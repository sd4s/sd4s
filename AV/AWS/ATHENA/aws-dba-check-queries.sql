--geef een query een query-category + query-id mee !
SELECT 'Reporting' AS query_category
,      'R1'        as query_id
,      me.* 
FROM method me
limit 100
;

--Vraag performance-info van deze query op mbv PG_CATALOG-system view STL_QUERY !!
SELECT sq.userid, sq.database, sq.label, sq.query, sq.querytxt, datediff(seconds, sq.starttime, sq.endtime) as duration, sq.aborted
FROM stl_query sq
WHERE sq.querytxt LIKE '%Reporting%'
--and sq.starttime >= '2018-04-15 00:00'
--and sq.endtime < '2018-04-15 23:59'
;
/*
101	db_dev_lims  default 24149352	SELECT sq.query, datediff(seconds, sq.starttime, sq.endtime) FROM stl_query sq WHERE sq.querytxt LIKE '%Reporting%' and sq.starttime >= '2018-04-15 00:00' and sq.endtime < '2018-04-15 23:59'   1	0
101	db_dev_lims  default 24149377	 SELECT sq.query, datediff(seconds, sq.starttime, sq.endtime) FROM stl_query sq WHERE sq.querytxt LIKE '%Reporting%' and sq.starttime >= '2018-04-15 00:00' and sq.endtime < '2018-04-15 23:59'  1	0
101	db_dev_lims  default 24149363	 SELECT sq.query, datediff(seconds, sq.starttime, sq.endtime) FROM stl_query sq WHERE sq.querytxt LIKE '%Reporting%' and sq.starttime >= '2018-04-15 00:00' and sq.endtime < '2018-04-15 23:59'  1	0
101	db_dev_lims  default 24149386	 SELECT sq.query, datediff(seconds, sq.starttime, sq.endtime) FROM stl_query sq WHERE sq.querytxt LIKE '%Reporting%' and sq.starttime >= '2018-04-15 00:00' and sq.endtime < '2018-04-15 23:59'  1	0
101	db_dev_lims  default 24149343	SELECT sq.query, datediff(seconds, sq.starttime, sq.endtime) FROM stl_query sq WHERE sq.querytxt LIKE '%Reporting%' and sq.starttime >= '2018-04-15 00:00' and sq.endtime < '2018-04-15 23:59'   5	0
*/


--**********************************************************
--conn superuser: Query table-statistics info, 
--**********************************************************
--To identify tables with missing or out-of-date statistics.
--The results are ordered from largest to smallest table
--The default ANALYZE threshold is 10 percent. This default means that the ANALYZE command skips a
--given table if fewer than 10 percent of the table's rows have changed since the last ANALYZE
SELECT  ti.schema||'.'||ti."table" tablename
,       ti.size                    table_size_mb
,       ti.stats_off               statistics_accuracy
FROM svv_table_info ti
WHERE ti.stats_off > 5.00
ORDER BY ti.size DESC
;
/*
sc_unilab_ens.utrq						248	7.12
sc_interspec_ens.specification_header	132	9.61
sc_unilab_ens.utprmt					96	8.63
sc_unilab_ens.utrtip					76	9.20
sc_unilab_ens.utppau					56	5.08
sc_unilab_ens.utlc						50	9.38
public.awsdms_history					44	8.81
sc_unilab_ens.utwsgkoutsource			20	6.83
*/
 
--run the following SQL command to identify columns used as predicates 
--You can also let Amazon Redshift choose which columns to analyze by specifying ANALYZE PREDICATE COLUMNS.
WITH predicate_column_info as (
SELECT ns.nspname AS schema_name
,      c.relname AS table_name
,      a.attnum as col_num
,      a.attname as col_name
, CASE WHEN 10002 = s.stakind1 THEN array_to_string(stavalues1, '||')
       WHEN 10002 = s.stakind2 THEN array_to_string(stavalues2, '||')
       WHEN 10002 = s.stakind3 THEN array_to_string(stavalues3, '||')
       WHEN 10002 = s.stakind4 THEN array_to_string(stavalues4, '||')
       ELSE NULL::varchar
   END AS pred_ts
FROM pg_statistic s
JOIN pg_class c ON c.oid = s.starelid
JOIN pg_namespace ns ON c.relnamespace = ns.oid 
JOIN pg_attribute a ON c.oid = a.attrelid AND a.attnum = s.staattnum
)
SELECT schema_name
,      table_name
,      col_num
,      col_name
,      pred_ts
,      pred_ts NOT LIKE '2000-01-01%' AS is_predicate
,      CASE WHEN pred_ts NOT LIKE '2000-01-01%' 
            THEN (split_part(pred_ts, '||',1))::timestamp 
			ELSE NULL::timestamp 
	   END as first_predicate_use
