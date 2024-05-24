create or replace PACKAGE
-- Unilab 5.0 Package
-- $Revision: 2 $
-- $Date: 10/13/03 3:22p $
uncomparecustomer AS

FUNCTION GetCustomerList
(a_sc               IN VARCHAR2,                    /* VC20_TYPE */
 a_st               IN VARCHAR2,                    /* VC20_TYPE */
 a_st_version       IN VARCHAR2,                    /* VC20_TYPE */
 a_customer         OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER )                   /* NUM_TYPE */
RETURN NUMBER;



END uncomparecustomer;
 