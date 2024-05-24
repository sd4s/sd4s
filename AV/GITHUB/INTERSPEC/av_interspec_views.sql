--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View AV_APPLICABLE_FOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_APPLICABLE_FOR" ("PART_NO", "REVISION", "DESCRIPTION", "ENSCHEDE", "KIROV", "VORONESZ") AS 
  select a.part_no, a.revision, b.description, 
(select s.value_s from specdata s where property = 705888 AND s.part_no = a.part_no and s.revision=a.revision and s.sub_section_id=a.sub_section_id) Enschede, 
(select s.value_s from specdata s where property = 705889 AND s.part_no = a.part_no and s.revision=a.revision and s.sub_section_id=a.sub_section_id) Kirov, 
(select s.value_s from specdata s where property = 705890 AND s.part_no = a.part_no and s.revision=a.revision and s.sub_section_id=a.sub_section_id) Voronezh 
from specification_section a, sub_section b 
where a.part_no like 'GR%' and (a.section_id=700581 or a.section_id=700579) and b.sub_section_id = a.sub_section_id and 
   section_sequence_no = (select max(section_sequence_no) 
   from specification_section b 
      where a.part_no = b.part_no and a.revision = b.revision and a.section_id = b.section_id and a.sub_section_id = b.sub_section_id) 
order by a.part_no, a.revision, a.sub_section_id
 ;
--------------------------------------------------------
--  DDL for View AV_CHARACTERISTICS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_CHARACTERISTICS" ("ASSOCIATION", "CHARACTERISTIC") AS 
  SELECT
	association.description AS association,
	characteristic.description AS characteristic
FROM
	characteristic
INNER JOIN
	characteristic_association
	ON characteristic_association.characteristic = characteristic.characteristic_id
INNER JOIN
	association
	ON association.association = characteristic_association.association
WHERE
	characteristic.status = 0 
 ;
--------------------------------------------------------
--  DDL for View AV_DBA_MONITOR_LOG_SWITCHES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_DBA_MONITOR_LOG_SWITCHES" ("DAY", "00", "01", "02", "03", "04", "05", "06", "07", "0", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23") AS 
  SELECT "DAY","00","01","02","03","04","05","06","07","0","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23" FROM SYS.AV_DBA_MONITOR_LOG_SWITCHES
;
--------------------------------------------------------
--  DDL for View AV_ITOID_RAW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_ITOID_RAW" ("OBJECT_ID", "FILE_NAME", "DESKTOP_OBJECT") AS 
  SELECT rpmv_itoid.OBJECT_ID, rpmv_itoid.FILE_NAME, rpmv_itoiraw.DESKTOP_OBJECT
    FROM rpmv_itoid
    INNER JOIN rpmv_itoiraw ON (rpmv_itoid.object_id = rpmv_itoiraw.object_id)
 ;
--------------------------------------------------------
--  DDL for View AV_KEYWORDS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_KEYWORDS" ("PART_NO", "OLD_VR_CODE", "OLD_AMTEL_CODE", "PRODUCTGROUP", "OLD_PRODUCTGROUP", "SPEC_FUNCTION", "SPECTRAC") AS 
  SELECT   h.part_no,
            (SELECT   kw_value
               FROM   SPECIFICATION_KW kv, ITKW kw
              WHERE       kv.part_no = h.part_no
                      AND kv.kw_id = kw.kw_id
                      AND kw.description = 'Old VR code'
                      AND ROWNUM = 1)
               Old_VR_Code,
            (SELECT   kw_value
               FROM   SPECIFICATION_KW kv, ITKW kw
              WHERE       kv.part_no = h.part_no
                      AND kv.kw_id = kw.kw_id
                      AND kw.description = 'Old Amtel code'
                      AND ROWNUM = 1)
               Old_Amtel_Code,
            (SELECT   kw_value
               FROM   SPECIFICATION_KW kv, ITKW kw
              WHERE       kv.part_no = h.part_no
                      AND kv.kw_id = kw.kw_id
                      AND kw.description = 'Productgroup'
                      AND ROWNUM = 1)
               Productgroup,
            (SELECT   kw_value
               FROM   SPECIFICATION_KW kv, ITKW kw
              WHERE       kv.part_no = h.part_no
                      AND kv.kw_id = kw.kw_id
                      AND kw.description = 'Old Productgroup'
                      AND ROWNUM = 1)
               Old_Productgroup,
            (SELECT   kw_value
               FROM   SPECIFICATION_KW kv, ITKW kw
              WHERE       kv.part_no = h.part_no
                      AND kv.kw_id = kw.kw_id
                      AND kw.description = 'Spec. Function'
                      AND ROWNUM = 1)
               Spec_Function,
            (SELECT   kw_value
               FROM   SPECIFICATION_KW kv, ITKW kw
              WHERE       kv.part_no = h.part_no
                      AND kv.kw_id = kw.kw_id
                      AND kw.description = 'Function'
                      AND ROWNUM = 1)
               Spectrac
     FROM   PART h 
 ;
