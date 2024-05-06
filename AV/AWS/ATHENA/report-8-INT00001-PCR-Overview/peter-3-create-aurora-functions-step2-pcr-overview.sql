--INTERSPEC-FUNCTIONS TBV MATERIALIZED-VIEWS
--translation-table postgres-tables / aurora-tables
--******************************************************************************************
--POSTGRES-FUNCTIONS IN SCHEMA UTIL_INTERSPEC MIGREREN NAAR AURORA.SC_LIMS_DAL !!!!!!
--******************************************************************************************
--/*
--UTIL_INTERSPEC-FUNCTIONS
--STEP1-VIEWS:
--9.PATH2LTXT(TEXT)
--8.PATH2LTREE(TEXT)
--5.BOM_FUNCTION(JSONB, JSONB)
--*/
--
--STEP2-VIEWS
--1.BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, TEXT, JSONB)
--2.BOM_EXPLODE(TEXT, TIMESTAMPTZ, NUMERIC, TEXT, JSONB)
--3.BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, JSONB)
--4.BOM_EXPLODE(TEXT, TIMESTAMP, NUMERIC, TEXT JSONB)
--6.BOM_IMPLODE(TEXT, NUMERIC, NUMERIC, TEXT, JSONB)
--7.PART_REVISION(VARCHAR, TIMESTAMP)


--WHEN CREATING BOM-EXPLODE-4: SQL Error [42883]: ERROR: function sc_lims_dal.bom_explode(text, numeric, numeric, text, jsonb) does not exist


/*
--*******************************************************************************************************************
--9.PATH2LTXT(TEXT)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_path2ltxt(path text)
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
--8.PATh2LTREE(TEXT)
--
--AFHANKELIJKHEDEN:    FNC_PATH2LTXT
--
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_path2ltree(path text)
 RETURNS ltree
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
begin
	return sc_lims_dal.fnc_path2ltxt(path)::ltree;
end;
$function$
;


--*******************************************************************************************************************
--5.BOM_FUNCTION(JSONB, JSONB)
--
--AFHANKELIJKHEDEN:    TABLE: PCR_FUNCTION_CONVERSION
--
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_bom_function(properties jsonb, keywords jsonb)
 RETURNS text
 LANGUAGE plpgsql
 STABLE
AS $function$
begin
	return coalesce(properties ->> 'FUNCTIONCODE'
	,	(select bom_function from sc_lims_dal.pcr_function_conversion where function = keywords #>> '{Function, 0}')
	,	keywords #>> '{Function, 0}'
	,	keywords #>> '{Spec. Function, 0}'
	,	'None'
	);
end;

$function$
;
*/

