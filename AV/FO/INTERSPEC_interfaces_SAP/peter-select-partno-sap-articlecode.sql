--ZOEKEN VAN ALLE SAP-ARTICLE-CODE 
SELECT sp.part_no
,      sh.frame_id
,      sp.property
,      p.description
,      sp.char_1
FROM property p
,    specification_prop sp                              
,    specification_header sh
WHERE sp.property = p.property
AND   sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    ) 
AND sh.part_no = sp.part_no
And  sh.revision = sp.revision
AND   sp.section_id     = 700755 --  SAP information                              
and   sp.property_group = 704056 --  SAP articlecode
and   (  sp.property       = 713824 --  Commercial article code
      or sp.property       = 713825 --  Commercial DA article code	  
       )
AND  sp.char_1 is not null
order by sh.frame_id, sp.part_no , sp.property
;


--ZOEKEN VAN SAP-ARTICLE-CODE EN RETURN IN 1 ROW...
SELECT sh.part_no
,      sh.frame_id
,      sp1.property      sap_property
,      p1.description    sap_description
,      sp1.char_1        sap_article_code
,      sp2.property      sap_da_property
,      p2.description    sap_da_description
,      sp2.char_1        sap_da_article_code
FROM property              p1
,    specification_prop   sp1                              
,    property              p2
,    specification_prop   sp2                              
,    specification_header sh
WHERE sh.part_no ='EF_710/60R42TRO176'
and   sp1.property = p1.property
and   sp2.property = p2.property
AND   sp1.revision = (select max(sh1.revision)                               
                      from status s1, specification_header sh1                              
                      where   sh1.part_no    = sp1.part_no             --is component-part-no                              
                      and     sh1.status     = s1.status                               
                      and     s1.status_type in ('CURRENT','HISTORIC')                              
                     ) 
AND  sh.part_no = sp1.part_no
AND  sh.part_no = sp2.part_no
And  sh.revision = sp1.revision
And  sh.revision = sp2.revision
AND   sp1.section_id     = 700755 --  SAP information                              
and   sp1.property_group = 704056 --  SAP articlecode
and   sp1.property       = 713824 --  Commercial article code
AND   sp2.section_id     = 700755 --  SAP information                              
and   sp2.property_group = 704056 --  SAP articlecode
and   sp2.property       = 713825 --  Commercial DA article code	  
--AND  sp.char_1 is not null
order by sh.frame_id, sh.part_no , sp1.property
;


--ZOEKEN VAN PART-NO obv SAP-ARTICLE-CODE
SELECT sp.part_no
,      sh.frame_id
,      sp.property
,      p.description
,      sp.char_1
FROM property p
,    specification_prop sp                              
,    specification_header sh
WHERE sp.property = p.property
AND   sp.revision = (select max(sh1.revision)                               
                     from status s1, specification_header sh1                              
                     where   sh1.part_no    = sp.part_no             --is component-part-no                              
                     and     sh1.status     = s1.status                               
                     and     s1.status_type in ('CURRENT','HISTORIC')                              
                    ) 
AND sh.part_no = sp.part_no
And  sh.revision = sp.revision
AND   sp.section_id     = 700755 --  SAP information                              
and   sp.property_group = 704056 --  SAP articlecode
and   (  sp.property       = 713824 --  Commercial article code
      or sp.property       = 713825 --  Commercial DA article code	  
       )
AND  sp.char_1 is not null
AND  sp.char_1 = 'SPPOR992TUSA00'
order by sh.frame_id, sp.part_no , sp.property
;
--EQ_SP-ASEM-P20BS	E_BBQ	713824	Commercial article code	SPPOR992TUSA00