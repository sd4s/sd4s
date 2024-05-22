--Checking for AWR Usage
--You can check for usage of various AWR related features in the dba_feature_usage_statistics view, for example to check for creation of Workload Repository Reports you could use the following select :

column name format a60
SELECT name,
  detected_usages,
  currently_used,
  TO_CHAR(last_sample_date,'DD-MON-YYYY:HH24:MI') last_sample
FROM dba_feature_usage_statistics
--WHERE name = 'AWR Report' 
WHERE CURRENTLY_USED = 'TRUE'
;

