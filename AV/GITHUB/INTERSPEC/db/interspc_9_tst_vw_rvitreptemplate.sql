--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View RVITREPTEMPLATE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."RVITREPTEMPLATE" ("TEMPL_ID", "TYPE", "DESCRIPTION", "HTML", "PDF", "LAST_MODIFIED_ON", "LAST_MODIFIED_BY") AS 
  SELECT "TEMPL_ID","TYPE","DESCRIPTION","HTML","PDF","LAST_MODIFIED_ON","LAST_MODIFIED_BY" FROM ITREPTEMPLATE
 ;
