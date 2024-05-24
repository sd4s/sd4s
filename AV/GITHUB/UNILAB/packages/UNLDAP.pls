create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 1 $
-- $Date: 05 02 21 4:23p $
unldap AS

FUNCTION GetUserList                                          /* INTERNAL */
(a_dn            OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_display_name  OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_connect_id    OUT     UNAPIGEN.VC20_TABLE_TYPE,            /* VC20_TABLE_TYPE */
 a_email         OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                              /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                            /* VC511_TYPE */
RETURN NUMBER;

END unldap;
 