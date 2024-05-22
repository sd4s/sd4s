--Het blijkt dat de Quickbase database er een poosje heeft uitgelegen waardoor niet alle
--data vanuit Interspec goed is aangekomen/opgeslagen.
--
--Voor de volgende banden moet de data worden aangeleverd:
/*
 'GF_2256018QPRXV'
,'GF_2355518QPRXV'
,'GF_2354519WPRXV'
,'GF_2555519WPRXV'
,'GF_2555019WPRXV'
,'GF_2355019WPRXV'
,'GF_2454018WPRXW'
,'GF_2154518WPRXV'
,'GF_2354018WPRXW'
,'GF_2255519USANW'
,'GF_2554520WPRXV'
,'GF_2754520WPRXV'
,'GF_2754020QPRXY'
,'GF_2454020QPRXY'
,'GF_2553520QPRXY'
,'GF_2453520QPRXY'
,'GF_2553519WPRXY'
,'GF_1955516QT6XV'
,'GF_2355517AA4XY'
,'GF_2255518AA4XV'
,'GF_2255518ULAYB'
,'GF_2255518ULAQB'
*/

--query

select section_id, description
from section s
where s.description in ('SAP information','General information','Labels and certification')
/*
700755	SAP information
700579	General information
701095	Labels and certification
*/

select pg.property_group, pg.description
from property_group pg
where pg.description in ('SAP articlecode','General tyre characteristics','Size', 'Sidewall designation','Labels Rolling resistance','Labels Wet grip', 'Labels Noise','Quality grading UTQG')
;
/*
701563	General tyre characteristics
701568	Sidewall designation
701569	Size
704056	SAP articlecode
704176	Labels Noise
704177	Labels Rolling resistance
704178	Labels Wet grip
704180	Quality grading UTQG
*/


spool c:\temp\quickbase-export-20221201.txt

set pages 999
set linesize 600

column description format a40
column PRODUCTCAT_DESC format a30
column section_desc format a30
column subsection_desc format a10
column prop_group_desc format a30
column property_desc format a30
column uom_desc format a10
column test_desc format a20
column char_desc format a20
column char_1 format a40
column char_2 format a10

prompt PART-PROPERTIES

select 'pa.part_no'||';'||
      'pa.description'||';'||
      'pp.plant'||';'||
      'h.revision'||';'||
      'h.status'||';'||
      'h.frame_id'||';'||
      'h.class3_id'||';'||
      'productcat_desc'||';'||
      'st.sort_desc'||';'||
      'sp.section_id'||';'||
      'section_desc'||';'||
      'sp.sub_section_id'||';'||
      'subsection_desc'||';'||
      'sp.property_group'||';'||
      'prop_group_desc'||';'||
      'sp.property'||';'||
      'property_desc'||';'||
      'sp.attribute'||';'||
      'sp.uom_id'||';'||
      'uom_desc'||';'||
      'sp.test_method'||';'||
      'test_desc'||';'||
      'sp.num_1' ||';'||
      'sp.num_2'||';'||
      'sp.char_1'||';'||
      'sp.char_2'||';'||
      'ch.characteristic_id' ||';'||
      'char_desc'
from dual;
--



with c_part as
(select p.part_no 
from part p 
where p.part_no in 
('GF_2256018QPRXV'
,'GF_2355518QPRXV'
,'GF_2354519WPRXV'
,'GF_2555519WPRXV'
,'GF_2555019WPRXV'
,'GF_2355019WPRXV'
,'GF_2454018WPRXW'
,'GF_2154518WPRXV'
,'GF_2354018WPRXW'
,'GF_2255519USANW'
,'GF_2554520WPRXV'
,'GF_2754520WPRXV'
,'GF_2754020QPRXY'
,'GF_2454020QPRXY'
,'GF_2553520QPRXY'
,'GF_2453520QPRXY'
,'GF_2553519WPRXY'
,'GF_1955516QT6XV'
,'GF_2355517AA4XY'
,'GF_2255518AA4XV'
,'GF_2255518ULAYB'
,'GF_2255518ULAQB')
--and p.part_no in ('GF_2256018QPRXV' )
)
select pa.part_no||';'||
       pa.description||';'||
       pp.plant||';'||
       h.revision||';'||
       h.status||';'||
       h.frame_id||';'||
       h.class3_id||';'||
       c3.description||';'||    
       st.sort_desc||';'||
       sp.section_id||';'||
       s.description||';'||     
       sp.sub_section_id||';'||
       ss.description||';'||    
       sp.property_group||';'||
       pg.description||';'||    
       sp.property||';'||
       p.description||';'||     
       sp.attribute||';'||
       sp.uom_id||';'||
       u.description||';'||     
       sp.test_method||';'||
       t.description||';'||     
       sp.num_1||';'||          
       sp.num_2||';'||
       sp.char_1||';'||
       sp.char_2||';'||
       ch.characteristic_id||';'|| 
       ch.description   
