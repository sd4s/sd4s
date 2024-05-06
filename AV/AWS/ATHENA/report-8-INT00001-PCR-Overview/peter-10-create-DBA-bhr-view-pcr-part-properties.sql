--CREATE DBA-BHR-VIEWS FOR MAINTENANCE TBV PCR-OVERVIEW
--*********************************************************************
--1. dba_v_tot_specification_prop
--2. dba_v_tot_specification_prop_field   (property + all attributes incl field-name)
--3. dba_v_specification_prop_aggr_json   (build JSON based on all properties)

--*********************************************************************
DROP VIEW sc_lims_dal.dba_v_specification_prop_aggr_json;
DROP VIEW sc_lims_dal.dba_v_tot_specification_prop_field;
DROP VIEW sc_lims_dal.dba_v_tot_specification_prop;
--
CREATE OR REPLACE VIEW sc_lims_dal.dba_v_tot_specification_prop
AS SELECT sp.part_no
,    sp.revision
,    skw.kw_value      as bom_function
,    sp.section_id
,    sec.description   as section_descr
,    sp.sub_section_id
,    ssec.description  as sub_section_descr
,    sp.property_group
,    pg.description    as property_group_descr
,    sp.property
,    p.description     as property_descr
,    sp.attribute
,    sp.section_rev
,    sp.sub_section_rev
,    sp.property_group_rev
,    sp.property_rev
,    sp.attribute_rev
,    sp.uom_id
,    sp.uom_rev
,    sp.test_method
,    sp.test_method_rev
,    sp.sequence_no
,    sp.num_1
,    sp.num_2
,    sp.num_3
,    sp.num_4
,    sp.num_5
,    sp.num_6
,    sp.num_7
,    sp.num_8
,    sp.num_9
,    sp.num_10
,    sp.char_1
,    sp.char_2
,    sp.char_3
,    sp.char_4
,    sp.char_5
,    sp.char_6
,    sp.boolean_1
,    sp.boolean_2
,    sp.boolean_3
,    sp.boolean_4
,    sp.date_1
,    sp.date_2
,    sp.characteristic
,    sp.characteristic_rev
,    sp.association
,    sp.association_rev
,    sp.intl
,    sp.info
,    sp.uom_alt_id
,    sp.uom_alt_rev
,    sp.tm_det_1
,    sp.tm_det_2
,    sp.tm_det_3
,    sp.tm_det_4
,    sp.tm_set_no
,    sp.ch_2
,    sp.ch_rev_2
,    sp.ch_3
,    sp.ch_rev_3
,    sp.as_2
,    sp.as_rev_2
,    sp.as_3
,    sp.as_rev_3
,    p.description AS property_1
,    u.description AS uom
,    tm.description AS test_method_1
,    CASE c.characteristic_id
       WHEN sp.characteristic            THEN c.description
       ELSE NULL::character varying
     END AS characteristic_1
,    CASE c.characteristic_id
       WHEN sp.ch_2                      THEN c.description
       ELSE NULL::character varying
     END AS characteristic_2
,    CASE c.characteristic_id
       WHEN sp.ch_3                      THEN c.description
       ELSE NULL::character varying
     END AS characteristic_3
FROM      sc_interspec_ens.specification_prop sp
LEFT JOIN sc_interspec_ens.specification_kw  skw ON (skw.part_no = sp.part_no and skw.kw_id in (select kw.kw_id from sc_interspec_ens.itkw kw where kw.kw_id = skw.kw_id and kw.description = 'Function') )
--LEFT JOIN sc_interspec_ens.itkw               kw on (kw.kw_id= skw.kw_id and kw.description = 'Function' )
LEFT JOIN sc_interspec_ens.section           sec on (sec.section_id      = sp.section_id)
LEFT JOIN sc_interspec_ens.sub_section      ssec on (ssec.sub_section_id = sp.sub_section_id)
LEFT JOIN sc_interspec_ens.property_group     pg ON (pg.property_group   = sp.property_group)
LEFT JOIN sc_interspec_ens.property            p USING (property)
LEFT JOIN sc_interspec_ens.uom                 u USING (uom_id)
LEFT JOIN sc_interspec_ens.test_method        tm USING (test_method)
LEFT JOIN sc_interspec_ens.characteristic      c ON c.characteristic_id = ANY (ARRAY[sp.characteristic, sp.ch_2, sp.ch_3])
;
	 


select * from sc_lims_dal.dba_v_tot_specification_prop  d where d.part_no = 'GV_2156517QPRNV' and d.revision = 16
;
select * from sc_lims_dal.dba_v_tot_specification_prop  d where d.part_no = 'GF_2156517QPRNV' and d.revision = 16
;

