--ORACLE-QUERY to SELECT complete BOM at once.
--We try to build same query in REDSHIFT...
select LEVEL   LVL
,      RPAD('.', (level-1)*2, '.') || LEVEL AS level_tree
,      bi.part_no
,      bi.revision
,      bi.plant
,      bi.alternative
,      bi.component_part
,      bi.quantity
,      bi.uom
,      bi.ch_1                
FROM   sc_interspec_ens.bom_item    bi
WHERE  bi.revision   = (select max(sh1.revision) 
		                from sc_interspec_ens.status s1
						,    sc_interspec_ens.specification_header sh1 
						where sh1.part_no = bi.part_no 
						and sh1.status = s1.status 
						and s1.status_type in ('CURRENT','HISTORIC'))
START WITH bI.part_no = 'XGF_1557013QT5NTRW'
CONNECT BY NOCYCLE PRIOR bi.component_part = bi.part_no 
order siblings by bi.part_no
;




/*
Display “hierarchical path” via recursive CTE
Displaying hierarchy levels and a hierarchical path along with the data is also often desired in these types of use cases. You can easily achieve this by using a recursive CTE with the following approach.
Let’s modify the preceding query to display the hierarchical path and levels:

WITH RECURSIVE subordinates(level, employee_id, manager_id, employee_name, path) AS (
SELECT  1,
        employee_id,
        manager_id,
        employee_name,
        CAST(employee_id AS VARCHAR(1000))  -- See note below for CAST
FROM    employees 
WHERE   employee_id = 302

UNION ALL 
SELECT s.level + 1,
       E1.employee_id,
       E1.manager_id,
       E1.employee_name,
       concat( concat( s.path, '/'), E1.employee_id) AS path
FROM   employees E1
INNER JOIN subordinates s 
On s.employee_id = E1.manager_id
)
SELECT * FROM subordinates;
*/

/*
WITH RECURSIVE bom_item_header(level, part_no, revision, component_part, path) 
AS (SELECT  1
   ,        b.part_no
   ,        b.revision
   ,        b.component_part
   ,        CAST(b.component_part AS VARCHAR(1000))  
   FROM    sc_interspec_ens.bom_item  b
   WHERE   b.part_no = 'XGF_1557013QT5NTRW'
   and     b.revision   = (select max(sh1.revision) 
		                   from sc_interspec_ens.status s1
      	                   ,    sc_interspec_ens.specification_header sh1 
                           where sh1.part_no = b.part_no 
                           and sh1.status = s1.status 
                           and s1.status_type in ('CURRENT','HISTORIC')
						  )
   UNION ALL 
   SELECT bh.level + 1
   ,      BI.part_no
   ,      BI.revision
   ,      BI.component_part
   ,      concat( concat( bh.path, '/'), BI.COMPONENT_PART) AS path
   FROM   sc_interspec_ens.bom_item BI
   INNER JOIN bom_item_header bh on ( bh.component_part = BI.part_no )
  )
SELECT * FROM bom_item_header
;

--ERROR: Correlated subquery in recursive CTE is not supported yet
*/

/*
WITH RECURSIVE bom_item_header(level, part_no, revision, component_part, path) 
AS (SELECT  1
   ,        b.part_no
   ,        b.revision
   ,        b.component_part
   ,        CAST(b.component_part AS VARCHAR(1000))  
   FROM    sc_interspec_ens.bom_item  b
   ,       sc_interspec_ens.status s1
   ,       sc_interspec_ens.specification_header sh1 
   WHERE   b.part_no = 'XGF_1557013QT5NTRW'
   and     sh1.part_no = b.part_no 
   and     sh1.status = s1.status 
   and     s1.status_type in ('CURRENT')
   UNION ALL 
   SELECT bh.level + 1
   ,      BI.part_no
   ,      BI.revision
   ,      BI.component_part
   ,      concat( concat( bh.path, '/'), BI.COMPONENT_PART) AS path
   FROM   sc_interspec_ens.bom_item BI
   INNER JOIN bom_item_header bh on ( bh.component_part = BI.part_no )
  )
SELECT * FROM bom_item_header
;
 
--ERROR: Hit recursive CTE max rows limit, please add correct CTE termination predicates or change the max_recursion_rows parameter. 
--Detail: error: Hit recursive CTE max rows limit, please add correct CTE termination predicates 
--or change the max_recursion_rows parameter. code: 8001 context: query: 16983741 location: step_common.cpp:1122 process: query1_123_16983741 [pid=24423] 
*/


-- 'XGF_1557013QT5NTRW'
-- 'GV_1557013QT5NTRW' 
-- 'GG_157013QT5NTRW' 

