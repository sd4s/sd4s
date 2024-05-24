--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Type BOMHEADERRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."BOMHEADERRECORD_TYPE" AS OBJECT(
         PartNo                     	VARCHAR2(18),
         Revision                    	NUMBER(4),
         Plant                          VARCHAR2(8),
         Alternative                 	NUMBER(2),
         BomUsage                	NUMBER(2),
         Description                	VARCHAR2(60),
         PlantDescription        	VARCHAR2(60),
         UsageDescription     		VARCHAR2(60),
         Quantity                     	NUMBER(17,7),
         Uom                            VARCHAR2(60),
         ConversionFactor       	NUMBER,
         ConvertedUom           	VARCHAR2(60),
         ConvertedQuantity     		NUMBER(17,7),
         MinimumQuantity        	NUMBER(17,7),
         MaximumQuantity       		NUMBER(17,7),
         Yield                          NUMBER(13,3),
         CalculationMode         	VARCHAR2(1),
         BomItemType              	VARCHAR2(5),
         PlannedEffectiveDate 		DATE,
         Preferred                      NUMBER(1),
         HasItems			NUMBER(1),
	 SpecificationDescription	VARCHAR2(60)
)

/
--------------------------------------------------------
--  DDL for Type BOMHEADERTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."BOMHEADERTABLE_TYPE" AS TABLE OF BomHeaderRecord_Type

/
--------------------------------------------------------
--  DDL for Type BOMITEMRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."BOMITEMRECORD_TYPE" AS OBJECT(
       PartNo                        VARCHAR2( 18 ),
       Revision                      NUMBER( 4 ),
       Plant                         VARCHAR2( 8 ),
       Alternative                   NUMBER( 2 ),
       BomUsage                      NUMBER( 2 ),
       ItemNumber                    NUMBER( 4 ),
       AlternativeGroup              VARCHAR2( 60 ),
       AlternativePriority           NUMBER( 2 ),
       ComponentPartNo               VARCHAR2( 18 ),
       ComponentRevision             NUMBER( 4 ),
       ComponentDescription          VARCHAR2( 60 ),
       ComponentPlant                VARCHAR2( 8 ),
       PartSource                    VARCHAR2( 3 ),
       PartTypeGroup                 VARCHAR2( 5 ),
       Quantity                      NUMBER( 17, 7 ),
       Uom                           VARCHAR2( 60 ),
       ConversionFactor              NUMBER,
       ConvertedUom                  VARCHAR2( 60 ),
       Yield                         NUMBER( 13, 3 ),
       AssemblyScrap                 NUMBER( 5, 2 ),
       ComponentScrap                NUMBER( 5, 2 ),
       LeadTimeOffset                NUMBER( 3 ),
       RelevancyToCosting            NUMBER( 1 ),
       BulkMaterial                  NUMBER( 1 ),
       ItemCategory                  VARCHAR2( 1 ),
       ItemCategoryDescr             VARCHAR2( 60 ),
       IssueLocation                 VARCHAR2( 4 ),
       CalculationMode               VARCHAR2( 1 ),
       BomItemType                   VARCHAR2( 5 ),
       OperationalStep               NUMBER( 6 ),
       MinimumQuantity               NUMBER( 17, 7 ),
       MaximumQuantity               NUMBER( 17, 7 ),
       FixedQuantity                 NUMBER( 1 ),
       Code                          VARCHAR2( 6 ),
       Text1                         VARCHAR2( 255 ),
       Text2                         VARCHAR2( 255 ),
       Text3                         VARCHAR2( 40 ),
       Text4                         VARCHAR2( 40 ),
       Text5                         VARCHAR2( 40 ),
       Numeric1                      FLOAT,
       Numeric2                      FLOAT,
       Numeric3                      FLOAT,
       Numeric4                      FLOAT,
       Numeric5                      FLOAT,
       Boolean1                      NUMBER( 1 ),
       Boolean2                      NUMBER( 1 ),
       Boolean3                      NUMBER( 1 ),
       Boolean4                      NUMBER( 1 ),
       Date1                         DATE,
       Date2                         DATE,
       Characteristic1               INTEGER,
       Characteristic1Revision       NUMBER( 4 ),
       Characteristic2               INTEGER,
       Characteristic2Revision       NUMBER( 4 ),
       Characteristic3               INTEGER,
       Characteristic3Revision       NUMBER( 4 ),
       Characteristic1Description    VARCHAR2( 60 ),
       Characteristic2Description    VARCHAR2( 60 ),
       Characteristic3Description    VARCHAR2( 60 ),
       MakeUp                        NUMBER( 1 ),
       InternationalEquivalent       VARCHAR2( 18 ),
       ViewBomAccess                 NUMBER( 1 ),
       ComponentScrapSync            NUMBER( 1 ),
       Owner                         NUMBER( 4 )
)

/
--------------------------------------------------------
--  DDL for Type BOMITEMTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."BOMITEMTABLE_TYPE" AS TABLE OF BomItemRecord_Type

