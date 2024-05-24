create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
UNAPIHSDETAILS3 AS
FUNCTION GetVersion
RETURN VARCHAR2;
PROCEDURE AddScHsDetails
(
a_old_record IN     udsc%ROWTYPE,
a_new_record IN     udsc%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddScicHsDetails
(
a_old_record IN     udscic%ROWTYPE,
a_new_record IN     udscic%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddSciiHsDetails
(
a_old_record IN     udscii%ROWTYPE,
a_new_record IN     udscii%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
END UNAPIHSDETAILS3;