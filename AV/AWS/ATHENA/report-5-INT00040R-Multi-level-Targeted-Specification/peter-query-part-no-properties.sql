--query voor opvragen van alle PROPERTIES bij PART-NO

WITH cart AS 
 (SELECT 'Array'                                                AS origin
 ,      'XGG_BF66A17J1'                                         AS part_no
 ,      to_date('2023/10/09 10:36:32', 'YYYY/MM/DD HH24:MI:SS') AS reference_date
 ,      NULL                                                    AS plant 
 FROM dual
 )
, partList AS 
(SELECT H.part_no
 ,      H.revision
 ,	    H.issued_date
 ,      H.planned_effective_date
 ,      H.obsolescence_date
 ,	    H.class3_id
 ,	    B.plant
 ,      B.preferred
 ,      B.alternative
 ,	    S.status
 ,      S.sort_desc AS status_code
 ,      S.status_type
 ,	    L.reference_date
 FROM cart L
 JOIN specification_header H ON (H.part_no  = L.part_no)
 JOIN status               S ON (S.status   = H.status)
 JOIN class3               C ON (C.class    = H.class3_id)
 LEFT JOIN bom_header      B ON ( B.part_no = H.part_no AND B.revision = H.revision )
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 --AND C.sort_desc	= 'FOC_NONE'
 AND B.preferred	= 1
 AND B.alternative	= 1            --FOC_NONE
 AND (L.plant IS NULL OR B.plant = L.plant)
 AND NOT EXISTS ( SELECT 1
                  FROM specification_header
                  JOIN status USING (status)
                  WHERE part_no = H.part_no
                  AND revision  > H.revision
                  AND status_type IN ('HISTORIC', 'CURRENT')
                 )
 AND	( 'DEFAULT' <> 'REFDATE'
        OR ( 'DEFAULT' = 'REFDATE'
           AND	L.reference_date >= coalesce(H.issued_date, H.planned_effective_date)
           AND (H.obsolescence_date IS NULL OR L.reference_date < H.obsolescence_date)
           )
        )
 GROUP BY H.part_no
 ,        H.revision
 ,	      H.issued_date
 ,        H.planned_effective_date
 ,        H.obsolescence_date
 ,	      H.class3_id
 ,	      B.plant
 ,        B.preferred
 ,        B.alternative
 ,	      S.status
 ,        S.sort_desc
 ,        S.status_type
 ,	      L.reference_date
)
, specList AS 
(SELECT h2.part_no
 ,      h2.revision
 ,	    h2.issued_date
 ,      h2.obsolescence_date
 ,      h2.planned_effective_date
 ,	    h2.status
 ,      s2.sort_desc     AS status_code
 ,      s2.status_type
 ,	    h2.class3_id
 ,	    CASE WHEN 'DEFAULT' = 'REFDATE' 
             THEN 1 
			 ELSE 0 
	    END               AS f_checkRefDate
 FROM specification_header h2
 JOIN status s2 ON ( s2.status = h2.status AND status_type IN ('HISTORIC', 'CURRENT') )
 WHERE (  'DEFAULT' = 'HIGHEST' 
       OR h2.issued_date IS NOT NULL
	   )
)
, root_function AS 
(SELECT sk.part_no
 ,      sk.kw_value
 FROM specification_kw sk
 JOIN itkw                 ON ( itkw.kw_id = sk.kw_id AND itkw.description = 'Function' )
)
, BoMProperties (part_no                     
                ,revision                    
                ,item_number
				,branch       
                ,section_sequence_no
                ,ref_id
                ,type
                ,sequence_no
                ,section_id
                ,section_rev
                ,sub_section_id
                ,sub_section_rev
                ,property_group
                ,property
                ,pg_sequence_no
                ,sp_num_1
                ,sp_num_2
                ,sp_num_3
                ,sp_num_4
                ,sp_num_5
                ,sp_num_6
                ,sp_num_7
                ,sp_num_8
                ,sp_num_9
                ,sp_num_10
                ,sp_char_1
                ,sp_char_2
                ,sp_char_3
                ,sp_char_4
                ,sp_char_5
                ,sp_char_6
                ,sp_boolean_1
                ,sp_boolean_2
                ,sp_boolean_3
                ,sp_boolean_4
                ,sp_date_1
                ,sp_date_2
                ,sp_uom_id
                ,sp_attribute
                ,sp_test_method
                ,sp_characteristic
                ,sp_ch_2
                ,sp_ch_3
                ,layout_id
                ,field_id
                ,header_id
                ,start_pos
                ,format_id
                ,field_relevance_bit 
) AS 
(SELECT p.part_no      
,       p.revision     
,       NULL    AS item_number
,       null    as branch       
,	    ss.section_sequence_no
,       ss.ref_id
,       ss.type
,	    ss.sequence_no
,	    sp.section_id
,       sp.section_rev
,	    sp.sub_section_id
,       sp.sub_section_rev
,	    sp.property_group
,       sp.property
,       sp.sequence_no as pg_sequence_no
,	sp.num_1 AS sp_num_1
,	sp.num_2 AS sp_num_2
,	sp.num_3 AS sp_num_3
,	sp.num_4 AS sp_num_4
,	sp.num_5 AS sp_num_5
,	sp.num_6 AS sp_num_6
,	sp.num_7 AS sp_num_7
,	sp.num_8 AS sp_num_8
,	sp.num_9 AS sp_num_9
,	sp.num_10 AS sp_num_10
,	sp.char_1 AS sp_char_1
,	sp.char_2 AS sp_char_2
,	sp.char_3 AS sp_char_3
,	sp.char_4 AS sp_char_4
,	sp.char_5 AS sp_char_5
,	sp.char_6 AS sp_char_6
,	sp.boolean_1 AS sp_boolean_1
,	sp.boolean_2 AS sp_boolean_2
,	sp.boolean_3 AS sp_boolean_3
,	sp.boolean_4 AS sp_boolean_4
,	sp.date_1 AS sp_date_1
,	sp.date_2 AS sp_date_2
,	sp.uom_id AS sp_uom_id
,	sp.attribute AS sp_attribute
,	sp.test_method AS sp_test_method
,	sp.characteristic AS sp_characteristic
,	sp.ch_2 AS sp_ch_2
,	sp.ch_3 AS sp_ch_3
,	pl.layout_id
,	pl.field_id
,   pl.header_id
,   pl.start_pos
,   pl.format_id
,	CASE	WHEN pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' THEN 0
			WHEN pl.field_id = 23  THEN 0	ELSE 1
	END AS field_relevance_bit
FROM partList p
JOIN root_function r ON (r.part_no = p.part_no)
JOIN specification_prop sp ON (	  sp.part_no		= p.part_no    --changed-p-to-t
                              AND sp.revision		= p.revision   --changed-p-to-t
--                              AND sp.section_id		    = t.section_id
--                              AND sp.sub_section_id	    = t.sub_section_id
--                              AND sp.property_group     = t.property_group
--                              AND sp.property			= t.property
                              )
-- Base columns per property-group or single property on layout fields
JOIN specification_section ss ON (   ss.part_no			= sp.part_no
                                 AND ss.revision		= sp.revision
                                 AND ss.section_id		= sp.section_id
                                 AND ss.section_rev		= sp.section_rev
                                 AND ss.sub_section_id	= sp.sub_section_id
                                 AND ss.sub_section_rev	= sp.sub_section_rev
                                 --AND ss.type			= t.type
                                 AND (	(ss.type = 1 AND ss.ref_id = sp.property_group)
                                     OR (ss.type = 4 AND ss.ref_id = sp.property)
                                     )
                                 )
JOIN property_layout pl ON (   pl.layout_id		= ss.display_format
                           AND pl.revision		= ss.display_format_rev
                           --AND pl.header_id		= t.header_id
                           AND (  (pl.field_id = 1	 AND sp.num_1	IS NOT NULL			)
                               OR (pl.field_id = 2	 AND sp.num_2	IS NOT NULL			)
                               OR (pl.field_id = 3	 AND sp.num_3	IS NOT NULL			)
                               OR (pl.field_id = 4	 AND sp.num_4	IS NOT NULL			)
                               OR (pl.field_id = 5	 AND sp.num_5	IS NOT NULL			)
                               OR (pl.field_id = 6	 AND sp.num_6	IS NOT NULL			)
                               OR (pl.field_id = 7  AND sp.num_7	IS NOT NULL			)
							   OR (pl.field_id = 8	 AND sp.num_8	IS NOT NULL			)
							   OR (pl.field_id = 9  AND sp.num_9	IS NOT NULL			)
							   OR (pl.field_id = 10 AND sp.num_10	IS NOT NULL			)
							   OR (pl.field_id = 11 AND sp.char_1	IS NOT NULL			)
							   OR (pl.field_id = 12 AND sp.char_2	IS NOT NULL			)
							   OR (pl.field_id = 13 AND sp.char_3	IS NOT NULL			)
							   OR (pl.field_id = 14 AND sp.char_4	IS NOT NULL			)
							   OR (pl.field_id = 15 AND sp.char_5	IS NOT NULL			)
							   OR (pl.field_id = 16 AND sp.char_6	IS NOT NULL			)
							   OR (pl.field_id = 17 AND sp.boolean_1 <> 'N'				)
							   OR (pl.field_id = 18 AND sp.boolean_2 <> 'N'				)
							   OR (pl.field_id = 19 AND sp.boolean_3 <> 'N'				)
							   OR (pl.field_id = 20 AND sp.boolean_4 <> 'N'				)
							   OR (pl.field_id = 21 AND sp.date_1	IS NOT NULL			)
							   OR (pl.field_id = 22 AND sp.date_2	IS NOT NULL			)
							   OR (pl.field_id = 23 AND sp.uom_id	IS NOT NULL			)
							   OR (pl.field_id = 32 AND sp.test_method	<> 0			)
							   OR (pl.field_id = 26 AND sp.characteristic IS NOT NULL	)
							   OR (pl.field_id = 30 AND sp.ch_2	IS NOT NULL				)
							   OR (pl.field_id = 31 AND sp.ch_3	IS NOT NULL				)
							   OR (pl.field_id = 27)
	                           )
                            )
JOIN layout l ON (l.layout_id = pl.layout_id AND l.revision = pl.revision )
JOIN header h ON (h.header_id = pl.header_id)
WHERE NOT (  (  pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' )
             or (  pl.field_id = 23  )
	      )
)
SELECT bp.part_no                     
,   part.description AS part_descr
,bp.revision                    
,bp.item_number
,bp.branch       
,bp.section_sequence_no
,bp.ref_id
,bp.type
,bp.sequence_no
,bp.section_id
,	sc.description   AS section_descr
,bp.section_rev
,bp.sub_section_id
,	su.description   AS sub_section_descr
,bp.sub_section_rev
,bp.property_group
,	pg.description   AS property_group_descr
,bp.property
,	p.description    AS property_descr
,bp.pg_sequence_no
,bp.sp_num_1
,bp.sp_num_2
,bp.sp_num_3
,bp.sp_num_4
,bp.sp_num_5
,bp.sp_num_6
,bp.sp_num_7
,bp.sp_num_8
,bp.sp_num_9
,bp.sp_num_10
,bp.sp_char_1
,bp.sp_char_2
,bp.sp_char_3
,bp.sp_char_4
,bp.sp_char_5
,bp.sp_char_6
,bp.sp_boolean_1
,bp.sp_boolean_2
,bp.sp_boolean_3
,bp.sp_boolean_4
,bp.sp_date_1
,bp.sp_date_2
,bp.sp_uom_id
,	u.description    AS uom_descr
,bp.sp_attribute
,	a.description    AS attribute_descr
,bp.sp_test_method
,	tm.description   AS test_method_descr
,bp.sp_characteristic
,	ch.description   AS ch_1_descr
,bp.sp_ch_2
,	c2.description   AS ch_2_descr
,bp.sp_ch_3
,	c3.description   AS ch_3_descr
,bp.layout_id
,bp.field_id
,bp.header_id
,	h.description    AS header_descr
,bp.start_pos
,bp.format_id
,bp.field_relevance_bit
,	pc.description   AS property_descr2
FROM BoMProperties bp 
LEFT JOIN	part            ON (part.part_no      = bp.part_no)
JOIN section             sc ON (sc.section_id     = bp.section_id)
LEFT JOIN sub_section    su ON (su.sub_section_id = bp.sub_section_id AND bp.sub_section_id <> 0)
JOIN property_group      pg ON (pg.property_group = bp.property_group)
JOIN property             p ON (p.property        = bp.property)
JOIN header               h ON (h.header_id       = bp.header_id)
LEFT JOIN uom             u ON (bp.field_id = 23 AND u.uom_id             = bp.sp_uom_id)
LEFT JOIN attribute       a ON (bp.field_id = 24 AND a.attribute          = bp.sp_attribute)
LEFT JOIN test_method    tm ON (bp.field_id = 25 AND tm.test_method       = bp.sp_test_method)
LEFT JOIN characteristic ch ON (bp.field_id = 26 AND ch.characteristic_id = bp.sp_characteristic)
LEFT JOIN characteristic c2 ON (bp.field_id = 30 AND c2.characteristic_id = bp.sp_ch_2)
LEFT JOIN characteristic c3 ON (bp.field_id = 31 AND c3.characteristic_id = bp.sp_ch_3)
LEFT JOIN property       pc ON (bp.field_id = 27 AND pc.property          = bp.property)
order by  bp.part_no, bp.section_id, bP.sub_section_id, bP.property_group, bP.property
;

/*
XGG_BF66A17J1	Greentyre BMW F66A17	2			1700	705238	4		700583	Processing	100	700542	General	100	0	default property group	705238	Recipe no.	100																									0										700930	27	700005	Property	1		0	Recipe no.
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	705244	Rimcushion under bead	200																	Y	N	Y	N					0										703829	17	701631	APBM	2		1	
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	705244	Rimcushion under bead	200																	Y	N	Y	N					0										703829	27	700005	Property	1		0	Rimcushion under bead
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	705244	Rimcushion under bead	200																	Y	N	Y	N					0										703829	19	701633	MAXX	4		1	
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	705632	Sidewall over tread	100																	N	N	Y	N					0										703829	27	700005	Property	1		0	Sidewall over tread
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	705632	Sidewall over tread	100																	N	N	Y	N					0										703829	19	701633	MAXX	4		1	
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	706588	Endless capply	300																	Y	N	Y	N					0										703829	19	701633	MAXX	4		1	
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	706588	Endless capply	300																	Y	N	Y	N					0										703829	27	700005	Property	1		0	Endless capply
XGG_BF66A17J1	Greentyre BMW F66A17	2			400	701557	1	3	700584	Properties	100	0		100	701557	Construction parameters	706588	Endless capply	300																	Y	N	Y	N					0										703829	17	701631	APBM	2		1	
XGG_BF66A17J1	Greentyre BMW F66A17	2			200	701564	1	2	700584	Properties	100	0		100	701564	Greentyre properties	703508	Circumference greentyre	100	1897	12	12														N	N	N	N			700649		0		0								701928	27	700005	Property	1		0	Circumference greentyre
XGG_BF66A17J1	Greentyre BMW F66A17	2			200	701564	1	2	700584	Properties	100	0		100	701564	Greentyre properties	703508	Circumference greentyre	100	1897	12	12														N	N	N	N			700649		0		0								701928	3	700812	+ tol	5		1	
XGG_BF66A17J1	Greentyre BMW F66A17	2			200	701564	1	2	700584	Properties	100	0		100	701564	Greentyre properties	703508	Circumference greentyre	100	1897	12	12														N	N	N	N			700649		0		0								701928	1	700498	Target	3		1	
etc.
*/







--*******************************************************************************
--query for the PART-NO-PROPERTIES
--*******************************************************************************
select sh.part_no
,      sh.revision
,      bh.plant
,      bh.preferred
,      bh.alternative
,      sh.status
,      sh.frame_id
,      sp.section_id
,      s.description section_descr
,      sp.SUB_section_id
,      ss.description subsection_descr
,      sp.property_group
,      pg.description pg_descr
,      sp.property
,      p.description p_descr
,      sps.type
,      sps.ref_id
,      h.header_id
,      pl.field_id
,      sps.display_format
,      l.description      layout_descr
,      h.description      header_descr
,      sp.uom_id 
,	   u.description    AS uom_descr
,      sp.attribute
,	   a.description    AS attribute_descr
,      sp.test_method
,	   tm.description   AS test_method_descr
,      sp.characteristic
,      c.description    AS ch_1_descr
,      sp.ch_2
,	   c2.description   AS ch_2_descr
,      sp.ch_3
,	   c3.description   AS ch_3_descr
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then to_char(sp.Num_1)
            when pl.field_id = 2  then to_char(sp.Num_2)
            when pl.field_id = 3  then to_char(sp.Num_3)
            when pl.field_id = 4  then to_char(sp.Num_4)
            when pl.field_id = 5  then to_char(sp.Num_5)
            when pl.field_id = 6  then to_char(sp.Num_6)
            when pl.field_id = 7  then to_char(sp.Num_7)
            when pl.field_id = 8  then to_char(sp.Num_8)
            when pl.field_id = 9  then to_char(sp.Num_9)
            when pl.field_id = 10 then to_char(sp.Num_10)
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then TO_CHAR(sp.Date_1,'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2,'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then to_char(sp.UOM_id)
            when pl.field_id = 24 then to_char(sp.Attribute)
            when pl.field_id = 25 then to_char(sp.Test_method)
            when pl.field_id = 26 then to_char(sp.Characteristic)
            when pl.field_id = 27 then to_char(sp.Property)
            when pl.field_id = 30 then to_char(sp.Ch_2)
            when pl.field_id = 31 then to_char(sp.Ch_3)
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN status                    st   on st.status    = sh.status
JOIN bom_header                bh   on bh.part_no   = sh.part_no  and bh.revision = sh.revision
JOIN specification_prop        sp   on sp.part_no   = sh.part_no  and sh.revision = sp.revision
join specification_section     sps  on sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id 
JOIN layout                    l    ON l.layout_id  = sps.display_format and l.revision = sps.display_format_rev
JOIN property_layout           pl   ON pl.layout_id = l.layout_id        and pl.revision = l.revision
join header                    h    on h.header_id  = pl.header_id 
JOIN SECTION                   s    ON s.section_id = sp.section_id
JOIN SUB_SECTION               ss   on ss.sub_section_id   = sp.sub_section_id
JOIN PROPERTY_GROUP            pg   ON pg.property_GROUP   = sp.property_group
JOIN PROPERTY                  p    on p.property          = sp.property
LEFT JOIN uom             u ON (pl.field_id = 23 AND u.uom_id             = sp.uom_id)
LEFT JOIN attribute       a ON (pl.field_id = 24 AND a.attribute          = sp.attribute)
LEFT JOIN test_method    tm ON (pl.field_id = 25 AND tm.test_method       = sp.test_method)
LEFT JOIN characteristic c  ON (pl.field_id = 26 AND c.characteristic_id  = sp.characteristic)
LEFT JOIN characteristic c2 ON (pl.field_id = 30 AND c2.characteristic_id = sp.ch_2)
LEFT JOIN characteristic c3 ON (pl.field_id = 31 AND c3.characteristic_id = sp.ch_3)
WHERE  sp.part_no = 'XGG_BF66A17J1' 	
AND   NOT (  (  pl.field_id = 27  AND UPPER(h.description) = 'PROPERTY' )  --or (  pl.field_id = 23  )
	      )	
AND   st.status_type IN ('HISTORIC', 'CURRENT') 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
;


--example WHERE-CLAUSE
--where part_no = 'XGG_BF66A17J1'
--and   preferred = 1
--and   alternative = 1
--and   db_field_value is not null

	   
/*
XGG_BF66A17J1	2	125	A_PCR_GT v1	700583	Processing	700542	General	0	default property group	705238	Recipe no.	4	705238	700005	27	700930	IS_Single_Value_CHAR_DF	Property			Property	705238
XGG_BF66A17J1	2	125	A_PCR_GT v1	700583	Processing	700542	General	0	default property group	705238	Recipe no.	4	705238	700511	11	700930	IS_Single_Value_CHAR_DF	Value			Char_1	
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701557	700005	27	703829	IS_Triple_Boolean	Property			Property	705244
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701557	701631	17	703829	IS_Triple_Boolean	APBM			Boolean_1	Y
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701557	701632	18	703829	IS_Triple_Boolean	HAPBM			Boolean_2	N
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701557	701633	19	703829	IS_Triple_Boolean	MAXX			Boolean_3	Y
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701564	700005	27	701928	IS_production_B&V	Property			Property	705244
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701564	700010	23	701928	IS_production_B&V	UoM			UOM_id	
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701564	700498	1	701928	IS_production_B&V	Target			Num_1	
XGG_BF66A17J1	2	125	A_PCR_GT v1	700584	Properties	0	(none)	701557	Construction parameters	705244	Rimcushion under bead	1	701564	700501	25	701928	IS_production_B&V	Apollo test code			Test method	
*/
