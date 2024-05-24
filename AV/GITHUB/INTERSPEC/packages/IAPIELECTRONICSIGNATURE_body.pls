CREATE OR REPLACE PACKAGE BODY iapiElectronicSignature
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

   
   FUNCTION GETNEXTSEQUENCE(
      ANESSEQNO                  OUT      IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNextSequence';

      CURSOR LQSEQUENCE
      IS
         SELECT ITES_SEQ.NEXTVAL ELECTRONICSIGNATURENO
           FROM DUAL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRSEQUENCE IN LQSEQUENCE
      LOOP
         ANESSEQNO := LRSEQUENCE.ELECTRONICSIGNATURENO;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNEXTSEQUENCE;

   
   FUNCTION CREATELOGGING(
      ASTYPE                     IN       IAPITYPE.ELECTRONICSIGNATURETYPE_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASSIGNFORID                IN       IAPITYPE.ELECTRONICSIGNATUREFORID_TYPE,
      ASSIGNFOR                  IN       IAPITYPE.ELECTRONICSIGNATUREFOR_TYPE,
      ASSIGNWHATID               IN       IAPITYPE.ELECTRONICSIGNATUREWHATID_TYPE,
      ASSIGNWHAT                 IN       IAPITYPE.ELECTRONICSIGNATUREWHAT_TYPE,
      ANSUCCESS                  IN       IAPITYPE.NUMVAL_TYPE,
      ASSUCCESSDESCR             IN       IAPITYPE.STRING_TYPE,
      ANESSEQNO                  OUT      IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNESSEQNO                     IAPITYPE.SEQUENCENR_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSSUCCESSDESCR                IAPITYPE.STRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateLogging';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETNEXTSEQUENCE( LNESSEQNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      ANESSEQNO := LNESSEQNO;

      
      SELECT AU.FORENAME,
             AU.LAST_NAME
        INTO LSFORENAME,
             LSLASTNAME
        FROM APPLICATION_USER AU
       WHERE AU.USER_ID = ASUSERID;

      IF ASSUCCESSDESCR IS NULL
      THEN
         IF ANSUCCESS = 0
         THEN
            LSSUCCESSDESCR := 'Successful';
         ELSE
            LSSUCCESSDESCR := 'Unsuccessful';
         END IF;
      ELSE
         LSSUCCESSDESCR := ASSUCCESSDESCR;
      END IF;

      INSERT INTO ITESHS
                  ( ES_SEQ_NO,
                    TYPE,
                    USER_ID,
                    FORENAME,
                    LAST_NAME,
                    TIMESTAMP,
                    SIGN_FOR_ID,
                    SIGN_FOR,
                    SIGN_WHAT_ID,
                    SIGN_WHAT,
                    SUCCESS,
                    SUCCESS_DESCR )
           VALUES ( LNESSEQNO,
                    ASTYPE,
                    ASUSERID,
                    LSFORENAME,
                    LSLASTNAME,
                    SYSDATE,
                    ASSIGNFORID,
                    ASSIGNFOR,
                    ASSIGNWHATID,
                    ASSIGNWHAT,
                    ANSUCCESS,
                    LSSUCCESSDESCR );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATELOGGING;

   
   FUNCTION LOGSPECIFICATION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANESSEQNO                  IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      CURSOR LQESHS(
         ANESSEQNO                  IN       IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT USER_ID,
                FORENAME,
                LAST_NAME,
                TIMESTAMP,
                SIGN_FOR_ID,
                SIGN_FOR,
                SIGN_WHAT_ID,
                SIGN_WHAT
           FROM ITESHS
          WHERE ES_SEQ_NO = ANESSEQNO;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNESSEQNO                     IAPITYPE.SEQUENCENR_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSSUCCESSDESCR                IAPITYPE.STRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogSpecification';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRESHS IN LQESHS( ANESSEQNO )
      LOOP
         INSERT INTO ITSHHS
                     ( PART_NO,
                       REVISION,
                       ES_SEQ_NO,
                       USER_ID,
                       FORENAME,
                       LAST_NAME,
                       TIMESTAMP,
                       SIGN_FOR_ID,
                       SIGN_FOR,
                       SIGN_WHAT_ID,
                       SIGN_WHAT )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANESSEQNO,
                       LRESHS.USER_ID,
                       LRESHS.FORENAME,
                       LRESHS.LAST_NAME,
                       LRESHS.TIMESTAMP,
                       LRESHS.SIGN_FOR_ID,
                       LRESHS.SIGN_FOR,
                       LRESHS.SIGN_WHAT_ID,
                       LRESHS.SIGN_WHAT );
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END LOGSPECIFICATION;

   
   FUNCTION LOGREFERENCETEXT(
      ANREFTEXTTYPE              IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANESSEQNO                  IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQESHS(
         ANESSEQNO                  IN       IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT USER_ID,
                FORENAME,
                LAST_NAME,
                TIMESTAMP,
                SIGN_FOR_ID,
                SIGN_FOR,
                SIGN_WHAT_ID,
                SIGN_WHAT
           FROM ITESHS
          WHERE ES_SEQ_NO = ANESSEQNO;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogReferenceText';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      FOR LRESHS IN LQESHS( ANESSEQNO )
      LOOP
         INSERT INTO ITRTHS
                     ( REF_TEXT_TYPE,
                       TEXT_REVISION,
                       OWNER,
                       ES_SEQ_NO,
                       USER_ID,
                       FORENAME,
                       LAST_NAME,
                       TIMESTAMP,
                       SIGN_FOR_ID,
                       SIGN_FOR,
                       SIGN_WHAT_ID,
                       SIGN_WHAT )
              VALUES ( ANREFTEXTTYPE,
                       ANREVISION,
                       ANOWNER,
                       ANESSEQNO,
                       LRESHS.USER_ID,
                       LRESHS.FORENAME,
                       LRESHS.LAST_NAME,
                       LRESHS.TIMESTAMP,
                       LRESHS.SIGN_FOR_ID,
                       LRESHS.SIGN_FOR,
                       LRESHS.SIGN_WHAT_ID,
                       LRESHS.SIGN_WHAT );
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END LOGREFERENCETEXT;

   
   FUNCTION LOGOBJECTIMAGE(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANESSEQNO                  IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQESHS(
         ANESSEQNO                  IN       IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT USER_ID,
                FORENAME,
                LAST_NAME,
                TIMESTAMP,
                SIGN_FOR_ID,
                SIGN_FOR,
                SIGN_WHAT_ID,
                SIGN_WHAT
           FROM ITESHS
          WHERE ES_SEQ_NO = ANESSEQNO;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogObjectImage';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      FOR LRESHS IN LQESHS( ANESSEQNO )
      LOOP
         INSERT INTO ITOIHS
                     ( OBJECT_ID,
                       REVISION,
                       OWNER,
                       ES_SEQ_NO,
                       USER_ID,
                       FORENAME,
                       LAST_NAME,
                       TIMESTAMP,
                       SIGN_FOR_ID,
                       SIGN_FOR,
                       SIGN_WHAT_ID,
                       SIGN_WHAT )
              VALUES ( ANOBJECTID,
                       ANREVISION,
                       ANOWNER,
                       ANESSEQNO,
                       LRESHS.USER_ID,
                       LRESHS.FORENAME,
                       LRESHS.LAST_NAME,
                       LRESHS.TIMESTAMP,
                       LRESHS.SIGN_FOR_ID,
                       LRESHS.SIGN_FOR,
                       LRESHS.SIGN_WHAT_ID,
                       LRESHS.SIGN_WHAT );
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END LOGOBJECTIMAGE;
END IAPIELECTRONICSIGNATURE;