/
--------------------------------------------------------
--  DDL for Type CORAWLIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."CORAWLIST" IS TABLE OF RAW(80)

/
--------------------------------------------------------
--  DDL for Type COSETTING
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."COSETTING" AS OBJECT(
   setting_seq                   NUMBER( 5 ),
   setting_name                  VARCHAR2( 40 ),
   setting_value                 VARCHAR2( 255 )
)

/
--------------------------------------------------------
--  DDL for Type COSETTINGLIST
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."COSETTINGLIST" IS TABLE OF cosetting

/
--------------------------------------------------------
--  DDL for Type ERRORDATATABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."ERRORDATATABLE_TYPE" AS TABLE OF  ERRORRECORD_TYPE

/
--------------------------------------------------------
--  DDL for Type ERRORRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."ERRORRECORD_TYPE" AS OBJECT
(
  MESSAGETYPE INTEGER,
  PARAMETERID VARCHAR2(255),
  ERRORTEXT VARCHAR2(2048)
)

/
--------------------------------------------------------
--  DDL for Type FRSECTIONDATATABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."FRSECTIONDATATABLE_TYPE" AS TABLE OF FRSECTIONRECORD_TYPE;

/
--------------------------------------------------------
--  DDL for Type FRSECTIONRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."FRSECTIONRECORD_TYPE" AS OBJECT
(
  FRAMENO  		   	   VARCHAR2(18),
  REVISION		   	   NUMBER(6,2),
  SECTIONID	 	   	   NUMBER,
  SECTIONREVISION	   NUMBER(4),
  SECTIONNAME		   VARCHAR2(60),
  SUBSECTIONID	   	   NUMBER,
  SUBSECTIONREVISION   NUMBER(4),
  SUBSECTIONNAME	   VARCHAR2(60),
  SEQUENCE			   NUMBER(13),
  EXTENDABLE		   NUMBER(1),
  ROWINDEX		   	   NUMBER(13),
  PARENTROWINDEX       NUMBER(13)
);

/
--------------------------------------------------------
--  DDL for Type MOPRPVSECTIONDATARECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."MOPRPVSECTIONDATARECORD_TYPE" AS OBJECT(
   USERID                        VARCHAR2( 8 ),
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   TEXT                          VARCHAR2( 2000 ),
   INTERNATIONAL                 NUMBER,
   FIELDTYPE                     VARCHAR2( 255 ),
   OLDVALUECHAR                  VARCHAR2( 255 ),
   NEWVALUECHAR                  VARCHAR2( 255 ),
   OLDVALUENUM                   FLOAT,
   NEWVALUENUM                   FLOAT,
   OLDVALUEDATE                  DATE,
   NEWVALUEDATE                  DATE,
   OLDVALUETMID                  FLOAT,
   NEWVALUETMID                  FLOAT,
   OLDVALUETM					 VARCHAR2(60),
   OLDVALUEASSID                 FLOAT,
   NEWVALUEASSID                 FLOAT,
   OLDVALUEASS					 VARCHAR2(60),
   ROWINDEX   					 NUMBER
);

/
--------------------------------------------------------
--  DDL for Type MOPRPVSECTIONDATATABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."MOPRPVSECTIONDATATABLE_TYPE" AS TABLE OF MopRpvSectionDataRecord_Type;

/
--------------------------------------------------------
--  DDL for Type NUTRESULTDETAILRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."NUTRESULTDETAILRECORD_TYPE" AS OBJECT(
       COLID                         NUMBER( 8 ),
       HEADER                        VARCHAR2( 60 ),
       ROW_ID                        NUMBER( 8 ),
       DATATYPE                      NUMBER( 1 ),
       DISPLAYNAME                   VARCHAR2( 60 ),
       DESCRIPTION                   VARCHAR2( 60 ),
       CALCQTY                       NUMBER( 17, 7 ),
       TEXT                          VARCHAR2( 100 ),
       VALUE                         VARCHAR2( 60 )
)

/
--------------------------------------------------------
--  DDL for Type NUTRESULTDETAILTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."NUTRESULTDETAILTABLE_TYPE" AS TABLE OF NutResultDetailRecord_Type

/
--------------------------------------------------------
--  DDL for Type PA_LIMSSPC_VC20NESTEDTABLETYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."PA_LIMSSPC_VC20NESTEDTABLETYPE" AS TABLE OF VARCHAR2(20)

/
--------------------------------------------------------
--  DDL for Type PRLINERECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."PRLINERECORD_TYPE" IS OBJECT(
      PARTNO            VARCHAR2(18),
      PLANTNO 		VARCHAR2(8),
      LINE 		VARCHAR2(4),
      CONFIGURATION 	NUMBER(4),
      LINEREVISION 	NUMBER(4),
      DESCRIPTION   VARCHAR2(60),
      ROWINDEX 		NUMBER
   )

