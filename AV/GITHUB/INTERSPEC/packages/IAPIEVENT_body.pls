CREATE OR REPLACE PACKAGE BODY iapiEvent
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

   
   
   

   
   
   
   
   FUNCTION GETBASECOLUMNSEVENT(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumnsEvent';
      LCBASECOLUMNS                 VARCHAR2( 4096 ) := NULL;
      LSALIAS                       IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ASALIAS != '' )
      THEN
         NULL;
      ELSE
         LSALIAS :=    ASALIAS
                    || '.';
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSALIAS,
                           IAPICONSTANT.INFOLEVEL_3 );
      LCBASECOLUMNS :=
            LSALIAS
         || 'EVENT_ID '
         || IAPICONSTANTCOLUMN.EVENTIDCOL
         || ','
         || LSALIAS
         || 'NAME '
         || IAPICONSTANTCOLUMN.EVENTNAMECOL
         || ','
         || LSALIAS
         || 'CREATED_ON '
         || IAPICONSTANTCOLUMN.CREATEDONCOL
         || ','
         || LSALIAS
         || 'CREATED_BY '
         || IAPICONSTANTCOLUMN.CREATEDBYCOL
         || ','
         || LSALIAS
         || 'EVENT_TYPE_ID '
         || IAPICONSTANTCOLUMN.EVENTTYPECOL;
      RETURN( LCBASECOLUMNS );
   END GETBASECOLUMNSEVENT;

   
   FUNCTION GETBASECOLUMNSSERVICEEVENT(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumnsServiceEvent';
      LCBASECOLUMNS                 VARCHAR2( 4096 ) := NULL;
      LSALIAS                       IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ASALIAS != '' )
      THEN
         NULL;
      ELSE
         LSALIAS :=    ASALIAS
                    || '.';
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSALIAS,
                           IAPICONSTANT.INFOLEVEL_3 );
      LCBASECOLUMNS :=
            LSALIAS
         || 'EV_SEQUENCE '
         || IAPICONSTANTCOLUMN.EVENTSEQUENCECOL
         || ','
         || LSALIAS
         || 'EVENT_ID '
         || IAPICONSTANTCOLUMN.EVENTIDCOL
         || ','
         || LSALIAS
         || 'EV_NAME '
         || IAPICONSTANTCOLUMN.EVENTNAMECOL
         || ','
         || LSALIAS
         || 'EV_DETAILS '
         || IAPICONSTANTCOLUMN.EVENTDETAILSCOL
         || ','
         || LSALIAS
         || 'CREATED_ON '
         || IAPICONSTANTCOLUMN.CREATEDONCOL
         || ','
         || LSALIAS
         || 'EV_DATA '
         || IAPICONSTANTCOLUMN.EVENTDATACOL;
      RETURN( LCBASECOLUMNS );
   END GETBASECOLUMNSSERVICEEVENT;

   
   FUNCTION GETEVENTNAME(
      ANEVENTID                  IN       IAPITYPE.ID_TYPE,
      ASNAME                     OUT      IAPITYPE.NAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetEventName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT NAME
        INTO ASNAME
        FROM ITEVENT
       WHERE EVENT_ID = ANEVENTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEVENTNAME;

   
   
   
   
   FUNCTION GETEVENT(
      ANEVENTID                  IN       IAPITYPE.ID_TYPE,
      AQEVENT                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetEvent';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNSEVENT( 'e' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'ItEvent e';
   BEGIN
      
      
      
      
      
      IF ( AQEVENT%ISOPEN )
      THEN
         CLOSE AQEVENT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE e.Event_id = null';

      OPEN AQEVENT FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ANEVENTID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         ANEVENTID );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQEVENT%ISOPEN )
      THEN
         CLOSE AQEVENT;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE e.Event_id = '
               || ANEVENTID;

      
      OPEN AQEVENT FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEVENT;

   
   FUNCTION GETEVENTS(
      AQEVENTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetEvents';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNSEVENT( 'e' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'ItEvent e';
   BEGIN
      
      
      
      
      
      IF ( AQEVENTS%ISOPEN )
      THEN
         CLOSE AQEVENTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE e.Event_id = null';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQEVENTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      LSSQL :=    LSSQL
               || ' WHERE  1=1 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQEVENTS%ISOPEN )
      THEN
         CLOSE AQEVENTS;
      END IF;

      
      OPEN AQEVENTS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEVENTS;

   
   FUNCTION GETSERVICEEVENTS(
      ASEVSERVICENAME            IN       IAPITYPE.STRINGVAL_TYPE,
      AQEVENTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetServiceEvents';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNSSERVICEEVENT( 'se' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itevsink se';
   BEGIN
      
      
      
      
      
      IF ( AQEVENTS%ISOPEN )
      THEN
         CLOSE AQEVENTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE se.ev_service_name = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQEVENTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      LSSQL :=    LSSQL
               || ' WHERE ev_service_name = '
               || ''''
               || ASEVSERVICENAME
               || ''''
               || ' AND handled_ok = ''1''';
      LSSQL :=    LSSQL
               || ' ORDER BY ev_sequence';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITEVSINK
         SET HANDLED_OK = '1'
       WHERE EV_SERVICE_NAME = ASEVSERVICENAME;

      
      IF ( AQEVENTS%ISOPEN )
      THEN
         CLOSE AQEVENTS;
      END IF;

      OPEN AQEVENTS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSERVICEEVENTS;

   
   FUNCTION EXISTEVENTTYPE4SERVICE(
      ASEVSERVICENAME            IN       IAPITYPE.STRINGVAL_TYPE,
      ANEVENTTYPEID              IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistEventType4Service';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITEVSERVICETYPE
       WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME
         AND ( EVENT_TYPE_ID = ANEVENTTYPEID );

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_EVENTSERVICETYPENOTFOUND,
                                                     ASEVSERVICENAME ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTEVENTTYPE4SERVICE;

   
   FUNCTION REGISTEREVENTSERVICE(
      ASEVSERVICENAME            IN       IAPITYPE.STRINGVAL_TYPE,
      ANEVENTTYPEID              IN       IAPITYPE.ID_TYPE DEFAULT 0 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RegisterEventService';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := EXISTEVENTTYPE4SERVICE( ASEVSERVICENAME,
                                          ANEVENTTYPEID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ANEVENTTYPEID = 0
         THEN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ITEVSERVICETYPE
             WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME;

            IF LNCOUNT > 0
            THEN
               DELETE FROM ITEVSERVICETYPE
                     WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME;
            END IF;
         ELSE
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ITEVSERVICETYPE
             WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME
               AND EVENT_TYPE_ID = 0;

            IF LNCOUNT > 0
            THEN
               DELETE FROM ITEVSERVICETYPE
                     WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME
                       AND EVENT_TYPE_ID = 0;
            END IF;
         END IF;

         INSERT INTO ITEVSERVICETYPE
                     ( EVENT_SERVICE_NAME,
                       EVENT_TYPE_ID )
              VALUES ( ASEVSERVICENAME,
                       ANEVENTTYPEID );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITEVSERVICES
       WHERE EV_SERVICE_NAME = ASEVSERVICENAME;

      IF LNCOUNT = 0
      THEN
         INSERT INTO ITEVSERVICES
                     ( EV_SERVICE_NAME,
                       CREATED_ON )
              VALUES ( ASEVSERVICENAME,
                       SYSDATE );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPLICATEEVENTSERVICE,
                                                    ASEVSERVICENAME );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REGISTEREVENTSERVICE;

   
   FUNCTION UNREGISTEREVENTSERVICE(
      ASEVSERVICENAME            IN       IAPITYPE.STRINGVAL_TYPE,
      ANEVENTTYPEID              IN       IAPITYPE.ID_TYPE DEFAULT 0 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UnRegisterEventService';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANEVENTTYPEID = 0
      THEN
         DELETE FROM ITEVSERVICETYPE
               WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME;
      ELSE
         LNRETVAL := EXISTEVENTTYPE4SERVICE( ASEVSERVICENAME,
                                             ANEVENTTYPEID );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            DELETE FROM ITEVSERVICETYPE
                  WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME
                    AND EVENT_TYPE_ID = ANEVENTTYPEID;
         END IF;
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITEVSERVICETYPE
       WHERE EVENT_SERVICE_NAME = ASEVSERVICENAME;

      IF LNCOUNT = 0
      THEN
         DELETE FROM ITEVSINK
               WHERE EV_SERVICE_NAME = ASEVSERVICENAME;

         DELETE FROM ITEVSERVICES
               WHERE EV_SERVICE_NAME = ASEVSERVICENAME;
      ELSE
         IF ANEVENTTYPEID <> 0
         THEN
            DELETE FROM ITEVSINK
                  WHERE EVENT_ID IN( SELECT EVENT_ID
                                      FROM ITEVENT
                                     WHERE EV_SERVICE_NAME = ASEVSERVICENAME
                                       AND EVENT_TYPE_ID = ANEVENTTYPEID );
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END UNREGISTEREVENTSERVICE;

   
   FUNCTION DELETEHANDLEDEVENTS(
      ASEVSERVICENAME            IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteHandledEvents';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITEVSINK
            WHERE EV_SERVICE_NAME = ASEVSERVICENAME
              AND HANDLED_OK = '1';

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DELETEHANDLEDEVENTS;

   
   FUNCTION SINKEVENT(
      ANEVENTID                  IN       IAPITYPE.ID_TYPE,
      ASEVDETAILS                IN       IAPITYPE.STRING_TYPE,
      ALEVDATA                   IN       IAPITYPE.CLOB_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SinkEvent';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSEVENTNAME                   IAPITYPE.NAME_TYPE;

      CURSOR REGISTERED_SERVERS
      IS
         SELECT IES.EV_SERVICE_NAME
           FROM ITEVSERVICES IES,
                ITEVSERVICETYPE IEST
          WHERE IES.EV_SERVICE_NAME = IEST.EVENT_SERVICE_NAME
            AND (    IEST.EVENT_TYPE_ID IN( SELECT EVENT_TYPE_ID
                                             FROM ITEVENT
                                            WHERE EVENT_ID = ANEVENTID )
                  OR IEST.EVENT_TYPE_ID = 0 );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETEVENTNAME( ANEVENTID,
                                LSEVENTNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      FOR REGISTERED_SERVERS_REC IN REGISTERED_SERVERS
      LOOP
         BEGIN
            INSERT INTO ITEVSINK
                        ( EV_SEQUENCE,
                          EV_SERVICE_NAME,
                          EV_NAME,
                          EV_DETAILS,
                          CREATED_ON,
                          HANDLED_OK,
                          EVENT_ID,
                          EV_DATA )
                 VALUES ( ITEV_SEQ.NEXTVAL,
                          REGISTERED_SERVERS_REC.EV_SERVICE_NAME,
                          LSEVENTNAME,
                          ASEVDETAILS,
                          SYSDATE,
                          '0',
                          ANEVENTID,
                          ALEVDATA );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               
               
               
               NULL;
         END;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SINKEVENT;
END IAPIEVENT;