--conn interspc/moonflower@is61
ALTER SESSION SET CURRENT_SCHEMA=INTERPC;
--
exec INTERSPC.AAPIUTILS.restartalldbjobs;
--
-- of:
--
/*
exec INTERSPC.AAPIUTILS.stopalldbjobs;
exec INTERSPC.AAPIUTILS.startalldbjobs;
*/

prompt 
prompt einde script
prompt
