--view om aantallen log-switches te kunnen bekijken.
--Indien aantallen te groot zijn dan is er een onderliggend probleem wat opgelost moet worden.

--conn sys as sysdba

/*
Name                                      Null?    Type
----------------------------------------- -------- ----------------
NAME                                               VARCHAR2(513)
SPACE_LIMIT                                        NUMBER
SPACE_USED                                         NUMBER
SPACE_RECLAIMABLE                                  NUMBER
NUMBER_OF_FILES                                    NUMBER
*/


CREATE OR REPLACE VIEW AV_DBA_MONITOR_ARCHLOG_SPACE
AS
SELECT NAME
, TRUNC(SPACE_LIMIT  / 1024 / 1024 / 1024) SPACE_LIMIT_GB
, TRUNC(SPACE_USED   / 1024 / 1024 / 1024) SPACE_USED_GB
, TRUNC( (SPACE_LIMIT - SPACE_USED) /1024/1024/1024) SPACE_AVAILABLE_GB
, SPACE_RECLAIMABLE
, NUMBER_OF_FILES
from  v$RECOVERY_FILE_DEST
;


--grants + synonyms
grant select on AV_DBA_MONITOR_ARCHLOG_SPACE to system   with grant option;
grant select on AV_DBA_MONITOR_ARCHLOG_SPACE to interspc with grant option;
grant select on AV_DBA_MONITOR_ARCHLOG_SPACE to unilab   with grant option;

prompt
prompt create INTERSPC/UNILAB-VIEW
prompt


CREATE OR REPLACE VIEW INTERSPC.AV_DBA_MONITOR_ARCHLOG_SPACE
AS
SELECT * FROM SYS.AV_DBA_MONITOR_ARCHLOG_SPACE
;

CREATE OR REPLACE VIEW UNILAB.AV_DBA_MONITOR_ARCHLOG_SPACE
AS
SELECT * FROM SYS.AV_DBA_MONITOR_ARCHLOG_SPACE
;



--einde script
