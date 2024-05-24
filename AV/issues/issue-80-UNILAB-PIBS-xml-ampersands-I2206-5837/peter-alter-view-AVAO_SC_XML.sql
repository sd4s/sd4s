/*
--ORIGINELE VIEW DD. 28-06-2022:
CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SC_XML" ("SC", "ST", "CREATED_BY", "SS", "ICLS") AS 
  SELECT m.sc, 
          m.st,
          m.created_by,
          m.ss,
          CAST (MULTISET (SELECT ic, icnode, ip_version, description, winsize_x, winsize_y,
                                 is_protected, hidden, manually_added, next_ii, 
                                 ic_class, log_hs, log_hs_details, allow_modify, ar, active, lc,
                                 lc_version, ss,
                                 CAST (MULTISET (SELECT ii, iinode, ie_version, iivalue, pos_x, pos_y,
                                                        is_protected, mandatory, hidden, 
                                                        dsp_title, dsp_len, dsp_tp, dsp_rows, 
                                                        ii_class, log_hs, log_hs_details, allow_modify, ar, active, lc,
                                                        lc_version, ss
                                                   FROM uvscii
                                                  WHERE sc(+) = a.sc
                                                    AND ic = a.ic AND icnode = a.icnode) AS atao_iils) iils
                            FROM uvscic a
                           WHERE a.sc(+) = m.sc) AS atao_icls) icls 
     FROM utsc m 
 ;
*/

--PS: dd. 30-06-2022: MET REPLACE-AMPERSAND-CONSTRUCTIE VOOR XML !!!
CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SC_XML" 
("SC"
, "ST"
, "CREATED_BY"
, "SS"
, "ICLS"
) AS 
SELECT m.sc
,      m.st
,      m.created_by
,      m.ss
,      CAST (MULTISET (SELECT ic
                       ,      icnode
					   ,      ip_version
					   ,      description
					   ,      winsize_x
					   ,      winsize_y
					   ,      is_protected
					   ,      hidden
					   ,      manually_added
					   ,      next_ii
					   ,      ic_class
					   ,      log_hs
					   ,      log_hs_details
					   ,      allow_modify
					   ,      ar
					   ,      active
					   ,      lc
					   ,      lc_version
					   ,      ss
					   ,      CAST (MULTISET (SELECT ii
					                          ,      iinode
											  ,      ie_version
											  ,      dbms_xmlgen.convert(iivalue,1)        --ampersand-subsitution
											  ,      pos_x
											  ,      pos_y
											  ,      is_protected
											  ,      mandatory
											  ,      hidden
											  ,      dsp_title
											  ,      dsp_len
											  ,      dsp_tp
											  ,      dsp_rows
											  ,      ii_class
											  ,      log_hs
											  ,      log_hs_details
											  ,      allow_modify
											  ,      ar
											  ,      active
											  ,      lc
											  ,      lc_version
											  ,      ss
                                              FROM uvscii
                                              WHERE sc(+) = a.sc
                                              AND ic     = a.ic 
											  AND icnode = a.icnode 
											 ) AS atao_iils
								   ) iils
                        FROM uvscic a
                        WHERE a.sc(+) = m.sc
                       ) AS atao_icls
			) icls 
FROM utsc m 
;

 
 