--------------------------------------------------------
--  DDL for View AV_LEVERINGSVORMEN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_LEVERINGSVORMEN" ("PART_NO", "REVISION", "DESCRIPTION", "SPEC_REFERENCE", "PRODUCTNAME", "ENSCHEDE", "KIROV", "VORONEZH") AS 
  SELECT a.part_no, a.revision, b.description, 
  (SELECT s.value_s FROM SPECDATA s WHERE PROPERTY = 703610 AND s.part_no = a.part_no AND s.revision=a.revision AND s.sub_section_id=a.sub_section_id) Spec_Reference, 
  (SELECT s.value_s FROM SPECDATA s WHERE PROPERTY = 704029 AND s.part_no = a.part_no AND s.revision=a.revision AND s.sub_section_id=a.sub_section_id) Productname, 
  (SELECT s.value_s FROM SPECDATA s WHERE PROPERTY = 705888 AND s.part_no = a.part_no AND s.revision=a.revision AND s.sub_section_id=a.sub_section_id) Enschede, 
  (SELECT s.value_s FROM SPECDATA s WHERE PROPERTY = 705889 AND s.part_no = a.part_no AND s.revision=a.revision AND s.sub_section_id=a.sub_section_id) Kirov, 
  (SELECT s.value_s FROM SPECDATA s WHERE PROPERTY = 705890 AND s.part_no = a.part_no AND s.revision=a.revision AND s.sub_section_id=a.sub_section_id) Voronezh 
FROM SPECIFICATION_SECTION a, SUB_SECTION b 
WHERE (a.part_no LIKE 'GR%' OR a.part_no LIKE 'SM%') 
  AND (a.section_id=700581 
      OR (a.section_id=700579 
         AND (SELECT COUNT(*) 
              FROM SPECIFICATION_SECTION c 
              WHERE c.part_no = a.part_no AND c.revision = a.revision AND c.section_id = 700581) = 0)) 
  AND b.sub_section_id = a.sub_section_id 
  AND section_sequence_no = (SELECT MAX(section_sequence_no) 
         FROM SPECIFICATION_SECTION b 
         WHERE a.part_no = b.part_no AND a.revision = b.revision AND a.section_id = b.section_id AND a.sub_section_id = b.sub_section_id) 
order by a.part_no, a.revision, a.sub_section_id
 ;
--------------------------------------------------------
--  DDL for View AV_MAIL_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_MAIL_LOG" ("LOGDATE", "ERROR_MSG") AS 
  SELECT logdate, error_msg
FROM iterror
WHERE source = 'iapiEmail'
AND logdate > SYSDATE - 30
ORDER BY logdate DESC;
--------------------------------------------------------
--  DDL for View AV_MAIL_LOG_USER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_MAIL_LOG_USER" ("USER_ID", "FORENAME", "LAST_NAME", "EMAIL_ADDRESS") AS 
  SELECT user_id, forename, last_name, email_address
