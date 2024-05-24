CREATE OR REPLACE PACKAGE BODY iapiTransGlos
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

   
   
   





   FUNCTION REMOVEEMPTYROW (
      ASTABLENAME                IN       IAPITYPE.DATABASEOBJECTNAME_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveEmptyRow';
      LNOBSOLETE                    IAPITYPE.BOOLEAN_TYPE DEFAULT NULL;
      LSSQLDEL                      IAPITYPE.BUFFER_TYPE := NULL;
      LSSQLWHERE                    IAPITYPE.BUFFER_TYPE := NULL;
      LSSQLWHERE1                   IAPITYPE.BUFFER_TYPE := NULL;
      LSSQLWHERE2                   IAPITYPE.BUFFER_TYPE := NULL;
      LSSQL                         IAPITYPE.BUFFER_TYPE := NULL;

      CURSOR LQREMOVE
        IS
        SELECT T.COLUMN_NAME FROM USER_TAB_COLUMNS T
          WHERE T.TABLE_NAME = UPPER(ASTABLENAME)
            AND T.COLUMN_NAME NOT IN
                (
                 SELECT ACC.COLUMN_NAME
                   FROM  USER_CONSTRAINTS AC,
                         USER_CONS_COLUMNS ACC
                    WHERE    AC.TABLE_NAME = ACC.TABLE_NAME
                         AND AC.TABLE_NAME = UPPER(ASTABLENAME)
                         AND AC.OWNER = ACC.OWNER
                         AND AC.CONSTRAINT_NAME = ACC.CONSTRAINT_NAME
                         AND AC.CONSTRAINT_TYPE = 'P');


    BEGIN
      
      
      

      FOR CUR IN LQREMOVE LOOP
         IF LSSQLWHERE1 IS NULL THEN
             LSSQLWHERE1 := CUR.COLUMN_NAME
                        || ' IS NULL '
                        ;
             LSSQLWHERE := LSSQLWHERE1;

           ELSE
             LSSQLWHERE2 := ' AND '
                        || CUR.COLUMN_NAME
                        || ' IS NULL '
                        ;
          LSSQLWHERE := LSSQLWHERE || LSSQLWHERE2;

          END IF;
      END LOOP;

      LSSQLDEL := 'DELETE '
               || ASTABLENAME
               || ' WHERE '
               ;

       LSSQL := LSSQLDEL || LSSQLWHERE;

      EXECUTE IMMEDIATE LSSQL;
      COMMIT;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                       LSMETHOD,
                       'Delete empty rows from the table: '
                       || ASTABLENAME,
                       IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEEMPTYROW;

   
   FUNCTION XMLTRANSLATE(
      AXTRANSLATE                IN       IAPITYPE.XMLTYPE_TYPE,
      ATTRANSLATEDATATABLE       OUT      IAPITYPE.TRANSGLOSL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'XmlTranslate';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               BOOLEAN;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXTRANSLATENODESLIST          XMLDOM.DOMNODELIST;
      LXTRANSLATENODE               XMLDOM.DOMNODE;
      LXTRANSLATEITEMNODE           XMLDOM.DOMNODE;
      LXTRANSLATEITEMNODESLIST      XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LRTRANSLATERECORD             IAPITYPE.TRANSGLOSLREC_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.SETPRESERVEWHITESPACE( LXPARSER,
                                       TRUE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXTRANSLATE.GETCLOBVAL( ) );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );
         
         LXTRANSLATENODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT, 'Table' );

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of rows <'
                              || XMLDOM.GETLENGTH( LXTRANSLATENODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXTRANSLATENODESLIST ) - 1
         LOOP
            LXTRANSLATENODE := XMLDOM.ITEM( LXTRANSLATENODESLIST,
                                         I );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Table <'
                                 || I
                                 || '>: <'
                                 || XMLDOM.GETNODENAME( LXTRANSLATENODE )
                                 || '>' );
            LRTRANSLATERECORD.PRIMARYKEY1 := NULL;
            LRTRANSLATERECORD.PRIMARYKEY2 := NULL;
            LRTRANSLATERECORD.TRANSVALUE := NULL;
            LXTRANSLATEITEMNODESLIST := XMLDOM.GETCHILDNODES( LXTRANSLATENODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXTRANSLATEITEMNODESLIST )
                          - 1
            LOOP
               LXTRANSLATEITEMNODE := XMLDOM.ITEM( LXTRANSLATEITEMNODESLIST,
                                                J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXTRANSLATEITEMNODE );

               
               IF ( XMLDOM.ISNULL( LXNODE ) = FALSE )
               THEN
                  IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
                  THEN
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                             'Filter item <'
                                          || J
                                          || '>: Name: <'
                                          || XMLDOM.GETNODENAME( LXTRANSLATEITEMNODE )
                                          || '>, Text: <'
                                          || XMLDOM.GETNODEVALUE( LXNODE )
                                          || '>' );

                     CASE XMLDOM.GETNODENAME( LXTRANSLATEITEMNODE )
                        WHEN 'PrimaryKey1'
                        THEN
                           LRTRANSLATERECORD.PRIMARYKEY1 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'PrimaryKey2'
                        THEN
                           LRTRANSLATERECORD.PRIMARYKEY2 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'TranslatedValue'
                        THEN
                           LRTRANSLATERECORD.TRANSVALUE := XMLDOM.GETNODEVALUE( LXNODE );
                     END CASE;
                  END IF;
               END IF;
            END LOOP;

            ATTRANSLATEDATATABLE( ATTRANSLATEDATATABLE.COUNT ) := LRTRANSLATERECORD;
         END LOOP;

         
         XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END XMLTRANSLATE;

  
   FUNCTION SAVETRANSL(
      ASTABLENAME                IN       IAPITYPE.DATABASEOBJECTNAME_TYPE,
      ASTRANSCOLUMN              IN       IAPITYPE.DATABASETABLECOLUMN_TYPE,
      AXTRANSLATE                IN       IAPITYPE.XMLTYPE_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveTransL';
      LTTRANSLATE                   IAPITYPE.TRANSGLOSL_TYPE;





   BEGIN
   IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

  
   LNRETVAL := XMLTRANSLATE( AXTRANSLATE, LTTRANSLATE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;
      LNRETVAL := IAPITRANSGLOS.SAVETRANSL( ASTABLENAME,
                                            ASTRANSCOLUMN,
                                            LTTRANSLATE  );

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
   END SAVETRANSL;
  
   FUNCTION SAVETRANSL(
      ASTABLENAME                IN       IAPITYPE.DATABASEOBJECTNAME_TYPE,
      ASTRANSCOLUMN              IN       IAPITYPE.DATABASETABLECOLUMN_TYPE,
      ATTRANSLATE                IN       IAPITYPE.TRANSGLOSL_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveTransL';
      LRTRANSLATE                   IAPITYPE.TRANSGLOSLREC_TYPE;
      LSTRANSLATE                   IAPITYPE.CLOB_TYPE := NULL;
      LSPKNAME1                     IAPITYPE.STRING_TYPE;
      LSPKNAME2                     IAPITYPE.STRING_TYPE;
      LSSQLINS                      IAPITYPE.BUFFER_TYPE := NULL;
      LSSQLUPD                      IAPITYPE.BUFFER_TYPE := NULL;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;

   BEGIN
   IAPIGENERAL.LOGINFO( GSSOURCE,
                        LSMETHOD,
                        'Body of FUNCTION',
                        IAPICONSTANT.INFOLEVEL_3 );
   
   IAPIGENERAL.LOGINFO( GSSOURCE,
                        LSMETHOD,
                        'Number of rows <'
                         || ATTRANSLATE.COUNT
                         || '>',
                         IAPICONSTANT.INFOLEVEL_3 );

       LNRETVAL := IAPIDATABASE.GETSCHEMANAME(LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
      END IF;

       BEGIN
       SELECT ACC.COLUMN_NAME INTO LSPKNAME1
         FROM  SYS.ALL_CONSTRAINTS AC,
               SYS.ALL_CONS_COLUMNS ACC
          WHERE    AC.TABLE_NAME = ACC.TABLE_NAME
               AND AC.TABLE_NAME = UPPER(ASTABLENAME)
               AND AC.OWNER = ACC.OWNER
               AND AC.CONSTRAINT_NAME = ACC.CONSTRAINT_NAME
               AND AC.OWNER = LSSCHEMANAME
               AND AC.CONSTRAINT_TYPE = 'P'
               AND ACC.POSITION = 1;
        EXCEPTION
          WHEN OTHERS THEN
          LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_APPLICATIONERROR,
                                                         SQLCODE,
                                                         SQLERRM );
                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                         LSMETHOD,
                                         IAPIGENERAL.GETLASTERRORTEXT( ) );
           END;
       BEGIN
       SELECT ACC.COLUMN_NAME INTO LSPKNAME2
         FROM  SYS.ALL_CONSTRAINTS AC,
               SYS.ALL_CONS_COLUMNS ACC
          WHERE    AC.TABLE_NAME = ACC.TABLE_NAME
               AND AC.TABLE_NAME = UPPER(ASTABLENAME)
               AND AC.OWNER = ACC.OWNER
               AND AC.CONSTRAINT_NAME = ACC.CONSTRAINT_NAME
               AND AC.OWNER = LSSCHEMANAME
               AND AC.CONSTRAINT_TYPE = 'P'
               AND ACC.POSITION = 2;

        EXCEPTION
          WHEN OTHERS THEN
          LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_APPLICATIONERROR,
                                                         SQLCODE,
                                                         SQLERRM );
                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                         LSMETHOD,
                                         IAPIGENERAL.GETLASTERRORTEXT( ) );
        END;

   FOR I IN 0 ..   ATTRANSLATE.COUNT - 1
   LOOP
       LRTRANSLATE := ATTRANSLATE (I);

       LSSQLINS := 'INSERT into '
                || ASTABLENAME
                || ' ( '
                || LSPKNAME1
                || ', '
                || LSPKNAME2
                || ', '
                || ASTRANSCOLUMN
                || ') VALUES ('
                || LRTRANSLATE.PRIMARYKEY1
                || ', '
                || LRTRANSLATE.PRIMARYKEY2
                || ', '
                || ''''
                || LRTRANSLATE.TRANSVALUE
                || ''''
                || ')';

       LSSQLUPD := 'UPDATE '
                || ASTABLENAME
                || ' SET '
                || ASTRANSCOLUMN
                || ' = '
                || ''''
                || LRTRANSLATE.TRANSVALUE
                || ''''
                || ' WHERE '
                || LSPKNAME1
                || ' = '
                || LRTRANSLATE.PRIMARYKEY1
                || ' AND '
                || LSPKNAME2
                || ' = '
                || LRTRANSLATE.PRIMARYKEY2
                || ' ';

       BEGIN
         EXECUTE IMMEDIATE LSSQLINS;
         COMMIT;
                 IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Insert statement '
                           || LSSQLINS,
                           IAPICONSTANT.INFOLEVEL_3 );

         IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Insert into '
                           || ASTABLENAME
                           || ' for '
                           || LSPKNAME1
                           || ' = '
                           || LRTRANSLATE.PRIMARYKEY1
                           || ' , '
                           || LSPKNAME2
                           || ' = '
                           || LRTRANSLATE.PRIMARYKEY2
                           || ' translation '
                           || ASTRANSCOLUMN
                           || ' = '
                           || LRTRANSLATE.TRANSVALUE
                           || ' ',
                           IAPICONSTANT.INFOLEVEL_3 );
       EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            EXECUTE IMMEDIATE LSSQLUPD;
            COMMIT;
                 IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Update statement '
                           || LSSQLUPD,
                           IAPICONSTANT.INFOLEVEL_3 );

            IAPIGENERAL.LOGINFO( GSSOURCE,
                             LSMETHOD,
                             'Update '
                             || ASTABLENAME
                             || ' for '
                             || LSPKNAME1
                             || ' = '
                             || LRTRANSLATE.PRIMARYKEY1
                             || ' , '
                             || LSPKNAME2
                             || ' = '
                             || LRTRANSLATE.PRIMARYKEY2
                             || ' translation '
                             || ASTRANSCOLUMN
                             || ' = '
                             || LRTRANSLATE.TRANSVALUE
                             || ' ',
                             IAPICONSTANT.INFOLEVEL_3 );

       END;
   END LOOP;


   LNRETVAL := REMOVEEMPTYROW( ASTABLENAME );
   IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
    THEN
       IAPIGENERAL.LOGERROR( GSSOURCE,
                             LSMETHOD,
                             IAPIGENERAL.GETLASTERRORTEXT( ) );
   END IF;

   LNRETVAL :=  IAPICONSTANTDBERROR.DBERR_SUCCESS;
   RETURN(LNRETVAL);
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVETRANSL;
  
END IAPITRANSGLOS;