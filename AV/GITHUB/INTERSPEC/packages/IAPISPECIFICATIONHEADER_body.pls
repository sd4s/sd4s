CREATE OR REPLACE PACKAGE BODY iapiSpecificationHeader
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION GETHEADERITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQHEADERITEMS              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetHeaderItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'null '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', null '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', null '
            || IAPICONSTANTCOLUMN.HEADERIDCOL
            || ', null '
            || IAPICONSTANTCOLUMN.ROWINDEXCOL
            || ', null '
            || IAPICONSTANTCOLUMN.PARENTROWINDEXCOL;
      LCSPHEADERITEMS               SPHEADERITEMDATATABLE_TYPE := SPHEADERITEMDATATABLE_TYPE( );
      LOSPHEADERITEM                SPHEADERITEMRECORD_TYPE;
      LROWINDEX                     NUMBER( 13 ) := 1;
      LPARENTROWINDEX               NUMBER( 13 ) := 0;
   BEGIN
      
      
      
      
      
      IF ( AQHEADERITEMS%ISOPEN )
      THEN
         CLOSE AQHEADERITEMS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM DUAL WHERE 1 = 2 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQHEADERITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Header',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LPARENTROWINDEX := LROWINDEX;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Main',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Details',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Keywords',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Classification',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ValidationRules',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ExtendableFrame',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ReasonForIssue',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'WhoHasToApprove',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Manufacturers',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ObjectImages',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Note',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWPRICEALLOWED = 1
      THEN
         LROWINDEX :=   LROWINDEX
                      + 1;
         LCSPHEADERITEMS.EXTEND;
         LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                    ANREVISION,
                                                    'Price',
                                                    LROWINDEX,
                                                    LPARENTROWINDEX );
         LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      END IF;

      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Plant',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'Journal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LPARENTROWINDEX := LROWINDEX;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'StatusJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ApprovalJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'EffectiveDateJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 1
      THEN
         LROWINDEX :=   LROWINDEX
                      + 1;
         LCSPHEADERITEMS.EXTEND;
         LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                    ANREVISION,
                                                    'BoMMRPJournal',
                                                    LROWINDEX,
                                                    LPARENTROWINDEX );
         LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      END IF;

      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'KeywordJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ClassificationJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'NoteJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ManufacturerJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'PlantJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'ObjectImagesJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;
      LROWINDEX :=   LROWINDEX
                   + 1;
      LCSPHEADERITEMS.EXTEND;
      LOSPHEADERITEM := SPHEADERITEMRECORD_TYPE( ASPARTNO,
                                                 ANREVISION,
                                                 'SpecificationJournal',
                                                 LROWINDEX,
                                                 LPARENTROWINDEX );
      LCSPHEADERITEMS( LROWINDEX ) := LOSPHEADERITEM;

      OPEN AQHEADERITEMS FOR
         SELECT   PARTNO,
                  REVISION,
                  NAME,
                  ROWINDEX,
                  PARENTROWINDEX
             FROM TABLE( CAST( LCSPHEADERITEMS AS SPHEADERITEMDATATABLE_TYPE ) )
         ORDER BY ROWINDEX;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETHEADERITEMS;

   
   























































   
   















































   
   
















































   


























































   FUNCTION GETSPECIFICATIONSINPROGRESS(
      AQSPECS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSpecificationsInProgress';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
                                                     :=    'part_no '
                                                        || IAPICONSTANTCOLUMN.PARTNOCOL
                                                        || ', revision '
                                                        || IAPICONSTANTCOLUMN.REVISIONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM specification_header ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' where tc_in_progress > 0 ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQSPECS%ISOPEN )
      THEN
         CLOSE AQSPECS;
      END IF;

      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;

      OPEN AQSPECS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSPECIFICATIONSINPROGRESS;
END IAPISPECIFICATIONHEADER;