/
--------------------------------------------------------
--  DDL for Type PRLINETABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."PRLINETABLE_TYPE" AS TABLE OF PrLineRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPATTACHEDSPECITEMRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPATTACHEDSPECITEMRECORD_TYPE" AS OBJECT(
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   SECTIONID                     NUMBER( 8 ),
   SUBSECTIONID                  NUMBER( 8 ),
   ITEMID                        NUMBER( 8 ),
   ATTACHEDPARTNO                VARCHAR2( 18 ),
   ATTACHEDREVISION              NUMBER( 4 ),
   INTERNATIONAL                 NUMBER( 1 ),
   ATTACHEDDESCRIPTION           VARCHAR2( 60 ),
   STATUSID                      INTEGER,
   STATUSNAME                    VARCHAR2( 20 ),
   ATTACHEDPHANTOM               NUMBER( 1 ),
   SPECIFICATIONACCESS           NUMBER( 1 ),
   STATUSTYPE                    VARCHAR2( 11 ),
   ROWINDEX                      NUMBER
)

/
--------------------------------------------------------
--  DDL for Type SPATTACHEDSPECITEMTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPATTACHEDSPECITEMTABLE_TYPE" as TABLE OF SpAttachedSpecItemRecord_TYpe

/
--------------------------------------------------------
--  DDL for Type SPBASENAMERECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPBASENAMERECORD_TYPE" AS OBJECT(
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   SECTIONID                     NUMBER( 8 ),
   SECTIONREVISION               NUMBER( 4 ),
   SUBSECTIONID                  NUMBER( 8 ),
   SUBSECTIONREVISION            NUMBER( 4 ),
   ITEMID                        NUMBER( 8 ),
   ITEMREVISION                  NUMBER( 4 ),
   INGREDIENT					 VARCHAR2( 256 )
);

/
--------------------------------------------------------
--  DDL for Type SPBASENAMETABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPBASENAMETABLE_TYPE" AS TABLE OF SPBASENAMERECORD_TYPE;

/
--------------------------------------------------------
--  DDL for Type SPCHEMICALLISTITEMRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPCHEMICALLISTITEMRECORD_TYPE" AS OBJECT(
      PARTNO            	VARCHAR2(18),
      REVISION         		NUMBER(4),
      SECTIONID        		INTEGER,
      SUBSECTIONID        	INTEGER,
      INGREDIENTID              INTEGER,
      INGREDIENTREVISION   	NUMBER(4),
      INGREDIENTQUANTITY        NUMBER(17,7),
      INGREDIENTLEVEL   	VARCHAR2(10),
      INGREDIENTCOMMENT 	VARCHAR2(25),
      INTERNATIONAL 		NUMBER(1),
      SEQUENCE 			NUMBER(4),
      ACTIVEINGREDIENT 		NUMBER(1),
      SYNONYMID 		INTEGER,
      SYNONYMREVISION 		NUMBER(4),
      ALTERNATIVELANGUAGEID 	NUMBER(2),
      ALTERNATIVELEVEL 		VARCHAR2(10),
      ALTERNATIVECOMMENT 	VARCHAR2(25),
      INGREDIENT 		VARCHAR2(256),
      SYNONYMNAME 		VARCHAR2(256),
      TRANSLATED 		NUMBER(1),
      DECLAREFLAG               NUMBER(1),
      ROWINDEX 			NUMBER
)

/
--------------------------------------------------------
--  DDL for Type SPCHEMICALLISTITEMTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPCHEMICALLISTITEMTABLE_TYPE" AS TABLE OF SpChemicalListItemRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPECREFRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPECREFRECORD_TYPE" 
AS   OBJECT(
        part_no VARCHAR2(18),
        revision NUMBER(4, 0),
        description VARCHAR2(60)
     ); 

/
--------------------------------------------------------
--  DDL for Type SPECREFTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPECREFTABLE_TYPE" 
IS   TABLE OF SpecRefRecord_Type; 

/
--------------------------------------------------------
--  DDL for Type SPFREETEXTRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPFREETEXTRECORD_TYPE" AS OBJECT(
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   SECTIONID                     NUMBER( 8 ),
   SECTIONREVISION               NUMBER( 4 ),
   SUBSECTIONID                  NUMBER( 8 ),
   SUBSECTIONREVISION            NUMBER( 4 ),
   ITEMID                        NUMBER( 8 ),
   ITEMREVISION                  NUMBER( 4 ),
   ITEMDESCRIPTION               VARCHAR2( 60 ),
   TEXT                          CLOB,
   LANGUAGEID                    NUMBER( 2 ),
   INCLUDED                      NUMBER( 1 )
);

/
--------------------------------------------------------
--  DDL for Type SPFREETEXTTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPFREETEXTTABLE_TYPE" AS TABLE OF SPFREETEXTRECORD_TYPE;

