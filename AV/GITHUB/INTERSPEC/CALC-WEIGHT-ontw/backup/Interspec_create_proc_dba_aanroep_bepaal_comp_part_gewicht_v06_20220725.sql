--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***************  procedure   DBA_AANROEP_COMP_PART_GEWICHT                                                     ********
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
SET SERVEROUTPUT ON
declare
l_component_part             varchar2(100) := 'EF_H195/60R16QT5C'; --'XGF_BU11S18N1';  --'EM_764';
begin
  dbms_output.put_line('start AANROEP-bepaal_comp_part_gewicht');
  DBA_AANROEP_COMP_PART_GEWICHT (p_header_part_no=>l_component_part
                                ,p_header_frame_id=>'A_PCR'
                                ,p_aantal=>'1' 
								,p_show_incl_items_jn=>'J' 
							    ,p_insert_weight_comp_jn=>'N');
  dbms_output.put_line('eind AANROEP-bepaal_comp_part_gewicht');
END;
/ 



create or replace procedure DBA_AANROEP_COMP_PART_GEWICHT (p_header_part_no        varchar2   default 'ALLE' 
                                                          ,p_header_frame_id       varchar2   default 'ALLE' 
													      ,p_aantal                number     default 1       
														  ,p_show_incl_items_jn    varchar2   default 'N' 
                                                          ,p_insert_weight_comp_jn varchar2   default 'J'			)
