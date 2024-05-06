--*******************************************************
--inactieve session
--*******************************************************
--dd. 07-03-2023 08:48:00
/* Formatted on 07/03/2023 09:33:42 (QP5 v5.391) */
SELECT current_scn FROM v$database

/* Formatted on 07/03/2023 09:33:54 (QP5 v5.391) */
SELECT object_id
  FROM all_objects
 WHERE owner = 'SYS' AND object_name = 'OBJ$'
 
 /* Formatted on 07/03/2023 09:34:03 (QP5 v5.391) */
SELECT COUNT (*)
  FROM dba_objects
 WHERE 1 = 0
 
 /* Formatted on 07/03/2023 09:34:18 (QP5 v5.391) */
BEGIN
    SYS.DBMS_LOGMNR.END_LOGMNR ();
END;


--************************************************************
--1E SESSION IS ACTIEF
--*******************************************************
/* Formatted on 07/03/2023 09:34:18 (QP5 v5.391) */
BEGIN
    SYS.DBMS_LOGMNR.END_LOGMNR ();
END;


/* Formatted on 07/03/2023 09:32:32 (QP5 v5.391) */
SELECT NVL (owner, ' ')
           OWNER,
       NVL (table_name, ' ')
           NAME,
       NVL (NUM_ROWS, 0),
       NVL (PARTITIONED, ' '),
       NVL (IOT_TYPE, ' '),
       NVL (compression, ' '),
       NVL (compress_for, ' '),
       NVL (
           (SELECT NVL (object_id, 0)
              FROM all_objects
             WHERE     all_tables.table_name = object_name
                   AND all_tables.owner = owner
                   AND object_type = 'TABLE'),
           0),
       NVL (
           (SELECT NVL (data_object_id, 0)
              FROM all_objects
             WHERE     all_tables.table_name = object_name
                   AND all_tables.owner = owner
                   AND object_type = 'TABLE'),
           0),
       NVL (
           (SELECT NVL (encrypted, ' ')
              FROM dba_tablespaces
             WHERE dba_tablespaces.tablespace_name =
                   all_tables.tablespace_name),
           ' '),
       NVL (cluster_name, ' '),
       NVL (nested, ' '),
       'T'
  FROM all_tables
 WHERE     (   (    (   (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'ATAOACTIONS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'ATAOCONDITIONS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'ATAVMETHODCLASS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'ATAVPROJECTS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'ATICTRHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'ATMETRHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'ATPATRHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'ATRQTRHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'ATSCTRHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTAD')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTADAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTDD')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTDECODE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTEQ')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTEQAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTEQCD')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTEQTYPE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTERROR')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTGKMELIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTGKRQLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTGKRTLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTGKSCLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTGKSTLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTGKWSLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTIE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTIEAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTIELIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTIP')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTIPIE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTLAB')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTLC')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTLCAF')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTLCHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTLCTR')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTLONGTEXT')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTLY')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTMT')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTMTAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTMTCELL')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTMTCELLLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTMTHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPP')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPPAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPPPR')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPPPRAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPR')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPRAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPRHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPRMT')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTPRMTAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRQ')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRQAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRQGK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKISRELEVANT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKISTEST')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKREQUESTCODE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKRQDAY')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKRQEXECUTIONWEEK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKRQMONTH')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKRQSTATUS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKRQWEEK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKRQYEAR')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRQGKSITE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKTESTLOCATION')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKTESTTYPE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRQGKWORKORDER')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRQHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRQIC')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRQII')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRSCME')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRSCMECELL')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRSCMECELLLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRSCPA')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRSCPASPA')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRSCPG')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRT')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRTAU')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRTGKREQUESTERUP')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTRTGKSPEC_TYPE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTRTIP')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSC')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCGK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKCONTEXT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKISTEST')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKPARTGROUP')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKPART_NO')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKPROJECT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKREQUESTCODE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKRIMCODE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKSCCREATEUP')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKSCLISTUP')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKSCRECEIVERUP')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCGKSITE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKSPEC_TYPE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCGKWEEK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCGKWORKORDER')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCGKYEAR')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCIC')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCII')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCME')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCMEAU')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMECELLLIST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCMEGK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKAVTESTMETHOD')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKAVTESTMETHODDESC')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKEQUIPEMENT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKEQUIPMENT_TYPE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKIMPORTID')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKKINDOFSAMPLE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKLAB')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKME_IS_RELEVANT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKPART_NO')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKREQUESTCODE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKSCPRIORITY')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKTM_POSITION')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKUSER_GROUP')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKWEEK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEGKYEAR')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCMEHS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEHSDETAILS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCPA')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCPAAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCPAHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCPASPA')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCPG')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCPGAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTST')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSTAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSTGK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSTGKCONTEXT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSTGKISTEST')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSTGKPRODUCT_RANGE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSTGKSPEC_TYPE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSTHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSTPP')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTUP')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTUPAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTUPPREF')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTUPUS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTUPUSPREF')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWSAU')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWSGK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKAVTESTMETHOD')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKAVTESTMETHODDESC')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKNUMBEROFREFS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKNUMBEROFSETS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKNUMBEROFVARIANTS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKOUTSOURCE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKP_INFL_FRONT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKP_INFL_REAR')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKREFSETDESC')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKREQUESTCODE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWSGKRIM')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKRIMETFRONT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKRIMETREAR')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKRIMWIDTHFRONT')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKRIMWIDTHREAR')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKSPEC_TYPE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKSUBPROGRAMID')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKTESTLOCATION')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKTESTPRIO')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKTESTSETSIZE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKTESTVEHICLETYPE')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKTESTWEEK')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKWSPRIO')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKWSTESTLOCATION')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTWSGKWSVEHICLE')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWSHS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWSII')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWSME')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWSSC')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTWT')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCMECELL'))
                AND NOT (   (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_changes%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_apply%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_truncation%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_audit_table')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_status')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_suspended_tables')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_history')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_validation_failure')
                         OR (    owner LIKE '%'
                             AND table_name LIKE
                                     'awsdms_cdc_%awsdms_full_load_exceptions%')))
            OR (1 <> 1))
       AND 1 = 1
       AND owner NOT IN ('SYS',
                         'MDSYS',
                         'OLAPSYS',
                         'WKSYS',
                         'CTXSYS',
                         'XDB',
                         'WMSYS',
                         'EXFSYS',
                         'ORDSYS',
                         'DMSYS',
                         'WK_TEST')
       AND table_name NOT LIKE 'BIN$%'
       AND table_name NOT LIKE 'DR$%'
       AND duration IS NULL
