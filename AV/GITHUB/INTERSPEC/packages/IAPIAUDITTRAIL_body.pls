CREATE OR REPLACE PACKAGE BODY iapiAuditTrail
AS












   FUNCTION GETPACKAGEVERSION

   RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN



      RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.0 (06.07.00.00-01.00) $)' );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;








   
   FUNCTION GETUSERINFO(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASFORENAME                 OUT      IAPITYPE.FORENAME_TYPE,
      ASLASTNAME                 OUT      IAPITYPE.LASTNAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUserHsAddUserPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LQUSERINFO(
         ASUSERID                   IN       APPLICATION_USER.USER_ID%TYPE )
      IS
         SELECT FORENAME,
                LAST_NAME
           FROM APPLICATION_USER
          WHERE USER_ID = ASUSERID;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LQUSERINFO%ISOPEN )
      THEN
         CLOSE LQUSERINFO;
      END IF;

      
      FOR LRUSERINFO IN LQUSERINFO( ASUSERID )
      LOOP
         ASFORENAME := LRUSERINFO.FORENAME;
         ASLASTNAME := LRUSERINFO.LAST_NAME;
      END LOOP;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERINFO;


   FUNCTION FILLUSERAUDITTRAILDETAILS(
      ASUSERIDCHANGED            IN       IAPITYPE.USERID_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITUP%ROWTYPE,
      ARNEWVALUE                 IN       ITUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillUserAuditTrailDetails';
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITUSHSDETAILS
                  ( USER_ID_CHANGED,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ASUSERIDCHANGED,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLUSERAUDITTRAILDETAILS;


   FUNCTION GETSEQUENCE(
      ANAUDITTRAILSEQUENCENR     OUT      IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSequence';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ITAUDIT_TRAIL_SEQ.NEXTVAL
        INTO ANAUDITTRAILSEQUENCENR
        FROM DUAL;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSEQUENCE;


   FUNCTION FILLAUDITTRAILDETAILS(
      ASUSERIDCHANGED            IN       IAPITYPE.USERID_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       APPLICATION_USER%ROWTYPE,
      ARNEWVALUE                 IN       APPLICATION_USER%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillAuditTrailDetails';
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITUSHSDETAILS
                  ( USER_ID_CHANGED,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ASUSERIDCHANGED,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.FORENAME <> ARNEWVALUE.FORENAME ),
                  TRUE )
         AND NOT(     AROLDVALUE.FORENAME IS NULL
                  AND ARNEWVALUE.FORENAME IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Forename> changed value from <'
                       || AROLDVALUE.FORENAME
                       || '> to <'
                       || ARNEWVALUE.FORENAME
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.LAST_NAME <> ARNEWVALUE.LAST_NAME ),
                  TRUE )
         AND NOT(     AROLDVALUE.LAST_NAME IS NULL
                  AND ARNEWVALUE.LAST_NAME IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Last Name> changed value from <'
                       || AROLDVALUE.LAST_NAME
                       || '> to <'
                       || ARNEWVALUE.LAST_NAME
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.USER_INITIALS <> ARNEWVALUE.USER_INITIALS ),
                  TRUE )
         AND NOT(     AROLDVALUE.USER_INITIALS IS NULL
                  AND ARNEWVALUE.USER_INITIALS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <User Initials> changed value from <'
                       || AROLDVALUE.USER_INITIALS
                       || '> to <'
                       || ARNEWVALUE.USER_INITIALS
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.TELEPHONE_NO <> ARNEWVALUE.TELEPHONE_NO ),
                  TRUE )
         AND NOT(     AROLDVALUE.TELEPHONE_NO IS NULL
                  AND ARNEWVALUE.TELEPHONE_NO IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Telephone> changed value from <'
                       || AROLDVALUE.TELEPHONE_NO
                       || '> to <'
                       || ARNEWVALUE.TELEPHONE_NO
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.EMAIL_ADDRESS <> ARNEWVALUE.EMAIL_ADDRESS ),
                  TRUE )
         AND NOT(     AROLDVALUE.EMAIL_ADDRESS IS NULL
                  AND ARNEWVALUE.EMAIL_ADDRESS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Email Address> changed value from <'
                       || AROLDVALUE.EMAIL_ADDRESS
                       || '> to <'
                       || ARNEWVALUE.EMAIL_ADDRESS
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.CURRENT_ONLY <> ARNEWVALUE.CURRENT_ONLY ),
                  TRUE )
         AND NOT(     AROLDVALUE.CURRENT_ONLY IS NULL
                  AND ARNEWVALUE.CURRENT_ONLY IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Current Only> changed value from <'
                       || AROLDVALUE.CURRENT_ONLY
                       || '> to <'
                       || ARNEWVALUE.CURRENT_ONLY
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.INITIAL_PROFILE <> ARNEWVALUE.INITIAL_PROFILE ),
                  TRUE )
         AND NOT(     AROLDVALUE.INITIAL_PROFILE IS NULL
                  AND ARNEWVALUE.INITIAL_PROFILE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Initial Profile> changed value from <'
                       || AROLDVALUE.INITIAL_PROFILE
                       || '> to <'
                       || ARNEWVALUE.INITIAL_PROFILE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.USER_PROFILE <> ARNEWVALUE.USER_PROFILE ),
                  TRUE )
         AND NOT(     AROLDVALUE.USER_PROFILE IS NULL
                  AND ARNEWVALUE.USER_PROFILE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <User Profile> changed value from <'
                       || AROLDVALUE.USER_PROFILE
                       || '> to <'
                       || ARNEWVALUE.USER_PROFILE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.USER_DROPPED <> ARNEWVALUE.USER_DROPPED ),
                  TRUE )
         AND NOT(     AROLDVALUE.USER_DROPPED IS NULL
                  AND ARNEWVALUE.USER_DROPPED IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <User has been dropped> changed value from <'
                       || AROLDVALUE.USER_DROPPED
                       || '> to <'
                       || ARNEWVALUE.USER_DROPPED
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.PROD_ACCESS <> ARNEWVALUE.PROD_ACCESS ),
                  TRUE )
         AND NOT(     AROLDVALUE.PROD_ACCESS IS NULL
                  AND ARNEWVALUE.PROD_ACCESS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Production Access> changed value from <'
                       || AROLDVALUE.PROD_ACCESS
                       || '> to <'
                       || ARNEWVALUE.PROD_ACCESS
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.PLAN_ACCESS <> ARNEWVALUE.PLAN_ACCESS ),
                  TRUE )
         AND NOT(     AROLDVALUE.PLAN_ACCESS IS NULL
                  AND ARNEWVALUE.PLAN_ACCESS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Planning Access> changed value from <'
                       || AROLDVALUE.PLAN_ACCESS
                       || '> to <'
                       || ARNEWVALUE.PLAN_ACCESS
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.PHASE_ACCESS <> ARNEWVALUE.PHASE_ACCESS ),
                  TRUE )
         AND NOT(     AROLDVALUE.PHASE_ACCESS IS NULL
                  AND ARNEWVALUE.PHASE_ACCESS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Phase Access> changed value from <'
                       || AROLDVALUE.PHASE_ACCESS
                       || '> to <'
                       || ARNEWVALUE.PHASE_ACCESS
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.PRINTING_ALLOWED <> ARNEWVALUE.PRINTING_ALLOWED ),
                  TRUE )
         AND NOT(     AROLDVALUE.PRINTING_ALLOWED IS NULL
                  AND ARNEWVALUE.PRINTING_ALLOWED IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Printing Allowed> changed value from <'
                       || AROLDVALUE.PRINTING_ALLOWED
                       || '> to <'
                       || ARNEWVALUE.PRINTING_ALLOWED
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.INTL <> ARNEWVALUE.INTL ),
                  TRUE )
         AND NOT(     AROLDVALUE.INTL IS NULL
                  AND ARNEWVALUE.INTL IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <International> changed value from <'
                       || AROLDVALUE.INTL
                       || '> to <'
                       || ARNEWVALUE.INTL
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.FRAMES_ONLY <> ARNEWVALUE.FRAMES_ONLY ),
                  TRUE )
         AND NOT(     AROLDVALUE.FRAMES_ONLY IS NULL
                  AND ARNEWVALUE.FRAMES_ONLY IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Frames only> changed value from <'
                       || AROLDVALUE.FRAMES_ONLY
                       || '> to <'
                       || ARNEWVALUE.FRAMES_ONLY
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REFERENCE_TEXT <> ARNEWVALUE.REFERENCE_TEXT ),
                  TRUE )
         AND NOT(     AROLDVALUE.REFERENCE_TEXT IS NULL
                  AND ARNEWVALUE.REFERENCE_TEXT IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Objects / Reference Text> changed value from <'
                       || AROLDVALUE.REFERENCE_TEXT
                       || '> to <'
                       || ARNEWVALUE.REFERENCE_TEXT
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.APPROVED_ONLY <> ARNEWVALUE.APPROVED_ONLY ),
                  TRUE )
         AND NOT(     AROLDVALUE.APPROVED_ONLY IS NULL
                  AND ARNEWVALUE.APPROVED_ONLY IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Approved and Current only> changed value from <'
                       || AROLDVALUE.APPROVED_ONLY
                       || '> to <'
                       || ARNEWVALUE.APPROVED_ONLY
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.LOC_ID <> ARNEWVALUE.LOC_ID ),
                  TRUE )
         AND NOT(     AROLDVALUE.LOC_ID IS NULL
                  AND ARNEWVALUE.LOC_ID IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.LOC_ID IS NULL
         THEN
            LSOLDVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSOLDVALUE
              FROM ITUSLOC
             WHERE LOC_ID = AROLDVALUE.LOC_ID;
         END IF;

         IF ARNEWVALUE.LOC_ID IS NULL
         THEN
            LSNEWVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSNEWVALUE
              FROM ITUSLOC
             WHERE LOC_ID = ARNEWVALUE.LOC_ID;
         END IF;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Location> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.CAT_ID <> ARNEWVALUE.CAT_ID ),
                  TRUE )
         AND NOT(     AROLDVALUE.CAT_ID IS NULL
                  AND ARNEWVALUE.CAT_ID IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.CAT_ID IS NULL
         THEN
            LSOLDVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSOLDVALUE
              FROM ITUSCAT
             WHERE CAT_ID = AROLDVALUE.CAT_ID;
         END IF;

         IF ARNEWVALUE.CAT_ID IS NULL
         THEN
            LSNEWVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSNEWVALUE
              FROM ITUSCAT
             WHERE CAT_ID = ARNEWVALUE.CAT_ID;
         END IF;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Category> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.OVERRIDE_PART_VAL <> ARNEWVALUE.OVERRIDE_PART_VAL ),
                  TRUE )
         AND NOT(     AROLDVALUE.OVERRIDE_PART_VAL IS NULL
                  AND ARNEWVALUE.OVERRIDE_PART_VAL IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Create Local Parts> changed value from <'
                       || AROLDVALUE.OVERRIDE_PART_VAL
                       || '> to <'
                       || ARNEWVALUE.OVERRIDE_PART_VAL
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.WEB_ALLOWED <> ARNEWVALUE.WEB_ALLOWED ),
                  TRUE )
         AND NOT(     AROLDVALUE.WEB_ALLOWED IS NULL
                  AND ARNEWVALUE.WEB_ALLOWED IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <WEB User> changed value from <'
                       || AROLDVALUE.WEB_ALLOWED
                       || '> to <'
                       || ARNEWVALUE.WEB_ALLOWED
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.LIMITED_CONFIGURATOR <> ARNEWVALUE.LIMITED_CONFIGURATOR ),
                  TRUE )
         AND NOT(     AROLDVALUE.LIMITED_CONFIGURATOR IS NULL
                  AND ARNEWVALUE.LIMITED_CONFIGURATOR IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Limited Configurator> changed value from <'
                       || AROLDVALUE.LIMITED_CONFIGURATOR
                       || '> to <'
                       || ARNEWVALUE.LIMITED_CONFIGURATOR
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.PLANT_ACCESS <> ARNEWVALUE.PLANT_ACCESS ),
                  TRUE )
         AND NOT(     AROLDVALUE.PLANT_ACCESS IS NULL
                  AND ARNEWVALUE.PLANT_ACCESS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Plant Access> changed value from <'
                       || AROLDVALUE.PLANT_ACCESS
                       || '> to <'
                       || ARNEWVALUE.PLANT_ACCESS
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.VIEW_BOM <> ARNEWVALUE.VIEW_BOM ),
                  TRUE )
         AND NOT(     AROLDVALUE.VIEW_BOM IS NULL
                  AND ARNEWVALUE.VIEW_BOM IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <View BOM> changed value from <'
                       || AROLDVALUE.VIEW_BOM
                       || '> to <'
                       || ARNEWVALUE.VIEW_BOM
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.HISTORIC_ONLY <> ARNEWVALUE.HISTORIC_ONLY ),
                  TRUE )
         AND NOT(     AROLDVALUE.HISTORIC_ONLY IS NULL
                  AND ARNEWVALUE.HISTORIC_ONLY IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUSHSDETAILS
                     ( USER_ID_CHANGED,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ASUSERIDCHANGED,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User <'
                       || ASUSERIDCHANGED
                       || '> is updated: property <Approved, Current and Historic only> changed value from <'
                       || AROLDVALUE.HISTORIC_ONLY
                       || '> to <'
                       || ARNEWVALUE.HISTORIC_ONLY
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLAUDITTRAILDETAILS;


   FUNCTION FILLSTATUSHSDETAILS(
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASSTATUS                   IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       STATUS%ROWTYPE,
      ARNEWVALUE                 IN       STATUS%ROWTYPE )
      RETURN NUMBER
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUserHsAddUserPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITSSHSDETAILS
                  ( STATUS,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANSTATUS,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.SORT_DESC <> ARNEWVALUE.SORT_DESC ),
                  TRUE )
         AND NOT(     AROLDVALUE.SORT_DESC IS NULL
                  AND ARNEWVALUE.SORT_DESC IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Status> changed value from <'
                       || AROLDVALUE.SORT_DESC
                       || '> to <'
                       || ARNEWVALUE.SORT_DESC
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DESCRIPTION <> ARNEWVALUE.DESCRIPTION ),
                  TRUE )
         AND NOT(     AROLDVALUE.DESCRIPTION IS NULL
                  AND ARNEWVALUE.DESCRIPTION IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Description> changed value from <'
                       || AROLDVALUE.DESCRIPTION
                       || '> to <'
                       || ARNEWVALUE.DESCRIPTION
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.STATUS_TYPE <> ARNEWVALUE.STATUS_TYPE ),
                  TRUE )
         AND NOT(     AROLDVALUE.STATUS_TYPE IS NULL
                  AND ARNEWVALUE.STATUS_TYPE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Status Type> changed value from <'
                       || AROLDVALUE.STATUS_TYPE
                       || '> to <'
                       || ARNEWVALUE.STATUS_TYPE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.PHASE_IN_STATUS <> ARNEWVALUE.PHASE_IN_STATUS ),
                  TRUE )
         AND NOT(     AROLDVALUE.PHASE_IN_STATUS IS NULL
                  AND ARNEWVALUE.PHASE_IN_STATUS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Phase-in> changed value from <'
                       || AROLDVALUE.PHASE_IN_STATUS
                       || '> to <'
                       || ARNEWVALUE.PHASE_IN_STATUS
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.EMAIL_TITLE <> ARNEWVALUE.EMAIL_TITLE ),
                  TRUE )
         AND NOT(     AROLDVALUE.EMAIL_TITLE IS NULL
                  AND ARNEWVALUE.EMAIL_TITLE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Email Title> changed value from <'
                       || AROLDVALUE.EMAIL_TITLE
                       || '> to <'
                       || ARNEWVALUE.EMAIL_TITLE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.PROMPT_FOR_REASON <> ARNEWVALUE.PROMPT_FOR_REASON ),
                  TRUE )
         AND NOT(     AROLDVALUE.PROMPT_FOR_REASON IS NULL
                  AND ARNEWVALUE.PROMPT_FOR_REASON IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Prompt for reason> changed value from <'
                       || AROLDVALUE.PROMPT_FOR_REASON
                       || '> to <'
                       || ARNEWVALUE.PROMPT_FOR_REASON
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REASON_MANDATORY <> ARNEWVALUE.REASON_MANDATORY ),
                  TRUE )
         AND NOT(     AROLDVALUE.REASON_MANDATORY IS NULL
                  AND ARNEWVALUE.REASON_MANDATORY IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Reason mandatory> changed value from <'
                       || AROLDVALUE.REASON_MANDATORY
                       || '> to <'
                       || ARNEWVALUE.REASON_MANDATORY
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.ES <> ARNEWVALUE.ES ),
                  TRUE )
         AND NOT(     AROLDVALUE.ES IS NULL
                  AND ARNEWVALUE.ES IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITSSHSDETAILS
                     ( STATUS,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANSTATUS,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Status <'
                       || ASSTATUS
                       || '> is updated: property <Electronic Signature> changed value from <'
                       || AROLDVALUE.ES
                       || '> to <'
                       || ARNEWVALUE.ES
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLSTATUSHSDETAILS;


   FUNCTION FILLWORKFLOWTYPEHSDETAILS(
      ANWORKFLOWTYPEID           IN       IAPITYPE.WORKFLOWID_TYPE,
      ASWORKFLOWTYPE             IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       WORK_FLOW_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       WORK_FLOW_GROUP%ROWTYPE )
      RETURN NUMBER
   IS


















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillWorkflowTypeHsDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( LNSEQNO,
                      0 );

      INSERT INTO ITWTHSDETAILS
                  ( WORK_FLOW_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANWORKFLOWTYPEID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.DESCRIPTION <> ARNEWVALUE.DESCRIPTION ),
                  TRUE )
         AND NOT(     AROLDVALUE.DESCRIPTION IS NULL
                  AND ARNEWVALUE.DESCRIPTION IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITWTHSDETAILS
                     ( WORK_FLOW_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWTYPEID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow type <'
                       || ASWORKFLOWTYPE
                       || '> is updated: property <Description> changed value from <'
                       || AROLDVALUE.DESCRIPTION
                       || '> to <'
                       || ARNEWVALUE.DESCRIPTION
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.INITIAL_STATUS <> ARNEWVALUE.INITIAL_STATUS ),
                  TRUE )
         AND NOT(     AROLDVALUE.INITIAL_STATUS IS NULL
                  AND ARNEWVALUE.INITIAL_STATUS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.INITIAL_STATUS IS NULL
         THEN
            LSOLDVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSOLDVALUE
              FROM STATUS
             WHERE STATUS = AROLDVALUE.INITIAL_STATUS;
         END IF;

         IF ARNEWVALUE.INITIAL_STATUS IS NULL
         THEN
            LSNEWVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSNEWVALUE
              FROM STATUS
             WHERE STATUS = ARNEWVALUE.INITIAL_STATUS;
         END IF;

         INSERT INTO ITWTHSDETAILS
                     ( WORK_FLOW_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWTYPEID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow type <'
                       || ASWORKFLOWTYPE
                       || '> is updated: property <Initial Status> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      LNSEQNO := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLWORKFLOWTYPEHSDETAILS;


   FUNCTION FILLWORKFLOWTYPEHSDETAILSLIST(
      ANWORKFLOWTYPEID           IN       IAPITYPE.WORKFLOWID_TYPE,
      ASWORKFLOWTYPE             IN       IAPITYPE.DESCRIPTION_TYPE,
      ASSTATUS                   IN       IAPITYPE.DESCRIPTION_TYPE,
      ASNEXTSTATUS               IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       WORK_FLOW%ROWTYPE,
      ARNEWVALUE                 IN       WORK_FLOW%ROWTYPE )
      RETURN NUMBER
   IS




















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillWorkflowTypeHsDetailsList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( LNSEQNO,
                      0 );

      INSERT INTO ITWTHSDETAILS
                  ( WORK_FLOW_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANWORKFLOWTYPEID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.EXPORT_ERP <> ARNEWVALUE.EXPORT_ERP ),
                  TRUE )
         AND NOT(     AROLDVALUE.EXPORT_ERP IS NULL
                  AND ARNEWVALUE.EXPORT_ERP IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITWTHSDETAILS
                     ( WORK_FLOW_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWTYPEID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow type <'
                       || ASWORKFLOWTYPE
                       || '> with status change from <'
                       || ASSTATUS
                       || '> to <'
                       || ASNEXTSTATUS
                       || '> is updated: property <Export Erp> changed value from <'
                       || AROLDVALUE.EXPORT_ERP
                       || '> to <'
                       || ARNEWVALUE.EXPORT_ERP
                       || '>.' );
      END IF;

      LNSEQNO := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLWORKFLOWTYPEHSDETAILSLIST;


   FUNCTION FILLWORKFLOWGROUPHSDETAILS(
      ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE,
      ASWORKFLOWGROUP            IN       IAPITYPE.PARAMETER_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       WORKFLOW_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       WORKFLOW_GROUP%ROWTYPE )
      RETURN NUMBER
   IS





















 
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillWorkflowGroupHsDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( LNSEQNO,
                      0 );

      INSERT INTO ITWGHSDETAILS
                  ( WORKFLOW_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANWORKFLOWGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.SORT_DESC <> ARNEWVALUE.SORT_DESC ),
                  TRUE )
         AND NOT(     AROLDVALUE.SORT_DESC IS NULL
                  AND ARNEWVALUE.SORT_DESC IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITWGHSDETAILS
                     ( WORKFLOW_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASWORKFLOWGROUP
                       || '> is updated: property <Workflow group> changed value from <'
                       || AROLDVALUE.SORT_DESC
                       || '> to <'
                       || ARNEWVALUE.SORT_DESC
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DESCRIPTION <> ARNEWVALUE.DESCRIPTION ),
                  TRUE )
         AND NOT(     AROLDVALUE.DESCRIPTION IS NULL
                  AND ARNEWVALUE.DESCRIPTION IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITWGHSDETAILS
                     ( WORKFLOW_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASWORKFLOWGROUP
                       || '> is updated: property <Description> changed value from <'
                       || AROLDVALUE.DESCRIPTION
                       || '> to <'
                       || ARNEWVALUE.DESCRIPTION
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.WORK_FLOW_ID <> ARNEWVALUE.WORK_FLOW_ID ),
                  TRUE )
         AND NOT(     AROLDVALUE.WORK_FLOW_ID IS NULL
                  AND ARNEWVALUE.WORK_FLOW_ID IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.WORK_FLOW_ID IS NULL
         THEN
            LSOLDVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSOLDVALUE
              FROM WORK_FLOW_GROUP
             WHERE WORK_FLOW_ID = AROLDVALUE.WORK_FLOW_ID;
         END IF;

         IF ARNEWVALUE.WORK_FLOW_ID IS NULL
         THEN
            LSNEWVALUE := '';
         ELSE
            SELECT DESCRIPTION
              INTO LSNEWVALUE
              FROM WORK_FLOW_GROUP
             WHERE WORK_FLOW_ID = ARNEWVALUE.WORK_FLOW_ID;
         END IF;

         INSERT INTO ITWGHSDETAILS
                     ( WORKFLOW_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASWORKFLOWGROUP
                       || '> is updated: property <Workflow Type> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      
      IF     NVL(  ( AROLDVALUE.APPROVERS_NUMBER <> ARNEWVALUE.APPROVERS_NUMBER ),
                  TRUE )
         AND NOT(     AROLDVALUE.APPROVERS_NUMBER IS NULL
                  AND ARNEWVALUE.APPROVERS_NUMBER IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITWGHSDETAILS
                     ( WORKFLOW_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASWORKFLOWGROUP
                       || '> is updated: property <Max. Approvals Number> changed value from <'
                       || AROLDVALUE.APPROVERS_NUMBER
                       || '> to <'
                       || ARNEWVALUE.APPROVERS_NUMBER
                       || '>.' );
      END IF;

      LNSEQNO := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLWORKFLOWGROUPHSDETAILS;


   FUNCTION FILLWORKFLOWGROUPHSDETAILSLIST(
      ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASSTATUS                   IN       IAPITYPE.DESCRIPTION_TYPE,
      ASUSERGROUP                IN       IAPITYPE.USERGROUPDESC_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       WORK_FLOW_LIST%ROWTYPE,
      ARNEWVALUE                 IN       WORK_FLOW_LIST%ROWTYPE )
      RETURN NUMBER
   IS




















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillWorkflowGroupHsDetailsList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( LNSEQNO,
                      0 );

      INSERT INTO ITWGHSDETAILS
                  ( WORKFLOW_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANWORKFLOWGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.ALL_TO_APPROVE <> ARNEWVALUE.ALL_TO_APPROVE ),
                  TRUE )
         AND NOT(     AROLDVALUE.ALL_TO_APPROVE IS NULL
                  AND ARNEWVALUE.ALL_TO_APPROVE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.ALL_TO_APPROVE = 'Y'
         THEN
            LSOLDVALUE := 'All';
         ELSIF AROLDVALUE.ALL_TO_APPROVE = 'N'
         THEN
            LSOLDVALUE := 'One';
         ELSE
            LSOLDVALUE := '';
         END IF;

         IF ARNEWVALUE.ALL_TO_APPROVE = 'Y'
         THEN
            LSNEWVALUE := 'All';
         ELSIF ARNEWVALUE.ALL_TO_APPROVE = 'N'
         THEN
            LSNEWVALUE := 'One';
         ELSE
            LSNEWVALUE := '';
         END IF;

         INSERT INTO ITWGHSDETAILS
                     ( WORKFLOW_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASDESCRIPTION
                       || '> with status <'
                       || ASSTATUS
                       || '> and user group <'
                       || ASUSERGROUP
                       || '> is updated: property <Approve> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.SEND_MAIL <> ARNEWVALUE.SEND_MAIL ),
                  TRUE )
         AND NOT(     AROLDVALUE.SEND_MAIL IS NULL
                  AND ARNEWVALUE.SEND_MAIL IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITWGHSDETAILS
                     ( WORKFLOW_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASDESCRIPTION
                       || '> with status <'
                       || ASSTATUS
                       || '> and user group <'
                       || ASUSERGROUP
                       || '> is updated: property <Mail> changed value from <'
                       || AROLDVALUE.SEND_MAIL
                       || '> to <'
                       || ARNEWVALUE.SEND_MAIL
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.EFF_DATE_MAIL <> ARNEWVALUE.EFF_DATE_MAIL ),
                  TRUE )
         AND NOT(     AROLDVALUE.EFF_DATE_MAIL IS NULL
                  AND ARNEWVALUE.EFF_DATE_MAIL IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITWGHSDETAILS
                     ( WORKFLOW_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANWORKFLOWGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASDESCRIPTION
                       || '> with status <'
                       || ASSTATUS
                       || '> and user group <'
                       || ASUSERGROUP
                       || '> is updated: property <Effective Date Mail> changed value from <'
                       || AROLDVALUE.EFF_DATE_MAIL
                       || '> to <'
                       || ARNEWVALUE.EFF_DATE_MAIL
                       || '>.' );
      END IF;

      LNSEQNO := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLWORKFLOWGROUPHSDETAILSLIST;


   FUNCTION FILLUSERGROUPHSDETAILSLIST3(
      ANUSERGROUPID              IN       IAPITYPE.USERGROUPID_TYPE,
      ASUSERGROUP                IN       IAPITYPE.USERGROUPDESC_TYPE,
      ASWORKFLOWGROUP            IN       IAPITYPE.PARAMETER_TYPE,
      ASSTATUS                   IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       WORK_FLOW_LIST%ROWTYPE,
      ARNEWVALUE                 IN       WORK_FLOW_LIST%ROWTYPE )
      RETURN NUMBER
   IS





















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillUserGroupHsDetailsList3';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( LNSEQNO,
                      0 );

      INSERT INTO ITUGHSDETAILS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANUSERGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.ALL_TO_APPROVE <> ARNEWVALUE.ALL_TO_APPROVE ),
                  TRUE )
         AND NOT(     AROLDVALUE.ALL_TO_APPROVE IS NULL
                  AND ARNEWVALUE.ALL_TO_APPROVE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.ALL_TO_APPROVE = 'Y'
         THEN
            LSOLDVALUE := 'All';
         ELSIF AROLDVALUE.ALL_TO_APPROVE = 'N'
         THEN
            LSOLDVALUE := 'One';
         ELSE
            LSOLDVALUE := '';
         END IF;

         IF ARNEWVALUE.ALL_TO_APPROVE = 'Y'
         THEN
            LSNEWVALUE := 'All';
         ELSIF ARNEWVALUE.ALL_TO_APPROVE = 'N'
         THEN
            LSNEWVALUE := 'One';
         ELSE
            LSNEWVALUE := '';
         END IF;

         INSERT INTO ITUGHSDETAILS
                     ( USER_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANUSERGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASWORKFLOWGROUP
                       || '> with status <'
                       || ASSTATUS
                       || '> and user group <'
                       || ASUSERGROUP
                       || '> is updated: property <Approve> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.SEND_MAIL <> ARNEWVALUE.SEND_MAIL ),
                  TRUE )
         AND NOT(     AROLDVALUE.SEND_MAIL IS NULL
                  AND ARNEWVALUE.SEND_MAIL IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUGHSDETAILS
                     ( USER_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANUSERGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASWORKFLOWGROUP
                       || '> with status <'
                       || ASSTATUS
                       || '> and user group <'
                       || ASUSERGROUP
                       || '> is updated: property <Mail> changed value from <'
                       || AROLDVALUE.SEND_MAIL
                       || '> to <'
                       || ARNEWVALUE.SEND_MAIL
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.EFF_DATE_MAIL <> ARNEWVALUE.EFF_DATE_MAIL ),
                  TRUE )
         AND NOT(     AROLDVALUE.EFF_DATE_MAIL IS NULL
                  AND ARNEWVALUE.EFF_DATE_MAIL IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUGHSDETAILS
                     ( USER_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANUSERGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Workflow group <'
                       || ASWORKFLOWGROUP
                       || '> with status <'
                       || ASSTATUS
                       || '> and user group <'
                       || ASUSERGROUP
                       || '> is updated: property <Effective Date Mail> changed value from <'
                       || AROLDVALUE.EFF_DATE_MAIL
                       || '> to <'
                       || ARNEWVALUE.EFF_DATE_MAIL
                       || '>.' );
      END IF;

      LNSEQNO := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLUSERGROUPHSDETAILSLIST3;


   FUNCTION FILLWORKFLOWGROUPHSDETAILSFILT(
      ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE,
      ASWORKFLOWGROUP            IN       IAPITYPE.PARAMETER_TYPE,
      ASUSERGROUP                IN       IAPITYPE.USERGROUPDESC_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       USER_WORKFLOW_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_WORKFLOW_GROUP%ROWTYPE )
      RETURN NUMBER
   IS



















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillWorkflowGroupHsDetailsFilt';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( LNSEQNO,
                      0 );

      INSERT INTO ITWGHSDETAILS
                  ( WORKFLOW_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANWORKFLOWGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      LNSEQNO := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLWORKFLOWGROUPHSDETAILSFILT;


   FUNCTION FILLUSERGROUPHSDETAILSFILTER(
      ANUSERGROUPID              IN       IAPITYPE.USERGROUPID_TYPE,
      ASUSERGROUP                IN       IAPITYPE.USERGROUPDESC_TYPE,
      ASWORKFLOWGROUP            IN       IAPITYPE.PARAMETER_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       USER_WORKFLOW_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_WORKFLOW_GROUP%ROWTYPE )
      RETURN NUMBER
   IS


















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillUserGroupHsDetailsFilter';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN
      
      LNSEQNO := NVL( LNSEQNO,
                      0 );

      INSERT INTO ITUGHSDETAILS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANUSERGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      LNSEQNO := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLUSERGROUPHSDETAILSFILTER;


   FUNCTION FILLACCESSGROUPHSDETAILS(
      ANACCESSGROUPID            IN       IAPITYPE.USERGROUPID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ACCESS_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       ACCESS_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillAccessGroupHsDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITAGHSDETAILS
                  ( ACCESS_GROUP,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANACCESSGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.SORT_DESC <> ARNEWVALUE.SORT_DESC ),
                  TRUE )
         AND NOT(     AROLDVALUE.SORT_DESC IS NULL
                  AND ARNEWVALUE.SORT_DESC IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITAGHSDETAILS
                     ( ACCESS_GROUP,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANACCESSGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Access group <'
                       || ASDESCRIPTION
                       || '> is updated: property <Access Group> changed value from <'
                       || AROLDVALUE.SORT_DESC
                       || '> to <'
                       || ARNEWVALUE.SORT_DESC
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DESCRIPTION <> ARNEWVALUE.DESCRIPTION ),
                  TRUE )
         AND NOT(     AROLDVALUE.DESCRIPTION IS NULL
                  AND ARNEWVALUE.DESCRIPTION IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITAGHSDETAILS
                     ( ACCESS_GROUP,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANACCESSGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Access group <'
                       || ASDESCRIPTION
                       || '> is updated: property <Description> changed value from <'
                       || AROLDVALUE.DESCRIPTION
                       || '> to <'
                       || ARNEWVALUE.DESCRIPTION
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLACCESSGROUPHSDETAILS;


   FUNCTION FILLACCESSGROUPHSDETAILSLIST(
      ANACCESSGROUPID            IN       IAPITYPE.USERGROUPID_TYPE,
      ASACCESSGROUP              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASUSERGROUP                IN       IAPITYPE.USERGROUPDESC_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       USER_ACCESS_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_ACCESS_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS


















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillAccessGroupHsDetailsList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITAGHSDETAILS
                  ( ACCESS_GROUP,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANACCESSGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.UPDATE_ALLOWED <> ARNEWVALUE.UPDATE_ALLOWED ),
                  TRUE )
         AND NOT(     AROLDVALUE.UPDATE_ALLOWED IS NULL
                  AND ARNEWVALUE.UPDATE_ALLOWED IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITAGHSDETAILS
                     ( ACCESS_GROUP,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANACCESSGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Access group <'
                       || ASACCESSGROUP
                       || '> user group <'
                       || ASUSERGROUP
                       || '> link is updated: property <Update Allowed> changed value from <'
                       || AROLDVALUE.UPDATE_ALLOWED
                       || '> to <'
                       || ARNEWVALUE.UPDATE_ALLOWED
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.MRP_UPDATE <> ARNEWVALUE.MRP_UPDATE ),
                  TRUE )
         AND NOT(     AROLDVALUE.MRP_UPDATE IS NULL
                  AND ARNEWVALUE.MRP_UPDATE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITAGHSDETAILS
                     ( ACCESS_GROUP,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANACCESSGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Access group <'
                       || ASACCESSGROUP
                       || '> user group <'
                       || ASUSERGROUP
                       || '> link is updated: property <MRP Update> changed value from <'
                       || AROLDVALUE.MRP_UPDATE
                       || '> to <'
                       || ARNEWVALUE.MRP_UPDATE
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLACCESSGROUPHSDETAILSLIST;


   FUNCTION FILLUSERGROUPHSDETAILSLIST2(
      ANUSERGROUPID              IN       IAPITYPE.USERGROUPID_TYPE,
      ASUSERGROUP                IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASACCESSGROUP              IN       IAPITYPE.USERGROUPDESC_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       USER_ACCESS_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_ACCESS_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS


















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillUserGroupHsDetailsList2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITUGHSDETAILS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANUSERGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.UPDATE_ALLOWED <> ARNEWVALUE.UPDATE_ALLOWED ),
                  TRUE )
         AND NOT(     AROLDVALUE.UPDATE_ALLOWED IS NULL
                  AND ARNEWVALUE.UPDATE_ALLOWED IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUGHSDETAILS
                     ( USER_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANUSERGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Access group <'
                       || ASACCESSGROUP
                       || '> user group <'
                       || ASUSERGROUP
                       || '> link is updated: property <Update Allowed> changed value from <'
                       || AROLDVALUE.UPDATE_ALLOWED
                       || '> to <'
                       || ARNEWVALUE.UPDATE_ALLOWED
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.MRP_UPDATE <> ARNEWVALUE.MRP_UPDATE ),
                  TRUE )
         AND NOT(     AROLDVALUE.MRP_UPDATE IS NULL
                  AND ARNEWVALUE.MRP_UPDATE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUGHSDETAILS
                     ( USER_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANUSERGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Access group <'
                       || ASACCESSGROUP
                       || '> user group <'
                       || ASUSERGROUP
                       || '> link is updated: property <MRP Update> changed value from <'
                       || AROLDVALUE.MRP_UPDATE
                       || '> to <'
                       || ARNEWVALUE.MRP_UPDATE
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLUSERGROUPHSDETAILSLIST2;


   FUNCTION FILLUSERGROUPHSDETAILS(
      ANUSERGROUPID              IN       IAPITYPE.USERGROUPID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.USERGROUPDESC_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       USER_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_GROUP%ROWTYPE )
      RETURN NUMBER
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillUserGroupHsDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITUGHSDETAILS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANUSERGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.SHORT_DESC <> ARNEWVALUE.SHORT_DESC ),
                  TRUE )
         AND NOT(     AROLDVALUE.SHORT_DESC IS NULL
                  AND ARNEWVALUE.SHORT_DESC IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUGHSDETAILS
                     ( USER_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANUSERGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User group <'
                       || ASDESCRIPTION
                       || '> is updated: property <User Group> changed value from <'
                       || AROLDVALUE.SHORT_DESC
                       || '> to <'
                       || ARNEWVALUE.SHORT_DESC
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DESCRIPTION <> ARNEWVALUE.DESCRIPTION ),
                  TRUE )
         AND NOT(     AROLDVALUE.DESCRIPTION IS NULL
                  AND ARNEWVALUE.DESCRIPTION IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITUGHSDETAILS
                     ( USER_GROUP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANUSERGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'User group <'
                       || ASDESCRIPTION
                       || '> is updated: property <Description> changed value from <'
                       || AROLDVALUE.DESCRIPTION
                       || '> to <'
                       || ARNEWVALUE.DESCRIPTION
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLUSERGROUPHSDETAILS;


   FUNCTION FILLUSERGROUPHSDETAILSLIST1(
      ANUSERGROUPID              IN       IAPITYPE.USERGROUPID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.USERGROUPDESC_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       USER_GROUP_LIST%ROWTYPE,
      ARNEWVALUE                 IN       USER_GROUP_LIST%ROWTYPE )
      RETURN NUMBER
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillUserGroupHsDetailsList1';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITUGHSDETAILS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANUSERGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLUSERGROUPHSDETAILSLIST1;


   FUNCTION FILLUSERHSDETAILSUSERGROUP(
      ANUSERIDCHANGED            IN       IAPITYPE.USERID_TYPE,
      ASUSERGROUP                IN       IAPITYPE.USERGROUPDESC_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       USER_GROUP_LIST%ROWTYPE,
      ARNEWVALUE                 IN       USER_GROUP_LIST%ROWTYPE )
      RETURN NUMBER
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillUserHsDetailsUserGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITUSHSDETAILS
                  ( USER_ID_CHANGED,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANUSERIDCHANGED,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLUSERHSDETAILSUSERGROUP;


   FUNCTION FILLREPORTHSDETAILS(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPD%ROWTYPE,
      ARNEWVALUE                 IN       ITREPD%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.SORT_DESC <> ARNEWVALUE.SORT_DESC ),
                  TRUE )
         AND NOT(     AROLDVALUE.SORT_DESC IS NULL
                  AND ARNEWVALUE.SORT_DESC IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Report Name> changed value from <'
                       || AROLDVALUE.SORT_DESC
                       || '> to <'
                       || ARNEWVALUE.SORT_DESC
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DESCRIPTION <> ARNEWVALUE.DESCRIPTION ),
                  TRUE )
         AND NOT(     AROLDVALUE.DESCRIPTION IS NULL
                  AND ARNEWVALUE.DESCRIPTION IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Report Description> changed value from <'
                       || AROLDVALUE.DESCRIPTION
                       || '> to <'
                       || ARNEWVALUE.DESCRIPTION
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.INFO <> ARNEWVALUE.INFO ),
                  TRUE )
         AND NOT(     AROLDVALUE.INFO IS NULL
                  AND ARNEWVALUE.INFO IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Definition> changed value from <'
                       || AROLDVALUE.INFO
                       || '> to <'
                       || ARNEWVALUE.INFO
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.STATUS <> ARNEWVALUE.STATUS ),
                  TRUE )
         AND NOT(     AROLDVALUE.STATUS IS NULL
                  AND ARNEWVALUE.STATUS IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.STATUS = 2
         THEN
            LSOLDVALUE := 'Active';
         ELSIF AROLDVALUE.STATUS = 1
         THEN
            LSOLDVALUE := 'Historic';
         ELSIF AROLDVALUE.STATUS = 1
         THEN
            LSOLDVALUE := '(none)';
         ELSE
            LSOLDVALUE := '';
         END IF;

         IF ARNEWVALUE.STATUS = 2
         THEN
            LSNEWVALUE := 'Active';
         ELSIF ARNEWVALUE.STATUS = 1
         THEN
            LSNEWVALUE := 'Historic';
         ELSIF ARNEWVALUE.STATUS = 1
         THEN
            LSNEWVALUE := '(none)';
         ELSE
            LSNEWVALUE := '';
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Status> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_TYPE <> ARNEWVALUE.REP_TYPE ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_TYPE IS NULL
                  AND ARNEWVALUE.REP_TYPE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.REP_TYPE IS NULL
         THEN
            LSOLDVALUE := '';
         ELSIF AROLDVALUE.REP_TYPE = 0
         THEN
            LSOLDVALUE := '(none)';
         ELSE
            SELECT SORT_DESC
              INTO LSOLDVALUE
              FROM ITREPTYPE
             WHERE REP_TYPE = AROLDVALUE.REP_TYPE;
         END IF;

         IF ARNEWVALUE.REP_TYPE IS NULL
         THEN
            LSNEWVALUE := '';
         ELSIF ARNEWVALUE.REP_TYPE = 0
         THEN
            LSNEWVALUE := '(none)';
         ELSE
            SELECT SORT_DESC
              INTO LSNEWVALUE
              FROM ITREPTYPE
             WHERE REP_TYPE = ARNEWVALUE.REP_TYPE;
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Report Type> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.BATCH_ALLOWED <> ARNEWVALUE.BATCH_ALLOWED ),
                  TRUE )
         AND NOT(     AROLDVALUE.BATCH_ALLOWED IS NULL
                  AND ARNEWVALUE.BATCH_ALLOWED IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Queue allowed> changed value from <'
                       || AROLDVALUE.BATCH_ALLOWED
                       || '> to <'
                       || ARNEWVALUE.BATCH_ALLOWED
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.WEB_ALLOWED <> ARNEWVALUE.WEB_ALLOWED ),
                  TRUE )
         AND NOT(     AROLDVALUE.WEB_ALLOWED IS NULL
                  AND ARNEWVALUE.WEB_ALLOWED IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <WEB allowed> changed value from <'
                       || AROLDVALUE.WEB_ALLOWED
                       || '> to <'
                       || ARNEWVALUE.WEB_ALLOWED
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILS;


   FUNCTION FILLREPORTHSDETAILSNSTDEF(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASNREPTYPE                 IN       IAPITYPE.REPORTITEMTYPE_TYPE,
      ASREPORTTYPE               IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPNSTDEF%ROWTYPE,
      ARNEWVALUE                 IN       ITREPNSTDEF%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS




















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsNstDef';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSREPORTTYPE                  IAPITYPE.DESCRIPTION_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      IF ASNREPTYPE = 'bmp'
      THEN
         
         
         IF     NVL(  ( AROLDVALUE.NREP_D <> ARNEWVALUE.NREP_D ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_D IS NULL
                     AND ARNEWVALUE.NREP_D IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Bitmap name> changed value from <'
                          || AROLDVALUE.NREP_D
                          || '> to <'
                          || ARNEWVALUE.NREP_D
                          || '>.' );
         END IF;
      ELSIF ASNREPTYPE = 'rep'
      THEN
         
         
         IF     NVL(  ( AROLDVALUE.NREP_L <> ARNEWVALUE.NREP_L ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_L IS NULL
                     AND ARNEWVALUE.NREP_L IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Number of lines> changed value from <'
                          || AROLDVALUE.NREP_L
                          || '> to <'
                          || ARNEWVALUE.NREP_L
                          || '>.' );
         END IF;
      ELSIF ASNREPTYPE = 'title'
      THEN
         
         
         IF     NVL(  ( AROLDVALUE.NREP_D <> ARNEWVALUE.NREP_D ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_D IS NULL
                     AND ARNEWVALUE.NREP_D IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Report title> changed value from <'
                          || AROLDVALUE.NREP_D
                          || '> to <'
                          || ARNEWVALUE.NREP_D
                          || '>.' );
         END IF;
      ELSIF ASNREPTYPE = 'proc'
      THEN
         
         
         IF     NVL(  ( AROLDVALUE.NREP_D <> ARNEWVALUE.NREP_D ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_D IS NULL
                     AND ARNEWVALUE.NREP_D IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <procedure name> changed value from <'
                          || AROLDVALUE.NREP_D
                          || '> to <'
                          || ARNEWVALUE.NREP_D
                          || '>.' );
         END IF;

         
         IF     NVL(  ( AROLDVALUE.REMARKS <> ARNEWVALUE.REMARKS ),
                     TRUE )
            AND NOT(     AROLDVALUE.REMARKS IS NULL
                     AND ARNEWVALUE.REMARKS IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Arguments> changed value from <'
                          || AROLDVALUE.REMARKS
                          || '> to <'
                          || ARNEWVALUE.REMARKS
                          || '>.' );
         END IF;
      ELSE
         
         
         IF     NVL(  ( AROLDVALUE.NREP_D <> ARNEWVALUE.NREP_D ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_D IS NULL
                     AND ARNEWVALUE.NREP_D IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Datawindow> changed value from <'
                          || AROLDVALUE.NREP_D
                          || '> to <'
                          || ARNEWVALUE.NREP_D
                          || '>.' );
         END IF;

         
         IF     NVL(  ( AROLDVALUE.NREP_R <> ARNEWVALUE.NREP_R ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_R IS NULL
                     AND ARNEWVALUE.NREP_R IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Datawindow [Layout]> changed value from <'
                          || AROLDVALUE.NREP_R
                          || '> to <'
                          || ARNEWVALUE.NREP_R
                          || '>.' );
         END IF;

         
         IF     NVL(  ( AROLDVALUE.NREP_L <> ARNEWVALUE.NREP_L ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_L IS NULL
                     AND ARNEWVALUE.NREP_L IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Datawindow: Height of row [lines]> changed value from <'
                          || AROLDVALUE.NREP_L
                          || '> to <'
                          || ARNEWVALUE.NREP_L
                          || '>.' );
         END IF;

         
         IF     NVL(  ( AROLDVALUE.NREP_HL <> ARNEWVALUE.NREP_HL ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_HL IS NULL
                     AND ARNEWVALUE.NREP_HL IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Datawindow: Height of header [lines]> changed value from <'
                          || AROLDVALUE.NREP_HL
                          || '> to <'
                          || ARNEWVALUE.NREP_HL
                          || '>.' );
         END IF;

         
         IF     NVL(  ( AROLDVALUE.NREP_D_LANG <> ARNEWVALUE.NREP_D_LANG ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_D_LANG IS NULL
                     AND ARNEWVALUE.NREP_D_LANG IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Multi language: Datawindow [Definition]> changed value from <'
                          || AROLDVALUE.NREP_D_LANG
                          || '> to <'
                          || ARNEWVALUE.NREP_D_LANG
                          || '>.' );
         END IF;

         
         IF     NVL(  ( AROLDVALUE.NREP_L_LANG <> ARNEWVALUE.NREP_L_LANG ),
                     TRUE )
            AND NOT(     AROLDVALUE.NREP_L_LANG IS NULL
                     AND ARNEWVALUE.NREP_L_LANG IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Multi language: Datawindow [Layout]> changed value from <'
                          || AROLDVALUE.NREP_L_LANG
                          || '> to <'
                          || ARNEWVALUE.NREP_L_LANG
                          || '>.' );
         END IF;

         
         IF     NVL(  ( AROLDVALUE.REMARKS <> ARNEWVALUE.REMARKS ),
                     TRUE )
            AND NOT(     AROLDVALUE.REMARKS IS NULL
                     AND ARNEWVALUE.REMARKS IS NULL )
         THEN
            LNSEQNO :=   LNSEQNO
                       + 1;

            INSERT INTO ITREPHSDETAILS
                        ( REP_ID,
                          AUDIT_TRAIL_SEQ_NO,
                          SEQ_NO,
                          DETAILS )
                 VALUES ( ANREPORTID,
                          ANAUDITTRAILSEQUENCENR,
                          LNSEQNO,
                             'Report Layout <'
                          || ASREPORTTYPE
                          || '> of report <'
                          || ASDESCRIPTION
                          || '> is updated: property <Arguments> changed value from <'
                          || AROLDVALUE.REMARKS
                          || '> to <'
                          || ARNEWVALUE.REMARKS
                          || '>.' );
         END IF;
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSNSTDEF;


   FUNCTION FILLREPORTHSDETAILSDATA1(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASNREPTYPE                 IN       IAPITYPE.REPORTITEMTYPE_TYPE,
      ASREPORTTYPE               IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPDATA%ROWTYPE,
      ARNEWVALUE                 IN       ITREPDATA%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS




















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsData1';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.INCLUDE <> ARNEWVALUE.INCLUDE ),
                  TRUE )
         AND NOT(     AROLDVALUE.INCLUDE IS NULL
                  AND ARNEWVALUE.INCLUDE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Object type <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Include> changed value from <'
                       || AROLDVALUE.INCLUDE
                       || '> to <'
                       || ARNEWVALUE.INCLUDE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.SEQ <> ARNEWVALUE.SEQ ),
                  TRUE )
         AND NOT(     AROLDVALUE.SEQ IS NULL
                  AND ARNEWVALUE.SEQ IS NULL )
         AND (    ASNREPTYPE = 'kw'
               OR ASNREPTYPE = 'cl' )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.SEQ = 1
         THEN
            LSOLDVALUE := 'Y';
         ELSIF AROLDVALUE.SEQ = 0
         THEN
            LSOLDVALUE := 'N';
         ELSE
            LSOLDVALUE := TO_CHAR( AROLDVALUE.SEQ );
         END IF;

         IF ARNEWVALUE.SEQ = 1
         THEN
            LSNEWVALUE := 'Y';
         ELSIF ARNEWVALUE.SEQ = 0
         THEN
            LSNEWVALUE := 'N';
         ELSE
            LSNEWVALUE := TO_CHAR( ARNEWVALUE.SEQ );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Object type <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <at Footer> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.HEADER <> ARNEWVALUE.HEADER ),
                  TRUE )
         AND NOT(     AROLDVALUE.HEADER IS NULL
                  AND ARNEWVALUE.HEADER IS NULL )
         AND (    ASNREPTYPE = 'kw'
               OR ASNREPTYPE = 'cl' )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.HEADER = 1
         THEN
            LSOLDVALUE := 'Y';
         ELSIF AROLDVALUE.HEADER = 0
         THEN
            LSOLDVALUE := 'N';
         ELSE
            LSOLDVALUE := TO_CHAR( AROLDVALUE.HEADER );
         END IF;

         IF ARNEWVALUE.HEADER = 1
         THEN
            LSNEWVALUE := 'Y';
         ELSIF ARNEWVALUE.HEADER = 0
         THEN
            LSNEWVALUE := 'N';
         ELSE
            LSNEWVALUE := TO_CHAR( ARNEWVALUE.HEADER );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Object type <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Header> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSDATA1;


   FUNCTION FILLREPORTHSDETAILSDATA2(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASNREPTYPE                 IN       IAPITYPE.REPORTITEMTYPE_TYPE,
      ASREPORTTYPE               IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPDATA%ROWTYPE,
      ARNEWVALUE                 IN       ITREPDATA%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS




















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsData2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.INCLUDE <> ARNEWVALUE.INCLUDE ),
                  TRUE )
         AND NOT(     AROLDVALUE.INCLUDE IS NULL
                  AND ARNEWVALUE.INCLUDE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Section <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Include> changed value from <'
                       || AROLDVALUE.INCLUDE
                       || '> to <'
                       || ARNEWVALUE.INCLUDE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.HEADER <> ARNEWVALUE.HEADER ),
                  TRUE )
         AND NOT(     AROLDVALUE.HEADER IS NULL
                  AND ARNEWVALUE.HEADER IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.HEADER = 1
         THEN
            LSOLDVALUE := 'Y';
         ELSIF AROLDVALUE.HEADER = 0
         THEN
            LSOLDVALUE := 'N';
         ELSE
            LSOLDVALUE := TO_CHAR( AROLDVALUE.HEADER );
         END IF;

         IF ARNEWVALUE.HEADER = 1
         THEN
            LSNEWVALUE := 'Y';
         ELSIF ARNEWVALUE.HEADER = 0
         THEN
            LSNEWVALUE := 'N';
         ELSE
            LSNEWVALUE := TO_CHAR( ARNEWVALUE.HEADER );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Section <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Header> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.INCL_OBJ <> ARNEWVALUE.INCL_OBJ ),
                  TRUE )
         AND NOT(     AROLDVALUE.INCL_OBJ IS NULL
                  AND ARNEWVALUE.INCL_OBJ IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.INCL_OBJ = 0
         THEN
            LSOLDVALUE := 'Y';
         ELSIF AROLDVALUE.INCL_OBJ = 1
         THEN
            LSOLDVALUE := 'N';
         ELSE
            LSOLDVALUE := TO_CHAR( AROLDVALUE.INCL_OBJ );
         END IF;

         IF ARNEWVALUE.INCL_OBJ = 0
         THEN
            LSNEWVALUE := 'Y';
         ELSIF ARNEWVALUE.INCL_OBJ = 1
         THEN
            LSNEWVALUE := 'N';
         ELSE
            LSNEWVALUE := TO_CHAR( ARNEWVALUE.INCL_OBJ );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Section <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Excl. All> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSDATA2;


   FUNCTION FILLREPORTHSDETAILSDATA3(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASNREPTYPE                 IN       IAPITYPE.REPORTITEMTYPE_TYPE,
      ASREPORTTYPE               IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPDATA%ROWTYPE,
      ARNEWVALUE                 IN       ITREPDATA%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS




















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsData3';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.INCLUDE <> ARNEWVALUE.INCLUDE ),
                  TRUE )
         AND NOT(     AROLDVALUE.INCLUDE IS NULL
                  AND ARNEWVALUE.INCLUDE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          '<'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Include> changed value from <'
                       || AROLDVALUE.INCLUDE
                       || '> to <'
                       || ARNEWVALUE.INCLUDE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.HEADER <> ARNEWVALUE.HEADER ),
                  TRUE )
         AND NOT(     AROLDVALUE.HEADER IS NULL
                  AND ARNEWVALUE.HEADER IS NULL )
         AND ASNREPTYPE IN( '1', '2', '3', '4', '5', '6' )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.HEADER = 1
         THEN
            LSOLDVALUE := 'Y';
         ELSIF AROLDVALUE.HEADER = 0
         THEN
            LSOLDVALUE := 'N';
         ELSE
            LSOLDVALUE := TO_CHAR( AROLDVALUE.HEADER );
         END IF;

         IF ARNEWVALUE.HEADER = 1
         THEN
            LSNEWVALUE := 'Y';
         ELSIF ARNEWVALUE.HEADER = 0
         THEN
            LSNEWVALUE := 'N';
         ELSE
            LSNEWVALUE := TO_CHAR( ARNEWVALUE.HEADER );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          '<'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Header> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.INCL_OBJ <> ARNEWVALUE.INCL_OBJ ),
                  TRUE )
         AND NOT(     AROLDVALUE.INCL_OBJ IS NULL
                  AND ARNEWVALUE.INCL_OBJ IS NULL )
         AND ASNREPTYPE = '1'
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.INCL_OBJ = 0
         THEN
            LSOLDVALUE := 'Y';
         ELSIF AROLDVALUE.INCL_OBJ = 1
         THEN
            LSOLDVALUE := 'N';
         ELSE
            LSOLDVALUE := TO_CHAR( AROLDVALUE.INCL_OBJ );
         END IF;

         IF ARNEWVALUE.INCL_OBJ = 0
         THEN
            LSNEWVALUE := 'Y';
         ELSIF ARNEWVALUE.INCL_OBJ = 1
         THEN
            LSNEWVALUE := 'N';
         ELSE
            LSNEWVALUE := TO_CHAR( ARNEWVALUE.INCL_OBJ );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          '<'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Excl. All> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DISPLAY_FORMAT <> ARNEWVALUE.DISPLAY_FORMAT ),
                  TRUE )
         AND NOT(     AROLDVALUE.DISPLAY_FORMAT IS NULL
                  AND ARNEWVALUE.DISPLAY_FORMAT IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.DISPLAY_FORMAT IS NULL
         THEN
            LSOLDVALUE := '';
         ELSE
            LSOLDVALUE := F_LYH_DESCR( 1,
                                       AROLDVALUE.DISPLAY_FORMAT,
                                       0 );
         END IF;

         IF ARNEWVALUE.DISPLAY_FORMAT IS NULL
         THEN
            LSNEWVALUE := '';
         ELSE
            LSNEWVALUE := F_LYH_DESCR( 1,
                                       ARNEWVALUE.DISPLAY_FORMAT,
                                       0 );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          '<'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Display Format> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DISPLAY_FORMAT_REV <> ARNEWVALUE.DISPLAY_FORMAT_REV ),
                  TRUE )
         AND NOT(     AROLDVALUE.DISPLAY_FORMAT_REV IS NULL
                  AND ARNEWVALUE.DISPLAY_FORMAT_REV IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          '<'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Display Format Rev> changed value from <'
                       || AROLDVALUE.DISPLAY_FORMAT_REV
                       || '> to <'
                       || ARNEWVALUE.DISPLAY_FORMAT_REV
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSDATA3;


   FUNCTION FILLREPORTHSDETAILSDATA4(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASNREPTYPE                 IN       IAPITYPE.REPORTITEMTYPE_TYPE,
      ASREPORTTYPE               IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPDATA%ROWTYPE,
      ARNEWVALUE                 IN       ITREPDATA%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS




















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsData4';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.REF_ID <> ARNEWVALUE.REF_ID ),
                  TRUE )
         AND NOT(     AROLDVALUE.REF_ID IS NULL
                  AND ARNEWVALUE.REF_ID IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;
         LSOLDVALUE := F_SCH_DESCR( 1,
                                    AROLDVALUE.REF_ID,
                                    0 );
         LSNEWVALUE := F_SCH_DESCR( 1,
                                    ARNEWVALUE.REF_ID,
                                    0 );

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Object <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <To be insert after/before Section> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.INCLUDE <> ARNEWVALUE.INCLUDE ),
                  TRUE )
         AND NOT(     AROLDVALUE.INCLUDE IS NULL
                  AND ARNEWVALUE.INCLUDE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Object <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <After> changed value from <'
                       || AROLDVALUE.INCLUDE
                       || '> to <'
                       || ARNEWVALUE.INCLUDE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DISPLAY_FORMAT <> ARNEWVALUE.DISPLAY_FORMAT ),
                  TRUE )
         AND NOT(     AROLDVALUE.DISPLAY_FORMAT IS NULL
                  AND ARNEWVALUE.DISPLAY_FORMAT IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.DISPLAY_FORMAT IS NULL
         THEN
            LSOLDVALUE := '';
         ELSE
            LSOLDVALUE := F_LYH_DESCR( 1,
                                       AROLDVALUE.DISPLAY_FORMAT,
                                       0 );
         END IF;

         IF ARNEWVALUE.DISPLAY_FORMAT IS NULL
         THEN
            LSNEWVALUE := '';
         ELSE
            LSNEWVALUE := F_LYH_DESCR( 1,
                                       ARNEWVALUE.DISPLAY_FORMAT,
                                       0 );
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Object <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Display Format> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.DISPLAY_FORMAT_REV <> ARNEWVALUE.DISPLAY_FORMAT_REV ),
                  TRUE )
         AND NOT(     AROLDVALUE.DISPLAY_FORMAT_REV IS NULL
                  AND ARNEWVALUE.DISPLAY_FORMAT_REV IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Object <'
                       || ASREPORTTYPE
                       || '> of report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Display Format Rev> changed value from <'
                       || AROLDVALUE.DISPLAY_FORMAT_REV
                       || '> to <'
                       || ARNEWVALUE.DISPLAY_FORMAT_REV
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSDATA4;


   FUNCTION FILLREPORTHSDETAILSARG(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPARG%ROWTYPE,
      ARNEWVALUE                 IN       ITREPARG%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsArg';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSOLDVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSNEWVALUE                    IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.REP_TYPE <> ARNEWVALUE.REP_TYPE ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_TYPE IS NULL
                  AND ARNEWVALUE.REP_TYPE IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <rep_type> changed value from <'
                       || AROLDVALUE.REP_TYPE
                       || '> to <'
                       || ARNEWVALUE.REP_TYPE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_ARG1 <> ARNEWVALUE.REP_ARG1 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_ARG1 IS NULL
                  AND ARNEWVALUE.REP_ARG1 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Caption argument 1> changed value from <'
                       || AROLDVALUE.REP_ARG1
                       || '> to <'
                       || ARNEWVALUE.REP_ARG1
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_DT_1 <> ARNEWVALUE.REP_DT_1 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_DT_1 IS NULL
                  AND ARNEWVALUE.REP_DT_1 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.REP_DT_1 = 'C'
         THEN
            LSOLDVALUE := 'Character';
         ELSIF AROLDVALUE.REP_DT_1 = 'N'
         THEN
            LSOLDVALUE := 'Numeric';
         ELSIF AROLDVALUE.REP_DT_1 = 'DT'
         THEN
            LSOLDVALUE := 'Datetime';
         ELSIF AROLDVALUE.REP_DT_1 = 'D'
         THEN
            LSOLDVALUE := 'Date';
         ELSIF AROLDVALUE.REP_DT_1 = 'S'
         THEN
            LSOLDVALUE := 'Part No';
         ELSIF AROLDVALUE.REP_DT_1 = 'R'
         THEN
            LSOLDVALUE := 'Part Rev';
         ELSIF AROLDVALUE.REP_DT_1 = 'DD'
         THEN
            LSOLDVALUE := 'Drop Down';
         ELSE
            LSOLDVALUE := '';
         END IF;

         IF ARNEWVALUE.REP_DT_1 = 'C'
         THEN
            LSNEWVALUE := 'Character';
         ELSIF ARNEWVALUE.REP_DT_1 = 'N'
         THEN
            LSNEWVALUE := 'Numeric';
         ELSIF ARNEWVALUE.REP_DT_1 = 'DT'
         THEN
            LSNEWVALUE := 'Datetime';
         ELSIF ARNEWVALUE.REP_DT_1 = 'D'
         THEN
            LSNEWVALUE := 'Date';
         ELSIF ARNEWVALUE.REP_DT_1 = 'S'
         THEN
            LSNEWVALUE := 'Part No';
         ELSIF ARNEWVALUE.REP_DT_1 = 'R'
         THEN
            LSNEWVALUE := 'Part Rev';
         ELSIF ARNEWVALUE.REP_DT_1 = 'DD'
         THEN
            LSNEWVALUE := 'Drop Down';
         ELSE
            LSNEWVALUE := '';
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Type argument 1> changed value from <'
                       || LSOLDVALUE
                       || '> to <'
                       || LSNEWVALUE
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_ARG2 <> ARNEWVALUE.REP_ARG2 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_ARG2 IS NULL
                  AND ARNEWVALUE.REP_ARG2 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Caption argument 2> changed value from <'
                       || AROLDVALUE.REP_ARG2
                       || '> to <'
                       || ARNEWVALUE.REP_ARG2
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_DT_2 <> ARNEWVALUE.REP_DT_2 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_DT_2 IS NULL
                  AND ARNEWVALUE.REP_DT_2 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.REP_DT_2 = 'C'
         THEN
            LSOLDVALUE := 'Character';
         ELSIF AROLDVALUE.REP_DT_2 = 'N'
         THEN
            LSOLDVALUE := 'Numeric';
         ELSIF AROLDVALUE.REP_DT_2 = 'DT'
         THEN
            LSOLDVALUE := 'Datetime';
         ELSIF AROLDVALUE.REP_DT_2 = 'D'
         THEN
            LSOLDVALUE := 'Date';
         ELSIF AROLDVALUE.REP_DT_2 = 'S'
         THEN
            LSOLDVALUE := 'Part No';
         ELSIF AROLDVALUE.REP_DT_2 = 'R'
         THEN
            LSOLDVALUE := 'Part Rev';
         ELSIF AROLDVALUE.REP_DT_2 = 'DD'
         THEN
            LSOLDVALUE := 'Drop Down';
         ELSE
            LSOLDVALUE := '';
         END IF;

         IF ARNEWVALUE.REP_DT_2 = 'C'
         THEN
            LSNEWVALUE := 'Character';
         ELSIF ARNEWVALUE.REP_DT_2 = 'N'
         THEN
            LSNEWVALUE := 'Numeric';
         ELSIF ARNEWVALUE.REP_DT_2 = 'DT'
         THEN
            LSNEWVALUE := 'Datetime';
         ELSIF ARNEWVALUE.REP_DT_2 = 'D'
         THEN
            LSNEWVALUE := 'Date';
         ELSIF ARNEWVALUE.REP_DT_2 = 'S'
         THEN
            LSNEWVALUE := 'Part No';
         ELSIF ARNEWVALUE.REP_DT_2 = 'R'
         THEN
            LSNEWVALUE := 'Part Rev';
         ELSIF ARNEWVALUE.REP_DT_2 = 'DD'
         THEN
            LSNEWVALUE := 'Drop Down';
         ELSE
            LSNEWVALUE := '';
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Type argument 2> changed value from <'
                       || AROLDVALUE.REP_DT_2
                       || '> to <'
                       || ARNEWVALUE.REP_DT_2
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_ARG3 <> ARNEWVALUE.REP_ARG3 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_ARG3 IS NULL
                  AND ARNEWVALUE.REP_ARG3 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Caption argument 3> changed value from <'
                       || AROLDVALUE.REP_ARG3
                       || '> to <'
                       || ARNEWVALUE.REP_ARG3
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_DT_3 <> ARNEWVALUE.REP_DT_3 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_DT_3 IS NULL
                  AND ARNEWVALUE.REP_DT_3 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.REP_DT_3 = 'C'
         THEN
            LSOLDVALUE := 'Character';
         ELSIF AROLDVALUE.REP_DT_3 = 'N'
         THEN
            LSOLDVALUE := 'Numeric';
         ELSIF AROLDVALUE.REP_DT_3 = 'DT'
         THEN
            LSOLDVALUE := 'Datetime';
         ELSIF AROLDVALUE.REP_DT_3 = 'D'
         THEN
            LSOLDVALUE := 'Date';
         ELSIF AROLDVALUE.REP_DT_3 = 'S'
         THEN
            LSOLDVALUE := 'Part No';
         ELSIF AROLDVALUE.REP_DT_3 = 'R'
         THEN
            LSOLDVALUE := 'Part Rev';
         ELSIF AROLDVALUE.REP_DT_3 = 'DD'
         THEN
            LSOLDVALUE := 'Drop Down';
         ELSE
            LSOLDVALUE := '';
         END IF;

         IF ARNEWVALUE.REP_DT_3 = 'C'
         THEN
            LSNEWVALUE := 'Character';
         ELSIF ARNEWVALUE.REP_DT_3 = 'N'
         THEN
            LSNEWVALUE := 'Numeric';
         ELSIF ARNEWVALUE.REP_DT_3 = 'DT'
         THEN
            LSNEWVALUE := 'Datetime';
         ELSIF ARNEWVALUE.REP_DT_3 = 'D'
         THEN
            LSNEWVALUE := 'Date';
         ELSIF ARNEWVALUE.REP_DT_3 = 'S'
         THEN
            LSNEWVALUE := 'Part No';
         ELSIF ARNEWVALUE.REP_DT_3 = 'R'
         THEN
            LSNEWVALUE := 'Part Rev';
         ELSIF ARNEWVALUE.REP_DT_3 = 'DD'
         THEN
            LSNEWVALUE := 'Drop Down';
         ELSE
            LSNEWVALUE := '';
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Type argument 3> changed value from <'
                       || AROLDVALUE.REP_DT_3
                       || '> to <'
                       || ARNEWVALUE.REP_DT_3
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_ARG4 <> ARNEWVALUE.REP_ARG4 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_ARG4 IS NULL
                  AND ARNEWVALUE.REP_ARG4 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Caption argument 4> changed value from <'
                       || AROLDVALUE.REP_ARG4
                       || '> to <'
                       || ARNEWVALUE.REP_ARG4
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_DT_4 <> ARNEWVALUE.REP_DT_4 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_DT_4 IS NULL
                  AND ARNEWVALUE.REP_DT_4 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         IF AROLDVALUE.REP_DT_4 = 'C'
         THEN
            LSOLDVALUE := 'Character';
         ELSIF AROLDVALUE.REP_DT_4 = 'N'
         THEN
            LSOLDVALUE := 'Numeric';
         ELSIF AROLDVALUE.REP_DT_4 = 'DT'
         THEN
            LSOLDVALUE := 'Datetime';
         ELSIF AROLDVALUE.REP_DT_4 = 'D'
         THEN
            LSOLDVALUE := 'Date';
         ELSIF AROLDVALUE.REP_DT_4 = 'S'
         THEN
            LSOLDVALUE := 'Part No';
         ELSIF AROLDVALUE.REP_DT_4 = 'R'
         THEN
            LSOLDVALUE := 'Part Rev';
         ELSIF AROLDVALUE.REP_DT_4 = 'DD'
         THEN
            LSOLDVALUE := 'Drop Down';
         ELSE
            LSOLDVALUE := '';
         END IF;

         IF ARNEWVALUE.REP_DT_4 = 'C'
         THEN
            LSNEWVALUE := 'Character';
         ELSIF ARNEWVALUE.REP_DT_4 = 'N'
         THEN
            LSNEWVALUE := 'Numeric';
         ELSIF ARNEWVALUE.REP_DT_4 = 'DT'
         THEN
            LSNEWVALUE := 'Datetime';
         ELSIF ARNEWVALUE.REP_DT_4 = 'D'
         THEN
            LSNEWVALUE := 'Date';
         ELSIF ARNEWVALUE.REP_DT_4 = 'S'
         THEN
            LSNEWVALUE := 'Part No';
         ELSIF ARNEWVALUE.REP_DT_4 = 'R'
         THEN
            LSNEWVALUE := 'Part Rev';
         ELSIF ARNEWVALUE.REP_DT_4 = 'DD'
         THEN
            LSNEWVALUE := 'Drop Down';
         ELSE
            LSNEWVALUE := '';
         END IF;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report <'
                       || ASDESCRIPTION
                       || '> is updated: property <Type argument 4> changed value from <'
                       || AROLDVALUE.REP_DT_4
                       || '> to <'
                       || ARNEWVALUE.REP_DT_4
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSARG;


   FUNCTION FILLREPORTHSDETAILSSQL(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASSQLDESCRIPTION           IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPSQL%ROWTYPE,
      ARNEWVALUE                 IN       ITREPSQL%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS


















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsSql';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.REP_SQL1 <> ARNEWVALUE.REP_SQL1 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_SQL1 IS NULL
                  AND ARNEWVALUE.REP_SQL1 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Reporting statement <'
                       || ASSQLDESCRIPTION
                       || '> is updated: property <SQL> changed value from <'
                       || AROLDVALUE.REP_SQL1
                       || '> to <'
                       || ARNEWVALUE.REP_SQL1
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_SQL2 <> ARNEWVALUE.REP_SQL2 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_SQL2 IS NULL
                  AND ARNEWVALUE.REP_SQL2 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Reporting statement <'
                       || ASSQLDESCRIPTION
                       || '> is updated: property <SQL2> changed value from <'
                       || AROLDVALUE.REP_SQL2
                       || '> to <'
                       || ARNEWVALUE.REP_SQL2
                       || '>.' );
      END IF;

      
      IF     NVL(  ( AROLDVALUE.REP_SQL3 <> ARNEWVALUE.REP_SQL3 ),
                  TRUE )
         AND NOT(     AROLDVALUE.REP_SQL3 IS NULL
                  AND ARNEWVALUE.REP_SQL3 IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPHSDETAILS
                     ( REP_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Reporting statement <'
                       || ASSQLDESCRIPTION
                       || '> is updated: property <SQL3> changed value from <'
                       || AROLDVALUE.REP_SQL3
                       || '> to <'
                       || ARNEWVALUE.REP_SQL3
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSSQL;


   FUNCTION FILLREPORTHSDETAILSAC(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPAC%ROWTYPE,
      ARNEWVALUE                 IN       ITREPAC%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsAc';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSAC;


   FUNCTION FILLREPORTHSDETAILSLINK(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPL%ROWTYPE,
      ARNEWVALUE                 IN       ITREPL%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportHsDetailsLink';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPHSDETAILS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTHSDETAILSLINK;


   FUNCTION FILLREPORTGROUPHSDETAILS(
      ANREPORTGROUPID            IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPG%ROWTYPE,
      ARNEWVALUE                 IN       ITREPG%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportGroupHsDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPGHSDETAILS
                  ( REPG_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      
      IF     NVL(  ( AROLDVALUE.DESCRIPTION <> ARNEWVALUE.DESCRIPTION ),
                  TRUE )
         AND NOT(     AROLDVALUE.DESCRIPTION IS NULL
                  AND ARNEWVALUE.DESCRIPTION IS NULL )
      THEN
         LNSEQNO :=   LNSEQNO
                    + 1;

         INSERT INTO ITREPGHSDETAILS
                     ( REPG_ID,
                       AUDIT_TRAIL_SEQ_NO,
                       SEQ_NO,
                       DETAILS )
              VALUES ( ANREPORTGROUPID,
                       ANAUDITTRAILSEQUENCENR,
                       LNSEQNO,
                          'Report group <'
                       || ASDESCRIPTION
                       || '> is updated: property <Description> changed value from <'
                       || AROLDVALUE.DESCRIPTION
                       || '> to <'
                       || ARNEWVALUE.DESCRIPTION
                       || '>.' );
      END IF;

      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTGROUPHSDETAILS;


   FUNCTION FILLREPORTGROUPHSDETAILSLINK(
      ANREPORTGROUPID            IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANAUDITTRAILSEQUENCENR     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASWHAT                     IN       IAPITYPE.WHAT_TYPE,
      AROLDVALUE                 IN       ITREPL%ROWTYPE,
      ARNEWVALUE                 IN       ITREPL%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillReportGroupHsDetailsLink';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
   BEGIN
      
      LNSEQNO := NVL( ANSEQUENCENR,
                      0 );

      INSERT INTO ITREPGHSDETAILS
                  ( REPG_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    SEQ_NO,
                    DETAILS )
           VALUES ( ANREPORTGROUPID,
                    ANAUDITTRAILSEQUENCENR,
                    LNSEQNO,
                    ASWHAT );

      
      ANSEQUENCENR := LNSEQNO;
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLREPORTGROUPHSDETAILSLINK;




   FUNCTION GETBOMJOURNAL(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      AQSPECIFICATIONS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomJournal';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT IBJ.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', IBJ.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', IBJ.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', IBJ.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', IBJ.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_get_bomusage(IBJ.BOM_USAGE) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', IBJ.ITEM_NUMBER '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ', IBJ.OLD_VALUE '
         || IAPICONSTANTCOLUMN.OLDVALUECOL
         || ', IBJ.NEW_VALUE '
         || IAPICONSTANTCOLUMN.NEWVALUECOL
         || ', IBJ.HEADER_ID '
         || IAPICONSTANTCOLUMN.HEADERIDCOL
         || ', F_HDH_DESCR( 1, IBJ.HEADER_ID, 0 ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', IBJ.FIELD_ID '
         || IAPICONSTANTCOLUMN.FIELDIDCOL
         || ', IBJ.FORENAME '
         || IAPICONSTANTCOLUMN.FORENAMECOL
         || ', IBJ.LAST_NAME '
         || IAPICONSTANTCOLUMN.LASTNAMECOL
         || ', IBJ.USER_ID '
         || IAPICONSTANTCOLUMN.USERIDCOL
         || ', IBJ.TIMESTAMP '
         || IAPICONSTANTCOLUMN.TIMESTAMPCOL;

      
      
      
      
      
      IF ( AQSPECIFICATIONS%ISOPEN )
      THEN
         CLOSE AQSPECIFICATIONS;
      END IF;

      LSSQLNULL :=    LSSQL
                   || ' FROM ITBOMJRNL IBJ WHERE IBJ.PART_NO = NULL';

      OPEN AQSPECIFICATIONS FOR LSSQLNULL;

      IF NOT ASPARTNO IS NULL
      THEN
         LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                            ANREVISION,
                                                            LNACCESS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         IF LNACCESS = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                       ASPARTNO,
                                                       ANREVISION );
         END IF;
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' FROM ITBOMJRNL IBJ, PART P, PART_PLANT PP'
                  || ' WHERE ';
      ELSE
         LSSQL :=    LSSQL
                  || ' FROM ITBOMJRNL IBJ'
                  || ' WHERE ';
      END IF;

      IF NOT ASPARTNO IS NULL
      THEN
         LSSQL :=    LSSQL
                  || ' IBJ.PART_NO = :asPartNo AND ';
      END IF;

      IF NOT ANREVISION IS NULL
      THEN
         LSSQL :=    LSSQL
                  || ' IBJ.REVISION = :anRevision AND ';
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=
               LSSQL
            || ' IBJ.PART_NO = P.PART_NO'
            || ' AND IBJ.PART_NO = PP.PART_NO'
            || ' AND IBJ.PLANT = PP.PLANT'
            || ' AND PP.PLANT_ACCESS = ''Y'''
            || ' AND IBJ.PLANT IN (SELECT PLANT FROM ITUP WHERE USER_ID = :lsUser)';
      ELSE
         LSSQL :=    LSSQL
                  || ' F_CHECK_ACCESS(IBJ.PART_NO, IBJ.REVISION) = 1';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY 1, 2, 3, 4, 5, 6';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      IF     ASPARTNO IS NOT NULL
         AND ANREVISION IS NOT NULL
      THEN
         IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
         THEN   
            OPEN AQSPECIFICATIONS FOR LSSQL USING ASPARTNO,
            ANREVISION,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQSPECIFICATIONS FOR LSSQL USING ASPARTNO,
            ANREVISION;
         END IF;
      END IF;

      IF     ASPARTNO IS NOT NULL
         AND ANREVISION IS NULL
      THEN
         IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
         THEN   
            OPEN AQSPECIFICATIONS FOR LSSQL USING ASPARTNO,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQSPECIFICATIONS FOR LSSQL USING ASPARTNO;
         END IF;
      END IF;

      IF     ASPARTNO IS NULL
         AND ANREVISION IS NOT NULL
      THEN
         IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
         THEN   
            OPEN AQSPECIFICATIONS FOR LSSQL USING ANREVISION,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQSPECIFICATIONS FOR LSSQL USING ANREVISION;
         END IF;
      END IF;

      IF     ASPARTNO IS NULL
         AND ANREVISION IS NULL
      THEN
         IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
         THEN   
            OPEN AQSPECIFICATIONS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQSPECIFICATIONS FOR LSSQL;
         END IF;
      END IF;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMJOURNAL;


   FUNCTION GETMESSAGE(
      ASMESSAGEID                IN       IAPITYPE.MESSAGEID_TYPE,
      ASPARAMETER1               IN       IAPITYPE.STRINGVAL_TYPE DEFAULT NULL,
      ASPARAMETER2               IN       IAPITYPE.STRINGVAL_TYPE DEFAULT NULL,
      ASPARAMETER3               IN       IAPITYPE.STRINGVAL_TYPE DEFAULT NULL,
      ASPARAMETER4               IN       IAPITYPE.STRINGVAL_TYPE DEFAULT NULL,
      ASPARAMETER5               IN       IAPITYPE.STRINGVAL_TYPE DEFAULT NULL,
      ASMESSAGE                  IN OUT   IAPITYPE.MESSAGETEXT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMessage';

      
      CURSOR LQMESSAGE(
         ASMESSAGEID                IN       ITMESSAGE.MSG_ID%TYPE )
      IS
         SELECT MSG.MESSAGE
           FROM ITMESSAGE MSG
          WHERE MSG.MSG_ID = ASMESSAGEID;

      LBFOUND                       BOOLEAN;
      LSMESSAGE                     ITMESSAGE.MESSAGE%TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LBFOUND := FALSE;




      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LQMESSAGE%ISOPEN )
      THEN
         CLOSE LQMESSAGE;
      END IF;

      
      FOR LRMESSAGE IN LQMESSAGE( ASMESSAGEID )
      LOOP
         LSMESSAGE := LRMESSAGE.MESSAGE;
         LBFOUND := TRUE;
      END LOOP;

      IF NOT( LBFOUND )
      THEN
         LSMESSAGE :=    'Message with id <'
                      || ASMESSAGEID
                      || '> could not be found. Parameters : %1 %2 %3 %4 %5';
         LSMESSAGE := REPLACE( LSMESSAGE,
                               '%1',
                               ASPARAMETER1 );
         LSMESSAGE := REPLACE( LSMESSAGE,
                               '%2',
                               ASPARAMETER2 );
         LSMESSAGE := REPLACE( LSMESSAGE,
                               '%3',
                               ASPARAMETER3 );
         LSMESSAGE := REPLACE( LSMESSAGE,
                               '%4',
                               ASPARAMETER4 );
         LSMESSAGE := REPLACE( LSMESSAGE,
                               '%5',
                               ASPARAMETER5 );
      ELSE
         IF ASPARAMETER1 IS NOT NULL
         THEN
            LSMESSAGE := REPLACE( LSMESSAGE,
                                  '%1',
                                  ASPARAMETER1 );
         END IF;

         IF ASPARAMETER2 IS NOT NULL
         THEN
            LSMESSAGE := REPLACE( LSMESSAGE,
                                  '%2',
                                  ASPARAMETER2 );
         END IF;

         IF ASPARAMETER3 IS NOT NULL
         THEN
            LSMESSAGE := REPLACE( LSMESSAGE,
                                  '%3',
                                  ASPARAMETER3 );
         END IF;

         IF ASPARAMETER4 IS NOT NULL
         THEN
            LSMESSAGE := REPLACE( LSMESSAGE,
                                  '%4',
                                  ASPARAMETER4 );
         END IF;

         IF ASPARAMETER5 IS NOT NULL
         THEN
            LSMESSAGE := REPLACE( LSMESSAGE,
                                  '%5',
                                  ASPARAMETER5 );
         END IF;
      END IF;

      ASMESSAGE := SUBSTR( LSMESSAGE,
                           1,
                           500 );
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMESSAGE;


   FUNCTION ADDUSERHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       APPLICATION_USER%ROWTYPE,
      ARNEWVALUE                 IN       APPLICATION_USER%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUserHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LSUSERIDCHANGED               IAPITYPE.USERID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;






      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_USER_INS';
         LSUSERIDCHANGED := ARNEWVALUE.USER_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_USER_UPD';
         LSUSERIDCHANGED := ARNEWVALUE.USER_ID;         
      
      ELSIF ASACTION =  'UPDATING_PWD'
      THEN
         LSWHATID := 'AT_USER_PWD_UPD';
         LSUSERIDCHANGED := ARNEWVALUE.USER_ID;
      
      ELSE
         LSWHATID := 'AT_USER_DEL';
         LSUSERIDCHANGED := AROLDVALUE.USER_ID;
      END IF;

      
      IF  LSWHATID = 'AT_USER_PWD_UPD'
      THEN
        LNRETVAL := GETMESSAGE( LSWHATID,
                                  LSUSERIDCHANGED,
                                  LSUSERID,
                                  NULL,
                                  NULL,
                                  NULL,
                                  LSWHAT );
      ELSE
     
      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSUSERIDCHANGED,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );
      
      END IF;                                    

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITUSHS
                  ( USER_ID_CHANGED,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LSUSERIDCHANGED,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLAUDITTRAILDETAILS( LSUSERIDCHANGED,
                                         LNAUDITTRAILSEQNO,
                                         LNSEQNO,
                                         LSWHAT,
                                         AROLDVALUE,
                                         ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDUSERHISTORY;


   FUNCTION ADDUSERHSADDUSERPLANT(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITUP%ROWTYPE,
      ARNEWVALUE                 IN       ITUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUserHsAddUserPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LSUSERIDCHANGED               IAPITYPE.USERID_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_USER_PLANT_INS';
         LSUSERIDCHANGED := ARNEWVALUE.USER_ID;
         LSPLANT := ARNEWVALUE.PLANT;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_USER_PLANT_UPD';
         LSUSERIDCHANGED := ARNEWVALUE.USER_ID;
         LSPLANT := ARNEWVALUE.PLANT;
      ELSE
         LSWHATID := 'AT_USER_PLANT_DEL';
         LSUSERIDCHANGED := AROLDVALUE.USER_ID;
         LSPLANT := AROLDVALUE.PLANT;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSUSERIDCHANGED,
                              LSPLANT,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITUSHS
                  ( USER_ID_CHANGED,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LSUSERIDCHANGED,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLUSERAUDITTRAILDETAILS( LSUSERIDCHANGED,
                                             LNAUDITTRAILSEQNO,
                                             LNSEQNO,
                                             LSWHAT,
                                             AROLDVALUE,
                                             ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDUSERHSADDUSERPLANT;


   FUNCTION ADDSTATUSHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       STATUS%ROWTYPE,
      ARNEWVALUE                 IN       STATUS%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddStatusHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LSSTATUS                      IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_STATUS_INS';
         LNSTATUS := ARNEWVALUE.STATUS;
         LSSTATUS := ARNEWVALUE.DESCRIPTION;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_STATUS_UPD';
         LNSTATUS := ARNEWVALUE.STATUS;
         LSSTATUS := ARNEWVALUE.DESCRIPTION;
      ELSE
         LSWHATID := 'AT_STATUS_DEL';
         LNSTATUS := AROLDVALUE.STATUS;
         LSSTATUS := AROLDVALUE.DESCRIPTION;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSSTATUS,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITSSHS
                  ( STATUS,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNSTATUS,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLSTATUSHSDETAILS( LNSTATUS,
                                       LSSTATUS,
                                       LNAUDITTRAILSEQNO,
                                       LNSEQNO,
                                       LSWHAT,
                                       AROLDVALUE,
                                       ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDSTATUSHISTORY;


   FUNCTION ADDWORKFLOWTYPEHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       WORK_FLOW_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       WORK_FLOW_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddWorkflowTypeHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNWORKFLOWTYPEID              IAPITYPE.WORKFLOWID_TYPE;
      LSWORKFLOWTYPE                IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_WORKFLOW_TYPE_INS';
         LNWORKFLOWTYPEID := ARNEWVALUE.WORK_FLOW_ID;
         LSWORKFLOWTYPE := ARNEWVALUE.DESCRIPTION;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_WORKFLOW_TYPE_UPD';
         LNWORKFLOWTYPEID := ARNEWVALUE.WORK_FLOW_ID;
         LSWORKFLOWTYPE := ARNEWVALUE.DESCRIPTION;
      ELSE
         LSWHATID := 'AT_WORKFLOW_TYPE_DEL';
         LNWORKFLOWTYPEID := AROLDVALUE.WORK_FLOW_ID;
         LSWORKFLOWTYPE := AROLDVALUE.DESCRIPTION;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSWORKFLOWTYPE,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITWTHS
                  ( WORK_FLOW_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNWORKFLOWTYPEID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLWORKFLOWTYPEHSDETAILS( LNWORKFLOWTYPEID,
                                             LSWORKFLOWTYPE,
                                             LNAUDITTRAILSEQNO,
                                             LNSEQNO,
                                             LSWHAT,
                                             AROLDVALUE,
                                             ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDWORKFLOWTYPEHISTORY;


   FUNCTION ADDWORKFLOWTYPELISTHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       WORK_FLOW%ROWTYPE,
      ARNEWVALUE                 IN       WORK_FLOW%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddWorkflowTypeListHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNWORKFLOWTYPEID              IAPITYPE.WORKFLOWID_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LNNEXTSTATUS                  IAPITYPE.STATUSID_TYPE;
      LSWORKFLOWTYPE                IAPITYPE.DESCRIPTION_TYPE;
      LSSTATUS                      IAPITYPE.DESCRIPTION_TYPE;
      LSNEXTSTATUS                  IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_WORKFLOW_TYPE_LIST_INS';
         LNWORKFLOWTYPEID := ARNEWVALUE.WORK_FLOW_ID;
         LNSTATUS := ARNEWVALUE.STATUS;
         LNNEXTSTATUS := ARNEWVALUE.NEXT_STATUS;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_WORKFLOW_TYPE_LIST_UPD';
         LNWORKFLOWTYPEID := ARNEWVALUE.WORK_FLOW_ID;
         LNSTATUS := ARNEWVALUE.STATUS;
         LNNEXTSTATUS := ARNEWVALUE.NEXT_STATUS;
      ELSE
         LSWHATID := 'AT_WORKFLOW_TYPE_LIST_DEL';
         LNWORKFLOWTYPEID := AROLDVALUE.WORK_FLOW_ID;
         LNSTATUS := AROLDVALUE.STATUS;
         LNNEXTSTATUS := AROLDVALUE.NEXT_STATUS;
      END IF;

      SELECT DESCRIPTION
        INTO LSWORKFLOWTYPE
        FROM WORK_FLOW_GROUP
       WHERE WORK_FLOW_ID = LNWORKFLOWTYPEID;

      SELECT DESCRIPTION
        INTO LSSTATUS
        FROM STATUS
       WHERE STATUS = LNSTATUS;

      SELECT DESCRIPTION
        INTO LSNEXTSTATUS
        FROM STATUS
       WHERE STATUS = LNNEXTSTATUS;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSWORKFLOWTYPE,
                              LSSTATUS,
                              LSNEXTSTATUS,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITWTHS
                  ( WORK_FLOW_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNWORKFLOWTYPEID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL :=
         FILLWORKFLOWTYPEHSDETAILSLIST( LNWORKFLOWTYPEID,
                                        LSWORKFLOWTYPE,
                                        LSSTATUS,
                                        LSNEXTSTATUS,
                                        LNAUDITTRAILSEQNO,
                                        LNSEQNO,
                                        LSWHAT,
                                        AROLDVALUE,
                                        ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDWORKFLOWTYPELISTHISTORY;


   FUNCTION ADDWORKFLOWGROUPHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       WORKFLOW_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       WORKFLOW_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddWorkflowGroupHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_WORKFLOW_GROUP_INS';
         LNWORKFLOWGROUPID := ARNEWVALUE.WORKFLOW_GROUP_ID;
         LSDESCRIPTION := ARNEWVALUE.SORT_DESC;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_WORKFLOW_GROUP_UPD';
         LNWORKFLOWGROUPID := ARNEWVALUE.WORKFLOW_GROUP_ID;
         LSDESCRIPTION := ARNEWVALUE.SORT_DESC;
      ELSE
         LSWHATID := 'AT_WORKFLOW_GROUP_DEL';
         LNWORKFLOWGROUPID := AROLDVALUE.WORKFLOW_GROUP_ID;
         LSDESCRIPTION := AROLDVALUE.SORT_DESC;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITWGHS
                  ( WORKFLOW_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNWORKFLOWGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLWORKFLOWGROUPHSDETAILS( LNWORKFLOWGROUPID,
                                              LSDESCRIPTION,
                                              LNAUDITTRAILSEQNO,
                                              LNSEQNO,
                                              LSWHAT,
                                              AROLDVALUE,
                                              ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDWORKFLOWGROUPHISTORY;


   FUNCTION ADDWORKFLOWGROUPLISTHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       WORK_FLOW_LIST%ROWTYPE,
      ARNEWVALUE                 IN       WORK_FLOW_LIST%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddWorkflowGroupListHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LSWORKFLOWGROUP               IAPITYPE.PARAMETER_TYPE;
      LSSTATUS                      IAPITYPE.DESCRIPTION_TYPE;
      LSUSERGROUP                   IAPITYPE.USERGROUPDESC_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_WORKFLOW_GROUP_LIST_INS';
         LNWORKFLOWGROUPID := ARNEWVALUE.WORKFLOW_GROUP_ID;
         LNSTATUS := ARNEWVALUE.STATUS;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_WORKFLOW_GROUP_LIST_UPD';
         LNWORKFLOWGROUPID := ARNEWVALUE.WORKFLOW_GROUP_ID;
         LNSTATUS := ARNEWVALUE.STATUS;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
      ELSE
         LSWHATID := 'AT_WORKFLOW_GROUP_LIST_DEL';
         LNWORKFLOWGROUPID := AROLDVALUE.WORKFLOW_GROUP_ID;
         LNSTATUS := AROLDVALUE.STATUS;
         LNUSERGROUPID := AROLDVALUE.USER_GROUP_ID;
      END IF;

      SELECT SORT_DESC
        INTO LSWORKFLOWGROUP
        FROM WORKFLOW_GROUP
       WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID;

      SELECT DESCRIPTION
        INTO LSSTATUS
        FROM STATUS
       WHERE STATUS = LNSTATUS;

      SELECT SHORT_DESC
        INTO LSUSERGROUP
        FROM USER_GROUP
       WHERE USER_GROUP_ID = LNUSERGROUPID;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSWORKFLOWGROUP,
                              LSSTATUS,
                              LSUSERGROUP,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITWGHS
                  ( WORKFLOW_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNWORKFLOWGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL :=
         FILLWORKFLOWGROUPHSDETAILSLIST( LNWORKFLOWGROUPID,
                                         LSWORKFLOWGROUP,
                                         LSSTATUS,
                                         LSUSERGROUP,
                                         LNAUDITTRAILSEQNO,
                                         LNSEQNO,
                                         LSWHAT,
                                         AROLDVALUE,
                                         ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      LNSEQNO := 1;

      INSERT INTO ITUGHS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNUSERGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL :=
         FILLUSERGROUPHSDETAILSLIST3( LNUSERGROUPID,
                                      LSUSERGROUP,
                                      LSWORKFLOWGROUP,
                                      LSSTATUS,
                                      LNAUDITTRAILSEQNO,
                                      LNSEQNO,
                                      LSWHAT,
                                      AROLDVALUE,
                                      ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDWORKFLOWGROUPLISTHISTORY;


   FUNCTION ADDWORKFLOWGROUPFILTERHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       USER_WORKFLOW_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_WORKFLOW_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddWorkflowGroupFilterHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LSWORKFLOWGROUP               IAPITYPE.PARAMETER_TYPE;
      LSUSERGROUP                   IAPITYPE.USERGROUPDESC_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_WORKFLOW_GROUP_FILT_INS';
         LNWORKFLOWGROUPID := ARNEWVALUE.WORKFLOW_GROUP_ID;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_WORKFLOW_GROUP_FILT_UPD';
         LNWORKFLOWGROUPID := ARNEWVALUE.WORKFLOW_GROUP_ID;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
      ELSE
         LSWHATID := 'AT_WORKFLOW_GROUP_FILT_DEL';
         LNWORKFLOWGROUPID := AROLDVALUE.WORKFLOW_GROUP_ID;
         LNUSERGROUPID := AROLDVALUE.USER_GROUP_ID;
      END IF;

      SELECT SORT_DESC
        INTO LSWORKFLOWGROUP
        FROM WORKFLOW_GROUP
       WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID;

      SELECT SHORT_DESC
        INTO LSUSERGROUP
        FROM USER_GROUP
       WHERE USER_GROUP_ID = LNUSERGROUPID;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSWORKFLOWGROUP,
                              LSUSERGROUP,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITWGHS
                  ( WORKFLOW_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNWORKFLOWGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL :=
         FILLWORKFLOWGROUPHSDETAILSFILT( LNWORKFLOWGROUPID,
                                         LSWORKFLOWGROUP,
                                         LSUSERGROUP,
                                         LNAUDITTRAILSEQNO,
                                         LNSEQNO,
                                         LSWHAT,
                                         AROLDVALUE,
                                         ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      LNSEQNO := 1;

      INSERT INTO ITUGHS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNUSERGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL :=
               FILLUSERGROUPHSDETAILSFILTER( LNUSERGROUPID,
                                             LSUSERGROUP,
                                             LSWORKFLOWGROUP,
                                             LNAUDITTRAILSEQNO,
                                             LNSEQNO,
                                             LSWHAT,
                                             AROLDVALUE,
                                             ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDWORKFLOWGROUPFILTERHISTORY;


   FUNCTION ADDACCESSGROUPHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ACCESS_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       ACCESS_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddAccessGroupHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNACCESSGROUP                 IAPITYPE.USERGROUPID_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_ACCESS_GROUP_INS';
         LNACCESSGROUP := ARNEWVALUE.ACCESS_GROUP;
         LSDESCRIPTION := ARNEWVALUE.SORT_DESC;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_ACCESS_GROUP_UPD';
         LNACCESSGROUP := ARNEWVALUE.ACCESS_GROUP;
         LSDESCRIPTION := ARNEWVALUE.SORT_DESC;
      ELSE
         LSWHATID := 'AT_ACCESS_GROUP_DEL';
         LNACCESSGROUP := AROLDVALUE.ACCESS_GROUP;
         LSDESCRIPTION := AROLDVALUE.SORT_DESC;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITAGHS
                  ( ACCESS_GROUP,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNACCESSGROUP,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLACCESSGROUPHSDETAILS( LNACCESSGROUP,
                                            LSDESCRIPTION,
                                            LNAUDITTRAILSEQNO,
                                            LNSEQNO,
                                            LSWHAT,
                                            AROLDVALUE,
                                            ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDACCESSGROUPHISTORY;


   FUNCTION ADDACCESSGROUPLISTHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       USER_ACCESS_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_ACCESS_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddAccessGroupListHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNACCESSGROUP                 IAPITYPE.USERGROUPID_TYPE;
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LSACCESSGROUP                 IAPITYPE.SHORTDESCRIPTION_TYPE;
      LSUSERGROUP                   IAPITYPE.USERGROUPDESC_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_ACCESS_GROUP_LIST_INS';
         LNACCESSGROUP := ARNEWVALUE.ACCESS_GROUP;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_ACCESS_GROUP_LIST_UPD';
         LNACCESSGROUP := ARNEWVALUE.ACCESS_GROUP;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
      ELSE
         LSWHATID := 'AT_ACCESS_GROUP_LIST_DEL';
         LNACCESSGROUP := AROLDVALUE.ACCESS_GROUP;
         LNUSERGROUPID := AROLDVALUE.USER_GROUP_ID;
      END IF;

      SELECT SORT_DESC
        INTO LSACCESSGROUP
        FROM ACCESS_GROUP
       WHERE ACCESS_GROUP = LNACCESSGROUP;

      SELECT SHORT_DESC
        INTO LSUSERGROUP
        FROM USER_GROUP
       WHERE USER_GROUP_ID = LNUSERGROUPID;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSACCESSGROUP,
                              LSUSERGROUP,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITAGHS
                  ( ACCESS_GROUP,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNACCESSGROUP,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL :=
                 FILLACCESSGROUPHSDETAILSLIST( LNACCESSGROUP,
                                               LSACCESSGROUP,
                                               LSUSERGROUP,
                                               LNAUDITTRAILSEQNO,
                                               LNSEQNO,
                                               LSWHAT,
                                               AROLDVALUE,
                                               ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      LNSEQNO := 1;

      INSERT INTO ITUGHS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNUSERGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLUSERGROUPHSDETAILSLIST2( LNUSERGROUPID,
                                               LSUSERGROUP,
                                               LSACCESSGROUP,
                                               LNAUDITTRAILSEQNO,
                                               LNSEQNO,
                                               LSWHAT,
                                               AROLDVALUE,
                                               ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDACCESSGROUPLISTHISTORY;


   FUNCTION ADDUSERGROUPHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       USER_GROUP%ROWTYPE,
      ARNEWVALUE                 IN       USER_GROUP%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUserGroupHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LSDESCRIPTION                 IAPITYPE.USERGROUPDESC_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_USER_GROUP_INS';
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
         LSDESCRIPTION := ARNEWVALUE.SHORT_DESC;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_USER_GROUP_UPD';
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
         LSDESCRIPTION := ARNEWVALUE.SHORT_DESC;
      ELSE
         LSWHATID := 'AT_USER_GROUP_DEL';
         LNUSERGROUPID := AROLDVALUE.USER_GROUP_ID;
         LSDESCRIPTION := AROLDVALUE.SHORT_DESC;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITUGHS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNUSERGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLUSERGROUPHSDETAILS( LNUSERGROUPID,
                                          LSDESCRIPTION,
                                          LNAUDITTRAILSEQNO,
                                          LNSEQNO,
                                          LSWHAT,
                                          AROLDVALUE,
                                          ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDUSERGROUPHISTORY;


   FUNCTION ADDUSERGROUPLISTHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       USER_GROUP_LIST%ROWTYPE,
      ARNEWVALUE                 IN       USER_GROUP_LIST%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUserGroupListHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LSUSER                        IAPITYPE.USERID_TYPE;
      LSDESCRIPTION                 IAPITYPE.USERGROUPDESC_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_USER_GROUP_LIST_INS';
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
         LSUSER := ARNEWVALUE.USER_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_USER_GROUP_LIST_UPD';
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
         LSUSER := ARNEWVALUE.USER_ID;
      ELSE
         LSWHATID := 'AT_USER_GROUP_LIST_DEL';
         LNUSERGROUPID := AROLDVALUE.USER_GROUP_ID;
         LSUSER := AROLDVALUE.USER_ID;
      END IF;

      SELECT SHORT_DESC
        INTO LSDESCRIPTION
        FROM USER_GROUP
       WHERE USER_GROUP_ID = LNUSERGROUPID;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              LSUSER,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITUGHS
                  ( USER_GROUP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNUSERGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLUSERGROUPHSDETAILSLIST1( LNUSERGROUPID,
                                               LSDESCRIPTION,
                                               LNAUDITTRAILSEQNO,
                                               LNSEQNO,
                                               LSWHAT,
                                               AROLDVALUE,
                                               ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      LNSEQNO := 1;

      INSERT INTO ITUSHS
                  ( USER_ID_CHANGED,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LSUSER,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLUSERHSDETAILSUSERGROUP( LSUSER,
                                              LSDESCRIPTION,
                                              LNAUDITTRAILSEQNO,
                                              LNSEQNO,
                                              LSWHAT,
                                              AROLDVALUE,
                                              ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDUSERGROUPLISTHISTORY;


   FUNCTION ADDREPORTHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPD%ROWTYPE,
      ARNEWVALUE                 IN       ITREPD%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_INS';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSDESCRIPTION := ARNEWVALUE.SORT_DESC;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_UPD';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSDESCRIPTION := ARNEWVALUE.SORT_DESC;
      ELSE
         LSWHATID := 'AT_REPORT_DEL';
         LNREPORTID := AROLDVALUE.REP_ID;
         LSDESCRIPTION := AROLDVALUE.SORT_DESC;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITREPHS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLREPORTHSDETAILS( LNREPORTID,
                                       LSDESCRIPTION,
                                       LNAUDITTRAILSEQNO,
                                       LNSEQNO,
                                       LSWHAT,
                                       AROLDVALUE,
                                       ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTHISTORY;


   FUNCTION ADDREPORTNSTDEFHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPNSTDEF%ROWTYPE,
      ARNEWVALUE                 IN       ITREPNSTDEF%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportNstDefHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LSNREPTYPE                    IAPITYPE.REPORTITEMTYPE_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
      LSREPORTTYPE                  IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_NSTDEF_INS';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSNREPTYPE := ARNEWVALUE.NREP_TYPE;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_NSTDEF_UPD';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSNREPTYPE := ARNEWVALUE.NREP_TYPE;
      ELSE
         LSWHATID := 'AT_REPORT_NSTDEF_DEL';
         LNREPORTID := AROLDVALUE.REP_ID;
         LSNREPTYPE := AROLDVALUE.NREP_TYPE;
      END IF;

      SELECT SORT_DESC
        INTO LSDESCRIPTION
        FROM ITREPD
       WHERE REP_ID = LNREPORTID;

      IF LSNREPTYPE = 'att'
      THEN
         LSREPORTTYPE := 'Attached Spec';
      ELSIF LSNREPTYPE = 'bmh'
      THEN
         LSREPORTTYPE := 'BoM Header (retrieval)';
      ELSIF LSNREPTYPE = 'bmp'
      THEN
         LSREPORTTYPE := 'Header Logo (Bitmap)';
      ELSIF LSNREPTYPE = 'bom'
      THEN
         LSREPORTTYPE := 'Bill of Material';
      ELSIF LSNREPTYPE = 'cobj_1[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 1';
      ELSIF LSNREPTYPE = 'cobj_2[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 2';
      ELSIF LSNREPTYPE = 'cobj_3[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 3';
      ELSIF LSNREPTYPE = 'cobj_4[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 4';
      ELSIF LSNREPTYPE = 'cobj_5[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 5';
      ELSIF LSNREPTYPE = 'cobj_1[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 1';
      ELSIF LSNREPTYPE = 'cobj_2[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 2';
      ELSIF LSNREPTYPE = 'cobj_3[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 3';
      ELSIF LSNREPTYPE = 'cobj_4[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 4';
      ELSIF LSNREPTYPE = 'cobj_5[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 5';
      ELSIF LSNREPTYPE = 'data'
      THEN
         LSREPORTTYPE := 'Section List';
      ELSIF LSNREPTYPE = 'ft'
      THEN
         LSREPORTTYPE := 'Free Text';
      ELSIF LSNREPTYPE = 'ftr'
      THEN
         LSREPORTTYPE := 'Report Footer';
      ELSIF LSNREPTYPE = 'hdr'
      THEN
         LSREPORTTYPE := 'Report Header';
      ELSIF LSNREPTYPE = 'ing'
      THEN
         LSREPORTTYPE := 'Ingredient List';
      ELSIF LSNREPTYPE = 'kw'
      THEN
         LSREPORTTYPE := 'Keywords';
      ELSIF LSNREPTYPE = 'obj'
      THEN
         LSREPORTTYPE := 'Object';
      ELSIF LSNREPTYPE = 'objnv'
      THEN
         LSREPORTTYPE := 'non-visual Object';
      ELSIF LSNREPTYPE = 'pg'
      THEN
         LSREPORTTYPE := 'Property Group';
      ELSIF LSNREPTYPE = 'pl'
      THEN
         LSREPORTTYPE := 'Process Line';
      ELSIF LSNREPTYPE = 'proc'
      THEN
         LSREPORTTYPE := 'Stored Procedure';
      ELSIF LSNREPTYPE = 'rep'
      THEN
         LSREPORTTYPE := 'Number of lines';
      ELSIF LSNREPTYPE = 'rfi'
      THEN
         LSREPORTTYPE := 'Reason for Issue';
      ELSIF LSNREPTYPE = 'rfr'
      THEN
         LSREPORTTYPE := 'Reason for Rejection';
      ELSIF LSNREPTYPE = 'rt'
      THEN
         LSREPORTTYPE := 'Reference Text';
      ELSIF LSNREPTYPE = 'rta'
      THEN
         LSREPORTTYPE := '<Any> Indicator';
      ELSIF LSNREPTYPE = 'rtd'
      THEN
         LSREPORTTYPE := 'Reference Text (only title)';
      ELSIF LSNREPTYPE = 'sc'
      THEN
         LSREPORTTYPE := 'Section/Sub-Section';
      ELSIF LSNREPTYPE = 'sp'
      THEN
         LSREPORTTYPE := 'Single Property';
      ELSIF LSNREPTYPE = 'st'
      THEN
         LSREPORTTYPE := 'Stages';
      ELSIF LSNREPTYPE = 'stft'
      THEN
         LSREPORTTYPE := 'Stages Free Text';
      ELSIF LSNREPTYPE = 'title'
      THEN
         LSREPORTTYPE := 'Report Title';
      ELSIF LSNREPTYPE = 'pagepos'
      THEN
         LSREPORTTYPE := 'Position Page ind.';
      ELSIF LSNREPTYPE = 'cl'
      THEN
         LSREPORTTYPE := 'Classification';
      ELSIF LSNREPTYPE = 'conf'
      THEN
         LSREPORTTYPE := 'Confidential';
      ELSIF LSNREPTYPE = 'bomh'
      THEN
         LSREPORTTYPE := 'Bom Header (layout)';
      ELSIF LSNREPTYPE = 'eatt'
      THEN
         LSREPORTTYPE := 'Explode Attachments';
      ELSE
         LSREPORTTYPE := LSNREPTYPE;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              LSREPORTTYPE,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITREPHS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL :=
          FILLREPORTHSDETAILSNSTDEF( LNREPORTID,
                                     LSDESCRIPTION,
                                     LSNREPTYPE,
                                     LSREPORTTYPE,
                                     LNAUDITTRAILSEQNO,
                                     LNSEQNO,
                                     LSWHAT,
                                     AROLDVALUE,
                                     ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTNSTDEFHISTORY;


   FUNCTION ADDREPORTDATAHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPDATA%ROWTYPE,
      ARNEWVALUE                 IN       ITREPDATA%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportDataHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LSNREPTYPE                    IAPITYPE.REPORTITEMTYPE_TYPE;
      LNREFID                       IAPITYPE.ID_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
      
      
      
      
      
      LSREPORTTYPE                  IAPITYPE.DESCRIPTIONREPORTTYPE_TYPE;
      
      LNWINDOWTYPE                  IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Calling GetSequence',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Calling GetUserInfo',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Retrieve the audit trail message asAction = '
                           || ASACTION,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_DATA_INS';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSNREPTYPE := ARNEWVALUE.NREP_TYPE;
         LNREFID := ARNEWVALUE.REF_ID;
         LNOWNER := ARNEWVALUE.REF_OWNER;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_DATA_UPD';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSNREPTYPE := ARNEWVALUE.NREP_TYPE;
         LNREFID := ARNEWVALUE.REF_ID;
         LNOWNER := ARNEWVALUE.REF_OWNER;
      ELSE
         LSWHATID := 'AT_REPORT_DATA_DEL';
         LNREPORTID := AROLDVALUE.REP_ID;
         LSNREPTYPE := AROLDVALUE.NREP_TYPE;
         LNREFID := AROLDVALUE.REF_ID;
         LNOWNER := AROLDVALUE.REF_OWNER;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Select sort_desc rep_id = '
                           || LNREPORTID,
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT SORT_DESC
        INTO LSDESCRIPTION
        FROM ITREPD
       WHERE REP_ID = LNREPORTID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lnRepType = '
                           || LSNREPTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF LSNREPTYPE = 'bomalt'
      THEN
         LSREPORTTYPE := 'Alternative BoM Items';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'esc'
      THEN
         LSREPORTTYPE := 'Empty Section';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'esp'
      THEN
         LSREPORTTYPE := 'Empty Property';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'rfi'
      THEN
         LSREPORTTYPE := 'Reason For Issue';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'rfr'
      THEN
         LSREPORTTYPE := 'Reason For Rejection';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'asc'
      THEN
         LSREPORTTYPE := 'All Sections';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'eft'
      THEN
         LSREPORTTYPE := 'Empty Text';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'kw'
      THEN
         LSREPORTTYPE := 'KeyWords';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'eat'
      THEN
         LSREPORTTYPE := 'Explode Attachments';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'sem'
      THEN
         LSREPORTTYPE := 'Empty Section message';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'irt'
      THEN
         LSREPORTTYPE := 'Reference Text';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'cl'
      THEN
         LSREPORTTYPE := 'Classification';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'suppl'
      THEN
         LSREPORTTYPE := 'Supplier Report';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'mfc'
      THEN
         LSREPORTTYPE := 'Manufacturer';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'pobj'
      THEN
         LSREPORTTYPE := 'Attachments';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'tm'
      THEN
         LSREPORTTYPE := 'Test Methods';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'stpb'
      THEN
         LSREPORTTYPE := 'PageBreak ProcessLine';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'hdrb'
      THEN
         LSREPORTTYPE := 'Report header border';
         LNWINDOWTYPE := 1;
      ELSIF LSNREPTYPE = 'note'
      THEN
         LSREPORTTYPE := 'Note';
         LNWINDOWTYPE := 1;
      
      ELSIF LSNREPTYPE = '0'
      THEN
         LSREPORTTYPE := F_SCH_DESCR( 1,
                                      LNREFID,
                                      0 );
         LNWINDOWTYPE := 2;
      
      ELSIF LSNREPTYPE = '1'
      THEN
         LSREPORTTYPE := F_PGH_DESCR( 1,
                                      LNREFID,
                                      0 );
         LSREPORTTYPE :=    'Property Group: '
                         || LSREPORTTYPE;
         LNWINDOWTYPE := 3;
      
      ELSIF LSNREPTYPE = '2'
      THEN
         LSREPORTTYPE := F_RTH_DESCR( 1,
                                      LNREFID,
                                      LNOWNER );
         LSREPORTTYPE :=    'Reference Text: '
                         || LSREPORTTYPE;
         LNWINDOWTYPE := 3;
      
      ELSIF LSNREPTYPE = '3'
      THEN
         LSREPORTTYPE := 'Bill of Material';
         LNWINDOWTYPE := 3;
      
      ELSIF LSNREPTYPE = '4'
      THEN
         LSREPORTTYPE := F_SPH_DESCR( 1,
                                      LNREFID,
                                      0 );
         LSREPORTTYPE :=    'Single Property: '
                         || LSREPORTTYPE;
         LNWINDOWTYPE := 3;
      
      ELSIF LSNREPTYPE = '5'
      THEN
         LSREPORTTYPE := F_FTH_DESCR( 1,
                                      LNREFID,
                                      0 );
         LSREPORTTYPE :=    'Free Text: '
                         || LSREPORTTYPE;
         LNWINDOWTYPE := 3;
      
      ELSIF LSNREPTYPE = '6'
      THEN
         LSREPORTTYPE := F_OIH_DESCR( 1,
                                      LNREFID,
                                      LNOWNER );
         LSREPORTTYPE :=    'Object: '
                         || LSREPORTTYPE;
         LNWINDOWTYPE := 3;
      
      ELSIF LSNREPTYPE = '7'
      THEN
         LSREPORTTYPE := 'Process';
         LNWINDOWTYPE := 3;
      
      ELSIF LSNREPTYPE = '8'
      THEN
         LSREPORTTYPE := 'Attached Specs';
         LNWINDOWTYPE := 3;
      ELSIF LSNREPTYPE = 'cobj_1[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 1';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_2[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 2';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_3[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 3';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_4[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 4';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_5[1]'
      THEN
         LSREPORTTYPE := 'Custom Obj (row) 5';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_1[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 1';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_2[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 2';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_3[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 3';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_4[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 4';
         LNWINDOWTYPE := 4;
      ELSIF LSNREPTYPE = 'cobj_5[2]'
      THEN
         LSREPORTTYPE := 'Custom Obj (txt) 5';
         LNWINDOWTYPE := 4;
      ELSE
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      LSWHATID :=    LSWHATID
                  || '_'
                  || TO_CHAR( LNWINDOWTYPE );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'GetMessage ',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              LSREPORTTYPE,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Insert into itrephs ',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITREPHS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'WindowType = '
                           || LNWINDOWTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF LNWINDOWTYPE = 1
      THEN
         LNRETVAL :=
            FILLREPORTHSDETAILSDATA1( LNREPORTID,
                                      LSDESCRIPTION,
                                      LSNREPTYPE,
                                      LSREPORTTYPE,
                                      LNAUDITTRAILSEQNO,
                                      LNSEQNO,
                                      LSWHAT,
                                      AROLDVALUE,
                                      ARNEWVALUE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
      ELSIF LNWINDOWTYPE = 2
      THEN
         LNRETVAL :=
            FILLREPORTHSDETAILSDATA2( LNREPORTID,
                                      LSDESCRIPTION,
                                      LSNREPTYPE,
                                      LSREPORTTYPE,
                                      LNAUDITTRAILSEQNO,
                                      LNSEQNO,
                                      LSWHAT,
                                      AROLDVALUE,
                                      ARNEWVALUE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
      ELSIF LNWINDOWTYPE = 3
      THEN
         LNRETVAL :=
            FILLREPORTHSDETAILSDATA3( LNREPORTID,
                                      LSDESCRIPTION,
                                      LSNREPTYPE,
                                      LSREPORTTYPE,
                                      LNAUDITTRAILSEQNO,
                                      LNSEQNO,
                                      LSWHAT,
                                      AROLDVALUE,
                                      ARNEWVALUE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
      ELSIF LNWINDOWTYPE = 4
      THEN
         LNRETVAL :=
            FILLREPORTHSDETAILSDATA4( LNREPORTID,
                                      LSDESCRIPTION,
                                      LSNREPTYPE,
                                      LSREPORTTYPE,
                                      LNAUDITTRAILSEQNO,
                                      LNSEQNO,
                                      LSWHAT,
                                      AROLDVALUE,
                                      ARNEWVALUE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTDATAHISTORY;


   FUNCTION ADDREPORTARGHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPARG%ROWTYPE,
      ARNEWVALUE                 IN       ITREPARG%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportArgHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_ARG_INS';
         LNREPORTID := ARNEWVALUE.REP_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_ARG_UPD';
         LNREPORTID := ARNEWVALUE.REP_ID;
      ELSE
         LSWHATID := 'AT_REPORT_ARG_DEL';
         LNREPORTID := AROLDVALUE.REP_ID;
      END IF;

      SELECT SORT_DESC
        INTO LSDESCRIPTION
        FROM ITREPD
       WHERE REP_ID = LNREPORTID;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITREPHS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLREPORTHSDETAILSARG( LNREPORTID,
                                          LSDESCRIPTION,
                                          LNAUDITTRAILSEQNO,
                                          LNSEQNO,
                                          LSWHAT,
                                          AROLDVALUE,
                                          ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTARGHISTORY;


   FUNCTION ADDREPORTSQLHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPSQL%ROWTYPE,
      ARNEWVALUE                 IN       ITREPSQL%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportSqlHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LSSORTDESC                    IAPITYPE.SHORTDESCRIPTION_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_SQL_INS';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSSORTDESC := ARNEWVALUE.SORT_DESC;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_SQL_UPD';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LSSORTDESC := ARNEWVALUE.SORT_DESC;
      ELSE
         LSWHATID := 'AT_REPORT_SQL_DEL';
         LNREPORTID := AROLDVALUE.REP_ID;
         LSSORTDESC := AROLDVALUE.SORT_DESC;
      END IF;

      IF LNREPORTID = 0
      THEN
         LSDESCRIPTION := 'SQL';
      ELSE
         SELECT SORT_DESC
           INTO LSDESCRIPTION
           FROM ITREPD
          WHERE REP_ID = LNREPORTID;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSSORTDESC,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITREPHS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLREPORTHSDETAILSSQL( LNREPORTID,
                                          LSDESCRIPTION,
                                          LSSORTDESC,
                                          LNAUDITTRAILSEQNO,
                                          LNSEQNO,
                                          LSWHAT,
                                          AROLDVALUE,
                                          ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTSQLHISTORY;


   FUNCTION ADDREPORTACCESSHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPAC%ROWTYPE,
      ARNEWVALUE                 IN       ITREPAC%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportAccessHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LSUSER                        IAPITYPE.USERID_TYPE;
      LSACCESSTYPE                  IAPITYPE.ACCESS_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
      LSUSERGROUP                   IAPITYPE.USERGROUPDESC_TYPE;
      LSTEXT                        VARCHAR2( 100 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           ' Retrieve the user id information',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' Retrieve the audit trail message action = '
                           || ASACTION,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_AC_INS';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
         LSUSER := ARNEWVALUE.USER_ID;
         LSACCESSTYPE := ARNEWVALUE.ACCESS_TYPE;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_AC_UPD';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LNUSERGROUPID := ARNEWVALUE.USER_GROUP_ID;
         LSUSER := ARNEWVALUE.USER_ID;
         LSACCESSTYPE := ARNEWVALUE.ACCESS_TYPE;
      ELSE
         LSWHATID := 'AT_REPORT_AC_DEL';
         LNREPORTID := AROLDVALUE.REP_ID;
         LNUSERGROUPID := AROLDVALUE.USER_GROUP_ID;
         LSUSER := AROLDVALUE.USER_ID;
         LSACCESSTYPE := AROLDVALUE.ACCESS_TYPE;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' Select Sort desc = '
                           || ASACTION,
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT SORT_DESC
        INTO LSDESCRIPTION
        FROM ITREPD
       WHERE REP_ID = LNREPORTID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' Select Short desc = '
                           || ASACTION,
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT SHORT_DESC
        INTO LSUSERGROUP
        FROM USER_GROUP
       WHERE USER_GROUP_ID = LNUSERGROUPID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' AccessType = '
                           || LSACCESSTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF LSACCESSTYPE = 'A'
      THEN
         LSTEXT :=    'for user group <'
                   || LSUSERGROUP
                   || '>';
      ELSIF LSACCESSTYPE = 'U'
      THEN
         LSTEXT :=    'for user <'
                   || LSUSER
                   || '>';
      ELSIF LSACCESSTYPE = 'G'
      THEN
         LSTEXT :=    'for usergroup <'
                   || LSUSERGROUP
                   || '>';
      ELSE
         LSTEXT :=    'for usergroup <'
                   || LSUSERGROUP
                   || '> and user <'
                   || LSUSER
                   || '> and access type <'
                   || LSACCESSTYPE
                   || '>';
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' Before GetMessage = '
                           || LSACCESSTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              LSTEXT,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' Before insert into itrephs = '
                           || LSACCESSTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITREPHS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' Before FillReportHsDetailsAc '
                           || LSACCESSTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := FILLREPORTHSDETAILSAC( LNREPORTID,
                                         LSDESCRIPTION,
                                         LNAUDITTRAILSEQNO,
                                         LNSEQNO,
                                         LSWHAT,
                                         AROLDVALUE,
                                         ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTACCESSHISTORY;


   FUNCTION ADDREPORTLINKHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPL%ROWTYPE,
      ARNEWVALUE                 IN       ITREPL%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportLinkHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LNREPORTGROUPID               IAPITYPE.ID_TYPE;
      LSDESCRIPTION                 IAPITYPE.SHORTDESCRIPTION_TYPE;
      LSREPORTGROUP                 IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_LINK_INS';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LNREPORTGROUPID := ARNEWVALUE.REPG_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_LINK_UPD';
         LNREPORTID := ARNEWVALUE.REP_ID;
         LNREPORTGROUPID := ARNEWVALUE.REPG_ID;
      ELSE
         LSWHATID := 'AT_REPORT_LINK_DEL';
         LNREPORTID := AROLDVALUE.REP_ID;
         LNREPORTGROUPID := AROLDVALUE.REPG_ID;
      END IF;

      SELECT SORT_DESC
        INTO LSDESCRIPTION
        FROM ITREPD
       WHERE REP_ID = LNREPORTID;

      SELECT DESCRIPTION
        INTO LSREPORTGROUP
        FROM ITREPG
       WHERE REPG_ID = LNREPORTGROUPID;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              LSREPORTGROUP,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITREPHS
                  ( REP_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLREPORTHSDETAILSLINK( LNREPORTID,
                                           LSDESCRIPTION,
                                           LNAUDITTRAILSEQNO,
                                           LNSEQNO,
                                           LSWHAT,
                                           AROLDVALUE,
                                           ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTLINKHISTORY;


   FUNCTION ADDREPORTGROUPHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPG%ROWTYPE,
      ARNEWVALUE                 IN       ITREPG%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportGroupHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTGROUPID               IAPITYPE.ID_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_GROUP_INS';
         LNREPORTGROUPID := ARNEWVALUE.REPG_ID;
         LSDESCRIPTION := ARNEWVALUE.DESCRIPTION;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_GROUP_UPD';
         LNREPORTGROUPID := ARNEWVALUE.REPG_ID;
         LSDESCRIPTION := ARNEWVALUE.DESCRIPTION;
      ELSE
         LSWHATID := 'AT_REPORT_GROUP_DEL';
         LNREPORTGROUPID := AROLDVALUE.REPG_ID;
         LSDESCRIPTION := AROLDVALUE.DESCRIPTION;
      END IF;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSDESCRIPTION,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITREPGHS
                  ( REPG_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLREPORTGROUPHSDETAILS( LNREPORTGROUPID,
                                            LSDESCRIPTION,
                                            LNAUDITTRAILSEQNO,
                                            LNSEQNO,
                                            LSWHAT,
                                            AROLDVALUE,
                                            ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTGROUPHISTORY;


   FUNCTION ADDREPORTGROUPLINKHISTORY(
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE,
      AROLDVALUE                 IN       ITREPL%ROWTYPE,
      ARNEWVALUE                 IN       ITREPL%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReportGroupLinkHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNAUDITTRAILSEQNO             IAPITYPE.SEQUENCENR_TYPE;
      LNSEQNO                       IAPITYPE.SEQUENCENR_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSWHATID                      IAPITYPE.WHATID_TYPE;
      LSWHAT                        IAPITYPE.WHAT_TYPE;
      LNREPORTGROUPID               IAPITYPE.ID_TYPE;
      LNREPORTID                    IAPITYPE.ID_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LSREPORT                      IAPITYPE.SHORTDESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSEQNO := 1;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETSEQUENCE( LNAUDITTRAILSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      LSUSERID := USER;
      LNRETVAL := GETUSERINFO( LSUSERID,
                               LSFORENAME,
                               LSLASTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      IF ASACTION = 'INSERTING'
      THEN
         LSWHATID := 'AT_REPORT_LINK_INS';
         LNREPORTGROUPID := ARNEWVALUE.REPG_ID;
         LNREPORTID := ARNEWVALUE.REP_ID;
      ELSIF ASACTION = 'UPDATING'
      THEN
         LSWHATID := 'AT_REPORT_LINK_UPD';
         LNREPORTGROUPID := ARNEWVALUE.REPG_ID;
         LNREPORTID := ARNEWVALUE.REP_ID;
      ELSE
         LSWHATID := 'AT_REPORT_LINK_DEL';
         LNREPORTGROUPID := AROLDVALUE.REPG_ID;
         LNREPORTID := AROLDVALUE.REP_ID;
      END IF;

      SELECT SORT_DESC
        INTO LSREPORT
        FROM ITREPD
       WHERE REP_ID = LNREPORTID;

      SELECT DESCRIPTION
        INTO LSDESCRIPTION
        FROM ITREPG
       WHERE REPG_ID = LNREPORTGROUPID;

      LNRETVAL := GETMESSAGE( LSWHATID,
                              LSREPORT,
                              LSDESCRIPTION,
                              NULL,
                              NULL,
                              NULL,
                              LSWHAT );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      INSERT INTO ITREPGHS
                  ( REPG_ID,
                    AUDIT_TRAIL_SEQ_NO,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    WHAT_ID,
                    WHAT )
           VALUES ( LNREPORTGROUPID,
                    LNAUDITTRAILSEQNO,
                    LSUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    LSWHATID,
                    LSWHAT );

      LNRETVAL := FILLREPORTGROUPHSDETAILSLINK( LNREPORTGROUPID,
                                                LSDESCRIPTION,
                                                LNAUDITTRAILSEQNO,
                                                LNSEQNO,
                                                LSWHAT,
                                                AROLDVALUE,
                                                ARNEWVALUE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREPORTGROUPLINKHISTORY;


   FUNCTION SETUSERINFOHISTORY
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetUserInfoHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      
      
      CURSOR LQUSERHS
      IS
         SELECT USHS.USER_ID_CHANGED,
                USHS.AUDIT_TRAIL_SEQ_NO,
                AU.FORENAME,
                AU.LAST_NAME
           FROM ITUSHS USHS,
                APPLICATION_USER AU
          WHERE AU.USER_ID = USHS.USER_ID
            
            AND USHS.FORENAME IS NULL
            AND USHS.LAST_NAME IS NULL
            AND USHS.TIMESTAMP >   SYSDATE
                                 -   1
                                   / 24;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LQUSERHS%ISOPEN )
      THEN
         CLOSE LQUSERHS;
      END IF;

      FOR LRUSERHS IN LQUSERHS
      LOOP
         UPDATE ITUSHS
            SET FORENAME = LRUSERHS.FORENAME,
                LAST_NAME = LRUSERHS.LAST_NAME
          WHERE USER_ID_CHANGED = LRUSERHS.USER_ID_CHANGED
            AND AUDIT_TRAIL_SEQ_NO = LRUSERHS.AUDIT_TRAIL_SEQ_NO;
      END LOOP;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETUSERINFOHISTORY;
END IAPIAUDITTRAIL;