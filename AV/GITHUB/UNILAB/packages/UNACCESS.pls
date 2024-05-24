create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 2 $
-- $Date: 10/17/02 18:32 $
unaccess AS

FUNCTION GetVersion
RETURN VARCHAR2;


FUNCTION OldInitObjectAccessRights                          /* INTERNAL */
(a_object_tp     IN   VARCHAR2,                             /* VC4_TYPE */
 a_object_id     IN   VARCHAR2,                             /* VC20_TYPE */
 a_ar            OUT  UNAPIGEN.CHAR1_TABLE_TYPE)            /* CHAR1_TABLE_TYPE */
RETURN NUMBER;

FUNCTION UpdateAccessRights                           /* INTERNAL */
RETURN NUMBER;


FUNCTION InitObjectAccessRights                             /* INTERNAL */
(a_object_tp     IN   VARCHAR2,                             /* VC4_TYPE */
 a_object_id     IN   VARCHAR2,                             /* VC20_TYPE */
 a_ar            OUT  UNAPIGEN.CHAR1_TABLE_TYPE)            /* CHAR1_TABLE_TYPE */
RETURN NUMBER;

FUNCTION TransitionAuthorised                         /* INTERNAL */
RETURN BOOLEAN;

END unaccess;
