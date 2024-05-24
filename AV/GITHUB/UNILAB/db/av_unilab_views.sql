--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View AV_DBA_MONITOR_LOG_SWITCHES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_DBA_MONITOR_LOG_SWITCHES" ("DAY", "00", "01", "02", "03", "04", "05", "06", "07", "0", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23") AS 
  SELECT "DAY","00","01","02","03","04","05","06","07","0","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23" FROM SYS.AV_DBA_MONITOR_LOG_SWITCHES
;
--------------------------------------------------------
--  DDL for View AV_ITSHQ_INTERSPEC_MOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_ITSHQ_INTERSPEC_MOP" ("USER_ID", "PART_NO", "REVISION", "STATUS_TO", "TEXT", "USER_INTL", "WORKFLOW_GROUP_ID", "ACCESS_GROUP", "VIEW_ID", "FRAME_NO", "FRAME_OWNER", "NEW_VALUE_CHAR", "NEW_VALUE_NUM", "NEW_VALUE_DATE", "ES_SEQ_NO", "PLANT", "ALTERNATIVE", "SELECTED") AS 
  select "USER_ID","PART_NO","REVISION","STATUS_TO","TEXT","USER_INTL","WORKFLOW_GROUP_ID","ACCESS_GROUP","VIEW_ID","FRAME_NO","FRAME_OWNER","NEW_VALUE_CHAR","NEW_VALUE_NUM","NEW_VALUE_DATE","ES_SEQ_NO","PLANT","ALTERNATIVE","SELECTED"
from   itshq@interspec ;
--------------------------------------------------------
--  DDL for View AV_MT_CLASS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_MT_CLASS" ("MT_CLASS", "MT", "VERSION") AS 
  select
    A.value AS mt_class
,    M.mt
,    M.version
from uvmtau A
join uvmt M on (M.mt = A.mt)
where A.au = 'avReportMeClass'
group by
    A.value
,    M.mt
,    M.version;
--------------------------------------------------------
--  DDL for View AV_MT_DIMENSION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_MT_DIMENSION" ("MT", "VERSION", "MT_CLASS", "MT_DIMENSION") AS 
  select
    Mc.mt, Mc.version
,    Ac.value as mt_class
,    Ad.value as mt_dimension
from uvmt Mc
join uvmtau Ac on (Ac.mt = Mc.mt and Ac.au = 'avReportMeClass')
join uvmtau Ad on (Ad.mt = Mc.mt and Ad.au = 'avReportCell3rdDim')
group by Mc.mt, Mc.version, Ac.value, Ad.value
order by Mc.mt;
--------------------------------------------------------
--  DDL for View AV_MVI_UTMTAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_MVI_UTMTAU" ("MT", "VERSION", "AU", "VALUE") AS 
  select MT,VERSION,AU,VALUE from UTMTAU 
WHERE au = 'avIsoCode'
 ;
--------------------------------------------------------
--  DDL for View AV_SC_PART_REV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_SC_PART_REV" ("SC", "ST", "ST_VERSION", "VERSION_IS_CURRENT", "UVSC_ST_VERSION") AS 
  SELECT
			sc,
			st1.st,
			GREATEST(st1.version, utsc.st_version) AS st_version,
			st1.version_is_current,
			utsc.st_version AS uvsc_st_version
		  FROM utsc
		 INNER JOIN av_st_corrected st1 ON (
				utsc.st = st1.st
			AND utsc.creation_date >= st1.effective_from
			AND	(st1.corrected_effective_till IS NULL OR utsc.creation_date <= st1.corrected_effective_till)
		 )
 ;
--------------------------------------------------------
--  DDL for View AV_SCPATESTMETHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_SCPATESTMETHOD" ("SC", "PG", "PGNODE", "PA", "PANODE", "PA_SS", "PA_TESTMETHOD", "PA_TESTMETHODDESCR", "PR_TESTMETHOD") AS 
  SELECT
  A.SC,         
  A.PG,            
  A.PGNODE,
  A.PA,           
  A.PANODE,
  A.SS AS PA_SS,
  (select value from utscpaau b where b.sc=a.sc and b.pg=a.pg and B.PGNODE=a.pgnode and B.PA = a.pa and B.PANODE=a.panode and B.AU='avTestMethod') PA_TestMethod,
  (select value from utscpaau c where c.sc=a.sc and c.pg=a.pg and c.PGNODE=a.pgnode and c.PA = a.pa and c.PANODE=a.panode and c.AU='avTestMethodDesc') PA_TestMethodDescr,
  (select value from utprau d where d.Pr = a.pa and d.version=a.pr_version and d.AU='avTestMethod') PR_TestMethod
  
FROM
  UTSCPA a
 ;
--------------------------------------------------------
--  DDL for View AV_SPEED_LOAD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_SPEED_LOAD" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "INDEX_Y", "TEST_TIME", "DELTA_V", "SPEED", "LOAD_PERCENTAGE", "LOAD", "CONTROL", "P_INFL_PERCENTAGE", "P_INFL") AS 
  SELECT me.SC,
          me.PG,
          me.PGNODE,
          me.PA,
          me.PANODE,
          me.ME,
          me.MENODE,
          test_time.INDEX_Y,
          test_time.VALUE_S AS TEST_TIME,
          delta_v.VALUE_S AS DELTA_V,
          DECODE(Abs_v.VALUE_F, NULL, (delta_v.VALUE_F + v_basis.VALUE_F), Abs_v.VALUE_F) AS SPEED,
          load_percentage.VALUE_F AS LOAD_PERCENTAGE,
          DECODE(ABS_load.VALUE_F, NULL, (load_percentage.VALUE_F * load_basis.VALUE_F / 100), Abs_load.VALUE_F) AS LOAD,
          control.VALUE_S AS CONTROL,
          p_infl_percentage.VALUE_F AS P_INFL_PERCENTAGE,
          (p_infl_percentage.VALUE_F * p_infl_basis.VALUE_F / 100) AS p_infl
     FROM UVSCME me
          LEFT JOIN UVSCMECELL v_basis
             ON (    v_basis.SC = me.SC
                 AND v_basis.PG = me.PG
                 AND v_basis.PGNODE = me.PGNODE
                 AND v_basis.PA = me.PA
                 AND v_basis.PANODE = me.PANODE
                 AND v_basis.ME = me.ME
                 AND v_basis.MENODE = me.MENODE
                 AND v_basis.CELL = 'v_basis')
          LEFT JOIN UVSCMECELL load_basis
             ON (    load_basis.SC = me.SC
                 AND load_basis.PG = me.PG
                 AND load_basis.PGNODE = me.PGNODE
                 AND load_basis.PA = me.PA
                 AND load_basis.PANODE = me.PANODE
                 AND load_basis.ME = me.ME
                 AND load_basis.MENODE = me.MENODE
                 AND load_basis.CELL = 'load_basis')
          LEFT JOIN UVSCMECELL max_defl
             ON (    max_defl.SC = me.SC
                 AND max_defl.PG = me.PG
                 AND max_defl.PGNODE = me.PGNODE
                 AND max_defl.PA = me.PA
                 AND max_defl.PANODE = me.PANODE
                 AND max_defl.ME = me.ME
                 AND max_defl.MENODE = me.MENODE
                 AND max_defl.CELL = 'max_defl')        
          LEFT JOIN UVSCMECELL p_infl_basis
             ON (    p_infl_basis.SC = me.SC
                 AND p_infl_basis.PG = me.PG
                 AND p_infl_basis.PGNODE = me.PGNODE
                 AND p_infl_basis.PA = me.PA
                 AND p_infl_basis.PANODE = me.PANODE
                 AND p_infl_basis.ME = me.ME
                 AND p_infl_basis.MENODE = me.MENODE
                 AND p_infl_basis.CELL = 'p_infl')
          INNER JOIN UVSCMECELLLIST test_time
             ON (    test_time.SC = me.SC
                 AND test_time.PG = me.PG
                 AND test_time.PGNODE = me.PGNODE
                 AND test_time.PA = me.PA
                 AND test_time.PANODE = me.PANODE
                 AND test_time.ME = me.ME
                 AND test_time.MENODE = me.MENODE
                 AND test_time.INDEX_X = 0
                 AND test_time.CELL = 'avIndoorTyreTest')
          INNER JOIN UVSCMECELLLIST delta_v
             ON (    test_time.SC = delta_v.SC
                 AND test_time.PG = delta_v.PG
                 AND test_time.PGNODE = delta_v.PGNODE
                 AND test_time.PA = delta_v.PA
                 AND test_time.PANODE = delta_v.PANODE
                 AND test_time.ME = delta_v.ME
                 AND test_time.MENODE = delta_v.MENODE
                 AND test_time.CELL = delta_v.CELL
                 AND test_time.INDEX_Y = delta_v.INDEX_Y
                 AND delta_v.INDEX_X = 1)
          INNER JOIN UVSCMECELLLIST load_percentage
             ON (    test_time.SC = load_percentage.SC
                 AND test_time.PG = load_percentage.PG
                 AND test_time.PGNODE = load_percentage.PGNODE
                 AND test_time.PA = load_percentage.PA
                 AND test_time.PANODE = load_percentage.PANODE
                 AND test_time.ME = load_percentage.ME
                 AND test_time.MENODE = load_percentage.MENODE
                 AND test_time.CELL = load_percentage.CELL
                 AND test_time.INDEX_Y = load_percentage.INDEX_Y
                 AND load_percentage.INDEX_X = 2)
          LEFT JOIN UVSCMECELLLIST control
             ON (    test_time.SC = control.SC
                 AND test_time.PG = control.PG
                 AND test_time.PGNODE = control.PGNODE
                 AND test_time.PA = control.PA
                 AND test_time.PANODE = control.PANODE
                 AND test_time.ME = control.ME
                 AND test_time.MENODE = control.MENODE
                 AND test_time.CELL = control.CELL
                 AND test_time.INDEX_Y = control.INDEX_Y
                 AND control.INDEX_X = 3)
          LEFT JOIN UVSCMECELLLIST p_infl_percentage
             ON (    test_time.SC = p_infl_percentage.SC
                 AND test_time.PG = p_infl_percentage.PG
                 AND test_time.PGNODE = p_infl_percentage.PGNODE
                 AND test_time.PA = p_infl_percentage.PA
                 AND test_time.PANODE = p_infl_percentage.PANODE
                 AND test_time.ME = p_infl_percentage.ME
                 AND test_time.MENODE = p_infl_percentage.MENODE
                 AND test_time.CELL = p_infl_percentage.CELL
                 AND test_time.INDEX_Y = p_infl_percentage.INDEX_Y
                 AND p_infl_percentage.INDEX_X = 4)
          LEFT JOIN UVSCMECELLLIST Abs_v
             ON (    test_time.SC = Abs_v.SC
                 AND test_time.PG = Abs_v.PG
                 AND test_time.PGNODE = Abs_v.PGNODE
                 AND test_time.PA = Abs_v.PA
                 AND test_time.PANODE = Abs_v.PANODE
                 AND test_time.ME = Abs_v.ME
                 AND test_time.MENODE = Abs_v.MENODE
                 AND test_time.CELL = Abs_v.CELL
                 AND test_time.INDEX_Y = Abs_v.INDEX_Y
                 AND Abs_v.INDEX_X = 5)
          LEFT JOIN UVSCMECELLLIST Abs_load
             ON (    test_time.SC = Abs_load.SC
                 AND test_time.PG = Abs_load.PG
                 AND test_time.PGNODE = Abs_load.PGNODE
                 AND test_time.PA = Abs_load.PA
                 AND test_time.PANODE = Abs_load.PANODE
                 AND test_time.ME = Abs_load.ME
                 AND test_time.MENODE = Abs_load.MENODE
                 AND test_time.CELL = Abs_load.CELL
                 AND test_time.INDEX_Y = Abs_load.INDEX_Y
                 AND Abs_load.INDEX_X = 6)                                                   
        WHERE me.ss <> '@C';
