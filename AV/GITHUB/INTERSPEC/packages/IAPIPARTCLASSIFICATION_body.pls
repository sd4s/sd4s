CREATE OR REPLACE PACKAGE BODY iapipartclassification
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
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || LSALIAS
         || 'hier_level '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ','
         || LSALIAS
         || 'matl_class_id '
         || IAPICONSTANTCOLUMN.MATERIALCLASSIDCOL
         || ','
         || 'material_class.long_name '
         || IAPICONSTANTCOLUMN.MATERIALCLASSCOL
         || ','
         || LSALIAS
         || 'code '
         || IAPICONSTANTCOLUMN.CODECOL
         || ','
         || LSALIAS
         || 'type '
         || IAPICONSTANTCOLUMN.TYPECOL
         || ','
         || 'itclat.label '
         || IAPICONSTANTCOLUMN.LABELCOL
         || ' ';
      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNS;





   FUNCTION GETCLASSIFICATIONS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQCLASSIFICATIONS          OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetClassifications';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'cl' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itprcl cl, material_class, itclat ';
   BEGIN





      IF ( AQCLASSIFICATIONS%ISOPEN )
      THEN
         CLOSE AQCLASSIFICATIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || 'FROM '
                   || LSFROM
                   || ' WHERE cl.part_no = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQCLASSIFICATIONS FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

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
      
      LSSQL :=
           
            
            'SELECT DISTINCT '
            
         || LSSELECT
         || 'FROM '
         || LSFROM
         || 'WHERE '
         || 'cl.matl_class_id = material_class.IDENTIFIER '
         || 'AND cl.code = itclat.code(+) '
         || 'AND cl.part_no = :aspartno '
         || 'ORDER BY '
         || IAPICONSTANTCOLUMN.TYPECOL
         || ' ASC, '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ' ASC ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQCLASSIFICATIONS%ISOPEN )
      THEN
         CLOSE AQCLASSIFICATIONS;
      END IF;

      
      OPEN AQCLASSIFICATIONS FOR LSSQL USING ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCLASSIFICATIONS;


   FUNCTION REMOVECLASSIFICATION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveClassification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN





      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITPRCL
            WHERE PART_NO = ASPARTNO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_CLASSIFICATIONNOTFOUND,
                                                     ASPARTNO ) );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete classification for PartNo <'
                           || ASPARTNO
                           || '> ',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVECLASSIFICATION;


   FUNCTION ADDCLASSIFICATION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANHIERARCHICALLEVEL        IN       IAPITYPE.LEVEL_TYPE,
      ANMATERIALCLASSID          IN       IAPITYPE.MATERIALCLASSID_TYPE,
      ASCLASSIFICATIONCODE       IN       IAPITYPE.CLASSIFICATIONCODE_TYPE,
      ASCLASSIFICATIONTYPE       IN       IAPITYPE.CLASSIFICATIONTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddClassification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN





      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

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

      BEGIN
         INSERT INTO ITPRCL
                     ( PART_NO,
                       HIER_LEVEL,
                       MATL_CLASS_ID,
                       CODE,
                       TYPE )
              VALUES ( ASPARTNO,
                       ANHIERARCHICALLEVEL,
                       ANMATERIALCLASSID,
                       ASCLASSIFICATIONCODE,
                       ASCLASSIFICATIONTYPE );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_DUPLICATECLASSIFICATION,
                                                        ASPARTNO,
                                                        ANHIERARCHICALLEVEL,
                                                        ANMATERIALCLASSID,
                                                        ASCLASSIFICATIONCODE,
                                                        ASCLASSIFICATIONTYPE ) );
      END;

      INSERT INTO ITPRCL_H
                  ( PART_NO,
                    HIER_LEVEL,
                    MATL_CLASS_ID,
                    CODE,
                    TYPE,
                    LAST_MODIFIED_ON,
                    LAST_MODIFIED_BY,
                    FORENAME,
                    LAST_NAME )
           VALUES ( ASPARTNO,
                    ANHIERARCHICALLEVEL,
                    ANMATERIALCLASSID,
                    ASCLASSIFICATIONCODE,
                    ASCLASSIFICATIONTYPE,
                    SYSDATE,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDCLASSIFICATION;
END IAPIPARTCLASSIFICATION;