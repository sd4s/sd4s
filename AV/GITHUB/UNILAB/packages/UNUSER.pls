create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 1 $
-- $Date: 05 02 21 4:23p $
unuser AS

FUNCTION GetDefaultPassword                                 /* INTERNAL */
(a_us            IN   VARCHAR2,                             /* VC4_TYPE */
 a_password      OUT  VARCHAR2)                             /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ResetPassword                                 /* INTERNAL */
(a_us            IN   VARCHAR2,                             /* VC20_TYPE */
 a_password      IN   VARCHAR2)                             /* VC20_TYPE */
RETURN NUMBER;

END unuser;
 