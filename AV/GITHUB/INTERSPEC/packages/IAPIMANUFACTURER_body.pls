CREATE OR REPLACE PACKAGE BODY iapiManufacturer
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

   
   
   

   
   
   
   
   FUNCTION GETBASECOLUMNS(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumns';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.SQLSTRING_TYPE := NULL;
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
         || 'mfc_id '
         || IAPICONSTANTCOLUMN.MANUFACTURERIDCOL
         || ','
         || LSALIAS
         || 'description '
         || IAPICONSTANTCOLUMN.MANUFACTURERCOL
         || ','
         || LSALIAS
         || 'status '
         || IAPICONSTANTCOLUMN.HISTORICCOL
         || ','
         || LSALIAS
         || 'intl '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ','
         || ' mt.mtp_id '
         || IAPICONSTANTCOLUMN.MTPIDCOL
         || ','
         || ' mt.description '
         || IAPICONSTANTCOLUMN.MTPDESCRIPTIONCOL
         || ','
         || ' mt.status '
         || IAPICONSTANTCOLUMN.MTPSTATUSCOL
         || ','
         || ' mt.intl '
         || IAPICONSTANTCOLUMN.MTPINTERNATIONALCOL;
      RETURN( LCBASECOLUMNS );
   END GETBASECOLUMNS;

   
   FUNCTION GETBASECOLUMNSMTP(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumnsMtp';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.BASECOLUMNS_TYPE := NULL;
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
         || 'mtp_id '
         || IAPICONSTANTCOLUMN.MTPIDCOL
         || ','
         || LSALIAS
         || 'description '
         || IAPICONSTANTCOLUMN.MTPDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'status '
         || IAPICONSTANTCOLUMN.MTPSTATUSCOL
         || ','
         || LSALIAS
         || 'intl '
         || IAPICONSTANTCOLUMN.MTPINTERNATIONALCOL;
      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNSMTP;

   
   
   
   
   FUNCTION GETMANUFACTURERS(
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      ATKEYWORDFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASSPECPREFIXTYPE           IN       IAPITYPE.SPECIFICATIONPREFIXTYPE_TYPE DEFAULT NULL,
      ANWHEREUSED                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQMANUFACTURERS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERKEYWORD               IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfc m, itmtp mt';
      LSFROMMFCMPL                  IAPITYPE.STRING_TYPE := ', itmfcmpl mp, itmpl mpl';
      LNSHOWLOCAL                   IAPITYPE.BOOLEAN_TYPE;
      LSLEFTOPERAND                 IAPITYPE.STRING_TYPE;
      LSOPERATOR                    IAPITYPE.STRING_TYPE;
      LSRIGHTOPERAND                IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mfc_id = NULL AND m.mtp_id = mt.mtp_id(+) ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in DefaultFilter <'
                           || ATDEFAULTFILTER.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATDEFAULTFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATDEFAULTFILTER( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'DefaultFilter ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         CASE LRFILTER.LEFTOPERAND
            WHEN IAPICONSTANTCOLUMN.MANUFACTURERIDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.mfc_id';
            WHEN IAPICONSTANTCOLUMN.MANUFACTURERCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.description';
            WHEN IAPICONSTANTCOLUMN.HISTORICCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.status';
            WHEN IAPICONSTANTCOLUMN.INTERNATIONALCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.intl';
            WHEN IAPICONSTANTCOLUMN.MTPIDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'mt.mtp_id';
            WHEN IAPICONSTANTCOLUMN.MTPDESCRIPTIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'mt.description';
            ELSE
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                               LRFILTER.LEFTOPERAND );
               RETURN( LNRETVAL );
         END CASE;

         IF ( I > 0 )
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTER :=    LSFILTER
                        || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in KeywordFilter <'
                           || ATKEYWORDFILTER.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATKEYWORDFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATKEYWORDFILTER( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'KeywordFilter ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
         LSLEFTOPERAND := LRFILTER.LEFTOPERAND;
         LSOPERATOR := LRFILTER.OPERATOR;
         LSRIGHTOPERAND := LRFILTER.RIGHTOPERAND;

         IF ( LSFILTERKEYWORD IS NULL )
         THEN
            IF ANDONOTHAVE = 1
            THEN
               LSFILTERKEYWORD := ' m.mfc_id not in (';
            ELSE
               LSFILTERKEYWORD := ' m.mfc_id in (';
            END IF;
         ELSE
            IF ANDONOTHAVE = 1
            THEN
               LSFILTERKEYWORD :=    LSFILTERKEYWORD
                                  || ' union ';
            ELSE
               LSFILTERKEYWORD :=    LSFILTERKEYWORD
                                  || ' intersect ';
            END IF;
         END IF;

         LSFILTERKEYWORD :=    LSFILTERKEYWORD
                            || ' select mfc_id from itmfckw where ';
         LRFILTER.LEFTOPERAND := 'kw_id';
         LRFILTER.OPERATOR := IAPICONSTANT.OPERATOR_EQUAL;
         LRFILTER.RIGHTOPERAND := LSLEFTOPERAND;
         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTERKEYWORD :=    LSFILTERKEYWORD
                               || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;

         LRFILTER.LEFTOPERAND := 'kw_value';
         LRFILTER.OPERATOR := LSOPERATOR;
         LRFILTER.RIGHTOPERAND := LSRIGHTOPERAND;
         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTERKEYWORD :=    LSFILTERKEYWORD
                               || ' and '
                               || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      IF ( LSFILTERKEYWORD IS NOT NULL )
      THEN
         IF ( LSFILTER IS NOT NULL )
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || LSFILTERKEYWORD
                     || ' )';
      END IF;

      
      IF ANWHEREUSED = 0
      THEN
         LSFROM :=    LSFROM
                   || LSFROMMFCMPL;
      END IF;

      LSSQL :=    'SELECT DISTINCT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE m.mtp_id = mt.mtp_id(+) ';

      IF ANWHEREUSED = 0
      THEN
         LSSQL :=    LSSQL
                  || ' AND mp.mfc_id = m.mfc_id '
                  || ' AND mp.status = 0 '
                  || ' AND mp.mpl_id = mpl.mpl_id ';
      END IF;

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      
      LNRETVAL := IAPIMANUFACTURER.SHOWLOCAL( ASSPECPREFIXTYPE,
                                              LNSHOWLOCAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNSHOWLOCAL = 0 )
      THEN
         LSSQL :=    LSSQL
                  || ' AND m.intl <> 0';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY m.mfc_id ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      
      OPEN AQMANUFACTURERS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERS;

   
   FUNCTION GETMANUFACTURER(
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      AQMANUFACTURER             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturer';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPLANT                       IAPITYPE.PLANTREC_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfc m, itmtp mt';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURER%ISOPEN )
      THEN
         CLOSE AQMANUFACTURER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mfc_id = NULL AND m.mtp_id = mt.mtp_id(+) ';

      OPEN AQMANUFACTURER FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( ANMANUFACTURERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQMANUFACTURER%ISOPEN )
      THEN
         CLOSE AQMANUFACTURER;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE m.mfc_id = '
               || ANMANUFACTURERID
               || ' AND m.mtp_id = mt.mtp_id(+) ';

      
      OPEN AQMANUFACTURER FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURER;

   
   FUNCTION GETMANUFACTURERSPB(
      ASDEFAULTFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      ASKEYWORDFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASSPECPREFIXTYPE           IN       IAPITYPE.SPECIFICATIONPREFIXTYPE_TYPE DEFAULT NULL,
      ANWHEREUSED                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQMANUFACTURERS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturersPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LTKEYWORDFILTER               IAPITYPE.FILTERTAB_TYPE;
      LXDEFAULTFILTER               IAPITYPE.XMLTYPE_TYPE;
      LXKEYWORDFILTER               IAPITYPE.XMLTYPE_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfc m, itmtp mt';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mfc_id = NULL AND m.mtp_id = mt.mtp_id(+) ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXDEFAULTFILTER := XMLTYPE( ASDEFAULTFILTER );
      LXKEYWORDFILTER := XMLTYPE( ASKEYWORDFILTER );
      LNRETVAL := IAPIMANUFACTURER.GETMANUFACTURERS( LXDEFAULTFILTER,
                                                     LXKEYWORDFILTER,
                                                     ANDONOTHAVE,
                                                     ASSPECPREFIXTYPE,
                                                     ANWHEREUSED,
                                                     AQMANUFACTURERS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERSPB;

   
   FUNCTION GETMANUFACTURERS(
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AXKEYWORDFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASSPECPREFIXTYPE           IN       IAPITYPE.SPECIFICATIONPREFIXTYPE_TYPE DEFAULT NULL,
      ANWHEREUSED                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQMANUFACTURERS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LTKEYWORDFILTER               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfc m, itmtp mt';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mfc_id = NULL AND m.mtp_id = mt.mtp_id(+) ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXDEFAULTFILTER,
                                               LTDEFAULTFILTER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXKEYWORDFILTER,
                                               LTKEYWORDFILTER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIMANUFACTURER.GETMANUFACTURERS( LTDEFAULTFILTER,
                                                     LTKEYWORDFILTER,
                                                     ANDONOTHAVE,
                                                     ASSPECPREFIXTYPE,
                                                     ANWHEREUSED,
                                                     AQMANUFACTURERS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERS;

   
   FUNCTION EXISTID(
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNMANUFACTURERID              IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT MFC_ID
        INTO LNMANUFACTURERID
        FROM ITMFC
       WHERE MFC_ID = ANMANUFACTURERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_MANUFACTURERNOTFOUND,
                                                     ANMANUFACTURERID ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION SHOWLOCAL(
      ASSPECPREFIXTYPE           IN       IAPITYPE.SPECIFICATIONPREFIXTYPE_TYPE,
      ANSHOWLOCAL                OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ShowLocal';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSALLOWMFC                    IAPITYPE.PARAMETERDATA_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ANSHOWLOCAL := 1;

      IF ( ASSPECPREFIXTYPE = 'R' )
      THEN
         IF ( IAPIGENERAL.SESSION.DATABASE.DATABASETYPE = 'L' )
         THEN
            LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'allow_mfc',
                                                             IAPICONSTANT.CFG_SECTION_STANDARD,
                                                             LSALLOWMFC );

            IF LNRETVAL = IAPICONSTANTDBERROR.DBERR_MISSINGPARAMORSECTION
            THEN
               IF IAPIGENERAL.SESSION.DATABASE.CONFIGURATION.GLOSSARY
               THEN
                  ANSHOWLOCAL := 0;
               END IF;

               LNRETVAL := NULL;
            ELSIF LNRETVAL = IAPICONSTANTDBERROR.DBERR_GENFAIL
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            ELSIF LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IF LSALLOWMFC = '1'
               THEN
                  ANSHOWLOCAL := 0;
               END IF;

               LNRETVAL := NULL;
            END IF;
         ELSIF( IAPIGENERAL.SESSION.DATABASE.DATABASETYPE = 'R' )
         THEN
            LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'allow_mfc',
                                                             IAPICONSTANT.CFG_SECTION_STANDARD,
                                                             LSALLOWMFC );

            IF LNRETVAL = IAPICONSTANTDBERROR.DBERR_MISSINGPARAMORSECTION
            THEN
               IF ( NOT IAPIGENERAL.SESSION.DATABASE.CONFIGURATION.GLOSSARY )
               THEN
                  ANSHOWLOCAL := 0;
               END IF;

               LNRETVAL := NULL;
            ELSIF LNRETVAL = IAPICONSTANTDBERROR.DBERR_GENFAIL
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            ELSIF LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IF ( LSALLOWMFC <> '1' )
               THEN
                  ANSHOWLOCAL := 0;
               END IF;

               LNRETVAL := NULL;
            END IF;
         END IF;
      ELSIF( ASSPECPREFIXTYPE = 'G' )
      THEN
         ANSHOWLOCAL := 0;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SHOWLOCAL;

   
   FUNCTION GETMANUFACTURERTYPES(
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      AQMANUFACTURERTYPES        OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturerTypes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNSMTP( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmtp m';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERTYPES%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERTYPES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE mtp_id = null';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERTYPES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in DefaultFilter <'
                           || ATDEFAULTFILTER.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATDEFAULTFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATDEFAULTFILTER( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'DefaultFilter ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         CASE LRFILTER.LEFTOPERAND
            WHEN IAPICONSTANTCOLUMN.MTPDESCRIPTIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.description';
            ELSE
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                               LRFILTER.LEFTOPERAND );
               RETURN( LNRETVAL );
         END CASE;

         IF ( I > 0 )
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTER :=    LSFILTER
                        || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' WHERE '
                  || LSFILTER;
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY m.mtp_id ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQMANUFACTURERTYPES%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERTYPES;
      END IF;

      
      OPEN AQMANUFACTURERTYPES FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERTYPES;

   
   FUNCTION GETMANUFACTURERTYPES(
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AQMANUFACTURERTYPES        OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturerTypes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LTKEYWORDFILTER               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNSMTP( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmtp m';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERTYPES%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERTYPES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mtp_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERTYPES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXDEFAULTFILTER,
                                               LTDEFAULTFILTER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIMANUFACTURER.GETMANUFACTURERTYPES( LTDEFAULTFILTER,
                                                         AQMANUFACTURERTYPES );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERTYPES;

   
   FUNCTION GETMANUFACTURERTYPESPB(
      ASDEFAULTFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      AQMANUFACTURERTYPES        OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturerTypesPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LTKEYWORDFILTER               IAPITYPE.FILTERTAB_TYPE;
      LXDEFAULTFILTER               IAPITYPE.XMLTYPE_TYPE;
      LXKEYWORDFILTER               IAPITYPE.XMLTYPE_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNSMTP( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmtp m';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERTYPES%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERTYPES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mtp_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERTYPES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXDEFAULTFILTER := XMLTYPE( ASDEFAULTFILTER );
      LNRETVAL := IAPIMANUFACTURER.GETMANUFACTURERTYPES( LXDEFAULTFILTER,
                                                         AQMANUFACTURERTYPES );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERTYPESPB;

   
   FUNCTION GETKEYWORDS(
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      AQKEYWORDS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetKeywords';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'm.kw_id '
            || IAPICONSTANTCOLUMN.KEYWORDIDCOL
            || ','
            || 'k.description '
            || IAPICONSTANTCOLUMN.KEYWORDCOL
            || ','
            || 'k.kw_type '
            || IAPICONSTANTCOLUMN.KEYWORDTYPECOL
            || ','
            || 'm.kw_value '
            || IAPICONSTANTCOLUMN.KEYWORDVALUECOL
            || ','
            || 'm.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfckw m, itkw k';
   BEGIN
      
      
      
      
      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mfc_id = NULL'
                   || ' AND'
                   || ' m.kw_id = k.kw_id';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQKEYWORDS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIMANUFACTURER.EXISTID( ANMANUFACTURERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE m.mfc_id = :ManufacturerId '
               || ' AND '
               || ' m.kw_id = k.kw_id';
      LSSQL :=    LSSQL
               || ' ORDER BY m.kw_id ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      
      OPEN AQKEYWORDS FOR LSSQL USING ANMANUFACTURERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETKEYWORDS;
END IAPIMANUFACTURER;