/*
part_no	revision	bom_function	section_id	section_descr	sub_section_id	sub_section_descr	property_group	property_group_descr	property	property_descr	attribute	section_rev	sub_section_rev	property_group_rev	property_rev	attribute_rev	uom_id	uom_rev	test_method	test_method_rev	sequence_no	num_1	num_2	num_3	num_4	num_5	num_6	num_7	num_8	num_9	num_10	char_1	char_2	char_3	char_4	char_5	char_6	boolean_1	boolean_2	boolean_3	boolean_4	date_1	date_2	characteristic	characteristic_rev	association	association_rev	intl	info	uom_alt_id	uom_alt_rev	tm_det_1	tm_det_2	tm_det_3	tm_det_4	tm_set_no	ch_2	ch_rev_2	ch_3	ch_rev_3	as_2	as_rev_2	as_3	as_rev_3	property_1	uom	test_method_1	characteristic_1	characteristic_2	characteristic_3
GV_2156517QPRNV	16	Tyre vulcanized	700,755	SAP information	0	(none)	0	default property group	703,262	Weight	0	200	100	1	100	100	[NULL]	0	[NULL]	0	100	1	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	0	[NULL]	0	1	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Weight	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	700,755	SAP information	0	(none)	0	default property group	705,428	Article group PG	0	200	100	1	100	100	[NULL]	0	[NULL]	0	100	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	901,397	300	900,134	100	1	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Article group PG	[NULL]	[NULL]	Q2: VULK   QUATRAC 5 (H)          	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	700,755	SAP information	0	(none)	0	default property group	705,429	Packaging PG	0	200	100	1	100	100	[NULL]	0	[NULL]	0	100	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	900,419	100	900,137	101	1	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Packaging PG	[NULL]	[NULL]	EMPBD	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	700,755	SAP information	0	(none)	0	default property group	709,030	Physical in product	0	200	100	1	200	100	[NULL]	0	[NULL]	0	100	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	900,484	100	900,141	100	1	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Physical in product	[NULL]	[NULL]	Yes	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	700,915	Config	0	(none)	0	default property group	709,128	Base UoM	0	100	100	1	100	100	[NULL]	0	[NULL]	0	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	pcs	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	0	[NULL]	0	1	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Base UoM	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	0	default property group	710,528	volgnummer	0	100	300	1	100	100	[NULL]	0	[NULL]	0	100	20	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	0	900,215	100	1	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	volgnummer	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	700,755	SAP information	0	(none)	0	default property group	710,531	Article type	0	200	100	1	200	100	[NULL]	0	[NULL]	0	100	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	900,978	100	900,211	100	1	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Article type	[NULL]	[NULL]	V: Vulkanisatie output Alternatief	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	700,542	General	0	default property group	712,488	Curing critical point	0	100	100	1	100	100	[NULL]	0	[NULL]	0	100	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	901,450	100	900,252	100	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Curing critical point	[NULL]	[NULL]	Tread section - Tread	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	705,215	Segment	0	100	300	100	400	100	[NULL]	0	[NULL]	0	100	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	4349	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	900,253	100	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Segment	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	707,391	Bladder	0	100	300	100	100	100	[NULL]	0	[NULL]	0	500	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	RP15/5	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	900,261	100	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bladder	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	707,392	Container	0	100	300	100	200	100	[NULL]	0	[NULL]	0	300	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	ARC5	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	900,258	100	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Container	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	707,408	Bajonet adaptor ring	0	100	300	100	300	100	[NULL]	0	[NULL]	0	400	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	0	900,259	100	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bajonet adaptor ring	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	713,549	Sideplate	0	100	300	100	200	100	[NULL]	0	[NULL]	0	200	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	4349	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Sideplate	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	713,550	Bladder clamping #4	0	100	300	100	200	100	[NULL]	0	[NULL]	0	1,100	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	HBC-15 Item 4	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bladder clamping #4	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	713,551	Bladder clamping #2	0	100	300	100	100	100	[NULL]	0	[NULL]	0	900	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	HBC-15 Item 2	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bladder clamping #2	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	713,552	Bladder clamping #3	0	100	300	100	100	100	[NULL]	0	[NULL]	0	1,000	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	HBC-15 Item 3	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bladder clamping #3	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	713,553	Bead ring bottom	0	100	300	100	100	100	[NULL]	0	[NULL]	0	700	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	H74E	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bead ring bottom	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	713,554	Bead ring top	0	100	300	100	100	100	[NULL]	0	[NULL]	0	800	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	H74E	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bead ring top	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	702,451	PCUR52: PCR Curing 52 COLL machine group	701,570	Tooling	716,667	Bladder code	0	100	300	100	100	100	[NULL]	0	[NULL]	0	600	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	BLD0081	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bladder code	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	700,542	General	701,836	Curing settings (nitrogen)	705,176	Curing time (total)	0	100	100	100	401	100	700,625	100	0	0	200	11.5	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Curing time (total)	min	[NULL]	[NULL]	[NULL]	[NULL]
GV_2156517QPRNV	16	Tyre vulcanized	701,058	Processing Gyongyoshalasz	700,542	General	701,836	Curing settings (nitrogen)	706,048	Bladder temperature (steam)	0	100	100	100	101	100	700,577	100	0	0	700	198	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	[NULL]	N	N	N	N	[NULL]	[NULL]	[NULL]	0	[NULL]	0	2	[NULL]	[NULL]	0	N	N	N	N	[NULL]	[NULL]	0	[NULL]	0	[NULL]	0	[NULL]	0	Bladder temperature (steam)	°C	[NULL]	[NULL]	[NULL]	[NULL]
...
*/