,      CASE WHEN pred_ts NOT LIKE '%||2000-01-01%' 
            THEN (split_part(pred_ts, '||',2))::timestamp 
			ELSE NULL::timestamp 
	   END as last_analyze
FROM predicate_column_info
;
/*
pg_automv			mv_tbl__auto_mv_16643703__0	1	grvar_1			2022-10-20 13:10:21.640257||2022-09-04 00:41:56.210122	true	2022-10-20 13:10:21.640257	2022-09-04 00:41:56.210122
sc_unilab_ens		utad						1	ad				2022-09-30 10:20:02.79645||2022-09-27 07:51:31.803997	true	2022-09-30 10:20:02.79645	2022-09-27 07:51:31.803997
sc_unilab_ens		utad						10	person			2022-09-30 10:20:02.796456||2022-09-27 07:51:31.804281	true	2022-09-30 10:20:02.796456	2022-09-27 07:51:31.804281
sc_unilab_ens		utrq						9	created_by		2022-09-30 10:20:02.796092||2021-10-08 12:11:58.649804	true	2022-09-30 10:20:02.796092	2021-10-08 12:11:58.649804
sc_unilab_ens		utrq						8	creation_date	2022-09-30 09:06:08.578283||2021-10-08 12:11:58.649744	true	2022-09-30 09:06:08.578283	2021-10-08 12:11:58.649744
sc_interspec_ens	reason						3	revision		2022-09-27 22:05:01.088434||2022-09-27 03:35:00.574484	true	2022-09-27 22:05:01.088434	2022-09-27 03:35:00.574484
sc_interspec_ens	reason						2	part_no			2022-09-27 22:05:01.088426||2022-09-27 03:35:00.57446	true	2022-09-27 22:05:01.088426	2022-09-27 03:35:00.57446
sc_interspec_ens	reason						1	id				2022-09-27 22:05:01.088415||2022-09-27 03:35:00.57428	true	2022-09-27 22:05:01.088415	2022-09-27 03:35:00.57428
sc_interspec_ens	header						2	description		2022-09-22 12:57:15.301543||2021-10-26 08:10:31.028381	true	2022-09-22 12:57:15.301543	2021-10-26 08:10:31.028381
sc_unilab_ens		utscme						24	assign_date		2022-09-22 09:27:53.296124||2021-10-08 12:57:16.813679	true	2022-09-22 09:27:53.296124	2021-10-08 12:57:16.813679
sc_unilab_ens		utscme						14	exec_end_date	2022-09-22 09:27:53.296121||2021-10-08 12:57:11.856411	true	2022-09-22 09:27:53.296121	2021-10-08 12:57:11.856411
sc_unilab_ens		utscme						13	exec_start_date	2022-09-22 09:27:53.296113||2021-10-08 12:57:11.856301	true	2022-09-22 09:27:53.296113	2021-10-08 12:57:11.856301
sc_interspec_ens	itkw						1	kw_id			2022-09-22 08:40:46.588876||2021-10-26 08:11:06.797081	true	2022-09-22 08:40:46.588876	2021-10-26 08:11:06.797081
sc_interspec_ens	frame_kw					2	kw_id			2022-09-22 08:40:46.588583||2021-10-26 08:10:16.776142	true	2022-09-22 08:40:46.588583	2021-10-26 08:10:16.776142
sc_unilab_ens		utscgkworkorder				2	sc				2022-09-21 14:45:35.820844||2021-10-08 12:23:33.221147	true	2022-09-21 14:45:35.820844	2021-10-08 12:23:33.221147
sc_unilab_ens		utrqhs						6	logdate			2022-09-21 14:24:11.536543||2021-10-08 12:59:45.79934	true	2022-09-21 14:24:11.536543	2021-10-08 12:59:45.79934
*/

--Short query acceleration (SQA) prioritizes selected short-running queries ahead of longer-running queries
--To check whether SQA is enabled, run the following query. If the query returns a row, then SQA is enabled.
select * 
from stv_wlm_service_class_config
where service_class = 14
;
/*
14	Predicted Time queue policy     	6	6	true    	0	30	30	5	Short query queue                                               	0	false   	false   	off                 	Normal              
*/

