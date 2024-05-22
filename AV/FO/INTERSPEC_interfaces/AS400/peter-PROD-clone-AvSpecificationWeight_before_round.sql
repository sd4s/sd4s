--
--Veiligstellen van originele data voor evt FALLBACK als er iets misgaat
--
select count(*) from avspecification_weight;
--
create table peter_avspecification_weight AS SELECT * FROM AVSPECIFICATION_WEIGHT ;
--
select count(*) from avspecification_weight;
--33599
select count(*) from peter_avspecification_weight;
--0
COMMIT;
--

--
--Afronden van gewichten in AVSPECIFICATION_WEIGHT.WEIGHT
--TRIGGERS disablen:
alter table AVSPECIFICATION_WEIGHT DISABLE all triggers;

--controle vooraf:
select part_no, weight, round(weight,3) from avspecification_weight where length(weight)>7 and rownum<100;
--
--indien OK, dan updaten:
update AVSPECIFICATION_WEIGHT SET WEIGHT = round(weight,3);
--
--controle achteraf:
SELECT part_no, weight from avspecification_weight where length(weight)>7 and rownum<100;;
--
--indien alles ok, dan COMMIT:
commit;
--

--
--re-CREATE VIEW DBA_VW_CRRENT_SAP_WEIGHT 
--
CREATE or REPLACE view DBA_VW_CRRNT_SAP_WEIGHT
(COMP_TYPE
,PLANT
,PART_NO
,REVISION
,BASE_UOM
,STATUS_TYPE
,KMGKOD
,ARTKOD
,SAP_ARTICLE
,ARWGHT
,UOM
,DA_ARTICLE
,ALTERNATIVE
,ISSUEDDATE
)
as
select 'TYRE'   COMP_TYPE
,      dwc.mainplant 
,      dwc.mainpart
,      dwc.mainrevision
,      null                                                       HEADERBASEUOM           --TOEVOEGEN
,      s.status_type                                              HEADERSTATUSSORTDESC
,      decode(substr(dwc.mainpart,1,1),'E','E1' ,substr(dwc.mainpart,1,2))  KMGKOD_TYRE
,      substr(dwc.mainpart,instr(dwc.mainpart,'_')+1)                               ARTKOD_TYRE
,      DECODE(dwc.sap_article_code,null,(decode(substr(dwc.mainpart,1,1),'E','E1' ,substr(dwc.mainpart,1,2)) || substr(dwc.mainpart,instr(dwc.mainpart,'_')+1)  ), dwc.sap_article_code) SAP_ARTICLE_CODE
,      ROUND(nvl(dwc.comp_part_eenheid_kg,0),3)                  HEADERWEIGHT
,      null                                                      HEADERUOM
,      dwc.sap_da_article_code                                   SAP_DA_ARTICLE_CODE
,      dwc.alternative                                           HEADERALTERNATIVE
,      to_char(dwc.header_issueddate,'dd-mm-yyyy hh24:mi:ss')    HEADERISSUEDDATE
from  dba_weight_component_part dwc
,     status                    s
WHERE dwc.remark              like 'MAINPART-HEADER-TYRE:%'
and   dwc.component_part_no   is null        
and   dwc.component_revision  is null
and   dwc.HEADER_STATUS = s.sort_desc 
and   s.status_type = 'CURRENT'  --alleen de current-tyres
and   dwc.HEADER_ISSUEDDATE is not null
AND   dwc.REVISION = (SELECT /*+ INDEX(dwc2 IX_WEIGHT_MAINPART_COMP) */ max(dwc2.revision) 
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.mainpart = dwc.mainpart
					  and   dwc2.component_part_no is null
				     )
AND   upper(dwc.TECH_CALCULATION_DATE) = (SELECT /*+ INDEX(dwc3 IX_WEIGHT_MAINPART_COMP) */ max(dwc3.tech_calculation_date)    
                                          FROM dba_weight_component_part dwc3 
                                          WHERE dwc3.mainpart = dwc.mainpart
                                          and   dwc3.component_part_no is null
                                         )
UNION 
select 'COMPONENT'   COMP_TYPE
,      null          COMPONENTPLANT       --TOEVOEGEN
,      dwc.component_part_no
,      dwc.component_revision
,      null                                                         COMPONENTBASEUOM    --TOEVOEGEN
,      s.status_type                                                COMPONENTSTATUSDESC
,      decode(substr(dwc.component_part_no,1,1),'E','E1' ,substr(dwc.component_part_no,1,2))  KMGKOD_COMP
,      substr(dwc.component_part_no,instr(dwc.component_part_no,'_')+1)                       ARTKOD_COMP
,      DECODE(dwc.sap_article_code,null,(decode(substr(dwc.component_part_no,1,1),'E','E1' ,substr(dwc.component_part_no,1,2)) || substr(dwc.component_part_no,instr(dwc.component_part_no,'_')+1)  ), dwc.sap_article_code) SAP_ARTICLE_CODE
,      ROUND(dwc.COMP_PART_EENHEID_KG,3)                            COMPONENTWEIGHT
,      null                                                         COMPONENTUOM
,      dwc.sap_da_article_code                                      SAP_DA_ARTICLE_CODE
,      dwc.component_alternative                                    COMPONENTALTERNATIVE
,      to_char(dwc.component_issueddate,'dd-mm-yyyy hh24:mi:ss')    COMPONENTISSUEDDATE
from dba_weight_component_part dwc
,    status                    s
WHERE dwc.component_part_no is not null
and   dwc.component_status = s.sort_desc
and   nvl(dwc.COMP_PART_EENHEID_KG,0) > 0
AND   dwc.COMPONENT_REVISION = (SELECT /*+ INDEX(dwc2 IX_WEIGHT_COMP_PART_REVISION */  max(dwc2.component_revision ) 
                                FROM dba_weight_component_part dwc2 
								WHERE dwc2.component_part_no = dwc.component_part_no 
								and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
							   )
AND   upper(dwc.TECH_CALCULATION_DATE) = (SELECT /*+ INDEX(dwc3 IX_WEIGHT_COMP_PART_REVISION */  max(dwc3.tech_calculation_date) 
                                          FROM dba_weight_component_part dwc3
                                          WHERE dwc3.component_part_no = dwc.component_part_no
                                          and   dwc3.component_revision = dwc.component_revision
                                          and NVL(dwc3.COMP_PART_EENHEID_KG,0) > 0
                                         )
;





/*
--***************************************************************************************
--FALLBACK-SCENARIO, ALS WE TERUG MOETEN NAAR SITUATIE WAAROP DE CLONE GEMAAKT IS: PETER_AVSPECIFICATION_WEIGHT
--***************************************************************************************
--
alter table AVSPECIFICATION_WEIGHT disable all triggers;
--
truncate table AVSPECIFICATION_WEIGHT;
--
insert into AVSPECIFICATION_WEIGHT select * from PETER_AVSPECIFICATION_WEIGHT;
commit;
--
alter table AVSPECIFICATION_WEIGHT enable all triggers;
--
*/

purge recyclebin;







