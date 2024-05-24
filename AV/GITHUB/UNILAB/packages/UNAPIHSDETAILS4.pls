create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
UNAPIHSDETAILS4 AS
FUNCTION GetVersion
RETURN VARCHAR2;
PROCEDURE AddWsHsDetails
(
a_old_record IN     udws%ROWTYPE,
a_new_record IN     udws%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddChHsDetails
(
a_old_record IN     udch%ROWTYPE,
a_new_record IN     udch%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddChdpHsDetails
(
a_old_record IN     UTCHDP%ROWTYPE,
a_new_record IN     UTCHDP%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
END UNAPIHSDETAILS4;