--***********************************************************
--dba_v_tot_specification_prop_field
--***********************************************************
DROP VIEW VIEW sc_lims_dal.dba_v_tot_specification_prop_field;
--
CREATE OR REPLACE VIEW sc_lims_dal.dba_v_tot_specification_prop_field
AS SELECT sp.part_no
,    sp.revision
,    sp.bom_function
,    sp.section_id
,    sp.section_descr
,    sp.sub_section_id
,    sp.sub_section_descr
,    sp.property_group
,    sp.property_group_descr
,    sp.property
,    sp.property_descr
,    sp.sequence_no
,    sp.attribute
,    sp.attribute_rev
,    sp.uom_id
,    sp.uom_rev
,    sp.uom_alt_id
,    sp.uom_alt_rev
,    sp.test_method
,    sp.test_method_rev
,    sp.intl
,    sp.info
,    ss.display_format
,    ss.display_format_rev
,    ss.section_sequence_no
,    h.description          as header_descr
,    jsonb_object_agg(h.description
           ,CASE upf.name
            WHEN 'num_1'::text THEN to_jsonb(sp.num_1)
            WHEN 'num_2'::text THEN to_jsonb(sp.num_2)
            WHEN 'num_3'::text THEN to_jsonb(sp.num_3)
            WHEN 'num_4'::text THEN to_jsonb(sp.num_4)
            WHEN 'num_5'::text THEN to_jsonb(sp.num_5)
            WHEN 'num_6'::text THEN to_jsonb(sp.num_6)
            WHEN 'num_7'::text THEN to_jsonb(sp.num_7)
            WHEN 'num_8'::text THEN to_jsonb(sp.num_8)
            WHEN 'num_9'::text THEN to_jsonb(sp.num_9)
            WHEN 'num_10'::text THEN to_jsonb(sp.num_10)
            WHEN 'char_1'::text THEN to_jsonb(sp.char_1)
            WHEN 'char_2'::text THEN to_jsonb(sp.char_2)
            WHEN 'char_3'::text THEN to_jsonb(sp.char_3)
            WHEN 'char_4'::text THEN to_jsonb(sp.char_4)
            WHEN 'char_5'::text THEN to_jsonb(sp.char_5)
            WHEN 'char_6'::text THEN to_jsonb(sp.char_6)
            WHEN 'uom'::text    THEN to_jsonb(sp.uom)
            WHEN 'test_method_1'::text  THEN to_jsonb(sp.test_method_1)
            WHEN 'property_1'::text     THEN to_jsonb(sp.property_1)
            WHEN 'info'::text           THEN to_jsonb(sp.info)
            WHEN 'attribute'::text      THEN to_jsonb(sp.attribute)
            WHEN 'boolean_1'::text      THEN to_jsonb(sp.boolean_1)
            WHEN 'boolean_2'::text      THEN to_jsonb(sp.boolean_2)
            WHEN 'boolean_3'::text      THEN to_jsonb(sp.boolean_3)
            WHEN 'boolean_4'::text      THEN to_jsonb(sp.boolean_4)
            WHEN 'tm_det_1'::text       THEN to_jsonb(sp.tm_det_1)
            WHEN 'tm_det_2'::text       THEN to_jsonb(sp.tm_det_2)
            WHEN 'tm_det_3'::text       THEN to_jsonb(sp.tm_det_3)
            WHEN 'tm_det_4'::text       THEN to_jsonb(sp.tm_det_4)
            WHEN 'date_1'::text         THEN to_jsonb(sp.date_1)
            WHEN 'date_2'::text         THEN to_jsonb(sp.date_2)
            WHEN 'characteristic_1'::text THEN to_jsonb(sp.characteristic_1)
            WHEN 'characteristic_2'::text THEN to_jsonb(sp.characteristic_2)
            WHEN 'characteristic_3'::text THEN to_jsonb(sp.characteristic_3)
            ELSE NULL::jsonb
           END) AS cells
,    jsonb_object_agg(h.description, pl.start_pos)     AS cell_seq
,    jsonb_object_agg(h.description, upf.name)         AS cell_field
FROM sc_lims_dal.dba_v_tot_specification_prop       sp
JOIN sc_interspec_ens.specification_section         ss USING (part_no, revision, section_id, sub_section_id)
JOIN sc_interspec_ens.property_layout               pl(layout_id, header_id, field_id, included, start_pos, length, alignment, format_id, header, color, bold, underline, intl, revision_1, header_rev, def, url, attached_spec, edit_allowed) ON pl.layout_id = ss.display_format AND pl.revision_1 = ss.display_format_rev
JOIN sc_lims_dal.pcr_property_field                upf USING (field_id)
JOIN sc_interspec_ens.header                         h USING (header_id)
WHERE (  (  ss.type::numeric = 1::numeric 
         AND ss.ref_id = sp.property_group )
      OR (  ss.type::numeric = 4::numeric 
         AND ss.ref_id = sp.property )
	  )
