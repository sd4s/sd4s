CREATE OR REPLACE function DBA_check_part_changed_weight (p_part_no      varchar2
                                     ,p_revision     number 
                                     ,p_alternative  number  )
RETURN VARCHAR2                                   
IS
--Er worden een heleboel components gewijzigd (nieuwe revision aangemaakt) waarbij de wijzigingen
--helemaal geen gewichts-wijziging tot gevolg hebben. In zo'n geval hoeven we niet op zoek te gaan
--naar gerelateerde finished-products/tyres om daarvoor een volledig nieuwe gewichtsberekening te doen.
--Indien het een nieuw PART-no is (REVISION=1) moet het part-no zowiezo opnieuw worden meegenomen
--Parameters:   p_part_no     = part-no waarvoor nieuwe revision is aangemaakt
--              p_revision    = is het nieuwe/current-revision-nr 
--              p_alternative = alternative-waarde waarvoor gewicht berekend moet worden.
--
--Result-value: TRUE    --het gewicht is veranderd, moet opnieuw worden berekend
--              FALSE   --het gewicht is NIET veranderd, er hoeven geen nieuwe gewichten te worden berekend.
--
l_part_no           varchar2(18) := p_part_no;
l_revision          number       := p_revision;
l_alternative       number(2,0)  := p_alternative;
--
l_base_quantity_curr number;
l_base_quantity_prev number;
l_weight_curr_rev    number;
l_weight_prev_rev    number;
--
l_result             varchar2(10);
begin
  dbms_output.put_line('start part_no: '||l_part_no||' rev: '||l_revision);
  --init
  l_weight_curr_rev := null;
  l_weight_prev_rev := null;
  l_result          := 'FALSE';   
  --
  if l_revision = 1
  then 
    dbms_output.put_line('REVISION=1 part_no: '||l_part_no||' rev: '||l_revision);
    l_result := 'TRUE';
  else
    dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision);
    --controleren eerst of base-quantity van part-no.bom-header gelijk gebleven is.
    begin
      --Hierna controleren we mbv gewicht-berekening of er ergens in de structuur van part-no.BOM 
      --is gewijzigd (aan componenten/materiaal) die gewichtswijziging tot gevolg zouden kunnen hebben.
      --EERST: we halen gewicht van een eventueel vorige revision van part-no op.
      select base_quantity
      into  l_base_quantity_curr
      from bom_header bh
      where bh.part_no     = l_part_no
      and   bh.revision    = l_revision
      and   bh.alternative = l_alternative
      ;
	  dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' bq: '||l_base_quantity_curr);
      --
      select base_quantity
      into  l_base_quantity_prev
      from bom_header bh
      where bh.part_no     = l_part_no
      and   bh.revision    = l_revision
      and   bh.alternative = l_alternative
      and   bh.revision = (select max(bh2.revision)
                           from bom_header bh2
                           where bh2.part_no     = bh.part_no
                           and   bh2.alternative = bh.alternative  )
      ;
	  dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' bqprev: '||l_base_quantity_prev);
      --
      if l_base_quantity_curr <> l_base_quantity_prev
      then 
        dbms_output.put_line('BASE-diff part_no: '||l_part_no||' rev: '||l_revision||' BQprev: '||l_base_quantity_prev||' BQcurr: '||l_base_quantity_curr);
        l_result := 'TRUE';
      else
        begin
          --selecteer van vorige revision het gewicht van de component/tyre.
          --Let op: vorige revision-nummer hoeft in deze tabel niet hierop volgend te zijn als vorige keer ook het gewicht niet veranderd is.
          select distinct wcp.comp_part_eenheid_kg
          into l_weight_prev_rev
          from DBA_WEIGHT_COMPONENT_PART wcp
          where wcp.component_part_no     = l_part_no
          --and   wcp.component_revision   = l_revision
          and   wcp.component_alternative = l_alternative
          --and   wcp.component_revision = (select max(wcp2.component_revision)
          --                                from DBA_WEIGHT_COMPONENT_PART wcp2
          --                                where wcp2.component_part_no     = wcp.component_part_no
          --                                and   wcp2.component_alternative = wcp.component_alternative
          --                               )
          --We nemen voortaan REVISION van de laatste INITIELE/MUTATIE-VERWERKING !!!
          and   wcp.datum_verwerking = (select max(wcp2.datum_verwerking)
                                        from DBA_WEIGHT_COMPONENT_PART wcp2
                                        where wcp2.component_part_no     = wcp.component_part_no
                                        and   wcp2.component_alternative = wcp.component_alternative
                                       )
          and rownum = 1                                     
          ;
    	  dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' PREV-WEIGHT: '||l_weight_prev_rev);

          --DAARNA: berekenen we het nieuwe gewicht bij current-revision
          --'GM_R5026'
          l_weight_curr_rev := AAPIWEIGHT_CALC.DBA_FNC_BEPAAL_HEADER_GEWICHT(p_header_part_no=>l_part_no     
                                                            ,p_header_revision=>l_revision
                                                            ,p_header_alternative=>l_alternative
                                                            ,p_show_incl_items_jn=>'N' ) ;
    	  dbms_output.put_line('REVISION<>1 part_no: '||l_part_no||' rev: '||l_revision||' CURR-WEIGHT: '||l_weight_curr_rev);
          --Indien gewicht van current-version anders is dan previous-revision dan opnieuw berekenen.
          if l_weight_prev_rev <> l_weight_curr_rev
          then 
             dbms_output.put_line('WEIGHT-diff part_no: '||l_part_no||' rev: '||l_revision||' Qprev: '||l_weight_prev_rev||' Qcurr: '||l_weight_curr_rev);
             l_result := 'TRUE';
          end if;
        exception
          when no_data_found
          then --geen vorig voorkomen gevonden, dan ook altijd nieuw gewicht berekenen
               --vaak het geval indien status-verandering naar CURRENT heeft plaatsgevonden
               dbms_output.put_line('EXCP-NO-DATA-FOUND part_no: '||l_part_no||' rev: '||l_revision||' Qprev: '||l_weight_prev_rev||' Qcurr: '||l_weight_curr_rev);
               l_result := 'TRUE';
          when others
          then 
            dbms_output.put_line('EXCP-OTHERS part_no: '||l_part_no||' rev: '||l_revision||' Qprev: '||l_weight_prev_rev||' Qcurr: '||l_weight_curr_rev);
            l_result := 'TRUE';           
        end; 
        --
      end if; --base-quantity-curr/prev
      --
    exception
      when others
      then 
        dbms_output.put_line('ALG-EXCP-CHECK-PART part_no: '||l_part_no||' rev: '||l_revision||'-'||sqlerrm);
        l_result := 'TRUE';
    end;
    --
  end if; --revision = 1
  --
  dbms_output.put_line('VOOR RETURN part_no: '||l_part_no||' rev: '||l_revision||'RESULT: '||L_RESULT);
  --
  return l_result;
  --
exception
  when others
  then 
    dbms_output.put_line('ALG-EXCP-OTHERS-CHECK-PART part_no: '||l_part_no||' rev: '||l_revision||'-'||sqlerrm);
    l_result := 'TRUE';   
    return l_result;  
end DBA_check_part_changed_weight; 
/