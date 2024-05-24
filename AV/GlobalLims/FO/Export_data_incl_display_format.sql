-- Correct but without display format
select d.part_no
, d.revision
, status.sort_desc status
, s.description section
, ss.description sub_section
, pg.description property_group
, d.sequence_no seq
, p.description property
--,dsp.type
--, dsp.ref_id
--, l.description display_format
, u.description uom
, tm.description test_method
, d.num_1, d.num_2, d.num_3, d.num_4, d.num_5, d.num_6, d.num_7, d.num_8, d.num_9, d.num_10
, d.char_1, d.char_2, d.char_3, d.char_4, d.char_5, d.char_6
, d.boolean_1, d.boolean_2, d.boolean_3, d.boolean_4
, d.date_1, d.date_2
, a.description association
, c.description characteristic
, d.intl
, d.info
, d.uom_alt_id
, d.uom_alt_rev
, d.tm_det_1, d.tm_det_2, d.tm_det_3, d.tm_det_4
, d.tm_set_no
, a2.description association2
, c2.description characteristic2
, a3.description association3
, c3.description characteristic3
from specification_prop d
, specification_header h
, status
, section s
, sub_section ss
, property_group pg
, property p
--, specification_section dsp
--, layout l
, uom u
, test_method tm
, association    a
, characteristic c
, association    a2
, characteristic c2
, association    a3
, characteristic c3
where h.frame_id = 'Trial E_CA_PCT'
   and h.status           = status.status
   and status.status_type = 'CURRENT'
   and d.part_no  = h.part_no
   and d.revision = h.revision
   and s.section_id         = d.section_id
   and ss.sub_section_id(+) = d.sub_section_id
   and pg.property_group(+) = d.property_group
   and p.property(+)        = d.property
   and u.uom_id(+)          = d.uom_id
   and tm.test_method(+)    = d.test_method
   and a.association(+)        = d.association
   and c.characteristic_id(+)  = d.characteristic
   and a2.association(+)       = d.as_2
   and c2.characteristic_id(+) = d.ch_2
   and a3.association(+)       = d.as_3
   and c3.characteristic_id(+) = d.ch_3
   order by d.part_no, s.description, ss.description, pg.description, d.sequence_no
 ;
 
/*
status:
1	DEV			In Development
2	SUBMIT		Submit for Approval
3	APPROVED	Approved
4	CURRENT		Current
5	HISTORIC	Historic
6	REJECTED	Rejected
7	OBSOLETE	Obsolete
...
*/ 

/*
select part_NO 
from SPECIFICATION_HEADER 
where FRAME_ID ='Trial E_CA_PCT';

--ALLE part-no gerelateerd aan FRAME-ID
*/

/*
select * from FRAME_HEADER where FRAME_NO = 'Trial E_CA_PCT' ;
--                      sts=SUBMIT 
Trial E_CA_PCT	6	1	2	Competitor specs PCR, AT and Bicycle	05-02-2020 15:56:16	PGO	05-02-2020 10:41:43
*/


/*
SELECT * FROM FRAME_SECTION WHERE FRAME_NO='Trial E_CA_PCT' ;
--                      sec         sub     TYPE ref_id                         property   
Trial E_CA_PCT	6	1	700579	100	0	100	1	 701562	3	1	Y	500	100		701788	1
Trial E_CA_PCT	6	1	700579	100	0	100	1	 701563	1	1	Y	300	100		700929	4
Trial E_CA_PCT	6	1	700579	100	0	100	1	 701569	2	1	Y	400	100		700930	2
Trial E_CA_PCT	6	1	700579	100	0	100	1	 701976		1	Y	600	100		702671	1    --komt niet voor in specification_prop
Trial E_CA_PCT	6	1	700579	100	0	100	1	 702636		1	Y	100	100		702669	1
Trial E_CA_PCT	6	1	700579	100	0	100	1	 702637		0	Y	200	100		702668	1
Trial E_CA_PCT	6	1	700579	100	0	100	5	 702526		1	N	700	100	    5		0
*/

