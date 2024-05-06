--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View WF_SPECIFICATION_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."WF_SPECIFICATION_HEADER" ("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE", "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV", "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "UOM_TYPE", "MASK_ID", "PED_IN_SYNC", "LOCKED", "STATUS_TYPE", "STATUS_DESCRIPTION") AS 
  SELECT specification_header."PART_NO",specification_header."REVISION",specification_header."STATUS",specification_header."DESCRIPTION",specification_header."PLANNED_EFFECTIVE_DATE",specification_header."ISSUED_DATE",specification_header."OBSOLESCENCE_DATE",specification_header."STATUS_CHANGE_DATE",specification_header."PHASE_IN_TOLERANCE",specification_header."CREATED_BY",specification_header."CREATED_ON",specification_header."LAST_MODIFIED_BY",specification_header."LAST_MODIFIED_ON",specification_header."FRAME_ID",specification_header."FRAME_REV",specification_header."ACCESS_GROUP",specification_header."WORKFLOW_GROUP_ID",specification_header."CLASS3_ID",specification_header."OWNER",specification_header."INT_FRAME_NO",specification_header."INT_FRAME_REV",specification_header."INT_PART_NO",specification_header."INT_PART_REV",specification_header."FRAME_OWNER",specification_header."INTL",specification_header."MULTILANG",specification_header."UOM_TYPE",specification_header."MASK_ID",specification_header."PED_IN_SYNC",specification_header."LOCKED", status.status_type, status.description AS status_description
FROM specification_header
INNER JOIN status ON (specification_header.status = status.status);

   COMMENT ON TABLE "INTERSPC"."WF_SPECIFICATION_HEADER"  IS 'Specification header and status-type in a single view.
Reason: We can only join a WebFOCUS FOCUS file to a single database table or view, but the status-type is almost always important for filtering results.';