from c_part  c
join part pa on pa.part_no = c.part_no
JOIN part_plant pp on pp.part_no = pa.part_no
join specification_header h on h.part_no = pa.part_no
JOIN CLASS3 c3 on c3.class = h.class3_id
join SPECIFICATION_PROP sp on sp.part_no = h.part_no and sp.revision = h.revision
JOIN  STATUS st             on h.status = st.status
join property_group pg     on pg.property_group = sp.property_group
JOIN PROPERTY p            on sp.property = p.property
JOIN SECTION s             on sp.section_id = s.section_id
JOIN sub_section ss        on sp.sub_section_id = ss.sub_section_id
left outer join uom u      on sp.uom_id = u.uom_id
left outer join test_method t on t.test_method = sp.test_method
left outer join characteristic ch on ch.characteristic_id = sp.characteristic
where h.revision = (select max(h2.revision) from specification_header h2 where h2.part_no = h.part_no)
and (   (   s.description   = 'SAP information'
        and pg.description  = 'SAP articlecode'
        and p.description in ('Commercial article code','Commercial DA article code')
        )	
	or (    s.description   = 'General information'
        and pg.description  = 'General tyre characteristics'
        and p.description in ('Brand','Tyre class','Tubetype/tubeless','Structure','Load index class','Productline','Category','Winter indication','Traction marking','Load index class'  )
	    )
	or (    s.description   = 'General information'
        and pg.description  = 'Size'
        and p.description in ('Section width','Aspect ratio','Rimcode','Load index','Ply rating','Load index (dual)','Speed index'  )
	    )
	or (    s.description   = 'General information'
        and pg.description  = 'Sidewall designation'
        and p.description in ('Size designation','Quality grading','DOT Plant Code','DOT Manufacturers Code','Made in ','Max. pressure','Max. load','Max. pressure','Plies sidewall','Plies tread'  )
	    )
	or (    s.description   = 'Labels and certification'
        and pg.description  in ('Labels Rolling resistance','Labels Wet grip','Labels Noise')
        and p.description in ('Europe')
	    )
	or (    s.description   = 'Labels and certification'
        and pg.description  in ('Quality grading UTQG')
        and p.description in ('Temperature','Traction','Tread wear')
	    )
	)
order by pa.part_no, s.description, pg.description, p.description
;


prompt part-no WEIGHT

select 'PART_NO'||';'||
       'WEIGHT_UNIT_KG'
from dual;

select PART_NO||';'||
       WEIGHT_UNIT_KG
from dba_vw_crrnt_weight_tyres
where part_no in 
('GF_2256018QPRXV'
,'GF_2355518QPRXV'
,'GF_2354519WPRXV'
,'GF_2555519WPRXV'
,'GF_2555019WPRXV'
,'GF_2355019WPRXV'
,'GF_2454018WPRXW'
,'GF_2154518WPRXV'
,'GF_2354018WPRXW'
,'GF_2255519USANW'
,'GF_2554520WPRXV'
,'GF_2754520WPRXV'
,'GF_2754020QPRXY'
,'GF_2454020QPRXY'
,'GF_2553520QPRXY'
,'GF_2453520QPRXY'
,'GF_2553519WPRXY'
,'GF_1955516QT6XV'
,'GF_2355517AA4XY'
,'GF_2255518AA4XV'
,'GF_2255518ULAYB'
,'GF_2255518ULAQB')
;

spool off;

