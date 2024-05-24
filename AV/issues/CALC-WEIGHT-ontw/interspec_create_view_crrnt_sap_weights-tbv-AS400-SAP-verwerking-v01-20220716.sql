--**********************************************************************************************************
-- CREATE VIEWS: 	1.DBA_VW_CRRNT_SAP_WEIGHT
--                  2.DBA_VW_CRRNT_MAINPART_PARTS
--
--**********************************************************************************************************
--**********************************************************************************************************
--1.view: DBA_VW_CRRNT_SAP_WEIGHT: overzicht van ALLE berekende WEIGHTS TYRES/COMPONENTS tbv SAP !!!
--uitvragen obv MAINPART BIJV: where part_NO='XGF_1557013QT5NTRW'
--**********************************************************************************************************
--**********************************************************************************************************
CREATE or REPLACE view DBA_VW_CRRNT_SAP_WEIGHT
(COMP_TYPE
,KMGKOD
,ARTKOD
,PART_NO
,REVISION
,ALTERNATIVE
,ARWGHT
,ISSUEDDATE
,STATUS_DESC
)
as
select 'TYRE'   COMP_TYPE
,      decode(substr(part_no,1,1),'E','E1' ,substr(part_no,1,2))  KMGKOD_TYRE
,      substr(mainpart,instr(mainpart,'_')+1)                     ARTKOD_TYRE
,      dwc.part_no
,      dwc.revision
,      dwc.alternative
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
UNION 
select 'COMPONENT'   COMP_TYPE
,      decode(substr(component_part_no,1,1),'E','E1' ,substr(component_part_no,1,2))  KMGKOD_COMP
,      substr(component_part_no,instr(component_part_no,'_')+1)                       ARTKOD_COMP
,      dwc.component_part_no
,      dwc.component_revision
,      dwc.alternative
,      dwc.COMP_PART_EENHEID_KG
,      to_char(dwc.component_issueddate,'dd-mm-yyyy hh24:mi:ss')    COMPONENTISSUEDDATE
,      dwc.component_status                                         COMPONENTSTATUSDESC
from dba_weight_component_part dwc
WHERE nvl(dwc.COMP_PART_EENHEID_KG,0) > 0
--and   dwc.COMPONENT_STATUS in (select s.sort_desc from status s where status_type='CURRENT')    
AND   (    dwc.COMPONENT_ISSUEDDATE is not null
      or   ( dwc.COMPONENT_ISSUEDDATE is null and dwc.COMPONENT_STATUS is null)
	  )
