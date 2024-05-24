CREATE OR REPLACE PACKAGE BODY iapiPlant
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
         || 'plant '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ','
         || LSALIAS
         || 'description '
         || IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'plant_source '
         || IAPICONSTANTCOLUMN.PLANTSOURCECOL;
      RETURN( LCBASECOLUMNS );
   END GETBASECOLUMNS;

   
   
   
   
   FUNCTION GETPLANTS(
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      ATKEYWORDFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQPLANTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'p' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'plant p';
      LSLEFTOPERAND                 IAPITYPE.STRING_TYPE;
      LSOPERATOR                    IAPITYPE.STRING_TYPE;
      LSRIGHTOPERAND                IAPITYPE.STRING_TYPE;
      LSFILTERKEYWORD               IAPITYPE.CLOB_TYPE := NULL;
   BEGIN
      
      
      
      
      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.plant = null';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPLANTS FOR LSSQLNULL;

      
      
      
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
            WHEN IAPICONSTANTCOLUMN.PLANTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.plant';
            WHEN IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.description';
            WHEN IAPICONSTANTCOLUMN.PLANTSOURCECOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.plant_source';
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
               LSFILTERKEYWORD := ' p.plant not in (';
            ELSE
               LSFILTERKEYWORD := ' p.plant in (';
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
                            || ' select pl_id from itplkw where ';
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

         IF ( LSRIGHTOPERAND IS NOT NULL )
         THEN
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
               || LSFROM;
      LSSQL :=    LSSQL
               || ' WHERE  1=1 ';

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND EXISTS ( SELECT i.plant FROM itup i'
                  || ' WHERE i.user_id = :UserId'
                  || ' AND i.plant = p.plant )';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY p.plant ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      
      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 )
      THEN
         OPEN AQPLANTS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      ELSE
         OPEN AQPLANTS FOR LSSQL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPLANTS;

   
   FUNCTION GETPLANT(
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      AQPLANT                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPLANT                       IAPITYPE.PLANTREC_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'p' );
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := 'plant p';
   BEGIN
      
      
      
      
      
      IF ( AQPLANT%ISOPEN )
      THEN
         CLOSE AQPLANT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.plant = NULL';

      OPEN AQPLANT FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( ASPLANTNO );

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

      
      IF ( AQPLANT%ISOPEN )
      THEN
         CLOSE AQPLANT;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE p.plant = '''
               || ASPLANTNO
               || '''';

      
      OPEN AQPLANT FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPLANT;

   
   FUNCTION GETPLANTS(
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AXKEYWORDFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQPLANTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LTKEYWORDFILTER               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'p' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'plant p';
   BEGIN
      
      
      
      
      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.plant = null';

      OPEN AQPLANTS FOR LSSQLNULL;

      
      
      
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

      LNRETVAL := IAPIPLANT.GETPLANTS( LTDEFAULTFILTER,
                                       LTKEYWORDFILTER,
                                       ANDONOTHAVE,
                                       AQPLANTS );

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
   END GETPLANTS;

   
   FUNCTION EXISTID(
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPLANTNO                     IAPITYPE.PLANTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PLANT
        INTO LSPLANTNO
        FROM PLANT
       WHERE PLANT = ASPLANTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PLANTNOTFOUND,
                                                     ASPLANTNO ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION GETPLANTSPB(
      ASDEFAULTFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      ASKEYWORDFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      ANDONOTHAVE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQPLANTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlantsPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXDEFAULTFILTER               IAPITYPE.XMLTYPE_TYPE;
      LXKEYWORDFILTER               IAPITYPE.XMLTYPE_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'p' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'plant p';
   BEGIN
      
      
      
      
      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.plant = null';

      OPEN AQPLANTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXDEFAULTFILTER := XMLTYPE( ASDEFAULTFILTER );
      LXKEYWORDFILTER := XMLTYPE( ASKEYWORDFILTER );
      LNRETVAL := IAPIPLANT.GETPLANTS( LXDEFAULTFILTER,
                                       LXKEYWORDFILTER,
                                       ANDONOTHAVE,
                                       AQPLANTS );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPLANTSPB;

   
   FUNCTION GETKEYWORDS(
      ASPLANTID                  IN       IAPITYPE.PLANT_TYPE,
      AQKEYWORDS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetKeywords';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'p.kw_id '
            || IAPICONSTANTCOLUMN.KEYWORDIDCOL
            || ','
            || 'k.description '
            || IAPICONSTANTCOLUMN.KEYWORDCOL
            || ','
            || 'k.kw_type '
            || IAPICONSTANTCOLUMN.KEYWORDTYPECOL
            || ','
            || 'p.kw_value '
            || IAPICONSTANTCOLUMN.KEYWORDVALUECOL
            || ','
            || 'p.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'itplkw p, itkw k';
   BEGIN
      
      
      
      
      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.pl_id = NULL'
                   || ' AND'
                   || ' p.kw_id = k.kw_id';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQKEYWORDS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIPLANT.EXISTID( ASPLANTID );

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
               || ' WHERE p.pl_id = :PlantId '
               || ' AND p.kw_id = k.kw_id';
      LSSQL :=    LSSQL
               || ' ORDER BY p.kw_id ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      
      OPEN AQKEYWORDS FOR LSSQL USING ASPLANTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETKEYWORDS;

   
   FUNCTION GETLOCATIONS(
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      AQLOCATIONS                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLocations';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
                                    :=    'l.location '
                                       || IAPICONSTANTCOLUMN.LOCATIONIDCOL
                                       || ','
                                       || 'l.description '
                                       || IAPICONSTANTCOLUMN.LOCATIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'location l';
   BEGIN
      
      
      
      
      
      IF ( AQLOCATIONS%ISOPEN )
      THEN
         CLOSE AQLOCATIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE l.plant = NULL and l.location = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLOCATIONS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIPLANT.EXISTID( ASPLANTNO );

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
               || ' WHERE l.plant = :PlantNo';
      LSSQL :=    LSSQL
               || ' ORDER BY l.location ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLOCATIONS%ISOPEN )
      THEN
         CLOSE AQLOCATIONS;
      END IF;

      
      OPEN AQLOCATIONS FOR LSSQL USING ASPLANTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLOCATIONS;
END IAPIPLANT;