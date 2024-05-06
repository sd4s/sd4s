--Script om de BANDEN te selecteren waar een component-part onderdeel van uitmaakt.
--LET OP: -De status band moet wel van type CRRNT-QR3/4/5 zijn.
--        (-Alleen banden met PREFERRED=1, meestal ALTERNATIVE=1 maar ook =2/3/4)
--        -in PATH komen ook weer de voorkomens met de COMPONENT-PARTS van het PART-NO waarmee deze proc wordt
--         aangeroepen. In dat geval krijgen we doublures in output. Dat is reden dat we PATH niet default meeselecteren...
--
with sel_bom_item as
(select LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      b.part_no
,      b.revision
,      b.plant
,      b.alternative
,      b.component_part
,      b.quantity
,      b.uom
,      b.quantity_kg
,      sys_connect_by_path( b.component_part || ',' || b.part_no ,'|')  path
FROM   ( SELECT bi.part_no
         , bi.revision
		 , bi.plant
		 , bi.alternative
		 , bi.component_part
		 , bi.quantity
		 , bi.uom 
		 , case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg 
		 from bom_header           bh
         --,    status               s
		 ,    specification_header sh
		 ,    bom_item             bi	 
		 WHERE bh.part_no      = bi.part_no
		 and   bh.revision     = bi.revision
		 and   bh.preferred    = 1
		 and   bh.alternative  = bi.alternative
         and   bi.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = bi.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC' ))
		 and   bi.part_no     = sh.part_no
         and   bi.revision    = sh.revision
       ) b
START WITH b.part_no = 'ED_K2004-5-11'  --'EB_V27490E88F'  --'EG_BH168015CLS-G'    --'EV_BH165/80R15CLS'
CONNECT BY NOCYCLE PRIOR b.part_no = b.component_part
                     and b.revision = (select sh1.revision from status s1, specification_header sh1 where sh1.part_no = b.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
order siblings by part_no						 
)
(select distinct boh.part_no   header_part_no
 ,       boh.revision
 ,       boh.plant
 ,       boh.alternative
 ,       sh.status
 ,       sh.frame_id
 ,       boh.base_quantity
 ,       sbi.part_no            item_part_no
 ,       sbi.component_part     comp_part_no
 ,       sbi.quantity
 ,       sbi.path
 from   sel_bom_item         sbi
 ,      specification_header sh
 ,      bom_header           boh 
 where  sbi.part_no  = boh.part_no
 and    sbi.revision = boh.revision
 and    sh.part_no   = boh.part_no
 and    sh.revision  = boh.revision
 --and    boh.alternative = 1
 and    NOT EXISTS (select boi2.component_part from bom_item boi2 where boi2.component_part = boh.part_no)
 and    boh.revision = (select max(sh.revision) 
                        from status               s  
                        ,    specification_header sh
                        where  sh.part_no    = boh.part_no  
                        and    sh.status     = s.status		
                        and    s.status_type in ( 'CURRENT','HISTORIC')						
                       )
 --extra conditie: alleen Enschede-tyres
 --and   boh.part_no like 'EF%'
 --extra conditie: alleen A_PCR-tyres
 --and   sh.frame_id in ('A_PCR')
 --indien current-tyre moet zijn...
 --AND   boh.part_no in (SELECT DISTINCT dwc.MAINPART FROM DBA_WEIGHT_COMPONENT_PART dwc where dwc.mainpart=boh.part_no)
)
;


/*
EF_540/65R34TVZM45	1	ENS	1	127	E_AT_RRO	1	EF_540/65R34TVZM45	EF_540/65R34TVZ145	1
EF_600/65R34TVZM51	1	ENS	1	127	E_AT_RRO	1	EF_600/65R34TVZM51	EF_600/65R34TVZ151	1
EF_600/70R34TRXM60	4	ENS	1	127	E_AT_RRO	1	EF_600/70R34TRXM60	EF_600/70R34TRX160	1
EF_540/65R34TVZ152	6	ENS	1	127	E_AT		1	EF_540/65R34TVZ152	EG_N540/65R34-152G	1
*/

--EINDE SCRIPT

