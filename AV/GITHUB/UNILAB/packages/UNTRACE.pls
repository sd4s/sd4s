create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.4.0 (V06.04.00.00_24.01) $
-- $Date: 2009-04-20T16:24:00 $
untrace AS

P_TRACE_MODE   VARCHAR2(20);
P_TRACE_FILE   VARCHAR2(200);
P_TRACE_PIPE   VARCHAR2(40);
P_TRACE_DIR    VARCHAR2(255);

FUNCTION TraceOn             /* INTERNAL */
(a_trace_mode IN VARCHAR2)
RETURN NUMBER;

FUNCTION TraceOff            /* INTERNAL */
RETURN NUMBER;

PROCEDURE Log                /* INTERNAL */
(a_message IN VARCHAR2);

PROCEDURE ReceiveLog;        /* INTERNAL */

FUNCTION EvTraceOn           /* INTERNAL */
(a_trace_mode IN VARCHAR2)
RETURN NUMBER;

FUNCTION EvTraceOff          /* INTERNAL */
RETURN NUMBER;

FUNCTION GetVersion
RETURN VARCHAR2;

END untrace;