AND   dwc.COMPONENT_REVISION = (SELECT max(dwc2.component_revision ) 
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

--**********************************************************************************************************
--**********************************************************************************************************
--2.view: DBA_VW_CRRNT_MAINPART_PARTS: overzicht van gehele TYRE-BOM met berekende WEIGHTS tbv SAP !!!
--uitvragen obv MAINPART BIJV: where mainpart='XGF_1557013QT5NTRW'
--**********************************************************************************************************
--**********************************************************************************************************
CREATE or REPLACE view DBA_VW_CRRNT_MAINPART_PARTS
(COMP_TYPE
,ID
,MAINPART
,MAINREVISION
,TECH_CALC_DATE
,KMGKOD
,ARTKOD
,PART_NO
,REVISION
,ALTERNATIVE
,WEIGHT_UNIT_KG
,ISSUEDDATE
,STATUS_DESC
)
as
select 'TYRE'   COMP_TYPE
,      dwc.id
,      dwc.MAINPART
,      dwc.MAINREVISION
,      to_char(dwc.tech_calculation_date,'dd-mm-yyyy hh24:mi:ss') TECH_CALC_DATE
,      decode(substr(part_no,1,1),'E','E1' ,substr(part_no,1,2))  KMGKOD_TYRE
,      substr(mainpart,instr(mainpart,'_')+1)                     ARTKOD_TYRE
,      dwc.part_no
,      dwc.revision
,      dwc.alternative
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
AND   dwc.MAINREVISION = (SELECT max(dwc2.mainrevision) 
                          FROM dba_weight_component_part dwc2 
                          WHERE dwc2.mainpart = dwc.mainpart
                         )
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
UNION 
select 'COMPONENT'   COMP_TYPE
,      dwc.id
,      dwc.MAINPART
,      dwc.MAINREVISION
,      to_char(dwc.tech_calculation_date,'dd-mm-yyyy hh24:mi:ss') TECH_CALC_DATE
,      decode(substr(component_part_no,1,1),'E','E1' ,substr(component_part_no,1,2))  KMGKOD_COMP
,      substr(component_part_no,instr(component_part_no,'_')+1)                       ARTKOD_COMP
,      dwc.component_part_no
,      dwc.component_revision
,      dwc.alternative
,      dwc.COMP_PART_EENHEID_KG
,      to_char(dwc.component_issueddate,'dd-mm-yyyy hh24:mi:ss')    COMPONENTISSUEDDATE
,      dwc.component_status                                         COMPONENTSTATUSDESC
from dba_weight_component_part dwc
WHERE nvl(dwc.COMP_PART_EENHEID_KG,0) > 0
--and   dwc.COMPONENT_STATUS in (select s.sort_desc from status s where status_type='CURRENT')    
AND   (    dwc.COMPONENT_ISSUEDDATE is not null
      or   ( dwc.COMPONENT_ISSUEDDATE is null and dwc.COMPONENT_STATUS is null)
	  )
AND   dwc.MAINREVISION = (SELECT max(dwc2.mainrevision) 
                          FROM dba_weight_component_part dwc2 
                          WHERE dwc2.mainpart = dwc.mainpart
                         )
AND   dwc.COMPONENT_REVISION = (SELECT max(dwc2.component_revision ) 
                                FROM dba_weight_component_part dwc2 
								WHERE dwc2.component_part_no = dwc.component_part_no 
								and   dwc2.mainpart          = dwc.mainpart
								and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
							   )
AND   dwc.TECH_CALCULATION_DATE = (SELECT max(dwc2.tech_calculation_date) 
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.component_part_no = dwc.component_part_no
                      and   dwc2.mainpart          = dwc.mainpart
					  and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
				     )
;

--check
select * from dba_vw_crrnt_mainpart_parts where mainpart='XGF_2656018WPRXH_s';



--*******************************************************
--controle tellingen SAP-INTERFACE-VIEW:
--*******************************************************
select count(*), comp_type
from dba_vw_crrnt_sap_weight
group by comp_type;
/*
10821	COMPONENT
3862	TYRE
*/

--controle comp-type/kmgkod:
select comp_type,kmgkod,count(*)
from dba_vw_crrnt_sap_weight
group by comp_type,kmgkod
order by comp_type,kmgkod
;
/*
COMPONENT	E1	2052
COMPONENT	GB	181
COMPONENT	GC	27
COMPONENT	GD	8
COMPONENT	GE	8
COMPONENT	GG	453
COMPONENT	GI	3
COMPONENT	GL	76
COMPONENT	GM	524
COMPONENT	GR	580
COMPONENT	GS	80
COMPONENT	GT	266
COMPONENT	GV	615
COMPONENT	GX	7
COMPONENT	XG	5941
--
TYRE		E1	396
TYRE		GF	607
TYRE		XG	2859
*/
--Ik zit met een paar verschillen... Ik raad een paar componenten kwijt in deze QUERY...ondanks feit dat ik UNION gebruik (en dus DISTINCT...)
SELECT distinct component_part_no
from dba_weight_component_part dwc
WHERE decode(substr(dwc.component_part_no,1,1),'E','E1' ,substr(dwc.component_part_no,1,2)) = 'E1'
AND dwc.component_part_no not in (select sap.part_no from dba_vw_crrnt_sap_weight sap where comp_type='COMPONENT' and sap.part_no=dwc.component_part_no);
/*
EB_12855N66
EV_AT185/65R14A4W
EM_778
EM_478
EG_BY224517QT5X-G
EM_491
EG_AT186514SN5-G
EG_BV246517QT5X-G
EV_AV205/55R16SP5
EG_AV205516SP5X-G
EV_BY225/45R17QT5X
EV_BH235/70R16SP5
EV_BV245/65R17QT5X
EV_AH205/55R16SN5X
EG_AH205516SN5X-G
EM_740
EV_BV215/50R18WPR
EG_BV215018WPR-G
EG_BH237016SP5-G
EG_AT186014SN5-G
EV_AT185/60R14A4W
*/

--Bij deze COMPONENTS is het COMPONENT_ISSUEDDATE + COMPONENT_STATUS niet gevuld !!! Hierdoor worden ze niet meegenomen in de CRRNT-SAP-VIEW !!!
--Wat is hier dan weer de reden van... 
--Ik zie ook dat bij de aan dit COMPONENT gerelateerde PART-NO = ET_LV575 NIET ALLEEN de BOM-ITEM maar ook de BOM-HEADER allebei HISTORIC zijn...!!!
--

--NIEUWE POGING NA AANPASSING VAN DE VIEW..... door CONTROLE OP STATUS TE VERWIJDEREN, loopt nu alleen over REVISION + TECH-CALCULATION-DATE...
/*
COMPONENT	E1	2073
COMPONENT	GB	368
COMPONENT	GC	29
COMPONENT	GD	8
COMPONENT	GE	8
COMPONENT	GG	481
COMPONENT	GI	3
COMPONENT	GL	88         --hier mis ik er nog 2 (90 waren het)
COMPONENT	GM	527
COMPONENT	GR	603
COMPONENT	GS	92
COMPONENT	GT	270
COMPONENT	GV	619
COMPONENT	GX	10
COMPONENT	XG	6361      --hier mis ik er nog 6 (6367 waren het)
TYRE	E1	396
TYRE	GF	607
TYRE	XG	2859
*/

--Ik zit met een paar verschillen... Ik raad een paar componenten kwijt in deze QUERY...ondanks feit dat ik UNION gebruik (en dus DISTINCT...)
SELECT distinct component_part_no
from dba_weight_component_part dwc
WHERE decode(substr(dwc.component_part_no,1,1),'E','E1' ,substr(dwc.component_part_no,1,2)) = 'GL'
AND dwc.component_part_no not in (select sap.part_no from dba_vw_crrnt_sap_weight sap where comp_type='COMPONENT' and sap.part_no=dwc.component_part_no)
;
--GL_LFQ1330S70
--GL_LPQ1380S70
--ONDERZOEK: DEZE COMPONENTEN HEBBEN GEEN COP-PART-EENHEID-KG !!!!
--En KOMT NIET als BOM-HEADER in de BOM-ITEM tabel voor !!!! Heeft zelf een OBSOLETE-STATUS !!! hoe komt deze dan door de VERWERKING in de tabel DBA_WEIGHT_COMPONENT_PART ???
GL_LPQ1380S70	1	01-06-2018 11:19:49	10-11-2018 10:32:10	GYO	1	1	7	OBSOLETE	OBSOLETE	LPQ-380-S70	A_Innerliner v1	GM_K2004	36	36	0.09744	kg	903350	Technical layer compound
GL_LPQ1380S70	1	01-06-2018 11:19:49	10-11-2018 10:32:10	GYO	1	1	7	OBSOLETE	OBSOLETE	LPQ-380-S70	A_Innerliner v1	GM_L2002	39	39	0.62928	kg	903349	Innerliner compound

SELECT distinct component_part_no
from dba_weight_component_part dwc
WHERE decode(substr(dwc.component_part_no,1,1),'E','E1' ,substr(dwc.component_part_no,1,2)) = 'XG'
AND dwc.component_part_no not in (select sap.part_no from dba_vw_crrnt_sap_weight sap where comp_type='COMPONENT' and sap.part_no=dwc.component_part_no)
;
--XGV_2355518HTRNV
--XGV_G19C104B
--XGV_G20C024B
--XGV_G20C002A
--XGV_2355519HTRNH
--XGV_G20C054B
--ONDERZOEK: de XGV-componenten staan nog in DEV-status !!!
XGV_G19C104B	1			GYO	1	1	1	DEV	DEVELOPMENT	205/60R16 96V XL Quatrac 5	A_PCR_VULC v1	XGG_G19C104B	2	2	1	pcs	903332	Greentyre
XGV_G20C002A	1			GYO	1	1	1	DEV	DEVELOPMENT	225/45R18 95Y XL Quatrac PRO	A_PCR_VULC v1	XGG_G20C002A	1		1	pcs	903332	Greentyre
--
--CONCLUSIE: IS DUS WEL TERECHT DAT DEZE UITVALLEN !!!
--ACTIE:     WE KUNNEN NOG WEL EEN KEER UITZOEKEN WAAROM DEZE COMPONENTEN ALSNOG DOOR DE WEIGHT-VERWERKING HEEN KOMEN !!! 
--           DEZE ZOUDEN AL NIET VANUIT DE VERWERKING GESELECTEERD MOGEN WORDEN...







PROMPT einde script


