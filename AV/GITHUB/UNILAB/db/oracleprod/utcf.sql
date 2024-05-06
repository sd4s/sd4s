--------------------------------------------------------
--  File created - donderdag-oktober-01-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table UTCF
--------------------------------------------------------

  CREATE TABLE "UNILAB"."UTCF" 
   (	"CF" VARCHAR2(20 CHAR), 
	"DESCRIPTION" VARCHAR2(40 CHAR), 
	"CF_TYPE" VARCHAR2(20 CHAR), 
	"CF_FILE" VARCHAR2(255 CHAR)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 5 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_DATAC" ;
--------------------------------------------------------
--  DDL for Index UKCF
--------------------------------------------------------

  CREATE UNIQUE INDEX "UNILAB"."UKCF" ON "UNILAB"."UTCF" ("CF", "CF_TYPE") 
  PCTFREE 0 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_INDEXC" ;
--------------------------------------------------------
--  Constraints for Table UTCF
--------------------------------------------------------

  ALTER TABLE "UNILAB"."UTCF" ADD CONSTRAINT "UKCF" PRIMARY KEY ("CF", "CF_TYPE")
  USING INDEX PCTFREE 0 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "UNI_INDEXC"  ENABLE;
