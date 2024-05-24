CREATE OR REPLACE PACKAGE BODY iapiFrameSection
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
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIFRAME.EXISTID( ASFRAMENO,
                                     ANREVISION,
                                     ANOWNER );

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

      SELECT DISTINCT FRAME_NO
                 INTO LSFRAMENO
                 FROM FRAME_SECTION
                WHERE FRAME_NO = ASFRAMENO
                  AND REVISION = ANREVISION
                  AND OWNER = ANOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_FRAMESECTIONNOTFOUND,
                                                     ASFRAMENO,
                                                     ANREVISION,
                                                     ANOWNER,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0) ));
                                                     
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION EXISTITEMINSECTION(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      ANMASKID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsItemInSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSECTIONSEQUENCENUMBER       IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE;
      LSMANDATORY                   IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIFRAMESECTION.EXISTID( ASFRAMENO,
                                            ANREVISION,
                                            ANOWNER,
                                            ANSECTIONID,
                                            ANSUBSECTIONID );

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

       
      
      IF (     ANTYPE IN( IAPICONSTANT.SECTIONTYPE_OBJECT, IAPICONSTANT.SECTIONTYPE_REFERENCETEXT )
           AND ( ANITEMID <> 0 ) )
      THEN
         SELECT DISTINCT SECTION_SEQUENCE_NO
                    INTO LNSECTIONSEQUENCENUMBER
                    FROM FRAME_SECTION
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = ANREVISION
                     AND OWNER = ANOWNER
                     AND SECTION_ID = ANSECTIONID
                     AND SUB_SECTION_ID = ANSUBSECTIONID
                     AND TYPE = ANTYPE
                     AND REF_ID = ANITEMID
                     AND REF_VER = ANITEMREVISION
                     AND REF_OWNER = ANITEMOWNER;
      ELSE
         SELECT DISTINCT SECTION_SEQUENCE_NO
                    INTO LNSECTIONSEQUENCENUMBER
                    FROM FRAME_SECTION
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = ANREVISION
                     AND OWNER = ANOWNER
                     AND SECTION_ID = ANSECTIONID
                     AND SUB_SECTION_ID = ANSUBSECTIONID
                     AND TYPE = ANTYPE
                     AND REF_ID = ANITEMID;
      END IF;

      
      
      
      IF ( ANMASKID IS NOT NULL )
      THEN
         SELECT MANDATORY
           INTO LSMANDATORY
           FROM ITFRMVSC
          WHERE VIEW_ID = ANMASKID
            AND FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = ANITEMID
            AND SECTION_SEQUENCE_NO = LNSECTIONSEQUENCENUMBER;

         IF ( LSMANDATORY = IAPICONSTANT.FLAG_HIDDEN )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_FRAMEITEMHIDDEN,
                                                        ASFRAMENO,
                                                        ANREVISION,
                                                        ANOWNER,
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                        F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),                                                                                                    
                                                        F_RFH_DESCR(NULL, ANTYPE, ANITEMID),
                                                        F_GET_MASK(ASFRAMENO, ANREVISION, ANOWNER, ANMASKID) ));
                                                        
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_FRAMEITEMNOTFOUND,
                                                     ASFRAMENO,
                                                     ANREVISION,
                                                     ANOWNER,
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),
                                                     F_RFH_DESCR(NULL, ANTYPE, ANITEMID)));                                            
                                                     
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTITEMINSECTION;

   
   FUNCTION GETSECTIONS(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      AQSECTIONS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSections';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSQLCHUNK                    VARCHAR2( 1024 ) := NULL;
      LNCHUNKCOUNT                  NUMBER := 0;
      LSSELECT                      VARCHAR2( 4096 )
         :=    ''''
            || ASFRAMENO
            || ''' '   
            || IAPICONSTANTCOLUMN.FRAMENOCOL
            || ', '
            || ANREVISION
            || ' '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', '
            || ANOWNER
            || ' '
            || IAPICONSTANTCOLUMN.OWNERCOL
            || ', section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', section_sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', DECODE(sc_ext, ''Y'', 1, 0) '
            || IAPICONSTANTCOLUMN.EXTENDABLECOL;
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := 'frame_section';
      LCFRSECTIONS                  FRSECTIONDATATABLE_TYPE := FRSECTIONDATATABLE_TYPE( );
      LRFRSECTION                   IAPITYPE.FRSECTIONREC_TYPE;
      LOFRSECTION                   FRSECTIONRECORD_TYPE;
      LNSECTIONS                    NUMBER := 0;
      LNCURSOR                      INTEGER;
      LBFETCHING                    BOOLEAN := TRUE;
      LNROWINDEX                    NUMBER;
   BEGIN
      
      
      
      
      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || LSSELECT
         || ', NULL '
         || IAPICONSTANTCOLUMN.NAMECOL   
         || ' FROM '
         || LSFROMFRAME
         || ' WHERE frame_no = NULL';
      LSSQLNULL :=
             'SELECT a.*, RowNum '
          || IAPICONSTANTCOLUMN.ROWINDEXCOL
          || ', 0 '
          || IAPICONSTANTCOLUMN.PARENTROWINDEXCOL
          || ' FROM ('
          || LSSQLNULL
          || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROMFRAME
         || ' WHERE frame_no = '''
         || ASFRAMENO
         || ''' AND revision = '
         || ANREVISION
         || ' AND owner = '
         || ANOWNER;
      LSSQL :=
            'SELECT a.* '
         || ', f_sch_descr(1, '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.SECTIONNAMECOL
         || ', f_sbh_descr(1, '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.SUBSECTIONNAMECOL
         || ', RowNum '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.PARENTROWINDEXCOL
         || ' FROM ('
         || ' SELECT '
         || IAPICONSTANTCOLUMN.FRAMENOCOL
         || ', '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ') '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.EXTENDABLECOL
         || ') '
         || IAPICONSTANTCOLUMN.EXTENDABLECOL
         || ' FROM ( '
         || LSSQL
         || ') GROUP BY '
         || IAPICONSTANTCOLUMN.FRAMENOCOL
         || ', '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ' ORDER BY '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ') a';
      
      LSSQLCHUNK := SUBSTR( LSSQL,
                            1,
                            1024 );

      WHILE( LENGTH( LSSQLCHUNK ) > 0 )
      LOOP
         LNCHUNKCOUNT :=   LNCHUNKCOUNT
                         + 1;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQLCHUNK,
                              IAPICONSTANT.INFOLEVEL_3 );
         LSSQLCHUNK := SUBSTR( LSSQL,
                                 1024
                               * LNCHUNKCOUNT,
                               1024 );
      END LOOP;

      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              1,
                              LRFRSECTION.FRAMENO,
                              18 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              2,
                              LRFRSECTION.REVISION );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              3,
                              LRFRSECTION.SECTIONID );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              4,
                              LRFRSECTION.SECTIONREVISION );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              5,
                              LRFRSECTION.SUBSECTIONID );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              6,
                              LRFRSECTION.SUBSECTIONREVISION );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              7,
                              LRFRSECTION.EXTENDABLE );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              8,
                              LRFRSECTION.SEQUENCE );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              9,
                              LRFRSECTION.SECTIONNAME,
                              60 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              10,
                              LRFRSECTION.SUBSECTIONNAME,
                              60 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              11,
                              LRFRSECTION.ROWINDEX );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              12,
                              LRFRSECTION.PARENTROWINDEX );
      LNRETVAL := DBMS_SQL.EXECUTE( LNCURSOR );

      WHILE( LBFETCHING )
      LOOP
         LNRETVAL := DBMS_SQL.FETCH_ROWS( LNCURSOR );

         IF ( LNRETVAL = 0 )
         THEN
            LBFETCHING := FALSE;
         ELSE
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   1,
                                   LRFRSECTION.FRAMENO );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   2,
                                   LRFRSECTION.REVISION );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   3,
                                   LRFRSECTION.SECTIONID );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   4,
                                   LRFRSECTION.SECTIONREVISION );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   5,
                                   LRFRSECTION.SUBSECTIONID );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   6,
                                   LRFRSECTION.SUBSECTIONREVISION );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   7,
                                   LRFRSECTION.SEQUENCE );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   8,
                                   LRFRSECTION.EXTENDABLE );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   9,
                                   LRFRSECTION.SECTIONNAME );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   10,
                                   LRFRSECTION.SUBSECTIONNAME );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   11,
                                   LRFRSECTION.ROWINDEX );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   12,
                                   LRFRSECTION.PARENTROWINDEX );
            LNSECTIONS :=   LNSECTIONS
                          + 1;
            LCFRSECTIONS.EXTEND;
            LOFRSECTION :=
               FRSECTIONRECORD_TYPE( LRFRSECTION.FRAMENO,
                                     LRFRSECTION.REVISION,
                                     LRFRSECTION.SECTIONID,
                                     LRFRSECTION.SECTIONREVISION,
                                     LRFRSECTION.SECTIONNAME,
                                     LRFRSECTION.SUBSECTIONID,
                                     LRFRSECTION.SUBSECTIONREVISION,
                                     LRFRSECTION.SUBSECTIONNAME,
                                     LRFRSECTION.SEQUENCE,
                                     LRFRSECTION.EXTENDABLE,
                                     LRFRSECTION.ROWINDEX,
                                     LRFRSECTION.PARENTROWINDEX );
            LCFRSECTIONS( LNSECTIONS ) := LOFRSECTION;
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      
      
      
      LNROWINDEX := 0;

      FOR LNCOUNT IN LCFRSECTIONS.FIRST .. LCFRSECTIONS.LAST
      LOOP
         IF LCFRSECTIONS( LNCOUNT ).SUBSECTIONID <> 0
         THEN
            SELECT COUNT( * )
              INTO LNRETVAL
              FROM TABLE( LCFRSECTIONS ) T
             WHERE T.SECTIONID = LCFRSECTIONS( LNCOUNT ).SECTIONID
               AND T.SUBSECTIONID = 0;

            IF LNRETVAL = 0
            THEN
               LCFRSECTIONS.EXTEND;
               LNROWINDEX :=   LNROWINDEX
                             + 1;
               LOFRSECTION :=
                  FRSECTIONRECORD_TYPE( LCFRSECTIONS( LNCOUNT ).FRAMENO,
                                        LCFRSECTIONS( LNCOUNT ).REVISION,
                                        LCFRSECTIONS( LNCOUNT ).SECTIONID,
                                        100,
                                        LCFRSECTIONS( LNCOUNT ).SECTIONNAME,
                                        0,
                                        100,
                                        '(none)',
                                          LCFRSECTIONS( LNCOUNT ).SEQUENCE
                                        - 1,
                                        LCFRSECTIONS( LNCOUNT ).EXTENDABLE,
                                        LNROWINDEX,
                                        0 );
               LNSECTIONS :=   LNSECTIONS
                             + 1;
               LCFRSECTIONS( LNSECTIONS ) := LOFRSECTION;
            END IF;
         END IF;

         LNROWINDEX :=   LNROWINDEX
                       + 1;
         LCFRSECTIONS( LNCOUNT ).ROWINDEX := LNROWINDEX;
      END LOOP;

      
      FOR LNCOUNT IN LCFRSECTIONS.FIRST .. LCFRSECTIONS.LAST
      LOOP
         IF LCFRSECTIONS( LNCOUNT ).SUBSECTIONID <> 0
         THEN
            SELECT ROWINDEX
              INTO LNROWINDEX
              FROM TABLE( LCFRSECTIONS ) T
             WHERE T.SECTIONID = LCFRSECTIONS( LNCOUNT ).SECTIONID
               AND T.SUBSECTIONID = 0;
         ELSE
            LNROWINDEX := 0;
         END IF;

         LCFRSECTIONS( LNCOUNT ).PARENTROWINDEX := LNROWINDEX;
      END LOOP;

      OPEN AQSECTIONS FOR
         SELECT   FRAMENO,
                  REVISION,
                  SECTIONID,
                  SECTIONREVISION,
                  SUBSECTIONID,
                  SUBSECTIONREVISION,
                  DECODE( SUBSECTIONNAME,
                          '(none)', SECTIONNAME,
                          SUBSECTIONNAME ) NAME,
                  EXTENDABLE,
                  ROWINDEX,
                  PARENTROWINDEX
             FROM TABLE( CAST( LCFRSECTIONS AS FRSECTIONDATATABLE_TYPE ) )
         ORDER BY ROWINDEX;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSECTIONS;

   
   FUNCTION GETSECTIONITEMS(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AQSECTIONITEMS             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSectionItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSEXTENDED                    VARCHAR2( 2048 ) := NULL;   
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSQLCHUNK                    VARCHAR2( 1024 ) := NULL;
      LNCHUNKCOUNT                  NUMBER := 0;
      LSSELECT                      VARCHAR2( 4096 )
         :=    ''''
            || ASFRAMENO
            || ''' '   
            || IAPICONSTANTCOLUMN.FRAMENOCOL
            || ', '
            || ANREVISION
            || ' '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', '
            || ANOWNER
            || ' '
            || IAPICONSTANTCOLUMN.OWNERCOL
            || ', section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', type '
            || IAPICONSTANTCOLUMN.ITEMTYPECOL
            || ', ref_id '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', ref_ver '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', ref_owner '
            || IAPICONSTANTCOLUMN.ITEMOWNERCOL
            || ', ref_info '
            || IAPICONSTANTCOLUMN.ITEMINFOCOL
            || ', sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', section_sequence_no '
            || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL
            || ', display_format '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
            || ', display_format_rev '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATREVISIONCOL
            || ', association '
            || IAPICONSTANTCOLUMN.ASSOCIATIONIDCOL
            || ', intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', header '
            || IAPICONSTANTCOLUMN.HEADERCOL
            || ', decode(mandatory,''N'',1,0) '
            || IAPICONSTANTCOLUMN.OPTIONALCOL;
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := 'frame_section';
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQSECTIONITEMS%ISOPEN )
      THEN
         CLOSE AQSECTIONITEMS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROMFRAME
                   || ' WHERE frame_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( ASFRAMENO,
                           ANREVISION,
                           ANOWNER,
                           ANSECTIONID,
                           ANSUBSECTIONID );

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
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROMFRAME
         || ' WHERE frame_no = '''
         || ASFRAMENO
         || ''' AND revision = '
         || ANREVISION
         || ' AND owner = '
         || ANOWNER
         || ' AND section_id = '
         || ANSECTIONID
         || ' AND sub_section_id = '
         || ANSUBSECTIONID
         || ' ORDER BY '
         || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      
      LSSQLCHUNK := SUBSTR( LSSQL,
                            1,
                            1024 );

      WHILE( LENGTH( LSSQLCHUNK ) > 0 )
      LOOP
         LNCHUNKCOUNT :=   LNCHUNKCOUNT
                         + 1;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQLCHUNK,
                              IAPICONSTANT.INFOLEVEL_3 );
         LSSQLCHUNK := SUBSTR( LSSQL,
                                 1024
                               * LNCHUNKCOUNT,
                               1024 );
      END LOOP;

      
      IF ( AQSECTIONITEMS%ISOPEN )
      THEN
         CLOSE AQSECTIONITEMS;
      END IF;

      
      OPEN AQSECTIONITEMS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSECTIONITEMS;

   
   FUNCTION ISITEMLOCALLYMODIFIABLE(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      ANLOCALLYMODIFIABLE        OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsItemLocallyModifiable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTITEMINSECTION( ASFRAMENO,
                                      ANREVISION,
                                      ANOWNER,
                                      ANSECTIONID,
                                      ANSUBSECTIONID,
                                      ANTYPE,
                                      ANITEMID,
                                      ANITEMREVISION,
                                      ANITEMOWNER );

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

      SELECT DECODE( INTL,
                     2, 1,
                     0 )
        INTO ANLOCALLYMODIFIABLE
        FROM FRAME_SECTION
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = ANTYPE
         AND REF_ID = ANITEMID
         AND DECODE( ANITEMREVISION,
                     NULL, 1,
                     REF_VER ) = NVL( ANITEMREVISION,
                                      1 )
         AND DECODE( ANITEMOWNER,
                     NULL, 1,
                     REF_OWNER ) = NVL( ANITEMOWNER,
                                        1 );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISITEMLOCALLYMODIFIABLE;

   
   FUNCTION ISEXTENDABLE(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
       
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsExtendable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNISEXTENDABLE                IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIFRAMESECTION.EXISTID( ASFRAMENO,
                                            ANREVISION,
                                            ANOWNER,
                                            ANSECTIONID,
                                            ANSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( -1 );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT DECODE( SC_EXT,
                     'Y', 1,
                     0 )
        INTO LNISEXTENDABLE
        FROM FRAME_SECTION
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND ROWNUM = 1;

      RETURN( LNISEXTENDABLE );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( -1 );
   END ISEXTENDABLE;
END IAPIFRAMESECTION;