/*
SELECT * FROM SPECIFICATION_PROP SPP, SPECIFICATION_HEADER SH WHERE SH.FRAME_ID='Trial E_CA_PCT' AND SH.PART_NO = SPP.PART_NO AND SH.REVISION = SPP.REVISION AND SPP.SECTION_ID=700579;
--
XEF_CA17-219	2	700579	100	0	100	701562	100	705192	400
XEF_CA17-219	2	700579	100	0	100	701562	100	705195	300
--
XEF_CA17-219	2	700579	100	0	100	701563	100	703418	301
XEF_CA17-219	2	700579	100	0	100	701563	100	703544	401
XEF_CA17-219	2	700579	100	0	100	701563	100	705045	201
--
XEF_CA17-219	2	700579	100	0	100	701569	100	703417	301
XEF_CA17-219	2	700579	100	0	100	701569	100	703421	300
XEF_CA17-219	2	700579	100	0	100	701569	100	703423	301
XEF_CA17-219	2	700579	100	0	100	701569	100	703424	301
XEF_CA17-219	2	700579	100	0	100	701569	100	703425	300
XEF_CA17-219	2	700579	100	0	100	701569	100	705669	101
XEF_CA17-219	2	700579	100	0	100	701569	100	710308	100
--
XEF_CA17-219	2	700579	100	0	100	702636	100	708648	100
--
XEF_CA17-219	2	700579	100	0	100	702637	100	703422	301
*/
 
 
--QUERY INCL. DISPLAY-FORMAT 
select spr.part_no    part_no
, spr.revision        part_revision
, sh.frame_id         frame_id
, sh.frame_rev        frame_rev
, st.sort_desc      status
, s.section_id      section
, s.description     section_descr
, ss.sub_section_id sub_section
, ss.description    sub_section_descr
, pg.property_group prop_group
, pg.description    prop_group_descr
, spr.sequence_no     seq
, p.property        property
, p.description     property_desc
, u.description     uom
, tm.description    test_method
, spr.num_1, spr.num_2, spr.num_3, spr.num_4, spr.num_5, spr.num_6, spr.num_7, spr.num_8, spr.num_9, spr.num_10
, spr.char_1, spr.char_2, spr.char_3, spr.char_4, spr.char_5, spr.char_6
, spr.boolean_1, spr.boolean_2, spr.boolean_3, spr.boolean_4
, spr.date_1, spr.date_2
, a.description     association
, c.description     characteristic
, spr.intl
, spr.info
, spr.uom_alt_id
, spr.uom_alt_rev
, spr.tm_det_1, spr.tm_det_2, spr.tm_det_3, spr.tm_det_4
, spr.tm_set_no
, a2.description association2
, c2.description characteristic2
, a3.description association3
, c3.description characteristic3
, fs.frame_no        fs_frame
, fs.revision        fs_rev
, fs.section_id      fs_section
, fs.sub_section_id  fs_sub_section
, fs.ref_id          fs_ref_id
, fs.type            fs_type
, fs.display_format  fs_dispay_format
, (SELECT DISTINCT l.description from layout l where l.layout_id = fs.display_format) display_format_descr
from specification_prop   spr
,    specification_header sh
,    status         st
,    section        s
,    sub_section    ss
,    property_group pg
,    property       p
,    frame_section  fs    --LET OP: contains all sections/sub-sections + REF_ID's of all property-groups (type=1)/properties(type=4) EN ook VOOR MEERDERE FRAME-REVISIONs!!
,    uom            u
,    test_method   tm
,    association    a
,    characteristic c
,    association    a2
,    characteristic c2
,    association    a3
,    characteristic c3
where  sh.frame_id         = 'A_RM_Polymer v1'  -- 'Trial E_CA_PCT'
   and sh.part_no          = '120020BA'  
   and sh.status           = st.status
   --and st.status_type       = 'CURRENT'
   and sh.frame_id          = fs.frame_no
   and sh.frame_rev         = fs.revision
   --and sh.revision in (select max(fh.revision) from frame_header fh where fh.frame_no = fs.frame_no and fh.status = 3 ) --APPROVED
   and fs.section_id        = spr.section_id
   and fs.sub_section_id    = spr.sub_section_id
   AND (  (   fs.type = 1
          and fs.ref_id = spr.property_group )
	   or (   fs.type = 4
	      and fs.ref_id = spr.property )
	   )
   and spr.part_no          = sh.part_no
   and spr.revision         = sh.revision
   and s.section_id         = spr.section_id
   and ss.sub_section_id(+) = spr.sub_section_id
   and pg.property_group(+) = spr.property_group
   and p.property(+)        = spr.property
   and u.uom_id(+)          = spr.uom_id
   and tm.test_method(+)    = spr.test_method
   and a.association(+)        = spr.association
   and c.characteristic_id(+)  = spr.characteristic
   and a2.association(+)       = spr.as_2
   and c2.characteristic_id(+) = spr.ch_2
   and a3.association(+)       = spr.as_3
   and c3.characteristic_id(+) = spr.ch_3
   order by spr.part_no, s.description, ss.description, pg.description, spr.sequence_no
 ;
 
/*
Trial E_CA_PCT	6	700579	0	701562	1	701788
Trial E_CA_PCT	6	700579	0	702636	1	702669
Trial E_CA_PCT	6	700579	0	701976	1	702671
Trial E_CA_PCT	6	700579	0	701569	1	700930
Trial E_CA_PCT	6	700579	0	701563	1	700929
*/ 
 
with  
 
 
 

 
 