GROUP BY sp.part_no
,    sp.revision
,    sp.bom_function
,    sp.section_id
,    sp.section_descr
,    sp.sub_section_id
,    sp.sub_section_descr
,    sp.property_group
,    sp.property_group_descr
,    sp.property
,    sp.property_descr
,    sp.sequence_no
,    sp.attribute
,    sp.attribute_rev
,    sp.uom_id
,    sp.uom_rev
,    sp.uom_alt_id
,    sp.uom_alt_rev
,    sp.test_method
,    sp.test_method_rev
,    sp.intl
,    sp.info
,    ss.display_format
,    ss.display_format_rev
,    ss.section_sequence_no
,    h.description          
;

select * from sc_lims_dal.dba_v_tot_specification_prop_field  d where d.part_no = 'GF_2156517QPRNV' and d.revision = 16
;


select * from sc_lims_dal.dba_v_tot_specification_prop_field d where d.part_no = 'GV_2156517QPRNV' and d.revision = 16
;

/*
part_no	revision	bom_function	section_id	section_descr	sub_section_id	sub_section_descr	property_group	property_group_descr	property	property_descr	sequence_no	attribute	attribute_rev	uom_id	uom_rev	uom_alt_id	uom_alt_rev	test_method	test_method_rev	intl	info	display_format	display_format_rev	section_sequence_no	header_descr	cells	cell_seq	cell_field
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,368	CCC A068723 engraved	200	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Approval code	{"Approval code": null}	{"Approval code": 5}	{"Approval code": "char_3"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,368	CCC A068723 engraved	200	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Current certificate validity	{"Current certificate validity": null}	{"Current certificate validity": 4}	{"Current certificate validity": "char_2"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,368	CCC A068723 engraved	200	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Description	{"Description": null}	{"Description": 2}	{"Description": "characteristic_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,368	CCC A068723 engraved	200	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Property	{"Property": "CCC A068723 engraved"}	{"Property": 1}	{"Property": "property_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,368	CCC A068723 engraved	200	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Sidewall plates engraved since	{"Sidewall plates engraved since": null}	{"Sidewall plates engraved since": 3}	{"Sidewall plates engraved since": "char_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,369	ISI  CM/L-4034946 engraved	300	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Approval code	{"Approval code": null}	{"Approval code": 5}	{"Approval code": "char_3"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,369	ISI  CM/L-4034946 engraved	300	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Current certificate validity	{"Current certificate validity": null}	{"Current certificate validity": 4}	{"Current certificate validity": "char_2"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,369	ISI  CM/L-4034946 engraved	300	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Description	{"Description": null}	{"Description": 2}	{"Description": "characteristic_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,369	ISI  CM/L-4034946 engraved	300	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Property	{"Property": "ISI CM/L-4034946 engraved"}	{"Property": 1}	{"Property": "property_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,369	ISI  CM/L-4034946 engraved	300	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Sidewall plates engraved since	{"Sidewall plates engraved since": null}	{"Sidewall plates engraved since": 3}	{"Sidewall plates engraved since": "char_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,370	Inmetro 200 engraved	400	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Approval code	{"Approval code": null}	{"Approval code": 5}	{"Approval code": "char_3"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,370	Inmetro 200 engraved	400	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Current certificate validity	{"Current certificate validity": null}	{"Current certificate validity": 4}	{"Current certificate validity": "char_2"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,370	Inmetro 200 engraved	400	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Description	{"Description": null}	{"Description": 2}	{"Description": "characteristic_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,370	Inmetro 200 engraved	400	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Property	{"Property": "Inmetro 200 engraved"}	{"Property": 1}	{"Property": "property_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,370	Inmetro 200 engraved	400	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Sidewall plates engraved since	{"Sidewall plates engraved since": null}	{"Sidewall plates engraved since": 3}	{"Sidewall plates engraved since": "char_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,371	GSO certified	500	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Approval code	{"Approval code": null}	{"Approval code": 5}	{"Approval code": "char_3"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,371	GSO certified	500	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Current certificate validity	{"Current certificate validity": null}	{"Current certificate validity": 4}	{"Current certificate validity": "char_2"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,371	GSO certified	500	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Description	{"Description": null}	{"Description": 2}	{"Description": "characteristic_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,371	GSO certified	500	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Property	{"Property": "GSO certified"}	{"Property": 1}	{"Property": "property_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,371	GSO certified	500	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Sidewall plates engraved since	{"Sidewall plates engraved since": null}	{"Sidewall plates engraved since": 3}	{"Sidewall plates engraved since": "char_1"}
GF_2156517QPRNV	16	Tyre	700,579	General information	0	(none)	700,696	Certification	711,388	CCC mandatory	100	0	100	[NULL]	0	[NULL]	0	[NULL]	0	2	[NULL]	703,508	2	1,000	Approval code	{"Approval code": null}	{"Approval code": 5}	{"Approval code": "char_3"}
...

*/

