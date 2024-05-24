--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Type ATAO_ICLS
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."ATAO_ICLS" AS TABLE OF ic; 

/
--------------------------------------------------------
--  DDL for Type ATAO_IILS
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."ATAO_IILS" AS TABLE OF ii; 

/
--------------------------------------------------------
--  DDL for Type CORAWLIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."CORAWLIST" IS TABLE OF RAW(80)

/
--------------------------------------------------------
--  DDL for Type COSETTING
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."COSETTING" AS OBJECT (
  setting_seq        NUMBER(5),
  setting_name       VARCHAR2(40),
  setting_value      VARCHAR2(255))

/
--------------------------------------------------------
--  DDL for Type COSETTINGLIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."COSETTINGLIST" IS TABLE OF cosetting

/
--------------------------------------------------------
--  DDL for Type IC
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."IC" AS OBJECT (
  IC              VARCHAR2(20),
  ICNODE          NUMBER(9),
  IP_VERSION      VARCHAR2(20),
  DESCRIPTION     VARCHAR2(40),
  WINSIZE_X       NUMBER(4),
  WINSIZE_Y       NUMBER(4),
  IS_PROTECTED    CHAR (1),
  HIDDEN          CHAR (1),
  MANUALLY_ADDED  CHAR (1),
  NEXT_II         VARCHAR2(20),
  IC_CLASS        VARCHAR2(2),
  LOG_HS          CHAR (1),
  LOG_HS_DETAILS  CHAR (1),
  ALLOW_MODIFY    CHAR (1),
  AR              CHAR (1),
  ACTIVE          CHAR (1),
  LC              VARCHAR2(2),
  LC_VERSION      VARCHAR2(20),
  SS              VARCHAR2(2),
  IILS            ATAO_IILS
  ); 

/
--------------------------------------------------------
--  DDL for Type II
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."II" AS OBJECT (
  II              VARCHAR2(20),
  IINODE          NUMBER(9),
  IE_VERSION      VARCHAR2(20),
  IIVALUE         VARCHAR2(2000),
  POS_X           NUMBER(4),              
  POS_Y           NUMBER(4),              
  IS_PROTECTED    CHAR(1),
  MANDATORY       CHAR(1),
  HIDDEN          CHAR(1),
  DSP_TITLE       VARCHAR2(40),
  DSP_LEN         NUMBER(4),             
  DSP_TP          CHAR(1),
  DSP_ROWS        NUMBER(3),              
  II_CLASS        VARCHAR2(2),
  LOG_HS          CHAR(1),
  LOG_HS_DETAILS  CHAR(1),
  ALLOW_MODIFY    CHAR(1),
  AR              CHAR(1),
  ACTIVE          CHAR(1),
  LC              VARCHAR2(2),
  LC_VERSION      VARCHAR2(20),
  SS              VARCHAR2(2)
); 

/
--------------------------------------------------------
--  DDL for Type TZRECORD
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."TZRECORD" AS OBJECT (
  WindowsTZ       VARCHAR2(64),
  OracleTZ      VARCHAR2(64))

/
--------------------------------------------------------
--  DDL for Type TZTABLE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."TZTABLE" IS TABLE OF TZrecord

/
--------------------------------------------------------
--  DDL for Type UOEV
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."UOEV" AS OBJECT (
 tr_seq            NUMBER,
 ev_seq            NUMBER,
 created_on        TIMESTAMP(0) WITH LOCAL TIME ZONE,
 created_on_tz     TIMESTAMP(0) WITH TIME ZONE,
 client_id         VARCHAR2(20),
 applic            VARCHAR2(8),
 dbapi_name        VARCHAR2(40),
 evmgr_name        VARCHAR2(20),
 object_tp         VARCHAR2(4),
 object_id         VARCHAR2(20),
 object_lc         VARCHAR2(2),
 object_lc_version VARCHAR2(20),
 object_ss         VARCHAR2(2),
 ev_tp             VARCHAR2(60),
 username          VARCHAR2(30),
 ev_details        VARCHAR2(2000))

/
--------------------------------------------------------
--  DDL for Type UOEVLIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."UOEVLIST" IS TABLE OF uoev

/
--------------------------------------------------------
--  DDL for Type UORQSC
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."UORQSC" AS OBJECT (
  rq VARCHAR2(20),
  sc VARCHAR2(20),
  seq NUMBER,
  assign_date DATE,
  assigned_by VARCHAR2(20))

/
--------------------------------------------------------
--  DDL for Type UORQSCLIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."UORQSCLIST" IS TABLE OF uorqsc

/
--------------------------------------------------------
--  DDL for Type UOSTPPKEY
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."UOSTPPKEY" AS OBJECT (
  st         VARCHAR2(20),
  version    VARCHAR2(20),
  pp         VARCHAR2(20),
  pp_version VARCHAR2(20),
  pp_key1    VARCHAR2(20),
  pp_key2    VARCHAR2(20),
  pp_key3    VARCHAR2(20),
  pp_key4    VARCHAR2(20),
  pp_key5    VARCHAR2(20),
  seq        NUMBER(5))

/
--------------------------------------------------------
--  DDL for Type UOSTPPKEYLIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."UOSTPPKEYLIST" IS TABLE OF uostppkey

/
--------------------------------------------------------
--  DDL for Type VC20_NESTEDTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."VC20_NESTEDTABLE_TYPE" AS TABLE OF VARCHAR2(20)

/
--------------------------------------------------------
--  DDL for Type VC255_NESTEDTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."VC255_NESTEDTABLE_TYPE" AS TABLE OF VARCHAR2(255)

/
--------------------------------------------------------
--  DDL for Type VC40_NESTEDTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "UNILAB"."VC40_NESTEDTABLE_TYPE" AS TABLE OF VARCHAR2(40)

/