--------------------------------------------------------
--  DDL for View AV_ST_CORRECTED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_ST_CORRECTED" ("ST", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "CORRECTED_EFFECTIVE_TILL", "DESCRIPTION", "SHELF_LIFE_VAL", "SHELF_LIFE_UNIT", "FREQ_TP", "FREQ_VAL", "FREQ_UNIT", "PRIORITY", "LC", "LC_VERSION", "SS") AS 
  SELECT st, version, version_is_current, effective_from, effective_till,
		CASE
			WHEN version_is_current = '1' THEN NULL
			ELSE LAG(effective_from, 1) OVER (PARTITION BY st ORDER BY effective_from DESC)
		END AS corrected_effective_till,
		description, shelf_life_val, shelf_life_unit, freq_tp, freq_val, freq_unit, priority, lc, lc_version, ss
	  FROM utst
 ;
--------------------------------------------------------
--  DDL for View AV_TESTMETHODS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_TESTMETHODS" ("AVTESTMETHOD", "AVTESTMETHODDESC") AS 
  select pav.value avtestmethod
,      pad.value avtestmethoddesc
from   uvpr par
,      uvprau pav
,      uvprau pad
where  par.version_is_current = '1'
and    pav.au = 'avTestMethod'
and    pav.pr = par.pr
and    pav.version = par.version
and    pav.value is not null
and    pad.au = 'avTestMethodDesc'
and    pad.pr = par.pr
and    pad.version = par.version ;
--------------------------------------------------------
--  DDL for View AV_USER_PROFILES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AV_USER_PROFILES" ("US", "PERSON", "EMAIL", "DEFAULT_PROFILE", "UP", "USER_PROFILE", "LAB") AS 
  select
distinct upf.us
,        usr.person
,        usr.email
,        usr.def_up default_profile
,        upf.up
,        prf.description user_profile
,        utupuspref.pref_value lab
from     utup prf
,        utupus upf
,        utad usr
,        utupuspref
where    prf.up = upf.up
and      usr.ad = upf.us
and      utupuspref.us(+) = upf.us
and      utupuspref.up(+) = upf.up
--and      utupuspref.pref_name(+) = 'lab';
--------------------------------------------------------
--  DDL for View AVAO_FREQ_UABASED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_FREQ_UABASED" ("ST", "ST_VERSION", "STAU", "PR", "PR_VERSION", "MT", "MT_VERSION", "MT_DESCRIPTION", "MTAU", "ST_VALUE", "OPERATOR", "MT_VALUE", "SORT") AS 
  SELECT   a.st, a.VERSION st_version, a.au stau, e.pr, e.version pr_version, c.mt, c.version mt_version,
            c.description mt_description, b.au mtau, a.VALUE st_value,
            CASE
               WHEN INSTR (b.VALUE, '<>') > 0
                  THEN '<>'
               WHEN INSTR (b.VALUE, '>=') > 0
                  THEN '>='
               WHEN INSTR (b.VALUE, '<=') > 0
                  THEN '<='
               WHEN INSTR (b.VALUE, '>') > 0
                  THEN '>'
               WHEN INSTR (b.VALUE, '<') > 0
                  THEN '<'
               ELSE '='
            END OPERATOR,
            CASE
               WHEN INSTR (b.VALUE, '<>') > 0
                  THEN SUBSTR (b.VALUE, INSTR (b.VALUE, '<>') + 2)
               WHEN INSTR (b.VALUE, '>=') > 0
                  THEN SUBSTR (b.VALUE, INSTR (b.VALUE, '>=') + 2)
               WHEN INSTR (b.VALUE, '<=') > 0
                  THEN SUBSTR (b.VALUE, INSTR (b.VALUE, '<=') + 2)
               WHEN INSTR (b.VALUE, '>') > 0
                  THEN SUBSTR (b.VALUE, INSTR (b.VALUE, '>') + 1)
               WHEN INSTR (b.VALUE, '<') > 0
                  THEN SUBSTR (b.VALUE, INSTR (b.VALUE, '<') + 1)
               ELSE b.VALUE
            END mt_value,
            CASE
               WHEN INSTR (b.VALUE, '<>') > 0
                  THEN '1'
               WHEN INSTR (b.VALUE, '>=') > 0
                  THEN '0'
               WHEN INSTR (b.VALUE, '<=') > 0
                  THEN '0'
               WHEN INSTR (b.VALUE, '>') > 0
                  THEN '0'
               WHEN INSTR (b.VALUE, '<') > 0
                  THEN '0'
               ELSE '1'
            END sort
       FROM utstau a, utprmtau b, utmt c, utau d, utpr e, utst f
      WHERE b.mt = c.mt
        AND c.version_is_current = '1'
        AND b.pr = e.pr
        AND b.VERSION = e.VERSION
        AND e.version_is_current = '1'
        AND a.st = f.st
        AND a.VERSION = f.VERSION
        AND f.version_is_current = '1'
        AND a.au = b.au
        AND b.au = d.au
        AND d.version_is_current = '1'
        AND d.service = 'UAbased'
   ORDER BY a.st, b.mt, sort 
 ;
--------------------------------------------------------
--  DDL for View AVAO_FREQ_UABASED_SC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_FREQ_UABASED_SC" ("SC", "ST_VERSION", "SCAU", "PR", "PR_VERSION", "MT", "MT_VERSION", "MT_DESCRIPTION", "MTAU", "SC_VALUE", "OPERATOR", "MT_VALUE", "SORT") AS 
  SELECT a.sc,
            g.st_version,
            a.au stau,
            e.pr,
            e.VERSION pr_version,
            c.mt,
            c.VERSION mt_version,
            c.description mt_description,
            b.au mtau,
            a.VALUE sc_value,
            CASE
               WHEN INSTR (b.VALUE, '<>') > 0 THEN '<>'
               WHEN INSTR (b.VALUE, '>=') > 0 THEN '>='
               WHEN INSTR (b.VALUE, '<=') > 0 THEN '<='
               WHEN INSTR (b.VALUE, '>') > 0 THEN '>'
               WHEN INSTR (b.VALUE, '<') > 0 THEN '<'
               ELSE '='
            END
               OPERATOR,
            CASE
               WHEN INSTR (b.VALUE, '<>') > 0
               THEN
                  SUBSTR (b.VALUE, INSTR (b.VALUE, '<>') + 2)
               WHEN INSTR (b.VALUE, '>=') > 0
               THEN
                  SUBSTR (b.VALUE, INSTR (b.VALUE, '>=') + 2)
               WHEN INSTR (b.VALUE, '<=') > 0
               THEN
                  SUBSTR (b.VALUE, INSTR (b.VALUE, '<=') + 2)
               WHEN INSTR (b.VALUE, '>') > 0
               THEN
                  SUBSTR (b.VALUE, INSTR (b.VALUE, '>') + 1)
               WHEN INSTR (b.VALUE, '<') > 0
               THEN
                  SUBSTR (b.VALUE, INSTR (b.VALUE, '<') + 1)
               ELSE
                  b.VALUE
            END
               mt_value,
            CASE
               WHEN INSTR (b.VALUE, '<>') > 0 THEN '1'
               WHEN INSTR (b.VALUE, '>=') > 0 THEN '0'
               WHEN INSTR (b.VALUE, '<=') > 0 THEN '0'
               WHEN INSTR (b.VALUE, '>') > 0 THEN '0'
               WHEN INSTR (b.VALUE, '<') > 0 THEN '0'
               ELSE '1'
            END
               sort
       FROM utscau a,
            utprmtau b,
            utmt c,
            utau d,
            utpr e,
            utst f,
            utsc g
      WHERE     b.mt = c.mt
            AND c.version_is_current = '1'
            AND b.pr = e.pr
            AND b.VERSION = e.VERSION
            AND e.version_is_current = '1'
            AND g.st = f.st
            AND g.st_VERSION = f.VERSION
            AND a.au = b.au
            AND b.au = d.au
            AND d.version_is_current = '1'
            AND d.service = 'UAbased'
            AND a.sc = g.sc
   ORDER BY a.sc, b.mt, sort;