FROM application_user
WHERE email_address IS NOT NULL
AND email_address IN (
  SELECT DISTINCT REGEXP_REPLACE(
    error_msg,
    'ORA-29279: [^:]+: 550 (.+?)... No such user|The e-mail address <([^>]+)> is invalid or does not exist',
    '\1\2'
  )
  FROM iterror
  WHERE source = 'iapiEmail'
  AND logdate > SYSDATE - 30
);
--------------------------------------------------------
--  DDL for View AV_MAIL_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_MAIL_STATUS" ("BROKEN", "FAILURES", "WHAT") AS 
  SELECT broken, failures, what
FROM dba_jobs
WHERE LOWER(what) LIKE LOWER('%iapiEmail.SendEmails%');

   COMMENT ON TABLE "INTERSPC"."AV_MAIL_STATUS"  IS 'DECLARE
  lnJobID NUMBER;
  lnRetVal iapiType.ErrorNum_Type;
BEGIN
  SELECT job
  INTO lnJobID
  FROM dba_jobs
  WHERE LOWER(what) LIKE LOWER(''%iapiEmail.SendEmails%'');
  dbms_job.remove(lnJobID);
  COMMIT;

  SyncNLS;
  lnRetVal := iapiEmail.StartJob();
  COMMIT;
  dbms_output.put_line(''Job Start: '' || CASE WHEN lnRetVal = 0 THEN ''Success'' ELSE ''Failure'' END);
END;
/';
--------------------------------------------------------
--  DDL for View AV_PART_PRICE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_PART_PRICE" ("PART_NO", "ENSCHEDE", "KIROV", "VORONEZH") AS 
  select h.part_no, 
(select pc.price from part_cost pc 
where pc.part_no = h.part_no and pc.plant='ENS') Enschede, 
(select pc.price from part_cost pc 
where pc.part_no = h.part_no and pc.plant='KIR') Kirov, 
(select pc.price from part_cost pc 
where pc.part_no = h.part_no and pc.plant='VOR') Voronezh 
from specification_header h 
where h.part_no like 'GR_%'
 ;
--------------------------------------------------------
--  DDL for View AV_PART_SPECS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_PART_SPECS" ("PART_NO", "REVISION", "DESCRIPTION", "PART_SOURCE") AS 
  select a.part_no, a.revision, b.description, b.PART_SOURCE 
  from SPECIFICATION_header a, part b 
 where a.part_no = b.part_no
 ;
--------------------------------------------------------
--  DDL for View AV_PG_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_PG_KW" ("PART_NO", "KW_ID", "KW_VALUE", "INTL") AS 
  select "PART_NO","KW_ID","KW_VALUE","INTL" from specification_kw 
where KW_ID = 700347
 ;
--------------------------------------------------------
--  DDL for View AV_PLANTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_PLANTS" ("PART_NO", "ENSCHEDE", "KIROV", "VORONEZH") AS 
  select h.part_no, 
(select p.plant from rvpart_plant p 
where h.part_no = p.part_no AND p.plant = 'ENS') Enschede, 
(select p.plant from rvpart_plant p 
where h.part_no = p.part_no AND p.plant = 'KIR') Kirov, 
(select p.plant from rvpart_plant p 
where h.part_no = p.part_no AND p.plant = 'VOR') Voronezh 
from specification_header h
 ;
--------------------------------------------------------
--  DDL for View AV_PRODUCT_NAME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_PRODUCT_NAME" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "PRODUCT_NAME") AS 
  select part_no, revision, section_id, sub_section_id, value_s as product_name 
  from specdata 
where property = 704029
 ;
--------------------------------------------------------
--  DDL for View AV_PRODUCTLINE_SIZE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_PRODUCTLINE_SIZE" ("PART_NO", "REVISION", "PRODUCTLINE", "SIZE") AS 
  SELECT
    spec_assoc.part_no,
    spec_assoc.revision,
    spec_assoc.productline,
    spec_width.value_s || '/' || spec_ratio.value_s || 'R' || spec_code.value_s AS "SIZE"
