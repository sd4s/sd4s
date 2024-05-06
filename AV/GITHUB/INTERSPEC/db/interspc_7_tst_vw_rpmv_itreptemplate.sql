--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View RPMV_ITREPTEMPLATE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RPMV_ITREPTEMPLATE" ("TEMPL_ID", "TYPE", "DESCRIPTION", "HTML", "PDF", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  select "TEMPL_ID","TYPE","DESCRIPTION","HTML","PDF","LAST_MODIFIED_ON","LAST_MODIFIED_BY" from ITREPTEMPLATE
 ;
