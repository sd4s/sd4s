create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unrpcapi IS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION BeginTransaction        /* INTERNAL */
RETURN NUMBER;

FUNCTION EndTransaction          /* INTERNAL */
RETURN NUMBER;

FUNCTION LastError               /* INTERNAL */
RETURN NUMBER;

FUNCTION LastErrorText           /* INTERNAL */
RETURN VARCHAR2;

END unrpcapi;