FROM (
    SELECT
        specdata.part_no,
        MAX(specdata.revision) AS revision,
        specdata.value_s AS productline
    FROM
        specdata
    WHERE
        specdata.property_group  = 701563 -- General tyre characteristics
        AND specdata.property    = 703422 -- Productline
    GROUP BY
        specdata.part_no,
        specdata.value_s
) spec_assoc
INNER JOIN
    specdata spec_width
    ON  spec_width.part_no  = spec_assoc.part_no
    AND spec_width.revision = spec_assoc.revision
INNER JOIN
    specdata spec_ratio
    ON  spec_ratio.part_no  = spec_assoc.part_no
    AND spec_ratio.revision = spec_assoc.revision
INNER JOIN
    specdata spec_code
    ON  spec_code.part_no  = spec_assoc.part_no
    AND spec_code.revision = spec_assoc.revision
WHERE spec_width.property = 703424 -- Section width
  AND spec_ratio.property = 703417 -- Aspect ratio
  AND spec_code.property  = 703423 -- Rimcode
  AND spec_width.section_id = 700579  -- General information
  AND spec_ratio.section_id = 700579  -- General information
  AND spec_code.section_id  = 700579 
 ;
--------------------------------------------------------
--  DDL for View AV_RUS_SUPPLIERS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_RUS_SUPPLIERS" ("PART_NO", "KW_ID", "KW_VALUE", "INTL") AS 
  select "PART_NO","KW_ID","KW_VALUE","INTL" from specification_kw 
where kw_id = 700406
 ;
--------------------------------------------------------
--  DDL for View AV_SPEC_REF
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_SPEC_REF" ("PART_NO", "REVISION", "SECTION_ID", "SUB_SECTION_ID", "SPEC_REF") AS 
  select part_no, revision, section_id, sub_section_id, value_s as spec_ref 
  from specdata 
where property = 703610
 ;
--------------------------------------------------------
--  DDL for View AV_SPECDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_SPECDATA" ("PART_NO", "REVISION", "SECTION_ID", "SECTION_REV", "SUB_SECTION_ID", "SUB_SECTION_REV", "TYPE", "REF_ID", "REF_VER", "REF_INFO", "REF_OWNER", "PROPERTY_GROUP", "PROPERTY_GROUP_REV", "PROPERTY", "PROPERTY_REV", "LANG_ID", "TARGET", "LSL", "USL", "LWL", "UWL", "INT_METHOD", "AV_METHOD", "REMARK") AS 
  select s1.part_no, s1.revision, s1.section_id,s1.section_rev, s1.sub_section_id, s1.sub_section_rev,s1.TYPE, s1.ref_id, s1.ref_ver,s1.ref_info,s1.ref_owner, s1.property_group,s1.property_group_rev, s1.property,s1.property_rev, s1.lang_id, 
(select s2.value_s from specdata s2 where header_id = 700498 and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) target, 
(select s2.value_s from specdata s2 where header_id = 700496 and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) LSL, 
(select s2.value_s from specdata s2 where header_id = 700500 and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) USL, 
(select s2.value_s from specdata s2 where header_id = 700497 and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) LWL, 
(select s2.value_s from specdata s2 where header_id = 700499 and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) UWL, 
(select s2.value_s from specdata s2 where (header_id = 700532 or header_id = 700691) and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) Int_method, 
(select s2.value_s from specdata s2 where header_id = 700501 and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) AV_method, 
(select s2.value_s from specdata s2 where header_id = 700591 and s2.part_no = s1.part_no and s2.revision = s1.revision and 
s1.section_id = s2.section_id and s1.sub_section_id = s2.sub_section_id and s1.property_group = s2.property_group and s1.property = s2.property 
and s1.section_rev = s2.section_rev and s1.sub_section_rev = s2.sub_section_rev and s1.property_group_rev = s2.property_group_rev 
and s1.property_rev = s2.property_rev and s1.ref_id = s2.ref_id and s1.ref_ver = s2.ref_ver 
and s1.type = s2.type and s1.ref_info = s2.ref_info and s1.ref_owner = s2.ref_owner and s1.lang_id = s2.lang_id) Remark 
from specdata s1
 ;