UNION
SELECT NVL (owner, ' ')
           OWNER,
       NVL (view_name, ' ')
           NAME,
       0,
       ' ',
       ' ',
       ' ',
       ' ',
       NVL (
           (SELECT NVL (object_id, 0)
              FROM all_objects
             WHERE     all_views.view_name = object_name
                   AND all_views.owner = owner
                   AND object_type = 'VIEW'),
           0),
       0,
       ' ',
       ' ',
       ' ',
       'V'
  FROM all_views
 WHERE     (   (    (1 <> 1)
                AND NOT (   (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_changes%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_apply%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_truncation%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_audit_table')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_status')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_suspended_tables')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_history')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_validation_failure')
                         OR (    owner LIKE '%'
                             AND view_name LIKE
                                     'awsdms_cdc_%awsdms_full_load_exceptions%')))
            OR (1 <> 1))
       AND 1 = 1
       AND owner NOT IN ('SYS',
                         'MDSYS',
                         'OLAPSYS',
                         'WKSYS',
                         'CTXSYS',
                         'XDB',
                         'WMSYS',
                         'EXFSYS',
                         'ORDSYS',
                         'DMSYS',
                         'WK_TEST')
       AND view_name NOT LIKE 'BIN$%'
       AND view_name NOT LIKE 'DR$%'
ORDER BY OWNER, NAME

--in deze query komen wel de 3 tabellen voor (UTSCHS etc) !!!!!!!!!!!

