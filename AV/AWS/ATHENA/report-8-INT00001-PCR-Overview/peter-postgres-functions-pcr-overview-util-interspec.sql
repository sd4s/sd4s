--POSTGRES-INTERSPEC-FUNCTIONS TBV MATERIALIZED-VIEWS

--FUNCTIONS:
--1.BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, TEXT JSONB)
--2.BOM_EXPLODE(TEXT, TIMESTAMPTZ, NUMERIC, TEXT JSONB)
--3.BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, JSONB)
--4.BOM_EXPLODE(TEXT, TIMESTAMP, NUMERIC, TEXT JSONB)
--5.BOM_FUNCTION(JSONB, JSONB)
--6.BOM_IMPLODE*TEXT, NUMERIC, NUMERIC, TEXT, JSONB)
--7.PART_REVISION(VARCHAR, TIMESTAMP)
--8.PART2LTREE(TEXT)
--9.PART2LTXT(TEXT)

--********************************************************************************
--1.BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, TEXT JSONB)
--********************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.bom_explode(p_part_no text, p_revision numeric, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(part_no text, revision numeric, component_part_no text, component_revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean, quantity numeric, total_quantity numeric)
 LANGUAGE sql
 STABLE
AS $function$

with recursive
options as (
select *
from jsonb_to_record('{ "scenario": "CURRENT", "status_exclude": ["TEMP CRRNT"] }'::jsonb || p_options) as options(
			scenario			text
		,	refdate				timestamp
		,	function_path_query	lquery[]
		,	status_exclude		text[]
	  )
)
,tree (part_no
,   revision
,	component_part_no
,   component_revision
,   class3_id
,	plant, alternative, preferred
,	keywords
,	spec_function
,	level
,	item_number
,	bom_function
,	properties
,	hierarchy
,	part_path
,	function_path
,	parent_part_no, parent_revision
,	contains_cycle
,	quantity
,	total_quantity
) as 
(select	pl.part_no
    ,   pl.revision
	,	i.component_part
	,   comp_s.revision
	,   comp_s.class3_id
	,	i.plant
	,   i.alternative
	,   h.preferred
	,	comp_k.keywords
	--	spec_function
	,	coalesce(comp_k.keywords #>> '{Function, 0}', comp_k.keywords #>> '{Spec. Function, 0}', '(unknown)') 
	,	1
	,	i.item_number::integer
	--	bom_function
	,	util_interspec.bom_function(i.properties, comp_k.keywords)
	,	i.properties
	--	hierarchy
	,	replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree
	--	part_path
	,	util_interspec.path2ltree(pl.part_no) || util_interspec.path2ltree(i.component_part)
	--	function_path
	,	util_interspec.path2ltree(sk.keywords #>> '{Function, 0}') || util_interspec.path2ltree(util_interspec.bom_function(i.properties, comp_k.keywords)	)
	--	parent part
	,	pl.part_no, pl.revision
	--	contains_cycle
	,	pl.part_no = i.component_part
	--	calculated quantity
	,	i.quantity
	,	i.quantity
from util_interspec.specification_status      pl
join util_interspec.specification_keyword     sk using (part_no)
join rd_interspec_webfocus.bom_header          h using (part_no, revision)
join util_interspec.bom_item_property          i using (part_no, revision, plant, alternative, bom_usage)
join util_interspec.specification_status  comp_s on (comp_s.part_no = i.component_part)
join util_interspec.specification_keyword comp_k on (comp_k.part_no = comp_s.part_no)
cross join options                             o
left  join util_interspec.function_conversion fc on (fc.function = comp_k.keywords #>> '{Function, 0}')
where pl.part_no = p_part_no
and  (  (   pl.revision = p_revision and p_revision is not null) 
	    or (o.scenario = 'REFDATE' and o.refdate is not null and p_revision is null)
	 )
and h.alternative = p_alternative
and (p_plant is null or h.plant = p_plant)
-- option: scenario (+ refdate)
and (  (   o.scenario = 'CURRENT'
 	   and comp_s.status_type = 'CURRENT'
       and (   o.status_exclude = '{}' 
           or comp_s.status_code <> any(o.status_exclude)  
           )
       )
    or  (    o.scenario = 'HIGHEST'
        and comp_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
		and not exists (select 1
                        from util_interspec.specification_status higher_s
                        where higher_s.part_no		= comp_s.part_no
                        and higher_s.revision	> comp_s.revision
                        and higher_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
                       )
		)
    or  (    o.scenario = 'REFDATE'
	    and o.refdate is not null
		and o.refdate <@ pl.validity_range
		and pl.status_type in ('HISTORIC', 'CURRENT')
		and o.refdate <@ comp_s.validity_range
		and comp_s.status_type in ('HISTORIC', 'CURRENT')
		and (    o.status_exclude = '{}'
			or (   comp_s.status_code <> any(o.status_exclude)
               and pl.status_code <> any(o.status_exclude)
		       )
            )
		)
    )
    -- option: function_path_query
and (  o.function_path_query is null
    or util_interspec.path2ltree(sk.keywords #>> '{Function, 0}')|| util_interspec.path2ltree(util_interspec.bom_function(i.properties, comp_k.keywords)) ? o.function_path_query
    )
union all
select	t.part_no
	,   t.revision
	,	i.component_part
	,   comp_s.revision
	,   comp_s.class3_id
	,	i.plant
	,   i.alternative
	,    h.preferred
	,	comp_k.keywords
	--	spec_function
	,	coalesce(comp_k.keywords #>> '{Function, 0}', comp_k.keywords #>> '{Spec. Function, 0}','(unknown)')
	,	t.level +1
	,	i.item_number::integer
	--	bom_function
	,	util_interspec.bom_function(i.properties, comp_k.keywords)
	,	i.properties
	--	hierarchy
	,	t.hierarchy || replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree
	--	part_path
	,	t.part_path || util_interspec.path2ltree(i.component_part)
	--	function_path
	,	t.function_path	|| util_interspec.path2ltree(util_interspec.bom_function(i.properties, comp_k.keywords)	)
	,	t.component_part_no, t.component_revision
	--	contains_cycle
	,	t.part_path @ util_interspec.path2ltxt(i.component_part)::ltxtquery
	--	calculated quantity
	,	i.quantity
	,	(case h.base_quantity	when 0 then 0
			                    else i.quantity * t.total_quantity / h.base_quantity
  		 end)::numeric(18, 6) 
from tree t
join rd_interspec_webfocus.bom_header h on (   h.part_no		= t.component_part_no
										   and h.revision		= t.component_revision
 		                                   and h.plant		= t.plant
		                                   and h.preferred    = 1
	                                       )
join util_interspec.bom_item_property i on (   i.part_no		= h.part_no
                                         and i.revision		= h.revision
                                         and i.plant		= h.plant
                                         and i.alternative	= h.alternative
                                         and i.bom_usage	= h.bom_usage
                                           )
join util_interspec.specification_status  comp_s on (comp_s.part_no = i.component_part)
join util_interspec.specification_keyword comp_k on (comp_k.part_no = comp_s.part_no)
cross join options o
left join util_interspec.function_conversion fc on (fc.function = comp_k.keywords #>> '{Function, 0}')
where not t.contains_cycle
-- option: scenario (+ refdate)
and (   (    o.scenario = 'CURRENT'
		and comp_s.status_type = 'CURRENT'
		and (o.status_exclude = '{}' or comp_s.status_code <> any(o.status_exclude))
		)
	or  (    o.scenario = 'HIGHEST'
		and comp_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
		and not exists (select 1
					    from util_interspec.specification_status    higher_s
					    where higher_s.part_no		= comp_s.part_no
					    and higher_s.revision	    > comp_s.revision
					    and higher_s.status_type    in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
				       )
	    )
    or  (    o.scenario = 'REFDATE'
		and o.refdate is not null
		and o.refdate <@ comp_s.validity_range
		and comp_s.status_type in ('HISTORIC', 'CURRENT')
		and (o.status_exclude = '{}' or comp_s.status_code <> any(o.status_exclude))
	   )
   )
-- option: function_path_query
and (  o.function_path_query is null
    or t.function_path|| util_interspec.path2ltree(util_interspec.bom_function(i.properties, comp_k.keywords)) ? o.function_path_query
    )
)
select part_no
,	revision
,	component_part_no
,	component_revision
,	class3_id
,	plant
,	alternative
,	preferred
,	keywords
,	spec_function
,	level
,	item_number
,	bom_function
,	properties
,	hierarchy
,	part_path
,	function_path
,	contains_cycle
,	quantity
,	total_quantity
from tree;

$function$
;


--*******************************************************************************************************************
--2.BOM_EXPLODE(TEXT, TIMESTAMPTZ, NUMERIC, TEXT JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.bom_explode(p_part_no text, p_reference_date timestamp with time zone, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(part_no text, revision numeric, component_part_no text, component_revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean, quantity numeric, total_quantity numeric)
 LANGUAGE sql
 STABLE STRICT
AS $function$

select *
from util_interspec.bom_explode(p_part_no,	null::int,	p_alternative,	p_plant,  p_options||jsonb_build_object('scenario', 'REFDATE', 'refdate', p_reference_date) );

$function$
;

--*******************************************************************************************************************
--3.BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.bom_explode(p_part_no text, p_revision numeric, p_alternative numeric, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(part_no text, revision numeric, component_part_no text, component_revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean, quantity numeric, total_quantity numeric)
 LANGUAGE sql
 STABLE STRICT
AS $function$

select * 
from util_interspec.bom_explode(p_part_no, p_revision, p_alternative, null::text, p_options);

$function$
;



--*******************************************************************************************************************
--4.BOM_EXPLODE(TEXT, TIMESTAMP, NUMERIC, TEXT JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.bom_explode(p_part_no text, p_reference_date timestamp without time zone, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(part_no text, revision numeric, component_part_no text, component_revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean, quantity numeric, total_quantity numeric)
 LANGUAGE sql
 STABLE STRICT
AS $function$

select *
from util_interspec.bom_explode(p_part_no,	null::int,	p_alternative,	p_plant,	p_options || jsonb_build_object('scenario', 'REFDATE', 'refdate', p_reference_date) );

$function$
;

--*******************************************************************************************************************
--5.BOM_FUNCTION(JSONB, JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.bom_function(properties jsonb, keywords jsonb)
 RETURNS text
 LANGUAGE plpgsql
 STABLE
AS $function$
begin

	return coalesce(properties ->> 'FUNCTIONCODE'
	,	(select bom_function from util_interspec.function_conversion where function = keywords #>> '{Function, 0}')
	,	keywords #>> '{Function, 0}'
	,	keywords #>> '{Spec. Function, 0}'
	,	'None'
	);

end;

$function$
;


--*******************************************************************************************************************
--6.BOM_IMPLODE*TEXT, NUMERIC, NUMERIC, TEXT, JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.bom_implode(p_part_no text, p_revision numeric, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(component_part_no text, component_revision numeric, part_no text, revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean)
 LANGUAGE sql
 STABLE
AS $function$

with recursive
options as (
select *
from jsonb_to_record('{ "scenario": "CURRENT" }'::jsonb || p_options) as options(
			scenario			text
		,	refdate				timestamp
		,	function_path_query	lquery[]
	  )
)
,tree (component_part_no
,   component_revision
,	part_no
,   revision
,   class3_id
,	plant
,   alternative
,   preferred
,	keywords
,	spec_function
,	level
,	item_number
,	bom_function
,	properties
,	hierarchy
,	part_path
,	function_path
,	child_part_no, child_revision
,	contains_cycle
) as 
(select	pl.part_no
 ,      pl.revision
 ,	    i.part_no
 ,      i.revision
 ,      part_s.class3_id
 ,      i.plant
 ,      i.alternative
 ,      h.preferred
 ,      part_k.keywords
--	spec_function
 ,      coalesce( part_k.keywords #>> '{Function, 0}'
                , part_k.keywords #>> '{Spec. Function, 0}'
                , '(unknown)' )             AS SPEC_FUNCTION
 ,      1                                   AS LEVEL
 ,      i.item_number::integer
--	bom_function
 ,      util_interspec.bom_function(i.properties, part_k.keywords)
 ,      i.properties
	--	hierarchy
	,	replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree
	--	part_path
	,	util_interspec.path2ltree(pl.part_no)|| util_interspec.path2ltree(i.part_no)
	--	function_path
	,	util_interspec.path2ltree(util_interspec.bom_function(i.properties, sk.keywords))
	--	child_part
	,	pl.part_no, pl.revision
	--	contains_cycle
	,	pl.part_no = i.part_no
from util_interspec.specification_status pl
join util_interspec.specification_keyword sk using (part_no)
join util_interspec.bom_item_property i on (i.component_part	= pl.part_no)
join rd_interspec_webfocus.bom_header h	on (   h.part_no		= i.part_no
			                               and h.revision		= i.revision
 			                               and h.plant			= i.plant
			                               and h.alternative	= i.alternative
			                               and h.bom_usage		= i.bom_usage
		                                   )
join util_interspec.specification_status part_s 	on (part_s.part_no = i.part_no and part_s.revision = i.revision)
join util_interspec.specification_keyword part_k on (part_k.part_no = part_s.part_no)
cross join options o
where pl.part_no		= p_part_no
and pl.revision		= p_revision
and h.alternative	= p_alternative
and (p_plant is null or h.plant = p_plant)
-- option: scenario (+ refdate)
and (  (   o.scenario = 'CURRENT'
       and part_s.status_type = 'CURRENT'
       and part_s.status_code not in ('TEMP CRRNT')
       )
    or (   o.scenario = 'HIGHEST'
       and part_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
       and not exists (select 1
 					   from util_interspec.specification_status higher_s
					   where higher_s.part_no		= part_s.part_no
					   and   higher_s.revision	> part_s.revision
					   and   higher_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
				      )
		)
   or	(   o.scenario = 'REFDATE'
		and o.refdate is not null
		and o.refdate <@ part_s.validity_range
		and part_s.status_type in ('HISTORIC', 'CURRENT')
		and part_s.status_code <> 'TEMP CRRNT'
		)		
	)
-- option: function_path_query
and (	o.function_path_query is null
	or	util_interspec.path2ltree(util_interspec.bom_function(i.properties, sk.keywords)) ? o.function_path_query	
	)
union all
select	t.part_no
    ,   t.revision
	,	i.part_no, i.revision, part_s.class3_id
	,	i.plant, i.alternative, h.preferred
	,	part_k.keywords
	--	spec_function
	,	coalesce(
			part_k.keywords #>> '{Function, 0}'
		,	part_k.keywords #>> '{Spec. Function, 0}'
		,	'(unknown)'
		)
	,	t.level +1
	,	i.item_number::integer
	--	bom_function
	,	util_interspec.bom_function(i.properties, part_k.keywords)
	,	i.properties
	--	hierarchy
	,	t.hierarchy || replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree
	--	part_path
	,	t.part_path || util_interspec.path2ltree(i.part_no)
	--	function_path
	,	t.function_path	|| util_interspec.path2ltree(util_interspec.bom_function(i.properties, part_k.keywords)	)
	,	t.component_part_no, t.component_revision
	--	contains_cycle
	,	t.part_path @ util_interspec.path2ltxt(i.part_no)::ltxtquery
from tree t
join util_interspec.bom_item_property i on (   i.component_part = t.part_no  and i.plant = t.plant )
join rd_interspec_webfocus.bom_header h on (   h.part_no		= i.part_no
		                                   and	h.revision		= i.revision
 		                                   and	h.plant			= i.plant
		                                   and	h.bom_usage		= i.bom_usage
		                                   and h.preferred		= 1
	                                       )
join util_interspec.specification_status part_s on (part_s.part_no	= i.part_no and	part_s.revision	= i.revision )
join util_interspec.specification_keyword part_k on (part_k.part_no = part_s.part_no)
cross join options o
where not t.contains_cycle
-- option: scenario (+refdate)
and (  (   o.scenario = 'CURRENT'
		and part_s.status_type = 'CURRENT'
	   )
    or	(   o.scenario = 'HIGHEST'
		and part_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
		and not exists (select 1
					    from util_interspec.specification_status higher_s
					    where higher_s.part_no		= part_s.part_no
					    and higher_s.revision	> part_s.revision
					    and higher_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
					    and higher_s.status_code not in ('TEMP CRRNT')
				       )
		)
	or	(   o.scenario = 'REFDATE'
		and o.refdate is not null
		and o.refdate <@ part_s.validity_range
		and part_s.status_type in ('HISTORIC', 'CURRENT')
		)
	)
and part_s.status_code not in ('TEMP CRRNT')
-- option: function_path_query
and (   o.function_path_query is null
    or t.function_path || util_interspec.path2ltree(util_interspec.bom_function(i.properties, part_k.keywords) ) ? o.function_path_query
	)
)
select component_part_no
,	component_revision
,	part_no
,	revision
,	class3_id
,	plant
,	alternative
,	preferred
,	keywords
,	spec_function
,	level
,	item_number
,	bom_function
,	properties
,	hierarchy
,	part_path
,	function_path
,	contains_cycle
from tree;

$function$
;



--*******************************************************************************************************************
--7.PART_REVISION(VARCHAR, TIMESTAMP)
--*******************************************************************************************************************
--
CREATE OR REPLACE FUNCTION util_interspec.part_revision(p_part_no character varying, p_reference_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP)
 RETURNS TABLE(part_no character varying, revision numeric, issued_date timestamp without time zone, obsolescence_date timestamp without time zone, status_change_date timestamp without time zone, status numeric, status_type character varying)
 LANGUAGE sql
AS $function$

select	h.part_no
	,	h.revision
	,	h.issued_date
	,	h.obsolescence_date
	,	h.status_change_date
	,	h.status
	,	s.status_type
from rd_interspec_webfocus.specification_header h
join rd_interspec_webfocus.status s using (status)
where h.part_no = p_part_no
 and (   (s.status_type = 'HISTORIC' and p_reference_date between h.issued_date and h.obsolescence_date)
     or (s.status_type = 'CURRENT' and p_reference_date >= h.issued_date and h.obsolescence_date is null)
     or (s.status_type = 'DEVELOPMENT' and not exists (select 1
			                                           from rd_interspec_webfocus.specification_header old
			                                           where old.part_no = h.part_no
			                                           and old.revision < h.revision
			                                           and p_reference_date >= old.issued_date
			                                           and (  p_reference_date < old.obsolescence_date 
													       or old.obsolescence_date is null
														   )
		                                               )
	    )
	);
$function$
;

--*******************************************************************************************************************
--8.PART2LTREE(TEXT)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.path2ltree(path text)
 RETURNS ltree
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
begin

	return util_interspec.path2ltxt(path)::ltree;

end;
$function$
;


--*******************************************************************************************************************
--9.PART2LTXT(TEXT)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION util_interspec.path2ltxt(path text)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
begin

	return regexp_replace(path, '[^[:alnum:]]', '_', 'g');

end;
$function$
;


--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
--*******************************************************************************************************************
