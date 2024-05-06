--ONDERZOEK verschil in gewicht in COMPONENTEN per tyre
--Waarbij we per MAINPART alle VERSCHILLEN IN KG PER COMPONENT LATEN ZIEN...
--

select  count(distinct dwc.PART_NO), dwc.STATUS_DESC
FROM DBA_VW_CRRNT_MAINPART_PARTS dwc
where comp_type='COMPONENT' 
group by dwc.status_desc 
;
/*
720	
2941	CRRNT QR5
2		TEMP CRRNT
1019	CRRNT QR4
353		CRRNT QR3
6546	CRRNT QR2
7		CRRNT QR1
1		CRRNT QR0
*/



--query van componenten zonder "CURRENT"-STATUS !!!
select  dwc.mainpart
,       dwc.mainrevision
,       dwc.PART_NO
,       dwc.REVISION
,       s.sort_desc
FROM status    s
,    specification_header sh
,    DBA_VW_CRRNT_MAINPART_PARTS dwc
where dwc.comp_type ='COMPONENT' 
and   nvl(dwc.status_desc,'OBSOLETE') IN ('OBSOLETE','HISTORIC')
and   dwc.part_no = sh.part_no
and   dwc.revision = sh.revision
and   sh.status = s.status
;

--overzicht banden/status waarbij min.1x historic-component voorkomt...
select  distinct dwc.mainpart
,       sh_main.revision        main_rev
,       main_status.sort_desc   main_status
,       dwc.mainrevision
,       rev_status.sort_desc             part_status
,       dwc.part_no
,       dwc.revision
,       compsh.part_no          comp_part_no
,       comps.sort_desc         comp_status  
FROM status                      main_status
,    specification_header        sh_main
,    status                      rev_status
,    specification_header        sh
,    status                      comps
,    specification_header        compsh
,    DBA_VW_CRRNT_MAINPART_PARTS dwc
where dwc.comp_type    = 'COMPONENT' 
and   nvl(dwc.status_desc,'OBSOLETE') IN ('OBSOLETE','HISTORIC')
--and   dwc.status_desc  is null
and   dwc.mainpart     = sh.part_no
and   dwc.mainrevision = sh.revision
and   dwc.part_no      = compsh.part_no
and   dwc.revision     = compsh.revision
and   sh.status        = rev_status.status
and   dwc.mainpart     = sh_main.part_no
and   sh_main.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sh_main.part_no)
and   sh_main.status   = main_status.status
and   compsh.status    = comps.status
order by main_status, dwc.mainpart, part_status, dwc.mainrevision, dwc.part_no, dwc.revision, comp_status, comp_part_no
;

--LET OP:
--We komen hier ook TYRES tegen met REVISION/STATUS = HISTORIC. Dit is wel een CURRENT-TYRE, maar
--BOM-HEADER loopt REVISION achter op SPECIFICATION_HEADER, en komt daarom met status=HISTORIC in de lijst voor...
select MAX(revision) from specification_header where part_no='EF_H165/60R15QT5';
--24
select MAX(revision) from bom_header where part_no='EF_H165/60R15QT5';
--23
select MAX(revision) from bom_item where part_no='EF_H165/60R15QT5'
--23





--overzicht historic-component BIJ CURRENT-TYRES.
select  distinct dwc.part_no
,       dwc.revision
,       comps.sort_desc
FROM status                      comps
,    specification_header        compsh
,    DBA_VW_CRRNT_MAINPART_PARTS dwc
where dwc.comp_type    = 'COMPONENT' 
--and   dwc.status_desc  is null
and   nvl(dwc.status_desc,'OBSOLETE') IN ('OBSOLETE','HISTORIC')
and   dwc.part_no      = compsh.part_no
and   dwc.revision     = compsh.revision
and   compsh.status    = comps.status
order by dwc.part_no, dwc.revision
;

/*
SELECT sh.part_no, sh.revision, s.sort_desc
from status    s
,    specification_header sh
where sh.status = s.status
and   sh.part_no='EM_491' 
and   sh.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no=sh.part_no)
*/



--met een procedure:
SET SERVEROUTPUT ON
declare
l_mainpart    varchar2(100) := ' ALLE'; --'XGF_1557013QT5NTRW';
l_av_AANTAL   number;
--
cursor c_comp (pl_mainpart varchar2)
is
select  dwc.COMP_TYPE
,       dwc.PART_NO
,       dwc.REVISION
,       dwc.WEIGHT_UNIT_KG
FROM DBA_VW_CRRNT_MAINPART_PARTS dwc
WHERE dwc.MAINPART=decode(pl_mainpart,'ALLE',dwc.MAINPART, pl_mainpart)
;
begin
  for r_comp in c_comp(l_mainpart)
  loop
    l_av_aantal   := 0;
    begin
      select COUNT(*) into l_av_aantal from avspecification_weight av where av.part_no = r_comp.part_no;
	  IF l_av_aantal > 0
	  THEN dbms_output.put_Line('Mainpart: ' ||l_mainpart||' comp-Partno: '||r_comp.part_no||' comp-revision: '||r_comp.revision||' AANTAL: '||l_av_aantal);
	  end if;
	  --EVT. een loop over de componenten om te zien om welke componten het gaat...
	  
	end;
  end loop;
end;
/