/* Formatted on 07/03/2023 09:34:31 (QP5 v5.391) */
SELECT operation,
       NVL (sql_undo, ' '),
       xidusn,
       xidslt,
       xidsqn,
       NVL (seg_name, ' '),
       SCN,
       RBASQN,
       RBABLK,
       RBABYTE,
       NVL (seg_owner, ' '),
       NVL (sql_redo, ' '),
       CSF,
       rollback,
       NVL (row_id, ' '),
       timestamp,
       NVL (username, ' ')
  FROM v$logmnr_contents
 WHERE     SCN >= :startScn
       AND (   (    operation IN ('INSERT',
                                  'DELETE',
                                  'UPDATE',
                                  'DIRECT INSERT')
                AND (seg_name IN ('OBJ# 18',
                                  'OBJ# 262458',
                                  'OBJ# 262490',
                                  'OBJ# 262493')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))
							 							 
--welke tabellen zijn dit:							 
select object_id, name from all_objects where object_type='TABLE' and object_id in (	262458, 262490, 262493 )						 
/*
262458	UTSCHS
262490	UTSCMEHSDETAILS
262493	UTSCPAHS						 
*/


/* Formatted on 07/03/2023 09:33:26 (QP5 v5.391) */
SELECT NVL (owner, ' ')
           OWNER,
       NVL (table_name, ' ')
           NAME,
       NVL (NUM_ROWS, 0),
       NVL (PARTITIONED, ' '),
       NVL (IOT_TYPE, ' '),
       NVL (compression, ' '),
       NVL (compress_for, ' '),
       NVL (
           (SELECT NVL (object_id, 0)
              FROM all_objects
             WHERE     all_tables.table_name = object_name
                   AND all_tables.owner = owner
                   AND object_type = 'TABLE'),
           0),
       NVL (
           (SELECT NVL (data_object_id, 0)
              FROM all_objects
             WHERE     all_tables.table_name = object_name
                   AND all_tables.owner = owner
                   AND object_type = 'TABLE'),
           0),
       NVL (
           (SELECT NVL (encrypted, ' ')
              FROM dba_tablespaces
             WHERE dba_tablespaces.tablespace_name =
                   all_tables.tablespace_name),
           ' '),
       NVL (cluster_name, ' '),
       NVL (nested, ' '),
       'T'
  FROM all_tables
 WHERE     (   (    (   (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCHS')
                     OR (    owner LIKE 'UNILAB'
                         AND table_name LIKE 'UTSCMEHSDETAILS')
                     OR (owner LIKE 'UNILAB' AND table_name LIKE 'UTSCPAHS'))
                AND NOT (   (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_changes%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_apply%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_truncation%')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_audit_table')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_status')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_suspended_tables')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_history')
                         OR (    owner LIKE '%'
                             AND table_name LIKE 'awsdms_validation_failure')
                         OR (    owner LIKE '%'
                             AND table_name LIKE
                                     'awsdms_cdc_%awsdms_full_load_exceptions%')))
            OR (1 <> 1))
       AND 1 = 1
       AND owner NOT IN ('SYS',
                         'MDSYS',
                         'OLAPSYS',
                         'WKSYS',
                         'CTXSYS',
                         'XDB',
                         'WMSYS',
                         'EXFSYS',
                         'ORDSYS',
                         'DMSYS',
                         'WK_TEST')
       AND table_name NOT LIKE 'BIN$%'
       AND table_name NOT LIKE 'DR$%'
       AND duration IS NULL
UNION
SELECT NVL (owner, ' ')
           OWNER,
       NVL (view_name, ' ')
           NAME,
       0,
       ' ',
       ' ',
       ' ',
       ' ',
       NVL (
           (SELECT NVL (object_id, 0)
              FROM all_objects
             WHERE     all_views.view_name = object_name
                   AND all_views.owner = owner
                   AND object_type = 'VIEW'),
           0),
       0,
       ' ',
       ' ',
       ' ',
       'V'
  FROM all_views
 WHERE     (   (    (1 <> 1)
                AND NOT (   (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_changes%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_apply%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_truncation%')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_audit_table')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_status')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_suspended_tables')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_history')
                         OR (    owner LIKE '%'
                             AND view_name LIKE 'awsdms_validation_failure')
                         OR (    owner LIKE '%'
                             AND view_name LIKE
                                     'awsdms_cdc_%awsdms_full_load_exceptions%')))
            OR (1 <> 1))
       AND 1 = 1
       AND owner NOT IN ('SYS',
                         'MDSYS',
                         'OLAPSYS',
                         'WKSYS',
                         'CTXSYS',
                         'XDB',
                         'WMSYS',
                         'EXFSYS',
                         'ORDSYS',
                         'DMSYS',
                         'WK_TEST')
       AND view_name NOT LIKE 'BIN$%'
       AND view_name NOT LIKE 'DR$%'