--------------------------------------------------------
--  DDL for View AVAO_INTERSPEC_PPPR_FREQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_INTERSPEC_PPPR_FREQ" ("PART_NO", "REVISION", "SECTION", "PROPERTYGROUP", "PROPERTY", "HEADER", "LIMSHEADER", "VALUE", "TEST_METHOD") AS 
  SELECT a.part_no, a.revision, b1.description section,
          b2.description propertygroup, b3.description property,
          d2.description header, d3.description limsheader, a.value_s VALUE,
          g.description test_method
     FROM specdata@interspec a,
          section@interspec b1,
          property_group@interspec b2,
          property_group_h@interspec b4, 
          itlang@interspec b5,
          property@interspec b3,
          header@interspec d2,
          header_h@interspec d3,
          itlang@interspec e,
          itlang@interspec f,
          test_method@interspec g
    WHERE a.section_id = b1.section_id
      AND a.property_group = b2.property_group
      AND a.property_group = b4.property_group
      AND b4.lang_id = b5.lang_id
      AND b4.description = 'PPPR-frequency'
      AND b5.description = 'LIMS'
      AND a.property = b3.property
      AND a.header_id = d2.header_id
      AND d2.header_id = d3.header_id
      AND d3.lang_id = e.lang_id
      AND d3.max_rev = 1
      AND e.description = 'English'
      AND g.test_method = a.test_method
   UNION
   SELECT a.part_no, a.revision, b1.description section,
          b2.description propertygroup, b3.description property,
          d2.description header, d3.description limsheader, a.value_s VALUE,
          g.description test_method
     FROM specdata@interspec a,
          section@interspec b1,
          property_group@interspec b2,
          property_group_h@interspec b4, 
          itlang@interspec b5,
          property@interspec b3,
          header@interspec d2,
          header_h@interspec d3,
          itlang@interspec e,
          itlang@interspec f,
          test_method@interspec g
    WHERE a.section_id = b1.section_id
      AND a.property_group = b2.property_group
      AND a.property_group = b4.property_group
      AND b4.lang_id = b5.lang_id
      AND b4.description = 'PPPR-frequency'
      AND b5.description = 'LIMS'
      AND a.property = b3.property
      AND a.header_id = d2.header_id
      AND d2.header_id = d3.header_id
      AND d3.lang_id = e.lang_id
      AND d3.max_rev = 1
      AND e.description = 'LIMS'
      AND g.test_method = a.test_method 
 ;
--------------------------------------------------------
--  DDL for View AVAO_INTERSPEC_STPP_FREQ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_INTERSPEC_STPP_FREQ" ("PART_NO", "REVISION", "SECTION", "PROPERTYGROUP", "PROPERTY", "LIMSPROPERTY", "HEADER", "LIMSHEADER", "VALUE") AS 
  (SELECT a.part_no, a.revision, b1.description section,
           b2.description propertygroup, b3.description property,
           b4.description limsproperty, d2.description header,
           d3.description limsheader, a.value_s VALUE
      FROM specdata@interspec a,
           section@interspec b1,
           property_group@interspec b2,
           property_group_h@interspec b5, 
           itlang@interspec b6,
           property@interspec b3,
           property_h@interspec b4,
           header@interspec d2,
           header_h@interspec d3,
           itlang@interspec e,
           itlang@interspec f
     WHERE a.header_id = d2.header_id
       AND d2.header_id = d3.header_id
       AND d3.lang_id = e.lang_id
       AND d3.max_rev = 1
       AND e.description = 'English'
       AND a.section_id = b1.section_id
       AND a.property_group = b2.property_group
       AND a.property_group = b5.property_group
       AND b5.lang_id = b6.lang_id
       AND b5.description = 'STPP-frequency'
       AND b6.description = 'LIMS'
       AND a.property = b3.property
       AND b3.property = b4.property
       AND b4.max_rev = 1
       AND b4.lang_id = f.lang_id
       AND f.description = 'English'
    UNION
    SELECT a.part_no, a.revision, b1.description section,
           b2.description propertygroup, b3.description property,
           b4.description limsproperty, d2.description header,
           d3.description limsheader, a.value_s VALUE
      FROM specdata@interspec a,
           section@interspec b1,
           property_group@interspec b2,
           property_group_h@interspec b5, 
           itlang@interspec b6,
           property@interspec b3,
           property_h@interspec b4,
           header@interspec d2,
           header_h@interspec d3,
           itlang@interspec e,
           itlang@interspec f
     WHERE a.header_id = d2.header_id
       AND d2.header_id = d3.header_id
       AND d3.lang_id = e.lang_id
       AND d3.max_rev = 1
       AND e.description = 'LIMS'
       AND a.section_id = b1.section_id
       AND a.property_group = b2.property_group
       AND a.property_group = b5.property_group
       AND b5.lang_id = b6.lang_id
       AND b5.description = 'STPP-frequency'
       AND b6.description = 'LIMS'
       AND a.property = b3.property
       AND b3.property = b4.property
       AND b4.max_rev = 1
       AND b4.lang_id = f.lang_id
       AND f.description = 'LIMS') 
 ;