--FRAME_HEADER
FRAME_NO           NOT NULL VARCHAR2(18 CHAR) 
REVISION           NOT NULL NUMBER(6,2)       
OWNER              NOT NULL NUMBER(4)         
STATUS             NOT NULL NUMBER(4)         
DESCRIPTION        NOT NULL VARCHAR2(60 CHAR) 
STATUS_CHANGE_DATE          DATE              
CREATED_BY                  VARCHAR2(40 CHAR) 
CREATED_ON                  DATE              
LAST_MODIFIED_BY            VARCHAR2(20 CHAR) 
LAST_MODIFIED_ON            DATE              
INTL                        VARCHAR2(1 CHAR)  
CLASS3_ID                   NUMBER(8)         
WORKFLOW_GROUP_ID           NUMBER(8)         
ACCESS_GROUP                NUMBER(8)         
INT_FRAME_NO                VARCHAR2(18 CHAR) 
INT_FRAME_REV               NUMBER(4)         
EXPORTED                    NUMBER(1)         

select frame_no, revision, status from frame_header where frame_no='A_RM_Polymer v1';
/*
A_RM_Polymer v1	94	3
A_RM_Polymer v1	95	3
A_RM_Polymer v1	96	3
A_RM_Polymer v1	97	3
A_RM_Polymer v1	98	3
A_RM_Polymer v1	99	3
A_RM_Polymer v1	100	3
A_RM_Polymer v1	101	2
A_RM_Polymer v1	102	1
*/

 
--FRAME_SECTION
FRAME_NO            NOT NULL VARCHAR2(18 CHAR)       --RELATED TO FRAME_HEADER.FRAME_NO
REVISION            NOT NULL NUMBER(6,2)             --RELATED TO FRAME_HEADER.REVISION
OWNER               NOT NULL NUMBER(4)         
SECTION_ID          NOT NULL NUMBER(8)         
SECTION_REV         NOT NULL NUMBER(4)         
SUB_SECTION_ID      NOT NULL NUMBER(8)         
SUB_SECTION_REV     NOT NULL NUMBER(4)         
TYPE                NOT NULL NUMBER(2)                --type=1 = prop-group, type=2 = property
REF_ID              NOT NULL NUMBER(8)         
SEQUENCE_NO                  NUMBER(13)        
HEADER                       NUMBER(4)         
MANDATORY                    VARCHAR2(1 CHAR)  
SECTION_SEQUENCE_NO NOT NULL NUMBER(13)        
REF_VER                      NUMBER(4)         
REF_INFO                     NUMBER(8)         
DISPLAY_FORMAT               NUMBER(8)         
DISPLAY_FORMAT_REV           NUMBER(4)         
ASSOCIATION                  NUMBER(8)         
INTL                         VARCHAR2(1 CHAR)  
REF_OWNER                    NUMBER(4)         
SC_EXT                       VARCHAR2(1 CHAR)  
REF_EXT                      VARCHAR2(1 CHAR) 

 
--SPECIFICATION_HEADER
PART_NO                NOT NULL VARCHAR2(18 CHAR) 
REVISION               NOT NULL NUMBER(4)         
STATUS                 NOT NULL NUMBER(4)         
DESCRIPTION            NOT NULL VARCHAR2(60 CHAR) 
PLANNED_EFFECTIVE_DATE          DATE              
ISSUED_DATE                     DATE              
OBSOLESCENCE_DATE               DATE              
STATUS_CHANGE_DATE              DATE              
PHASE_IN_TOLERANCE              NUMBER(2)         
CREATED_BY                      VARCHAR2(40 CHAR) 
CREATED_ON                      DATE              
LAST_MODIFIED_BY                VARCHAR2(40 CHAR) 
LAST_MODIFIED_ON                DATE              
FRAME_ID               NOT NULL VARCHAR2(18 CHAR) 
FRAME_REV              NOT NULL NUMBER(6,2)       
ACCESS_GROUP           NOT NULL NUMBER(8)         
WORKFLOW_GROUP_ID      NOT NULL NUMBER(8)         
CLASS3_ID              NOT NULL NUMBER(8)         
OWNER                  NOT NULL NUMBER(4)         
INT_FRAME_NO                    VARCHAR2(18 CHAR) 
INT_FRAME_REV                   NUMBER(4)         
INT_PART_NO                     VARCHAR2(18 CHAR) 
INT_PART_REV                    NUMBER(4)         
FRAME_OWNER                     NUMBER(4)         
INTL                            VARCHAR2(1 CHAR)  
MULTILANG                       NUMBER(1)         
UOM_TYPE                        NUMBER(1)         
MASK_ID                         NUMBER(8)         
PED_IN_SYNC                     VARCHAR2(1 CHAR)  
LOCKED                          VARCHAR2(20 CHAR) 
 
--DESCR LAYOUT
LAYOUT_ID        NOT NULL NUMBER(8)         
DESCRIPTION      NOT NULL VARCHAR2(60 CHAR) 
INTL                      VARCHAR2(1 CHAR)  
STATUS                    NUMBER(4)         
CREATED_BY                VARCHAR2(40 CHAR) 
CREATED_ON                DATE              
LAST_MODIFIED_BY          VARCHAR2(40 CHAR) 
LAST_MODIFIED_ON          DATE              
REVISION         NOT NULL NUMBER(4)         
DATE_IMPORTED             DATE      
 
 
 
 
 