DETERMINISTIC
AS
--AANROEP-procedure voor een selectie van alle COMPONENT-PARTS onder een BOM-HEADER/TYRE. Voor alle COMPONENT-PARTS 
--wordt vervolgens APART de Eenheid-WEIGHT van deze COMPONENT-PART berekend. Dus LOOP in een LOOP !
--Dit is de basis voor WEIGHT-CALCULATION voor ieder BOM-HEADER/COMPONENT tbv SAP-INTERFACE.
--Het gewicht wordt hier berekend uitgaande van 1 x EENHEID van een COMPONENT-PART. 
--Dat is anders dan de gewichten die berekend worden vanuit een BOM_HEADER_GEWICHT die vanuit een band 
--van alle onderliggende componenten de gewichten berekend. 
--
--Selectie-criteria: Selectie vind plaats op view AV_BHR_BOM_HEADER_PART_NO.
--                   OBV: - part-no met status="CRRNT QR5"
--
--Parameters:  P_PART_NO = bom-item-header, Indien leeg, dan krijgt waarde='ALLE' !!!!
--                         part-no kan volledig part-no zijn (zonder %), een substring (met %) of waarde=ALLE bevatten.
--                         Kan ook als FILTER gebruikt worden, ook met SUBSTRING van een PART-NO:
--                                          bijv.  EF_H215/60R16SP5X (controleer alleen header-spec = EF_H215/60R16SP5X)
--                                                 EF%               (controleer alle header-specs beginnend met EF%) 
--                                                 GF%               (controleer alle header-specs beginnend met GF%) 
--                                                 EF_Y245%          (controleer alle header-specs beginnend met EF_Y245)
--
--             P_FRAME_ID = frame-id, Indien leeg, dan krijgt waarde='ALLE' !!!!
--                          frame-id mag alleen waarde ALLE/<null> of volledig frame-id bevatten
--                          kan ook als filter gebruikt worden maar ALLEEN MET VOLLEDIG FRAME-ID, NIET MET SUBSTRING !!!!
--                                          bijv.  A_PCR             (controleer alle header-specs van type frame=A_PCR)
--
--             P_AANTAL = aantal rows output. Indien leeg dan krijgt waarde=999999999
--                        Dit is alleen voor testdoeleinden, en werkt alleen bij gebruik van WILDCARDS/'ALLE' in partno of sap-no !!
--                        Als je 1 specifieke band met PARTNO/SAPNO opvraagt zal resultaat altijd maar 1 zijn.
--
--             P_SHOW_INCL_ITEMS_JN = J=Ja, N=Nee. Indien leeg dan krijgt waarde='N'
--                                    Indien "J" dan tonen van de componenten in de BOM-HEADER-STRUCTURE vanuit procedure DBA_BEPAAL_COMP_PART_GEWICHT !!!
--
--             P_INSERT_WEIGHT_COMP_JN = J=Ja, N=Nee. Indien leeg dan krijgt waarde='J'
--                                       J = INSERT van alle component-parts (resultaat van DBA_BEPAAL_BOM_HEADER_GEWICHT) in DBA_WEIGHT_COMPONENT_PART.
--                                           Indien aangeroepen vanuit DBA_AANROEP_BEPAAL_COMP_PART_GEWICHT dan ALTIJD INSERTEN van resultaten in VERWERKINGSTABEL !!!!!
--                                       N = geen output weggeschreven naar DBA_WEIGHT_COMPONENT_PART, alleen testing/logging !!! 
--                                           Indien direct aangeroepen voor test-doeleinden, dan resultaat niet altijd wegschrijven naar VERWERKING-TABEL !
--                                                 
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--                                              Indien aangeroepen vanuit deze aanroep-procedure wordt er ALLEEN totaal-gewicht bepaald.
--              FUNCTIE DBA_BEPAAL_BOM_HEADER_GEWICHT: functie om per BOM-HEADER het gewicht te berekenen obv onderliggende component-parts.
--                                                     Dit vanuit 1xEenheid van bom-header.
--
--OUTPUT: Via de procedure DBA_BEPAAL_COMP_PART_GEWICHT wordt het gewicht per COMPONENT-PART berekend en in tabel DBA_WEIGHT_COMPONENT_PART gezet!!!
--
--SELECT COUNT(*) FROM DBA_WEIGHT_COMPONENT_PART;
--TRUNCATE table DBA_WEIGHT_COMPONENT_PART;
--
--Aanroep-voorbeelden:
-- 1) exec DBA_AANROEP_COMP_PART_GEWICHT('EF_H215/60R16SP5X', null    , null);    --haal alleen specifiek part-no op
-- 2) exec DBA_AANROEP_COMP_PART_GEWICHT('EF_H215/60R16SP5X', null    , 1);       --haal alleen specifiek part-no op
-- 3) exec DBA_AANROEP_COMP_PART_GEWICHT('EF_H215/60R16SP5X', null    , 10);      --haal vanaf specifiek part-no ook de volgende 9 part-no op.
-- 4) exec DBA_AANROEP_COMP_PART_GEWICHT('ALLE'             , 'A_PCR' , null);    --haal alle part-no van A_PCR op
-- 5) exec DBA_AANROEP_COMP_PART_GEWICHT('EF_H165/80R15CLSM', 'A_PCR' , null);    --haal specifiek part-no op (met juiste frame-id)
-- 6) exec DBA_AANROEP_COMP_PART_GEWICHT('EF_H215/60R16SP5X', 'A_PCR' , 10);      --haal specifiek part-no op (met juiste frame-id) en volgende 9 part-no op.
-- 7) exec DBA_AANROEP_COMP_PART_GEWICHT('EF%'              , ''      , 10);      --haal eerste 10 part-no op.
-- 8) exec DBA_AANROEP_COMP_PART_GEWICHT('EF%'              , 'A_PCR' , 10);      --haal eerste 10 part-no beginnend met EF% binnen frame-id op.
-- 9) exec DBA_AANROEP_COMP_PART_GEWICHT('ALLE'             , 'A_PCR' , 10);      --haal de eerste 10 part-no van A_PCR op
--10) SET SERVEROUTPUT ON
--    exec DBA_AANROEP_COMP_PART_GEWICHT('ALLE'             , 'A_PCR' , 1000000);      --haal alle part-no van A_PCR op
--    exec DBA_AANROEP_COMP_PART_GEWICHT('EF%'              , 'A_PCR' , 1000000);      --haal alle part-no van ENSCHEDE van A_PCR op
--
--*************************************************************************************************************************
--REVISION DATE        WHO	DESCRIPTION
--      06 25-07-2022  PS   iNDIEN p-insert-WEIGHT-comp-jn = N dan helemaal geen controle/insert op SYNC-BESTURING-tabel uitvoeren...
--
--*************************************************************************************************************************
--  --
l_header_part_no           varchar2(100)   := p_header_part_no;
l_header_frame_id          varchar2(100)   := p_header_frame_id;
l_aantal                   number          := p_aantal;
l_show_incl_items_jn       varchar2(1)     := UPPER(p_show_incl_items_jn);
l_insert_weight_comp_jn    varchar2(1)     := UPPER(p_insert_weight_comp_jn);
--stuurinfo-attributen !!!
l_str_startdatum_van       varchar2(100);
l_str_startdatum_tm        varchar2(100);
l_mut_verwerking_aan_ind   VARCHAR2(1);  
l_mut_sync_periode_dagen   NUMBER;
l_sync_id                  NUMBER;
l_verwerkt_aantal_tyres    number;
--***********************************************
--AANROEP VIA VIEW: AV_BHR_BOM_TYRE_PART_NO !!!!
--***********************************************
cursor c_tyre_part_no (pl_header_part_no  varchar2 default '%'
                      ,pl_header_frame_id varchar2 default '%' 
                      ,pl_aantal          number   default 1   ) 
