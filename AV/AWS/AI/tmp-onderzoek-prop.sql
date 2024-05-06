onderzoek ontbrekende properties in SC_LIMS_DAL_AI

select * from sc_lims_dal_ai.ai_specification_data where part_number='EF_H165/60R14SP5';
--D-Spec (section)	704651	401	Bead width
--ETRTO properties	705195	300	ETRTO rimwidth

select * from sc_lims_dal.specification_data where part_number='EF_H165/60R14SP5';


select * 
FROM  sc_lims_dal.specification_property sp
where exists (select '' from sc_lims_dal_ai.ai_specification asp where asp.part_number = sp.part_number and asp.spec_revision = sp.revision) 
and part_number='EF_H165/60R14SP5'
and   (   sp.property_id    in (965,705212,712615,705300,703424,705195)   --etrto
      OR  sp.property_id    in (704651)            --bead
	  OR  sp.property_id    in (709538)            --vulc-tyre
	  OR  sp.property_id    in (707328, 715440)    --rim-protector 
	  )
	  
--D-Spec (section)	704651	401	Bead width
--ETRTO properties	705195	300	ETRTO rimwidth

select * 
from sc_lims_dal.specification_data 
where part_number='EF_H165/60R14SP5'
and   (   sp.property_id    in (965,705212,712615,705300,703424,705195)   --etrto
      OR  sp.property_id    in (704651)            --bead
	  OR  sp.property_id    in (709538)            --vulc-tyre
	  OR  sp.property_id    in (707328, 715440)    --rim-protector 
	  )
;
--10 pagina's...

select * from sc_lims_dal.specification_data sp where sp.part_number='EF_H165/60R14SP5'
and   (  sp.property_id    in (707328, 715440)    
	  )
;
--no-data-found...

--INTERSPEC
select * 
from specdata sp 
where sp.part_no='EF_H165/60R14SP5'
and   (  sp.property_id    in (707328, 715440)    
	  )
;

select * from sc_interspec_ens.specdata sp where sp.part_no='EF_H165/60R14SP5'
and   (  sp.property    in (707328, 715440)    
	  )
;
--hier komt hij nog wel voor !!!!

--onderzoek-spec-data op attributen:

select spd.*
FROM  sc_interspec_ens.specdata       spd
,     sc_interspec_ens.section        sec
,     sc_interspec_ens.sub_section    sub
,     sc_interspec_ens.property_group prg
,     sc_interspec_ens.property       prp
,     sc_interspec_ens.header         hea
,     sc_interspec_ens.attribute      att
,     sc_interspec_ens.test_method    tst
,     sc_interspec_ens.characteristic cha
,     sc_interspec_ens.association    ass
,     sc_interspec_ens.uom            uom
where spd.section_id     = sec.section_id
and   spd.sub_section_id = sub.sub_section_id
and   spd.property_group = prg.property_group
and   spd.property       = prp.property
and   spd.header_id      = hea.header_id
and   spd.attribute      = att.attribute(+)
and   spd.test_method    = tst.test_method(+)
and   spd.characteristic = cha.characteristic_id(+)
and   spd.association    = ass.association(+)
and   spd.uom_id         = uom.uom_id

--probleem: DE UOM tabel moet ook een OUTER-JOIN ZIJN !!!!!!!!!!
--          UOM-ID is blijkbaar toch niet overal gevuld ...
--dus: and   spd.uom_id         = uom.uom_id(+)


