--overicht AWS-replicatie-tabellen

--UNILAB

SELECT tab.TABLE_NAME, ind.index_name
FROM ALL_TABLES tab
LEFT OUTER JOIN ALL_INDEXES ind ON tab.table_name = ind.table_name
WHERE tab.table_name in 
('UTEQ'
,'UTRQ'
,'UTRQAU'
,'UTRQGK'
,'UTRQGKISTEST'
,'UTRQII'
,'UTSC'
,'UTSCAU'
,'UTSCGK'
,'UTSCGKISTEST'
,'UTSCII'
,'UTSCME'
,'UTSCMECELL'
,'UTSCMEGK'
,'UTSCMEGKME_IS_RELEVANT'
,'UTSCPA'
,'UTSCPAAU'
,'UTSS'
)
AND ind.uniqueness = 'UNIQUE'
order by tab.table_name

/*
UTEQ					UKEQ
UTRQ					UKRQ
UTRQAU					UKRQAU
UTRQGK					UKRQGK
UTRQGKISTEST			UKRQGKISTEST
UTRQII					UKRQII
UTSC					UKSC
UTSCAU					UKSCAU
UTSCGK					UKSCGK
UTSCGKISTEST			UKSCGKISTEST
UTSCII					UKSCII
UTSCME					UKSCME
UTSCMECELL				UKSCMECELL
UTSCMEGK				UKSCMEGK
UTSCMEGKME_IS_RELEVANT	UKSCMEGKME_IS_RELEVANT
UTSCPA					UKSCPA
UTSCPAAU				UKSCPAAU
UTSS					UKSS
UTSS					UISSNAME
*/


SELECT 'alter table '||tab.TABLE_NAME||' add supplemental log data (all) columns;'
FROM ALL_TABLES tab
WHERE tab.table_name in 
('UTEQ'
,'UTRQ'
,'UTRQAU'
,'UTRQGK'
,'UTRQGKISTEST'
,'UTRQII'
,'UTSC'
,'UTSCAU'
,'UTSCGK'
,'UTSCGKISTEST'
,'UTSCII'
,'UTSCME'
,'UTSCMECELL'
,'UTSCMEGK'
,'UTSCMEGKME_IS_RELEVANT'
,'UTSCPA'
,'UTSCPAAU'
,'UTSS'
)
order by tab.table_name;

/*
alter table UTEQ add supplemental log data (all) columns;
alter table UTRQ add supplemental log data (all) columns;
alter table UTRQAU add supplemental log data (all) columns;
alter table UTRQGK add supplemental log data (all) columns;
alter table UTRQGKISTEST add supplemental log data (all) columns;
alter table UTRQII add supplemental log data (all) columns;
alter table UTSC add supplemental log data (all) columns;
alter table UTSCAU add supplemental log data (all) columns;
alter table UTSCGK add supplemental log data (all) columns;
alter table UTSCGKISTEST add supplemental log data (all) columns;
alter table UTSCII add supplemental log data (all) columns;
alter table UTSCME add supplemental log data (all) columns;
alter table UTSCMECELL add supplemental log data (all) columns;
alter table UTSCMEGK add supplemental log data (all) columns;
alter table UTSCMEGKME_IS_RELEVANT add supplemental log data (all) columns;
alter table UTSCPA add supplemental log data (all) columns;
alter table UTSCPAAU add supplemental log data (all) columns;
alter table UTSS add supplemental log data (all) columns;
*/

/*
--REMOVE SUPPLEMENTAL-LOGGING ON TABLE:
alter table UTEQ drop supplemental log data (all) columns;
alter table UTRQ drop supplemental log data (all) columns;
*/




--INTERSPEC-REPORTING:

SELECT tab.TABLE_NAME, ind.index_name
FROM ALL_TABLES tab
FULL OUTER JOIN ALL_INDEXES ind ON tab.table_name = ind.table_name
WHERE tab.table_name in 
('ATTACHED_SPECIFICATION'
,'BOM_HEADER'
,'BOM_ITEM'
,'BOM_LAYOUT'
,'OBJECT'
,'PART_BOM_LAYOUT'
,'PROPERTY_LAYOUT_HEADER'
,'REFERENCE_TEXT'
,'SECTION_PROPERTY_VALUE'
,'SPECIFICATION_FREETEXT'
,'SPECIFICATION_KEYWORD'
,'SPECIFICATION_PROP'
,'SPECIFICATION_SECTION'
,'SPECIFICATION_STATUS'
,'SPECIFICATION_STATUS_HISTORY'
)
AND ind.uniqueness = 'UNIQUE'
order by tab.table_name
;
alter system switch logfile; 

/*
ATTACHED_SPECIFICATION	XPK_ATTACHED_SPECIFICATION
BOM_HEADER				XPKBOM_HEADER
BOM_ITEM				XPK_BOM_ITEM
REFERENCE_TEXT			XPKREFERENCE_TEXT
SPECIFICATION_PROP		XPK_SPECIFICATION_PROP
SPECIFICATION_PROP		AI_SPECTRAC2
SPECIFICATION_SECTION	PK_SPECIFICATION_SECTION

--conclusie: INTERSPEC-TABELNAME IN AWS wijken af van de tabellen in INTERSPEC-ORACLE.

AWS-TABLE                      ORACLE-TABLE-NAME (??)
---------------------          --------------------------
BOM_LAYOUT                     ITBOMLY
OBJECT                         ITOID of ITOIH
PART_BOM_LAYOUT                -
PROPERTY_LAYOUT_HEADER         HEADER
SECTION_PROPERTY_VALUE         -
SPECIFICATION_FREETEXT         SPECIFICATION_TEXT
SPECIFICATION_KEYWORD          SPECIFICATION_KW
SPECIFICATION_STATUS           STATUS kolom in SPECIFICATION_HEADER?
SPECIFICATION_STATUS_HISTORY   STATUS_HISTORY


*/

SELECT 'alter table '||tab.TABLE_NAME||' add supplemental log data (all) columns;'
FROM ALL_TABLES tab
WHERE tab.table_name in 
('ATTACHED_SPECIFICATION'
,'BOM_HEADER'
,'BOM_ITEM'
,'BOM_LAYOUT'
,'OBJECT'
,'PART_BOM_LAYOUT'
,'PROPERTY_LAYOUT_HEADER'
,'REFERENCE_TEXT'
,'SECTION_PROPERTY_VALUE'
,'SPECIFICATION_FREETEXT'
,'SPECIFICATION_KEYWORD'
,'SPECIFICATION_PROP'
,'SPECIFICATION_SECTION'
,'SPECIFICATION_STATUS'
,'SPECIFICATION_STATUS_HISTORY'
)
order by tab.table_name
;
alter system switch logfile; 

/*
alter table ATTACHED_SPECIFICATION add supplemental log data (all) columns;
alter table BOM_HEADER add supplemental log data (all) columns;
alter table BOM_ITEM add supplemental log data (all) columns;
alter table REFERENCE_TEXT add supplemental log data (all) columns;
alter table SPECIFICATION_PROP add supplemental log data (all) columns;
alter table SPECIFICATION_SECTION add supplemental log data (all) columns;
*/


