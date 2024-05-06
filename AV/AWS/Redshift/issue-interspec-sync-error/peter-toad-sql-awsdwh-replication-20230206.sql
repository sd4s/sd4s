--***************************************************
--SESSION RETRIEVING THE CURRENT_SCN
--***************************************************
/* Formatted on 06/03/2023 17:24:54 (QP5 v5.391) */
SELECT current_scn FROM v$database


--**********************************************
--SESSION SEARCHING FOR THE LOGMNR 
--**********************************************

/* Formatted on 06/03/2023 17:26:33 (QP5 v5.391) */
BEGIN
    SYS.DBMS_LOGMNR.END_LOGMNR ();
END;

/* Formatted on 07/03/2023 09:20:49 (QP5 v5.391) */
BEGIN
    sys.DBMS_LOGMNR.ADD_LOGFILE ( :logfile, sys.DBMS_LOGMNR.NEW);
END;

/* Formatted on 07/03/2023 09:19:16 (QP5 v5.391) */
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

/* Formatted on 07/03/2023 09:20:08 (QP5 v5.391) */
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
                AND (seg_name IN ('OBJ# 18', 'OBJ# 231877')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))
							 
--CONCLUSION: Only looking the OBJ# 18 + 231877	??



--*******************************************************************
--SESSION RETRIEVING TIMESTAMP
--*******************************************************************

/* Formatted on 06/03/2023 17:27:18 (QP5 v5.391) */
SELECT SUM (
             EXTRACT (DAY FROM (timestamp_diff)) * 24 * 60 * 60
           + (EXTRACT (HOUR FROM timestamp_diff)) * 3600
           + (EXTRACT (MINUTE FROM timestamp_diff)) * 60
           + EXTRACT (SECOND FROM timestamp_diff))
  FROM ( (SELECT (  TO_TIMESTAMP (
                        TO_CHAR (SYSTIMESTAMP, 'DD.MM.YYYY:HH24:MI:SS.FF'),
                        'DD.MM.YYYY:HH24:MI:SS.FF')
                  - TO_TIMESTAMP ('01.01.1970:00:00:00.000',
                                  'DD.MM.YYYY:HH24:MI:SS.FF'))    timestamp_diff
            FROM DUAL))
			
			


/* Formatted on 06/03/2023 17:23:04 (QP5 v5.391) */
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
                                  'OBJ# 87827',
                                  'OBJ# 87833',
                                  'OBJ# 87837',
                                  'OBJ# 87840',
                                  'OBJ# 87851',
                                  'OBJ# 87852',
                                  'OBJ# 87855',
                                  'OBJ# 87857',
                                  'OBJ# 87859',
                                  'OBJ# 87860',
                                  'OBJ# 87874',
                                  'OBJ# 87876',
                                  'OBJ# 87878',
                                  'OBJ# 87887',
                                  'OBJ# 87890',
                                  'OBJ# 87900',
                                  'OBJ# 87903',
                                  'OBJ# 87906',
                                  'OBJ# 87907',
                                  'OBJ# 87911',
                                  'OBJ# 87918',
                                  'OBJ# 87920',
                                  'OBJ# 87922',
                                  'OBJ# 87923',
                                  'OBJ# 87927',
                                  'OBJ# 87928',
                                  'OBJ# 87929',
                                  'OBJ# 87930',
                                  'OBJ# 87932',
                                  'OBJ# 87935',
                                  'OBJ# 87937',
                                  'OBJ# 87939',
                                  'OBJ# 87940',
                                  'OBJ# 87942',
                                  'OBJ# 87945',
                                  'OBJ# 87947',
                                  'OBJ# 87948',
                                  'OBJ# 87950',
                                  'OBJ# 87952',
                                  'OBJ# 87953',
                                  'OBJ# 87958',
                                  'OBJ# 87959',
                                  'OBJ# 87973',
                                  'OBJ# 87991',
                                  'OBJ# 88001',
                                  'OBJ# 88002',
                                  'OBJ# 88003',
                                  'OBJ# 88034',
                                  'OBJ# 88036',
                                  'OBJ# 88041',
                                  'OBJ# 88045',
                                  'OBJ# 88054',
                                  'OBJ# 88059',
                                  'OBJ# 88104',
                                  'OBJ# 88105',
                                  'OBJ# 88113',
                                  'OBJ# 88120',
                                  'OBJ# 88122',
                                  'OBJ# 88123',
                                  'OBJ# 88125',
                                  'OBJ# 88126',
                                  'OBJ# 88128',
                                  'OBJ# 88135',
                                  'OBJ# 88136',
                                  'OBJ# 88138',
                                  'OBJ# 88150',
                                  'OBJ# 88152',
                                  'OBJ# 88153',
                                  'OBJ# 88156',
                                  'OBJ# 88159',
                                  'OBJ# 88167',
                                  'OBJ# 88168',
                                  'OBJ# 88181',
                                  'OBJ# 88182',
                                  'OBJ# 88183',
                                  'OBJ# 88194',
                                  'OBJ# 88274',
                                  'OBJ# 88275',
                                  'OBJ# 88279',
                                  'OBJ# 88281',
                                  'OBJ# 231877')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))

