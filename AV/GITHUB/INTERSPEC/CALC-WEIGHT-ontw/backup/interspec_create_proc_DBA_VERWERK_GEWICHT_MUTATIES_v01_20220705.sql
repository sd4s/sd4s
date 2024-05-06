--Create procedure om dagelijks / periodiek te draaien en alle mutaties van na het runnen van de vorige keer
--gaan verwerken in de tabel DBA_WEIGHT_COMPONENT_PART 
--
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***************  procedure   DBA_VERWERK_GEWICHT_MUTATIES                                                      ********
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
SET SERVEROUTPUT ON
declare
l_startdatum             varchar2(30);  
begin
  l_startdatum :=   to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss');
  dbms_output.put_line('start AANROEP-DBA_VERWERK_GEWICHT_MUTATIES: '||l_startdatum);
  DBA_VERWERK_GEWICHT_MUTATIES (p_str_verwerk_startdatum=>l_startdatum);
  dbms_output.put_line('eind AANROEP-DBA_VERWERK_GEWICHT_MUTATIES');
END;
/ 



create or replace procedure DBA_VERWERK_GEWICHT_MUTATIES (p_str_verwerk_startdatum  varchar2 default null )
DETERMINISTIC
AS
--AANROEP-procedure om voor alle TYRES/COMPONENTEN waarvoor nieuwe REVISION gemaakt is, 
--vervolgens voor deze EN alle aan deze component gerelateerde bovenliggende BOM-HEADERS/BANDEN 
--de gewichten door te rekenen, en te verwerken in de tabel DBA_WEIGHT_COMPONENT_PART.
--LET OP: In INTERSPEC kan namelijk een component gewijzigd worden ZONDER dat BOM-HEADER/BAND een
--        nieuwe REVISION krijgt.
--Dit is de basis voor WEIGHT-CALCULATION voor ieder BOM-HEADER/COMPONENT tbv SAP-INTERFACE.
--Het gewicht wordt hier berekend uitgaande van 1 x EENHEID van een COMPONENT-PART. 
--Dat is anders dan de gewichten die berekend worden vanuit een BOM_HEADER_GEWICHT die vanuit een band 
--van alle onderliggende componenten de gewichten berekend. 
--
--Let op: SELECTIE ZIT VOORLOPIG NOG ALLEEN OP EF%-BANDEN VAN TYPE A_PCR !!!
--        DIT WORDT GESTUURD DOOR VULLING VAN DE VIEW: AV_BHR_BOM_TYRE_PART_NO !!!
--
--Selectie-criteria: Selectie vind plaats op view AV_BHR_BOM_HEADER_PART_NO + SPECIFICATION_HEADER.ISSUED_DATE
--                   OBV: - part-no met status-type='CURRENT' 
--                   IN COMBINATIE MET: inhoud van HULPtabel DBA_WEIGHT_COMPONENT_PART en max(TECH_CALCULATION_DATE) 
--                   Alle componenten/tyres en status=CURRENT met een ISSUED-DATE hoger dan max(TECH_CALCULATION_DATE) 
--                   komen hiervoor in aanmerking
--                   Alle mutaties t/m GISTEREN (LEES: TRUNC(SYSDATE)) worden in 1x verwerkt...Dus niet lopende wijzigingen van vandaag!!
--
--Parameters:  P_VERWERK_STARTDATUM  = Indien leeg, dan wordt obv max(tech_calculation_date) de STARTDATUM bepaald !!
--                                     Is ook handmatig mee te geven, maar dan wel een datum in het verleden 
--                                     en met date-format="dd-mm-yyyy hh24:mi:ss"
--                                     Bijv. "01-07-2022 13:00:00".
--                                                 
--dependencies: FUNCTIE DBA_BEPAAL_BOM_PART_GEWICHT: functie om per BOM-HEADER alle onderliggende component-parts te bepalen.
--              FUNCTIE DBA_BEPAAL_BOM_HEADER_GEWICHT: functie om per BOM-HEADER uit functie DBA_BEPAAL_BOM_PART_GEWICHT 
--                                                     het gewicht te berekenen obv onderliggende component-parts.
--                                                     Dit vanuit 1xEenheid van bom-header.
--
--OUTPUT: Via de procedure DBA_BEPAAL_COMP_PART_GEWICHT wordt het gewicht per COMPONENT-PART berekend en in tabel DBA_WEIGHT_COMPONENT_PART gezet!!!
--
--SELECT COUNT(*) FROM DBA_WEIGHT_COMPONENT_PART;
--TRUNCATE table DBA_WEIGHT_COMPONENT_PART;
--
--Aanroep-voorbeelden:
--1) SET SERVEROUTPUT ON
--   exec DBA_VERWERK_GEWICHT_MUTATIES(to_char(sysdate-1,'dd-mm-yyyy hh24:mi:ss'));      --haal alle part-no van ENSCHEDE van A_PCR op
--
l_str_startdatum_van       varchar2(100);
l_str_startdatum_tm        varchar2(100);
--
--selecteer alle bom-headers met een nieuwe CURRENT-REVISION:
--
cursor c_nw_part_revision (pl_str_startdatum_van varchar2
                          ,pl_str_startdatum_tm  varchar2 )
