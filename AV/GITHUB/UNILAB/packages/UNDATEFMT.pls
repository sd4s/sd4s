create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
undatefmt AS

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_ret_code        NUMBER;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_ev_seq_nr       NUMBER;
StpError          EXCEPTION;

DAY_ELEMENT           CONSTANT INTEGER := 1;
MONTH_ELEMENT         CONSTANT INTEGER := 2;
YEAR_ELEMENT          CONSTANT INTEGER := 4;
HOUR_ELEMENT          CONSTANT INTEGER := 8;
MINUTE_ELEMENT        CONSTANT INTEGER := 16;
SECOND_ELEMENT        CONSTANT INTEGER := 32;
MERIDIAN_ELEMENT      CONSTANT INTEGER := 64;
QUOTED_ELEMENT        CONSTANT INTEGER := 128;
OTHER_ELEMENT         CONSTANT INTEGER := 256;

FUNCTION GetVersion
RETURN VARCHAR2;

   FUNCTION ConvertDateFmt                       /* INTERNAL */
(a_date_format        IN OUT NOCOPY VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ConvertTimeZone                       /* INTERNAL */
(a_TimeZone        IN VARCHAR2)                /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetOracleTZFromWinTZ                       /* INTERNAL */
(a_TimeZone        IN VARCHAR2)                /* VC255_TYPE */
RETURN VARCHAR2;

FUNCTION GetOracleTZFromOffset                       /* INTERNAL */
(a_Offset        IN VARCHAR2)                /* VC255_TYPE */
RETURN VARCHAR2;

FUNCTION GetTZrelation
RETURN TZtable;

END undatefmt;