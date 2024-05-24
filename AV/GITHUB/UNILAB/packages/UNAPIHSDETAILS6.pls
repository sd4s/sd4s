create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
UNAPIHSDETAILS6 AS
FUNCTION GetVersion
RETURN VARCHAR2;
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
END UNAPIHSDETAILS6;