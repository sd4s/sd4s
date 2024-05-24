--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function DSINTERVALTONUM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."DSINTERVALTONUM" 
(
  anInterval IN INTERVAL DAY TO SECOND
) RETURN NUMBER AS 
BEGIN

  RETURN EXTRACT(DAY    FROM anInterval) * 86400
       + EXTRACT(HOUR   FROM anInterval) *  3600
       + EXTRACT(MINUTE FROM anInterval) *    60
       + EXTRACT(SECOND FROM anInterval);

END DSINTERVALTONUM;
 

/
