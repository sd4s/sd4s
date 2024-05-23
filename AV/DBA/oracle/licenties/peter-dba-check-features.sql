--Checking for AWR Usage
--You can check for usage of various AWR related features in the dba_feature_usage_statistics view, for example to check for creation of Workload Repository Reports you could use the following select :

column name format a60
column name format a60
SELECT name,
  detected_usages,
  currently_used,
  TO_CHAR(last_sample_date,'DD-MON-YYYY:HH24:MI') last_sample
FROM dba_feature_usage_statistics
--WHERE name = 'AWR Report' 
WHERE CURRENTLY_USED = 'TRUE'
and last_sample_date > to_date('01-09-2020','dd-mm-yyyy')
;

/*
--UNILAB:
NAME									DETAECTED-USAGES	CURRENTLY-USED	LAST_SAMPLE
Server Parameter File									78	TRUE	03-OKT-2020:01:40
Character Semantics										78	TRUE	03-OKT-2020:01:40
Character Set											78	TRUE	03-OKT-2020:01:40
Locally Managed Tablespaces (system)					78	TRUE	03-OKT-2020:01:40
Locally Managed Tablespaces (user)						78	TRUE	03-OKT-2020:01:40
Oracle Managed Files									78	TRUE	03-OKT-2020:01:40
Partitioning (system)									78	TRUE	03-OKT-2020:01:40
Recovery Area											78	TRUE	03-OKT-2020:01:40
Recovery Manager (RMAN)									77	TRUE	03-OKT-2020:01:40
RMAN - Disk Backup										77	TRUE	03-OKT-2020:01:40
Logfile Multiplexing									78	TRUE	03-OKT-2020:01:40
Virtual Private Database (VPD)							78	TRUE	03-OKT-2020:01:40
LOB														78	TRUE	03-OKT-2020:01:40
Object													78	TRUE	03-OKT-2020:01:40
SecureFiles (user)										78	TRUE	03-OKT-2020:01:40
SecureFiles (system)									78	TRUE	03-OKT-2020:01:40
Oracle Java Virtual Machine (user)						78	TRUE	03-OKT-2020:01:40
Oracle Java Virtual Machine (system)					78	TRUE	03-OKT-2020:01:40
Automatic Undo Management								78	TRUE	03-OKT-2020:01:40
Deferred Segment Creation								78	TRUE	03-OKT-2020:01:40
Job Scheduler											77	TRUE	03-OKT-2020:01:40
Oracle Utility Metadata API								8	TRUE	03-OKT-2020:01:40
Extensibility											19	TRUE	03-OKT-2020:01:40
Audit Options											78	TRUE	03-OKT-2020:01:40
Automatic Maintenance - Optimizer Statistics Gathering	78	TRUE	03-OKT-2020:01:40
Automatic Maintenance - Space Advisor					78	TRUE	03-OKT-2020:01:40
Automatic Segment Space Management (system)				78	TRUE	03-OKT-2020:01:40
Automatic Segment Space Management (user)				78	TRUE	03-OKT-2020:01:40*/


