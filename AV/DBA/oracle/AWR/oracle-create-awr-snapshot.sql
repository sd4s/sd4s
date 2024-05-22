Taking a STATSPACK or AWR snapshot
Oracle Database Tips by Donald Burleson

Question: How to I collect a STATSPACK or AWR snapshot?  How to I invoke a STATSPACK or AWR report?
Answer:  You can take a snapshot easily from the SQL*Plus prompt:
Taking an AWR snapshot (10g and beyond)

EXEC dbms_workload_repository.create_snapshot;

Taking a STATSPACK snapshot:

EXEC statspack.snap;


Step 2:  To execute a STATSPACK or AWR report, go to your $ORACLE_HOME/rdbms/admin directory and run:
awrrpt.sql
spreport.sql

Step 3:  Analyze the output with AWR Report Analysis screen.

For more notes, see:

STATSPACK Snapshot thresholds
STATSPACK Oracle SQL Snapshot thresholds
Statspack snapshot collection top SQL mechanism
Oracle Database 10g New Advisor Features
STATSPACK purge utility