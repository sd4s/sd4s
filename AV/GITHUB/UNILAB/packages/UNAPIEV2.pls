create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiev2 AS

l_qualifier_table             UNAPIGEN.VC255_TABLE_TYPE;
l_qualifier_vaL_table         UNAPIGEN.VC255_TABLE_TYPE;
l_qualifier_nr_of_rows        NUMBER;
l_current_timestamp           TIMESTAMP WITH TIME ZONE;
l_sqlerrm                     VARCHAR2(255); --no exception handlers in UNAPIEV3
l_event_processed             BOOLEAN;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION EventManager          /* INTERNAL */
(a_tr_seq IN NUMBER)
RETURN NUMBER;

END unapiev2;