/* Formatted on 06/03/2023 17:23:27 (QP5 v5.391) */
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

							 
/* Formatted on 06/03/2023 17:23:40 (QP5 v5.391) */
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
                                  'OBJ# 87827',
                                  'OBJ# 87833',
                                  'OBJ# 87837',
                                  'OBJ# 87840',
                                  'OBJ# 87851',
                                  'OBJ# 87852',
                                  'OBJ# 87855',
                                  'OBJ# 87857',
                                  'OBJ# 87859',
                                  'OBJ# 87860',
                                  'OBJ# 87874',
                                  'OBJ# 87876',
                                  'OBJ# 87878',
                                  'OBJ# 87887',
                                  'OBJ# 87890',
                                  'OBJ# 87900',
                                  'OBJ# 87903',
                                  'OBJ# 87906',
                                  'OBJ# 87907',
                                  'OBJ# 87911',
                                  'OBJ# 87918',
                                  'OBJ# 87920',
                                  'OBJ# 87922',
                                  'OBJ# 87923',
                                  'OBJ# 87927',
                                  'OBJ# 87928',
                                  'OBJ# 87929',
                                  'OBJ# 87930',
                                  'OBJ# 87932',
                                  'OBJ# 87935',
                                  'OBJ# 87937',
                                  'OBJ# 87939',
                                  'OBJ# 87940',
                                  'OBJ# 87942',
                                  'OBJ# 87945',
                                  'OBJ# 87947',
                                  'OBJ# 87948',
                                  'OBJ# 87950',
                                  'OBJ# 87952',
                                  'OBJ# 87953',
                                  'OBJ# 87958',
                                  'OBJ# 87959',
                                  'OBJ# 87973',
                                  'OBJ# 87991',
                                  'OBJ# 88001',
                                  'OBJ# 88002',
                                  'OBJ# 88003',
                                  'OBJ# 88034',
                                  'OBJ# 88036',
                                  'OBJ# 88041',
                                  'OBJ# 88045',
                                  'OBJ# 88054',
                                  'OBJ# 88059',
                                  'OBJ# 88104',
                                  'OBJ# 88105',
                                  'OBJ# 88113',
                                  'OBJ# 88120',
                                  'OBJ# 88122',
                                  'OBJ# 88123',
                                  'OBJ# 88125',
                                  'OBJ# 88126',
                                  'OBJ# 88128',
                                  'OBJ# 88135',
                                  'OBJ# 88136',
                                  'OBJ# 88138',
                                  'OBJ# 88150',
                                  'OBJ# 88152',
                                  'OBJ# 88153',
                                  'OBJ# 88156',
                                  'OBJ# 88159',
                                  'OBJ# 88167',
                                  'OBJ# 88168',
                                  'OBJ# 88181',
                                  'OBJ# 88182',
                                  'OBJ# 88183',
                                  'OBJ# 88194',
                                  'OBJ# 88274',
                                  'OBJ# 88275',
                                  'OBJ# 88279',
                                  'OBJ# 88281')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))