--********************************************************************************
--1.FNC_BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, TEXT, JSONB)
--
--AFHANKELIJKHEDEN:  FNC_BOM_FUNCTION
--                   fnc_path2ltxt
--                   FNC_PATH2LTREE   
--                   mv_specification_status
--                   mv_specification_keyword
--                   mv_bom_item_property
--
--PARAMETER P_OPTIONS coming from MV: 
/*
select jsonb_build_object('function_path_query' 
                         , '{*.Bead|Bead_apex|Belt*|Capply|Capstrip|Greentyre|Innerliner|Innerliner_assembly|Pre_Assembly|Ply*|Rubberstrip|Sidewall*|Tread|Tyre|Vulcanized_tyre|Tyre_vulcanized , *.Tread.Compound|Tread_compound, *.Capstrip.Capply, *.Ply*|Belt*.Racknumber|Composite }');
*/
--RESULT:
--{"function_path_query": "{*.Bead|Bead_apex|Belt*|Capply|Capstrip|Greentyre|Innerliner|Innerliner_assembly|Pre_Assembly|Ply*|Rubberstrip|Sidewall*|Tread|Tyre|Vulcanized_tyre|Tyre_vulcanized , *.Tread.Compound|Tread_compound, *.Capstrip.Capply, *.Ply*|Belt*.Racknumber|Composite }"}
--
--P-OPTIONS-JSON-structure used for JSONB_TO_RECORD:
-- 
/*
select * 
from jsonb_to_record('{ "scenario": "CURRENT", "status_exclude": ["TEMP CRRNT"] }'::jsonb || '{ "function_path_query": "{*.Bead|Bead_apex|Belt*|Capply|Capstrip|Greentyre|Innerliner|Innerliner_assembly|Pre_Assembly|Ply*|Rubberstrip|Sidewall*|Tread|Tyre|Vulcanized_tyre|Tyre_vulcanized , *.Tread.Compound|Tread_compound, *.Capstrip.Capply, *.Ply*|Belt*.Racknumber|Composite }" }'::jsonb ) as options(
			scenario			text
		,	refdate				timestamp
		,	function_path_query	lquery[]
		,	status_exclude		text[]
		)
*/
--RESULT:
--scenario	refdate	function_path_query	                                                                                                                                                                                                                                        status_exclude
--CURRENT	[NULL]	{*.Bead|Bead_apex|Belt*|Capply|Capstrip|Greentyre|Innerliner|Innerliner_assembly|Pre_Assembly|Ply*|Rubberstrip|Sidewall*|Tread|Tyre|Vulcanized_tyre|Tyre_vulcanized,*.Tread.Compound|Tread_compound,*.Capstrip.Capply,*.Ply*|Belt*.Racknumber|Composite}	{"TEMP CRRNT"}
--
--********************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_bom_explode(p_part_no text, p_revision numeric, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
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
,	parent_part_no
,   parent_revision
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
	,	coalesce(comp_k.keywords #>> '{Function, 0}', comp_k.keywords #>> '{Spec. Function, 0}', '(unknown)')    as spec_function
	,	1                                                                                                        as level
	,	i.item_number::integer                                                                                   as item_number
	,	sc_lims_dal.fnc_bom_function(i.properties, comp_k.keywords)                                              as bom_function
	,	i.properties
	,	replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree                                              as hierarchy
	,	sc_lims_dal.fnc_path2ltree(pl.part_no) || sc_lims_dal.fnc_path2ltree(i.component_part)                   as part_path
	,	sc_lims_dal.fnc_path2ltree(sk.keywords #>> '{Function, 0}') || sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function( i.properties, comp_k.keywords)	)  as function_path
	,	pl.part_no                       as parent_part_no
	,   pl.revision                      as parent_revision
	,	pl.part_no = i.component_part    as contains_cycle
	,	i.quantity                       as quantity
	,	i.quantity                       as total_quantity
from sc_lims_dal.mv_specification_status      pl
join sc_lims_dal.mv_specification_keyword     sk using (part_no)
join sc_interspec_ens.bom_header               h using (part_no, revision)
join sc_lims_dal.mv_bom_item_property          i using (part_no, revision, plant, alternative, bom_usage)
join sc_lims_dal.mv_specification_status  comp_s on (comp_s.part_no = i.component_part)
join sc_lims_dal.mv_specification_keyword comp_k on (comp_k.part_no = comp_s.part_no)
cross join options                             o
left  join sc_lims_dal.pcr_function_conversion fc on (fc.function = comp_k.keywords #>> '{Function, 0}')
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
                        from sc_lims_dal.mv_specification_status higher_s
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
    or sc_lims_dal.fnc_path2ltree(sk.keywords #>> '{Function, 0}')|| sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function(i.properties, comp_k.keywords)) ? o.function_path_query
    )
union all
select	t.part_no
	,   t.revision
	,	i.component_part
	,   comp_s.revision
	,   comp_s.class3_id
	,	i.plant
	,   i.alternative
	,   h.preferred
	,	comp_k.keywords
	,	coalesce(comp_k.keywords #>> '{Function, 0}', comp_k.keywords #>> '{Spec. Function, 0}','(unknown)')    as spec_function    	--	spec_function
	,	t.level +1                                                                                              as level
	,	i.item_number::integer                                                                                  as item_number
	,	sc_lims_dal.fnc_bom_function(i.properties, comp_k.keywords)                             	            as bom_function
	,	i.properties
	,	t.hierarchy || replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree                  	        as hierarchy
	,	t.part_path || sc_lims_dal.fnc_path2ltree(i.component_part)                                    	        as part_path
	,	t.function_path	|| sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function( i.properties, comp_k.keywords)	)     	as function_path
	,	t.component_part_no                                                        as parent_part_no
	,   t.component_revision                                                       as parent_revision
	,	t.part_path @ sc_lims_dal.fnc_path2ltxt( i.component_part)::ltxtquery               	                          AS contains_cycle
	,	i.quantity                                                                             	                          AS quantity
	,	(case h.base_quantity when 0 then 0 else i.quantity * t.total_quantity / h.base_quantity end)::numeric(17, 7)     AS total_quantity
from tree t
join sc_interspec_ens.bom_header h on      (   h.part_no		= t.component_part_no
										   and h.revision		= t.component_revision
 		                                   and h.plant		= t.plant
		                                   and h.preferred    = 1
	                                       )
join sc_lims_dal.mv_bom_item_property i on ( i.part_no		= h.part_no
                                         and i.revision		= h.revision
                                         and i.plant		= h.plant
                                         and i.alternative	= h.alternative
                                         and i.bom_usage	= h.bom_usage
                                           )
join sc_lims_dal.mv_specification_status  comp_s on (comp_s.part_no = i.component_part)
join sc_lims_dal.mv_specification_keyword comp_k on (comp_k.part_no = comp_s.part_no)
cross join options o
left join sc_lims_dal.pcr_function_conversion fc on (fc.function = comp_k.keywords #>> '{Function, 0}')
where not t.contains_cycle
-- option: scenario (+ refdate)
and (   (    o.scenario = 'CURRENT'
		and comp_s.status_type = 'CURRENT'
		and (o.status_exclude = '{}' or comp_s.status_code <> any(o.status_exclude))
		)
	or  (    o.scenario = 'HIGHEST'
		and comp_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
		and not exists (select 1
					    from sc_lims_dal.mv_specification_status    higher_s
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
    or t.function_path|| sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function( i.properties, comp_k.keywords)) ? o.function_path_query
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


/*
SQL Error [42804]: ERROR: recursive query "tree" column 22 has type numeric(17,7) in non-recursive term but type numeric overall
  Hint: Cast the output of the non-recursive term to the correct type.
  Position: 2580

Error position: line: 61 pos: 2579
*/


--*******************************************************************************************************************
--2.BOM_EXPLODE(TEXT, TIMESTAMPTZ, NUMERIC, TEXT, JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_bom_explode(p_part_no text, p_reference_date timestamp with time zone, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(part_no text, revision numeric, component_part_no text, component_revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean, quantity numeric, total_quantity numeric)
 LANGUAGE sql
 STABLE STRICT
AS $function$

select *
from sc_lims_dal.fnc_bom_explode(p_part_no,	null::int,	p_alternative,	p_plant,  p_options||jsonb_build_object('scenario', 'REFDATE', 'refdate', p_reference_date) );

$function$
;

--*******************************************************************************************************************
--3.BOM_EXPLODE(TEXT, NUMERIC, NUMERIC, JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_bom_explode(p_part_no text, p_revision numeric, p_alternative numeric, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(part_no text, revision numeric, component_part_no text, component_revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean, quantity numeric, total_quantity numeric)
 LANGUAGE sql
 STABLE STRICT
AS $function$

select * 
from sc_lims_dal.fnc_bom_explode(p_part_no, p_revision, p_alternative, null::text, p_options);

$function$
;



--*******************************************************************************************************************
--4.BOM_EXPLODE(TEXT, TIMESTAMP, NUMERIC, TEXT, JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_bom_explode(p_part_no text, p_reference_date timestamp without time zone, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
 RETURNS TABLE(part_no text, revision numeric, component_part_no text, component_revision numeric, class3_id numeric, plant text, alternative numeric, preferred numeric, keywords jsonb, spec_function text, level integer, item_number integer, bom_function text, properties jsonb, hierarchy ltree, part_path ltree, function_path ltree, contains_cycle boolean, quantity numeric, total_quantity numeric)
 LANGUAGE sql
 STABLE STRICT
AS $function$

select *
from sc_lims_dal.fnc_bom_explode(p_part_no, null::decimal, p_alternative, p_plant, p_options || jsonb_build_object('scenario', 'REFDATE', 'refdate', p_reference_date) );

$function$
;


/*
SQL Error [42883]: ERROR: function sc_lims_dal.bom_explode(text, integer, numeric, text, jsonb) does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 676
Error position: line: 8 pos: 675

--CAST INT TO DECIMAL
*/


--*******************************************************************************************************************
--6.BOM_IMPLODE*TEXT, NUMERIC, NUMERIC, TEXT, JSONB)
--*******************************************************************************************************************
CREATE OR REPLACE FUNCTION sc_lims_dal.fnc_bom_implode(p_part_no text, p_revision numeric, p_alternative numeric, p_plant text DEFAULT NULL::text, p_options jsonb DEFAULT '{}'::jsonb)
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
 ,      coalesce( part_k.keywords #>> '{Function, 0}'
                , part_k.keywords #>> '{Spec. Function, 0}'
                , '(unknown)' )                                         AS SPEC_FUNCTION
 ,      1                                                               AS LEVEL
 ,      i.item_number::integer                                          AS ITEM_NUMBER
 ,      sc_lims_dal.fnc_bom_function(i.properties, part_k.keywords)     AS bom_function
 ,      i.properties
	,	replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree     AS hierarchy
	,	sc_lims_dal.fnc_path2ltree(pl.part_no)|| sc_lims_dal.fnc_path2ltree(i.part_no)  	AS part_path
	,	sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function( i.properties, sk.keywords))  AS function_path
	,	pl.part_no    AS child_part
	,   pl.revision
	,	pl.part_no = i.part_no   AS contains_cycle
from sc_lims_dal.mv_specification_status pl
join sc_lims_dal.mv_specification_keyword sk using (part_no)
join sc_lims_dal.mv_bom_item_property i on (i.component_part	= pl.part_no)
join sc_interspec_ens.bom_header      h	on (   h.part_no		= i.part_no
			                               and h.revision		= i.revision
 			                               and h.plant			= i.plant
			                               and h.alternative	= i.alternative
			                               and h.bom_usage		= i.bom_usage
		                                   )
join sc_lims_dal.mv_specification_status    part_s on (part_s.part_no = i.part_no and part_s.revision = i.revision)
join sc_lims_dal.mv_specification_keyword   part_k on (part_k.part_no = part_s.part_no)
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
 					   from sc_lims_dal.mv_specification_status   higher_s
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
	or	sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function( i.properties, sk.keywords)) ? o.function_path_query	
	)
union all
select	t.part_no
    ,   t.revision
	,	i.part_no, i.revision, part_s.class3_id
	,	i.plant, i.alternative, h.preferred
	,	part_k.keywords
	,	coalesce(part_k.keywords #>> '{Function, 0}',	part_k.keywords #>> '{Spec. Function, 0}',	'(unknown)'	)  	AS spec_function
	,	t.level +1                                                                                                  AS LEVEL
	,	i.item_number::integer
	,	sc_lims_dal.fnc_bom_function(i.properties, part_k.keywords)                                                 AS bom_function
	,	i.properties
	,	t.hierarchy || replace(to_char(i.item_number, 'FM0999'), '-0', '_')::ltree                   	            AS hierarchy
	,	t.part_path || sc_lims_dal.fnc_path2ltree(i.part_no)                                     	                AS part_path
	,	t.function_path	|| sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function( i.properties, part_k.keywords)	)  	AS function_path
	,	t.component_part_no
	,   t.component_revision
	,	t.part_path @ sc_lims_dal.fnc_path2ltxt( i.part_no)::ltxtquery    	AS contains_cycle
from tree t
join sc_lims_dal.mv_bom_item_property i on (   i.component_part = t.part_no  and i.plant = t.plant )
join sc_interspec_ens.bom_header      h on (   h.part_no		= i.part_no
		                                   and	h.revision		= i.revision
 		                                   and	h.plant			= i.plant
		                                   and	h.bom_usage		= i.bom_usage
		                                   and h.preferred		= 1
	                                       )
join sc_lims_dal.mv_specification_status part_s on (part_s.part_no	= i.part_no and	part_s.revision	= i.revision )
join sc_lims_dal.mv_specification_keyword part_k on (part_k.part_no = part_s.part_no)
cross join options o
where not t.contains_cycle
-- option: scenario (+refdate)
and (  (   o.scenario = 'CURRENT'
		and part_s.status_type = 'CURRENT'
	   )
    or	(   o.scenario = 'HIGHEST'
		and part_s.status_type in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
		and not exists (select 1
					    from sc_lims_dal.mv_specification_status   higher_s
					    where higher_s.part_no		= part_s.part_no
					    and   higher_s.revision	    > part_s.revision
					    and   higher_s.status_type  in ('HISTORIC', 'CURRENT', 'APPROVED', 'SUBMIT', 'DEVELOPMENT')
					    and   higher_s.status_code  not in ('TEMP CRRNT')
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
    or t.function_path || sc_lims_dal.fnc_path2ltree( sc_lims_dal.fnc_bom_function( i.properties, part_k.keywords) ) ? o.function_path_query
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
CREATE OR REPLACE FUNCTION sc_lims_dal.part_revision(p_part_no character varying, p_reference_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP)
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
from sc_interspec_ens.specification_header  h
join sc_interspec_ens.status                s using (status)
where h.part_no = p_part_no
 and (   (s.status_type = 'HISTORIC'   and p_reference_date between h.issued_date and h.obsolescence_date)
     or (s.status_type = 'CURRENT'     and p_reference_date >= h.issued_date      and h.obsolescence_date is null)
     or (s.status_type = 'DEVELOPMENT' and not exists (select 1
			                                           from sc_interspec_ens.specification_header old
			                                           where old.part_no       = h.part_no
			                                           and   old.revision      < h.revision
			                                           and   p_reference_date >= old.issued_date
			                                           and (  p_reference_date < old.obsolescence_date 
													       or old.obsolescence_date is null
														   )
		                                               )
	    )
	);
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
