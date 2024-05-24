CREATE OR REPLACE PACKAGE        AOTILDE AS

FUNCTION TildeSubTest RETURN VARCHAR2;

END AOTILDE;
/


CREATE OR REPLACE PACKAGE BODY        AOTILDE AS

FUNCTION TildeSubTest RETURN VARCHAR2 IS
   l_ret INTEGER;
   l_sql VARCHAR2(2000) := 'sc = ~sc@sc~, pg = ~pg@pg~, pgnode = ~pg@pgnode~, pa = ~pa@pa~, panode = ~pa@panode~, me = ~me@me~, menode = ~me@menode~.' ;
BEGIN
   l_ret := UNAPIGEN.SubstituteAllTildesInText (UNAPIEV.P_EV_REC.OBJECT_TP, '~EV_REC~', l_sql);
   UNAPIGEN.LogError ('TildeSubTest', l_sql);
   RETURN UNAPIGEN.DBERR_SUCCESS;
END TildeSubTest;

END AOTILDE;
/
