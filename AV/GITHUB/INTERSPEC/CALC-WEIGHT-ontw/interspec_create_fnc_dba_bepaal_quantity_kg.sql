CREATE OR REPLACE FUNCTION DBA_BEPAAL_QUANTITY_KG (P_STMNT VARCHAR2) 
RETURN VARCHAR
DETERMINISTIC
is
--Procedure om een STRING in format <BOM-ITEM COMPONENT-PART-quantity>/<BOM-HEADER COMPONENT-PART-base-Quantity> || 
--                                  <BOM-ITEM COMPONENT-PART-quantity>/<BOM-HEADER COMPONENT-PART-base-Quantity> etc.
--                        Vanaf de BOM_HEADER tot aan BOM_ITEM-MATERIAL (van item wat zelf geen header meer is).
--te vermenigvuldigen met de BOM_HEADER.BASE-QUANTITY, om vervolgens per BOM-ITEM het gewicht te bepalen van de hoeveelheid
--waarmee dit material onderdeel uitmaakt van de band/bom_header.
--
--PARAMETER:  P_STMNT  = bom_header.part_no
--AANNAME:    In deze procedure is de <bom_header.base-quantity> default op "1" gezet. Misschien moeten we deze met een extra parameter vanuit aanroepend script doorgeven 
--            om altijd het echte BASE-QUANTITY mee te geven voor de berekening !!!
--Voorbeeld aanroep:
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)') FROM DUAL;  --1.993676
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)') FROM DUAL; --.4485771
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)') FROM DUAL;  --.5104807398
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)') FROM DUAL;  --.46860149211580979823793708187219164334
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)*(1.009291/1.1950109)') FROM DUAL;  --.395774857433566327364349358905317245138
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)*(1.009291/1.1950109)*(1.0784192/1.1120994)') FROM DUAL;  --.383788719905451483836066941634160668775
--SELECT DBA_BEPAAL_QUANTITY_KG('*(1/1)*(1/1)*(1.993676/1)*(0.225/1)*(1.138/1)*(1.1077343/1.2067333)*(1.009291/1.1950109)*(1.0784192/1.1120994)*(0.692091 /1.1080374)') FROM DUAL;
--
l_stmnt   varchar2(1000);
l_return  varchar2(1000);
l_base_quantity number := 1;
begin
  --BASE-QUANTITY = 1 in onderstaande SQL:
  l_stmnt := 'select '||l_base_quantity||' '||p_stmnt||' from dual';  
  execute immediate l_stmnt into l_return;
  return l_return;
end;
/

show err


