--conn unilab/moonflower@u611
ALTER SESSION SET CURRENT_SCHEMA=UNILAB;
--
exec UNILAB.CXAPP.restartalldbjabs;
--
-- of:
--
/*
exec UNILAB.CXAPP.stopalldbjobs;
exec UNILAB.CXAPP.startalldbjobs;
*/

prompt 
prompt einde script
prompt
