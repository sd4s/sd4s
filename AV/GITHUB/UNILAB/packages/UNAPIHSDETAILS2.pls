create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
UNAPIHSDETAILS2 AS
FUNCTION GetVersion
RETURN VARCHAR2;
PROCEDURE AddRqHsDetails
(
a_old_record IN     udrq%ROWTYPE,
a_new_record IN     udrq%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddRqscHsDetails
(
a_old_record IN     UTRQSC%ROWTYPE,
a_new_record IN     UTRQSC%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddRqicHsDetails
(
a_old_record IN     udrqic%ROWTYPE,
a_new_record IN     udrqic%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddRqiiHsDetails
(
a_old_record IN     udrqii%ROWTYPE,
a_new_record IN     udrqii%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddRqppHsDetails
(
a_old_record IN     UTRQPP%ROWTYPE,
a_new_record IN     UTRQPP%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
END UNAPIHSDETAILS2;