--**********************************************************
--dba_v_specification_prop_aggr_json
--
--let op: is vervangen van een MV !!!. Performance is SLECHT !!!!!!!!
--**********************************************************
drop view sc_lims_dal.dba_v_specification_prop_aggr_json;
--
CREATE or replace VIEW sc_lims_dal.dba_v_specification_prop_aggr_json
AS SELECT subsec.part_no
,    subsec.revision
,    subsec.bom_function
,    sh.status
,    sh.frame_id
,    sh.class3_id
,    sh.issued_date
,    sh.obsolescence_date
--,    sk.functionkw
,    jsonb_object_agg(subsec.section_descr, subsec.properties) AS properties
--,    sk.keywords
FROM (     SELECT propgrp.part_no
           ,      propgrp.revision
		   ,      propgrp.bom_function
	       ,      propgrp.section_id
	       ,      propgrp.section_descr
           ,      jsonb_object_agg(propgrp.sub_section_descr, propgrp.properties) AS properties
           FROM (  SELECT prop.part_no
		           ,      prop.revision
				   ,      prop.bom_function
				   ,      prop.section_id
				   ,      prop.section_descr
				   ,      prop.sub_section_id
				   ,      prop.sub_section_descr
				   ,      jsonb_object_agg(prop.property_group_descr, prop.properties) AS properties
                   FROM ( SELECT sp.part_no
				          ,      sp.revision
						  ,      sp.bom_function
						  ,      sp.section_id
						  ,      sp.section_descr
						  ,      sp.sub_section_id
						  ,      sp.sub_section_descr
						  ,      sp.property_group
						  ,      sp.property_group_descr
						  ,      jsonb_object_agg(sp.property_descr, sp.cells - 'Property'::text) AS properties
                          FROM sc_lims_dal.DBA_V_TOT_SPECIFICATION_PROP_FIELD sp
                          GROUP BY sp.part_no, sp.revision, sp.bom_function,sp.section_id, sp.section_descr, sp.sub_section_id, sp.sub_section_descr, sp.property_group, sp.property_group_descr
						 ) prop
                  GROUP BY prop.part_no, prop.revision, prop.bom_function, prop.section_id, prop.section_descr, prop.sub_section_id, prop.sub_section_descr 
				) propgrp
          GROUP BY propgrp.part_no, propgrp.revision, propgrp.bom_function, propgrp.section_id, propgrp.section_descr
     ) subsec
JOIN sc_interspec_ens.specification_header     sh USING (part_no, revision)
--LEFT JOIN sc_lims_dal.mv_specification_keyword sk USING (part_no)
GROUP BY subsec.part_no
, subsec.revision
, subsec.bom_function
, sh.status
, sh.frame_id
, sh.class3_id
, sh.issued_date
, sh.obsolescence_date
--, sk.functionkw
--, sk.keywords
;


--sc_lims_dal.dba_v_specification_prop_aggr_json 
select * from sc_lims_dal.dba_v_specification_prop_aggr_json d  where d.part_no = 'GV_2156517QPRNV' and d.revision = 16
;