--The system view SVV_ALTER_TABLE_RECOMMENDATIONS records the current Amazon Redshift Advisor recommendations for tables. This view shows recommendations for all tables, those that are defined for
--                                                automatic optimization and those that are not.
--The system view SVL_AUTO_WORKER_ACTION shows an audit log of all the actions taken by the Amazon Redshift, and the previous state of the table.
--The system view SVV_TABLE_INFO         lists all of the tables in the system, along with a column to indicate whether the sort key and distribution style of the table is set to AUTO.
select database
,      schema
,      table_id
,      table
,      encoded
,      diststyle
,      sortkey1
,      max_varchar
,      sortkey1_enc
,      sortkey_num
,      size
,      pct_used
,      empty
,      unsorted
,      stats_off
,      tbl_rows
,      skew_sortkey1
,      skew_rows
,      estimated_visible_rows
,      risk_event
,      vacuum_sort_benefit
from  SVV_TABLE_INFO
;
/*
db_dev_lims	sc_unilab_ens	350223	utprmtau	Y, AUTO(ENCODE)	AUTO(EVEN)	AUTO(SORTKEY)	120		0	44	0.0115	0		0.87	36177			36131		
db_dev_lims	sc_unilab_ens	350203	utprhs	Y, AUTO(ENCODE)	AUTO(EVEN)	AUTO(SORTKEY)	765		0	56	0.0146	0		0.61	208369			208343		
db_dev_lims	sc_unilab_ens	350577	utscgksite	Y, AUTO(ENCODE)	AUTO(EVEN)	AUTO(SORTKEY)	120		0	20	0.0052	0		0.56	11980			11980		
db_dev_lims	sc_unilab_ens	350731	utscmegk	Y, AUTO(ENCODE)	AUTO(EVEN)	AUTO(SORTKEY)	120		0	1000	0.2622	0		0.14	37953169			37948488		
db_dev_lims	sc_unilab_ens	350804	utscmegklab	Y, AUTO(ENCODE)	AUTO(EVEN)	AUTO(SORTKEY)	120		0	96	0.0251	0		0.09	2669212			2669191		
db_dev_lims	public	444375	awsdms_txn_state	Y, AUTO(ENCODE)	AUTO(ALL)	AUTO(SORTKEY)	3072		0	14	0.0036	0		2.27	44			44		
db_dev_lims	sc_interspec_ens	444390	association	Y, AUTO(ENCODE)	AUTO(ALL)	AUTO(SORTKEY)	180		0	16	0.0041	0		0.00	232			232		
db_dev_lims	sc_interspec_ens	444841	specification_header	Y, AUTO(ENCODE)	AUTO(KEY(part_no))	AUTO(SORTKEY)	180		0	132	0.0346	0		9.61	194951		1.02	193563		
db_dev_lims	sc_interspec_ens	1729744	ref_text_type	Y, AUTO(ENCODE)	AUTO(ALL)	AUTO(SORTKEY)	210		0	24	0.0062	0		0.00	184			184		
db_dev_lims	sc_unilab_ens	350614	utscgkworkorder	Y, AUTO(ENCODE)	AUTO(EVEN)	AUTO(SORTKEY)	120		0	20	0.0052	0		0.13	200069			200054		
*/

--ENCODING
--use the ANALYZE COMPRESSION (p. 655) command to view the suggested encodings for the table.
analyze compression AI_METHOD;

