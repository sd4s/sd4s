create or replace procedure IS_SELECT_BOM ( p_part_no    INOUT varchar )
AS $$
DECLARE
l_tab   varchar(50);
df_cnt  int           := 1;
cnt     int           := 1;
a       int;
tblnm   varchar(50)   := '';
tblnm1  varchar(50)   := '';
qry     varchar(2500) := '';
BEGIN 
  --based on table EMPLOYEE-REC-TEST:  employee_number = number from an employee (=child)
  --                                   manager_employee_number = employee_number from manager (=parent)
  --We can compare this with table BOM_ITEM: employee_number         = bom_item.component_part
  --                                         manager_employee_number = bom_item.part_no
  --First we search for COMPONENT_PART under the PART_NO. 
  --Second we search for COMPONENT_PART under the COMPONENT-PART-PART-NO.
  --etc.
  --
  -- Create initial temp table (part-no/component-parts) obv. p_part_no
  --Creates a temporary table. 
  --A temporary table is automatically dropped at the end of the session in which it was created.
  for i in 0..15
  loop
    begin
      execute 'drop table IF EXISTS temp_tab'|| i;
      exception when others then RAISE NOTICE 'Table temp_tab % is not dropped...proceed...', i;
    end;
  end loop;
  --
  execute 'create temp table temp_tab0 as ( SELECT   '||''''||'temp_tab0'||''''||' as level  
                                   ,        b.part_number as part_no
                                   ,        b.revision
                                   ,        b.component_part
                                   FROM  sc_lims_dal_ai.ai_specification_bom_item_full  b
                                   WHERE   b.part_number    = '||''''||P_PART_NO||''''||'  
                                   and     b.preferred  = 1 
                                   and     b.status_type in ('||''''||'CURRENT'||''''||')
								 ) ';
  --RUN as long as component-parts can be found...
  RAISE INFO 'In loop df_cnt aantal > 0, voor select-stmnt, aantal: %', df_cnt;
  --
  while (df_cnt != 0 )
  loop
    tblnm  := 'temp_tab'||(cnt-1);  --de laatst reeds aanwezige gevulde temp-tab
    tblnm1 := 'temp_tab'||cnt;      --de nieuw te maken/vullen temp-tab based on 
	--
	--zoek bij alle aan een part-no gerelateerde component-parts opnieuw de daarbij behorende component-parts
    execute 'select * from ( select '||''''||quote_ident(tblnm)||''''||' as level 
	                         ,      b.part_number  as part_no
	                         ,      b.revision
	                         ,      b.component_part
                             FROM '||quote_ident(tblnm)||'                       master_part
							 ,    sc_lims_dal_ai.ai_specification_bom_item_full  b
                             WHERE   b.part_number     = master_part.component_part
                             and     b.preferred  = 1
                             and     b.status_type in ('||''''||'CURRENT'||''''||')
						   ) a';
    GET DIAGNOSTICS df_cnt := ROW_COUNT;
	--indien nog childs/component-parts gevonden dan slaan we deze op in temp-tabel
    --
    if (df_cnt!=0)
    then
      RAISE INFO 'In loop df_cnt na vooraf-select-component-parts aantal>0';
      execute 'create temp table '||quote_ident(tblnm1)||' as 
	                         select '||''''||quote_ident(tblnm1)||''''||' as level 
							 ,      b.part_number  as part_no
	                         ,      b.revision
	                         ,      b.component_part
                             FROM '||quote_ident(tblnm)||'                       master_part
							 ,    sc_lims_dal_ai.ai_specification_bom_item_full  b
                             WHERE   b.part_number     = master_part.component_part
                             and     b.preferred  = 1
                             and     b.status_type in ('||''''||'CURRENT'||''''||')';
    else
      RAISE INFO 'In loop df_cnt na vooraf-select-component-parts aantal=0';
    end if;    
    cnt := cnt + 1;
  end loop; 
  --
  for a in 0..(cnt-2)
  loop
    if (a=0)
    then qry := qry || 'select level, part_no, revision, component_part from temp_tab' || a;
    else qry := qry || ' union select level, part_no, revision, component_part from temp_tab' || a;
    end if;
  end loop;
  -- Return Result set
  --OPEN result_set for 
  if cnt!=0
  then
    begin
      execute 'drop table IF EXISTS result_rec';
      RAISE INFO 'Table result_rec dropped...';
    exception
      when others 
	  then RAISE INFO 'Table temp_tab0 is not dropped...proceed...';
    end;
    execute 'create table result_rec as '|| qry;
  end if;
  --
EXCEPTION 
  WHEN OTHERS 
  THEN RAISE INFO 'ALG-EXCP error message SQLERRM %', SQLERRM;  
END;
$$ LANGUAGE plpgsql;







--************************************************************************
--************************************************************************
--call procedure:
call IS_SELECT_BOM( 'EV_BW245/45R21WPRX' );
--in same session query:
select * from result_rec order by 1;

--************************************************************************
--************************************************************************

/*
LET OP: table temp_tab0, etc. worden aangemaakt in nieuw SCHEMA = pg_temp_6 !!!!

temp_tab0-QUERY doet het wel...:

XEM_B18-1042XN4_21	1	131424
XEM_B18-1042XN4_21	1	164311
XEM_B18-1042XN4_21	1	160224
XEM_B18-1042XN4_21	1	160727
XEM_B18-1042XN4_21	1	139034
XEM_B18-1042XN4_21	1	162213
XEM_B18-1042XN4_21	1	150708
XEM_B18-1042XN4_21	1	165215
XEM_B18-1042XN4_21	1	160280
XEM_B18-1042XN4_21	1	162502

*/

/*
--dd. 20-12-2022: when trying to create procedure on REDSHIFT-PROD-environment as user = usr_eu_lims_dl_admin :

An error occurred when executing the SQL command:
create procedure sc_interspec_ens.IS_SELECT_BOM ( p_part_no    INOUT varchar
                                                , p_result_set...
ERROR: permission denied for schema sc_interspec_ens
1 statement failed.
Execution time: 0.36s
*/

/*
Warnings:
Table temp_tab0
In loop df_cnt aantal > 0, voor select-stmnt, aantal: 1
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal>0
In loop df_cnt na vooraf-select-component-parts aantal=0
ALG-EXCP error message SQLERRM relation "result_rec" already exists

An error occurred when executing the SQL command:
call IS_SELECT_BOM( 'EV_BW245/45R21WPRX' )

ERROR: relation "result_rec" already exists
  Where: SQL statement "create table result_rec as select part_no, revision, component_part from temp_tab0 union select part_no, revision, component_part from temp_tab1 union select part_no, revision, component_part from temp_tab2 union select part_no, revision, component_part from temp_tab3 union select part_no, revision, component_part from temp_tab4 union select part_no, revision, component_part from temp_tab5 union select part_no, revision, component_part from temp_tab6 union select part_no, revision, component_part from temp_tab7 union select part_no, revision, component_part from temp_tab8 union select part_no, revision, component_part from temp_tab9"
PL/pgSQL function "is_select_bom" line 111 at execute statement
1 statement failed.
*/