--------------------------------------------------------
--  DDL for View AV_SPECIFICATION_HEADER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_SPECIFICATION_HEADER" ("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE", "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON", "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV", "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "UOM_TYPE", "MASK_ID", "PED_IN_SYNC", "LOCKED") AS 
  select "PART_NO","REVISION","STATUS","DESCRIPTION","PLANNED_EFFECTIVE_DATE","ISSUED_DATE","OBSOLESCENCE_DATE","STATUS_CHANGE_DATE","PHASE_IN_TOLERANCE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON","FRAME_ID","FRAME_REV","ACCESS_GROUP","WORKFLOW_GROUP_ID","CLASS3_ID","OWNER","INT_FRAME_NO","INT_FRAME_REV","INT_PART_NO","INT_PART_REV","FRAME_OWNER","INTL","MULTILANG","UOM_TYPE","MASK_ID","PED_IN_SYNC","LOCKED"
from   specification_header
where  f_check_access(part_no, revision) = 1;
--------------------------------------------------------
--  DDL for View AV_SUPPLIER_CODE_KW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_SUPPLIER_CODE_KW" ("PART_NO", "KW_ID", "KW_VALUE", "INTL") AS 
  select "PART_NO","KW_ID","KW_VALUE","INTL" from specification_kw 
where KW_ID = 700346
 ;
--------------------------------------------------------
--  DDL for View AVAO_AVMETHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVAO_AVMETHOD" ("PART_NO", "REVISION", "PROPERTY", "AVMETHOD") AS 
  select part_no, revision, property, char_3 avmethod 
  from SPECIFICATION_PROP 
 where section_id = 700578
 ;
--------------------------------------------------------
--  DDL for View AVAO_INTERVALTYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVAO_INTERVALTYPE" ("PART_NO", "REVISION", "PROPERTY", "INTERVALTYPE") AS 
  select a.part_no, a.revision, a.property, c.description intervaltype 
  from SPECIFICATION_PROP a, CHARACTERISTIC_ASSOCIATION b, CHARACTERISTIC c 
 where a.section_id = 700578 
   and a.association = b.association 
   and a.CHARACTERISTIC = b.CHARACTERISTIC 
   and b.CHARACTERISTIC = c.CHARACTERISTIC_id
 ;
--------------------------------------------------------
--  DDL for View AVAO_PHR_CALC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVAO_PHR_CALC" ("PART_NO", "REVISION", "SECTION_ID", "SECTION", "SUB_SECTION_ID", "SUB_SECTION", "PROPERTY_GROUP", "PG_DESC", "PROPERTY", "PROP_DESC", "NUM_1") AS 
  SELECT   a.part_no,
            a.revision,
            a.section_id,
            b.description SECTION,
            a.sub_section_id,
            c.description SUB_SECTION,
            a.property_group,
            d.description PG_DESC,
            a.property,
            e.description PROP_DESC,
            a.num_1
     FROM   SPECIFICATION_PROP a,
            section b,
            sub_section c,
            property_group d,
            property e
    WHERE       a.section_ID = b.SECTION_ID
            AND a.sub_section_ID = c.SUB_SECTION_ID
            AND a.property_group = d.PROPERTY_GROUP
            AND a.property = e.PROPERTY
            AND (
               c.description LIKE 'Mix%'
            OR c.description LIKE 'MNG%'
            OR c.description LIKE 'MMX%'
            )
            AND a.boolean_1 = 'Y';
