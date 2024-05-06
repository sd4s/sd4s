--testen/runnen van procedure:
SET SERVEROUTPUT ON
declare
l_component_part             varchar2(100) := 'EC_DE04';  --'EM_764';
l_component_part_eenheid_kg  number;
begin
  dbms_output.put_line('start bepaal_comp_part_gewicht');
  DBA_BEPAAL_COMP_PART_GEWICHT (p_header_part_no=>l_component_part
                               ,p_header_revision=>null
                               ,p_alternative=>'1' );
  dbms_output.put_line('eind bepaal_comp_part_gewicht');
END;
/  


--create procedure
create or replace procedure DBA_BEPAAL_COMP_PART_GEWICHT (p_header_part_no      varchar2 
                                                         ,p_header_revision     varchar2 default null
                                                         ,p_alternative         number   default null
                                                         ,p_show_incl_items_jn  varchar2 default 'N' 
														 )
DETERMINISTIC
AS
--Script om voor ALLE COMPONENT-PART (niet zijnde material/grondstof in kg) in de BOM van een 
--bom-header/component het gewicht te berekenen obv. de procedure DBA_BEPAAL_BOM_GEWICHT !!!
--Door deze procedure per COMPONENT-PART aan te roepen berekenen we voor eigenlijk alle BOM-HEADERS
--het gewicht van 1 x EENHEID van deze BOM-HEADER (dus los van base-quantity waarmee deze header
--onderdeel uitmaakt van een BAND/TYRE.
--
--SELECTIE ZIT HIERBIJ  OP ALLE BOM-ITEMS (=EXCL. de BOM-ITEMS WAARBIJ COMPONENT-PART = MATERIALEN/GRONDSTOFFEN) 
--WAARBIJ PER COMPONENT-PART HET EENHEID-GEWICHT WORDT BEREKEND. 
--Dit betekent dan ook dat voor de BAND zelf het gewicht niet berekend kan worden met deze procedure
--aangezien een band zelf niet als COMPONENT-PART in de BOM-ITEM-tabel voorkomt. 
--Het is wel zo dat je deze procedure wel weer met een BAND/TYRE-PART-NO aanroept !!!!
--Onderhuids wordt dan voor iedere BOM-HEADER het gewicht berekend.
--
--Het kan wel voorkomen dat een PART-NO meerdere keren in de BOM van een BAND voorkomt,
--in dat geval wordt alsnog voor ieder voorkomen het gewicht berekend.
--
--LET OP: Procedure werkt alleen nog maar voor ALTERNATIVE=1 items !!!. Dus als er op een lager
--        niveau bom-items voorkomen met ALTERNATIVE=2 dan worden deze NIET meegenomen in de berekening.
--        (het is ook nog de vraag wat we met deze gewichten moeten doen? Later evt. uitbreiden...)
--
--Resultaten worden weggeschreven naar een hulptabel die gebruikt wordt voor SAP-INTERFACE !!!!!
--
--Parameters:  P_HEADER_PART_NO = bom-item-header, bijv.  EF_H215/65R15QT5	("CRRNT QR5", A_PCR)
--                                                        EF_Q165/80R15SCS	("CRRNT QR5", A_PCR)
--                                                        EF_S640/95R13CLS	("CRRNT QR5", A_PCR)
--             P_HEADER_REVISION = bom-item-header-revision-number van CURRENT/HISTORIC header.
--                                 Indien een TYRE zal status altijd CURRENT zijn. 
--                                 Een component kan zelf al HISTORIC zijn maar zolang hij in BOM-ITEM zit moet hij wel worden meegenomen.
--             P_ALTERNATIVE = indicator die aangeeft om welk alternatief het gaat. 
--                             1=default, per eenheid
--                             2=batch, voor bulk
--             P_SHOW_INCL_ITEMS_JN = J = dbms-output van alle component-parts onder HEADER-part, INCL. insert DBA_WEIGHT_COMPONENT_PART.
--                                    N = ALLEEN output weggeschreven naar DBA_WEIGHT_COMPONENT_PART !!!
--
--
pl_header_part_no           varchar2(100)   := p_header_part_no;
pl_header_revision          number          := p_header_revision;
pl_alternative              number(2)       := p_alternative;
pl_show_incl_items_jn       varchar2(1)     := UPPER(p_show_incl_items_jn);
--
c_bom_items                sys_refcursor;
l_tech_calculation_date    date;    --datum waarmee alle components voor 1 BAND/HEADER in hulptabel DBA_WEIGHT_COMP_PART komen!!
l_remark                   varchar2(100) := 'PRC: DBA_BEPAAL_COMP_PART_GEWICHT';
--
l_LVL                      varchar2(100);  
l_level_tree               varchar2(4000);
l_rownum                   number;
--
l_mainpart                 varchar2(100);
l_mainrevision             number;
l_mainplant                varchar2(100);
l_mainalternative          number;
l_mainbasequantity         number;
l_mainminqty               number;
l_mainmaxqty               number;
l_mainsumitemsquantity     number;
l_mainstatus               varchar2(100);
l_mainframeid              varchar2(100);
l_mainpartdescription      varchar2(1000);
l_mainpartbaseuom          varchar2(100);
--
l_part_no                  varchar2(100);
l_revision                 NUMBER;
l_plant                    varchar2(100);
l_alternative              number(2);
l_characteristic_id        number;
l_item_header_base_quantity number;
l_component_part           varchar2(100);
l_quantity                 number;
l_uom                      varchar2(100);
l_quantity_kg              number;
l_status                   varchar2(30);
l_functiecode              varchar2(1000);
l_header_issued_date       varchar2(30);
l_header_status            varchar2(30);
l_componentdescription     varchar2(1000);
l_componentrevision        number;
l_componentalternative     number;
l_componentissueddate      varchar2(30);
l_componentstatus          varchar2(30);
l_path                     varchar2(4000);
l_quantity_path            varchar2(4000);
l_bom_quantity_kg         varchar2(100);
--
l_part_eenheid_kg            number;    --gewicht van BOM-HEADER=TYRE zelf.
l_component_part_eenheid_kg  number;    --gewicht van 1xEENHEID component-part obv volledige TREE aan BOM-ITEMS !!
--
c_bom                      sys_refcursor;
l_header_mainpart          varchar2(100);
l_header_gewicht           varchar2(100);
l_header_gewicht_som_items varchar2(100);
--
function p_part_exists (p_part_no   varchar2
                       ,p_revision  number )
return boolean
IS
l_aantal  number;
begin
  l_aantal := 0;
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  select count(*) 
  into l_aantal
  from dba_weight_component_part dwc 
  where dwc.mainpart = p_part_no
  and   dwc.part_no  = p_part_no
  and   dwc.revision = p_revision
  --kan zijn dat er voor de direct gerelateerde components al record is weggeschreven. deze bevatten gewicht van component en niet van tyre zelf.
  --vandaar extra check op lege component-part 
  and   dwc.component_part_no   is null        
  and   dwc.component_revision  is null
  and   dwc.comp_part_eenheid_kg > 0
  and   dwc.tech_calculation_date >= trunc(sysdate)
  ;
  --dbms_output.put_line('RESULT part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  if nvl(l_aantal,0) > 0
  then return TRUE;
  else return FALSE;
  end if;
exception
  when no_data_found
  then return FALSE;  
end;
--
function p_component_exists (p_component_part_no  varchar2
                            ,p_componentrevision  number )
return boolean
IS
l_aantal  number;
begin
  l_aantal := 0;
  --dbms_output.put_line('START part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  select count(*) 
  into l_aantal
  from dba_weight_component_part dwc 
  where dwc.component_part_no  = p_component_part_no
  and   dwc.component_revision = p_componentrevision
  and   dwc.comp_part_eenheid_kg > 0
  and   dwc.tech_calculation_date >= trunc(sysdate)
  ;
  --dbms_output.put_line('RESULT part: '||p_component_part_no||' revision: '||p_componentrevision||' aantal: '||l_aantal);
  if nvl(l_aantal,0) > 0
  then return TRUE;
  else return FALSE;
  end if;
exception
  when no_data_found
  then return FALSE;  
end;
--							
BEGIN
  dbms_output.enable(1000000);
  --init
  if pl_header_revision is null
  then
    --indien er geen revision is meegegeven dan alsnog eerst zelf ophalen
    begin
      select max(sh1.revision) 
	  into pl_header_revision
	  from status s1
	  ,    specification_header sh1 
	  where sh1.part_no = pl_header_part_no 
	  and sh1.status = s1.status 
	  and s1.status_type in ('CURRENT','HISTORIC')
	  ;
	exception
	  when others 
	  then dbms_output.put_line('REVISION-EXCP: Revision kon niet bepaald worden voor partno: '||pl_header_part_no);
    end;
  end if;
  --
  if upper(pl_show_incl_items_jn) = 'J'
  then 
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('MAINPART: '||pl_header_part_no  );
    dbms_output.put_line('**************************************************************************************************************');
  end if;	
    BEGIN
	  --init
	  l_tech_calculation_date := sysdate;
	  --
	  if upper(pl_show_incl_items_jn) = 'J'
      then 
        dbms_output.put_line('l_mainpart'||';'||'l_mainrevision'||';'||'l_mainplant'||';''l_mainalternative'||';'||'l_mainframeid'||
		                    ';'||'l_part_no'||';'||'l_revision'||';'||'l_plant'||';''l_alternative'||';'||'l_header_issued_date'||';'||'l_header_status'||
							';'||'l_component_part'||';'||'l_componentdescription'||';'||'l_componentrevision'||';'||'l_componentalternative'||';'||'l_componentissueddate'||';'||'l_componentstatus'||
							';'||'l_characteristic_id'||';'||'l_functiecode'||';'||'l_path'||';'||'l_quantity_path'||';'||'l_bom_quantity_kg' );      
      end if;							
	  --Tonen van base/eenheid-gewicht van BOM-HEADER/component:
      open c_bom_items for SELECT bi2.LVL
				,      bi2.level_tree
				,      rownum
				,      bi2.mainpart
				,      bi2.mainrevision
				,      bi2.mainplant
				,      bi2.mainalternative
				,      bi2.mainframeid
				,      bi2.part_no
				,      bi2.revision
				,      bi2.plant
				,      bi2.alternative
				,      bi2.headerissueddate
				,      bi2.headerstatus
				,      bi2.component_part
				,      bi2.componentdescription
				,      bi2.componentrevision
				,      bi2.componentalternative
				,      bi2.componentissueddate
				,      bi2.componentstatus
				,      bi2.characteristic_id 
				,      bi2.functiecode
				,      bi2.path
				,      bi2.quantity_path
				,      DBA_BEPAAL_QUANTITY_KG(bi2.quantity_path)  bom_quantity_kg
				from
				(
				with sel_bom_header as 
				(select bh.part_no
				 ,      bh.revision
				 ,      bh.plant
				 ,      bh.alternative
				 ,      sh.frame_id
				 from status               s  
				 ,    specification_header sh
				 ,    bom_header           bh 
				 where  bh.part_no    = pl_header_part_no  --'EF_Q165/80R15SCS'  --'EM_764' --'EG_H620/50R22-154G'  --pl_header_part_no
                 and    bh.revision   = pl_header_revision  --(select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bh.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
				 and    bh.part_no    = sh.part_no
                 and    bh.revision   = sh.revision
                 and    sh.status     = s.status		
                 --Er komt maar 1x CRRNT voor, de rest is HISTORIC/DEV, en dus is altijd max(revision)		  
				 --and    s.status_type = 'CURRENT' 
				 --welk alternative we moeten gebruiken is afhankelijk van PREFERRED-ind.
                 and    bh.preferred  = 1
				 --WE HALEN PCR-CONTROLE UIT DEZE PROCEDURE, DEZE VERPLAATSEN WE NAAR DE AANROEP-PROCEDURE
				 --DAAR ZIT AL EEN SOORTGELIJKE CHECK INCL. DE SAP-VIEW-PART-NO. DIT WORDT DAARMEE OVERBODIG...
				 /* --PS: 03-07-2022 UITGEZET...
				    and (    (    sh.frame_id   = 'A_PCR'
                          and  bh.part_no NOT IN (--moet wel component zijn bij current bom-header
                                                 select bi1.component_part 
							                     from  status               s1
							                     ,     specification_header sh1 
							                     ,     bom_item             bi1
							                     where  bi1.component_part = bh.part_no
							                     and    bi1.part_no        = sh1.part_no
							                     and    bi1.revision       = sh1.revision
							                     and    sh1.status         = s1.status
							                     and    s1.status_type='CURRENT' 
							                     and    exists (--component-part zelf moet ook nog current zijn
						                                        select '' 
						                                        from bom_item bi2
						                                        ,    status   s2 
						                                        ,    specification_header sh2
                                                                where bi2.part_no  = bi1.component_part 
                                                                and   bi2.part_no  = sh2.part_no 
						                                        and   bi2.revision = sh2.revision 
						                                        and   sh2.status   = s2.status
						                                        and   s2.status_type = 'CURRENT' 
									                           )
							                     )
  				          and  exists ( --een band moet min. 1x current-component bevatten
                                      select bi1.component_part 
                                      from   status               s1
                        			  ,      specification_header sh1
                        			  ,      bom_item             bi1
                                      where  bi1.part_no  = bh.part_no
                        			  and    bi1.revision = bh.revision
			                          and    bi1.part_no  = sh1.part_no
                        			  and    bi1.revision = sh1.revision
                        			  and    sh1.status   = s1.status
                        			  and    s1.status_type = 'CURRENT' 
                        			  and    (   exists (--component zelf moet dan ook current zijn
									                    select '' 
                             			                from bom_item             bi2
                            			                ,    status               s2 
                            			                ,    specification_header sh2
                                                        where bi2.part_no  = bi1.component_part 
                                                        and   bi2.part_no  = sh2.part_no 
                            			                and   bi2.revision = sh2.revision 
                            			                and   sh2.status   = s2.status
                             			                and   s2.status_type = 'CURRENT' 
                             						   )
                                              or  not exists (--of is alleen material zonder header
											                  select '' 
                                                              from bom_header bh
                                                              where bh.part_no = bi1.component_part
                                                             )
                                              ) 
						                 )
						   )
				      or  bh.part_no IN (--moet een component zijn, geen material
					                     select boi2.part_no 
					                     from bom_item boi2 
										 where boi2.part_no     = bh.part_no 
										 and   boi2.alternative = bh.alternative
										)
					  )
				 */
				 and    rownum = 1
				) 
				select LEVEL   LVL
				,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
				,      h.part_no             mainpart
				,      h.revision            mainrevision
                ,      h.plant               mainplant
				,      h.alternative         mainalternative
				,      h.frame_id            mainframeid
				,      b.part_no
				,      b.revision
				,      b.plant
				,      b.alternative
				,      b.headerissueddate
				,      b.headerstatus
				,      b.component_part
				,      (select pi.description from part pi where pi.part_no = b.component_part)           componentdescription
				,      (select max(bi2.revision) from bom_item bi2 where bi2.part_no = b.component_part)  componentrevision
				,      b.alternative                                                                      componentalternative
				,      (select to_char(sh2.issued_date,'dd-mm-yyyy hh24:mi:ss') from status s2, specification_header sh2 where sh2.part_no=b.component_part and s2.status = sh2.status and s2.status_type='CURRENT' )   componentissueddate
				,      (select s3.sort_desc from status s3, specification_header sh3 where sh3.status = s3.status and sh3.part_no=b.component_part and s3.status = sh3.status and s3.status_type='CURRENT'  ) componentstatus
				,      b.item_header_base_quantity
				,      b.quantity
				,      b.uom
				,      b.quantity_kg
				,      b.characteristic_id       --FUNCTIECODE
				,      b.functiecode             --functiecode-descr
				,      sys_connect_by_path( b.part_no||decode(b.characteristic_id,null,'','-'||b.characteristic_id) || ',' || b.component_part ,'|')  path
				,      sys_connect_by_path( '('||b.quantity_kg||'/'||b.item_header_base_quantity||')', '*')  quantity_path
				FROM   ( SELECT bi.part_no
				         ,      bi.revision
						 ,      bi.plant
						 ,      bi.alternative
						 ,      TO_CHAR(sh.issued_date,'dd-mm-yyyy hh24:mi:ss')  headerissueddate
						 ,      s.sort_desc                                      headerstatus
						 ,      bi.component_part
						 ,      bh.base_quantity   item_header_base_quantity
						 ,      bi.quantity
						 ,      bi.uom 
						 ,      case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg   --hier moeten we de overige UOMs zoals pcs/m nog wel meenemen anders wordt later de factor in quantity-path=0
				         ,      bi.ch_1         characteristic_id       --FUNCTIECODE
				         ,      c.description   functiecode             --functiecode-descr
  				         FROM status               s
						 ,    specification_header sh
						 ,    bom_header           bh
 				         ,    characteristic       c
				         ,    bom_item             bi	 
						 WHERE bh.part_no      = bi.part_no
						 and   bh.revision     = bi.revision
						 and   bh.preferred    = 1
						 and   bh.alternative  = bi.alternative
                         and   bh.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
						 and   bi.part_no     = sh.part_no
                         and   bi.revision    = sh.revision
						 and   sh.status      = s.status	
						 --and   s.status_type  = 'CURRENT' 
				         and   bi.ch_1        = c.characteristic_id(+)
					   ) b
				,      sel_bom_header h	   
				START WITH b.part_no = h.part_no 
				CONNECT BY NOCYCLE PRIOR b.component_part = b.part_no --and b.component_revision = b.revision
				order siblings by b.part_no
				)  bi2
                where bi2.component_part IN (select bi3.part_no from bom_item bi3 where bi3.part_no = bi2.component_part)   --NU itt DBA_BEPAAL_BOM_HEADER_GEWICHT: NIET de selectie voor material-codes, DIE gaan we niet de gewichten berekenen...
				;
      loop 
        fetch c_bom_items into l_LVL
                          ,l_level_tree
                          ,l_rownum
		                  ,l_mainpart  
                          ,l_mainrevision
						  ,l_mainplant
                          ,l_mainalternative
						  ,l_mainframeid
						  ,l_part_no 
                          ,l_revision
                          ,l_plant   
                          ,l_alternative
						  ,l_header_issued_date 
						  ,l_header_status
                          ,l_component_part      
                          ,l_componentdescription	
						  ,l_componentrevision
						  ,l_componentalternative
						  ,l_componentissueddate
						  ,l_componentstatus
						  ,l_characteristic_id
                          ,l_functiecode
                          --,l_item_header_base_quantity
                          --,l_quantity            
                          --,l_uom                 
                          --,l_quantity_kg     
						  ,l_path
						  ,l_quantity_path
						  ,l_bom_quantity_kg
						  ;
        if (c_bom_items%notfound)   
        then CLOSE C_BOM_ITEMS;
	         exit;
	    end if;
		if upper(pl_show_incl_items_jn) = 'J'
        then 
          dbms_output.put_line(l_mainpart||';'||l_mainrevision||';'||l_mainplant||';'||l_mainalternative||';'||l_mainframeid||
		                    ';'||l_part_no||';'||l_revision||';'||l_plant||';'||l_alternative||';'||l_header_issued_date||';'||l_header_status||
							';'||l_component_part||';'||l_componentdescription||';'||l_componentrevision||';'||l_componentalternative||';'||l_componentissueddate||';'||l_componentstatus||
							';'||l_characteristic_id||';'||l_functiecode||';'||l_path||';'||l_quantity_path||';'||l_bom_quantity_kg );      
        end if;							
		--
		--INDIEN PART-NO = TYRE (MAINPART=PART-NO) DAN BEREKENEN WE GEWICHT VAN DE TYRE OOK NOG EVEN APART
		--OMDAT ALLEEN DAN OOK DE DIRECT GERELATEERDE MATERIALS (MEESTAL DE STICKER/LABELS) OOK IN GEWICHT BEREKENING WORDEN MEEGENOMEN...
		--
		if l_mainpart = l_part_no
		then
          --Het kan wel voorkomen dat er meerdere componenten onder mainpart voorkomen. In dit geval dus ook
          --controleren of er al een TYRE-record met een gewicht voorkomt. Als dat zo is doen we niets.
          --Dit in tegenstelling tot de componenten, waar we nog een lege regel wegschrijven, en gewicht later er pas weer bijzoeken.
          --Dat is bij een TYRE dus niet nodig...
          IF NOT p_part_exists(l_part_no, l_revision)
          THEN
            l_remark := 'MAINPART-HEADER-TYRE: DBA_BEPAAL_COMP_PART_GEWICHT';
            --dbms_output.put_line('TYRE-gewicht altijd berekenen, part-no:'||l_part_no );
            l_part_eenheid_kg := 0;
            l_part_eenheid_kg := DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_part_no
		                                                      ,p_header_revision=>l_revision
                                                              ,p_show_incl_items_jn=>'N' 
                                                              );
            --en schrijven we hier ook een aparte regel voor weg in hulptabel DBA_WEIGHT_COMPONENT_PART
            --zonder COMPONENT-data...
            --INSERT HULPTABEL: DBA_WEIGHT_COMPONENT_PART
		    --(LET OP: IS AUTONOMOUS-TRANSACTION !! Commit zit in procedure..)
            DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date=>l_tech_calculation_date
		                            ,p_datum_verwerking=>trunc(l_tech_calculation_date)
                                    ,p_mainpart=>l_mainpart 
                                    ,p_mainrevision=>l_mainrevision
                                    ,p_mainplant=>l_mainplant
                                    ,p_mainalternative=>l_mainalternative
                                    ,p_mainframeid=>l_mainframeid
                                    ,p_part_no=>l_part_no
									,p_revision=>l_revision
                                    ,p_plant=>l_plant
                                    ,p_alternative=>l_alternative
									,p_header_issueddate=>to_date(l_header_issued_date,'dd-mm-yyyy hh24:mi:ss')
									,p_header_status=>l_header_status
									,p_component_part_no=>null
                                    ,p_component_description=>null
									,p_component_revision=>null
									,p_component_alternative=>null
									,p_component_issueddate=>null
									,p_component_status=>null
 								    ,p_characteristic_id=>null
									,p_functiecode=>null
								    ,p_path=>l_part_no                   --alleen eigen part-no
								    ,p_quantity_path=>l_quantity_path
								    ,p_bom_quantity_kg=>1                --default = 1
									,p_comp_part_eenheid_kg=>l_part_eenheid_kg
								    ,p_remark=>l_remark
									);
          END IF;  --part-exists
          --
		end if;  --mainpart=part-no
		--
        --roep voor ALLE COMPONENT-PARTS ONDER DE MAINPART de weight-calculation via BEPAAL_BOM_HEADER_GEWICHT aan !
		--Alleen indien deze niet voorkomt gaan we deze opnieuw berekenen !!
		l_component_part_eenheid_kg := 0;
		IF NOT p_component_exists(l_component_part, l_componentrevision)
		THEN
		  --dbms_output.put_line('COMPONENT DOESNOT EXIST YET, call dba_fnc_bepaal_header_gewicht' );
  		  l_component_part_eenheid_kg := DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_component_part
		                                                              ,p_header_revision=>l_componentrevision
                                                                      ,p_show_incl_items_jn=>'N' 
                                                                      );
        ELSE
		  --we nemen gewicht over van we vorige keer al berekend hebben...
		  begin
		    select dwc.comp_part_eenheid_kg 
            into   l_component_part_eenheid_kg
            from  dba_weight_component_part dwc 
            where dwc.component_part_no     = l_component_part
            and   dwc.component_revision    = l_componentrevision
            and   dwc.comp_part_eenheid_kg  > 0
            and   dwc.tech_calculation_date >= trunc(sysdate)
			and   rownum = 1
            ;
		  exception
		    when others 
			then null;
                 dbms_output.put_line('COMPONENT-WEIGHT DOES ALREADY EXISTS, BUT RETRIEVING THE WEIGHT GIVES ERROR: '||l_component_part||'-'||l_componentrevision||': '||sqlerrm );
		  end;
		END IF;																	  
	    --dbms_output.put_line('MAINPART: '||l_mainpart||' PART_NO: '||l_part_no||' COMPONENT-PART: '||l_component_part||' gewicht: '||l_component_part_eenheid_kg);
		--
		l_remark  := 'COMPONENT-HEADER: DBA_BEPAAL_COMP_PART_GEWICHT';
		--INSERT HULPTABEL: DBA_WEIGHT_COMPONENT_PART
		--(LET OP: IS AUTONOMOUS-TRANSACTION !! Commit zit in procedure..)
		DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date=>l_tech_calculation_date
		                            ,p_datum_verwerking=>trunc(l_tech_calculation_date)
                                    ,p_mainpart=>l_mainpart 
                                    ,p_mainrevision=>l_mainrevision
                                    ,p_mainplant=>l_mainplant
                                    ,p_mainalternative=>l_mainalternative
                                    ,p_mainframeid=>l_mainframeid
                                    ,p_part_no=>l_part_no
									,p_revision=>l_revision
                                    ,p_plant=>l_plant
                                    ,p_alternative=>l_alternative
									,p_header_issueddate=>to_date(l_header_issued_date,'dd-mm-yyyy hh24:mi:ss')
									,p_header_status=>l_header_status
									,p_component_part_no=>l_component_part
                                    ,p_component_description=>l_componentdescription
									,p_component_revision=>l_componentrevision
									,p_component_alternative=>l_componentalternative
									,p_component_issueddate=>to_date(l_componentissueddate,'dd-mm-yyyy hh24:mi:ss')
									,p_component_status=>l_componentstatus
 								    ,p_characteristic_id=>l_characteristic_id
									,p_functiecode=>l_functiecode
								    ,p_path=>l_path
								    ,p_quantity_path=>l_quantity_path
								    ,p_bom_quantity_kg=>l_bom_quantity_kg
									,p_comp_part_eenheid_kg=>l_component_part_eenheid_kg
								    ,p_remark=>l_remark
									);
        --exit;	  
      end loop;
	  --
      if c_bom_items%isopen
	  then close c_bom_items;  
	  end if;
	  --
	EXCEPTION
	  WHEN OTHERS 
	  THEN 
        if c_bom_items%isopen
	    then close c_bom_items;  
	    end if;
        if sqlerrm not like '%ORA-01001%' 
        THEN dbms_output.put_line('ALG-EXCP BOM-ITEMS: '||SQLERRM); 
        else null;   
        end if;
	END;
  --
  if upper(pl_show_incl_items_jn) = 'J'
  then   
    dbms_output.put_line('**************************************************************************************************************');
    dbms_output.put_line('EINDE BEREKEN TOTAALGEWICHT VAN HEADER: '||pl_header_part_no ||' REVISION: '||pl_header_revision||' WEIGHT: '||l_part_eenheid_kg||' COMP-PART-WEIGHT: '||l_component_part_eenheid_kg);
    dbms_output.put_line('**************************************************************************************************************');
  end if;
  --
END DBA_BEPAAL_COMP_PART_GEWICHT;
/

show err


prompt
prompt einde script
prompt
