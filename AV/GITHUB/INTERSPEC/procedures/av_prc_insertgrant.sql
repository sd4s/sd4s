--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure INSERTGRANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "INTERSPC"."INSERTGRANT" ( p_ObjectName IN varchar2 ) as

begin

INSERT INTO grant_execute
          ( object_name,
            configurator,
            approver,
            dev_mgr,
            view_only,
            mrp,
            frame_builder )
   VALUES ( p_ObjectName,
            1,
            1,
            1,
            1,
            1,
            1             );

exception

   WHEN OTHERS THEN
     null;

end;

 

/
