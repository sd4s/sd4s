--***************************************************
--REFERENTIAL-DATA TBV PCR-OVERVIEW -MATERIALIZED-VIEWS
--
--ORIGINAL TABLES IN POSTGRES-DB SCHEMA = UTIL_INTERSPEC
--NOW MIGRATED THEM TO AURORA-DB SCHEMA = SC_LIMS_DAL
--***************************************************
--1.sc_lims_dal.pcr_bom_field 
--2.sc_lims_dal.pcr_bom_layout_type
--3.sc_lims_dal.pcr_bom_scenario 
--4.sc_lims_dal.pcr_function_conversion 
--5.sc_lims_dal.pcr_internal_status 
--6.sc_lims_dal.pcr_property_field 
--7.sc_lims_dal.pcr_section_type 



--***************************************************
--1.sc_lims_dal.bom_field 
-- Drop table
-- DROP TABLE sc_lims_dal.pcr_bom_field;

CREATE TABLE sc_lims_dal.pcr_bom_field (
	field_id int4 NOT NULL,
	"name" varchar(20) NOT NULL,
	"type" varchar(20) NOT NULL,
	CONSTRAINT pcr_bom_field_pkey PRIMARY KEY (field_id)
);
CREATE INDEX pcr_bom_field_name_idx ON sc_lims_dal.pcr_bom_field USING btree (name);
CREATE INDEX pcr_bom_field_type_idx ON sc_lims_dal.pcr_bom_field USING btree (type);


--***************************************************
--2.sc_lims_dal.bom_layout_type 

-- Drop table
-- DROP TABLE sc_lims_dal.pcr_bom_layout_type;

CREATE TABLE sc_lims_dal.pcr_bom_layout_type (
	"type" int4 NOT NULL,
	table_name varchar(40) NOT NULL,
	CONSTRAINT pcr_bom_layout_type_pkey PRIMARY KEY (type)
);


--***************************************************
--3.sc_lims_dal.bom_scenario 

-- Drop table
-- DROP TABLE sc_lims_dal.pcr_bom_scenario;

CREATE TABLE sc_lims_dal.pcr_bom_scenario (
	scenario varchar(10) NOT NULL,
	description text NULL,
	CONSTRAINT pcr_bom_scenario_pkey PRIMARY KEY (scenario)
);


--***************************************************
--4.sc_lims_dal.function_conversion 

-- Drop table
-- DROP TABLE sc_lims_dal.function_conversion;

CREATE TABLE sc_lims_dal.pcr_function_conversion (
	"function" text NOT NULL,
	bom_function text NOT NULL,
	CONSTRAINT pcr_function_conversion_pkey PRIMARY KEY (function)
);


--***************************************************
--5.sc_lims_dal.internal_status 

-- Drop table
-- DROP TABLE sc_lims_dal.pcr_internal_status;

CREATE TABLE sc_lims_dal.pcr_internal_status (
	status int4 NOT NULL,
	code varchar(20) NOT NULL,
	CONSTRAINT pcr_internal_status_pkey PRIMARY KEY (status)
);


--***************************************************
--6.sc_lims_dal.property_field 

-- Drop table
-- DROP TABLE sc_lims_dal.pcr_property_field;

CREATE TABLE sc_lims_dal.pcr_property_field (
	field_id int4 NOT NULL,
	"name" varchar(20) NOT NULL,
	"type" varchar(20) NOT NULL,
	CONSTRAINT pcr_property_field_pkey PRIMARY KEY (field_id)
);

CREATE INDEX pcr_property_field_id_type_idx ON sc_lims_dal.pcr_property_field USING btree (field_id, type, name);
CREATE INDEX pcr_property_field_name_idx ON sc_lims_dal.pcr_property_field USING btree (name);
CREATE INDEX pcr_property_field_type_idx ON sc_lims_dal.pcr_property_field USING btree (type);



--***************************************************
--7.sc_lims_dal.section_type 

-- Drop table
-- DROP TABLE sc_lims_dal.pcr_section_type;

CREATE TABLE sc_lims_dal.pcr_section_type (
	"type" int4 NOT NULL,
	table_name varchar(40) NOT NULL,
	ref_id varchar(40) NULL,
	ref_ver int4 NULL,
	CONSTRAINT pcr_section_type_pkey PRIMARY KEY (type)
);



--einde script



