--view "AVERRORDETAILS"  IS invalid op ORACLEPROD dd. 08-12-2020

/*
STAND 06-12-2020:

CREATE OR REPLACE FORCE VIEW "UNILAB"."AVERRORDETAILS" ("ERROR_HASH", "DESCRIPTION", "SEVERITY", "SOLVED", "SOLUTION") AS 
SELECT  FormatHash(error_hash) AS error_hash
,       description
,       severity
,       solved
,       solution
FROM aterrordetails
;
*/

descr aterrordetails;
/*
Name        Null     Type                
----------- -------- ------------------- 
ERROR_HASH  NOT NULL NUMBER(38)          
INFO_LEVEL  NOT NULL NUMBER(1)           
DESCRIPTION          VARCHAR2(255 CHAR)  
SOLUTION             VARCHAR2(2000 CHAR) 
*/
	
CREATE OR REPLACE FORCE VIEW "UNILAB"."AVERRORDETAILS" ("ERROR_HASH", "INFO_LEVEL", "DESCRIPTION", "SOLUTION") AS 
SELECT  FormatHash(error_hash) AS error_hash
,       info_level
,       description
,       solution
FROM aterrordetails
;


prompt
prompt VIEW AVERRORHASHMAP
prompt



/* 
STAND 08-12-2020:

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
*/

/*
DESCR ATERRORHASHMAP

Name        Null     Type       
----------- -------- ---------- 
PARENT_HASH NOT NULL NUMBER(38) 
CHILD_HASH  NOT NULL NUMBER(38) 
*/
	
CREATE OR REPLACE FORCE VIEW "UNILAB"."AVERRORHASHMAP" 
( "PARENT_HASH"
, "CHILD_HASH"
, "ROOT_DESCRIPTION"
, "NODE_DESCRIPTION"
, "INFO_LEVEL"
, "INFO_LEVEL_DESCRIPTION"
, "ROOT_SOLUTION"
, "NODE_SOLUTION"
)
AS 
SELECT FormatHash(map.parent_hash) AS parent_hash
,      FormatHash(map.child_hash)  AS child_hash
,      root.description            AS root_description
,      node.description            AS node_description
,      il.info_level               AS info_level
,      il.description              AS info_level_description
,      root.solution               AS root_solution
,      node.solution               AS node_solution
FROM  aterrorhashmap map
INNER JOIN aterrordetails root ON root.error_hash = map.parent_hash
INNER JOIN aterrordetails node ON node.error_hash = map.child_hash
INNER JOIN atinfolevel    il   ON node.info_level = il.info_level
ORDER BY  map.parent_hash DESC
,         map.child_hash
;	


PROMPT EINDE SCRIPT
	
	