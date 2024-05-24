CREATE OR REPLACE PACKAGE BODY iapiEventLog
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

   
   
   

   
   
   
   
   FUNCTION EXISTID(
      ANEVENTID                  IN       IAPITYPE.NUMVAL_TYPE,
      ASTRANSMTYPE               IN       IAPITYPE.SINGLEVARCHAR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITEVENTLOG
       WHERE EVENT_ID = ANEVENTID
         AND TRANSM_TYPE = ASTRANSMTYPE;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_EVENTLOGNOTFOUND,
                                                     ANEVENTID,
                                                     ASTRANSMTYPE ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   
   
   
   FUNCTION ADDEVENTLOG(
      ANEVENTID                  IN       IAPITYPE.NUMVAL_TYPE,
      ASTRANSMTYPE               IN       IAPITYPE.SINGLEVARCHAR_TYPE,
      ASMSG                      IN       IAPITYPE.BUFFER_TYPE,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddEventLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTID( ANEVENTID,
                           ASTRANSMTYPE );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_EVENTLOGEXIST,
                                                     ANEVENTID,
                                                     ASTRANSMTYPE ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITEVENTLOG
                  ( EVENT_ID,
                    TRANSM_TYPE,
                    MSG,
                    CREATED_ON )
           VALUES ( ANEVENTID,
                    ASTRANSMTYPE,
                    ASMSG,
                    ADCREATEDON );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDEVENTLOG;

   
   FUNCTION SAVEEVENTLOG(
      ANEVENTID                  IN       IAPITYPE.NUMVAL_TYPE,
      ASTRANSMTYPE               IN       IAPITYPE.SINGLEVARCHAR_TYPE,
      ASMSG                      IN       IAPITYPE.BUFFER_TYPE,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveEventLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTID( ANEVENTID,
                           ASTRANSMTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITEVENTLOG
         SET MSG = ASMSG,
             CREATED_ON = ADCREATEDON
       WHERE EVENT_ID = ANEVENTID
         AND TRANSM_TYPE = ASTRANSMTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEEVENTLOG;

   
   FUNCTION REMOVEEVENTLOG(
      ANEVENTID                  IN       IAPITYPE.NUMVAL_TYPE,
      ASTRANSMTYPE               IN       IAPITYPE.SINGLEVARCHAR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveEventLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTID( ANEVENTID,
                           ASTRANSMTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE      ITEVENTLOG
            WHERE EVENT_ID = ANEVENTID
              AND TRANSM_TYPE = ASTRANSMTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEEVENTLOG;

   
   FUNCTION GETEVENTLOG(
      ANEVENTID                  IN       IAPITYPE.NUMVAL_TYPE,
      ASTRANSMTYPE               IN       IAPITYPE.SINGLEVARCHAR_TYPE,
      ASMSG                      OUT      IAPITYPE.BUFFER_TYPE,
      ADCREATEDON                OUT      IAPITYPE.DATE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetEventLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTID( ANEVENTID,
                           ASTRANSMTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT MSG,
             CREATED_ON
        INTO ASMSG,
             ADCREATEDON
        FROM ITEVENTLOG
       WHERE EVENT_ID = ANEVENTID
         AND TRANSM_TYPE = ASTRANSMTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEVENTLOG;

   
   FUNCTION GETEVENTLOGS(
      AQEVENTLOGS                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetEventLogs';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'event_id '
            || IAPICONSTANTCOLUMN.EVENTIDCOL
            || ', transm_type '
            || IAPICONSTANTCOLUMN.TRANSMTYPECOL
            || ', msg '
            || IAPICONSTANTCOLUMN.MSGCOL
            || ', created_on '
            || IAPICONSTANTCOLUMN.CREATEDONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM ITEVENTLOG  ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQEVENTLOGS%ISOPEN )
      THEN
         CLOSE AQEVENTLOGS;
      END IF;

      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM;

      OPEN AQEVENTLOGS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEVENTLOGS;
END IAPIEVENTLOG;