/
--------------------------------------------------------
--  DDL for Type SPGETATTSPECITEMRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPGETATTSPECITEMRECORD_TYPE" AS OBJECT(
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   SECTIONID                     NUMBER( 8 ),
   SUBSECTIONID                  NUMBER( 8 ),
   ITEMID                        NUMBER( 8 ),
   ATTACHEDPARTNO                VARCHAR2( 18 ),
   ATTACHEDREVISION              NUMBER( 4 ),
   INTERNATIONAL                 NUMBER( 1 ),
   ATTACHEDDESCRIPTION           VARCHAR2( 60 ),
   STATUSID                      INTEGER,
   STATUSNAME                    VARCHAR2( 20 ),
   ATTACHEDPHANTOM               NUMBER( 1 ),
   SPECIFICATIONACCESS           NUMBER( 1 ),
   STATUSTYPE                    VARCHAR2( 11 ),
   OWNER                         NUMBER( 4 ),
   --AP00847482 Start
   ATTACHEDREVISIONPHANTOM       NUMBER( 4 ),
   --AP00847482 End
   ROWINDEX                      NUMBER
)

/
--------------------------------------------------------
--  DDL for Type SPGETATTSPECITEMTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPGETATTSPECITEMTABLE_TYPE" AS TABLE OF SpGetAttSpecItemRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPHEADERITEMDATATABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPHEADERITEMDATATABLE_TYPE" AS TABLE OF SPHEADERITEMRECORD_TYPE;

/
--------------------------------------------------------
--  DDL for Type SPHEADERITEMRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPHEADERITEMRECORD_TYPE" AS OBJECT(
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   NAME                      	 VARCHAR2( 30 ),
   ROWINDEX                      NUMBER( 13 ),
   PARENTROWINDEX                NUMBER( 13 )
);

/
--------------------------------------------------------
--  DDL for Type SPINGLISTITEMRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPINGLISTITEMRECORD_TYPE" AS OBJECT(
      PARTNO            	VARCHAR2(18),
      REVISION        	 	NUMBER(4),
      SECTIONID        		INTEGER,
      SUBSECTIONID        	INTEGER,
      INGREDIENTID              INTEGER,
      INGREDIENTREVISION   	NUMBER(4),
      INGREDIENTQUANTITY        NUMBER(17,7),
      INGREDIENTLEVEL   	VARCHAR2(10),
      --TFS 4946
      --INGREDIENTCOMMENT 	VARCHAR2(25),-- orig
      INGREDIENTCOMMENT 	VARCHAR2(256 CHAR),
      INTERNATIONAL 		NUMBER(1),
      SEQUENCE 			NUMBER(4),
      PARENTID 			INTEGER,
      HIERARCHICALLEVEL 	NUMBER(5,2),
      RECONSTITUTIONFACTOR 	NUMBER(4,2),
      SYNONYMID 		INTEGER,
      SYNONYMREVISION 		NUMBER(4),
      ALTERNATIVELANGUAGEID 	NUMBER(2),
      ALTERNATIVELEVEL 		VARCHAR2(10),
      ALTERNATIVECOMMENT 	VARCHAR2(25),
      INGREDIENT 		VARCHAR2(256),
      SYNONYMNAME 		VARCHAR2(256),
      TRANSLATED 		NUMBER(1),
      DECLAREFLAG               NUMBER(1),
      ROWINDEX 			NUMBER
)

/
--------------------------------------------------------
--  DDL for Type SPINGLISTITEMRECORDPB_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPINGLISTITEMRECORDPB_TYPE" AS OBJECT(
      PARTNO                VARCHAR2(18),
      REVISION                 NUMBER(4),
      SECTIONID                INTEGER,
      SUBSECTIONID            INTEGER,
      INGREDIENTID              INTEGER,
      INGREDIENTREVISION       NUMBER(4),
      INGREDIENTQUANTITY        NUMBER(17,7),
      INGREDIENTLEVEL       VARCHAR2(10),
      -- TFS 4946
      INGREDIENTCOMMENT     VARCHAR2(256 CHAR),
      INTERNATIONAL         NUMBER(1),
      SEQUENCE             NUMBER(4),
      PARENTID             INTEGER,
      HIERARCHICALLEVEL     NUMBER(5,2),
      RECONSTITUTIONFACTOR     NUMBER(4,2),
      SYNONYMID         INTEGER,
      SYNONYMREVISION         NUMBER(4),
      ALTERNATIVELANGUAGEID     NUMBER(2),
      ALTERNATIVELEVEL         VARCHAR2(10),
      ALTERNATIVECOMMENT     VARCHAR2(25),
      INGREDIENT         VARCHAR2(256),
      SYNONYMNAME         VARCHAR2(256),
      TRANSLATED         NUMBER(1),
      DECLAREFLAG               NUMBER(1),
      --AP00892453 --AP00888937
      PIDLIST                   VARCHAR2( 2048 ),
      ROWINDEX             NUMBER
)

/
--------------------------------------------------------
--  DDL for Type SPINGLISTITEMTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPINGLISTITEMTABLE_TYPE" AS TABLE OF SpIngListItemRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPINGLISTITEMTABLEPB_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPINGLISTITEMTABLEPB_TYPE" AS TABLE OF SpIngListItemRecordPb_Type

/
--------------------------------------------------------
--  DDL for Type SPNUMTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPNUMTABLE_TYPE" as Table of number(8)

