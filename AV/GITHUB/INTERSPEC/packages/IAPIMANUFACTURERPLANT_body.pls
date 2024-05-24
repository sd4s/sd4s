CREATE OR REPLACE PACKAGE BODY iapiManufacturerPlant
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
         || 'mpl_id '
         || IAPICONSTANTCOLUMN.MANUFACTURERPLANTNOCOL
         || ', f_mpl_descr(m.mpl_id) '
         || IAPICONSTANTCOLUMN.MANUFACTURERPLANTCOL
         || ','
         || LSALIAS
         || 'mfc_id '
         || IAPICONSTANTCOLUMN.MANUFACTURERIDCOL
         || ', f.description '
         || IAPICONSTANTCOLUMN.MANUFACTURERCOL
         || ','
         || LSALIAS
         || 'intl '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ','
         || LSALIAS
         || 'status '
         || IAPICONSTANTCOLUMN.HISTORICCOL;
      RETURN( LCBASECOLUMNS );
   END GETBASECOLUMNS;

   
   
   
   
   FUNCTION GETMANUFACTURERPLANTS(
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      ATKEYWORDFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASSPECPREFIXTYPE           IN       IAPITYPE.SPECIFICATIONPREFIXTYPE_TYPE DEFAULT NULL,
      AQMANUFACTURERPLANTS       OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturerPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERKEYWORD               IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfcmpl m, itmfc f';
      LNSHOWLOCAL                   IAPITYPE.BOOLEAN_TYPE;
      LSLEFTOPERAND                 IAPITYPE.STRING_TYPE;
      LSOPERATOR                    IAPITYPE.STRING_TYPE;
      LSRIGHTOPERAND                IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERPLANTS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERPLANTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mpl_id = null AND m.mfc_id = f.mfc_id';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERPLANTS
       FOR LSSQLNULL;

      
      
      
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
            WHEN IAPICONSTANTCOLUMN.MANUFACTURERPLANTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.mpl_id';
            WHEN IAPICONSTANTCOLUMN.MANUFACTURERPLANTCOL
            THEN
               LRFILTER.LEFTOPERAND := 'f_mpl_descr(m.mpl_id)';
            WHEN IAPICONSTANTCOLUMN.MANUFACTURERCOL
            THEN
               LRFILTER.LEFTOPERAND := 'f.description';
            WHEN IAPICONSTANTCOLUMN.HISTORICCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.status';
            WHEN IAPICONSTANTCOLUMN.INTERNATIONALCOL
            THEN
               LRFILTER.LEFTOPERAND := 'm.intl';
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
               LSFILTERKEYWORD := ' (m.mfc_id, m.mpl_id) not in (';
            ELSE
               LSFILTERKEYWORD := ' (m.mfc_id, m.mpl_id) in (';
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
                            || ' select mfc_id, mpl_id from itmfcmplkw where ';
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

         IF ( LSRIGHTOPERAND IS NOT NULL ) THEN
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

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE m.mfc_id = f.mfc_id ';

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
               || ' ORDER BY m.mpl_id ASC, m.mfc_id ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQMANUFACTURERPLANTS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERPLANTS;
      END IF;

      
      OPEN AQMANUFACTURERPLANTS
       FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERPLANTS;

   
   FUNCTION GETMANUFACTURERPLANT(
      ASMANUFACTURERPLANTNO      IN       IAPITYPE.MANUFACTURERPLANTNO_TYPE,
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      AQMANUFACTURERPLANT        OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturerPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfcmpl m, itmfc f';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERPLANT%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERPLANT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mpl_id = NULL AND m.mfc_id = f.mfc_id';

      OPEN AQMANUFACTURERPLANT
       FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( ASMANUFACTURERPLANTNO,
                           ANMANUFACTURERID );

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

      
      IF ( AQMANUFACTURERPLANT%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERPLANT;
      END IF;

      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE m.mpl_id = '''
         || ASMANUFACTURERPLANTNO
         || ''''
         || ' AND m.mfc_id = '
         || ANMANUFACTURERID
         || ' AND m.mfc_id = f.mfc_id';

      
      OPEN AQMANUFACTURERPLANT
       FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERPLANT;

   
   FUNCTION GETMANUFACTURERPLANTSPB(
      ASDEFAULTFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      ASKEYWORDFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASSPECPREFIXTYPE           IN       IAPITYPE.SPECIFICATIONPREFIXTYPE_TYPE DEFAULT NULL,
      AQMANUFACTURERPLANTS       OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturerPlantsPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXDEFAULTFILTER               IAPITYPE.XMLTYPE_TYPE;
      LXKEYWORDFILTER               IAPITYPE.XMLTYPE_TYPE;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfcmpl m, itmfc f';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERPLANTS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERPLANTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mpl_id = null AND m.mfc_id = f.mfc_id';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERPLANTS
       FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXDEFAULTFILTER := XMLTYPE( ASDEFAULTFILTER );
      LXKEYWORDFILTER := XMLTYPE( ASKEYWORDFILTER );
      LNRETVAL := GETMANUFACTURERPLANTS( LXDEFAULTFILTER,
                                         LXKEYWORDFILTER,
                                         ANDONOTHAVE,
                                         ASSPECPREFIXTYPE,
                                         AQMANUFACTURERPLANTS );

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
   END GETMANUFACTURERPLANTSPB;

   
   FUNCTION GETMANUFACTURERPLANTS(
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AXKEYWORDFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASSPECPREFIXTYPE           IN       IAPITYPE.SPECIFICATIONPREFIXTYPE_TYPE DEFAULT NULL,
      AQMANUFACTURERPLANTS       OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturerPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LTKEYWORDFILTER               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'm' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfcmpl m, itmfc f';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERPLANTS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERPLANTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE m.mpl_id = null AND m.mfc_id = f.mfc_id';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANUFACTURERPLANTS
       FOR LSSQLNULL;

      
      
      
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

      LNRETVAL := GETMANUFACTURERPLANTS( LTDEFAULTFILTER,
                                         LTKEYWORDFILTER,
                                         ANDONOTHAVE,
                                         ASSPECPREFIXTYPE,
                                         AQMANUFACTURERPLANTS );

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
   END GETMANUFACTURERPLANTS;

   
   FUNCTION EXISTID(
      ANMANUFACTURERPLANTNO      IN       IAPITYPE.MANUFACTURERPLANTNO_TYPE,
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNMANUFACTURERPLANTNO         IAPITYPE.MANUFACTURERPLANTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT MPL_ID
        INTO LNMANUFACTURERPLANTNO
        FROM ITMFCMPL
       WHERE MPL_ID = ANMANUFACTURERPLANTNO
         AND MFC_ID = ANMANUFACTURERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_MANUFACTURPLANTNOTFOUND,
                                                     ANMANUFACTURERPLANTNO,
                                                     ANMANUFACTURERID ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION GETKEYWORDS(
      ANMANUFACTURERPLANTNO      IN       IAPITYPE.MANUFACTURERPLANTNO_TYPE,
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      AQKEYWORDS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetKeywords';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
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
      LSFROM                        IAPITYPE.STRING_TYPE := 'itmfcmplkw m, itkw k';
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

      OPEN AQKEYWORDS
       FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIMANUFACTURERPLANT.EXISTID( ANMANUFACTURERPLANTNO,
                                                 ANMANUFACTURERID );

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
               || ' AND m.mpl_id = :ManufacturerPlantNo '
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

      
      OPEN AQKEYWORDS
       FOR LSSQL USING ANMANUFACTURERID, ANMANUFACTURERPLANTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETKEYWORDS;
END IAPIMANUFACTURERPLANT;