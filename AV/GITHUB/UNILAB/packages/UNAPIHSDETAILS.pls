create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
UNAPIHSDETAILS AS
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
PROCEDURE AddScmeHsDetails
(
a_old_record IN     udscme%ROWTYPE,
a_new_record IN     udscme%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddScmecellHsDetails
(
a_old_record IN     UTSCMECELL%ROWTYPE,
a_new_record IN     UTSCMECELL%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddScmecelllistHsDetails
(
a_old_record IN     UTSCMECELLLIST%ROWTYPE,
a_new_record IN     UTSCMECELLLIST%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
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
PROCEDURE AddSdHsDetails
(
a_old_record IN     udsd%ROWTYPE,
a_new_record IN     udsd%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddSdicHsDetails
(
a_old_record IN     udsdic%ROWTYPE,
a_new_record IN     udsdic%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
PROCEDURE AddSdiiHsDetails
(
a_old_record IN     udsdii%ROWTYPE,
a_new_record IN     udsdii%ROWTYPE,
a_tr_seq     IN     NUMBER,
a_ev_seq     IN     NUMBER,
a_start_seq  IN OUT NUMBER) ;
END UNAPIHSDETAILS;