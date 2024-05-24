CREATE OR REPLACE PACKAGE BODY iapiProperty
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
         || 'property '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ','
         || LSALIAS
         || 'description '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ','
         || LSALIAS
         || 'intl '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ','
         || LSALIAS
         || 'status '
         || IAPICONSTANTCOLUMN.HISTORICCOL;
      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNS;

   
   
   
   
   FUNCTION GETPROPERTIES(
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      AQPROPERTIES               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProperties';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'p' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'property p';
   BEGIN
      
      
      
      
      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.property = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROPERTIES FOR LSSQLNULL;

      
      
      
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
            WHEN IAPICONSTANTCOLUMN.PROPERTYCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.description';
            WHEN IAPICONSTANTCOLUMN.INTERNATIONALCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.intl';
            WHEN IAPICONSTANTCOLUMN.HISTORICCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.status';
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
               || ' ORDER BY 2';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      
      OPEN AQPROPERTIES FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTIES;

   
   FUNCTION EXISTPROPERTY(
      ANPROPERTY                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPROPERTY                    IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PROPERTY
        INTO LNPROPERTY
        FROM PROPERTY
       WHERE PROPERTY = ANPROPERTY;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PROPERTYNOTFOUND,
                                                    ANPROPERTY );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTPROPERTY;

   
   FUNCTION EXISTPROPERTY(
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANPROPERTYREVISION         IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPROPERTY                    IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PROPERTY
        INTO LNPROPERTY
        FROM PROPERTY_H
       WHERE PROPERTY = ANPROPERTYID
         AND REVISION = ANPROPERTYREVISION
         AND LANG_ID = 1;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PROPERTYNOTFOUND,
                                                    ANPROPERTYID,
                                                    ANPROPERTYREVISION );
      
      
      
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTPROPERTY;

   
   FUNCTION CREATEFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ASPROPERTYGROUP            IN       IAPITYPE.STRING_TYPE,
      ASSINGLEPROPERTY           IN       IAPITYPE.STRING_TYPE,
      ASATTRIBUTE                IN       IAPITYPE.STRING_TYPE,
      ASTESTMETHOD               IN       IAPITYPE.STRING_TYPE,
      ASUOM                      IN       IAPITYPE.STRING_TYPE,
      ASHEADER                   IN       IAPITYPE.STRING_TYPE,
      ASPROPERTYGROUPSINGLEPROPERTY IN    IAPITYPE.STRING_TYPE,
      ASDATATYPE                 IN       IAPITYPE.STRING_TYPE,
      ASOPERATOR                 IN       IAPITYPE.STRING_TYPE,
      ASVALUE1                   IN       IAPITYPE.STRING_TYPE,
      ASVALUE2                   IN       IAPITYPE.STRING_TYPE,
      
      ASANDOR                    IN       IAPITYPE.STRING_TYPE,      
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ANOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
                    
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFilter (2)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPROPERTYGROUP               SYS.XMLTYPE;
      LXSINGLEPROPERTY              SYS.XMLTYPE;
      LXATTRIBUTE                   SYS.XMLTYPE;
      LXTESTMETHOD                  SYS.XMLTYPE;
      LXUOM                         SYS.XMLTYPE;
      LXHEADER                      SYS.XMLTYPE;
      LXPROPERTYGROUPSINGLEPROPERTY SYS.XMLTYPE;
      LXDATATYPE                    SYS.XMLTYPE;
      LXOPERATOR                    SYS.XMLTYPE;
      LXVALUE1                      SYS.XMLTYPE;
      LXVALUE2                      SYS.XMLTYPE;
      
      LXANDOR                      SYS.XMLTYPE;
   BEGIN
      LXPROPERTYGROUP := XMLTYPE.CREATEXML( ASPROPERTYGROUP );
      LXSINGLEPROPERTY := XMLTYPE.CREATEXML( ASSINGLEPROPERTY );
      LXATTRIBUTE := XMLTYPE.CREATEXML( ASATTRIBUTE );
      LXTESTMETHOD := XMLTYPE.CREATEXML( ASTESTMETHOD );
      LXUOM := XMLTYPE.CREATEXML( ASUOM );
      LXHEADER := XMLTYPE.CREATEXML( ASHEADER );
      LXPROPERTYGROUPSINGLEPROPERTY := XMLTYPE.CREATEXML( ASPROPERTYGROUPSINGLEPROPERTY );
      LXDATATYPE := XMLTYPE.CREATEXML( ASDATATYPE );
      LXOPERATOR := XMLTYPE.CREATEXML( ASOPERATOR );
      LXVALUE1 := XMLTYPE.CREATEXML( ASVALUE1 );
      LXVALUE2 := XMLTYPE.CREATEXML( ASVALUE2 );
      
      LXANDOR := XMLTYPE.CREATEXML( ASANDOR );
      
      LNRETVAL :=
         CREATEFILTER( ANFILTERID,
                       ANARRAY,
                       LXPROPERTYGROUP,
                       LXSINGLEPROPERTY,
                       LXATTRIBUTE,
                       LXTESTMETHOD,
                       LXUOM,
                       LXHEADER,
                       LXPROPERTYGROUPSINGLEPROPERTY,
                       LXDATATYPE,
                       LXOPERATOR,
                       LXVALUE1,
                       LXVALUE2,
                       
                       LXANDOR,
                       ASSORTDESC,
                       ASCOMMENT,
                       ANOVERWRITE );

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
   END CREATEFILTER;

   
   FUNCTION CREATEFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      AXPROPERTYGROUP            IN       IAPITYPE.XMLTYPE_TYPE,
      AXSINGLEPROPERTY           IN       IAPITYPE.XMLTYPE_TYPE,
      AXATTRIBUTE                IN       IAPITYPE.XMLTYPE_TYPE,
      AXTESTMETHOD               IN       IAPITYPE.XMLTYPE_TYPE,
      AXUOM                      IN       IAPITYPE.XMLTYPE_TYPE,
      AXHEADER                   IN       IAPITYPE.XMLTYPE_TYPE,
      AXPROPERTYGROUPSINGLEPROPERTY IN    IAPITYPE.XMLTYPE_TYPE,
      AXDATATYPE                 IN       IAPITYPE.XMLTYPE_TYPE,
      AXOPERATOR                 IN       IAPITYPE.XMLTYPE_TYPE,
      AXVALUE1                   IN       IAPITYPE.XMLTYPE_TYPE,
      AXVALUE2                   IN       IAPITYPE.XMLTYPE_TYPE,
      
      AXANDOR                   IN       IAPITYPE.XMLTYPE_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ANOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
                    
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFilter (1)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPATHPROPERTYGROUP           IAPITYPE.STRING_TYPE := '/propertygroups/propertygroup';
      LXPATHSINGLEPROPERTY          IAPITYPE.STRING_TYPE := '/singleproperties/singleproperty';
      LXPATHATTRIBUTE               IAPITYPE.STRING_TYPE := '/attributes/attribute';
      LXPATHTESTMETHOD              IAPITYPE.STRING_TYPE := '/testmethods/testmethod';
      LXPATHUOM                     IAPITYPE.STRING_TYPE := '/uoms/uom';
      LXPATHHEADER                  IAPITYPE.STRING_TYPE := '/headers/header';
      LXPATHPROPGRPSINGLEPROPERTY   IAPITYPE.STRING_TYPE := '/pgsproperties/pgsproperty';
      LXPATHDATATYPE                IAPITYPE.STRING_TYPE := '/datatypes/datatype';
      LXPATHOPERATOR                IAPITYPE.STRING_TYPE := '/operators/operator';
      LXPATHVALUE1                  IAPITYPE.STRING_TYPE := '/values1/value';
      LXPATHVALUE2                  IAPITYPE.STRING_TYPE := '/values2/value';
      
      LXPATHANDOR                  IAPITYPE.STRING_TYPE := '/andors/andor';
      LTPROPERTYGROUP               IAPITYPE.NUMBERTAB_TYPE;
      LTSINGLEPROPERTY              IAPITYPE.NUMBERTAB_TYPE;
      LTATTRIBUTE                   IAPITYPE.NUMBERTAB_TYPE;
      LTTESTMETHOD                  IAPITYPE.NUMBERTAB_TYPE;
      LTUOM                         IAPITYPE.NUMBERTAB_TYPE;
      LTHEADER                      IAPITYPE.NUMBERTAB_TYPE;
      LTPROPERTYGROUPSINGLEPROPERTY IAPITYPE.NUMBERTAB_TYPE;
      LTDATATYPE                    IAPITYPE.NUMBERTAB_TYPE;
      LTOPERATOR                    IAPITYPE.CHARTAB_TYPE;
      LTVALUE1                      IAPITYPE.CHARTAB_TYPE;
      LTVALUE2                      IAPITYPE.CHARTAB_TYPE;
      
      LTANDOR                      IAPITYPE.CHARTAB_TYPE;
   BEGIN
      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXPROPERTYGROUP,
                                                  LXPATHPROPERTYGROUP ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHPROPERTYGROUP )
                              || '['
                              || INDX
                              || ']' )
           INTO LTPROPERTYGROUP( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXPROPERTYGROUP,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXSINGLEPROPERTY,
                                                  LXPATHSINGLEPROPERTY ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHSINGLEPROPERTY )
                              || '['
                              || INDX
                              || ']' )
           INTO LTSINGLEPROPERTY( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXSINGLEPROPERTY,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXATTRIBUTE,
                                                  LXPATHATTRIBUTE ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHATTRIBUTE )
                              || '['
                              || INDX
                              || ']' )
           INTO LTATTRIBUTE( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXATTRIBUTE,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXTESTMETHOD,
                                                  LXPATHTESTMETHOD ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHTESTMETHOD )
                              || '['
                              || INDX
                              || ']' )
           INTO LTTESTMETHOD( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXTESTMETHOD,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXUOM,
                                                  LXPATHUOM ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHUOM )
                              || '['
                              || INDX
                              || ']' )
           INTO LTUOM( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXUOM,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXHEADER,
                                                  LXPATHHEADER ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHHEADER )
                              || '['
                              || INDX
                              || ']' )
           INTO LTHEADER( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXHEADER,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXPROPERTYGROUPSINGLEPROPERTY,
                                                  LXPATHPROPGRPSINGLEPROPERTY ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHPROPGRPSINGLEPROPERTY )
                              || '['
                              || INDX
                              || ']' )
           INTO LTPROPERTYGROUPSINGLEPROPERTY( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXPROPERTYGROUPSINGLEPROPERTY,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXDATATYPE,
                                                  LXPATHDATATYPE ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHDATATYPE )
                              || '['
                              || INDX
                              || ']' )
           INTO LTDATATYPE( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXDATATYPE,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXOPERATOR,
                                                  LXPATHOPERATOR ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHOPERATOR )
                              || '['
                              || INDX
                              || ']' )
           INTO LTOPERATOR( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXOPERATOR,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALUE1,
                                                  LXPATHVALUE1 ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHVALUE1 )
                              || '['
                              || INDX
                              || ']' )
           INTO LTVALUE1( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALUE1,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALUE2,
                                                  LXPATHVALUE2 ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHVALUE2 )
                              || '['
                              || INDX
                              || ']' )
           INTO LTVALUE2( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALUE2,
                                                     '/' ) ) ) T ) R;
      END LOOP;

     
      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXANDOR,
                                                  LXPATHANDOR ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHANDOR )
                              || '['
                              || INDX
                              || ']' )
           INTO LTANDOR( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXANDOR,
                                                     '/' ) ) ) T ) R;
      END LOOP;     
     
     
      LNRETVAL :=
         CREATEFILTER( ANFILTERID,
                       ANARRAY,
                       LTPROPERTYGROUP,
                       LTSINGLEPROPERTY,
                       LTATTRIBUTE,
                       LTTESTMETHOD,
                       LTUOM,
                       LTHEADER,
                       LTPROPERTYGROUPSINGLEPROPERTY,
                       LTDATATYPE,
                       LTOPERATOR,
                       LTVALUE1,
                       LTVALUE2,
                       
                       LTANDOR,
                       ASSORTDESC,
                       ASCOMMENT,
                       ANOVERWRITE );

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
   END CREATEFILTER;

   
   FUNCTION CREATEFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ATPROPERTYGROUP            IN       IAPITYPE.NUMBERTAB_TYPE,
      ATSINGLEPROPERTY           IN       IAPITYPE.NUMBERTAB_TYPE,
      ATATTRIBUTE                IN       IAPITYPE.NUMBERTAB_TYPE,
      ATTESTMETHOD               IN       IAPITYPE.NUMBERTAB_TYPE,
      ATUOM                      IN       IAPITYPE.NUMBERTAB_TYPE,
      ATHEADER                   IN       IAPITYPE.NUMBERTAB_TYPE,
      ATPROPERTYGROUPSINGLEPROPERTY IN    IAPITYPE.NUMBERTAB_TYPE,
      ATDATATYPE                 IN       IAPITYPE.NUMBERTAB_TYPE,
      ATOPERATOR                 IN       IAPITYPE.CHARTAB_TYPE,
      ATVALUE1                   IN       IAPITYPE.CHARTAB_TYPE,
      ATVALUE2                   IN       IAPITYPE.CHARTAB_TYPE,
      
      ATANDOR                   IN       IAPITYPE.CHARTAB_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ANOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
                    
      
      
      
      

      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFilter';
      LNFILTERID                    IAPITYPE.FILTERID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNFILTERID := ANFILTERID;

      IF ANOVERWRITE = 1
      THEN
         BEGIN
            UPDATE ITSPFLTD
               SET SORT_DESC = ASSORTDESC,
                   DESCRIPTION = ASCOMMENT
             WHERE FILTER_ID = ANFILTERID;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      ELSE
         BEGIN
            SELECT SHFLT_SEQ.NEXTVAL
              INTO LNFILTERID
              FROM DUAL;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;

         ANFILTERID := LNFILTERID;

         BEGIN
            INSERT INTO ITSPFLTD
                        ( FILTER_ID,
                          USER_ID,
                          SORT_DESC,
                          DESCRIPTION )
                 VALUES ( LNFILTERID,
                          USER,
                          ASSORTDESC,
                          ASCOMMENT );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      DELETE FROM ITSPFLT
            WHERE FILTER_ID = ANFILTERID;

      FOR L_COUNTER IN 1 .. ANARRAY
      LOOP
         BEGIN
            INSERT INTO ITSPFLT
                        ( FILTER_ID,
                          PG,
                          SP,
                          ATT,
                          TM,
                          UM,
                          HDR,
                          PGSP,
                          OPERATOR,
                          VALUE1,
                          VALUE2,
                          
                          AND_OR,
                          DT )
                 VALUES ( ANFILTERID,
                          ATPROPERTYGROUP( L_COUNTER ),
                          ATSINGLEPROPERTY( L_COUNTER ),
                          ATATTRIBUTE( L_COUNTER ),
                          ATTESTMETHOD( L_COUNTER ),
                          ATUOM( L_COUNTER ),
                          ATHEADER( L_COUNTER ),
                          ATPROPERTYGROUPSINGLEPROPERTY( L_COUNTER ),
                          SUBSTR( ATOPERATOR( L_COUNTER ),
                                  1,
                                  40 ),
                          ATVALUE1( L_COUNTER ),
                          ATVALUE2( L_COUNTER ),
                          
                          ATANDOR( L_COUNTER ),                          
                          ATDATATYPE( L_COUNTER ) );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
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
   END;

   
   FUNCTION GETPROPERTYID(
      ASPROPERTYDESC             IN       IAPITYPE.DESCRIPTION_TYPE,
      ANPROPERTYID               OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPropertyId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PROPERTY
        INTO ANPROPERTYID
        FROM PROPERTY
       WHERE DESCRIPTION = ASPROPERTYDESC;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PROPERTYIDNOTFNDFORDESC,
                                                     ASPROPERTYDESC ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTYID;
END IAPIPROPERTY;