WITH RECURSIVE bom_item_header(level, part_no, revision, component_part, path) 
AS (SELECT  1
   ,        b.part_no
   ,        b.revision
   ,        b.component_part
   ,        CAST(b.component_part AS VARCHAR(1000))  
   FROM    sc_interspec_ens.bom_item  b
   ,       sc_interspec_ens.bom_header h
   ,       sc_interspec_ens.status s1
   ,       sc_interspec_ens.specification_header sh1 
   WHERE   b.part_no    = 'EF_V215/45R16A4GX'     
   and     b.part_no    = h.part_no
   and     b.revision   = h.revision
   and     h.preferred  = 1
   and     sh1.part_no  = b.part_no 
   and     sh1.revision = b.revision
   and     sh1.status   = s1.status 
   and     s1.status_type in ('CURRENT')
   UNION ALL 
   SELECT bh.level + 1
   ,      BI.part_no
   ,      BI.revision
   ,      BI.component_part
   ,      concat( concat( bh.path, '/'), BI.COMPONENT_PART) AS path
   FROM    sc_interspec_ens.bom_item   bi
   ,       sc_interspec_ens.bom_header h2
   ,       sc_interspec_ens.status     s2
   ,       sc_interspec_ens.specification_header sh2
   ,       bom_item_header             bh
   WHERE   bh.component_part = bi.part_no
   and     bi.part_no    = h2.part_no
   and     bi.revision   = h2.revision
   and     h2.preferred  = 1
   and     sh2.part_no  = bi.part_no 
   and     sh2.revision = bi.revision
   and     sh2.status   = s2.status 
   and     s2.status_type in ('CURRENT')
  )
SELECT * FROM bom_item_header
;
  
/*
1	XGF_1557013QT5NTRW	1	GV_1557013QT5NTRW	GV_1557013QT5NTRW
2	GV_1557013QT5NTRW	2	GG_157013QT5NTRW	GV_1557013QT5NTRW/GG_157013QT5NTRW
--

EF_V215/45R16A4GX	8
EF_H175/65R15QT5	19
GF_2255017AA4XV	9
EF_W245/40R18WPRX	27
GF_2354517AXPXY	10
GF_2055516AXPNW	8
EF_W235/40R18WPRX	7
EF_W225/45R18WPRX	6
EF_V255/50R19WPRX	9
EF_V235/50R19WPRX	9
EF_V235/45R20WPRX	9
EF_V235/45R18WPRX	7
EF_V225/45R17WPRX	9
EF_V215/65R17WXS	8
EF_V215/45R18WPRX	9
EF_V205/55R17WPRX	10

--conclusie: deze lijken het wel te doen !!!!!
*/



WITH RECURSIVE bom_item_header(level, part_no, revision, component_part, path) 
AS (SELECT  1
   ,        b.part_number
   ,        b.revision
   ,        b.component_part
   ,        CAST(b.component_part AS VARCHAR(1000))  
   FROM    sc_lims_dal_ai.AI_SPEC_BOM_ITEM_CURRENT_TREE   b
   WHERE   b.part_number    = 'EF_V215/45R16A4GX'     
   UNION ALL 
   SELECT bh.level + 1
   ,      BI.part_number
   ,      BI.revision
   ,      BI.component_part
   ,      concat( concat( bh.path, '/'), BI.COMPONENT_PART) AS path
   FROM    sc_lims_dal.SPEC_BOM_ITEM_CURRENT_TREE  bi
   ,       bom_item_header                         bh
   WHERE   bh.component_part = bi.part_number
  )
SELECT * FROM bom_item_header
;


/*
--lukt het wel om CRITERIA OP PART-NO OP HOOGSTE LEVEL TE ZETTEN?

WITH RECURSIVE bom_item_header(level, part_no, revision, component_part, path) 
AS (SELECT  1
   ,        b.part_no
   ,        b.revision
   ,        b.component_part
   ,        CAST(b.component_part AS VARCHAR(1000))  
   FROM    sc_interspec_ens.bom_item  b
   ,       sc_interspec_ens.bom_header h
   ,       sc_interspec_ens.status s1
   ,       sc_interspec_ens.specification_header sh1 
   WHERE   b.part_no    = h.part_no
   and     b.revision   = h.revision
   and     h.preferred  = 1
   and     sh1.part_no  = b.part_no 
   and     sh1.revision = b.revision
   and     sh1.status   = s1.status 
   and     s1.status_type in ('CURRENT')
   UNION ALL 
   SELECT bh.level + 1
   ,      BI.part_no
   ,      BI.revision
   ,      BI.component_part
   ,      concat( concat( bh.path, '/'), BI.COMPONENT_PART) AS path
   FROM    sc_interspec_ens.bom_item   bi
   ,       sc_interspec_ens.bom_header h2
   ,       sc_interspec_ens.status     s2
   ,       sc_interspec_ens.specification_header sh2
   ,       bom_item_header             bh
   WHERE   bh.component_part = bi.part_no
   and     bi.part_no    = h2.part_no
   and     bi.revision   = h2.revision
   and     h2.preferred  = 1
   and     sh2.part_no  = bi.part_no 
   and     sh2.revision = bi.revision
   and     sh2.status   = s2.status 
   and     s2.status_type in ('CURRENT')
  )
SELECT * FROM bom_item_header
where part_no    = 'EF_V215/45R16A4GX'     
;

--ERROR: Value too long for character type Detail: 
--error: Value too long for character type code: 8001 context: Value too long for type character varying(1000) query: 16984235 
--location: string.cpp:247 process: query1_123_16984235 [pid=26490] 
*/



  