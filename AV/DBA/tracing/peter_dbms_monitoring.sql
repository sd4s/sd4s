--wat is trace-file-directory:
select value from v$diag_info where name like 'Diag Trace';

--bekijk welke traces er lopen:
select * from dba_enabled_traces;




--ENABLE TRACE for MODULE/ACTION (mn. voor de SCHEDULED-JOBS !!)
set linesize 300
set pages 999
column job_action format a150
--
SELECT JOB_NAME
,JOB_ACTION
,ENABLED
,NLS_ENV
,JOB_ACTION
FROM SYS.DBA_SCHEDULER_JOBS 
where job_name like 'UNI_J_U4EVMGR%'
;
/*
UNI_J_U4EVMGR27018             UNAPIEV.EVENTMANAGERJOB('U4EVMGR',2);                                                                                                          TRUE
UNI_J_U4EVMGR27017             UNAPIEV.EVENTMANAGERJOB('U4EVMGR',1);                                                                                                          TRUE
UNI_J_U4EVMGR27019             UNAPIEV.EVENTMANAGERJOB('U4EVMGR',3);                                                                                                          TRUE
*/

select username, module, action 
from v$session 
where username = 'UNILAB'
/*
USERNAME                       MODULE                                                           ACTION
------------------------------ ---------------------------------------------------------------- -----------------------
UNILAB                         EvMgrJob3                                                        Waiting for alert
UNILAB                         EvMgrJob901                                                      Waiting for alert
UNILAB                         EvMgrJob201                                                      Waiting for alert
UNILAB                         SQL Developer
UNILAB                         SQL*Plus
UNILAB                         Unilab2Wms.exe
UNILAB                         EvMgrJob1                                                        Waiting for alert
UNILAB                         EvMgrJob2                                                        Waiting for alert
*/

SET SERVEROUTPUT ON
--MODULE = DBMS_SCHEDULER 
define v_module = 'DBMS_SCHEDULER'
--TRACE-ACTION = JOB_NAME !!!
define v_action = 'UNI_J_U4EVMGR27017'
BEGIN
  --eerste gedeelte van sessie mn START-job:  MODULE=DBMS_SCHEDULER + ACTION UNI_J_U4EVMGR27017
  --tweede gedeelte van sessie mn EXEC-job:   MODULE=EvMgrJob1      + ACTION=<null> 
  DBMS_OUTPUT.PUT_LINE('START TRACE');
  --
  DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'DBMS_SCHEDULER' ,ACTION_NAME=>'UNI_J_U4EVMGR27017' ,waits=>TRUE ,binds=>TRUE );
  --
  DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'EvMgrJob1' ,waits=>TRUE ,binds=>TRUE );
  DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'EvMgrJob2' ,waits=>TRUE ,binds=>TRUE );
  DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'EvMgrJob3' ,waits=>TRUE ,binds=>TRUE );
  --dedicemgr201								   
  DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'EvMgrJob201' ,waits=>TRUE ,binds=>TRUE );
  --study-evmgr901
  DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'EvMgrJob901' ,waits=>TRUE ,binds=>TRUE );
  --								    
  DBMS_OUTPUT.PUT_LINE('TRACE IS GESTART');
END;
/
--zoek trace-file:
SELECT S.USERNAME, P.TRACEFILE
FROM V$SESSION S
JOIN V$PROCESS P
ON  S.PADDR = P.ADDR
WHERE S.MODULE like 'EvMgrJob%'
;


--stoppen van trace
--exec DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'EvMgrJob1' ,waits=>TRUE ,binds=>TRUE );
exec sys.DBMS_MONITOR.SERV_MOD_ACT_TRACE_DISABLE(SERVICE_NAME=>'U611', MODULE_NAME=>'EvMgrJob1');








--enable trace for SERVER:
--
SET SERVEROUTPUT ON
define v_sid = 18
define v_serial = 56367
BEGIN
  DBMS_OUTPUT.PUT_LINE('START TRACE');
  DBMS_MONITOR.SESSION_trace_enable(session_id=>&v_sid
                                   ,serial_num=>&v_serial
								   ,waits=>TRUE
                                   ,binds=>TRUE );
  DBMS_OUTPUT.PUT_LINE('TRACE IS GESTART');
END;
/
--zoek trace-file:
define v_sid = 18
define v_serial = 56367
--
SELECT P.TRACEFILE
FROM V$SESSION S
JOIN V$PROCESS P
ON  S.PADDR = P.ADDR
WHERE S.SID = &V_SID
;


