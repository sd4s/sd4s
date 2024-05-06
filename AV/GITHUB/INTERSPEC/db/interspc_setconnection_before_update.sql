--UPDATE DESCRIPTION VAN CURRENT-TYRES om van "Quatrac Pro Plus" te maken: "Quatrac Pro +"

--Open INTERSPEC
--In INTERSPEC komen CURRENT, DEV(nieuw-tyre) en DEV(bij current-tyre) voor !!!
--Select all CURRENT-REVISIONS zonder al in DEV ??
--      , en wat gebeurt er als CURRENT al een DEV heeft, wordt deze dan genegeerd? 
--Maak met MULTI-operations voor al deze tyres een nieuwe REVISION aan (status=DEV), Laat scherm open staan !
--Update alle DEV-revisions (dus reeds bestaande + nieuwe DEV-vanuit-current) 
--APPROVE met MULTI-operations voor alle reeds geselecteerde TYRES (current waarvoor nieuwe dev is aangemaakt)
--
set serveroutput on
--voordat je kunt wijzigen moet je SET_CONNECTION opgeven
declare
l_return  number;
begin
  l_return := iapiGeneral.SetConnection(USER);
  dbms_output.put_line('return: '||l_return);
end;
/

--part-description:
--Dit mag alleen indien vantevoren voor alle SPECIFICATIONS een nieuwe REVISION in DEV is aangemaakt !!!!

update specification_header sh
set sh.description = replace(sh.description,' Plus', '+')
where sh.description like '%Quatrac%Pro%Plus%'
and   sh.revision = (select max(sh2.revision )
                     from specification_header sh2
					 where sh2.part_no = sh.part_no
					)
and   sh.status in (select s.status
                    from   status s
					where s.status_type='DEVELOPMENT' 
				   )
;


--Deze omschrijving komt ook nog voor in een ASSOCIATION...
update   characteristic c
set c.description = replace(c.description,' Plus', '+')
where c.characteristic_id in (select ca.characteristic
                              from characteristic_association ca
                              ,    association a
                              where a.association = 900143
                              and   a.association = ca.association
                              and   ca.characteristic = c.characteristic_id
                              and   c.description like '%Quatrac%Pro%Plus%'
							 )
;


prompt
prompt einde script
prompt