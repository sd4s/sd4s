--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View AV_SPECIFICATION_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_SPECIFICATION_HEADER" ("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE", "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV", "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "UOM_TYPE", "MASK_ID", "PED_IN_SYNC", "LOCKED", "LINKED_TO_TC", "LAST_SAVED_TO_TC", "TC_IN_PROGRESS") AS 
  select "PART_NO","REVISION","STATUS","DESCRIPTION","PLANNED_EFFECTIVE_DATE","ISSUED_DATE","OBSOLESCENCE_DATE","STATUS_CHANGE_DATE","PHASE_IN_TOLERANCE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","FRAME_ID","FRAME_REV","ACCESS_GROUP","WORKFLOW_GROUP_ID","CLASS3_ID","OWNER","INT_FRAME_NO","INT_FRAME_REV","INT_PART_NO","INT_PART_REV","FRAME_OWNER","INTL","MULTILANG","UOM_TYPE","MASK_ID","PED_IN_SYNC","LOCKED","LINKED_TO_TC","LAST_SAVED_TO_TC","TC_IN_PROGRESS"
from   specification_header
where  f_check_access(part_no, revision) = 1;