BEGIN
  DBMS_OUTPUT.PUT_LINE('STOP TRACE');
  DBMS_MONITOR.SESSION_trace_disable(session_id=>&v_sid
                                    ,serial_num=>&v_serial );
  DBMS_OUTPUT.PUT_LINE('TRACE IS GESTOPT');
END;
/
/*
TRACEFILE
---------------------------------------------------------
C:\ORACLE\diag\rdbms\u611\u611\trace\u611_ora_18164.trc
*/





--Hele DATABASE in TRACE-mode:
SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE('START TRACE');
  DBMS_MONITOR.database_trace_enable( binds=>TRUE
                                    , instance_name=>'U611');
  DBMS_OUTPUT.PUT_LINE('TRACE IS GESTART');
END;
/

SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE('VOOR STOP TRACE');
  DBMS_MONITOR.database_trace_disable(instance_name=>'U611');
  DBMS_OUTPUT.PUT_LINE('TRACE IS GESTOPT');
END;
/











/*
package SYS.dbms_monitor

  ------------
  --  OVERVIEW
  --
  --  This package provides database monitoring functionality, initially
  --  in the area of statistics aggregation and SQL tracing

  --  SECURITY
  --
  --  runs with SYS privileges.

  --  CONSTANTS to be used as OPTIONS for various procedures
  --  refer comments with procedure(s) for more detail

  all_modules                    CONSTANT VARCHAR2(14) := '###ALL_MODULES';
  all_actions                    CONSTANT VARCHAR2(14) := '###ALL_ACTIONS';

  -- Indicates that tracing/aggregation for a given module should be enabled
  -- for all actions

  ----------------------------

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  PROCEDURE client_id_stat_enable(
    client_id IN VARCHAR2);

  --  Enables statistics aggregation for the given Client ID
  --  Input arguments:
  --   client_id           - Client Identifier for which the statistics
  --                         colection is enabled

  PROCEDURE client_id_stat_disable(
    client_id IN VARCHAR2);

  --  Disables statistics aggregation for the given Client ID
  --  Input arguments:
  --   client_id           - Client Identifier for which the statistics
  --                         colection is disabled

  PROCEDURE serv_mod_act_stat_enable(
    service_name IN VARCHAR2,
    module_name IN VARCHAR2,
    action_name IN VARCHAR2 DEFAULT ALL_ACTIONS);

  --  Enables statistics aggregation for the given service/module/action
  --  Input arguments:
  --   service_name        - Service Name for which the statistics
  --                         colection is enabled
  --   module_name         - Module Name for which the statistics
  --                         colection is enabled
  --   action_name         - Action Name for which the statistics
  --                         colection is enabled. The name is optional.
  --                         if omitted, statistic aggregation is enabled
  --                         for all actions in a given module

  PROCEDURE serv_mod_act_stat_disable(
    service_name IN VARCHAR2,
    module_name IN VARCHAR2,
    action_name IN VARCHAR2 DEFAULT ALL_ACTIONS);

  --  Disables statistics aggregation for the given service/module/action
  --  Input arguments:
  --   service_name        - Service Name for which the statistics
  --                         colection is disabled
  --   module_name         - Module Name for which the statistics
  --                         colection is disabled
  --   action_name         - Action Name for which the statistics
  --                         colection is disabled. The name is optional.
  --                         if omitted, statistic aggregation is disabled
  --                         for all actions in a given module

  PROCEDURE client_id_trace_enable(
    client_id IN VARCHAR2,
    waits IN BOOLEAN DEFAULT TRUE,
    binds IN BOOLEAN DEFAULT FALSE,
    plan_stat IN VARCHAR2 DEFAULT NULL);

  --  Enables SQL for the given Client ID
  --  Input arguments:
  --   client_id           - Client Identifier for which SQL trace
  --                         is enabled
  --   waits               - If TRUE, wait information will be present in the
  --                         the trace
  --   binds               - If TRUE, bind information will be present in the
  --                         the trace
  --   plan_stat           - Frequency at which we dump row source statistics.
  --                         Value should be 'never', 'first_execution'
  --                         (equivalent to NULL) or 'all_executions'.

  PROCEDURE client_id_trace_disable(
    client_id IN VARCHAR2);

  --  Disables SQL trace for the given Client ID
  --  Input arguments:
  --   client_id           - Client Identifier for which SQL trace
  --                         is disabled

  PROCEDURE serv_mod_act_trace_enable(
    service_name IN VARCHAR2,
    module_name IN VARCHAR2 DEFAULT ALL_MODULES,
    action_name IN VARCHAR2 DEFAULT ALL_ACTIONS,
    waits IN BOOLEAN DEFAULT TRUE,
    binds IN BOOLEAN DEFAULT FALSE,
    instance_name IN VARCHAR2 DEFAULT NULL,
    plan_stat IN VARCHAR2 DEFAULT NULL);

  --  Enables SQL trace for the given service/module/action
  --  Input arguments:
  --   service_name        - Service Name for which SQL trace
  --                         is enabled
  --   module_name         - Module Name for which SQL trace
  --                         is enabled. The name is optional.
  --                         if omitted, SQL trace is enabled
  --                         for all modules and actions actions in a given
  --                         service
  --   action_name         - Action Name for which SQL trace
  --                         is enabled. The name is optional.
  --                         if omitted, SQL trace is enabled
  --                         for all actions in a given module
  --   waits               - If TRUE, wait information will be present in the
  --                         the trace
  --   binds               - If TRUE, bind information will be present in the
  --                         the trace
  --   instance_name       - if set, restricts tracing to the named instance
  --   plan_stat           - Frequency at which we dump row source statistics.
  --                         Value should be 'never', 'first_execution'
  --                         (equivalent to NULL) or 'all_executions'.

  PROCEDURE serv_mod_act_trace_disable(
    service_name IN VARCHAR2,
    module_name IN VARCHAR2 DEFAULT ALL_MODULES,
    action_name IN VARCHAR2 DEFAULT ALL_ACTIONS,
    instance_name IN VARCHAR2 DEFAULT NULL);

  --  Disables SQL trace for the given service/module/action
  --  Input arguments:
  --   service_name        - Service Name for which SQL trace
  --                         is disabled
  --   module_name         - Module Name for which SQL trace
  --                         is disabled. The name is optional.
  --                         if omitted, SQL trace is disabled
  --                         for all modules and actions actions in a given
  --   action_name         - Action Name for which SQL trace
  --                         is disabled. The name is optional.
  --                         if omitted, SQL trace is disabled
  --                         for all actions in a given module
  --                         the trace
  --   instance_name       - if set, restricts disabling to the named instance

  PROCEDURE session_trace_enable(
    session_id IN BINARY_INTEGER DEFAULT NULL,
    serial_num IN BINARY_INTEGER DEFAULT NULL,
    waits IN BOOLEAN DEFAULT TRUE,
    binds IN BOOLEAN DEFAULT FALSE,
    plan_stat  IN VARCHAR2 DEFAULT NULL);

  --  Enables SQL trace for the given Session ID
  --  Input arguments:
  --   session_id          - Session Identifier for which SQL trace
  --                         is enabled. If omitted (or NULL), the
  --                         user's own session is assumed
  --   serial_num          - Session serial number for which SQL trace
  --                         is enabled. If omitted (or NULL), only
  --                         the session ID is used to determine a session
  --   waits               - If TRUE, wait information will be present in the
  --                         the trace
  --   binds               - If TRUE, bind information will be present in the
  --                         the trace
  --   plan_stat           - Frequency at which we dump row source statistics.
  --                         Value should be 'never', 'first_execution'
  --                         (equivalent to NULL) or 'all_executions'.

  PROCEDURE session_trace_disable(
    session_id IN BINARY_INTEGER DEFAULT NULL,
    serial_num IN BINARY_INTEGER DEFAULT NULL);

  --  Disables SQL trace for the given Session ID
  --  Input arguments:
  --   session_id          - Session Identifier for which SQL trace
  --                         is disabled
  --   serial_num          - Session serial number for which SQL trace
  --                         is disabled

  PROCEDURE database_trace_enable(
    waits IN BOOLEAN DEFAULT TRUE,
    binds IN BOOLEAN DEFAULT FALSE,
    instance_name IN VARCHAR2 DEFAULT NULL,
    plan_stat IN VARCHAR2 DEFAULT NULL);

  --  Enables SQL trace for the whole database or given instance
  --  Input arguments:
  --   waits               - If TRUE, wait information will be present in the
  --                         the trace
  --   binds               - If TRUE, bind information will be present in the
  --                         the trace
  --   instance_name       - if set, restricts tracing to the named instance
  --   plan_stat           - Frequency at which we dump row source statistics.
  --                         Value should be 'never', 'first_execution'
  --                         (equivalent to NULL) or 'all_executions'.


  PROCEDURE database_trace_disable(
    instance_name IN VARCHAR2 DEFAULT NULL);

  --  Disables SQL trace for the whole database or given instance
  --  Input arguments:
  --   instance_name       - if set, restricts disabling to the named instance
*/


