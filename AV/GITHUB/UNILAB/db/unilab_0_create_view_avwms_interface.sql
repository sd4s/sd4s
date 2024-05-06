--------------------------------------------------------
--  File created - donderdag-oktober-01-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View AVWMS_INTERFACE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVWMS_INTERFACE" ("TYRECODE", "PART_NO") AS 
  SELECT TyreCode, Part_No
FROM UNILAB.ATWMS_INTERFACE;