/* Formatted on 06/03/2023 17:24:03 (QP5 v5.391) */
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
 WHERE     (   (    ((    owner LIKE 'INTERSPC'
                      AND table_name LIKE 'AVSPECIFICATION_WEIGHT'))
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
							 
							 
/* Formatted on 06/03/2023 17:24:38 (QP5 v5.391) */
SELECT NVL (owner, ' ')        OWNER,
       NVL (table_name, ' ')   NAME,
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
 WHERE     (   (    (   (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ACCESS_GROUP')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ASSOCIATION')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ATFUNCBOM')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ATFUNCBOMDATA')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ATFUNCBOMWORKAREA')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ATTACHED_SPECIFICATION')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ATTRIBUTE')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'AVARTICLEPRICES')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'BOM_HEADER')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'BOM_ITEM')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'CHARACTERISTIC')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'CHARACTERISTIC_ASSOCIATION')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'CLASS3')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'FRAME_HEADER')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'FRAME_KW')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'FRAME_PROP')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'FRAME_SECTION')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'HEADER')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'HEADER_H')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITBOMLY')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ITBOMLYITEM')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ITBOMLYSOURCE')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITCLAT')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITCLD')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITCLTV')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITFRMDEL')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITKW')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITKWAS')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITKWCH')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITLANG')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ITLIMSCONFLY')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ITLIMSJOB')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ITLIMSTMP')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITMFC')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITMFCMPL')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITMPL')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITOID')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITOIH')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITPLGRP')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'ITPLGRPLIST')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITPP_DEL')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITPRCL')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITPRMFC')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITSHDEL')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITSHQ')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITUP')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'ITUS')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'LAYOUT')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'MATERIAL_CLASS')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'PART')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PART_PLANT')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'PLANT')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'PROPERTY')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_DISPLAY')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_GROUP')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_GROUP_DISPLAY')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_GROUP_H')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_GROUP_LIST')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_H')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_LAYOUT')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'PROPERTY_TEST_METHOD')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'REASON')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'REF_TEXT_TYPE')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'SECTION')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'SECTION_H')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'SPECDATA')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'SPECIFICATION_HEADER')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'SPECIFICATION_KW')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'SPECIFICATION_PROP')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'SPECIFICATION_SECTION')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'STATUS')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'STATUS_HISTORY')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'SUB_SECTION')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'SUB_SECTION_H')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'TEST_METHOD')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'TEXT_TYPE')
                     OR (owner LIKE 'INTERSPC' AND table_name LIKE 'UOM')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'USER_GROUP')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'USER_GROUP_LIST')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'APPROVAL_HISTORY')
                     OR (    owner LIKE 'INTERSPC'
                         AND table_name LIKE 'AVSPECIFICATION_WEIGHT'))
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


SELECT object_id
  FROM all_objects
 WHERE owner = 'SYS' AND object_name = 'OBJ$'



--2 running queries
/* Formatted on 07/03/2023 09:15:12 (QP5 v5.391) */
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
                                  'OBJ# 87827',
                                  'OBJ# 87833',
                                  'OBJ# 87837',
                                  'OBJ# 87840',
                                  'OBJ# 87851',
                                  'OBJ# 87852',
                                  'OBJ# 87855',
                                  'OBJ# 87857',
                                  'OBJ# 87859',
                                  'OBJ# 87860',
                                  'OBJ# 87874',
                                  'OBJ# 87876',
                                  'OBJ# 87878',
                                  'OBJ# 87887',
                                  'OBJ# 87890',
                                  'OBJ# 87900',
                                  'OBJ# 87903',
                                  'OBJ# 87906',
                                  'OBJ# 87907',
                                  'OBJ# 87911',
                                  'OBJ# 87918',
                                  'OBJ# 87920',
                                  'OBJ# 87922',
                                  'OBJ# 87923',
                                  'OBJ# 87927',
                                  'OBJ# 87928',
                                  'OBJ# 87929',
                                  'OBJ# 87930',
                                  'OBJ# 87932',
                                  'OBJ# 87935',
                                  'OBJ# 87937',
                                  'OBJ# 87939',
                                  'OBJ# 87940',
                                  'OBJ# 87942',
                                  'OBJ# 87945',
                                  'OBJ# 87947',
                                  'OBJ# 87948',
                                  'OBJ# 87950',
                                  'OBJ# 87952',
                                  'OBJ# 87953',
                                  'OBJ# 87958',
                                  'OBJ# 87959',
                                  'OBJ# 87973',
                                  'OBJ# 87991',
                                  'OBJ# 88001',
                                  'OBJ# 88002',
                                  'OBJ# 88003',
                                  'OBJ# 88034',
                                  'OBJ# 88036',
                                  'OBJ# 88041',
                                  'OBJ# 88045',
                                  'OBJ# 88054',
                                  'OBJ# 88059',
                                  'OBJ# 88104',
                                  'OBJ# 88105',
                                  'OBJ# 88113',
                                  'OBJ# 88120',
                                  'OBJ# 88122',
                                  'OBJ# 88123',
                                  'OBJ# 88125',
                                  'OBJ# 88126',
                                  'OBJ# 88128',
                                  'OBJ# 88135',
                                  'OBJ# 88136',
                                  'OBJ# 88138',
                                  'OBJ# 88150',
                                  'OBJ# 88152',
                                  'OBJ# 88153',
                                  'OBJ# 88156',
                                  'OBJ# 88159',
                                  'OBJ# 88167',
                                  'OBJ# 88168',
                                  'OBJ# 88181',
                                  'OBJ# 88182',
                                  'OBJ# 88183',
                                  'OBJ# 88194',
                                  'OBJ# 88274',
                                  'OBJ# 88275',
                                  'OBJ# 88279',
                                  'OBJ# 88281')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT'))
							 
							 
							 