is
select PART_NO 
,      REVISION     
,      PLANT        
,      ALTERNATIVE  
,      BASE_QUANTITY
,      FRAME_ID     
,      SORT_DESC    
,      SAP_CODE     
from av_bhr_bom_tyre_part_no   bh
where (  (   (  instr(pl_header_part_no,'%') = 0
			 )
         and bh.part_no    = pl_header_part_no
         and bh.frame_id   like pl_header_frame_id||'%'
		 )
	  or (   instr(pl_header_part_no,'%') > 0
	     and bh.part_no    like pl_header_part_no||'%'   
	     and bh.frame_id   like pl_header_frame_id||'%'
		 )
      )
--vooralsnog alleen voor A_PCR (en zonder X-banden Enschede)	  
and substr(bh.part_no,1,2) not in ('XE')
--and frame_id = 'A_PCR'
and rownum < (pl_aantal+1)
order by bh.part_no
;
l_startdatum  date;
l_einddatum   date;
l_duur_minuut number;
l_teller      number;
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  dbms_output.put_line('Aanroep header-part-no: '||l_header_part_no||' frame: '||l_header_frame_id||' aantal: '||l_aantal);
  --init
  l_teller     := 0;
  l_startdatum := sysdate;
  l_aantal                 := nvl(l_aantal,999999999);
  l_show_incl_items_jn     := nvl(l_show_incl_items_jn,'N');
  l_insert_weight_comp_jn  := nvl(l_insert_weight_comp_jn,'J');
  --
  --part-no kan volledig part-no zijn (zonder %), een substring (met %) of waarde=ALLE bevatten.
  if upper(l_header_part_no) = 'ALLE'
  then l_header_part_no := '%';
  else l_header_part_no := upper(l_header_part_no);
  end if;
  --frame-id mag alleen waarde ALLE/<null> of volledig frame-id bevatten
  if nvl(upper(l_header_frame_id),'ALLE') = 'ALLE'
  then l_header_frame_id := '%';
  else l_header_frame_id := upper(l_header_frame_id);
  end if;
  --
  --Indien stuurtabel bijhouden dan PARAMETER=INSERT-WEIGHT-COMP-JN="J"
  if nvl(l_insert_weight_comp_jn,'N' ) = 'J' 
  then
    begin   
	  --van. max-calc-datum uit tabel 
      --select to_char( max(dwc.tech_calculation_date), 'dd-mm-yyyy hh24:mi:ss' ) into l_str_startdatum_van from dba_weight_component_part dwc ;
	  SELECT sbw_mut_verwerking_aan
	  ,      sbw_sync_periode_dagen
	  ,      to_char( sysdate, 'dd-mm-yyyy hh24:mi:ss' ) 
	  into l_mut_verwerking_aan_ind
	  ,    l_mut_sync_periode_dagen
	  ,    l_str_startdatum_van 
	  from DBA_SYNC_BESTURING_WEIGHT_SAP SBW 
	  WHERE sbw.id = (select max(sbw2.id) from DBA_SYNC_BESTURING_WEIGHT_SAP SBW2 ) 
	  AND   sbw.sbw_datum_verwerkt_tm is not null            --indien deze NULL is, dan loopt er nog een andere sessie, en starten we niet een nieuwe op!!!
	  ;
      dbms_output.put_line('UITVRAGEN-STUURTABEL verwerkingperiode van: '||l_str_startdatum_van);
    exception
	  when no_data_found
	  then rollback;
	       dbms_output.put_line('EXCP-NO-DATA-FOUND UITVRAGEN-STUURTABEL datum_verwerkt_tm is LEEG, PROCES STOPT ');
		   RAISE;
      when others 
      then rollback;
        --l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
        dbms_output.put_line('EXCP-UITVRAGEN-STUURTABEL verwerkingperiode van: '||l_str_startdatum_van||'-'||sqlerrm);
		RAISE;
    End;
    --
    --tm. eind ALTIJD tm. EINDE van de vorige WERKELIJKE dag tov SYSDATE:
    l_str_startdatum_tm := l_str_startdatum_van;    --to_char( (trunc(sysdate)-1/(24*60+60)), 'dd-mm-yyyy hh24:mi:ss' );
    --
    dbms_output.put_line('verwerkingperiode van: '||l_str_startdatum_van||' t/m '||l_str_startdatum_tm);
    --
    begin
	  --insert nieuwe verwerkingsregel in SYNC-BESTURING-tabel
	  --De velden VERWERKT-TM + AANTAL-TYRES vullen met UPDATE achteraf !!!!
	  select dba_weight_calc_seq.nextval into l_sync_id from dual;
	  --
	  insert into DBA_SYNC_BESTURING_WEIGHT_SAP
      ( ID
	  , SBW_MUT_VERWERKING_AAN 
      , SBW_SYNC_PERIODE_DAGEN
      , SBW_DATUM_VERWERKT_VANAF
      , SBW_DATUM_VERWERKT_TM
      , SBW_AANTAL_TYRES 
      , SBW_DATUM_ONTLADEN_SAP_TM
      )
      values (l_sync_id
	         ,l_mut_verwerking_aan_ind
	         ,l_mut_sync_periode_dagen
			 ,to_date(l_str_startdatum_van,'dd-mm-yyyy hh24:mi:ss')
			 ,to_date(null)
			 ,0
			 , to_date(null)
			 );
	  --********************************
      commit;
	  --********************************
      dbms_output.put_line('STUURTABEL-RECORD TOEGEVOEGD met ID =' ||l_sync_id);
      --
    exception
      when others 
      then rollback;
          --l_str_startdatum_van := to_char( (trunc(sysdate)-1), 'dd-mm-yyyy hh24:mi:ss') ;
          dbms_output.put_line('EXCP-INSERT-STUURTABEL verwerkingperiode van: '||l_str_startdatum_van||'-'||sqlerrm);
    End; 
	--
  END IF;
  --Het maakt niet uit wat de STUURTABEL aan inhoud bevat !!!
  --Indien DEZE INITIELE AANROEP-PROCEDURE wordt gestart wordt NIEUW SCENARIO/BEGINPUNT gestart, zonder met historie rekening te houden !!!!
  for r_tyre_part_no in c_tyre_part_no (l_header_part_no, l_header_frame_id, nvl(l_aantal,1) )
  loop
    if nvl(l_aantal,0) < 10
	then dbms_output.put_line('header-part-no: '||r_tyre_part_no.part_no||' revision: '||r_tyre_part_no.revision||' alternative: '||r_tyre_part_no.alternative||' STARTED...');
	end if;
    l_teller := l_teller + 1;
    --aanroep procedure DBA_BEPAAL_COMP_PART_GEWICHT
	--GEWICHT WORDT OP BASIS VAN PART-NO BEPAALD. SAP-CODE WORDT ALLEEN TER INFO MEEGEGEVEN !!
	--
	dba_bepaal_comp_part_gewicht(p_header_part_no=>r_tyre_part_no.part_no
	                            ,p_header_revision=>r_tyre_part_no.revision
	                            ,p_alternative=>r_tyre_part_no.alternative
								,p_show_incl_items_jn=>l_show_incl_items_jn 
								,p_insert_weight_comp_jn=>l_insert_weight_comp_jn);
    --   
    if nvl(l_aantal,0) < 10
	then dbms_output.put_line('header-part-no: '||r_tyre_part_no.part_no||' revision: '||r_tyre_part_no.revision||' alternative: '||r_tyre_part_no.alternative||' COMPLETED...');
	end if;
    --	
  end loop;
  --
  --
  --Indien stuurtabel bijhouden dan PARAMETER=INSERT-WEIGHT-COMP-JN="J"
  if nvl(l_insert_weight_comp_jn,'N' ) = 'J' 
  then
    BEGIN
      --WERK eindstand bij:
      UPDATE DBA_SYNC_BESTURING_WEIGHT_SAP 
	  set  SBW_DATUM_VERWERKT_TM = to_date(l_str_startdatum_tm,'dd-mm-yyyy hh24:mi:ss')
	  ,    SBW_AANTAL_TYRES      = l_teller
	  WHERE id = l_sync_id 
	  ;
      --**************
	  COMMIT;
	  --**************
    EXCEPTION
      when OTHERS 
      then
        rollback;
        Dbms_output.put_line('EXCP-UPDATE-STUURTABEL, SYNC-ID: '||l_sync_id||' VERWERKT-TM: '||l_str_startdatum_tm||' aantal tyres: '||l_teller||'-'||sqlerrm );
    END;
	--
  END IF; --insert-weight-comp-jn
  --
  l_einddatum := sysdate;
  l_duur_minuut := ( l_einddatum - l_startdatum ) * 24 * 60;
  dbms_output.put_line('Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: '||l_teller||' duur(min): '||l_duur_minuut);
  dbms_output.put_line('SELECT count(*), trunc(component_issueddate) FROM DBA_WEIGHT_COMPONENT_PART where component_issueddate > trunc(sysdate)-14 group by trunc(component_issueddate) order by trunc(component_issueddate);');
  dbms_output.put_line('SELECT count(*), mainpart, tech_calculation_date FROM DBA_WEIGHT_COMPONENT_PART where tech_calculation_date > trunc(sysdate) group by mainpart, tech_calculation_date order by mainpart, tech_calculation_date;');
  if l_header_part_no not in ('ALLE','%')
  then
    dbms_output.put_line('SELECT * FROM DBA_WEIGHT_COMPONENT_PART where part_no = '||''''||l_header_part_no||''''||' and tech_calculation_date > trunc(sysdate)-1 order by id;');
    dbms_output.put_line('SELECT * FROM DBA_WEIGHT_COMPONENT_PART where mainpart = '||''''||l_header_part_no||''''||' and tech_calculation_date > trunc(sysdate)-1 order by id;');
  end if;
  --
END;
/

show err


/*
Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: 648 duur(min): -2.35
SELECT count(*), mainpart, tech_calculation_date FROM DBA_WEIGHT_COMPONENT_PART where tech_calculation_date > trunc(sysdate) group by mainpart, tech_calculation_date order by mainpart, tech_calculation_date;
--
--BEREKENING DOORLOOPTIJDEN VOOR ALLE BANDEN:
--
select count(*) from av_bhr_bom_header_part_no where frame_id like 'A_PCR';
--873x CRRNT-QR4/QR5
--648x CRRNT-QR5

select 648x40/60 dlpt_minuten
,      648x40/60/60 dlpt_uur
from dual;
--432 minuten = 7,2 uur !!!
*/


--overzicht van duur van 1 run op 1 dag:
select min(tech_calculation_date) startdatum, max(tech_calculation_date) einddatum, (max(tech_calculation_date)-min(tech_calculation_date))*24*60 DUUR_MIN,  count(*) aantal
from dba_weight_component_part dwc
where tech_calculation_date > trunc(sysdate)+12/24
;

--10-06-2022 04:02:01	10-06-2022 04:22:45          ==> duur: 20 min !!!
--13-06-2022 12:27:29	13-06-2022 12:32:35	 48815   ==> duur:  5 min !!!
--13-06-2022 02:57:03	13-06-2022 03:02:11	5.13333333333333333333333333333333333334	55216

--dd. 14-06-2022: na aanpassing van STATUS-TYPE=CURRENT !!!!
--Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: 10926 duur(min): 23.51666666666666666666666666666666666664
select count(*) from dba_weight_component_part ;
--totaal: 215.593 rijen !!!
--distinct mainpart: 7692x

--dd. 20-06-2022: na exluden van XE-tyres:
--Uitvragen van hulptabel DBA_WEIGHT_COMPONENT_PART, aantal: 3851 duur(min): 20.83333333333333333333333333333333333334
select count(*) from dba_weight_component_part ;
--totaal: 188.036 rijen !!!
--distinct mainpart: 3841




--overzicht van mainparts in de tijd:
select count(distinct mainpart) 
from dba_weight_component_part dwc
where tech_calculation_date > trunc(sysdate)
;
--947 (zonder issued-date)
--944 (met issued-date)

--overzicht van aantal components met een berekende eenheid-hoeveelheid
select count(*) 
from dba_weight_component_part dwc
where tech_calculation_date > trunc(sysdate)
and   COMP_PART_EENHEID_KG > 0
;
--3523  (was met de vorige versie zonder alternative-koppeling nog maar 2341 !!!)
--3521  (met issued-date)


--overzicht van mainparts in de tijd:
select mainpart, mainrevision, mainalternative, tech_calculation_date, count(*) 
from dba_weight_component_part dwc
where dwc.mainpart in (select distinct dwc2.mainpart from dba_weight_component_part dwc2 where tech_calculation_date > trunc(sysdate))
group by mainpart, mainrevision,  mainalternative, tech_calculation_date
order by mainpart, mainrevision,  mainalternative, tech_calculation_date
;

/*
EC_ME01				15	1	10-06-2022 10:13:46	3
EF_H165/80R14CLS	13	1	10-06-2022 04:02:01	63
--
EF_H165/80R15CLS	11	1	09-06-2022 10:18:31	52
EF_H165/80R15CLS	11	1	10-06-2022 04:02:04	63
--
EF_H165/80R15CLSM	8	1	10-06-2022 04:02:04	63
*/


--selectie component-parts aantal per status
select component_status, count(*)
from dba_weight_component_part dwc
group by component_status
order by component_status
;
/*
CRRNT QR1	1
CRRNT QR2	6349
CRRNT QR3	1745
CRRNT QR4	18391
CRRNT QR5	28713
<NULL>		17
*/	

--selectie component-parts met issued-date van afgelopen week:
select to_char(component_issueddate,'dd-mm-yyyy'), count(*)
from dba_weight_component_part dwc
where dwc.component_issueddate > sysdate-14
group by to_char(component_issueddate,'dd-mm-yyyy')
order by to_char(component_issueddate,'dd-mm-yyyy')
;
/*
31-05-2022 12:00:00	2
01-06-2022 12:00:00	1387
02-06-2022 12:00:00	2
03-06-2022 12:00:00	1
07-06-2022 12:00:00	8
08-06-2022 12:00:00	3
09-06-2022 12:00:00	2
10-06-2022 12:00:00	338
13-06-2022 12:00:00	2
*/

--opvragen alle afzonderlijke mainparts-component-parts van laatste week
select component_part_no, component_revision, to_char(component_issueddate,'dd-mm-yyyy')
from dba_weight_component_part dwc
where dwc.component_issueddate > sysdate-7
;
/*
EP_PA96SF440-784	5	10-06-2022
EP_PA33AF440-776	5	10-06-2022
EP_PA96SF440-790	4	10-06-2022
EG_BH216516SP5-G	14	07-06-2022
EP_PA37ZF440-802	5	10-06-2022
EG_BH216516SP5-G	14	07-06-2022
EP_PA37ZF440-802	5	10-06-2022
...
*/
--***************************************************************************************
--***************************************************************************************
--let op: er KWAMEN in totaal = 3300 component-parts voor ZONDER een ISSUEDDATE !!!!!
--        Dat bleek aan ontbrekende STATUS=CRRNT-QR1/2 te liggen. Deze zijn nu toegevoegd.
--***************************************************************************************
--***************************************************************************************
--
select distinct mainpart, mainrevision, part_no, revision, header_status, component_part_no, component_revision, component_status
from dba_weight_component_part dwc
where dwc.component_issueddate IS NULL
;
/*
EF_Y205/40R18USAX	14	EM_791				7	CRRNT QR5	EM_491				5
XEF_Y275/40R20QPRX	10	XEF_Y275/40R20QPRX	10	CRRNT QR3	EV_BY275/40R20QPRX	7
EF_T195/65R15NO2X	15	EM_791				7	CRRNT QR5	EM_491				5
EF_T225/40R18NO2X	19	EG_BT224018NO2X-G	11	CRRNT QR3	ER_KE21-25-200BEC	13
EF_V215/45R16SP5X	16	EM_791				7	CRRNT QR5	EM_491				5
EF_V225/60R17SP5X	14	EM_791				7	CRRNT QR5	EM_491				5
EF_Y265/35R18AXPX	8	EM_791				7	CRRNT QR5	EM_491				5
GF_1856515QT5NV		10	GB_AC12005035056	8	CRRNT QR2	GB_BC12005056		8
GF_1856515QT5QA		13	GB_AC12005035056	8	CRRNT QR2	GB_BC12005056		8
EF_T215/55R16NO2X	11	EM_791				7	CRRNT QR5	EM_491				5
EF_V235/65R17SP5X	15	EM_791				7	CRRNT QR5	EM_491				5
PF_H165/60R14SP5	6	PF_H165/60R14SP5	6	CRRNT QR5	EV_AH165/60R14SP5	7
EF_T215/60R16NO2X	14	EM_791				7	CRRNT QR5	EM_491				5
EF_T215/55R17NO2X	14	EM_791				7	CRRNT QR5	EM_491				5
EF_V215/45R16A4GX	10	EM_791				7	CRRNT QR5	EM_491				5
GV_FDBX17D1			1	GV_FDBX17D1			1	CRRNT QR4	GG_FDBX17D1			2
XEF_V235/50R19QPR	1	XEF_V235/50R19QPR	1	CRRNT QR4	EV_BV235/50R19QPR	2
--
--LET OP: deze COMPONENT-PARTS blijven nog over ZONDER STATUS/ISSUEDDATE. 
--        ONDERZOEK WIJST UIT DAT DIT NOT-CURRENT-COMPONENTS ZIJN !!!!!!!
--        MAAR AANGEZIEN WE DIT NIET DIRECT UIT DE BOM-ITEMS-TABEL KUNNEN HALEN 
--        WORDEN ZE TIJDENS HET PROCES GEWOON MEEGENOMEN, MAAR MOETEN ER DUS LATER UITGEFILTERD WORDEN !!!
--        BIJV. MET CONDITIE: "AND dwc.component_issueddate IS NOT NULL"
--
*/

SELECT bh.part_no, bh.revision, sh.status
from specification_header sh
,    bom_header           bh
where bh.part_no  = sh.part_no
and   bh.revision = sh.revision
and   bh.revision = (select max(bh2.revision) from bom_header bh2 where bh2.part_no = bh.part_no)
and   bh.part_no in (select distinct component_part_no
                     from dba_weight_component_part dwc
					 where  dwc.component_part_no = bh.part_no
					 and    dwc.component_issueddate IS NULL
					)
;
/*
EM_491				5	5
ER_KE21-25-200BEC	13	154
EV_AH165/60R14SP5	7	5
EV_BV235/50R19QPR	2	5
EV_BY275/40R20QPRX	7	5
GB_BC12005056		8	5
GG_FDBX17D1			2	5
--
--conclusie: indien COMPONENT-PART een status heeft ongelijk aan CRRNT dan blijft status/issueddate leeg!!!
--           Dat komt veelal doordat COMPONENT-PART zelf status-HISTORIC heeft, of TEMP-CURRENT. 
--           Voorlopig negeren dus...
--           Daar zullen we rekening mee moeten houden op het moment dat we deze HULPTABEL gaan uitvragen voor SAP-interface !!
*/


--controle specification_header.REVISION per part-no
SELECT * from specification_header sh where sh.part_no='EM_491' ;
EM_491	4	5	compound for conductive cement 	17-01-2012 12:00:00	17-01-2012 10:25:00
EM_491	5	5	MB compound for conductive cement 	10-09-2013 12:00:00	10-09-2013 03:58:21
--HEEFT GEEN CRRNT-STATUS...

SELECT * from specification_header sh where sh.part_no='ER_KE21-25-200BEC' ;


SELECT * from specification_header sh where sh.part_no='GM_MST17011' ;
GM_MST17011	20	5	MB HP Tread Winter MST17011	17-05-2022 12:00:00	17-05-2022 01:25:50
GM_MST17011	21	125	MB HP Tread Winter MST17011	26-05-2022 12:00:00	26-05-2022 11:28:04
--HEEFT CRRNT-QR2-STATUS !!!




prompt
prompt einde script
prompt