is
SELECT sh.PART_NO
,      sh.REVISION
,      sh.FRAME_ID
,      sh.STATUS
,      s.sort_desc
,      sh.DESCRIPTION
,      sh.ISSUED_DATE   
,      sh.STATUS_CHANGE_DATE
,      sh.OBSOLESCENCE_DATE
FROM STATUS                s
,    SPECIFICATION_HEADER  sh
WHERE sh.issued_date between to_date(pl_str_startdatum_van,'dd-mm-yyyy hh24:mi:ss')  and  to_date(pl_str_startdatum_tm,'dd-mm-yyyy hh24:mi:ss')   --between trunc(sysdate)-1 and trunc(sysdate)
--alle wijzigingen t/m gisteren gaan we verwerken... 
and   s.status      = sh.status
and   s.status_type = 'CURRENT' 
;
--
--selecteer alle BOM-TYRES waarvan nw-part-revision onderdeel van uitmaakt: 
--
cursor c_part_tyre (p_part_no varchar2)
is
with sel_bom_item as
(select LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      b.part_no
,      b.revision
,      b.alternative
,      b.component_part
FROM   ( SELECT bi.part_no
         ,      bi.revision
		 ,      bi.alternative
		 ,      bi.component_part
		 from  bom_header     bh
         ,     bom_item       bi
		 WHERE bh.part_no      = bi.part_no
		 and   bh.revision     = bi.revision
		 and   bh.preferred    = 1
		 and   bh.alternative  = bi.alternative
		 and   bh.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
       ) b
START WITH b.part_no =  p_part_no      --'EB_12005AR66S'           --'EG_BH168015CLS-G'    --'EV_BH165/80R15CLS'
CONNECT BY NOCYCLE PRIOR b.part_no = b.component_part
order siblings by part_no						 
)
(select distinct boh.part_no   
 ,       boh.revision
 ,       boh.alternative
 ,       boh.preferred  
 from   sel_bom_item   sbi
 ,      bom_header     boh 
 where  sbi.part_no  = boh.part_no
 and    sbi.revision = boh.revision
 and    boh.preferred  = 1
 --we zoeken alleen tyres/headers die niet zelf als component voorkomen
 and    boh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = boh.part_no)           
 and    boh.revision = (select max(sh.revision) 
                        from status               s  
				        ,    specification_header sh
				        where  sh.part_no    = boh.part_no  
                        and    sh.status     = s.status				 
                        and    s.status_type  = 'CURRENT'
                       )
 and    boh.part_no in (select av.PART_NO     
                        from av_bhr_bom_tyre_part_no   av
						WHERE  av.part_no = boh.part_no
					   )
);
--
l_startdatum  date;
l_einddatum   date;
l_duur_minuut number;
l_teller      number;
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  dbms_output.put_line('start DBA_VERWERK_GEWICHT_MUTATIES met startdatum: '||p_str_verwerk_startdatum );
  --init
  l_teller     := 0;
  l_startdatum := sysdate;
  --
  if p_str_verwerk_startdatum is null
  then
    begin   
	  --van. max-calc-datum uit tabel 
      select to_char( max(dwc.tech_calculation_date), 'dd-mm-yyyy hh24:mi:ss' )
      into l_str_startdatum_van
      from dba_weight_component_part dwc
      ;
	exception
	  when others 
	  then l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
	end;
  else
    l_str_startdatum_van := p_str_verwerk_startdatum;  
  end if;
  --tm. eind ALTIJD tm. EINDE van de vorige WERKELIJKE dag tov SYSDATE:
  l_str_startdatum_tm := to_char( trunc(sysdate), 'dd-mm-yyyy hh24:mi:ss' );
  --
  dbms_output.put_line('verwerkingperiode van: '||l_str_startdatum_van||' t/m '||l_str_startdatum_tm);
  --START VERWERKING...
  for r_nw_part_revision in c_nw_part_revision (l_str_startdatum_van, l_str_startdatum_tm)
  loop
    dbms_output.put_line('r_nw_part: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' frame: '||r_nw_part_revision.FRAME_ID );
	--
	for r_part_tyre in c_part_tyre ( r_nw_part_revision.part_no)
	loop
      l_teller := l_teller + 1;
      dbms_output.put_line('TYRE-'||l_teller||': '||r_part_tyre.PART_NO||':'||r_part_tyre.REVISION||' alt: '||r_part_tyre.ALTERNATIVE );
	  --
	  --hier vullen van internal-table...
	  --
	end loop;
  end loop;
  -- 
  --loop door VARRAY om GEWICHTEN TE BEREKENEN...
  for i in 1..varray.count
  loop
    --aanroep procedure DBA_BEPAAL_COMP_PART_GEWICHT
	dba_bepaal_comp_part_gewicht(p_header_part_no=>r_tyre_part_no.part_no
	                            ,p_header_revision=>r_tyre_part_no.revision
	                            ,p_alternative=>r_tyre_part_no.alternative
								,p_show_incl_items_jn=>'N' );    
    --   
	dbms_output.put_line('header-part-no: '||r_tyre_part_no.part_no||' revision: '||r_tyre_part_no.revision||' alternative: '||r_tyre_part_no.alternative||' COMPLETED...');
  end loop;
  --
  l_einddatum := sysdate;
  l_duur_minuut := ( l_einddatum - l_startdatum ) * 24 * 60;
  dbms_output.put_line('Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: '||l_teller||' duur(min): '||l_duur_minuut);
  dbms_output.put_line('SELECT * FROM DBA_WEIGHT_COMPONENT_PART where  tech_calculation_date > trunc(sysdate)-1 order by id;');
  --
END;
/

show err