/
--------------------------------------------------------
--  DDL for Type SPOBJECTRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPOBJECTRECORD_TYPE" IS OBJECT (
      PARTNO            	VARCHAR2(18),
      REVISION         		NUMBER(4),
      SECTIONID        		INTEGER,
      SECTIONREVISION   	NUMBER(4),
      SUBSECTIONID        	INTEGER,
      SUBSECTIONREVISION   	NUMBER(4),
      ITEMID               	INTEGER,
      ITEMREVISION      	NUMBER(4),
      ITEMOWNER     		NUMBER(4),
      SECTIONSEQUENCENUMBER 	NUMBER(13)
   )

/
--------------------------------------------------------
--  DDL for Type SPOBJECTTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPOBJECTTABLE_TYPE" as TABLE OF SpObjectRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPPARTRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPARTRECORD_TYPE" IS OBJECT(
      PARTNO            VARCHAR2(18),
      DESCRIPTION       VARCHAR2(60),
      BASEUOM          	VARCHAR2(3),
      PARTSOURCE        VARCHAR2(3),
      BASECONVFACTOR    NUMBER,
      BASETOUNIT     	VARCHAR2(3),
      PARTTYPEID   	INTEGER,
      DATEIMPORTED      DATE,
      EANUPCBARCODE     VARCHAR2(18),
      OBSOLETE    	NUMBER(1),
      PARTTYPE 		VARCHAR2(10)
   )

/
--------------------------------------------------------
--  DDL for Type SPPARTTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPARTTABLE_TYPE" IS TABLE OF spPartRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPPDLINERECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDLINERECORD_TYPE" IS OBJECT(
      PARTNO            VARCHAR2(18),
      REVISION         	NUMBER(4),
      PLANTNO 		    VARCHAR2(8),
      LINE 		        VARCHAR2(4),
      CONFIGURATION 	NUMBER(4),
      LINEREVISION 	    NUMBER(4),
      ITEMPARTNO        VARCHAR2(18),
      ITEMREVISION      NUMBER(4),
      SEQUENCE          NUMBER (8),
      ROWINDEX 		    NUMBER
   )

/
--------------------------------------------------------
--  DDL for Type SPPDLINETABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDLINETABLE_TYPE" AS TABLE OF SpPdLineRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPPDSTAGEDATARECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDSTAGEDATARECORD_TYPE" AS OBJECT(
       PARTNO                        VARCHAR2( 18 ),
       REVISION                      NUMBER( 4 ),
       SECTIONID                     INTEGER,
       SECTIONREVISION               NUMBER( 4 ),
       SUBSECTIONID                  INTEGER,
       SUBSECTIONREVISION            NUMBER( 4 ),
       STAGEID                       NUMBER( 6 ),
       PROPERTYID                    INTEGER,
       PROPERTYREVISION              NUMBER( 4 ),
       PROPERTY                      VARCHAR2( 60 ),
       ATTRIBUTEID                   INTEGER,
       ATTRIBUTEREVISION             NUMBER( 4 ),
       ATTRIBUTE                     VARCHAR2( 60 ),
       TESTMETHODID                  INTEGER,
       TESTMETHODREVISION            NUMBER( 4 ),
       TESTMETHOD                    VARCHAR2( 60 ),
       STRING1                       VARCHAR2( 40 ),
       STRING2                       VARCHAR2( 40 ),
       STRING3                       VARCHAR2( 40 ),
       STRING4                       VARCHAR2( 40 ),
       STRING5                       VARCHAR2( 40 ),
       STRING6                       VARCHAR2( 256 ),
       BOOLEAN1                      VARCHAR2( 1 ),
       BOOLEAN2                      VARCHAR2( 1 ),
       BOOLEAN3                      VARCHAR2( 1 ),
       BOOLEAN4                      VARCHAR2( 1 ),
       DATE1                         DATE,
       DATE2                         DATE,
       CHARACTERISTICID1             INTEGER,
       CHARACTERISTICREVISION1       NUMBER( 4 ),
       CHARACTERISTICDESCRIPTION1    VARCHAR2( 60 ),
       NUMERIC1                      FLOAT,
       NUMERIC2                      FLOAT,
       NUMERIC3                      FLOAT,
       NUMERIC4                      FLOAT,
       NUMERIC5                      FLOAT,
       NUMERIC6                      FLOAT,
       NUMERIC7                      FLOAT,
       NUMERIC8                      FLOAT,
       NUMERIC9                      FLOAT,
       NUMERIC10                     FLOAT,
       ASSOCIATIONID1                INTEGER,
       ASSOCIATIONREVISION1          NUMBER( 4 ),
       INTERNATIONAL                 VARCHAR2( 1 ),
       UPPERLIMIT                    NUMBER,
       LOWERLIMIT                    NUMBER,
       UOMID                         NUMBER( 8 ),
       UOMREVISION                   NUMBER( 4 ),
       UOM                           VARCHAR2( 60 ),
       STAGE                         VARCHAR2( 60 ),
       PLANTNO                       VARCHAR2( 8 ),
       CONFIGURATION                 NUMBER( 4 ),
       LINEREVISION                  NUMBER( 4 ),
       LINE                          VARCHAR2( 4 ),
       TEXT                          VARCHAR2( 255 ),
       SEQUENCE                      NUMBER( 8 ),
       VALUETYPE                     NUMBER( 1 ),
       COMPONENTPARTNO               VARCHAR2( 18 ),
       ITEMDESCRIPTION               VARCHAR2( 60 ),
       STAGEREVISION                 NUMBER( 4 ),
       --AP00978864 --AP00978035 Start
    --   QUANTITY                      NUMBER( 13, 3 ), --orig
    --   QUANTITYBOMPCT                NUMBER( 13, 3 ), --orig
       QUANTITY                      NUMBER( 17, 7 ),
       QUANTITYBOMPCT                NUMBER( 17, 7 ),
       --AP00978864 --AP00978035 End
       UOMBOMPCT                     VARCHAR2( 60 ),
       BOMALTERNATIVE                NUMBER( 2 ),
       BOMUSAGEID                    NUMBER( 2 ),
       ALTERNATIVELANGUAGEID         NUMBER( 2 ),
       ALTERNATIVESTRING1            VARCHAR2( 40 ),
       ALTERNATIVESTRING2            VARCHAR2( 40 ),
       ALTERNATIVESTRING3            VARCHAR2( 40 ),
       ALTERNATIVESTRING4            VARCHAR2( 40 ),
       ALTERNATIVESTRING5            VARCHAR2( 40 ),
       ALTERNATIVESTRING6            VARCHAR2( 256 ),
       ALTERNATIVETEXT               VARCHAR2( 255 ),
       TRANSLATED                    NUMBER( 1 ),
       --AP01173640 Start
       --OWNER                         NUMBER( 1 ), --orig
       OWNER                         NUMBER( 4 ),
       --AP01173640 End
       ROWINDEX                      NUMBER
)