/* Formatted on 07/03/2023 09:15:50 (QP5 v5.391) */
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
                                  'OBJ# 87827',
                                  'OBJ# 87833',
                                  'OBJ# 87837',
                                  'OBJ# 87840',
                                  'OBJ# 87851',
                                  'OBJ# 87852',
                                  'OBJ# 87855',
                                  'OBJ# 87857',
                                  'OBJ# 87859',
                                  'OBJ# 87860',
                                  'OBJ# 87874',
                                  'OBJ# 87876',
                                  'OBJ# 87878',
                                  'OBJ# 87887',
                                  'OBJ# 87890',
                                  'OBJ# 87900',
                                  'OBJ# 87903',
                                  'OBJ# 87906',
                                  'OBJ# 87907',
                                  'OBJ# 87911',
                                  'OBJ# 87918',
                                  'OBJ# 87920',
                                  'OBJ# 87922',
                                  'OBJ# 87923',
                                  'OBJ# 87927',
                                  'OBJ# 87928',
                                  'OBJ# 87929',
                                  'OBJ# 87930',
                                  'OBJ# 87932',
                                  'OBJ# 87935',
                                  'OBJ# 87937',
                                  'OBJ# 87939',
                                  'OBJ# 87940',
                                  'OBJ# 87942',
                                  'OBJ# 87945',
                                  'OBJ# 87947',
                                  'OBJ# 87948',
                                  'OBJ# 87950',
                                  'OBJ# 87952',
                                  'OBJ# 87953',
                                  'OBJ# 87958',
                                  'OBJ# 87959',
                                  'OBJ# 87973',
                                  'OBJ# 87991',
                                  'OBJ# 88001',
                                  'OBJ# 88002',
                                  'OBJ# 88003',
                                  'OBJ# 88034',
                                  'OBJ# 88036',
                                  'OBJ# 88041',
                                  'OBJ# 88045',
                                  'OBJ# 88054',
                                  'OBJ# 88059',
                                  'OBJ# 88104',
                                  'OBJ# 88105',
                                  'OBJ# 88113',
                                  'OBJ# 88120',
                                  'OBJ# 88122',
                                  'OBJ# 88123',
                                  'OBJ# 88125',
                                  'OBJ# 88126',
                                  'OBJ# 88128',
                                  'OBJ# 88135',
                                  'OBJ# 88136',
                                  'OBJ# 88138',
                                  'OBJ# 88150',
                                  'OBJ# 88152',
                                  'OBJ# 88153',
                                  'OBJ# 88156',
                                  'OBJ# 88159',
                                  'OBJ# 88167',
                                  'OBJ# 88168',
                                  'OBJ# 88181',
                                  'OBJ# 88182',
                                  'OBJ# 88183',
                                  'OBJ# 88194',
                                  'OBJ# 88274',
                                  'OBJ# 88275',
                                  'OBJ# 88279',
                                  'OBJ# 88281',
                                  'OBJ# 231877')))
            OR operation IN ('START',
                             'COMMIT',
                             'ROLLBACK',
                             'DDL',
                             'DPI SAVEPOINT',
                             'DPI ROLLBACK SAVEPOINT')) 
							 
--CONCLUSIE:
--Er RUNNEN 2x QUERY met nagenoeg zelfde OBJ#-segments.
--Enige verschil lijkt OBJ# 231877 te zijn....

--peter queries:
select * from all_objects where object_name ='AVSPECIFICATION_WEIGHT';
owner       object_name                 object_id data_object_id 
INTERSPC	AVSPECIFICATION_WEIGHT		231877	  231877	     TABLE	08-07-2018 15:13:17	23-01-2023 14:14:24	2022-12-15:14:08:02	VALID	N	N	N	1	

select * from all_objects where OBJECT_ID=18
= OBJ$




							 