/*
How to trace Oracle bind variable values?
Oracle Database Tips by Donald Burleson
People often ask how to do tracing of the values of bind variables in Oracle SQL statements.  I devote many pages to tracing SQL my book "Oracle Tuning: The Definitive Reference", but this is a quick overview of tracing bind variable values.
There are several ways to display bind variable values in a debugging trace.  Note that TKPROF SQL trace (dbms_system.set_sql_trace_in_session) will not display bind variable values and you need to use a 10046 trace or the v$sql_bind_caprure view to see bind variable contents.
Using 10046 trace for tracing bind variable values
You can run a 10046 level 4 trace to debug code with bind variables and see the bind variable values as it steps through the code:
*/
EXECUTE sys.dbms_system.set_ev ('||SID||','||SERIAL#||',10046,4,'''')
/*
Using v$sql_bind_capture for tracing bind variable values
A new interesting view, v$sql_bind_capture, has been introduced to report information on bind variables used by SQL cursors. This view allows the retrieval of the actual values of bind variables for a given SQL cursor.
The script below can be used to retrieve list of bind variables and the corresponding actual values used for a particular SQL statement. This query uses the sql_id address that should be specified for each unique SQL statement (you can get the SQL ID from the v$sql view):
*/

SELECT a.sql_text
,      b.name
,      b.position
,      b.datatype_string
,      b.value_string
FROM  v$sql_bind_capture b
,     v$sqlarea          a
WHERE b.sql_id = 'dpf3w96us2797'
AND   b.sql_id = a.sql_id
;

/*
The following is a sample output:

SQL_TEXT                                           NAME      POSITION DATATYPE_STRING VALUE_STRING
-------------------------------------------------- ---------- ------- ------------
select owner, object_type, count (*) from all_obje :PAR             1 VARCHAR2(4000)  SYS%
cts where owner not like :par and object_type = :o
bjtype group by owner,object_type order by 1,2,3
 
select owner, object_type, count (*) from all_obje :OBJTYPE         2 VARCHAR2(4000)  TABLE
cts where owner not like :par and object_type = :o
bjtype group by owner,object_type order by 1,2,3
*/