/
--------------------------------------------------------
--  DDL for Type SPPDSTAGEDATATABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDSTAGEDATATABLE_TYPE" AS TABLE OF SpPdStageDataRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPPDSTAGEFREETEXTRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDSTAGEFREETEXTRECORD_TYPE" IS OBJECT(
      PARTNO   		VARCHAR2(18),
      REVISION   	NUMBER(4),
      PLANTNO 		VARCHAR2(8),
      LINE 		VARCHAR2(4),
      CONFIGURATION 	NUMBER(4),
      LINEREVISION 	NUMBER(4),
      STAGEID 		NUMBER(6),
      FREETEXTID 	INTEGER,
	  ITEMDESCRIPTION VARCHAR2(60),
      TEXT 		CLOB,
      LANGUAGEID        NUMBER(2),
      ROWINDEX 		NUMBER
   )

/
--------------------------------------------------------
--  DDL for Type SPPDSTAGEFREETEXTTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDSTAGEFREETEXTTABLE_TYPE" AS TABLE OF SpPdStageFreeTextRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPPDSTAGERECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDSTAGERECORD_TYPE" IS OBJECT(
      PARTNO           		VARCHAR2(18),
      REVISION         		NUMBER(4),
      PLANTNO 			VARCHAR2(8),
      LINE 			VARCHAR2(4),
      CONFIGURATION 		NUMBER(4),
      LINEREVISION 		NUMBER(4),
      STAGEID 			NUMBER(6),
      STAGE 			VARCHAR2(60),
      SEQUENCE 			NUMBER(3),
      RECIRCULATETO 		NUMBER(3),
      FREETEXTID 		INTEGER,
      DISPLAYFORMATID 		INTEGER,
      DISPLAYFORMATREVISION 	NUMBER(4),
      ROWINDEX 			NUMBER
   )