--------------------------------------------------------
--  DDL for View AVAO_SAMPLINGINTERVAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVAO_SAMPLINGINTERVAL" ("PART_NO", "REVISION", "PROPERTY", "SAMPLINGINTERVAL") AS 
  select part_no, revision, property, num_2 samplinginterval 
  from SPECIFICATION_PROP 
 where section_id = 700578
 ;
--------------------------------------------------------
--  DDL for View AVCATIAMAPPING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVCATIAMAPPING" ("FRAME_NO", "FRAME_REV", "SECTION", "SUB_SECTION", "PROPERTY_GROUP", "PROPERTY", "ATTRIBUTE", "FIELD", "CATIA_VARIABLE") AS 
  SELECT
  frame_no,
  frame_rev,
  section_id AS section,
  sub_section_id AS sub_section,
  property_group,
  property,
  attribute,
  field_type AS field,
  catia_var AS catia_variable
FROM atCatiaMapping
LEFT JOIN section
  ON (NVL(section_desc, '(none)') = section.description)
LEFT JOIN sub_section
  ON (NVL(sub_section_desc, '(none)') = sub_section.description)
LEFT JOIN property_group
  ON (NVL(property_group_desc, 'default property group') = property_group.description)
LEFT JOIN property
  ON (property_desc = property.description)
LEFT JOIN attribute
  ON (attribute_desc = attribute.description)
ORDER BY
  section_id,
  sub_section_id,
  property_group,
  property,
  attribute,
  field_type;
--------------------------------------------------------
--  DDL for View AVCONSTRUCTIONCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVCONSTRUCTIONCODE" ("SERIAL_CODE", "CONSTR_CODE", "PART_NO", "REVISION") AS 
  SELECT
    serial.value_s AS serial_code,
    constr.value_s AS constr_code,
    constr.part_no,
    constr.revision
FROM
    specdata serial
INNER JOIN
    specdata constr
    ON  constr.part_no  = serial.part_no
    AND constr.revision = serial.revision
INNER JOIN
    specification_header
    ON  specification_header.part_no  = constr.part_no
    AND specification_header.revision = constr.revision
WHERE specification_header.status IN (4, 5, 127, 128) --Current, Historic, QR4, QR5
  AND serial.section_id = 700579 --General information
  AND constr.section_id = 700579 --General information
  AND serial.property_group = 701568 --Sidewall designation
  AND constr.property_group = 701568 --Sidewall designation
  AND serial.property = 705629 --Serial number DOT
  AND constr.property = 970    --Construction code
  AND serial.value_s IS NOT NULL
  AND constr.value_s IS NOT NULL
ORDER BY
    serial_code,
    constr_code 
 ;
--------------------------------------------------------
--  DDL for View AVFUNCBOM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVFUNCBOM" ("FUNC_LEVEL", "FUNCTION", "FUNC_OVERRIDE", "COMPONENT_PART", "COMPONENT_REVISION", "DESCRIPTION", "PART_TYPE", "PLANT", "ALTERNATIVE", "USAGE", "QTY", "FRAME_NO", "ACTION") AS 
  SELECT func_level, FUNCTION, func_override, component_part, component_revision, description,
          part_type, plant, alternative, USAGE, qty, frame_no, action
   FROM   ATFUNCBOM
   WHERE  user_id = USER
     AND applic = aapiSpectrac.GetApplic
 ;
--------------------------------------------------------
--  DDL for View AVFUNCBOMDATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVFUNCBOMDATA" ("SEQUENCE_NO", "FUNC_LEVEL", "SPEC_HEADER", "KEYWORD", "KEYWORD_ID", "ATTACHED_SPECS", "SECTION", "SECTION_ID", "SUB_SECTION", "SUB_SECTION_ID", "PROPERTY_GROUP", "PROPERTY_GROUP_ID", "PROPERTY", "PROPERTY_ID", "FIELD", "FIELD_TYPE", "VALUE") AS 
  SELECT sequence_no, func_level, spec_header, keyword, keyword_id, attached_specs, section,
          section_id, sub_section, sub_section_id, property_group, property_group_id, property,
          property_id, FIELD, field_type, VALUE
   FROM   ATFUNCBOMDATA
   WHERE  user_id = USER
     AND applic = aapiSpectrac.GetApplic
 ;
