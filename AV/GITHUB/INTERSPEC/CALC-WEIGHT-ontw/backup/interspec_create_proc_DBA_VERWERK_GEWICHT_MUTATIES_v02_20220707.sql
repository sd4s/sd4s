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
--CONTROLE OP AANTALLEN GEWIJZIGDE COMPONENT-PARTS
SELECT sh.PART_NO
,      sh.REVISION
,      sh.FRAME_ID
,      sh.STATUS
,      s.sort_desc
,      sh.DESCRIPTION
,      sh.ISSUED_DATE   
,      sh.STATUS_CHANGE_DATE
,      sh.OBSOLESCENCE_DATE
,      bh.alternative
FROM STATUS                s
,    SPECIFICATION_HEADER  sh
,    BOM_HEADER            bh
WHERE sh.issued_date between to_date('01-07-2022 00:00:00','dd-mm-yyyy hh24:mi:ss')  and  to_date('02-07-2022 00:00:00','dd-mm-yyyy hh24:mi:ss')   --between trunc(sysdate)-1 and trunc(sysdate)
--alle wijzigingen t/m gisteren gaan we verwerken... 
and   s.status      = sh.status
and   s.status_type = 'CURRENT' 
and   sh.part_no like 'E%'
and   bh.part_no  = sh.part_no
and   bh.revision = sh.revision
and   bh.preferred = 1
order by sh.part_no
;
--

SET SERVEROUTPUT ON
declare
l_startdatum             varchar2(30)  := '01-07-2022 00:00:00';
begin
  --l_startdatum :=   to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss');
  dbms_output.put_line('start AANROEP-DBA_VERWERK_GEWICHT_MUTATIES: '||l_startdatum);
  DBA_VERWERK_GEWICHT_MUTATIES (p_str_verwerk_startdatum=>l_startdatum);
  dbms_output.put_line('eind AANROEP-DBA_VERWERK_GEWICHT_MUTATIES');
END;
/ 
--CONTROLE OP SAP-PART-NO-VIEW:
--select * from av_bhr_bom_tyre_part_no   av  WHERE  av.part_no like 'XEM%'
						


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
l_part_tyre_ind            number;     --controle part-no wel/niet tyre
l_teller                   number;     --teller aantal tyres in array (let op: zitten nog dubbele tyres in !!)
--
type          PartType is record  (part_no      varchar2(100)
                                  ,revision     number(20)
                                  ,alternative  number(1)  );
