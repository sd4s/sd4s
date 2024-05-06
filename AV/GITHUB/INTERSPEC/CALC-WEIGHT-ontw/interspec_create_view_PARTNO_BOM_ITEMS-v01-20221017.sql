--*********************************************************************************************
--*********************************************************************************************
--create views:   1.DBA_VW_PARTNO_ITEMS_CURRENT       -->select van een CURRENT-bom-item alleen de direct gerelateerde components/materials current-revision
--                2.DBA_VW_PARTNO_ITEMS_REVISIONS     -->select van een CURRENT-bom-item alleen de direct gerelateerde components/materials max-revision=current-revision
--
--*********************************************************************************************
--*********************************************************************************************


--*********************************************************************************************
--1.VIEW alle CURRENT BOM-ITEMS incl STATUS + CURRENT(REVISION)
--  TOEGANGSPAD: mbv current BOM_ITEM.PART_NO ALLEEN de direct eraan gerelateerde COMPONENT-PARTs te selecteren
--*********************************************************************************************
--drop view DBA_VW_CRRNT_BOM_ITEMS;
drop view DBA_VW_PARTNO_ITEMS_CURRENT
purge recyclebin;
--
CREATE or REPLACE view DBA_VW_PARTNO_ITEMS_CURRENT
as
select bi.part_no
,      bi.revision
,      to_char(sh.issued_date,'dd-mm-yyyy hh24:mi:ss') partissueddate
,      to_char(sh.obsolescence_date,'dd-mm-yyyy hh24:mi:ss') partobsolescencedate
,      bi.plant
,      bi.alternative
,      bh.preferred
,      sh.status
,      s.sort_desc
,      s.status_type
,      p.description
,      sh.frame_id
,      bi.component_part
,      (select distinct bh1.revision 
        from status               s1
		,    specification_header sh1
		,    bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status 
		and   s1.status_type = 'CURRENT')  componentrevision
,      bi.quantity
,      bi.uom
,      bi.ch_1
,      c.description    functiecode 
from characteristic       c
,    part                 p
,    status               s
,    specification_header sh
,    bom_header           bh
,    bom_item             bi
where bi.part_no     = bh.part_no
and   bi.revision    = bh.revision
and   bi.alternative = bh.alternative
and   sh.part_no     = bh.part_no
and   sh.revision    = bh.revision
and   sh.status      = s.status
and   s.status_type  = 'CURRENT' 
and   bh.part_no     = p.part_no
and   bi.ch_1        = c.characteristic_id(+)
--and rownum < 5
order by bi.part_no
,        bi.revision
,        bi.component_part
; 

--*******************************************************************************************
--2.VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION) + CURRENT(REVISION)
--*******************************************************************************************
--drop view DBA_VW_ALL_BOM_ITEMS;
drop view DBA_VW_PARTNO_ITEMS_REVISIONS
purge recyclebin;
--
CREATE or REPLACE view DBA_VW_PARTNO_ITEMS_REVISIONS
as
select bi.part_no
,      bi.revision
,      to_char(sh.issued_date,'dd-mm-yyyy hh24:mi:ss') partissueddate
,      to_char(sh.obsolescence_date,'dd-mm-yyyy hh24:mi:ss') partobsolescencedate
,      bi.plant
,      bi.alternative
,      bh.preferred
,      sh.status
,      s.sort_desc
,      s.status_type
,      p.description
,      sh.frame_id
,      bi.component_part
,      (select MAX(bh1.revision)
        from status               s1
		,    specification_header sh1
		,    bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status )  maxcomponentrevision
,      (select distinct bh1.revision 
        from status               s1
		,    specification_header sh1
		,    bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status 
		and   s1.status_type = 'CURRENT')  currentcomponentrevision
,      bi.quantity
,      bi.uom
,      bi.ch_1
,      c.description    functiecode 
from characteristic       c
,    part                 p
,    status               s
,    specification_header sh
,    bom_header           bh
,    bom_item             bi
where bi.part_no     = bh.part_no
and   bi.revision    = bh.revision
and   bi.alternative = bh.alternative
and   sh.part_no     = bh.part_no
and   sh.revision    = bh.revision
and   sh.status      = s.status
--and   s.status_type  = 'CURRENT' 
and   bh.part_no     = p.part_no
and   bi.ch_1        = c.characteristic_id(+)
--and rownum < 5
order by bi.part_no
,        bi.revision
,        bi.component_part
; 




PROMPT EINDE SCRIPT


