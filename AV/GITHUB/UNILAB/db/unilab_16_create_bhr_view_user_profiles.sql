--ophalen van default-role bij user

CREATE OR REPLACE FORCE VIEW UNILAB.AV_BHR_USER_PROFILES
(US, PERSON, EMAIL, DEFAULT_PROFILE, UP, USER_PROFILE, LAB)
AS 
select
distinct upf.us
,        usr.person
,        usr.email
,        usr.def_up default_profile
,        upf.up
,        prf.description user_profile
,        utupuspref.pref_value lab
from     utup prf
,        utupus upf
,        utad usr
,        utupuspref
where    prf.up = upf.up
and      usr.ad = upf.us
and      utupuspref.us(+) = upf.us
and      utupuspref.up(+) = upf.up
--and      utupuspref.pref_name(+) = 'lab'
;