part_no	revision	bom_function	status	frame_id	class3_id	issued_date	obsolescence_date								properties
GV_2156517QPRNV	16	Tyre vulcanized	128	A_PCR_VULC v1	700,674	2022-07-08 10:52:17.000	[NULL]									{"Config": {"(none)": {"default property group": {"Base UoM": {"Value": "pcs"}}}}, "Controlplan": {"Gyongyoshalasz": {"Controlplan vulcanized tyres": {"Visual inspection": {"Sampling interval": 1}}}}, "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"Value": 1095}, "Aging (minimal)": {"Value": 0}}, "default property group": {"Weight": {"Value": 1}, "Article type": {"Value": "V: Vulkanisatie output Alternatief"}, "Packaging PG": {}, "Article group PG": {"Value": "Q2: VULK QUATRAC 5 (H) "}, "Physical in product": {"Value": "Yes"}}}}, "Processing Gyongyoshalasz": {"General": {"PCR cure cycle": {"Step 1": {"Vacuum": "0"}, "Step 2": {"Vacuum": "0"}, "Step 3": {"Vacuum": "0"}, "Step 4": {"Vacuum": null}, "Step 5": {"Vacuum": "0"}, "Step 6": {"Vacuum": null}, "Step 7": {"Vacuum": "0"}, "Step 8": {"Vacuum": "0"}, "Step 9": {"Vacuum": "1"}}, "default property group": {"Curing critical point": {"Value": "Tread section - Tread"}}, "Curing settings (nitrogen)": {"Cycle time": {"UoM": "min"}, "Drain duration": {"UoM": "min"}, "Mould vacuum time": {"UoM": "min"}, "Platen temperature": {"UoM": "°C"}, "Curing time (total)": {"UoM": "min"}, "1st shaping pressure": {"UoM": "bar"}, "2nd shaping pressure": {"UoM": "bar"}, "3rd shaping pressure": {"UoM": "bar"}, "Gas leak detection time": {"UoM": "min"}, "Internal steam duration": {"UoM": "min"}, "Bladder pressure (steam)": {"UoM": "bar"}, "Internal Nitrogen duration": {"UoM": "min"}, "Bladder pressure (Nitrogen)": {"UoM": "bar"}, "Bladder temperature (steam)": {"UoM": "°C"}, "Gas leak detection duration": {"UoM": "min"}, "Bladder temperature (nitrogen)": {"UoM": "°C"}}}, "PCUR52: PCR Curing 52 COLL machine group": {"Tooling": {"Bladder": {"Value": "RP15/5"}, "Segment": {"Value": "4349"}, "Container": {"Value": "ARC5"}, "Sideplate": {"Value": "4349"}, "Bladder code": {"Value": "BLD0081"}, "Bead ring top": {"Value": "H74E"}, "Bead ring bottom": {"Value": "H74E"}, "Bladder clamping #2": {"Value": "HBC-15 Item 2"}, "Bladder clamping #3": {"Value": "HBC-15 Item 3"}, "Bladder clamping #4": {"Value": "HBC-15 Item 4"}, "Bajonet adaptor ring": {"Value": null}}, "Vulcanisation Recipe": {"Storage Location": {"Value": "205"}, "Recipe No. (nitrogen)": {"Value": "GV2156517QPRNV"}}, "default property group": {"volgnummer": {"Value": 20}}, "Curing press parameters": {"Pause time": {"UoM": "min"}, "Pause height": {"UoM": "mm"}, "Squeeze force": {"UoM": "kN"}, "Squeeze pressure": {"UoM": "bar"}, "Open shaping time": {"UoM": "min"}, "Press size / type": {"UoM": "Inch"}, "Open shaping height": {"UoM": "mm"}, "Loader shape position": {"UoM": "mm"}, "Open shaping pressure": {"UoM": "bar"}, "Bladder stacking height": {"UoM": "mm"}, "Bladder ring down height": {"UoM": "mm"}}}}}

part_no			revision	status	frame_id		class3_id	issued_date				obsolescence_date	functionkw			properties	keywords
GV_2156517QPRNV	16			128		A_PCR_VULC v1	700,674		2022-07-08 10:52:17.000	[NULL]				{"Tyre vulcanized"}	{"Config": {"(none)": {"default property group": {"Base UoM": {"Value": "pcs"}}}}, "Controlplan": {"Gyongyoshalasz": {"Controlplan vulcanized tyres": {"Visual inspection": {"Sampling interval": 1}}}},                                                                                                                                    "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"Value": 1095},              "Aging (minimal)": {"Value": 0}},              "default property group": {"Weight": {"Value": 1},              "Article type": {"Value": "V: Vulkanisatie output Alternatief"}, "Packaging PG": {},                                                    "Article group PG": {"Value": "Q2: VULK QUATRAC 5 (H) "}, "Physical in product": {"Value": "Yes"}}}}, "Processing Gyongyoshalasz": {"General": {"PCR cure cycle": {"Step 1": {"Vacuum": null},                                                                                                                                                                                                                               "Step 2": {"Vacuum": null},                                                                                                                                                                                                                                   "Step 3": {"Vacuum": null}, "Step 4": {"Vacuum": "0"}, "Step 5": {"Vacuum": "0"}, "Step 6": {"Vacuum": null}, "Step 7": {"Vacuum": "0"}, "Step 8": {"Vacuum": "0"}, "Step 9": {"Vacuum": null}}, "default property group": {"Curing critical point": {"Value": "Tread section - Tread"}}, "Curing settings (nitrogen)": {"Cycle time": {"UoM": "min"}, "Drain duration": {"UoM": "min"}, "Mould vacuum time": {"UoM": "min"}, "Platen temperature": {"UoM": "°C"}, "Curing time (total)": {"UoM": "min"}, "1st shaping pressure": {"UoM": "bar"}, "2nd shaping pressure": {"UoM": "bar"}, "3rd shaping pressure": {"UoM": "bar"}, "Gas leak detection time": {"UoM": "min"}, "Internal steam duration": {"UoM": "min"}, "Bladder pressure (steam)": {"UoM": "bar"}, "Internal Nitrogen duration": {"UoM": "min"}, "Bladder pressure (Nitrogen)": {"UoM": "bar"}, "Bladder temperature (steam)": {"UoM": "°C"}, "Gas leak detection duration": {"UoM": "min"}, "Bladder temperature (nitrogen)": {"UoM": "°C"}}}, "PCUR52: PCR Curing 52 COLL machine group": {"Tooling": {"Bladder": {"Value": "RP15/5"}, "Segment": {"Value": "4349"}, "Container": {"Value": "ARC5"}, "Sideplate": {"Value": "4349"}, "Bladder code": {"Value": "BLD0081"}, "Bead ring top": {"Value": "H74E"}, "Bead ring bottom": {"Value": "H74E"}, "Bladder clamping #2": {"Value": "HBC-15 Item 2"}, "Bladder clamping #3": {"Value": "HBC-15 Item 3"}, "Bladder clamping #4": {"Value": "HBC-15 Item 4"}, "Bajonet adaptor ring": {"Value": null}}, "Vulcanisation Recipe": {"Storage Location": {"Value": "205"},                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     "Recipe No. (nitrogen)": {"Value": "GV2156517QPRNV"}}, "default property group": {"volgnummer": {"Value": 20}}, "Curing press parameters": {"Pause time": {"UoM": "min"}, "Pause height": {"UoM": "mm"}, "Squeeze force": {"UoM": "kN"}, "Squeeze pressure": {"UoM": "bar"}, "Open shaping time": {"UoM": "min"}, "Press size / type": {"UoM": "Inch"}, "Open shaping height": {"UoM": "mm"}, "Loader shape position": {"UoM": "mm"}, "Open shaping pressure": {"UoM": "bar"}, "Bladder stacking height": {"UoM": "mm"}, "Bladder ring down height": {"UoM": "mm"}}}}}												{"Function": ["Tyre vulcanized"], "Specification type group": ["SFG (semi finished goods)"]}

was via MV:
part_no			revision	status	frame_id		class3_id	issued_date				obsolescence_date	functionkw			properties																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										keywords
GV_2156517QPRNV	16			128		A_PCR_VULC v1	700,674		2022-07-08 10:52:17.000	[NULL]				{"Tyre vulcanized"}	{"Config": {"(none)": {"default property group": {"Base UoM": {"Value": "pcs"}}}}, "Controlplan": {"Gyongyoshalasz": {"Controlplan vulcanized tyres": {"Visual inspection": {"Report": null, "Sample size": 1, "Interval type": "Pcs", "Reaction plan": null, "Responsibility": null, "Apollo test code": null, "Sampling interval": 1}}}}, "SAP information": {"(none)": {"Aging SAP": {"Aging (Maximal)": {"UoM": null, "Value": 1095}, "Aging (minimal)": {"UoM": null, "Value": 0}}, "default property group": {"Weight": {"UoM": null, "Value": 1}, "Article type": {"Value": "V: Vulkanisatie output Alternatief"}, "Packaging PG": {"Amount": null, "Info 1": null, "Packaging": "EMPBD"}, "Article group PG": {"Value": "Q2: VULK QUATRAC 5 (H) "}, "Physical in product": {"Value": "Yes"}}}}, "Processing Gyongyoshalasz": {"General": {"PCR cure cycle": {"Step 1": {"N2": null, "Steps": "14 bar steam Circulation", "Vacuum": null, "Steam On": "1", "Time (s)": 12, "Circ Drain": 1, "Cure Delay": 0, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 12},    "Step 2": {"N2": "0", "Steps": "14 bar steam with Mould vacuum", "Vacuum": "0", "Steam On": null, "Time (s)": 18, "Circ Drain": 0, "Cure Delay": 0, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 1, "N2 Rec. (option)": 0, "Cumulative time (s)": 30},    "Step 3": {"N2": null, "Steps": "14 bar steam", "Vacuum": null, "Steam On": "1", "Time (s)": 150, "Circ Drain": 0, "Cure Delay": 0, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 180}, "Step 4": {"N2": null, "Steps": "Nitrogen", "Vacuum": "0", "Steam On": "0", "Time (s)": 390, "Circ Drain": 0, "Cure Delay": 0, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 570}, "Step 5": {"N2": "0", "Steps": "Gas Leak Detection", "Vacuum": "0", "Steam On": "0", "Time (s)": 60, "Circ Drain": 0, "Cure Delay": 0, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 630}, "Step 6": {"N2": "1", "Steps": "Nitrogen", "Vacuum": null, "Steam On": null, "Time (s)": 30, "Circ Drain": 0, "Cure Delay": 1, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 660}, "Step 7": {"N2": "0", "Steps": "Slow Deflation", "Vacuum": "0", "Steam On": "0", "Time (s)": 12, "Circ Drain": 1, "Cure Delay": 0, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 672}, "Step 8": {"N2": "0", "Steps": "Main drain", "Vacuum": "0", "Steam On": "0", "Time (s)": 12, "Circ Drain": 0, "Cure Delay": 0, "Main Drain": 0, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 684}, "Step 9": {"N2": null, "Steps": "Vacuum", "Vacuum": "1", "Steam On": null, "Time (s)": 6, "Circ Drain": 0, "Cure Delay": 0, "Main Drain": 1, "Mold Vent.": 0, "Mold Vacuum": 0, "N2 Rec. (option)": 0, "Cumulative time (s)": 690}}, "default property group": {"Curing critical point": {"Value": "Tread section - Tread"}}, "Curing settings (nitrogen)": {"Cycle time": {"UoM": "min", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Drain duration": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 0.5, "Cr. par.": "N", "Apollo test code": null}, "Mould vacuum time": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 0.3, "Cr. par.": "N", "Apollo test code": null}, "Platen temperature": {"UoM": "°C", "+ tol": 2, "- tol": 2, "Target": 177, "Cr. par.": "N", "Apollo test code": null}, "Curing time (total)": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 11.5, "Cr. par.": "N", "Apollo test code": null}, "1st shaping pressure": {"UoM": "bar", "+ tol": 0.05, "- tol": 0.05, "Target": 0.4, "Cr. par.": "N", "Apollo test code": null}, "2nd shaping pressure": {"UoM": "bar", "+ tol": 0.05, "- tol": 0.05, "Target": 0.6, "Cr. par.": "N", "Apollo test code": null}, "3rd shaping pressure": {"UoM": "bar", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Gas leak detection time": {"UoM": "min", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Internal steam duration": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 3, "Cr. par.": "N", "Apollo test code": null}, "Bladder pressure (steam)": {"UoM": "bar", "+ tol": 0.4, "- tol": 0.4, "Target": 14, "Cr. par.": "N", "Apollo test code": null}, "Internal Nitrogen duration": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 8, "Cr. par.": "N", "Apollo test code": null}, "Bladder pressure (Nitrogen)": {"UoM": "bar", "+ tol": 2, "- tol": 2, "Target": 22, "Cr. par.": "N", "Apollo test code": null}, "Bladder temperature (steam)": {"UoM": "°C", "+ tol": null, "- tol": null, "Target": 198, "Cr. par.": "N", "Apollo test code": null}, "Gas leak detection duration": {"UoM": "min", "+ tol": null, "- tol": null, "Target": 1, "Cr. par.": "N", "Apollo test code": null}, "Bladder temperature (nitrogen)": {"UoM": "°C", "+ tol": null, "- tol": null, "Target": 170, "Cr. par.": "N", "Apollo test code": null}}}, "PCUR52: PCR Curing 52 COLL machine group": {"Tooling": {"Bladder": {"Value": "RP15/5"}, "Segment": {"Value": "4349"}, "Container": {"Value": "ARC5"}, "Sideplate": {"Value": "4349"}, "Bladder code": {"Value": "BLD0081"}, "Bead ring top": {"Value": "H74E"}, "Bead ring bottom": {"Value": "H74E"}, "Bladder clamping #2": {"Value": "HBC-15 Item 2"}, "Bladder clamping #3": {"Value": "HBC-15 Item 3"}, "Bladder clamping #4": {"Value": "HBC-15 Item 4"}, "Bajonet adaptor ring": {"Value": null}}, "Vulcanisation Recipe": {"Storage Location": {"Value": "205"},        "Recipe No. (nitrogen)": {"Value": "GV2156517QPRNV"}}, "default property group": {"volgnummer": {"Value": 20}}, "Curing press parameters": {"Pause time": {"UoM": "min", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Pause height": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Squeeze force": {"UoM": "kN", "+ tol": 30, "- tol": 30, "Target": 1092, "Cr. par.": "N", "Apollo test code": null}, "Squeeze pressure": {"UoM": "bar", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Open shaping time": {"UoM": "min", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Press size / type": {"UoM": "Inch", "+ tol": null, "- tol": null, "Target": 52, "Cr. par.": "N", "Apollo test code": null}, "Open shaping height": {"UoM": "mm", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Loader shape position": {"UoM": "mm", "+ tol": 15, "- tol": 15, "Target": 450, "Cr. par.": "N", "Apollo test code": null}, "Open shaping pressure": {"UoM": "bar", "+ tol": null, "- tol": null, "Target": null, "Cr. par.": "N", "Apollo test code": null}, "Bladder stacking height": {"UoM": "mm", "+ tol": 15, "- tol": 15, "Target": 500, "Cr. par.": "N", "Apollo test code": null}, "Bladder ring down height": {"UoM": "mm", "+ tol": 15, "- tol": 15, "Target": 300, "Cr. par.": "N", "Apollo test code": null}}}}}				{"Function": ["Tyre vulcanized"], "Specification type group": ["SFG (semi finished goods)"]}

--CONCLUSIE: WE MISSEN IN DE VIEW-STRUCTUUR OP EEN BEPAALD LEVEL WEL WAT PROPERTIES ......... ZEER VREEMD, ZOU GEWOON MEE GESELECTEERD MOETEN WORDEN.
--           NOG GEEN IDEE WAAROM DIT ZO IS .... !!!!!!!!!! LATER UITZOEKEN !!!!!!!!!!!!!!


--eind


