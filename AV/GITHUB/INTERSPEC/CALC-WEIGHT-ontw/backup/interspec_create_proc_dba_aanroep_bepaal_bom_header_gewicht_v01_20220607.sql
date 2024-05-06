--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***************  procedure   DBA_AANROEP_HEADER_BOM_GEWICHT                                                    ********
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************
--***********************************************************************************************************************

create or replace procedure DBA_AANROEP_HEADER_BOM_GEWICHT (p_header_part_no      varchar2   default 'ALLE' 
                                                           ,p_header_frame_id     varchar2   default 'A_PCR' 
														   ,p_aantal              number     default 1       )
DETERMINISTIC
AS
--AANROEP-procedure voor een totaal-controle van gewichten per HEADER-PART-NO op hoogste niveau.
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
--                                    frame-id mag alleen waarde ALLE/<null> of volledig frame-id bevatten
--                                    kan ook als filter gebruikt worden maar ALLEEN MET VOLLEDIG FRAME-ID, NIET MET SUBSTRING !!!!
--                                          bijv.  A_PCR             (controleer alle header-specs van type frame=A_PCR)
--
--             P_AANTAL = aantal rows output, aantal rows output. Indien leeg dan krijgt waarde=999999999
--                        Dit is alleen voor testdoeleinden, en werkt alleen bij gebruik van WILDCARDS/'ALLE' in partno of sap-no !!
--                        werkt alleen indien P_PART_NO een volledig PART-NO betreft (dus niet SUBSTRING met "%" of ALLE)
--                                                 
--dependencies: FUNCTIE DBA_BEPAAL_QUANTITY_KG: functie om de quantity-string te vermenigvuldiger met PART-NO-BASE-QUANTITY 
--                                              om uiteindelijk het gewicht van BOM-HEADER obv MATERIALS-gewichten te berekenen.
--                                              Indien aangeroepen vanuit deze aanroep-procedure wordt er ALLEEN totaal-gewicht bepaald.
--
--Aanroep-voorbeelden:
-- 0) dba_aanroep_header_bom_gewicht('ALLE'             , 'ALLE'  , null);    --haal alle part-no van A_PCR op
--
-- 1) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', null    , null);    --haal alleen specifiek part-no op
-- 2) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', null    , 1);       --haal alleen specifiek part-no op
-- 3) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', null    , 10);      --haal vanaf specifiek part-no ook de volgende 9 part-no op.
-- 4) dba_aanroep_header_bom_gewicht('ALLE'             , 'A_PCR' , null);    --haal alle part-no van A_PCR op
-- 5) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', 'A_PCR' , null);    --haal specifiek part-no op (met juiste frame-id)
-- 6) dba_aanroep_header_bom_gewicht('EF_H215/60R16SP5X', 'A_PCR' , 10);      --haal specifiek part-no op (met juiste frame-id) en volgende 9 part-no op.
-- 7) dba_aanroep_header_bom_gewicht('EF%'              , ''      , 10);      --haal eerste 10 part-no op.
-- 8) dba_aanroep_header_bom_gewicht('EF%'              , 'A_PCR' , 10);      --haal eerste 10 part-no binnen frame-id op.
--
l_header_part_no           varchar2(100)   := p_header_part_no;
l_header_frame_id          varchar2(100)   := p_header_frame_id;
l_aantal                   number          := p_aantal;
--*************************************************************************************
--AANROEP VIA VIEW: AV_BHR_BOM_HEADER_PART_NO (=ALLE CURRNT-TYRES/COMPONENTS) !!!!
--*************************************************************************************
cursor c_header_part_no (pl_header_part_no  varchar2 default '%'
                        ,pl_header_frame_id varchar2 default '%' 
						,pl_aantal          number   default 1   )
is
select * 
from av_bhr_bom_header_part_no   bh
where (  (   (  instr(p_header_part_no,'%') > 0
			 )
         and bh.part_no    like pl_header_part_no||'%'
         and bh.frame_id   like pl_header_frame_id||'%'
		 )
	  or (   instr(p_header_part_no,'%') = 0
	     and bh.part_no    >=   pl_header_part_no  
	     and bh.frame_id   like pl_header_frame_id||'%'
		 )
      )
and rownum < (l_aantal+1)
order by bh.part_no
;
l_startdatum  date;
l_einddatum   date;
l_duur_minuut number;
l_teller      number;
--
BEGIN
  DBMS_OUTPUT.ENABLE(1000000);
  --INIT
  l_teller     := 0;
  l_startdatum := sysdate;
  l_aantal     := nvl(l_aantal,999999999);
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
  for r_header_part_no in c_header_part_no (l_header_part_no, l_header_frame_id, l_aantal )
  loop
    l_teller := l_teller + 1;
    --aanroep procedure DBA_BEPAAL_BOM_GEWICHT
	--GEWICHT WORDT OP BASIS VAN PART-NO BEPAALD. 
	dba_bepaal_bom_header_gewicht(pf_header_part_no=>r_header_part_no.part_no
                                 ,pf_show_incl_items_jn=>'J');
  end loop;
  l_einddatum := sysdate;
  l_duur_minuut := ( l_einddatum - l_startdatum ) * 24 * 60;
  dbms_output.put_line('Bereken HEADER-GEWICHT, aantal: '||l_teller||' duur(min): '||l_duur_minuut);
  -- 
END;
/

show err



prompt
prompt einde script
prompt