ORDER BY OWNER, NAME







--****************************************
--2e SESSION ACTIEF
--****************************************

/* Formatted on 07/03/2023 09:42:17 (QP5 v5.391) */
BEGIN
    SYS.DBMS_LOGMNR.END_LOGMNR ();
END;

/* Formatted on 07/03/2023 09:43:01 (QP5 v5.391) */
SELECT name,
       first_change#,
       sequence#,
       status
  FROM v$archived_log
 WHERE     first_time IS NOT NULL
       AND name IS NOT NULL
       AND resetlogs_change# = (SELECT resetlogs_change# FROM v$database)
       AND resetlogs_time = (SELECT resetlogs_time FROM v$database)
       AND thread# = :thread
       AND next_change# >= :startScn
       AND dest_id IN (1)
UNION
SELECT lf.MEMBER,
       first_change#,
       sequence#,
       'A'
  FROM v$logfile lf, V$LOG l
 WHERE     l.group# = lf.group#
       AND l.first_time IS NOT NULL
       AND l.status = 'CURRENT'
       AND thread# = :thread
ORDER BY first_change# DESC


/* Formatted on 07/03/2023 09:38:43 (QP5 v5.391) */
SELECT operation,
       NVL (sql_undo, ' '),
       xidusn,
       xidslt,
       xidsqn,
       NVL (seg_name, ' '),
       SCN,
       RBASQN,
       RBABLK,
       RBABYTE,
       NVL (seg_owner, ' '),
       NVL (sql_redo, ' '),
       CSF,
       rollback,
       NVL (row_id, ' '),
       timestamp,
       NVL (username, ' ')
  FROM v$logmnr_contents
 WHERE     SCN >= :startScn
       AND (   (    operation IN ('INSERT',
                                  'DELETE',
                                  'UPDATE',
                                  'DIRECT INSERT')
                AND (seg_name IN ('OBJ# 18',
                                  'OBJ# 262150',
                                  'OBJ# 262152',
                                  'OBJ# 262153',
                                  'OBJ# 262154',
                                  'OBJ# 262162',
                                  'OBJ# 262168',
                                  'OBJ# 262169',
                                  'OBJ# 262174',
                                  'OBJ# 262207',
                                  'OBJ# 262208',
                                  'OBJ# 262214',
                                  'OBJ# 262215',
                                  'OBJ# 262218',
                                  'OBJ# 262225',
                                  'OBJ# 262240',
								  
                                  'OBJ# 262250',
                                  'OBJ# 262255',
                                  'OBJ# 262260',
								  
                                  'OBJ# 262270',
                                  'OBJ# 262276',
                                  'OBJ# 262278',
                                  'OBJ# 262279',
								  
                                  'OBJ# 262282',
                                  'OBJ# 262285',
                                  'OBJ# 262289',
								  
                                  'OBJ# 262295',
                                  'OBJ# 262297',
                                  'OBJ# 262298',
								  
                                  'OBJ# 262300',
                                  'OBJ# 262307',
                                  'OBJ# 262309',
								  
                                  'OBJ# 262310',
                                  'OBJ# 262311',
                                  'OBJ# 262312',
                                  'OBJ# 262314',
                                  'OBJ# 262317',
								  
                                  'OBJ# 262322',
                                  'OBJ# 262323',
                                  'OBJ# 262326',
                                  'OBJ# 262327',
								  
                                  'OBJ# 262331',
                                  'OBJ# 262332',
                                  'OBJ# 262336',
                                  'OBJ# 262339',
                                  'OBJ# 262340',
								  
                                  'OBJ# 262357',
                                  'OBJ# 262358',
                                  'OBJ# 262359',
								  
                                  'OBJ# 262360',
                                  'OBJ# 262361',
                                  'OBJ# 262363',
                                  'OBJ# 262364',
                                  'OBJ# 262365',
                                  'OBJ# 262366',
                                  'OBJ# 262367',
                                  'OBJ# 262368',
                                  'OBJ# 262369',
								  
                                  'OBJ# 262370',
                                  'OBJ# 262374',
                                  'OBJ# 262376',
								  
                                  'OBJ# 262380',
                                  'OBJ# 262384',
                                  'OBJ# 262385',
                                  'OBJ# 262387',
								  
                                  'OBJ# 262390',
                                  'OBJ# 262392',
                                  'OBJ# 262396',
                                  'OBJ# 262398',
                                  'OBJ# 262399',
								  
                                  'OBJ# 262402',
                                  'OBJ# 262405',
                                  'OBJ# 262409',
								  
                                  'OBJ# 262422',
                                  'OBJ# 262423',
                                  'OBJ# 262424',
                                  'OBJ# 262426',
								  
                                  'OBJ# 262431',
                                  'OBJ# 262435',
                                  'OBJ# 262436',
                                  'OBJ# 262439',
								  
                                  'OBJ# 262441',
                                  'OBJ# 262442',
                                  'OBJ# 262444',
                                  'OBJ# 262445',
                                  'OBJ# 262446',
                                  'OBJ# 262448',
                                  'OBJ# 262456',
                                  'OBJ# 262457',
								                      --262458
                                  'OBJ# 262460',
                                  'OBJ# 262464',
                                  'OBJ# 262465',
                                  'OBJ# 262466',
                                  'OBJ# 262467',
                                  'OBJ# 262469',
								  
                                  'OBJ# 262472',
                                  'OBJ# 262473',
                                  'OBJ# 262474',
                                  'OBJ# 262476',
                                  'OBJ# 262477',
                                  'OBJ# 262478',
                                  'OBJ# 262479',
                                  'OBJ# 262480',
                                  'OBJ# 262483',
                                  'OBJ# 262484',
                                  'OBJ# 262485',
                                  'OBJ# 262486',
                                  'OBJ# 262488',
                                  'OBJ# 262489',
                                  'OBJ# 262491',
                                  'OBJ# 262492',
														--262493
                                  'OBJ# 262496',
                                  'OBJ# 262501',
                                  'OBJ# 262502',
								  
                                  'OBJ# 262522',
                                  'OBJ# 262524',
                                  'OBJ# 262525',
                                  'OBJ# 262530',
                                  'OBJ# 262534',
                                  'OBJ# 262543',
								  
                                  'OBJ# 262550',
                                  'OBJ# 262556',
                                  'OBJ# 262561',
                                  'OBJ# 262586',
                                  'OBJ# 262587',
                                  'OBJ# 262591',
                                  'OBJ# 262594',
                                  'OBJ# 262599',
                                  'OBJ# 262605',
                                  'OBJ# 262606',
                                  'OBJ# 262607',
                                  'OBJ# 262609',
                                  'OBJ# 262611',
                                  'OBJ# 262612',
                                  'OBJ# 262613',
                                  'OBJ# 262614',
                                  'OBJ# 262631',
                                  'OBJ# 262650',
                                  'OBJ# 262666',
                                  'OBJ# 262668',
                                  'OBJ# 262669',
                                  'OBJ# 262670',
                                  'OBJ# 262671',
                                  'OBJ# 262672',
                                  'OBJ# 262673',
                                  'OBJ# 262674',
                                  'OBJ# 262675',
                                  'OBJ# 262676',
                                  'OBJ# 262677',
                                  'OBJ# 262678',
                                  'OBJ# 262679',
                                  'OBJ# 262680',
                                  'OBJ# 262681',
                                  'OBJ# 262682',
                                  'OBJ# 262683',
                                  'OBJ# 262684',
                                  'OBJ# 262685',
                                  'OBJ# 262687',
                                  'OBJ# 262688',
                                  'OBJ# 262689',
                                  'OBJ# 262690',
                                  'OBJ# 262691',
                                  'OBJ# 269387',
                                  'OBJ# 275002',
                                  'OBJ# 275260',
                                  'OBJ# 280414',
                                  'OBJ# 280417',
                                  'OBJ# 280423',
                                  'OBJ# 280426',
                                  'OBJ# 280429',
                                  'OBJ# 362603',
                                  'OBJ# 364695',
                                  'OBJ# 365499',
                                  'OBJ# 439142',
                                  'OBJ# 441463',
                                  'OBJ# 767179')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))
							 
--deze zijn actief, en verversen iedere seconde !!!!!!!!!!		
--HIER ONTBREKEN DE 3 LOSSE TABELLEN DIE VANUIT 1E SESSION LOPEN !!!!!!!!					 



--***************************************************
--3E SESSION IS ACTIEF:
--******
--in een aparte sessie blijft ALLEEN volgende query draaien, zonder query log !!!
--ONDERZOEKEN WAAROM DEZE AFWIJKT VAN DE QUERY UIT VORIGE SESSIE, ER ZITTEN 3 REGELS VERSCHIL IN....
--DIT ZIJN ALLE TABELLEN !!!!!!!!


/* Formatted on 07/03/2023 09:39:24 (QP5 v5.391) */
SELECT operation,
       NVL (sql_undo, ' '),
       xidusn,
       xidslt,
       xidsqn,
       NVL (seg_name, ' '),
       SCN,
       RBASQN,
       RBABLK,
       RBABYTE,
       NVL (seg_owner, ' '),
       NVL (sql_redo, ' '),
       CSF,
       rollback,
       NVL (row_id, ' '),
       timestamp,
       NVL (username, ' ')
  FROM v$logmnr_contents
 WHERE     SCN >= :startScn
       AND (   (    operation IN ('INSERT',
                                  'DELETE',
                                  'UPDATE',
                                  'DIRECT INSERT')
                AND (seg_name IN ('OBJ# 18',
                                  'OBJ# 262150',
                                  'OBJ# 262152',
                                  'OBJ# 262153',
                                  'OBJ# 262154',
                                  'OBJ# 262162',
                                  'OBJ# 262168',
                                  'OBJ# 262169',
                                  'OBJ# 262174',
                                  'OBJ# 262207',
                                  'OBJ# 262208',
                                  'OBJ# 262214',
                                  'OBJ# 262215',
                                  'OBJ# 262218',
                                  'OBJ# 262225',
                                  'OBJ# 262240',
								  
                                  'OBJ# 262250',
                                  'OBJ# 262255',
                                  'OBJ# 262260',
								  
                                  'OBJ# 262270',
                                  'OBJ# 262276',
                                  'OBJ# 262278',
                                  'OBJ# 262279',
								  
                                  'OBJ# 262282',
                                  'OBJ# 262285',
                                  'OBJ# 262289',
								  
                                  'OBJ# 262295',
                                  'OBJ# 262297',
                                  'OBJ# 262298',
								  
                                  'OBJ# 262300',
                                  'OBJ# 262307',
                                  'OBJ# 262309',
								  
                                  'OBJ# 262310',
                                  'OBJ# 262311',
                                  'OBJ# 262312',
                                  'OBJ# 262314',
                                  'OBJ# 262317',
								  
                                  'OBJ# 262322',
                                  'OBJ# 262323',
                                  'OBJ# 262326',
                                  'OBJ# 262327',
								  
                                  'OBJ# 262331',
                                  'OBJ# 262332',
                                  'OBJ# 262336',
                                  'OBJ# 262339',
                                  'OBJ# 262340',
								  
                                  'OBJ# 262357',
                                  'OBJ# 262358',
                                  'OBJ# 262359',
								  
                                  'OBJ# 262360',
                                  'OBJ# 262361',
                                  'OBJ# 262363',
                                  'OBJ# 262364',
                                  'OBJ# 262365',
                                  'OBJ# 262366',
                                  'OBJ# 262367',
                                  'OBJ# 262368',
                                  'OBJ# 262369',
								  
                                  'OBJ# 262370',
                                  'OBJ# 262374',
                                  'OBJ# 262376',
								  
                                  'OBJ# 262380',
                                  'OBJ# 262384',
                                  'OBJ# 262385',
                                  'OBJ# 262387',
								  
                                  'OBJ# 262390',
                                  'OBJ# 262392',
                                  'OBJ# 262396',
                                  'OBJ# 262398',
                                  'OBJ# 262399',
								  
                                  'OBJ# 262402',
                                  'OBJ# 262405',
                                  'OBJ# 262409',
								  
                                  'OBJ# 262422',
                                  'OBJ# 262423',
                                  'OBJ# 262424',
                                  'OBJ# 262426',
								  
                                  'OBJ# 262431',
                                  'OBJ# 262435',
                                  'OBJ# 262436',
                                  'OBJ# 262439',
								  
                                  'OBJ# 262441',
                                  'OBJ# 262442',
                                  'OBJ# 262444',
                                  'OBJ# 262445',
                                  'OBJ# 262446',
                                  'OBJ# 262448',
								  
                                  'OBJ# 262456',
                                  'OBJ# 262457',
                                  'OBJ# 262458',   --
								  
                                  'OBJ# 262460',
                                  'OBJ# 262464',
                                  'OBJ# 262465',
                                  'OBJ# 262466',
                                  'OBJ# 262467',
                                  'OBJ# 262469',
                                  'OBJ# 262472',
                                  'OBJ# 262473',
                                  'OBJ# 262474',
                                  'OBJ# 262476',
                                  'OBJ# 262477',
                                  'OBJ# 262478',
                                  'OBJ# 262479',
								  
                                  'OBJ# 262480',
                                  'OBJ# 262483',
                                  'OBJ# 262484',
                                  'OBJ# 262485',
                                  'OBJ# 262486',
                                  'OBJ# 262488',
                                  'OBJ# 262489',
                                  'OBJ# 262490',
                                  'OBJ# 262491',
                                  'OBJ# 262492',
                                  'OBJ# 262493',   --
                                  'OBJ# 262496',
								  
                                  'OBJ# 262501',
                                  'OBJ# 262502',
								  'OBJ# 262522',
                                  'OBJ# 262524',
                                  'OBJ# 262525',
                                  'OBJ# 262530',
                                  'OBJ# 262534',
                                  'OBJ# 262543',
                                  'OBJ# 262550',
                                  'OBJ# 262556',
                                  'OBJ# 262561',
								  
                                  'OBJ# 262586',
                                  'OBJ# 262587',
                                  'OBJ# 262591',
                                  'OBJ# 262594',
                                  'OBJ# 262599',
                                  'OBJ# 262605',
                                  'OBJ# 262606',
                                  'OBJ# 262607',
                                  'OBJ# 262609',
                                  'OBJ# 262611',
                                  'OBJ# 262612',
                                  'OBJ# 262613',
                                  'OBJ# 262614',
                                  'OBJ# 262631',
                                  'OBJ# 262650',
                                  'OBJ# 262666',
                                  'OBJ# 262668',
                                  'OBJ# 262669',
                                  'OBJ# 262670',
                                  'OBJ# 262671',
                                  'OBJ# 262672',
                                  'OBJ# 262673',
                                  'OBJ# 262674',
                                  'OBJ# 262675',
                                  'OBJ# 262676',
                                  'OBJ# 262677',
                                  'OBJ# 262678',
                                  'OBJ# 262679',
                                  'OBJ# 262680',
                                  'OBJ# 262681',
                                  'OBJ# 262682',
                                  'OBJ# 262683',
                                  'OBJ# 262684',
                                  'OBJ# 262685',
                                  'OBJ# 262687',
                                  'OBJ# 262688',
                                  'OBJ# 262689',
                                  'OBJ# 262690',
                                  'OBJ# 262691',
                                  'OBJ# 269387',
                                  'OBJ# 275002',
                                  'OBJ# 275260',
                                  'OBJ# 280414',
                                  'OBJ# 280417',
                                  'OBJ# 280423',
                                  'OBJ# 280426',
                                  'OBJ# 280429',
                                  'OBJ# 362603',
                                  'OBJ# 364695',
                                  'OBJ# 365499',
                                  'OBJ# 439142',
                                  'OBJ# 441463',
                                  'OBJ# 767179')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))
							 
							 
--