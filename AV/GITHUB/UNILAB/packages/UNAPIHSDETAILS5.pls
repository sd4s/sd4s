create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
UNAPIHSDETAILS5 AS
FUNCTION GetVersion
RETURN VARCHAR2;
PROCEDURE AddScpaHsDetails
(
a_old_record IN     udscpa%ROWTYPE,
a_new_record IN     udscpa%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddScpgHsDetails
(
a_old_record IN     udscpg%ROWTYPE,
a_new_record IN     udscpg%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
END UNAPIHSDETAILS5;