/
--------------------------------------------------------
--  DDL for Type SPPDSTAGETABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPDSTAGETABLE_TYPE" AS TABLE OF SpPdStageRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPPROPERTYRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPROPERTYRECORD_TYPE" AS OBJECT(
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   SECTIONID                     INTEGER,
   SECTIONREVISION               NUMBER( 4 ),
   SUBSECTIONID                  INTEGER,
   SUBSECTIONREVISION            NUMBER( 4 ),
   PROPERTYGROUPID               INTEGER,
   PROPERTYGROUPREVISION         NUMBER( 4 ),
   PROPERTYGROUP                 VARCHAR2( 60 ),
   PROPERTYID                    INTEGER,
   PROPERTYREVISION              NUMBER( 4 ),
   PROPERTY                      VARCHAR2( 60 ),
   ATTRIBUTEID                   INTEGER,
   ATTRIBUTEREVISION             NUMBER( 4 ),
   ATTRIBUTE                     VARCHAR2( 60 ),
   DISPLAYFORMATID               INTEGER,
   TESTMETHODID                  INTEGER,
   TESTMETHODREVISION            NUMBER( 4 ),
   TESTMETHOD                    VARCHAR2( 60 ),
   STRING1                       VARCHAR2( 40 ),
   STRING2                       VARCHAR2( 40 ),
   STRING3                       VARCHAR2( 40 ),
   STRING4                       VARCHAR2( 40 ),
   STRING5                       VARCHAR2( 40 ),
   STRING6                       VARCHAR2( 256 ),
   BOOLEAN1                      NUMBER( 1 ),
   BOOLEAN2                      NUMBER( 1 ),
   BOOLEAN3                      NUMBER( 1 ),
   BOOLEAN4                      NUMBER( 1 ),
   DATE1                         DATE,
   DATE2                         DATE,
   CHARACTERISTICID1             INTEGER,
   CHARACTERISTICREVISION1       NUMBER( 4 ),
   CHARACTERISTICDESCRIPTION1    VARCHAR2( 60 ),
   CHARACTERISTICID2             INTEGER,
   CHARACTERISTICREVISION2       NUMBER( 4 ),
   CHARACTERISTICDESCRIPTION2    VARCHAR2( 60 ),
   CHARACTERISTICID3             INTEGER,
   CHARACTERISTICREVISION3       NUMBER( 4 ),
   CHARACTERISTICDESCRIPTION3    VARCHAR2( 60 ),
   TESTMETHODSETNO               NUMBER( 4 ),
   METHODDETAIL                  VARCHAR2( 1 ),
   INFO                          VARCHAR2( 4000 ),
   UOM                           VARCHAR2( 60 ),
   NUMERIC1                      FLOAT,
   NUMERIC2                      FLOAT,
   NUMERIC3                      FLOAT,
   NUMERIC4                      FLOAT,
   NUMERIC5                      FLOAT,
   NUMERIC6                      FLOAT,
   NUMERIC7                      FLOAT,
   NUMERIC8                      FLOAT,
   NUMERIC9                      FLOAT,
   NUMERIC10                     FLOAT,
   TESTMETHODDETAILS1            NUMBER( 1 ),
   TESTMETHODDETAILS2            NUMBER( 1 ),
   TESTMETHODDETAILS3            NUMBER( 1 ),
   TESTMETHODDETAILS4            NUMBER( 1 ),
   ALTERNATIVELANGUAGEID         NUMBER( 2 ),
   ALTERNATIVESTRING1            VARCHAR2( 40 ),
   ALTERNATIVESTRING2            VARCHAR2( 40 ),
   ALTERNATIVESTRING3            VARCHAR2( 40 ),
   ALTERNATIVESTRING4            VARCHAR2( 40 ),
   ALTERNATIVESTRING5            VARCHAR2( 40 ),
   ALTERNATIVESTRING6            VARCHAR2( 256 ),
   ALTERNATIVEINFO               VARCHAR2( 4000 ),
   UOMID                         INTEGER,
   UOMREVISION                   NUMBER( 4 ),
   ASSOCIATIONID1                INTEGER,
   ASSOCIATIONREVISION1          NUMBER( 4 ),
   ASSOCIATIONDESCRIPTION1       VARCHAR2( 60 ),
   ASSOCIATIONID2                INTEGER,
   ASSOCIATIONREVISION2          NUMBER( 4 ),
   ASSOCIATIONDESCRIPTION2       VARCHAR2( 60 ),
   ASSOCIATIONID3                INTEGER,
   ASSOCIATIONREVISION3          NUMBER( 4 ),
   ASSOCIATIONDESCRIPTION3       VARCHAR2( 60 ),
   INTERNATIONAL                 VARCHAR2( 1 ),
   SEQUENCE                      NUMBER( 8 ),
   UPPERLIMIT                    NUMBER,
   LOWERLIMIT                    NUMBER,
   HASTESTMETHODCONDITION        NUMBER( 1 ),
   INCLUDED                      NUMBER( 1 ),
   OPTIONAL                      NUMBER( 1 ),
   EXTENDED                      NUMBER( 1 ),
   TRANSLATED                    NUMBER( 1 ),
   ROWINDEX                      NUMBER,
   EDITABLE                      NUMBER( 1 )
)

/
--------------------------------------------------------
--  DDL for Type SPPROPERTYTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPPROPERTYTABLE_TYPE" AS TABLE OF SpPropertyRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPREFERENCETEXTRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPREFERENCETEXTRECORD_TYPE" IS  OBJECT(
      PARTNO           		VARCHAR2(18),
      REVISION         		NUMBER(4),
      SECTIONID        		INTEGER,
      SECTIONREVISION   	NUMBER(4),
      SUBSECTIONID        	INTEGER,
      SUBSECTIONREVISION   	NUMBER(4),
      ITEMID               	INTEGER,
      ITEMREVISION      	NUMBER(4),
      ITEMOWNER     		NUMBER(4),
      TEXT 			CLOB,
      LANGUAGEID                NUMBER(2),
      DESCRIPTION               VARCHAR2(70),
      INTERNATIONAL             NUMBER(1)
   )

