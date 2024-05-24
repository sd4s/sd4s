create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.4.0 (V06.04.00.00_24.01) $
-- $Date: 2009-04-20T16:24:00 $
unapiplan AS

FUNCTION GetVersion
RETURN VARCHAR2;


PROCEDURE SamplePlanner
(a_start_date       IN  DATE,
 a_end_date         IN  DATE,
 a_incr             IN  NUMBER);

FUNCTION StartSamplePlanner
(a_first_run        IN VARCHAR2,
 a_next_run         IN VARCHAR2,
 a_start_date       IN VARCHAR2,
 a_end_date         IN VARCHAR2,
 a_incr             IN NUMBER)
RETURN NUMBER;

FUNCTION StopSamplePlanner
RETURN NUMBER;

P_TRACING_ON     BOOLEAN;
P_SIMULATE_ONLY  BOOLEAN;

END unapiplan;
