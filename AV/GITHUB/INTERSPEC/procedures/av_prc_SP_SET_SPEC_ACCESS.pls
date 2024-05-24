CREATE OR REPLACE PROCEDURE SP_SET_SPEC_ACCESS
IS















   LSSOURCE                      IAPITYPE.SOURCE_TYPE := 'SP_SET_SPEC_ACCESS';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   LSUSERID                      IAPITYPE.USERID_TYPE;
BEGIN
   LSUSERID := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

   IF LSUSERID IS NULL
   THEN
      LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      IAPIGENERAL.LOGERROR( LSSOURCE,
                            '',
                            IAPIGENERAL.GETLASTERRORTEXT( ) );
      RAISE_APPLICATION_ERROR( -20000,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
   END IF;

   DELETE      SPEC_ACCESS
         WHERE USER_ID = LSUSERID;

   


   INSERT INTO SPEC_ACCESS
               ( USER_ID,
                 ACCESS_GROUP,
                 MRP_UPDATE,
                 PLAN_ACCESS,
                 PROD_ACCESS,
                 PHASE_ACCESS )
      SELECT DISTINCT LSUSERID,
                      AG.ACCESS_GROUP,
                      MAX( UAG.MRP_UPDATE ),
                      MAX( NVL( AU.PLAN_ACCESS,
                                'N' ) ),
                      MAX( NVL( AU.PROD_ACCESS,
                                'N' ) ),
                      MAX( NVL( AU.PHASE_ACCESS,
                                'N' ) )
                 FROM ACCESS_GROUP AG,
                      USER_GROUP_LIST UGL,
                      USER_ACCESS_GROUP UAG,
                      USER_GROUP UG,
                      APPLICATION_USER AU
                WHERE ( AG.ACCESS_GROUP = UAG.ACCESS_GROUP )
                  AND ( UG.USER_GROUP_ID = UAG.USER_GROUP_ID )
                  AND ( UGL.USER_GROUP_ID = UG.USER_GROUP_ID )
                  AND ( UGL.USER_ID = AU.USER_ID )
                  AND ( UGL.USER_ID = LSUSERID )
             GROUP BY LSUSERID,
                      AG.ACCESS_GROUP;
EXCEPTION
   WHEN OTHERS
   THEN
      IAPIGENERAL.LOGERROR( LSSOURCE,
                            '',
                            SQLERRM );
      LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
END SP_SET_SPEC_ACCESS;