/
--------------------------------------------------------
--  DDL for Type SPREFERENCETEXTTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPREFERENCETEXTTABLE_TYPE" as TABLE of SpReferenceTextRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPSECTIONDATATABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPSECTIONDATATABLE_TYPE" AS TABLE OF SPSECTIONRECORD_TYPE

/
--------------------------------------------------------
--  DDL for Type SPSECTIONITEMRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPSECTIONITEMRECORD_TYPE" IS OBJECT (
      PARTNO    VARCHAR2(18),
      REVISION    NUMBER(4),
      SECTIONID    INTEGER,
      SECTIONREVISION   NUMBER(4),
      SUBSECTIONID   INTEGER,
      SUBSECTIONREVISION NUMBER(4),
      ITEMTYPE    NUMBER(2),
      ITEMID     INTEGER,
      ITEMREVISION    NUMBER(4),
      ITEMOWNER    NUMBER(4),
      ITEMINFO      INTEGER,
      SEQUENCE     NUMBER(13),
      SECTIONSEQUENCENUMBER  NUMBER(13),
      DISPLAYFORMATID   INTEGER,
      DISPLAYFORMATREVISION  NUMBER(4),
      ASSOCIATIONID   INTEGER,
      INTERNATIONAL   VARCHAR2(1),
      HEADER    NUMBER(1),
      OPTIONAL    NUMBER(1),
      EDITABLE    NUMBER(1),
      INCLUDED    NUMBER(1),
      EXTENDED    NUMBER(1),
      ISEXTENDABLE    NUMBER(1),
      ROWINDEX    NUMBER
      )

/
--------------------------------------------------------
--  DDL for Type SPSECTIONITEMTABLE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPSECTIONITEMTABLE_TYPE" AS TABLE OF SpSectionItemRecord_Type

/
--------------------------------------------------------
--  DDL for Type SPSECTIONRECORD_TYPE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."SPSECTIONRECORD_TYPE" AS OBJECT(
   PARTNO                        VARCHAR2( 18 ),
   REVISION                      NUMBER( 4 ),
   SECTIONID                     NUMBER,
   SECTIONREVISION               NUMBER( 4 ),
   SUBSECTIONID                  NUMBER,
   SUBSECTIONREVISION            NUMBER( 4 ),
   SEQUENCE                      NUMBER( 13 ),
   ISBOMSECTION                  NUMBER( 1 ),
   ISPROCESSSECTION              NUMBER( 1 ),
   ISEXTENDABLE                  NUMBER( 1 ),
   EDITABLE                      NUMBER( 1 ),
   VISIBLE                       NUMBER( 1 ),
   --ISQF125 Locked: 8 - > 20
   LOCKED                         VARCHAR2(20),
   INCLUDED                      NUMBER( 1 ),
   SECTIONNAME                   VARCHAR2( 60 ),
   SUBSECTIONNAME                VARCHAR2( 60 ),
   ROWINDEX                      NUMBER( 13 ),
   PARENTROWINDEX                NUMBER( 13 )
)

/
--------------------------------------------------------
--  DDL for Type STACK_OBJ
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."STACK_OBJ" wrapped
0
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
3
d
9200000
1
4
0
9
2 :e:
1TYPE:
1STACK_OBJ:
1OBJECT:
1ITEM:
1NUMBER:
1LEVEL_ID:
1DESCRIPTION:
1VARCHAR2:
1255:
0

0
0
1e
2
0 a0 9d a0 60 a3 a0 1c
b0 81 a3 a0 1c b0 81 a3
a0 51 a5 1c b0 81 77 a0
102 a0 c6 1d 17 b5
1e
2
0 3 73 b f 2f 23 27
22 36 4b 3f 43 1f 52 67
57 5b 5e 5f 3e 6e 7 7a
3b 7e 82 84 85 8e
1e
2
0 1 6 13 1 3 :2 10 :3 3
:2 13 :3 3 11 1a 19 11 :2 3 1
:2 0 :5 1
1e
4
0 :4 1 :5 2 :5 3
:7 4 1 :2 5 :5 1

90
4
:3 0 1 :3 0 2
0 4 0 3
:3 0 b :3 0 18
1 16 :9 0 5
3b 0 3 5
:3 0 6 :7 0 4
:6 0 8 7 0
4 0 17 :2 0
9 5 :3 0 b
:7 0 6 :6 0 d
c 0 4 0
8 :3 0 9 :2 0
7 10 12 :6 0
7 :6 0 14 13
0 4 0 2
4 2 1 :3 0
2 :3 0 2 :2 0
2 19 16 0
1b 1a 1d :8 0

f
4
:3 0 1 5 1
a 1 11 1
f 3 9 e
15
1
4
0
1c
1
1
14
1
4
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0
a 1 0
5 1 0
f 1 0
2 0 1
0

/
--------------------------------------------------------
--  DDL for Type STACK_TABLE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."STACK_TABLE" IS TABLE OF stack_obj

/
--------------------------------------------------------
--  DDL for Type TAB_MESSAGE2
--------------------------------------------------------

  CREATE OR REPLACE TYPE "INTERSPC"."TAB_MESSAGE2" is table of varchar2(255);

/