--------------------------------------------------------
--  DDL for View AVAO_IS2SCAU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_IS2SCAU" ("PART_NO", "REVISION", "SECTION", "PROP_GROUP", "DISPLAY_FORMAT", "PROPERTY", "HEADER", "AU", "VALUE") AS 
  SELECT a.part_no,
          a.revision,
          b1.description section,
          b2.description prop_group,
          c2.description display_format,
          b3.description property,
          d2.description header,
          SUBSTR (b3.description || d2.description, 1, 20) au,
          --c3.is_col,
          CASE
             WHEN c3.is_col = 'char_1' THEN a.char_1
             WHEN c3.is_col = 'char_2' THEN a.char_2
             WHEN c3.is_col = 'char_3' THEN a.char_3
             WHEN c3.is_col = 'char_4' THEN a.char_4
             WHEN c3.is_col = 'char_5' THEN a.char_5
             WHEN c3.is_col = 'char_6' THEN a.char_6
             --WHEN c3.is_col = 'num_1' THEN TO_CHAR(a.num_1)
             WHEN c3.is_col = 'num_1' THEN trim(to_char(a.num_1, replace(translate(abs(a.num_1), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_2' THEN trim(to_char(a.num_2, replace(translate(abs(a.num_2), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_3' THEN trim(to_char(a.num_3, replace(translate(abs(a.num_3), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_4' THEN trim(to_char(a.num_4, replace(translate(abs(a.num_4), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_5' THEN trim(to_char(a.num_5, replace(translate(abs(a.num_5), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_6' THEN trim(to_char(a.num_6, replace(translate(abs(a.num_6), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_7' THEN trim(to_char(a.num_7, replace(translate(abs(a.num_7), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_8' THEN trim(to_char(a.num_8, replace(translate(abs(a.num_8), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_9' THEN trim(to_char(a.num_9, replace(translate(abs(a.num_9), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_10' THEN trim(to_char(a.num_10, replace(translate(abs(a.num_10), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'boolean_1' THEN TO_CHAR (a.boolean_1)
             WHEN c3.is_col = 'boolean_2' THEN TO_CHAR (a.boolean_2)
             WHEN c3.is_col = 'boolean_3' THEN TO_CHAR (a.boolean_3)
             WHEN c3.is_col = 'boolean_4' THEN TO_CHAR (a.boolean_4)
             ELSE b4.description
          END
             VALUE
     FROM specification_prop@interspec a,
          section@interspec b1,
          property_group@interspec b2,
          property_h@interspec b3,
          characteristic@interspec b4,
          property_group_display@interspec c1,
          layout@interspec c2,
          itlimsconfly@interspec c3,
          property_layout@interspec d1,
          header@interspec d2,
          ITLANG@interspec e
    WHERE c3.is_col =
                 DECODE (d1.FIELD_ID,
                         1, 'num_1',
                         2, 'num_2',
                         3, 'num_3',
                         4, 'num_4',
                         5, 'num_5',
                         6, 'num_6',
                         7, 'num_7',
                         8, 'num_8',
                         9, 'num_9',
                         10, 'num_10',
                         11, 'char_1',
                         12, 'char_2',
                         13, 'char_3',
                         14, 'char_4',
                         15, 'char_5',
                         16, 'char_6',
                         17, 'boolean_1',
                         18, 'boolean_2',
                         19, 'boolean_3',
                         20, 'boolean_4',
                         21, 'date_1',
                         22, 'date_2',
                         26, 'CHARACTERISTIC',
                         30, 'CH_2',
                         31, 'CH_3',
                         23, 'UOM_ID',
                         41, 'test_method',
                         32, 'tm_det_1',
                         33, 'tm_det_1',
                         34, 'tm_det_1',
                         35, 'tm_det_1')
          AND a.section_id = b1.section_id
          AND a.property_group = b2.property_group
          AND c1.property_group = a.property_group
          AND c1.display_format = c2.layout_id
          AND c2.status = 2
          AND c2.layout_id = c3.layout_id
          AND c2.revision = c3.layout_rev
          AND a.property = b3.property
          AND b4.characteristic_id(+) = a.characteristic
          AND d1.header_id = d2.header_id
          AND d1.layout_id = c2.layout_id
          AND c3.un_object = 'ST'
          AND c3.un_type = 'AU'
          AND b3.lang_id = e.lang_id
          AND e.description = 'LIMS'
          AND b3.max_rev = 1
   UNION
   SELECT a.part_no,
          a.revision,
          b1.description section,
          b2.description prop_group,
          c2.description display_format,
          b3.description property,
          d2.description header,
          SUBSTR (b3.description || d2.description, 1, 20) au,
          --c3.is_col,
          CASE
             WHEN c3.is_col = 'char_1' THEN a.char_1
             WHEN c3.is_col = 'char_2' THEN a.char_2
             WHEN c3.is_col = 'char_3' THEN a.char_3
             WHEN c3.is_col = 'char_4' THEN a.char_4
             WHEN c3.is_col = 'char_5' THEN a.char_5
             WHEN c3.is_col = 'char_6' THEN a.char_6
             --WHEN c3.is_col = 'num_1' THEN TO_CHAR(a.num_1)
             WHEN c3.is_col = 'num_1' THEN trim(to_char(a.num_1, replace(translate(abs(a.num_1), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_2' THEN trim(to_char(a.num_2, replace(translate(abs(a.num_2), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_3' THEN trim(to_char(a.num_3, replace(translate(abs(a.num_3), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_4' THEN trim(to_char(a.num_4, replace(translate(abs(a.num_4), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_5' THEN trim(to_char(a.num_5, replace(translate(abs(a.num_5), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_6' THEN trim(to_char(a.num_6, replace(translate(abs(a.num_6), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_7' THEN trim(to_char(a.num_7, replace(translate(abs(a.num_7), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_8' THEN trim(to_char(a.num_8, replace(translate(abs(a.num_8), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_9' THEN trim(to_char(a.num_9, replace(translate(abs(a.num_9), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'num_10' THEN trim(to_char(a.num_10, replace(translate(abs(a.num_10), '012345678,.', '999999999DD'), 'D', '0D'), 'nls_numeric_characters=.,'))
             WHEN c3.is_col = 'boolean_1' THEN TO_CHAR (a.boolean_1)
             WHEN c3.is_col = 'boolean_2' THEN TO_CHAR (a.boolean_2)
             WHEN c3.is_col = 'boolean_3' THEN TO_CHAR (a.boolean_3)
             WHEN c3.is_col = 'boolean_4' THEN TO_CHAR (a.boolean_4)
             ELSE b4.description
          END
             VALUE
     FROM specification_prop@interspec a,
          section@interspec b1,
          property_group@interspec b2,
          property@interspec b3,
          characteristic@interspec b4,
          property_group_display@interspec c1,
          layout@interspec c2,
          itlimsconfly@interspec c3,
          property_layout@interspec d1,
          header@interspec d2
    WHERE c3.is_col =
                 DECODE (d1.FIELD_ID,
                         1, 'num_1',
                         2, 'num_2',
                         3, 'num_3',
                         4, 'num_4',
                         5, 'num_5',
                         6, 'num_6',
                         7, 'num_7',
                         8, 'num_8',
                         9, 'num_9',
                         10, 'num_10',
                         11, 'char_1',
                         12, 'char_2',
                         13, 'char_3',
                         14, 'char_4',
                         15, 'char_5',
                         16, 'char_6',
                         17, 'boolean_1',
                         18, 'boolean_2',
                         19, 'boolean_3',
                         20, 'boolean_4',
                         21, 'date_1',
                         22, 'date_2',
                         26, 'CHARACTERISTIC',
                         30, 'CH_2',
                         31, 'CH_3',
                         23, 'UOM_ID',
                         41, 'test_method',
                         32, 'tm_det_1',
                         33, 'tm_det_1',
                         34, 'tm_det_1',
                         35, 'tm_det_1')
          AND a.section_id = b1.section_id
          AND a.property_group = b2.property_group
          AND c1.property_group = a.property_group
          AND c1.display_format = c2.layout_id
          AND c2.status = 2
          AND c2.layout_id = c3.layout_id
          AND c2.revision = c3.layout_rev
          AND a.property = b3.property
          AND b4.characteristic_id(+) = a.characteristic
          AND d1.header_id = d2.header_id
          AND d1.layout_id = c2.layout_id
          AND c3.un_object = 'ST'
          AND c3.un_type = 'AU'
          AND b3.property NOT IN
                 (SELECT a.property
                    FROM property_h@interspec a, ITLANG@interspec e
                   WHERE     a.max_rev = 1
                         AND a.lang_id = e.lang_id
                         AND e.description = 'LIMS')
   ORDER BY (6);
--------------------------------------------------------
--  DDL for View AVAO_IS2SCGK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_IS2SCGK" ("PART_NO", "GK", "GKVALUE") AS 
  SELECT a.part_no, REPLACE(b.description, ' ', '_') gk, a.kw_value gkvalue
  FROM specification_kw@interspec a, itkw@interspec b
 WHERE 1 = 0  /* temporarily switched off */ 
   AND a.kw_id = b.kw_id
   AND REPLACE(b.description, ' ', '_') IN (SELECT gk FROM utgksc WHERE version_is_current = 1) 
 ;
--------------------------------------------------------
--  DDL for View AVAO_SC_SPECIFICATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SC_SPECIFICATION" ("SC", "SPECIFICATION", "DESCRIPTION") AS 
  select a.sc, a.part_no || ' [' || a.revision || ']' specification, b.description 
  from AVAO_SPECIFICATION a, AVAO_SPEC_DESC b
 where a.part_no = b.part_no
   and a.revision = b.revision 
 ;
--------------------------------------------------------
--  DDL for View AVAO_SC_XML
--------------------------------------------------------

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
--------------------------------------------------------
--  DDL for View AVAO_SCMECELLS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SCMECELLS" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "CELL", "VALUE_F", "VALUE_S", "LOGDATE") AS 
  SELECT   a.sc, a.pg, a.pgnode, a.pa, a.panode, a.me, a.menode,
            apaogen.strtok (b.details, '"', 2) cell,
            apaogen.strtok (c.details, '"', 6) value_f,
            apaogen.strtok (b.details, '"', 6) value_s, logdate
       FROM utscmehs a, utscmehsdetails b, utscmehsdetails c
      WHERE a.sc = b.sc
        AND a.pg = b.pg
        AND a.pgnode = b.pgnode
        AND a.pa = b.pa
        AND a.panode = b.panode
        AND a.me = b.me
        AND a.menode = b.menode
        AND a.sc = c.sc
        AND a.pg = c.pg
        AND a.pgnode = c.pgnode
        AND a.pa = c.pa
        AND a.panode = c.panode
        AND a.me = c.me
        AND a.menode = c.menode
        AND a.what = 'MeDetailsUpdated'
        AND a.tr_seq = b.tr_seq
        AND a.tr_seq = c.tr_seq
        AND apaogen.strtok (c.details, '"', 2) =
                                            apaogen.strtok (b.details, '"', 2)
        AND c.details LIKE 'method cell%<value_f%'
        AND b.details LIKE 'method cell%<value_s%'
   UNION
   SELECT   a.sc, a.pg, a.pgnode, a.pa, a.panode, a.me, a.menode,
            apaogen.strtok (b.details, '"', 2) cell, NULL value_f,
            apaogen.strtok (b.details, '"', 6) value_s, logdate
       FROM utscmehs a, utscmehsdetails b
      WHERE a.sc = b.sc
        AND a.pg = b.pg
        AND a.pgnode = b.pgnode
        AND a.pa = b.pa
        AND a.panode = b.panode
        AND a.me = b.me
        AND a.menode = b.menode
        AND a.what = 'MeDetailsUpdated'
        AND a.tr_seq = b.tr_seq
        AND b.details LIKE 'method cell%<value_s%'
   ORDER BY logdate ASC 
 ;
--------------------------------------------------------
--  DDL for View AVAO_SCMECELLS_NEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SCMECELLS_NEW" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "CELL", "VALUE_F", "VALUE_S", "LOGDATE") AS 
  SELECT   a.sc, a.pg, a.pgnode, a.pa, a.panode, a.me, a.menode,
            substr(substr(b.details, 1, instr(b.details, '"', 1, 2) - 1), instr(b.details, '"') + 1) cell,
            substr(substr(c.details, 1, instr(c.details, '"', 1, 6) - 1), instr(c.details, '"', 1, 5) + 1) value_f,
            substr(substr(b.details, 1, instr(b.details, '"', 1, 6) - 1), instr(b.details, '"', 1, 5) + 1) value_s, logdate
       FROM utscmehs a, utscmehsdetails b, utscmehsdetails c
      WHERE a.sc = b.sc
        AND a.pg = b.pg
        AND a.pgnode = b.pgnode
        AND a.pa = b.pa
        AND a.panode = b.panode
        AND a.me = b.me
        AND a.menode = b.menode
        AND a.sc = c.sc
        AND a.pg = c.pg
        AND a.pgnode = c.pgnode
        AND a.pa = c.pa
        AND a.panode = c.panode
        AND a.me = c.me
        AND a.menode = c.menode
        AND a.what = 'MeDetailsUpdated'
        AND a.tr_seq = b.tr_seq
        AND a.tr_seq = c.tr_seq
        and substr(substr(c.details, 1, instr(c.details, '"', 1, 2) - 1), instr(c.details, '"') + 1) =
            substr(substr(b.details, 1, instr(b.details, '"', 1, 2) - 1), instr(b.details, '"') + 1)
        AND c.details LIKE 'method cell%<value_f%'
        AND b.details LIKE 'method cell%<value_s%'
   UNION
   SELECT   a.sc, a.pg, a.pgnode, a.pa, a.panode, a.me, a.menode,
            substr(substr(b.details, 1, instr(b.details, '"', 1, 2) - 1), instr(b.details, '"') + 1) cell, NULL value_f,
            substr(substr(b.details, 1, instr(b.details, '"', 1, 6) - 1), instr(b.details, '"', 1, 5) + 1) value_s, logdate
       FROM utscmehs a, utscmehsdetails b
      WHERE a.sc = b.sc
        AND a.pg = b.pg
        AND a.pgnode = b.pgnode
        AND a.pa = b.pa
        AND a.panode = b.panode
        AND a.me = b.me
        AND a.menode = b.menode
        AND a.what = 'MeDetailsUpdated'
        AND a.tr_seq = b.tr_seq
        AND b.details LIKE 'method cell%<value_s%'
   ORDER BY logdate ASC ;
--------------------------------------------------------
--  DDL for View AVAO_SPEC_DESC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SPEC_DESC" ("PART_NO", "DESCRIPTION", "REVISION") AS 
  select c.part_no, c.description, c.revision
  from specification_header@interspec c 
 ;
--------------------------------------------------------
--  DDL for View AVAO_SPECIFICATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_SPECIFICATION" ("PART_NO", "SC", "ST", "ST_VERSION", "REVISION") AS 
  SELECT part_no, sc, st, st_version, REVISION FROM (
select a.part_no, a.sc, b.st, b.st_version, 
       APAOACTION.ConvertUnilab2Interspec(b.st_version) REVISION
  from utscgkpart_no a, utsc b
 where a.sc = b.sc 
   and a.part_no =b.st
 UNION  
select a.part_no, a.sc, b.st, b.st_version, 
       c.revision
  from utscgkpart_no a, utsc b, specification_header@interspec c 
 where a.sc = b.sc and a.part_no !=b.st
   and a.part_no = c.part_no
   and c.status = 4) 
 ;
--------------------------------------------------------
--  DDL for View AVAO_TRIALS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_TRIALS" ("PART_NO", "REVISION", "DESCRIPTION", "PLANT", "PED", "SPEC_TYPE", "CREATED_BY", "LAST_MODIFIED_BY") AS 
  SELECT   DISTINCT a.part_no,
                       a.revision,
                       a.description,
                       NULL,                                        --b.plant,
                       a.planned_effective_date,
                       d.sort_desc spec_type,
                       a.created_by,
                       a.last_modified_by
       FROM   specification_header@interspec a,
              --part_plant@interspec b,
              status@interspec c,
              class3@interspec d,
              part@interspec e
      WHERE       a.status = c.status              --AND a.part_no = b.part_no
                --AND b.plant = apaoconstant.getconststring ('InterspecPlant')
              AND c.status_type = 'CURRENT'        --AND e.part_no = b.part_no
              AND e.part_type = d.CLASS
              AND e.part_no = a.part_no                               -- Added
   ORDER BY   a.part_no 
 ;
--------------------------------------------------------
--  DDL for View AVAO_UVSCME_LNK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_UVSCME_LNK" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "VALUE_S", "LINK") AS 
  SELECT sc, pg, pgnode, pa, panode, me, menode,
          NVL (REPLACE(text_line, '"', ''), value_s) value_s, 
          NVL (line_nbr, 0) LINK
     FROM utscme a, utlongtext b
    WHERE value_s = doc_id(+) 
 ;
--------------------------------------------------------
--  DDL for View AVAO_UVSCMECELL_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_UVSCMECELL_ALL" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "CELL", "CELLNODE", "RES_TP", "VALUE_S", "LINE_NBR") AS 
  SELECT sc, pg, pgnode, pa, panode, me, menode, cell, cellnode, SUBSTR(value_s, -3) RES_TP,
          NVL (text_line, value_s) value_s, NVL (line_nbr, 0) line_nbr
     FROM utlongtext b, utscmecell a
    WHERE value_s = doc_id
      AND obj_tp = 'mece'
    UNION
   SELECT sc, pg, pgnode, pa, panode, me, menode, cell, cellnode, 'RES' RES_TP,
          value_s, 1  line_nbr
     FROM utscmecell a
    WHERE SUBSTR(value_s, -3) NOT IN ('TXT', 'LNK') 
 ;
--------------------------------------------------------
--  DDL for View AVAO_UVSCMECELL_LNK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_UVSCMECELL_LNK" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "CELL", "CELLNODE", "VALUE_S", "LINK") AS 
  SELECT sc, pg, pgnode, pa, panode, me, menode, cell, cellnode,
          NVL (REPLACE(text_line, '"', ''), value_s) value_s, 
          NVL (line_nbr, 0) LINK
     FROM utscmecell a, utlongtext b
    WHERE value_s = doc_id(+) 
 ;
--------------------------------------------------------
--  DDL for View AVAO_UVSCPA_LNK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAO_UVSCPA_LNK" ("SC", "PG", "PGNODE", "PA", "PANODE", "VALUE_S", "LINK") AS 
  SELECT sc, pg, pgnode, pa, panode, 
   			  NVL (REPLACE(text_line, '"', ''), value_s) value_s,
          NVL (line_nbr, 0) LINK
     FROM utscpa a, utlongtext b
    WHERE value_s = doc_id(+) 
 ;
--------------------------------------------------------
--  DDL for View AVAOACTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAOACTIONS" ("LC", "DESCRIPTION", "VERSION", "SS_FROM", "SS_TO", "TR_NO", "SEQ", "AF", "ABSTRACT") AS 
  SELECT   a.lc, e.description, a.VERSION, b.NAME ss_from, c.NAME ss_to,
            a.tr_no, a.seq, a.af, d.description abstract
       FROM utlcaf a, utss b, utss c, ataoactions d, utlc e
      WHERE a.ss_from = b.ss
        AND a.ss_to = c.ss
        AND a.af = d.action
        AND a.lc = e.lc
   ORDER BY lc, ss_from, tr_no, a.seq
 ;
--------------------------------------------------------
--  DDL for View AVAOCONDITIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAOCONDITIONS" ("LC", "DESCRIPTION", "VERSION", "SS_FROM", "SS_TO", "TR_NO", "CONDITION", "ABSTRACT") AS 
  SELECT   a.lc, e.description, a.VERSION, b.NAME ss_from, c.NAME ss_to,
            a.tr_no, a.condition, d.description abstract
       FROM utlctr a, utss b, utss c, ataoconditions d, utlc e
      WHERE a.ss_from = b.ss
        AND a.ss_to = c.ss
        AND a.condition = d.condition
        AND a.lc = e.lc
   ORDER BY lc, ss_from, tr_no
 ;
--------------------------------------------------------
--  DDL for View AVAOLAB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVAOLAB" ("LAB") AS 
  select "LAB" from utlab
 ;
--------------------------------------------------------
--  DDL for View AVERRORDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVERRORDETAILS" ("ERROR_HASH", "DESCRIPTION", "SEVERITY", "SOLVED", "SOLUTION") AS 
  SELECT
    FormatHash(error_hash) AS error_hash,
    description,
    severity,
    solved,
    solution
FROM 
    aterrordetails;
--------------------------------------------------------
--  DDL for View AVERRORHASHMAP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVERRORHASHMAP" ("PARENT_HASH", "CHILD_HASH", "ROOT_DESCRIPTION", "NODE_DESCRIPTION", "SEVERITY", "ROOT_SOLVED", "NODE_SOLVED", "SOLUTION") AS 
  SELECT
    FormatHash(parent_hash) AS parent_hash,
    FormatHash(child_hash) AS child_hash,
    root.description AS root_description,
    node.description AS node_description,
    DECODE(node.severity,
        NULL, 'Unknown',
        'F', 'Fatal',
        'E', 'Error',
        'W', 'Warning',
        'I', 'Info'
    ) AS severity,
    DECODE(
        (
            SELECT MIN(details.solved)
            FROM aterrordetails details
            INNER JOIN aterrorhashmap sub ON sub.child_hash = details.error_hash
            WHERE sub.parent_hash = map.parent_hash
            GROUP BY sub.parent_hash
        ),
        1, 'True',
        0, 'False'
    ) AS root_solved,
    DECODE(node.solved,
        1, 'True',
        0, 'False'
    ) AS node_solved,
    node.solution
FROM 
    aterrorhashmap map
INNER JOIN
    aterrordetails root
    ON root.error_hash = map.parent_hash
INNER JOIN
    aterrordetails node
    ON node.error_hash = map.child_hash
ORDER BY
    map.parent_hash DESC,
    map.child_hash;
--------------------------------------------------------
--  DDL for View AVEVLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVEVLOG" ("WAITING_TIME", "PROCESS_TIME", "START_DATE", "UPDATE_DATE", "END_DATE", "TR_SEQ", "EV_SEQ", "CREATED_ON", "CLIENT_ID", "APPLIC", "DBAPI_NAME", "EVMGR_NAME", "OBJECT_TP", "OBJECT_ID", "OBJECT_LC", "OBJECT_LC_VERSION", "OBJECT_SS", "EV_TP", "USERNAME", "EV_DETAILS", "CREATED_ON_TZ") AS 
  SELECT
    end_date - start_date  AS waiting_time,
    end_date - update_date AS process_time,
    atevlog."START_DATE",atevlog."UPDATE_DATE",atevlog."END_DATE",atevlog."TR_SEQ",atevlog."EV_SEQ",atevlog."CREATED_ON",atevlog."CLIENT_ID",atevlog."APPLIC",atevlog."DBAPI_NAME",atevlog."EVMGR_NAME",atevlog."OBJECT_TP",atevlog."OBJECT_ID",atevlog."OBJECT_LC",atevlog."OBJECT_LC_VERSION",atevlog."OBJECT_SS",atevlog."EV_TP",atevlog."USERNAME",atevlog."EV_DETAILS",atevlog."CREATED_ON_TZ"
FROM
    atevlog
 ;
--------------------------------------------------------
--  DDL for View AVEVLOGHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVEVLOGHS" ("INTERVAL", "COUNT", "WAITING_MIN", "WAITING_MAX", "WAITING_MEAN", "WAITING_STDDEV", "WAITING_MEDIAN", "PROCESS_MIN", "PROCESS_MAX", "PROCESS_MEAN", "PROCESS_STDDEV", "PROCESS_MEDIAN") AS 
  SELECT 
    interval,
    COUNT(1) AS count,
    NUMTODSINTERVAL(   MIN(waiting_time), 'SECOND') AS waiting_min,
    NUMTODSINTERVAL(   MAX(waiting_time), 'SECOND') AS waiting_max,
    NUMTODSINTERVAL(   AVG(waiting_time), 'SECOND') AS waiting_mean,
    NUMTODSINTERVAL(STDDEV(waiting_time), 'SECOND') AS waiting_stddev,
    NUMTODSINTERVAL(MEDIAN(waiting_time), 'SECOND') AS waiting_median,
    NUMTODSINTERVAL(   MIN(process_time), 'SECOND') AS process_min,
    NUMTODSINTERVAL(   MAX(process_time), 'SECOND') AS process_max,
    NUMTODSINTERVAL(   AVG(process_time), 'SECOND') AS process_mean,
    NUMTODSINTERVAL(STDDEV(process_time), 'SECOND') AS process_stddev,
    NUMTODSINTERVAL(MEDIAN(process_time), 'SECOND') AS process_median
FROM (
    SELECT
        TRUNC(end_date, 'HH24') AS interval,
        DSINTERVALTONUM(waiting_time) AS waiting_time,
        DSINTERVALTONUM(process_time) AS process_time
    FROM
        avevlog
    WHERE
        end_date < TRUNC(SYSDATE, 'HH24')
)
GROUP BY
    interval;
--------------------------------------------------------
--  DDL for View AVHASHEDERRORLOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVHASHEDERRORLOG" ("TYPE", "LOGDATE", "ROOT_HASH", "ERROR_HASH", "MACHINE_HASH", "SOURCE_HASH", "USER_HASH", "MACHINE", "MODULE", "USERNAME", "SOURCE", "MESSAGE") AS 
  WITH
hash_group AS (
    SELECT '910FB586' AS root_hash, 'F249F4BF' AS node_hash FROM dual UNION ALL
    SELECT '04890FB9', '7888464E' FROM dual UNION ALL
    SELECT '04890FB9', '49BDE705' FROM dual UNION ALL
    SELECT '04890FB9', '3BF0CD04' FROM dual UNION ALL
    SELECT 'F73756E3', '3BBD9980' FROM dual UNION ALL
    SELECT 'F73756E3', 'EBF65859' FROM dual UNION ALL
    SELECT '902BD96C', '094542FC' FROM dual UNION ALL
    SELECT '4C24B66E', '804884AA' FROM dual UNION ALL
    SELECT 'F7DEB9F8', 'FAA08060' FROM dual UNION ALL
    SELECT 'EA1A3846', 'CDBC6486' FROM dual UNION ALL
    SELECT 'EA1A3846', 'BA3978F3' FROM dual UNION ALL
    SELECT '2F9F4080', '8B73877E' FROM dual UNION ALL
    SELECT '8FED91E6', 'E7687AD5' FROM dual UNION ALL
    SELECT '85567B65', 'F3309F4B' FROM dual UNION ALL
    SELECT '85567B65', '48FF0723' FROM dual UNION ALL
    SELECT '85567B65', 'CCCBAF1A' FROM dual
),
err_log AS (
    SELECT
        type,
        logdate,
        client_id AS machine,
        applic AS module,
        who AS username,
        REGEXP_REPLACE(
            REGEXP_REPLACE(
            api_name,
                'Ev~\d+~(.+)',
                'Ev~%~\1'
            ),
            'UNACTION\.AssignGroupKey\(.+',
            'UNACTION.AssignGroupKey(%,%)'
        ) AS source_filter,
        api_name AS source,
        REGEXP_REPLACE(
        REGEXP_REPLACE(
        REGEXP_REPLACE(
            error_msg,
            '([A-Za-z()_]+)=[^#;]*',
            '\1=%'
        ),
            '<[^>]*>',
            '<%>'
        ),
            '^(SQL\(\d+\)|\(SQL\)).*$',
            '(SQL)'
        ) AS error_filter,
        error_msg AS message
    FROM (
        SELECT 'error' AS type, uterror.* FROM uterror UNION ALL
        SELECT 'info', atinfo.* FROM atinfo
    )
)

SELECT
    type,
    logdate,
    NVL(root_hash, error_hash) AS root_hash,
    error_hash,
    machine_hash,
    source_hash,
    user_hash,
    machine,
    module,
    username,
    source,
    message
FROM (
    SELECT
        LPAD(TRIM(TO_CHAR(ORA_HASH(source_filter || error_filter), 'XXXXXXXX')), 8, '0') AS error_hash,
        LPAD(TRIM(TO_CHAR(ORA_HASH(machine || module), 'XXXXXXXX')), 8, '0') AS machine_hash,
        LPAD(TRIM(TO_CHAR(ORA_HASH(machine || module || username), 'XXXXXXXX')), 8, '0') AS source_hash,
        LPAD(TRIM(TO_CHAR(ORA_HASH(module || username), 'XXXXXXXX')), 8, '0') AS user_hash,
        err_log.*
    FROM
        err_log
)
LEFT JOIN
    hash_group
    ON node_hash = error_hash;
--------------------------------------------------------
--  DDL for View AVSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVSC" ("SC", "PG", "PGNODE", "PA", "PANODE", "VALUE_S", "FORMAT", "UNIT", "ME", "MENODE", "ME_FLOAT", "ME_STRING") AS 
  select a.sc, 
       b.pg, b.pgnode, 
       b.pa, b.panode, b.value_s, b.format, b.unit, c.me, c.menode, c.value_f me_float, c.value_s me_string
  from atsc a, utscpa b, utscme c where a.sc = b.sc and b.value_s is null
and a.sc = c.sc and b.pg = c.pg and b.pgnode = c.pgnode and b.pa = c.pa and b.panode = c.panode 
 ;
--------------------------------------------------------
--  DDL for View AVSESSIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVSESSIONS" ("USERNAME", "TOTAL_SESSIONS", "QUICK_SESSIONS", "SHORT_SESSIONS", "MEDIUM_SESSIONS", "LONG_SESSIONS") AS 
  SELECT
    ses_dbuser AS username,
    --ses_class,
    COUNT(*) AS total_sessions,
    COUNT(CASE WHEN ses_class = 1 THEN 1 ELSE NULL END) AS quick_sessions,
    COUNT(CASE WHEN ses_class = 2 THEN 1 ELSE NULL END) AS short_sessions,
    COUNT(CASE WHEN ses_class = 3 THEN 1 ELSE NULL END) AS medium_sessions,
    COUNT(CASE WHEN ses_class = 4 THEN 1 ELSE NULL END) AS long_sessions
FROM (
    SELECT
        ses.*,
        CASE
            WHEN ses_length <= INTERVAL '10' MINUTE THEN
                1
            WHEN ses_length <= INTERVAL '60' MINUTE THEN
                2
            WHEN ses_length <= INTERVAL '8' HOUR THEN
                3
            ELSE
                4
        END AS ses_class
    FROM (
        SELECT
            (ses_logoff_date - ses_logon_date) DAY TO SECOND ses_length,
            ses_dbuser,
            ses_osuser,
            ses_machine,
            ses_terminal,
            ses_program,
            ses_logon_date,
            ses_logoff_date
        FROM at_sessions
    ) ses
)
GROUP BY
    ses_dbuser
ORDER BY
    total_sessions DESC;
--------------------------------------------------------
--  DDL for View AVTRHS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVTRHS" ("OBJECT_TP", "OBJECT_ID", "SS_FROM", "SS_TO", "TR_ON", "TR_ON_TZ") AS 
  SELECT "OBJECT_TP","OBJECT_ID","SS_FROM","SS_TO","TR_ON","TR_ON_TZ" FROM atobjecttrhs UNION ALL
SELECT 'ws', atwstrhs."WS",atwstrhs."SS_FROM",atwstrhs."SS_TO",atwstrhs."TR_ON",atwstrhs."TR_ON_TZ" FROM atwstrhs UNION ALL
SELECT 'rq', atrqtrhs."RQ",atrqtrhs."SS_FROM",atrqtrhs."SS_TO",atrqtrhs."TR_ON",atrqtrhs."TR_ON_TZ" FROM atrqtrhs UNION ALL
SELECT 'sc', atsctrhs."SC",atsctrhs."SS_FROM",atsctrhs."SS_TO",atsctrhs."TR_ON",atsctrhs."TR_ON_TZ" FROM atsctrhs UNION ALL
SELECT 'pg', sc || '/' || pg || '[' || pgnode || ']', ss_from, ss_to, tr_on, tr_on_tz FROM atpgtrhs UNION ALL
SELECT 'pa', sc || '/' || pg || '[' || pgnode || ']/' || pa || '[' || panode || ']', ss_from, ss_to, tr_on, tr_on_tz FROM atpatrhs UNION ALL
SELECT 'me', sc || '/' || pg || '[' || pgnode || ']/' || pa || '[' || panode || ']/' || me || '[' || menode || ']', ss_from, ss_to, tr_on, tr_on_tz FROM atmetrhs UNION ALL
SELECT 'rqic', rq || '/' || ic || '[' || icnode || ']', ss_from, ss_to, tr_on, tr_on_tz FROM atrqictrhs UNION ALL
SELECT 'ic',   sc || '/' || ic || '[' || icnode || ']', ss_from, ss_to, tr_on, tr_on_tz FROM atictrhs;
--------------------------------------------------------
--  DDL for View AVVRSCMECELL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."AVVRSCMECELL" ("SC", "PG", "PGNODE", "PA", "PANODE", "ME", "MENODE", "REANALYSIS", "CELL", "CELLNODE", "DSP_TITLE", "VALUE_F", "VALUE_S", "CELL_TP", "POS_X", "POS_Y", "ALIGN", "WINSIZE_X", "WINSIZE_Y", "IS_PROTECTED", "MANDATORY", "HIDDEN", "UNIT", "FORMAT", "EQ", "EQ_VERSION", "COMPONENT", "CALC_TP", "CALC_FORMULA", "VALID_CF", "MAX_X", "MAX_Y", "MULTI_SELECT", "MT_VERSION") AS 
  SELECT   CELL.SC,
            CELL.PG,
            CELL.PGNODE,
            CELL.PA,
            CELL.PANODE,
            CELL.ME,
            CELL.MENODE,                                  --        NUMBER(9),
            CELL.REANALYSIS,   --    NUMBER(3)                       NOT NULL,
            CELL.CELL,                                --    VARCHAR2(20 CHAR),
            CELL.CELLNODE,                                    --    NUMBER(9),
            CELL.DSP_TITLE,                           --    VARCHAR2(40 CHAR),
            CELL.VALUE_F,                                    --    FLOAT(126),
            CELL.VALUE_S,                             --    VARCHAR2(40 CHAR),
            CELL.CELL_TP,                                  --    CHAR(1 CHAR),
            CELL.POS_X,        --    NUMBER(4)                       NOT NULL,
            CELL.POS_Y,        --    NUMBER(4)                       NOT NULL,
            CELL.ALIGN,                                    --    CHAR(1 CHAR),
            CELL.WINSIZE_X,    --    NUMBER(4)                       NOT NULL,
            CELL.WINSIZE_Y,    --    NUMBER(4)                       NOT NULL,
            CELL.IS_PROTECTED,                                -- CHAR(1 CHAR),
            CELL.MANDATORY,                                   -- CHAR(1 CHAR),
            CELL.HIDDEN,                                      -- CHAR(1 CHAR),
            CELL.UNIT,                                   -- VARCHAR2(20 CHAR),
            CELL.FORMAT,                                 -- VARCHAR2(40 CHAR),
            CELL.EQ,                                     -- VARCHAR2(20 CHAR),
            CELL.EQ_VERSION,                             -- VARCHAR2(20 CHAR),
            CELL.COMPONENT,                              -- VARCHAR2(20 CHAR),
            CELL.CALC_TP,                                     -- CHAR(1 CHAR),
            CELL.CALC_FORMULA,                         -- VARCHAR2(2000 CHAR),
            CELL.VALID_CF,                               -- VARCHAR2(20 CHAR),
            CELL.MAX_X,           -- NUMBER(3)                       NOT NULL,
            CELL.MAX_Y,           -- NUMBER(3)                       NOT NULL,
            CELL.MULTI_SELECT,                                 -- CHAR(1 CHAR)
            ME.MT_VERSION
     FROM   UTSCME ME, UTSCMECELL CELL
    WHERE       CELL.SC = ME.SC
            AND CELL.PG = ME.PG
            AND CELL.PGNODE = ME.PGNODE
            AND CELL.PA = ME.PA
            AND CELL.PANODE = ME.PANODE
            AND CELL.ME = ME.ME
            AND CELL.MENODE = ME.MENODE 
 ;
--------------------------------------------------------
--  DDL for View RMWSETTINGS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RMWSETTINGS" ("SERVER", "DATABASE", "USERNAME", "COMPANY", "IMAGEFOLDER", "VERSION") AS 
  SELECT max(vi.host_name) SERVER,
       max(UPPER ( vi.instance_name )) DATABASE,
       max(user) USERNAME,
       max(DECODE(rt.Setting,'Company' , rt.Value)) as Company,
       max(DECODE( rt.Setting , 'SourceFolder' , rt.Value )) as ImageFolder,
	   max(DECODE( rt.Setting , 'Version' , rt.Value )) as Version
  FROM v$instance vi, RMtSETTINGS rt

 ;
--------------------------------------------------------
--  DDL for View RVU_IE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RVU_IE" ("II", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_TILL", "IS_PROTECTED", "MANDATORY", "HIDDEN", "DATA_TP", "FORMAT", "VALID_CF", "DEF_VAL_TP", "DEF_AU_LEVEL", "IEVALUE", "ALIGN", "DSP_TITLE", "DSP_TITLE2", "DSP_LEN", "DSP_TP", "DSP_ROWS", "LOOK_UP_PTR", "IS_TEMPLATE", "MULTI_SELECT", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "IE_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT ie as II,
       version,
       version_is_current,
       effective_from,
       EFFECTIVE_FROM_TZ  
       effective_till,
       EFFECTIVE_TILL_TZ 
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       last_comment,
       ie_class,
       log_hs,
       log_hs_details,
       allow_modify,
       active,
       lc,
       lc_version,
       ss,
       ar
  FROM uvie

 ;
--------------------------------------------------------
--  DDL for View RVU_PR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RVU_PR" ("PA", "VERSION", "VERSION_IS_CURRENT", "EFFECTIVE_FROM", "EFFECTIVE_FROM_TZ", "EFFECTIVE_TILL", "EFFECTIVE_TILL_TZ", "DESCRIPTION", "DESCRIPTION2", "UNIT", "FORMAT", "TD_INFO", "TD_INFO_UNIT", "CONFIRM_UID", "DEF_VAL_TP", "DEF_AU_LEVEL", "DEF_VAL", "ALLOW_ANY_MT", "DELAY", "DELAY_UNIT", "MIN_NR_RESULTS", "CALC_METHOD", "CALC_CF", "ALARM_ORDER", "SETA_SPECS", "SETA_LIMITS", "SETA_TARGET", "SETB_SPECS", "SETB_LIMITS", "SETB_TARGET", "SETC_SPECS", "SETC_LIMITS", "SETC_TARGET", "IS_TEMPLATE", "LOG_EXCEPTIONS", "SC_LC", "SC_LC_VERSION", "INHERIT_AU", "LAST_COMMENT", "PR_CLASS", "LOG_HS", "LOG_HS_DETAILS", "ALLOW_MODIFY", "ACTIVE", "LC", "LC_VERSION", "SS", "AR") AS 
  SELECT pr as PA,
   version,
   version_is_current,
   effective_from,
   effective_from_tz,
   effective_till,
   effective_till_tz,
   description,
   description2,
   unit,
   format,
   td_info,
   td_info_unit,
   confirm_uid,
   def_val_tp,
   def_au_level,
   def_val,
   allow_any_mt,
   delay,
   delay_unit,
   min_nr_results,
   calc_method,
   calc_cf,
   alarm_order,
   seta_specs,
   seta_limits,
   seta_target,
   setb_specs,
   setb_limits,
   setb_target,
   setc_specs,
   setc_limits,
   setc_target,
   is_template,
   log_exceptions,
   sc_lc,
   sc_lc_version,
   inherit_au,
   last_comment,
   pr_class,
   log_hs,
   log_hs_details,
   allow_modify,
   active,
   lc,
   lc_version,
   ss,
   ar
  FROM uvpr

 ;
--------------------------------------------------------
--  DDL for View RVU_PTCELLST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RVU_PTCELLST" ("PT", "VERSION", "PTROW", "PTCOLUMN", "SEQ", "ST", "ST_VERSION", "NR_PLANNED_SC", "SC_LC", "SC_LC_VERSION", "SC_UC", "SC_UC_VERSION", "ADD_STPP", "ADD_STIP", "NR_SC_MAX", "INHERIT_AU", "TP", "CS") AS 
  SELECT uvptcellst.pt,
       uvptcellst.VERSION,
       uvptcellst.ptrow,
       uvptcellst.ptcolumn,
       uvptcellst.seq,
       uvptcellst.st,
       uvptcellst.st_version,
       uvptcellst.nr_planned_sc,
       uvptcellst.sc_lc,
       uvptcellst.sc_lc_version,
       uvptcellst.sc_uc,
       uvptcellst.sc_uc_version,
       uvptcellst.add_stpp,
       uvptcellst.add_stip,
       uvptcellst.nr_sc_max,
       uvptcellst.inherit_au,
       uvpttp.tp,
       uvptcs.cs
  FROM uvptcellst, uvpttp, uvptcs
 WHERE (    (uvptcellst.pt = uvpttp.pt)
        AND (uvptcellst.ptcolumn = uvpttp.ptcolumn)
        AND (uvptcellst.pt = uvptcs.pt)
        AND (uvptcellst.VERSION = uvptcs.VERSION)
        AND (uvptcellst.ptrow = uvptcs.ptrow)
        AND (uvptcellst.VERSION = uvpttp.VERSION)
       )

 ;
--------------------------------------------------------
--  DDL for View RVU_PTPRINTCLDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RVU_PTPRINTCLDETAILS" ("REQ_ID", "ROW_NR", "COL_NR", "HDR_VAL", "COL_VAL", "ROW_TYPE") AS 
  select a.Req_Id,  b.Row_seq as Row_Nr,  '00' as Col_Nr,  a.Col00 as Hdr_Val,  b.Col00 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col00 is not null ) and a.Col00 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '01' as Col_Nr,  a.Col01 as Hdr_Val,  b.Col01 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col01 is not null ) and a.Col01 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '02' as Col_Nr,  a.Col02 as Hdr_Val,  b.Col02 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col02 is not null ) and a.Col02 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '03' as Col_Nr,  a.Col03 as Hdr_Val,  b.Col03 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col03 is not null ) and a.Col03 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '04' as Col_Nr,  a.Col04 as Hdr_Val,  b.Col04 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col04 is not null ) and a.Col04 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '05' as Col_Nr,  a.Col05 as Hdr_Val,  b.Col05 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col05 is not null ) and a.Col05 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '06' as Col_Nr,  a.Col06 as Hdr_Val,  b.Col06 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col06 is not null ) and a.Col06 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '07' as Col_Nr,  a.Col07 as Hdr_Val,  b.Col07 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col07 is not null ) and a.Col07 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '08' as Col_Nr,  a.Col08 as Hdr_Val,  b.Col08 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col08 is not null ) and a.Col08 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '09' as Col_Nr,  a.Col09 as Hdr_Val,  b.Col09 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col09 is not null ) and a.Col09 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '10' as Col_Nr,  a.Col10 as Hdr_Val,  b.Col10 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col10 is not null ) and a.Col10 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '11' as Col_Nr,  a.Col11 as Hdr_Val,  b.Col11 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col11 is not null ) and a.Col11 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '12' as Col_Nr,  a.Col12 as Hdr_Val,  b.Col12 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col12 is not null ) and a.Col12 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '13' as Col_Nr,  a.Col13 as Hdr_Val,  b.Col13 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col13 is not null ) and a.Col13 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '14' as Col_Nr,  a.Col14 as Hdr_Val,  b.Col14 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col14 is not null ) and a.Col14 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '15' as Col_Nr,  a.Col15 as Hdr_Val,  b.Col15 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col15 is not null ) and a.Col15 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '16' as Col_Nr,  a.Col16 as Hdr_Val,  b.Col16 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col16 is not null ) and a.Col16 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '17' as Col_Nr,  a.Col17 as Hdr_Val,  b.Col17 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col17 is not null ) and a.Col17 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '18' as Col_Nr,  a.Col18 as Hdr_Val,  b.Col18 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col18 is not null ) and a.Col18 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '19' as Col_Nr,  a.Col19 as Hdr_Val,  b.Col19 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col19 is not null ) and a.Col19 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '20' as Col_Nr,  a.Col20 as Hdr_Val,  b.Col20 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col20 is not null ) and a.Col20 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '21' as Col_Nr,  a.Col21 as Hdr_Val,  b.Col21 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col21 is not null ) and a.Col21 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '22' as Col_Nr,  a.Col22 as Hdr_Val,  b.Col22 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col22 is not null ) and a.Col22 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '23' as Col_Nr,  a.Col23 as Hdr_Val,  b.Col23 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col23 is not null ) and a.Col23 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '24' as Col_Nr,  a.Col24 as Hdr_Val,  b.Col24 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col24 is not null ) and a.Col24 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '25' as Col_Nr,  a.Col25 as Hdr_Val,  b.Col25 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col25 is not null ) and a.Col25 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '26' as Col_Nr,  a.Col26 as Hdr_Val,  b.Col26 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col26 is not null ) and a.Col26 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '27' as Col_Nr,  a.Col27 as Hdr_Val,  b.Col27 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col27 is not null ) and a.Col27 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '28' as Col_Nr,  a.Col28 as Hdr_Val,  b.Col28 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col28 is not null ) and a.Col28 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '29' as Col_Nr,  a.Col29 as Hdr_Val,  b.Col29 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col29 is not null ) and a.Col29 is not null  union select a.Req_Id,  b.Row_seq as Row_Nr,  '30' as Col_Nr,  a.Col30 as Hdr_Val,  b.Col30 as Col_Val,  b.Row_type as Row_Type from  UTPRINTCLDETAILS a inner join UTPRINTCLDETAILS b on a.Req_Id = b.Req_Id  where (a.Row_Type = 'H') and  b.Row_Type <> 'H' and  (b.Row_Type <> 'T' or b.Col30 is not null ) and a.Col30 is not null
 ;
--------------------------------------------------------
--  DDL for View RVU_PTTP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RVU_PTTP" ("PT", "VERSION", "PTCOLUMN", "TP", "TP_UNIT", "ALLOW_UPFRONT", "ALLOW_UPFRONT_UNIT", "ALLOW_OVERDUE", "ALLOW_OVERDUE_UNIT", "UNIT_DESCRIPTION", "UNIT_UPFRONT_DESCRIPTION", "UNIT_OVERDUE_DESCRIPTION") AS 
  SELECT uvpttp."PT",uvpttp."VERSION",uvpttp."PTCOLUMN",uvpttp."TP",uvpttp."TP_UNIT",uvpttp."ALLOW_UPFRONT",uvpttp."ALLOW_UPFRONT_UNIT",uvpttp."ALLOW_OVERDUE",uvpttp."ALLOW_OVERDUE_UNIT",
       uvdecode.description1 AS unit_description,
       uvdecode_for_upfront.description1 AS unit_upfront_description,
       uvdecode_for_overdue.description1 AS unit_overdue_description
  FROM uvpttp, uvdecode, uvdecode uvdecode_for_upfront, uvdecode uvdecode_for_overdue
 WHERE (    (uvpttp.tp_unit = uvdecode.code(+))
        AND (uvpttp.allow_upfront_unit = uvdecode_for_upfront.code(+))
        AND (uvpttp.allow_overdue_unit = uvdecode_for_overdue.code(+)))

 ;
--------------------------------------------------------
--  DDL for View RVU_SDCELLSC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RVU_SDCELLSC" ("SD", "CSNODE", "TPNODE", "SEQ", "SC", "LO", "LO_DESCRIPTION", "LO_START_DATE", "LO_START_DATE_TZ", "LO_END_DATE", "LO_END_DATE_TZ", "CS", "TP", "TP_UNIT", "PULLINGDATE", "ALLOW_UPFRONT", "ALLOW_UPFRONT_UNIT", "UPFRONT", "ALLOW_OVERDUE", "ALLOW_OVERDUE_UNIT", "OVERDUE") AS 
  SELECT uvsdcellsc.sd, 
       uvsdcellsc.csnode, 
       uvsdcellsc.tpnode, 
       uvsdcellsc.seq, 
       uvsdcellsc.sc, 
       uvsdcellsc.lo, 
       uvsdcellsc.lo_description, 
       uvsdcellsc.lo_start_date,
       uvsdcellsc.lo_start_date_TZ, 
       uvsdcellsc.lo_end_date,
       uvsdcellsc.lo_end_date_TZ, 
       uvsdcs.cs, 
       uvsdtp.tp, 
	   uvsdtp.TP_UNIT, 
	   TO_DATE(rfu_getpullingday (uvsdcellsc.sc), 'YYYY/MM/DD HH24:MI:SS') AS pullingdate, 
       uvsdtp.allow_upfront, 
       uvsdtp.allow_upfront_unit, 
       DECODE (rfu_getpullingday (uvsdcellsc.sc), 
               NULL, to_date(NULL), 
               unapiaut.sqlcalculatedelay ((-1) * uvsdtp.allow_upfront, 
                                           uvsdtp.allow_upfront_unit, 
                                           TO_DATE (rfu_getpullingday (uvsdcellsc.sc), 'YYYY/MM/DD HH24:MI:SS') 
                                          ) 
              ) AS upfront, 
       uvsdtp.allow_overdue, 
       uvsdtp.allow_overdue_unit, 
       DECODE (rfu_getpullingday (uvsdcellsc.sc), 
               NULL, to_date(NULL), 
               unapiaut.sqlcalculatedelay (uvsdtp.allow_overdue, 
                                           uvsdtp.allow_overdue_unit, 
                                           TO_DATE (rfu_getpullingday (uvsdcellsc.sc), 'YYYY/MM/DD HH24:MI:SS') 
                                          ) 
              ) AS overdue 
  FROM uvsdcellsc, uvsdcs, uvsdtp 
 WHERE (    (uvsdcellsc.sd = uvsdcs.sd) 
        AND (uvsdcellsc.csnode = uvsdcs.csnode) 
        AND (uvsdcellsc.sd = uvsdtp.sd) 
        AND (uvsdcellsc.tpnode = uvsdtp.tpnode) 
       )

 ;
--------------------------------------------------------
--  DDL for View RVU_SDTP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "UNILAB"."RVU_SDTP" ("SD", "TPNODE", "TP", "TP_UNIT", "ALLOW_UPFRONT", "ALLOW_UPFRONT_UNIT", "ALLOW_OVERDUE", "ALLOW_OVERDUE_UNIT", "UNIT_DESCRIPTION", "UNIT_UPFRONT_DESCRIPTION", "UNIT_OVERDUE_DESCRIPTION") AS 
  SELECT uvsdtp.sd,
       uvsdtp.tpnode,
       uvsdtp.tp,
       uvsdtp.tp_unit,
       uvsdtp.allow_upfront,
       uvsdtp.allow_upfront_unit,
       uvsdtp.allow_overdue,
       uvsdtp.allow_overdue_unit,
       uvdecode.description1 as UNIT_DESCRIPTION,
       unit_upfront_description.description1 AS UNIT_UPFRONT_DESCRIPTION,
       unit_overdue_description.description1 AS UNIT_OVERDUE_DESCRIPTION
  FROM uvsdtp, uvdecode, uvdecode unit_upfront_description, uvdecode unit_overdue_description
 WHERE (    (uvsdtp.tp_unit = uvdecode.code(+))
        AND (uvsdtp.allow_upfront_unit = unit_upfront_description.code(+))
        AND (uvsdtp.allow_overdue_unit = unit_overdue_description.code(+)))

 ;