Part          PartType;
type          TyreParttable  is table of Part%type;
TyrePartList  TyreParttable := TyreParttable();
--
l_tech_calculation_date  date;
l_startdatum             date;
l_einddatum              date;
l_duur_minuut            number;
--
l_sap_part_no           VARCHAR2(18);
l_sap_frame_id          varchar2(18);
l_part_eenheid_kg_old   number;
l_part_eenheid_kg_new   number;
l_remark                varchar2(1000);
--
--selecteer alle bom-headers met een nieuwe CURRENT-REVISION:
--Hier selecteren we alleen part/revision/alternative bij een preferred=1
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
,      bh.alternative
FROM STATUS                s
,    SPECIFICATION_HEADER  sh
,    BOM_HEADER            bh
WHERE sh.issued_date between to_date(pl_str_startdatum_van,'dd-mm-yyyy hh24:mi:ss')  and  to_date(pl_str_startdatum_tm,'dd-mm-yyyy hh24:mi:ss')   --between trunc(sysdate)-1 and trunc(sysdate)
--alle wijzigingen t/m gisteren gaan we verwerken... 
--and   bh.part_no like 'EM_700'  --'ED_700-5-11' 
and   s.status      = sh.status
and   s.status_type = 'CURRENT' 
and   sh.part_no like 'E%'
and   bh.part_no  = sh.part_no
and   bh.revision = sh.revision
and   bh.preferred = 1
order by sh.part_no
;
--
--selecteer alle BOM-TYRES waarvan nw-part-revision onderdeel van uitmaakt: 
--
cursor c_part_tyre (p_part_no varchar2)
is
select DISTINCT bi2.part_no     mainpart
,      bi2.revision             mainrevision
,      bi2.plant                mainplant
,      bi2.alternative          mainalternative
,      bi2.frame_id             mainframeid
from ( SELECT    bi.part_no
     ,      bi.revision
     ,      bi.plant
     ,      bi.alternative
     ,      bi.component_part
     ,      sh.frame_id
     FROM bom_header           bh
     --,    status               s
     ,    specification_header sh
     ,    bom_item             bi	 
     WHERE bh.part_no      = bi.part_no
     and   bh.revision     = bi.revision
     and   bh.preferred    = 1
     and   bh.alternative  = bi.alternative
     and   bi.revision   = (select sh1.revision from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT'))
     and   bi.part_no     = sh.part_no
     and   bi.revision    = sh.revision
     --and   sh.status      = s.status	
     --and   s.status_type  = 'CURRENT' 
     START WITH bi.part_no = p_part_no  --'ED_700-5-11'
     CONNECT BY NOCYCLE prior bi.part_no = bi.component_part 
                          and bi.revision = (select sh1.revision from status s1, specification_header sh1 where sh1.part_no = bi.component_part and sh1.status = s1.status and s1.status_type in ('CURRENT'))
     order siblings by bi.part_no
    ) bi2
where NOT EXISTS (select ''  from bom_item bi3 where bi3.component_part = bi2.part_no )  	
--and   bi2.part_no like 'EF%'
--and   bi2.frame_id in ('A_PCR')
--AND   bi2.part_no in (SELECT DISTINCT MAINPART FROM DBA_WEIGHT_COMPONENT_PART)
and    bi2.part_no in (--Hierin zit FRAME-ID en PLANT (EF/GT) en Finished-product=EF
                       select av.PART_NO     
                       from av_bhr_bom_tyre_part_no   av
                       WHERE  av.part_no = bi2.part_no
                     )
;
--
procedure p_add_part_not_exists (p_part_no      varchar2
                                ,p_revision     number 
                                ,p_alternative  number)
IS
--We nemen bij AANWEZIGHEID-CONTROLE geen ALTERNATIVE-mee !!. We nemen in dit stadium van het proces
--de hele band mee, en pas later bij het berekenen van de TYRE-weights wordt er pas de juiste ALTERNATIVE
--geselecteerd voor het berekenen van het gewicht...
l_aantal       number(20);    --aantal voorkomens van part-no in ARRAY
l_array_teller number(20);    --totaal aantal voorkomens in ARRAY
begin
  l_aantal       := 0;
  l_array_teller := TyrePartList.count;  
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  --hier vullen van internal-table...  
  if l_array_teller = 0
  then 
    l_aantal := 0;
  else
    for i in   TyrePartList.first..TyrePartList.last
    loop
      if  TyrePartList(i).PART_NO  = p_part_no  
      and TyrePartList(i).REVISION = p_revision
      then
        l_aantal := l_aantal+1;
      end if;
    end loop;
    --
  end if;
  --
  if nvl(l_aantal,0) = 0
  then
    --interne-tabel aanvullen met nieuw part-no  
    begin
      if TyrePartList.exists(l_array_teller+1)
      then null;
      else TyrePartList.extend;
      end if;
    exception
      when Subscript_beyond_count
      then TyrePartList.extend;
    end;
    l_array_teller := l_array_teller + 1;
	--
    TyrePartList(l_array_teller).PART_NO     := p_part_no;
    TyrePartList(l_array_teller).REVISION    := p_revision;
    TyrePartList(l_array_teller).ALTERNATIVE := p_alternative;
	--
	dbms_output.put_line('RESULT part: '||p_part_no||' revision: '||p_revision||' array-teller: '||l_array_teller);
  else
    --part-no komt al in array voor, hoeven verder niets te doen...
	null;
  end if;
exception
  when no_data_found
  then null;  
  when others
  then dbms_output.put_line('ALG-EXCP-ADD-PART-ERROR part: '||p_part_no||' revision: '||p_revision||' array-teller: '||l_array_teller||'-'||SQLERRM);
end p_add_part_not_exists; 
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  dbms_output.put_line('start DBA_VERWERK_GEWICHT_MUTATIES met startdatum: '||p_str_verwerk_startdatum );
  --init
  l_teller                := 0;
  l_startdatum            := sysdate;
  l_tech_calculation_date := sysdate;
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
  --**************************************************************************************************
  --**************************************************************************************************
  --START VERWERKING...
  --**************************************************************************************************
  --**************************************************************************************************
  --SELECTEER ALLE NIEUWE CURRENT-HEADER-REVISIONS DIE IN TIJDSINTERVAL ZIJN AANGEMAAKT...
  for r_nw_part_revision in c_nw_part_revision (l_str_startdatum_van, l_str_startdatum_tm)
  loop
    l_part_tyre_ind := 0;
    dbms_output.put_line('r_nw_part: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' issued-date: '||r_nw_part_revision.issued_date||' frame: '||r_nw_part_revision.FRAME_ID );
	--Check of het al een TYRE is...
	--In dat geval kunnen we tyre al direct in ARRAY opnemen.
	begin
	  select count(*)
	  into   l_part_tyre_ind
      from bom_header bh
      where bh.part_no = r_nw_part_revision.part_no
      --and   bh.alternative = 1
      and   bh.part_no NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = bh.part_no)
      ;
	exception
	  when others then l_part_tyre_ind := 0;
	end;
	--Afhankelijk van component/tyre vullen we ARRAY
    if nvl(l_part_tyre_ind,0) > 0
	then
	  --part is al tyre, direct opvoeren (indien juist FRAME-ID):
      l_teller := l_teller + 1;
      dbms_output.put_line('PART=TYRE-'||l_teller||': '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE );
	  --
	  --eerst controle op FRAME-ID...(deze zit nl. niet in de R_NW_PART_REVISION-cursor...
	  begin
	    select av.PART_NO 
        ,      av.FRAME_ID		
        into l_sap_part_no
		,    l_sap_frame_id
        from av_bhr_bom_tyre_part_no   av
        WHERE  av.part_no = r_nw_part_revision.part_no
		;
        --hier direct vullen van internal-table...
        p_add_part_not_exists (p_part_no=>r_nw_part_revision.PART_NO 
                              ,p_revision=>r_nw_part_revision.REVISION 
                              ,p_alternative=>r_nw_part_revision.ALTERNATIVE); 
	  exception
	    when others 
		then 
          --Het is niet het juiste FRAME-ID... Wordt niet meegenomen in de gewichtberekening
          dbms_output.put_line('FRAME-ID NOT CORRECT, SKIP PART=TYRE: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE||' FRAME: '||l_sap_frame_ID );
	  end;
	else
      --BOM-HEADER = COMPONENT-PART: 
	  --we gaan nu eerst gewicht voor COMPONENT-PART berekenen.
	  --Indien NIEUWE-REVISION geen gewichtswijziging inhoudt dan hoeven we de hele TYRE ook niet opnieuw te gaan berekenen 
	  --Deze behouden dan hun reeds berekende gewicht in DBA_WEIGHT_COMPONENT_PART, hun REVISION is dan nl. OOK NIET gewijzigd !!!
	  /*
      begin
        l_part_eenheid_kg_old := 0;
	    --haal huidige gewicht op uit DBA_WEIGHT_COMPONENT_PART
        --LET OP: het kan zijn dat COMPONENT-PART nog niet bestaat !!!!
        select distinct comp_part_eenheid_kg
        into  l_part_eenheid_kg_old
        from dba_weight_component_part dwc
        where dwc.component_part_no  = r_nw_part_revision.part_no
        and   dwc.component_revision <= r_nw_part_revision.revision
        and   dwc.alternative        = r_nw_part_revision.alternative
        and   dwc.tech_calculation_date = (select max(dwc2.tech_calculation_date) from dba_weight_component_part dwc2 where dwc2.component_part_no = dwc.component_part_no)
        and   dwc.component_issueddate  = (select max(dwc2.component_issueddate) from dba_weight_component_part dwc2 where dwc2.component_part_no = dwc.component_part_no)
        ;
      exception
	    when others
        then --component komt nog niet voor...
             l_part_eenheid_kg_old := 0;
	  end;
      dbms_output.put_line('GEWICHT PART=header: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE||' OLD-gewicht: '||l_part_eenheid_kg_old );
      begin		
        dbms_output.put_line('voor bepaal comp-PART=HEADER: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE);
		--bereken alleen voor COMPONENT-PART het nieuwe gewicht mbv DBA_BEPAAL_HEADER_GEWICHT
		--Aanroep gelijk aan aanroep van DBA_BEPAAL_HEADER_GEWICHT vanuit procedure DBA_BEPAAL_COMP_PART_GEWICHT !!!
		l_part_eenheid_kg_new := 0;
        l_part_eenheid_kg_new := DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>r_nw_part_revision.part_no
		                                                      ,p_header_revision=>r_nw_part_revision.revision
                                                              ,p_show_incl_items_jn=>'N' 
                                                              );
      exception
	    when others
		then l_part_eenheid_kg_new := 0;
             dbms_output.put_line('ALG-EXCP-bepaal-HEADER-gewicht: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE);
	  end;
	  */
	  --BOM-HEADER = COMPONENT-PART, GA HIER EERST ALLE GERELATEERDE TYRES VOOR BIJ ZOEKEN
	  --OP TYRE ZIT UITEINDELIJK IN DE CURSOR INCLUSIEF EEN SAP-CONTROLE...
      for r_part_tyre in c_part_tyre ( r_nw_part_revision.part_no)
      loop
        l_teller := l_teller + 1;
        dbms_output.put_line('GERELATEERDE-TYRE-'||l_teller||': '||r_part_tyre.MAINPART||':'||r_part_tyre.MAINREVISION||' alt: '||r_part_tyre.MAINALTERNATIVE );
	    --
		/*
        --Indien gewicht oud = nieuw dan INSERTEN we alleen nieuwe COMPONENT-VERSION om INHOUD consistent te houden met BOM-ITEM !!!
        if  nvl(l_part_eenheid_kg_new,0) = nvl(l_part_eenheid_kg_new,0)
        then
          --We inserten DIRECT voor alle MAINTYRES/COMPONENT-PARTS een nieuw voorkomen (zelfde gewicht/nieuwe version)
		  --en nemen de TYRE NIET op in de tyre-ARRAY !!!
          begin
            l_remark  := 'COMPONENT-HEADER: DBA_VERWERK_GEWICHT_MUTATIES';		  
			--ID wordt vanuit DB-TRIGGER BEPAALD...
		    insert into DBA_WEIGHT_COMPONENT_PART 
			(         tech_calculation_date
			   ,      datum_verwerking
			   ,      mainpart
			   ,      mainrevision
			   ,      mainplant
			   ,      mainalternative
			   ,      mainframeid
			   ,      part_no
			   ,      revision
			   ,      plant
			   ,      alternative
			   ,      header_issueddate
			   ,      header_status
			   ,      component_part_no
			   ,      component_description
			   ,      component_revision
			   ,      component_alternative
			   ,      component_issueddate
			   ,      component_status
			   ,      characteristic_id
			   ,      functiecode
			   ,      path
			   ,      quantity_path
			   ,      bom_quantity_kg
			   ,      comp_part_eenheid_kg
			   ,      remark
			)
			select l_tech_calculation_date
			   ,   trunc(l_tech_calculation_date)
			   ,      mainpart
			   ,      mainrevision
			   ,      mainplant
			   ,      mainalternative
			   ,      mainframeid
			   ,      part_no
			   ,      revision
			   ,      plant
			   ,      alternative
			   ,      header_issueddate
			   ,      header_status
			   ,      component_part_no
			   ,      component_description
			   ,   r_nw_part_revision.revision
			   ,   r_nw_part_revision.alternative
			   ,   r_nw_part_revision.issued_date
			   ,   r_nw_part_revision.sort_desc
			   ,      characteristic_id     --nemen we toch 1:1 over, ondanks feit dat deze gewijzigd kunnen zijn.
			   ,      functiecode           --nemen we toch 1:1 over, ondanks feit dat deze gewijzigd kunnen zijn.
			   ,      path
			   ,      quantity_path
			   ,      bom_quantity_kg
			   ,      comp_part_eenheid_kg   --nemen we toch 1:1 over. kan niet gewijzigd zijn, zie controle hiervoor...
			   ,   l_remark
			   from dba_weight_component_part  dwc
			   where dwc.mainpart              = r_part_tyre.mainpart
			   and   dwc.mainrevision          = r_part_tyre.mainrevision
			   and   dwc.mainplant             = r_part_tyre.mainplant
			   and   dwc.mainalternative       = r_part_tyre.mainalternative
			   and   dwc.component_part_no     = r_nw_part_revision.part_no
			   and   dwc.component_revision    < r_nw_part_revision.revision
			   and   dwc.component_alternative = r_nw_part_revision.alternative
 		       and   dwc.tech_calculation_date = (select max(dwc2.tech_calculation_date) from dba_weight_component_part dwc2 where dwc2.component_part_no = dwc.component_part_no)
		       and   dwc.component_issueddate  = (select max(dwc2.component_issueddate) from dba_weight_component_part dwc2 where dwc2.component_part_no = dwc.component_part_no)
			   and   rownum = 1
			   ;
          exception
		    when others 
			then dbms_output.put_line('ALG-EXCP-COMP-QUERY SKIP COMP-PART: '||r_nw_part_revision.PART_NO||':'||r_nw_part_revision.REVISION||' alt: '||r_nw_part_revision.ALTERNATIVE||'-'||SQLERRM);
		  end;
		  --
        else
          --Indien gewicht afwijkt gaan we hierna voor alle gerelateerde tyres, ook voor ALLE COMPONENTS nieuwe gewichten berekenen...
	      --hier vullen van internal-table...
          p_add_part_not_exists (p_part_no=>r_part_tyre.mainpart
                                ,p_revision=>r_part_tyre.mainrevision
                                ,p_alternative=>r_part_tyre.mainalternative); 
        end if;  --l_part_eenheid_kg_new = l_part_eenheid_kg_new
		*/
		--
      end loop;   --r_part_tyre
      --
    end if; --part=tyre
	--
  end loop;  --r_nw_part_revision
  -- 
  DBMS_OUTPUT.PUT_LINE('NA loop gewijzigde parts, ROEP voor alle ARRAY-PARTS dba_bepaal_comp_part_gewicht aan...');
  --loop door VARRAY om GEWICHTEN TE BEREKENEN...
  --LET OP: het kan zijn dat een ALTERNATIVE=2 component is gewijzigd, de daarbij behorende finished-products/tyres worden geselecteerd
  --        maar de gewichtsberekening uiteindelijk toch maar alleen via de PREFERRED=1 (en dus meestal via ALTERNATIVE=1) verloopt !!!!
  --        De ALTERNATIVE=2-components zullen op deze manier dus (nog) NIET in de tabel DBA_WEIGHT_COMPONENT_PARTS worden geinsert.
  if TyrePartList.count > 0
  then
    for i in TyrePartList.first..TyrePartList.last
    loop
      --aanroep procedure DBA_BEPAAL_COMP_PART_GEWICHT  
      dba_bepaal_comp_part_gewicht(p_header_part_no=>TyrePartList(i).part_no
                                  ,p_header_revision=>TyrePartList(i).revision
                                  ,p_alternative=>TyrePartList(i).alternative
                                  ,p_show_incl_items_jn=>'N' );    
      --   
      dbms_output.put_line('header-part-no: '||TyrePartList(i).part_no||' revision: '||TyrePartList(i).revision||' alternative: '||TyrePartList(i).alternative||' COMPLETED...');
    end loop;
  end if;
  --
  DBMS_OUTPUT.PUT_LINE('NA loop gewicht-berekening #parts: '||TyrePartList.count);
  --
  l_einddatum := sysdate;
  l_duur_minuut := ( l_einddatum - l_startdatum ) * 24 * 60;
  dbms_output.put_line('Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: '||l_teller||' duur(min): '||l_duur_minuut);
  dbms_output.put_line('SELECT * FROM DBA_WEIGHT_COMPONENT_PART where  tech_calculation_date > trunc(sysdate)-1 order by id;');
  --
END;
/

show err
