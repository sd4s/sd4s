CREATE OR REPLACE PACKAGE BODY iapiUsers
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

   
   
   

   
   
   
   
   FUNCTION ISEXTERNAL(
      ASUSER                     IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsExternal';
      ANEXTERNAL                    IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT CASE
                WHEN PASSWORD = 'EXTERNAL'
                   THEN 1
                ELSE 0
             END
        INTO ANEXTERNAL
        FROM DBA_USERS
       WHERE USERNAME = ASUSER;

      RETURN( ANEXTERNAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN( NULL );
   END ISEXTERNAL;

   
   
   
   
   FUNCTION ISGLOBAL(
      ASUSER                     IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsGlobal';
      ANGLOBAL                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT CASE
                WHEN PASSWORD = 'GLOBAL'
                   THEN 1
                ELSE 0
             END
        INTO ANGLOBAL
        FROM DBA_USERS
       WHERE USERNAME = ASUSER;

      RETURN( ANGLOBAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN( NULL );
   END ISGLOBAL;

   
   FUNCTION ISDROPPED(
      ASUSER                     IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsDropped';
      LNDROPPED                     IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT CASE
                WHEN USER_DROPPED = 'Y'
                   THEN 1
                ELSE 0
             END
        INTO LNDROPPED
        FROM APPLICATION_USER
       WHERE USER_ID = ASUSER;

      RETURN( LNDROPPED );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN( NULL );
   END ISDROPPED;

   
   FUNCTION USERFOUND(
      ASUSER                     IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UserFound';
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM APPLICATION_USER
       WHERE USER_ID = ASUSER;

      IF LNCOUNT = 0
      THEN
         RETURN 0;
      ELSE
         RETURN 1;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END USERFOUND;

   
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
         || 'USER_ID '
         || IAPICONSTANTCOLUMN.USERIDCOL
         || ','
         || LSALIAS
         || 'FORENAME '
         || IAPICONSTANTCOLUMN.FORENAMECOL
         || ','
         || LSALIAS
         || 'LAST_NAME '
         || IAPICONSTANTCOLUMN.LASTNAMECOL
         || ','
         || LSALIAS
         || 'USER_INITIALS '
         || IAPICONSTANTCOLUMN.USERINITIALSCOL
         || ','
         || LSALIAS
         || 'TELEPHONE_NO '
         || IAPICONSTANTCOLUMN.TELEPHONENUMBERCOL
         || ','
         || LSALIAS
         || 'EMAIL_ADDRESS '
         || IAPICONSTANTCOLUMN.EMAILADDRESSCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'CURRENT_ONLY,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.CURRENTONLYACCESSCOL
         || ','
         || LSALIAS
         || 'INITIAL_PROFILE '
         || IAPICONSTANTCOLUMN.INITIALPROFILECOL
         || ','
         || LSALIAS
         || 'USER_PROFILE '
         || IAPICONSTANTCOLUMN.USERPROFILECOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'USER_DROPPED,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.USERDROPPEDCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'PROD_ACCESS,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.MRPPRODUCTIONACCESSCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'PLAN_ACCESS,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.MRPPLANNINGACCESSCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'PHASE_ACCESS,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.MRPPHASEACCESSCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'PRINTING_ALLOWED,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.PRINTINGALLOWEDCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'INTL,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.INTERNATIONALACCESSCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'REFERENCE_TEXT,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.OBJECTANDREFTEXTACCESSCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'APPROVED_ONLY,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.APPROVEDONLYACCESSCOL
         || ','
         || LSALIAS
         || 'LOC_ID '
         || IAPICONSTANTCOLUMN.LOCATIONIDCOL
         || ','
         || LSALIAS
         || 'CAT_ID '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'OVERRIDE_PART_VAL,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.CREATELOCALPARTALLOWEDCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'WEB_ALLOWED,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.WEBALLOWEDCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'LIMITED_CONFIGURATOR,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.LIMITEDCONFIGURATORCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'PLANT_ACCESS,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.PLANTACCESSCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'VIEW_BOM,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.VIEWBOMACCESSCOL
         || ','
         || LSALIAS
         || 'VIEW_PRICE '
         || IAPICONSTANTCOLUMN.VIEWPRICECOL
         || ','
         || LSALIAS
         || 'OPTIONAL_DATA '
         || IAPICONSTANTCOLUMN.SHOWOPTIONALDATACOL
         || ','
         || 'iapiUsers.IsExternal (User_ID) '
         || IAPICONSTANTCOLUMN.EXTERNALCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'HISTORIC_ONLY,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.HISTORICONLYACCESSCOL
         || ','
         || 'iapiUsers.IsGlobal (User_ID) '
         || IAPICONSTANTCOLUMN.GLOBALCOL
         || ','
         || 'DECODE('
         || LSALIAS
         || 'UNLOCKING_RIGHT,''Y'',1,0) '
         || IAPICONSTANTCOLUMN.UNLOCKINGRIGHTCOL;
      RETURN( LCBASECOLUMNS );
   END GETBASECOLUMNS;

   
   FUNCTION VALIDATEAPPLICATIONUSER(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ASFORENAME                 IN       IAPITYPE.FORENAME_TYPE,
      ASLASTNAME                 IN       IAPITYPE.LASTNAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateApplicationUser';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      IF    ( ASUSER IS NULL )
         OR ( LENGTH( TRIM( ASUSER ) ) = 0 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'User' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      
      
      IF    ( ASFORENAME IS NULL )
         OR ( LENGTH( TRIM( ASFORENAME ) ) = 0 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Forename' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asForeName ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      
      
      IF    ( ASLASTNAME IS NULL )
         OR ( LENGTH( TRIM( ASLASTNAME ) ) = 0 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Lastname' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLastName ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      
      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM DBA_ROLES
       WHERE ROLE = ASUSER;

      IF LNCOUNT = 0
      THEN
         NULL;
      ELSE
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_USERNAMEINVALID,
                                                         ASUSER );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
         RETURN IAPICONSTANTDBERROR.DBERR_USERNAMEINVALID;
      END IF;

      
      
      
      IF    ASUSER = 'VIEW_ONLY'
         OR ASUSER = 'LIMITED'
         OR ASUSER = 'APPROVER'
         OR ASUSER = 'FRAME_BUILDER'
         OR ASUSER = 'CONFIGURATOR'
         OR ASUSER = 'DEV_MGR'
         OR ASUSER = 'MRP'
         OR ASUSER = 'ACCESS'
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_USERNAMEINVALID,
                                                         ASUSER );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
         RETURN IAPICONSTANTDBERROR.DBERR_USERNAMEINVALID;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEAPPLICATIONUSER;

   

   
   FUNCTION FILLAPPLICATIONUSERRECORD(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ARUSERRECORD               OUT      APPLICATION_USER%ROWTYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FillApplicationUserRecord';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT USER_ID,
             FORENAME,
             LAST_NAME,
             USER_INITIALS,
             TELEPHONE_NO,
             EMAIL_ADDRESS,
             CURRENT_ONLY,
             INITIAL_PROFILE,
             USER_PROFILE,
             USER_DROPPED,
             PROD_ACCESS,
             PLAN_ACCESS,
             PHASE_ACCESS,
             PRINTING_ALLOWED,
             INTL,
             REFERENCE_TEXT,
             APPROVED_ONLY,
             LOC_ID,
             CAT_ID,
             OVERRIDE_PART_VAL,
             WEB_ALLOWED,
             LIMITED_CONFIGURATOR,
             PLANT_ACCESS,
             VIEW_BOM,
             VIEW_PRICE,
             OPTIONAL_DATA,
             HISTORIC_ONLY
        INTO ARUSERRECORD.USER_ID,
             ARUSERRECORD.FORENAME,
             ARUSERRECORD.LAST_NAME,
             ARUSERRECORD.USER_INITIALS,
             ARUSERRECORD.TELEPHONE_NO,
             ARUSERRECORD.EMAIL_ADDRESS,
             ARUSERRECORD.CURRENT_ONLY,
             ARUSERRECORD.INITIAL_PROFILE,
             ARUSERRECORD.USER_PROFILE,
             ARUSERRECORD.USER_DROPPED,
             ARUSERRECORD.PROD_ACCESS,
             ARUSERRECORD.PLAN_ACCESS,
             ARUSERRECORD.PHASE_ACCESS,
             ARUSERRECORD.PRINTING_ALLOWED,
             ARUSERRECORD.INTL,
             ARUSERRECORD.REFERENCE_TEXT,
             ARUSERRECORD.APPROVED_ONLY,
             ARUSERRECORD.LOC_ID,
             ARUSERRECORD.CAT_ID,
             ARUSERRECORD.OVERRIDE_PART_VAL,
             ARUSERRECORD.WEB_ALLOWED,
             ARUSERRECORD.LIMITED_CONFIGURATOR,
             ARUSERRECORD.PLANT_ACCESS,
             ARUSERRECORD.VIEW_BOM,
             ARUSERRECORD.VIEW_PRICE,
             ARUSERRECORD.OPTIONAL_DATA,
             ARUSERRECORD.HISTORIC_ONLY
        FROM APPLICATION_USER
       WHERE USER_ID = ASUSER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FILLAPPLICATIONUSERRECORD;

   
   
   
   FUNCTION GETUSERSDISTINGUISHEDNAME(
      ANDN                       OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
      
       
       
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsersDistinguishedName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PARAMETER_DATA
        INTO ANDN
        FROM INTERSPC_CFG
       WHERE SECTION = 'interspec'
         AND PARAMETER = 'UsersDN';

      IF ( ANDN IS NULL )
      THEN
         
         LNRETVAL :=
                   IAPIGENERAL.SETERRORTEXTANDLOGINFO( IAPIUSERS.GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_GLBAUTHENTICATIONNOTCONF,
                                                       'asGlobal' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asGlobal',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 IAPIUSERS.GTERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_GLBAUTHENTICATIONNOTCONF );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         
         LNRETVAL :=
                   IAPIGENERAL.SETERRORTEXTANDLOGINFO( IAPIUSERS.GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_GLBAUTHENTICATIONNOTCONF,
                                                       'asGlobal' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asGlobal',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 IAPIUSERS.GTERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_GLBAUTHENTICATIONNOTCONF );
      WHEN OTHERS
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERSDISTINGUISHEDNAME;

   
   
   
   
   FUNCTION ADDUSER(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ANEXTERNAL                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANGLOBAL                   IN       IAPITYPE.BOOLEAN_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUser';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIUSCURSOR                    PLS_INTEGER;
      LSSQLSTRING1                  VARCHAR2( 500 );
      LNCOUNT                       NUMBER;
      LSDN                          IAPITYPE.STRING_TYPE;
      LSTEMPTABLESPACE              IAPITYPE.STRING_TYPE;
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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'User' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF (     ANEXTERNAL = 1
           AND ANGLOBAL = 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_INCOMPATIBLEPARAMETERS,
                                                         ANGLOBAL,
                                                         ANEXTERNAL );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anGlobal/anExternal',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      
      
      

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM DBA_USERS
       WHERE USERNAME = ASUSER;

      IF LNCOUNT = 0
      THEN
         NULL;
      ELSE










         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQLSTRING1 :=    '" IDENTIFIED BY "'
                      || ASUSER
                      || '"';

      
      IF (     ANEXTERNAL = 1
           AND ANGLOBAL = 0 )
      THEN
         LSSQLSTRING1 := '" IDENTIFIED EXTERNALLY ';
      ELSIF(     ANEXTERNAL = 0
             AND ANGLOBAL = 1 )
      THEN
         LNRETVAL := GETUSERSDISTINGUISHEDNAME( LSDN );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        LNRETVAL ) );
         ELSE
            LSSQLSTRING1 :=    '" IDENTIFIED GLOBALLY AS '
                            || ''''
                            || 'cn='
                            || ASUSER
                            || ','
                            || LSDN
                            || '''';
         END IF;
      END IF;

      LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;






      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Create USER' );
      BEGIN
       SELECT PARAMETER_DATA
         INTO LSTEMPTABLESPACE
         FROM INTERSPC_CFG
        WHERE SECTION = 'interspec'
          AND PARAMETER = 'TEMP_TABLESPACE_NAME';
       EXCEPTION
           WHEN OTHERS
         THEN
           LSTEMPTABLESPACE := 'TEMP';
      END;

      GSSQLSTRING :=    'CREATE USER "'
                     || ASUSER
                     || LSSQLSTRING1
                     || ' DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE '
                     || LSTEMPTABLESPACE ;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           GSSQLSTRING,
                           IAPICONSTANT.INFOLEVEL_3 );
      DBMS_SQL.PARSE( LIUSCURSOR,
                      GSSQLSTRING,
                      DBMS_SQL.V7 );
      GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF DBMS_SQL.IS_OPEN( LIUSCURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDUSER;

   
   FUNCTION REMOVEUSER(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveUser';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIUSCURSOR                    INTEGER;
      LNCOUNT                       NUMBER;
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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         ASUSER );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      
      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM DBA_USERS
       WHERE USERNAME = ASUSER;

      IF LNCOUNT = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_USERNOTFOUND,
                                                         'User' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
         RETURN IAPICONSTANTDBERROR.DBERR_USERNOTFOUND;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;
      GSSQLSTRING :=    'DROP USER "'
                     || ASUSER
                     || '"';
      DBMS_SQL.PARSE( LIUSCURSOR,
                      GSSQLSTRING,
                      DBMS_SQL.V7 );
      GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
      DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEUSER;

   
   FUNCTION ADDAPPLICATIONUSER(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ASFORENAME                 IN       IAPITYPE.FORENAME_TYPE,
      ASLASTNAME                 IN       IAPITYPE.LASTNAME_TYPE,
      ASUSERINITIALS             IN       IAPITYPE.INITIALS_TYPE,
      ASTELEPHONE_NO             IN       IAPITYPE.TELEPHONE_TYPE,
      ASEMAILADDRESS             IN       IAPITYPE.EMAILADDRESS_TYPE,
      ANCURRENTONLY              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASINITIALPROFILE           IN       IAPITYPE.INITIALPROFILE_TYPE,
      ASUSERPROFILE              IN       IAPITYPE.USERPROFILE_TYPE,
      ANUSERDROPPED              IN       IAPITYPE.BOOLEAN_TYPE,
      ANPRODACCESS               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPLANACCESS               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPHASEACCESS              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPRINTINGALLOWED          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANINTL                     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANREFERENCETEXT            IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANAPPROVEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANLOCID                    IN       IAPITYPE.LOCID_TYPE,
      ANCATID                    IN       IAPITYPE.CATID_TYPE,
      ANOVERRIDEPARTVAL          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANWEBALLOWED               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANLIMITEDCONFIGURATOR      IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPLANTACCESS              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANVIEWBOM                  IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANVIEWPRICE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANOPTIONALDATA             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANEXTERNAL                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANGLOBAL                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANHISTORICONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUNLOCKINGRIGHT           IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddApplicationUser';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIUSCURSOR                    PLS_INTEGER;
      LSPROFILE                     IAPITYPE.STRING_TYPE;
      LSSQLSTRING1                  VARCHAR2( 200 );
      LSACTION                      VARCHAR2( 20 );
      LROLDRECORD                   APPLICATION_USER%ROWTYPE;
      LRNEWRECORD                   APPLICATION_USER%ROWTYPE;


      CURSOR L_UNILAB_ROLES_CURSOR IS
          SELECT GRANTED_ROLE FROM SYS.DBA_ROLE_PRIVS 
					 WHERE GRANTEE = ASUSER
             AND (GRANTED_ROLE LIKE 'UNILAB%' OR GRANTED_ROLE LIKE 'UR%');
      L_SQL_STRING VARCHAR2(2000);			

			
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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := VALIDATEAPPLICATIONUSER( ASUSER,
                                           ASFORENAME,
                                           ASLASTNAME );

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      
      
      IF USERFOUND( ASUSER ) = 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_USERALREADYEXIST,
                                                     ASUSER ) );
      END IF;

      
      
      


      L_SQL_STRING := ASINITIALPROFILE;
      FOR L_UNILAB_ROLES_REC IN L_UNILAB_ROLES_CURSOR LOOP
        IF NVL(L_UNILAB_ROLES_REC.GRANTED_ROLE, '*') <> '*' THEN
					L_SQL_STRING := L_SQL_STRING
                       || ', '
											 || L_UNILAB_ROLES_REC.GRANTED_ROLE;
        END IF;
      END LOOP;

 
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQLSTRING1 :=    '" IDENTIFIED BY "'
                      || ASUSER
                      || '"';

      
      
      IF ( ANUSERDROPPED = 0 )
      THEN
         LNRETVAL := IAPIUSERS.ADDUSER( ASUSER,
                                        ANEXTERNAL,
                                        ANGLOBAL,
                                        AQERRORS );

         
         IF ( GTERRORS.COUNT > 0 )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;

         
         BEGIN
            SELECT PARAMETER_DATA
              INTO LSPROFILE
              FROM INTERSPC_CFG
             WHERE SECTION = 'interspec'
               AND PARAMETER = 'user_profile';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LSPROFILE := NULL;
         END;

         LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;



         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Grant USER' );
         GSSQLSTRING :=    'GRANT '
                        || ASINITIALPROFILE 
                        || ' TO "'
                        || ASUSER
                        || '"';
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );



         GSSQLSTRING :=    'GRANT '
                        || ASUSERPROFILE
                        || ' TO "'
                        || ASUSER
                        || '"';
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );



         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Alter USER' );
         GSSQLSTRING :=    'ALTER USER "'
                        || ASUSER
                        || '" DEFAULT ROLE '



                        || L_SQL_STRING; 

         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );




         IF NOT LSPROFILE IS NULL
         THEN
            GSSQLSTRING :=    'ALTER USER "'
                           || ASUSER
                           || '" PROFILE '
                           || LSPROFILE;
            DBMS_SQL.PARSE( LIUSCURSOR,
                            GSSQLSTRING,
                            DBMS_SQL.V7 );
            GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
         END IF;

         DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
      END IF;

      INSERT INTO APPLICATION_USER
                  ( USER_ID,
                    FORENAME,
                    LAST_NAME,
                    USER_INITIALS,
                    TELEPHONE_NO,
                    EMAIL_ADDRESS,
                    CURRENT_ONLY,
                    INITIAL_PROFILE,
                    USER_PROFILE,
                    USER_DROPPED,
                    PROD_ACCESS,
                    PLAN_ACCESS,
                    PHASE_ACCESS,
                    PRINTING_ALLOWED,
                    INTL,
                    REFERENCE_TEXT,
                    APPROVED_ONLY,
                    LOC_ID,
                    CAT_ID,
                    OVERRIDE_PART_VAL,
                    WEB_ALLOWED,
                    LIMITED_CONFIGURATOR,
                    PLANT_ACCESS,
                    VIEW_BOM,
                    VIEW_PRICE,
                    OPTIONAL_DATA,
                    HISTORIC_ONLY,
                    UNLOCKING_RIGHT  )
           VALUES ( ASUSER,
                    ASFORENAME,
                    ASLASTNAME,
                    ASUSERINITIALS,
                    ASTELEPHONE_NO,
                    ASEMAILADDRESS,
                    CASE
                       WHEN ANCURRENTONLY = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    ASINITIALPROFILE,
                    ASUSERPROFILE,
                    CASE
                       WHEN ANUSERDROPPED = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANPRODACCESS = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANPLANACCESS = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANPHASEACCESS = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANPRINTINGALLOWED = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANINTL = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANREFERENCETEXT = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANAPPROVEDONLY = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    ANLOCID,
                    ANCATID,
                    CASE
                       WHEN ANOVERRIDEPARTVAL = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANWEBALLOWED = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANLIMITEDCONFIGURATOR = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANPLANTACCESS = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANVIEWBOM = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    ANVIEWPRICE,
                    ANOPTIONALDATA,
                    CASE
                       WHEN ANHISTORICONLY = 1
                          THEN 'Y'
                       ELSE 'N'
                    END,
                    CASE
                       WHEN ANUNLOCKINGRIGHT = 1
                          THEN 'Y'
                       ELSE 'N'
                    END );

      LSACTION := 'INSERTING';
      
      LNRETVAL := FILLAPPLICATIONUSERRECORD( ASUSER,
                                             LRNEWRECORD );

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      BEGIN
         INSERT INTO ITUS
                     ( USER_ID,
                       FORENAME,
                       LAST_NAME,
                       CREATED_ON,
                       DELETED_ON )
            SELECT USER_ID,
                   FORENAME,
                   LAST_NAME,
                   SYSDATE,
                   NULL
              FROM APPLICATION_USER
             WHERE USER_ID = ASUSER;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      


      LNRETVAL := IAPIUSERPREFERENCES.INITUSERPREFERENCES( ASUSER );
      LNRETVAL := IAPIAUDITTRAIL.ADDUSERHISTORY( LSACTION,
                                                 LROLDRECORD,
                                                 LRNEWRECORD );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDAPPLICATIONUSER;

   
   FUNCTION SAVEAPPLICATIONUSER(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ASFORENAME                 IN       IAPITYPE.FORENAME_TYPE,
      ASLASTNAME                 IN       IAPITYPE.LASTNAME_TYPE,
      ASUSERINITIALS             IN       IAPITYPE.INITIALS_TYPE,
      ASTELEPHONE_NO             IN       IAPITYPE.TELEPHONE_TYPE,
      ASEMAILADDRESS             IN       IAPITYPE.EMAILADDRESS_TYPE,
      ANCURRENTONLY              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASINITIALPROFILE           IN       IAPITYPE.INITIALPROFILE_TYPE,
      ASUSERPROFILE              IN       IAPITYPE.USERPROFILE_TYPE,
      ANUSERDROPPED              IN       IAPITYPE.BOOLEAN_TYPE,
      ANPRODACCESS               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPLANACCESS               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPHASEACCESS              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPRINTINGALLOWED          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANINTL                     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANREFERENCETEXT            IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANAPPROVEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANLOCID                    IN       IAPITYPE.LOCID_TYPE,
      ANCATID                    IN       IAPITYPE.CATID_TYPE,
      ANOVERRIDEPARTVAL          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANWEBALLOWED               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANLIMITEDCONFIGURATOR      IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANPLANTACCESS              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANVIEWBOM                  IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANVIEWPRICE                IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANOPTIONALDATA             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANEXTERNAL                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANGLOBAL                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANHISTORICONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUNLOCKINGRIGHT           IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveApplicationUser';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIUSCURSOR                    PLS_INTEGER;
      LSPROFILE                     INTERSPC_CFG.PARAMETER_DATA%TYPE;
      LSACTION                      VARCHAR2( 20 );
      LROLDRECORD                   APPLICATION_USER%ROWTYPE;
      LRNEWRECORD                   APPLICATION_USER%ROWTYPE;
      LNREMOVED                     IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE DEFAULT 0;
      LNCOUNT1                      IAPITYPE.NUMVAL_TYPE DEFAULT 0;
      LNDN                          IAPITYPE.STRING_TYPE;

      
      CURSOR C_GRANTED_ROLE(
        ASUSER                              APPLICATION_USER.USER_ID%TYPE )
      IS
        SELECT GRANTED_ROLE
          FROM DBA_ROLE_PRIVS
        
        
        WHERE GRANTEE = ASUSER  
          
          AND GRANTED_ROLE NOT IN ('UNILABUSER','URAPI','UR1','UR2','UR3','UR4','UR5','UR6','UR7','UR8','UR9',
                                   'UR10','UR11','UR12','UR13','UR14','UR15','UR16','UR17','UR18','UR19','UR20','UR21',
                                   'UR22','UR23','UR24','UR25','UR26','UR27','UR28','UR29','UR30','UR31','UR32','UR33',
                                   'UR34','UR35','UR36','UR37','UR38','UR39','UR40','UR41','UR42','UR43','UR44','UR45',
                                   'UR46','UR47','UR48','UR49','UR50','UR51','UR52','UR53','UR54','UR55','UR56','UR57',
                                   'UR58','UR59','UR60','UR61','UR62','UR63','UR64','UR65','UR66','UR67','UR68','UR69',
                                   'UR70','UR71','UR72','UR73','UR74','UR75','UR76','UR77','UR78','UR79','UR80','UR81',
                                   'UR82','UR83','UR84','UR85','UR86','UR87','UR88','UR89','UR90','UR91','UR92','UR93',
                                   'UR94','UR95','UR96','UR97','UR98','UR99','UR100','UR101','UR102','UR103','UR104','UR105',
                                   'UR106','UR107','UR108','UR109','UR110','UR111','UR112','UR113','UR114','UR115','UR116',
                                   'UR117','UR118','UR119','UR120','UR121','UR122','UR123','UR124','UR125','UR126','UR127','UR128');        
      
      



      CURSOR L_UNILAB_ROLES_CURSOR IS
          SELECT GRANTED_ROLE FROM SYS.DBA_ROLE_PRIVS 
					 WHERE GRANTEE = ASUSER
             
             
             AND GRANTED_ROLE IN ('UNILABUSER','URAPI','UR1','UR2','UR3','UR4','UR5','UR6','UR7','UR8','UR9',
                                   'UR10','UR11','UR12','UR13','UR14','UR15','UR16','UR17','UR18','UR19','UR20','UR21',
                                   'UR22','UR23','UR24','UR25','UR26','UR27','UR28','UR29','UR30','UR31','UR32','UR33',
                                   'UR34','UR35','UR36','UR37','UR38','UR39','UR40','UR41','UR42','UR43','UR44','UR45',
                                   'UR46','UR47','UR48','UR49','UR50','UR51','UR52','UR53','UR54','UR55','UR56','UR57',
                                   'UR58','UR59','UR60','UR61','UR62','UR63','UR64','UR65','UR66','UR67','UR68','UR69',
                                   'UR70','UR71','UR72','UR73','UR74','UR75','UR76','UR77','UR78','UR79','UR80','UR81',
                                   'UR82','UR83','UR84','UR85','UR86','UR87','UR88','UR89','UR90','UR91','UR92','UR93',
                                   'UR94','UR95','UR96','UR97','UR98','UR99','UR100','UR101','UR102','UR103','UR104','UR105',
                                   'UR106','UR107','UR108','UR109','UR110','UR111','UR112','UR113','UR114','UR115','UR116',
                                   'UR117','UR118','UR119','UR120','UR121','UR122','UR123','UR124','UR125','UR126','UR127','UR128');
            
             
      L_SQL_STRING VARCHAR2(2000);			


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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF (     ANGLOBAL = 1
           AND ANEXTERNAL = 0 )
      THEN
         LNRETVAL := GETUSERSDISTINGUISHEDNAME( LNDN );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IF ( IAPIUSERS.GTERRORS.COUNT > 0 )
            THEN
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( IAPIUSERS.GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         END IF;
      END IF;

      
      IF ( ANUSERDROPPED = 1 )
      THEN
         NULL;
      ELSE
         LNRETVAL := VALIDATEAPPLICATIONUSER( ASUSER,
                                              ASFORENAME,
                                              ASLASTNAME );

         
         IF ( GTERRORS.COUNT > 0 )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;

      
      
      IF USERFOUND( ASUSER ) <> 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_USERNOTFOUND,
                                                     ASUSER ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );



      L_SQL_STRING := ASINITIALPROFILE;
      FOR L_UNILAB_ROLES_REC IN L_UNILAB_ROLES_CURSOR LOOP
        IF NVL(L_UNILAB_ROLES_REC.GRANTED_ROLE, '*') <> '*' THEN
					L_SQL_STRING := L_SQL_STRING
                       || ', '
											 || L_UNILAB_ROLES_REC.GRANTED_ROLE;
        END IF;
      END LOOP;


      IF ( ANUSERDROPPED = 1 )
      THEN
         IF ( ISDROPPED( ASUSER ) <> ANUSERDROPPED )
         THEN
            IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = ASUSER
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_USERCURRENTUNDELETABLE,
                                                               'User' );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );
            ELSE
               LNRETVAL := REMOVEUSER( ASUSER,
                                       AQERRORS );
            END IF;

            IF ( GTERRORS.COUNT > 0 )
            THEN
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         END IF;

         LNREMOVED := 1;
      ELSE
         IF ( ISDROPPED( ASUSER ) <> ANUSERDROPPED )
         THEN
            
            
            LNRETVAL := IAPIUSERS.ADDUSER( ASUSER,
                                           ANEXTERNAL,
                                           ANGLOBAL,
                                           AQERRORS );

            
            IF ( GTERRORS.COUNT > 0 )
            THEN
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      IF LNREMOVED = 0
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM APPLICATION_USER
          WHERE USER_ID = ASUSER;

         SELECT COUNT( * )
           INTO LNCOUNT1
           FROM DBA_USERS
          WHERE USERNAME = ASUSER;

         IF (     LNCOUNT > 0
              AND LNCOUNT1 = 0 )
         THEN
            
            
            LNRETVAL := IAPIUSERS.ADDUSER( ASUSER,
                                           ANEXTERNAL,
                                           ANGLOBAL,
                                           AQERRORS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                           ASUSER ) );
            END IF;
         END IF;
      END IF;

      IF     (     ( ISEXTERNAL( ASUSER ) <> ANEXTERNAL )
               OR ( ISGLOBAL( ASUSER ) <> ANGLOBAL ) )
         AND LNREMOVED = 0
      THEN
         
         
         IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = ASUSER
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_USERCURRENTUNDELETABLE,
                                                            'User' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         ELSE
            LNRETVAL := REMOVEUSER( ASUSER,
                                    AQERRORS );
         END IF;

         IF ( GTERRORS.COUNT > 0 )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;

         
         
         LNRETVAL := IAPIUSERS.ADDUSER( ASUSER,
                                        ANEXTERNAL,
                                        ANGLOBAL,
                                        AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                        ASUSER ) );
         END IF;
      END IF;

      IF LNREMOVED = 0
      THEN
         
         BEGIN
            SELECT PARAMETER_DATA
              INTO LSPROFILE
              FROM INTERSPC_CFG
             WHERE SECTION = 'interspec'
               AND PARAMETER = 'user_profile';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LSPROFILE := NULL;
         END;

         LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;

         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Remove old grants from USER' );

         FOR L_ROW IN C_GRANTED_ROLE( ASUSER )
         LOOP
             GSSQLSTRING :=    'REVOKE '
                            || L_ROW.GRANTED_ROLE
                            || ' FROM "'
                            ||  ASUSER
                            || '"';
             DBMS_SQL.PARSE( LIUSCURSOR,
                             GSSQLSTRING,
                             DBMS_SQL.V7 );
             GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
         END LOOP;
        




         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Grant USER' );
         GSSQLSTRING :=    'GRANT '
                        || ASINITIALPROFILE
                        || ' TO "'
                        || ASUSER
                        || '"';
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );



         GSSQLSTRING :=    'GRANT '
                        || ASUSERPROFILE
                        || ' TO "'
                        || ASUSER
                        || '"';
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );



         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Alter USER' );
         GSSQLSTRING :=    'ALTER USER "'
                        || ASUSER
                        || '" DEFAULT ROLE '



                        || L_SQL_STRING; 

         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );




         IF NOT LSPROFILE IS NULL
         THEN
            GSSQLSTRING :=    'ALTER USER "'
                           || ASUSER
                           || '" PROFILE '
                           || LSPROFILE;
            DBMS_SQL.PARSE( LIUSCURSOR,
                            GSSQLSTRING,
                            DBMS_SQL.V7 );
            GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
         END IF;

         DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
      END IF;

      LSACTION := 'UPDATING';
      
      LNRETVAL := FILLAPPLICATIONUSERRECORD( ASUSER,
                                             LROLDRECORD );

      UPDATE APPLICATION_USER
         SET FORENAME = ASFORENAME,
             LAST_NAME = ASLASTNAME,
             USER_INITIALS = ASUSERINITIALS,
             TELEPHONE_NO = ASTELEPHONE_NO,
             EMAIL_ADDRESS = ASEMAILADDRESS,
             CURRENT_ONLY = CASE
                              WHEN ANCURRENTONLY = 1
                                 THEN 'Y'
                              ELSE 'N'
                           END,
             INITIAL_PROFILE = ASINITIALPROFILE,
             USER_PROFILE = ASUSERPROFILE,
             USER_DROPPED = CASE
                              WHEN ANUSERDROPPED = 1
                                 THEN 'Y'
                              ELSE 'N'
                           END,
             PROD_ACCESS = CASE
                             WHEN ANPRODACCESS = 1
                                THEN 'Y'
                             ELSE 'N'
                          END,
             PLAN_ACCESS = CASE
                             WHEN ANPLANACCESS = 1
                                THEN 'Y'
                             ELSE 'N'
                          END,
             PHASE_ACCESS = CASE
                              WHEN ANPHASEACCESS = 1
                                 THEN 'Y'
                              ELSE 'N'
                           END,
             PRINTING_ALLOWED = CASE
                                  WHEN ANPRINTINGALLOWED = 1
                                     THEN 'Y'
                                  ELSE 'N'
                               END,
             INTL = CASE
                      WHEN ANINTL = 1
                         THEN 'Y'
                      ELSE 'N'
                   END,
             REFERENCE_TEXT = CASE
                                WHEN ANREFERENCETEXT = 1
                                   THEN 'Y'
                                ELSE 'N'
                             END,
             APPROVED_ONLY = CASE
                               WHEN ANAPPROVEDONLY = 1
                                  THEN 'Y'
                               ELSE 'N'
                            END,
             LOC_ID = ANLOCID,
             CAT_ID = ANCATID,
             OVERRIDE_PART_VAL = CASE
                                   WHEN ANOVERRIDEPARTVAL = 1
                                      THEN 'Y'
                                   ELSE 'N'
                                END,
             WEB_ALLOWED = CASE
                             WHEN ANWEBALLOWED = 1
                                THEN 'Y'
                             ELSE 'N'
                          END,
             LIMITED_CONFIGURATOR = CASE
                                      WHEN ANLIMITEDCONFIGURATOR = 1
                                         THEN 'Y'
                                      ELSE 'N'
                                   END,
             PLANT_ACCESS = CASE
                              WHEN ANPLANTACCESS = 1
                                 THEN 'Y'
                              ELSE 'N'
                           END,
             VIEW_BOM = CASE
                          WHEN ANVIEWBOM = 1
                             THEN 'Y'
                          ELSE 'N'
                       END,
             VIEW_PRICE = ANVIEWPRICE,
             OPTIONAL_DATA = ANOPTIONALDATA,
             HISTORIC_ONLY = CASE
                               WHEN ANHISTORICONLY = 1
                                  THEN 'Y'
                               ELSE 'N'
                            END,
             UNLOCKING_RIGHT = CASE
                                 WHEN ANUNLOCKINGRIGHT = 1
                                   THEN 'Y'
                                 ELSE 'N'
                               END
       WHERE USER_ID = ASUSER;

      
      LNRETVAL := FILLAPPLICATIONUSERRECORD( ASUSER,
                                             LRNEWRECORD );

      BEGIN
         UPDATE ITUS
            SET FORENAME = ASFORENAME,
                LAST_NAME = ASLASTNAME
          WHERE USER_ID = ASUSER;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      IF ANPLANTACCESS = 0
      THEN
         BEGIN
            DELETE      ITUP
                  WHERE USER_ID = ASUSER;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;

      


      LNRETVAL := IAPIUSERPREFERENCES.INITUSERPREFERENCES( ASUSER );
      LNRETVAL := IAPIAUDITTRAIL.ADDUSERHISTORY( LSACTION,
                                                 LROLDRECORD,
                                                 LRNEWRECORD );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEAPPLICATIONUSER;

   
   FUNCTION REMOVEAPPLICATIONUSER(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveApplicationUser';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIUSCURSOR                    INTEGER;
      LSACTION                      VARCHAR2( 20 );
      LROLDRECORD                   APPLICATION_USER%ROWTYPE;
      LRNEWRECORD                   APPLICATION_USER%ROWTYPE;
      LNCOUNT                       NUMBER;
      
      LNCOUNTUSER                   NUMBER ;
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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'User' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      ELSIF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = ASUSER
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_USERCURRENTUNDELETABLE,
                                                         'User' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      
      
      IF USERFOUND( ASUSER ) <> 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_USERNOTFOUND,
                                                     ASUSER ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( IAPIGENERAL.SESSION.DATABASE.CONFIGURATION.FDA21CFR11 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_USER21CFR11UNDELETABLE,
                                                     ASUSER ) );
      END IF;

        
        SELECT COUNT(USERNAME)
        INTO LNCOUNTUSER
        FROM V$SESSION 
        WHERE TYPE='USER' 
        AND PROGRAM IN ('interspc.exe','interfrm.exe','intercfg.exe') 
        AND USERNAME = ASUSER;        
        
        IF (LNCOUNTUSER > 0)
        THEN 
            RETURN (IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DELACTIVEUSER,
                                                     ASUSER ) );
        END IF;
        
        
      
      LNRETVAL := IAPIAUDITTRAIL.SETUSERINFOHISTORY;

      
      DELETE      ITSHQ
            WHERE USER_ID = ASUSER;

      DELETE      ITCMPPARTS
            WHERE USER_ID = ASUSER;

      
      LNRETVAL := IAPIUSERPREFERENCES.REMOVEUSERPREFERENCES( ASUSER );
      
      
      LSACTION := 'DELETING';
      
      LNRETVAL := FILLAPPLICATIONUSERRECORD( ASUSER,
                                             LROLDRECORD );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM USER_GROUP_LIST
       WHERE USER_ID = ASUSER;

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_USERINUSERGROUPS,
                                                     ASUSER ) );
      END IF;

      DELETE FROM APPLICATION_USER
            WHERE USER_ID = ASUSER;

      
      
      LNRETVAL := IAPIUSERS.REMOVEUSER( ASUSER,
                                        AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                     ASUSER ) );
      END IF;

      LNRETVAL := IAPIAUDITTRAIL.ADDUSERHISTORY( LSACTION,
                                                 LROLDRECORD,
                                                 LRNEWRECORD );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEAPPLICATIONUSER;

   
   FUNCTION EXISTID(
      ASUSER                     IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'User' );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF USERFOUND( ASUSER ) = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_USERNOTFOUND,
                                                         ASUSER );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
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

   
   FUNCTION GETAPPLICATIONUSER(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      AQUSER                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetApplicationUser';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'au' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'application_user au';
   BEGIN
      
      
      
      
      
      IF ( AQUSER%ISOPEN )
      THEN
         CLOSE AQUSER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE au.user_id is null';

      OPEN AQUSER FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_ISMANDATORY );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQUSER%ISOPEN )
      THEN
         CLOSE AQUSER;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE au.user_id = '''
               || ASUSER
               || '''';

      
      OPEN AQUSER FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETAPPLICATIONUSER;

   
   FUNCTION GETAPPLICATIONUSERS(
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      AQUSER                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetApplicationUsers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'ap' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'application_user ap';
      LSLEFTOPERAND                 IAPITYPE.STRING_TYPE;
      LSOPERATOR                    IAPITYPE.STRING_TYPE;
      LSRIGHTOPERAND                IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQUSER%ISOPEN )
      THEN
         CLOSE AQUSER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE ap.user_id = null';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQUSER FOR LSSQLNULL;

      
      
      
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
            WHEN IAPICONSTANTCOLUMN.USERIDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.user_id';
            WHEN IAPICONSTANTCOLUMN.FORENAMECOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.forename';
            WHEN IAPICONSTANTCOLUMN.LASTNAMECOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.last_name';
            WHEN IAPICONSTANTCOLUMN.USERINITIALSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.user_initials';
            WHEN IAPICONSTANTCOLUMN.TELEPHONENUMBERCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.telephone_no';
            WHEN IAPICONSTANTCOLUMN.EMAILADDRESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.email_address';
            WHEN IAPICONSTANTCOLUMN.CURRENTONLYACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.current_only';
            WHEN IAPICONSTANTCOLUMN.INITIALPROFILECOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.initial_profile';
            WHEN IAPICONSTANTCOLUMN.USERPROFILECOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.user_profile';
            WHEN IAPICONSTANTCOLUMN.USERDROPPEDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.user_dropped';
            WHEN IAPICONSTANTCOLUMN.MRPPRODUCTIONACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.prod_access';
            WHEN IAPICONSTANTCOLUMN.MRPPLANNINGACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.plan_access';
            WHEN IAPICONSTANTCOLUMN.MRPPHASEACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.phase_access';
            WHEN IAPICONSTANTCOLUMN.PRINTINGALLOWEDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.printing_allowed';
            WHEN IAPICONSTANTCOLUMN.INTERNATIONALACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.intl';
            WHEN IAPICONSTANTCOLUMN.OBJECTANDREFTEXTACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.reference_text';
            WHEN IAPICONSTANTCOLUMN.APPROVEDONLYACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.approved_only';
            WHEN IAPICONSTANTCOLUMN.LOCATIONIDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.loc_id';
            WHEN IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.cat_id';
            WHEN IAPICONSTANTCOLUMN.CREATELOCALPARTALLOWEDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.override_part_val';
            WHEN IAPICONSTANTCOLUMN.WEBALLOWEDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.web_allowed';
            WHEN IAPICONSTANTCOLUMN.LIMITEDCONFIGURATORCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.limited_configurator';
            WHEN IAPICONSTANTCOLUMN.PLANTACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.plant_access';
            WHEN IAPICONSTANTCOLUMN.VIEWBOMACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.view_bom';
            WHEN IAPICONSTANTCOLUMN.VIEWPRICECOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.view_price';
            WHEN IAPICONSTANTCOLUMN.SHOWOPTIONALDATACOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.optional_data';
            WHEN IAPICONSTANTCOLUMN.HISTORICONLYACCESSCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.historic_only';
            WHEN IAPICONSTANTCOLUMN.UNLOCKINGRIGHTCOL
            THEN
               LRFILTER.LEFTOPERAND := 'ap.unlocking_right';
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
      LSSQL :=    LSSQL
               || ' WHERE  1=1 ';

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY UPPER(USER_ID) ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQUSER%ISOPEN )
      THEN
         CLOSE AQUSER;
      END IF;

      
      OPEN AQUSER FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETAPPLICATIONUSERS;

   
   FUNCTION GETAPPLICATIONUSERS(
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AQUSER                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetApplicationUsers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'ap' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'application_user ap';
   BEGIN
      
      
      
      
      
      IF ( AQUSER%ISOPEN )
      THEN
         CLOSE AQUSER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE ap.user_id = null';

      OPEN AQUSER FOR LSSQLNULL;

      
      
      
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

      LNRETVAL := IAPIUSERS.GETAPPLICATIONUSERS( LTDEFAULTFILTER,
                                                 AQUSER );

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
   END GETAPPLICATIONUSERS;

   
   FUNCTION GETAPPLICATIONUSERSPB(
      AXDEFAULTFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      AQUSER                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetApplicationUsersPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXDEFAULTFILTER               IAPITYPE.XMLTYPE_TYPE;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'ap' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'application_user ap';
   BEGIN
      
      
      
      
      
      IF ( AQUSER%ISOPEN )
      THEN
         CLOSE AQUSER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE ap.user_id = null';

      OPEN AQUSER FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXDEFAULTFILTER := XMLTYPE( AXDEFAULTFILTER );
      LNRETVAL := IAPIUSERS.GETAPPLICATIONUSERS( LXDEFAULTFILTER,
                                                 AQUSER );

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
   END GETAPPLICATIONUSERSPB;

   
   FUNCTION REMOVEFROMUSERGROUPS(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFromUserGroup';
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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'User' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      
      IF USERFOUND( ASUSER ) <> 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_USERNOTFOUND,
                                                     ASUSER ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM USER_GROUP_LIST
            WHERE USER_ID = ASUSER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEFROMUSERGROUPS;

   
   FUNCTION GENERATEPASSWORD(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      LDDATE                     IN       IAPITYPE.DATE_TYPE,
      ASPASSWORD                 OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LNIND                         IAPITYPE.NUMVAL_TYPE := 0;
      LNIND1                        IAPITYPE.NUMVAL_TYPE := 0;
      LNIND2                        IAPITYPE.NUMVAL_TYPE;
      LSSTRING                      IAPITYPE.DESCRIPTION_TYPE;
      LSRESULT                      IAPITYPE.DESCRIPTION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GeneratePassword';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                    'User' );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSTRING :=    SUBSTR( ASUSER,
                             1,
                             4 )
                  || TO_CHAR( LDDATE,
                              'SSSS' );

      FOR LNIND IN 1 .. LEAST( LENGTH( LSSTRING ),
                               8 )
      LOOP
         LNIND1 := MOD(   LNIND1
                        + ASCII( SUBSTR( LSSTRING,
                                         LNIND,
                                         1 ) ),
                        256 );
         LNIND2 :=   MOD( BITAND( LNIND1,
                                  ASCII( SUBSTR( LSSTRING,
                                                 LNIND,
                                                 1 ) ) ),
                          74 )
                   + 48;

         IF LNIND2 BETWEEN 58 AND 64
         THEN
            LNIND2 :=   LNIND2
                      + 7;
         ELSIF LNIND2 BETWEEN 91 AND 96
         THEN
            LNIND2 :=   LNIND2
                      + 6;
         END IF;

         LSRESULT :=    LSRESULT
                     || CHR( LNIND2 );
      END LOOP;

      LSRESULT := REPLACE( LSRESULT,
                           '1',
                           '2' );
      LSRESULT := REPLACE( LSRESULT,
                           'l',
                           'L' );
      LSRESULT := REPLACE( LSRESULT,
                           '0',
                           '9' );
      LSRESULT := REPLACE( LSRESULT,
                           'O',
                           'P' );
      LSRESULT :=    'A'
                  || SUBSTR( LSRESULT,
                             2 );
      ASPASSWORD := LSRESULT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GENERATEPASSWORD;

   
   FUNCTION CHECKPASSWORD(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ASPASSWORD                 IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckPassword';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );


      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                    'User' );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IF ASUSER = LSSCHEMANAME
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_USERNOTALLOWEDMODPWD );
      END IF;

      
      IF    UPPER( SUBSTR( ASPASSWORD,
                           1,
                           1 ) ) < 'A'
         OR UPPER( SUBSTR( ASPASSWORD,
                           1,
                           1 ) ) > 'Z'
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PWDFIRSTCHARISNUM,
                                                    'User' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKPASSWORD;

   
   FUNCTION SAVEPASSWORD(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ASPASSWORD                 IN       IAPITYPE.STRINGVAL_TYPE DEFAULT NULL,
      ANSENTEMAIL                IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0,
      ANEXPIRE                   IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SavePassword';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIUSCURSOR                    PLS_INTEGER;
      LSPROFILE                     IAPITYPE.STRING_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LSPASSWORD                    IAPITYPE.PASSWORD_TYPE;
      LNSQLFUNCTIONCODE             IAPITYPE.NUMVAL_TYPE;
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
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ASPASSWORD IS NULL
      THEN
         LNRETVAL := GENERATEPASSWORD( ASUSER,
                                       SYSDATE,
                                       LSPASSWORD );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
      ELSE
         LSPASSWORD := ASPASSWORD;
      END IF;




















      
      BEGIN
         SELECT PROFILE
           INTO LSPROFILE
           FROM DBA_USERS
          WHERE USERNAME = ASUSER;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_USERNOTACTIVE,
                                                       ASUSER );
      END;

      IF ASUSER = LSPASSWORD
      THEN
         LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;
         GSSQLSTRING :=    'ALTER USER "'
                        || ASUSER
                        || '" PROFILE DEFAULT';
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
         DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
      END IF;


      BEGIN
   

   
   
   EXECUTE IMMEDIATE 'ALTER USER "'||ASUSER ||'" IDENTIFIED BY "'|| LSPASSWORD || '"';
   
  















      
      

      EXCEPTION
         WHEN OTHERS
         THEN
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPassword',
                                                    SQLERRM,
                                                    GTERRORS );

      END;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;


      IF ASUSER = LSPASSWORD
      THEN
         LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;
         GSSQLSTRING :=    'ALTER USER "'
                        || ASUSER
                        || '" PROFILE '
                        || LSPROFILE;
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
         DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
      END IF;


      IF ANEXPIRE = 1
      THEN
         LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;
         GSSQLSTRING :=    'ALTER USER "'
                        || ASUSER
                        || '" PASSWORD EXPIRE ';
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
         DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
      END IF;


      IF ANSENTEMAIL = 1
      THEN
         LNRETVAL := IAPIEMAIL.REGISTEREMAIL( NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              'P',
                                              ASUSER,
                                              LSPASSWORD,
                                              AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;

         COMMIT;

      END IF;

      IAPIGENERAL.LOGWARNING( GSSOURCE,
                              LSMETHOD,
                                 'PASSWORD of user <'
                              || ASUSER
                              || '> has been changed' );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE IN( -28007 )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_PWDNOTREUSABLE ) );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
   END SAVEPASSWORD;

   
   FUNCTION SAVEPROFILE(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ASINITIALPROFILE           IN       IAPITYPE.INITIALPROFILE_TYPE,
      ASUSERPROFILE              IN       IAPITYPE.INITIALPROFILE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveProfile';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR C_GRANTED_ROLE(
         ASUSER                              APPLICATION_USER.USER_ID%TYPE )
      IS
         SELECT GRANTED_ROLE
           FROM DBA_ROLE_PRIVS
          WHERE GRANTEE = ASUSER;



      CURSOR L_UNILAB_ROLES_CURSOR IS
          SELECT GRANTED_ROLE FROM SYS.DBA_ROLE_PRIVS 
					 WHERE GRANTEE = ASUSER
             AND (GRANTED_ROLE LIKE 'UNILAB%' OR GRANTED_ROLE LIKE 'UR%');
      L_SQL_STRING VARCHAR2(2000);			


      LIUSCURSOR                    PLS_INTEGER;
      NOT_ALLOWED                   EXCEPTION;
      LNCOUNT                       PLS_INTEGER;
      L_ERROR                       PLS_INTEGER;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'User' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );


      L_SQL_STRING := ASINITIALPROFILE;
      FOR L_UNILAB_ROLES_REC IN L_UNILAB_ROLES_CURSOR LOOP
        IF NVL(L_UNILAB_ROLES_REC.GRANTED_ROLE, '*') <> '*' THEN
					L_SQL_STRING := L_SQL_STRING
                       || ', '
											 || L_UNILAB_ROLES_REC.GRANTED_ROLE;
        END IF;
      END LOOP;


      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IF ASUSER = LSSCHEMANAME
      THEN
         RAISE NOT_ALLOWED;
      END IF;

      LIUSCURSOR := DBMS_SQL.OPEN_CURSOR;



      L_ERROR := 1;

      FOR L_ROW IN C_GRANTED_ROLE( ASUSER )
      LOOP
         GSSQLSTRING :=    'REVOKE '
                        || L_ROW.GRANTED_ROLE
                        || ' FROM "'
                        || UPPER( ASUSER )
                        || '"';
         DBMS_SQL.PARSE( LIUSCURSOR,
                         GSSQLSTRING,
                         DBMS_SQL.V7 );
         GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
      END LOOP;




      L_ERROR := 2;
      GSSQLSTRING :=    'GRANT '
                     || ASINITIALPROFILE
                     || ' to "'
                     || ASUSER
                     || '"';
      DBMS_SQL.PARSE( LIUSCURSOR,
                      GSSQLSTRING,
                      DBMS_SQL.V7 );
      GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );



      L_ERROR := 3;
      GSSQLSTRING :=    'GRANT '
                     || ASUSERPROFILE
                     || ' to "'
                     || ASUSER
                     || '"';
      DBMS_SQL.PARSE( LIUSCURSOR,
                      GSSQLSTRING,
                      DBMS_SQL.V7 );
      GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );



      L_ERROR := 4;
      GSSQLSTRING :=    'ALTER USER "'
                     || ASUSER
                     || '" default role '



                        || L_SQL_STRING; 

      DBMS_SQL.PARSE( LIUSCURSOR,
                      GSSQLSTRING,
                      DBMS_SQL.V7 );
      GIRESULT := DBMS_SQL.EXECUTE( LIUSCURSOR );
      DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NOT_ALLOWED
      THEN
         IAPIGENERAL.LOGWARNING( GSSOURCE,
                                 LSMETHOD,
                                    'The user profile of user '
                                 || LSSCHEMANAME
                                 || ' cannot be changed' );
         RAISE_APPLICATION_ERROR( -20035,
                                     'The user profile of user '
                                  || LSSCHEMANAME
                                  || ' cannot be changed' );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF DBMS_SQL.IS_OPEN( LIUSCURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LIUSCURSOR );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEPROFILE;

   
   FUNCTION GETUSERDESCRIPTION(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      ASNAME                     OUT      IAPITYPE.DESCRIPTION_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSNAME                        IAPITYPE.DESCRIPTION_TYPE;
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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ASUSER IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         ASUSER );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      
      
      IF USERFOUND( ASUSER ) <> 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_USERNOTFOUND,
                                                     ASUSER ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT    FORENAME
             || ' '
             || LAST_NAME
        INTO LSNAME
        FROM ITUS
       WHERE UPPER( USER_ID ) = UPPER( ASUSER );

      IF LSNAME = ' '
      THEN
         LSNAME := UPPER( ASUSER );
      END IF;

      ASNAME := LSNAME;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERDESCRIPTION;

   
   FUNCTION GETGRACEPERIODINDAYS(
      ANDAYS                     OUT      IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
        
        
        
        
       
       
       
      
        
        
        
        
        
        
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetGracePeriodInDays';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIDAYS                        PLS_INTEGER;
      LICOUNT                       PLS_INTEGER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LICOUNT
        FROM DBA_USERS
       WHERE USERNAME = NVL( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                             USER )
         AND ACCOUNT_STATUS <> 'OPEN';

      LIDAYS := 0;

      IF LICOUNT > 0
      THEN
         SELECT FLOOR(   NVL( EXPIRY_DATE,
                              SYSDATE )
                       - SYSDATE )
           INTO LIDAYS
           FROM DBA_USERS
          WHERE USERNAME = NVL( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                USER )
            AND ACCOUNT_STATUS <> 'OPEN';
      END IF;

      IF LICOUNT = 0
      THEN
         ANDAYS := -1;
      ELSIF LIDAYS > 0
      THEN
         ANDAYS := LIDAYS;
      ELSE
         ANDAYS := -2;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETGRACEPERIODINDAYS;
   
   
   
   
   FUNCTION LOGPASSWORDRESET(
      ASUSER                     IN       IAPITYPE.USERID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogPasswordReset';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSACTION                        VARCHAR2( 20 );
      LROLDRECORD                   APPLICATION_USER%ROWTYPE;
      LRNEWRECORD                   APPLICATION_USER%ROWTYPE;
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
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
                           
      LSACTION := 'UPDATING_PWD';
      
      LNRETVAL := FILLAPPLICATIONUSERRECORD( ASUSER,
                                             LROLDRECORD );
      LNRETVAL := FILLAPPLICATIONUSERRECORD( ASUSER,
                                             LRNEWRECORD );
      LNRETVAL := IAPIAUDITTRAIL.ADDUSERHISTORY( LSACTION,
                                                 LROLDRECORD,
                                                 LRNEWRECORD );      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END LOGPASSWORDRESET;  
  
   
END IAPIUSERS;