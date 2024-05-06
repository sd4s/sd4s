DROP TABLE INTERSPC.ATCATIAMAPPING CASCADE CONSTRAINTS;

CREATE TABLE INTERSPC.ATCATIAMAPPING
(
  FRAME_NO             VARCHAR2(18 BYTE)        NOT NULL,
  FRAME_REV            NUMBER(6,2)              NOT NULL,
  SECTION_DESC         VARCHAR2(60 BYTE),
  SUB_SECTION_DESC     VARCHAR2(60 BYTE),
  PROPERTY_GROUP_DESC  VARCHAR2(60 BYTE),
  PROPERTY_DESC        VARCHAR2(60 BYTE),
  ATTRIBUTE_DESC       VARCHAR2(60 BYTE),
  FIELD_TYPE           VARCHAR2(60 BYTE),
  CATIA_VAR            VARCHAR2(60 BYTE)        NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;


CREATE UNIQUE INDEX INTERSPC.ATCATIAMAPPING_PK ON INTERSPC.ATCATIAMAPPING
(FRAME_NO, FRAME_REV, CATIA_VAR)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE INTERSPC.ATCATIAMAPPING ADD (
  CONSTRAINT ATCATIAMAPPING_PK
  PRIMARY KEY
  (FRAME_NO, FRAME_REV, CATIA_VAR)
  USING INDEX INTERSPC.ATCATIAMAPPING_PK
  ENABLE VALIDATE);



prompt
prompt create AVCATIAMAPPING-view
prompt
  
/* Formatted on 7/9/2020 13:02:26 (QP5 v5.360) */
CREATE OR REPLACE FORCE VIEW INTERSPC.AVCATIAMAPPING
(
    FRAME_NO,
    FRAME_REV,
    SECTION,
    SUB_SECTION,
    PROPERTY_GROUP,
    PROPERTY,
    ATTRIBUTE,
    FIELD,
    CATIA_VARIABLE
)
AS
      SELECT frame_no,
             frame_rev,
             section_id         AS section,
             sub_section_id     AS sub_section,
             property_group,
             property,
             attribute,
             field_type         AS field,
             catia_var          AS catia_variable
        FROM atCatiaMapping
             LEFT JOIN section
                 ON (NVL (section_desc, '(none)') = section.description)
             LEFT JOIN sub_section
                 ON (NVL (sub_section_desc, '(none)') = sub_section.description)
             LEFT JOIN property_group
                 ON (NVL (property_group_desc, 'default property group') =
                     property_group.description)
             LEFT JOIN property ON (property_desc = property.description)
             LEFT JOIN attribute ON (attribute_desc = attribute.description)
    ORDER BY section_id,
             sub_section_id,
             property_group,
             property,
             attribute,
             field_type;

