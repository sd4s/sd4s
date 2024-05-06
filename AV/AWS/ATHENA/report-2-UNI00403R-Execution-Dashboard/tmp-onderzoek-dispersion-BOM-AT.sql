WITH RECURSIVE tree (
  part_no
, revision
, plant
, item_number
, status
, parent_part
, parent_rev
, parent_status
, alternative
, preferred
, phr
, quantity
--, density
--, root_density
, uom
, characteristic
, issued_date
, root_part
, root_rev
, root_status
, root_alternative
, root_preferred
, root_issued_date
, lvl
, lvl_tree
, path
, pathNode
, parent_branch
, parent_seq
, parent_quantity
, normalized_quantity
--, component_volume
--, volume
--, normalized_volume
--, parent_volume
, branch
, indentStr
, breadcrumbs
) AS 
(SELECT DISTINCT mv.component_part AS part_no
, convert(integer, mv.comp_revision)                  as revision
, mv.plant                         as plant
, mv.item_number
, mv.status                        as status
, mv.part_no     AS parent_part
, convert(integer, mv.revision)    AS parent_rev
, mv.status      AS parent_status
, mv.alternative
, mv.preferred
, mv.phr_num_5      AS phr
, mv.quantity
--, b1.num_1      AS density
--, b1.num_1      AS root_density
, mv.uom
, mv.characteristic
, mv.issued_date
, mv.part_no       AS root_part
, mv.revision      AS root_rev
, mv.status        AS root_status
, mv.alternative  AS root_alternative
, mv.preferred   AS root_preferred
, mv.issued_date   AS root_issued_date
, cast(1  as integer)                                       AS lvl
, RPAD('.', (1-1)*2, '.') || '1'                              AS lvl_tree
, CAST('0000' AS VARchar(200))                              AS path
, to_char(mv.item_number, '0999')                           AS pathNode
, CAST('' AS VARCHAR(100))                                  AS parent_branch
, mv.item_number                                            AS parent_seq
, mv.base_quantity                                          AS parent_quantity
, cast( (mv.quantity * 1 / 1 ) as decimal)                  AS normalized_quantity
--, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS component_volume
--, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS volume
--, DECODE(b1.num_1, 0, 0, b1.quantity / b1.num_1)            AS normalized_volume
--, CAST(1  AS DECIMAL )                                        AS parent_volume
, cast( to_char(mv.item_number, '0999') as varchar(200) )     AS branch
, CAST ('' AS VARCHAR(200))                                AS indentStr
, CAST('Top' AS VARCHAR(200))                              AS breadcrumbs
FROM  sc_interspec_ens.mv_bom_item_comp_header  mv
WHERE mv.preferred	= 1 
and   abs(mv.comp_preferred) = 1
UNION ALL
SELECT mv2.component_part                          AS part_no
, convert(integer, mv2.comp_revision )                as revision 
, mv2.plant                                      as plant
, mv2.item_number
, mv2.status                                  as status
, t.part_no                                        AS parent_part
, convert(integer, t.revision )                  AS parent_rev
, t.status                                         AS parent_status
, mv2.alternative
, mv2.preferred
, mv2.phr_num_5            AS phr
, mv2.quantity
--, b2.num_1                                         AS density
--, t.root_density
, mv2.uom
, mv2.characteristic                              as characteristic
, t.issued_date
, t.root_part
, t.root_rev
, t.root_status
, t.root_alternative
, t.root_preferred
, t.root_issued_date
, cast(t.lvl +1  as integer)                                          AS lvl
, RPAD('.', (t.lvl)*2, '.') || t.lvl+1                              AS lvl_tree
, cast(substring(t.path || '.' || t.pathNode, 1, 120) as VARchar(120))    AS path
, to_char(mv2.item_number, '0999')                         AS pathNode
, t.branch                                                AS parent_branch
, t.item_number                                           AS parent_seq
, mv2.base_quantity                                       AS parent_quantity
, cast(DECODE(mv2.base_quantity, 0, 0, mv2.quantity * t.normalized_quantity / mv2.base_quantity) as decimal)   AS normalized_quantity
--, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1)                                             AS component_volume
--, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity / bh2.base_quantity), 1.0 )                       AS volume
--, DECODE(b2.num_1, 0, 0, b2.quantity / b2.num_1) * coalesce(t.volume,DECODE(bh2.base_quantity, 0, 0, b2.quantity * t.normalized_quantity / bh2.base_quantity),1.0) AS normalized_volume
--, CAST(t.volume AS DECIMAL)                                                                     AS parent_volume
, cast(substring(t.branch || '.' || to_char(mv2.item_number, '0999'), 1, 100) as varchar(200))     AS branch
, CAST(substring(t.indentStr || ';' , 1, 200)  AS VARCHAR(200) )                                AS indentStr
, CAST(substring(t.breadcrumbs || ' / ' || mv2.part_no, 1, 200)   AS VARCHAR(200) )              AS breadcrumbs
FROM tree         t
JOIN sc_interspec_ens.mv_bom_item_comp_header  mv2 ON (mv2.part_no = t.part_no  AND convert(integer, mv2.revision) = convert(integer, t.revision) AND mv2.plant = t.plant and mv2.preferred = 1 and abs(mv2.comp_preferred) = 1)
--JOIN bom_header bh2 ON ( bh2.part_no = t.part_no   AND bh2.revision = t.revision   AND bh2.plant = t.plant   AND bh2.alternative = t.alternative AND bh2.preferred = 1 )
--JOIN bom_item    b2 ON ( b2.part_no	 = bh2.part_no AND b2.revision  = bh2.revision AND b2.plant  = bh2.plant AND b2.alternative  = bh2.alternative )
WHERE t.lvl < 12
)
select * 
from tree tt
--where tt.root_part = 'EG_L650/65R42-174G'  --'EF_650/65R42TRO174'   --'XEM_B23-1748_01'   --XEM_B24-1198
order by tt.root_part
,        tt.lvl
,        tt.parent_part
,        tt.item_number
;