--------------------------------------------------------
--  DDL for View AVSESSIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVSESSIONS" ("USERNAME", "TOTAL_SESSIONS", "QUICK_SESSIONS", "SHORT_SESSIONS", "MEDIUM_SESSIONS", "LONG_SESSIONS") AS 
  SELECT
    ses_dbuser AS username,
    --ses_class,
    COUNT(*) AS total_sessions,
    COUNT(CASE WHEN ses_class = 1 THEN 1 ELSE NULL END) AS quick_sessions,
    COUNT(CASE WHEN ses_class = 2 THEN 1 ELSE NULL END) AS short_sessions,
    COUNT(CASE WHEN ses_class = 3 THEN 1 ELSE NULL END) AS medium_sessions,
    COUNT(CASE WHEN ses_class = 4 THEN 1 ELSE NULL END) AS long_sessions
FROM (
    SELECT
        ses.*,
        CASE
            WHEN ses_length <= INTERVAL '10' MINUTE THEN
                1
            WHEN ses_length <= INTERVAL '60' MINUTE THEN
                2
            WHEN ses_length <= INTERVAL '8' HOUR THEN
                3
            ELSE
                4
        END AS ses_class
    FROM (
        SELECT
            (ses_logoff_date - ses_logon_date) DAY TO SECOND ses_length,
            ses_dbuser,
            ses_osuser,
            ses_machine,
            ses_terminal,
            ses_program,
            ses_logon_date,
            ses_logoff_date
        FROM at_sessions
    ) ses
)
GROUP BY
    ses_dbuser
ORDER BY
    total_sessions DESC;
--------------------------------------------------------
--  DDL for View AVSPECTRACCODES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVSPECTRACCODES" ("PART_NO", "REVISION", "DESCRIPTION", "STATUS", "PLANNED_EFFECTIVE_DATE", "PED_TEXT", "KW", "KW_VALUE", "PLANT") AS 
  WITH
    kwpl AS (
        SELECT
            skw.part_no,
            ikw.description,
            skw.kw_value,
            pp.plant
        FROM
            specification_kw skw,
            itkw ikw,
            part_plant pp
        WHERE
            skw.kw_id = ikw.kw_id
            AND skw.part_no = pp.part_no
    ),
    sh AS (
        SELECT
            sh.part_no,
            sh.revision,
            ss.sort_desc,
            sh.planned_effective_date,
            TO_CHAR(sh.planned_effective_date, 'DD-MM-YYYY')
        FROM
            specification_header sh,
            status ss
        WHERE
            sh.access_group > 0
            AND sh.status = ss.status
            AND ss.status_type NOT IN ('HISTORIC', 'OBSOLETE')
            AND f_check_access(sh.part_no, sh.revision) = 1
    )
            
SELECT
    sh.part_no,
    sh.revision,
    f_shh_descr(1, sh.part_no) description,
    sh.sort_desc status,
    sh.planned_effective_date,
    TO_CHAR(sh.planned_effective_date, 'DD-MM-YYYY') ped_text,
    kwpl.description kw,
    kwpl.kw_value,
    kwpl.plant
FROM
    sh,
    kwpl
WHERE
    sh.part_no = kwpl.part_no(+);
--------------------------------------------------------
--  DDL for View AVSPECTRACCODES1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "INTERSPC"."AVSPECTRACCODES1" ("PART_NO", "REVISION", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "PLANT") AS 
  SELECT
    part_no,
    revision,
    sh.description,
    TO_CHAR(planned_effective_date, 'DD-MM-YYYY') AS planned_effective_date,
    plant
FROM
    specification_header sh
INNER JOIN
    part_plant
    USING (part_no)
--INNER JOIN
--    bom_header
--    USING (part_no, revision);