select "tablename", "column", type, encoding
from pg_table_def where tablename like 'ai%'
;
/*
ai_method	sample_code	character varying(60)	none
ai_method	parameter_group	character varying(60)	none
ai_method	parameter_group_node	integer	none
ai_method	parameter	character varying(60)	none
ai_method	parameter_node	integer	none
ai_method	method	character varying(60)	none
ai_method	method_node	integer	none
ai_method	autorecalculation	character varying(3)	none
ai_method	confirm_complete	character varying(3)	none
ai_method	reanalysis	smallint	none
ai_method	sop	character varying(120)	none
ai_method	manually_added	character varying(3)	none
ai_method	manually_entered	character varying(3)	none
ai_method	allow_additional_measure	character varying(3)	none
ai_method	last_comment	character varying(765)	none
ai_method	description	character varying(120)	none
ai_method	version_description	character varying(60)	none
ai_method	version	character varying(60)	none
ai_method	delay_value	smallint	none
ai_method	delay_unit	character varying(60)	none
ai_method	result_unit	character varying(60)	none
ai_method	result_value_f	double precision	none
ai_method	result_value_s	character varying(120)	none
ai_method	result_format	character varying(120)	none
ai_method	planned_executor	character varying(60)	none
ai_method	executor	character varying(60)	none
ai_method	assigned_by	character varying(60)	none
ai_method	lab	character varying(60)	none
ai_method	planned_equipment	character varying(60)	none
ai_method	equipment	character varying(60)	none
ai_method	real_cost	character varying(120)	none
ai_method	real_time	character varying(120)	none
ai_method	life_cycle	character varying(6)	none
ai_method	life_cycle_description	character varying(120)	none
ai_method	status	character varying(6)	none
ai_method	status_description	character varying(60)	none
ai_method_cell	sample_code	character varying(60)	none
ai_method_cell	parameter_group	character varying(60)	none
ai_method_cell	parameter_group_node	integer	none
...
*/
--Distribution styles
--When you create a table, you can designate one of four distribution styles; AUTO, EVEN, KEY, or ALL.
--If you don't specify a distribution style, Amazon Redshift uses AUTO distribution.
--To view the distribution style of a table, query the PG_CLASS_INFO view or the SVV_TABLE_INFO view.
--The RELEFFECTIVEDISTSTYLE column in PG_CLASS_INFO indicates the current distribution style for the table.
/*
RELEFFECTIVEDISTSTYLE 	Current distribution style
0 						EVEN
1 						KEY
8 						ALL
10 						AUTO (ALL)
11 						AUTO (EVEN)
12 						AUTO (KEY)
*/

--EXPLAIN PLAN
explain
select * from ai_method limit 10
;
/*
XN Limit  (cost=103576333.26..1063143607.49 rows=2 width=367)
  ->  XN Hash Join DS_DIST_ALL_NONE  (cost=103576333.26..1063143607.49 rows=2 width=367)
        Hash Cond: (("outer".ss)::text = ("inner".ss)::text)
        ->  XN Hash Join DS_DIST_ALL_NONE  (cost=103576332.77..1063143606.95 rows=2 width=353)
              Hash Cond: (("outer".lc)::text = ("inner".lc)::text)
              ->  XN Hash IN Join DS_BCAST_INNER  (cost=103576332.37..1063143606.51 rows=2 width=331)
                    Hash Cond: (("outer".sc)::text = ("inner".sc)::text)
                    ->  XN Seq Scan on utscme scme  (cost=0.00..47262.22 rows=952 width=331)
                          Filter: (((pa)::text ~~ '%TT520AX%'::text) AND ((me)::text ~~ '%TT520%'::text) AND ((ss)::text = 'CM'::text))
                    ->  XN Hash  (cost=103576322.38..103576322.38 rows=3998 width=13)
                          ->  XN Hash IN Join DS_BCAST_INNER  (cost=12614.52..103576322.38 rows=3998 width=13)
                                Hash Cond: (("outer".value)::text = ("inner".part_no)::text)
                                ->  XN Seq Scan on utscgk scgk  (cost=0.00..1064055.20 rows=1569014 width=26)
                                      Filter: ((gk)::text ~~ '%PART_NO%'::text)
                                ->  XN Hash  (cost=12613.61..12613.61 rows=366 width=18)
                                      ->  XN Hash Join DS_DIST_ALL_NONE  (cost=1.82..12613.61 rows=366 width=18)
                                            Hash Cond: ("outer".class3_id = "inner"."class")
                                            ->  XN Hash Join DS_DIST_ALL_NONE  (cost=0.63..12604.19 rows=366 width=22)
                                                  Hash Cond: ("outer".status = "inner".status)
                                                  ->  XN Seq Scan on specification_header sh  (cost=0.00..12581.60 rows=1464 width=24)
                                                        Filter: (((((frame_id)::text = 'A_PCR'::text) OR ((frame_id)::text = 'A_OHT'::text) OR ((frame_id)::text = 'A_TBR'::text)) AND (((part_no)::text ~~ 'EF%'::text) OR ((part_no)::text ~~ 'XEF%'::text) OR ((part_no)::text ~~ 'GF%'::text) OR ((part_no)::text ~~ 'XGF%'::text))) OR ((((part_no)::text ~~ 'EV%'::text) OR ((part_no)::text ~~ 'GV%'::text) OR ((part_no)::text ~~ 'XEV%'::text) OR ((part_no)::text ~~ 'XGV%'::text)) AND (((frame_id)::text = 'E_PCR_VULC'::text) OR ((frame_id)::text = 'A_PCR_VULC v1'::text) OR ((frame_id)::text = 'A_TBR_VULC'::text))) OR ((((part_no)::text ~~ 'GB%'::text) OR ((part_no)::text ~~ 'EB%'::text) OR ((part_no)::text ~~ 'XEB%'::text) OR ((part_no)::text ~~ 'XGB%'::text)) AND (((frame_id)::text = 'A_Bead v1'::text) OR ((frame_id)::text = 'E_Bead'::text) OR ((frame_id)::text = 'E_Bead_AT'::text) OR ((frame_id)::text = 'E_Bead_Bare_AT'::text))))
                                                  ->  XN Hash  (cost=0.60..0.60 rows=12 width=2)
                                                        ->  XN Seq Scan on status st  (cost=0.00..0.60 rows=12 width=2)
                                                              Filter: ((status_type)::text = 'CURRENT'::text)
                                            ->  XN Hash  (cost=0.95..0.95 rows=95 width=4)
                                                  ->  XN Seq Scan on class3 spt  (cost=0.00..0.95 rows=95 width=4)
              ->  XN Hash  (cost=0.32..0.32 rows=32 width=28)
                    ->  XN Seq Scan on utlc lc  (cost=0.00..0.32 rows=32 width=28)
        ->  XN Hash  (cost=0.49..0.49 rows=1 width=20)
              ->  XN Seq Scan on utss ss  (cost=0.00..0.49 rows=1 width=20)
                    Filter: ('CM'::text = (ss)::text)
*/
					
--MERGE-OPERATION
--Put the entire operation in a single transaction block so that if there is a problem, everything will be rolled back.
begin transaction;
…
end transaction;



--ANALYZE-COMMAND-HISTORY
--Query STL_ANALYZE to view the history of analyze operations. If Amazon Redshift analyzes a table using
--automatic analyze, the is_background column is set to t (true). Otherwise, it is set to f (false). 
select distinct a.xid
,      trim(t.name) as name
,      a.status
,      a.rows
,      a.modified_rows
,      a.starttime
,      a.endtime
from stl_analyze a
join stv_tbl_perm t on t.id=a.table_id
where t.name = 'uteq'
order by starttime
;
/*
67747449	uteq	Full        	147.0	147.0	2022-12-01 12:10:12.958319	2022-12-01 12:10:12.958832
67747449	uteq	Skipped        	147.0	0.0		2022-12-01 12:10:12.960296	2022-12-01 12:10:12.960326
67747449	uteq	Skipped        	147.0	0.0		2022-12-01 12:10:12.961639	2022-12-01 12:10:12.961665
67747810	uteq	Skipped        	146.0	0.0		2022-12-01 12:12:23.600959	2022-12-01 12:12:23.60147
67747812	uteq	Skipped        	146.0	0.0		2022-12-01 12:12:23.762952	2022-12-01 12:12:23.762995
67747815	uteq	Skipped        	146.0	0.0		2022-12-01 12:12:23.906755	2022-12-01 12:12:23.906796
67757466	uteq	Skipped        	147.0	0.0		2022-12-01 13:10:13.210332	2022-12-01 13:10:13.211018
67757466	uteq	Skipped        	147.0	0.0		2022-12-01 13:10:13.213261	2022-12-01 13:10:13.21329
67757466	uteq	Skipped        	147.0	0.0		2022-12-01 13:10:13.21503	2022-12-01 13:10:13.215052
67757840	uteq	Skipped        	146.0	0.0		2022-12-01 13:12:23.966892	2022-12-01 13:12:23.967409
67757842	uteq	Skipped        	146.0	0.0		2022-12-01 13:12:24.129648	2022-12-01 13:12:24.129693
67757845	uteq	Skipped        	146.0	0.0		2022-12-01 13:12:24.272756	2022-12-01 13:12:24.272817
67767310	uteq	Skipped        	147.0	0.0		2022-12-01 14:10:14.444111	2022-12-01 14:10:14.444627
67767310	uteq	Skipped        	147.0	0.0		2022-12-01 14:10:14.446017	2022-12-01 14:10:14.446044
...
*/

--vraag wat is XID voor een identifier?  een session-id?

--ERROR:1018 DETAIL: Relation does not exist
--Transactions in Amazon Redshift follow snapshot isolation. After a transaction begins, Amazon Redshift
--takes a snapshot of the database. For the entire lifecycle of the transaction, the transaction operates on
--the state of the database as reflected in the snapshot. If the transaction reads from a table that doesn't
--exist in the snapshot, it throws the 1018 error message shown previously. Even when another concurrent
--transaction creates a table after the transaction has taken the snapshot, the transaction can't read from
--the newly created table







