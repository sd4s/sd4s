CREATE OR REPLACE PACKAGE BODY iapiWebRequest
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION ADDREQUEST(
      ASPASSWORD                 IN       IAPITYPE.STRING_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANUOMTYPE                  IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASAPPLICATIONLANGUAGEID    IN       IAPITYPE.GUILANGUAGE_TYPE DEFAULT NULL,
      
      ANRULESETID                IN       IAPITYPE.SEQUENCE_TYPE DEFAULT 0,
      
      ANINTERNATIONALMODE        IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL,
      
      ANID                       OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddRequest';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMTYPE                     IAPITYPE.BOOLEAN_TYPE := ANUOMTYPE;
      LNLANGUAGEID                  IAPITYPE.LANGUAGEID_TYPE := ANLANGUAGEID;
      
      LNINTERNATIONALMODE           IAPITYPE.BOOLEAN_TYPE := ANINTERNATIONALMODE;
      
      LSAPPLICATIONLANGUAGEID       IAPITYPE.GUILANGUAGE_TYPE := ASAPPLICATIONLANGUAGEID;
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF    ASPARTNO IS NOT NULL
         OR ANREVISION IS NOT NULL
      THEN
         
         LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                                ANREVISION );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      IF (     LNUOMTYPE IS NOT NULL
           AND ( LNUOMTYPE NOT IN( IAPICONSTANT.UOMTYPE_METRIC, IAPICONSTANT.UOMTYPE_NONMETRIC ) ) )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOINITSESSION ) );
      ELSE
         
         IF ( IAPIGENERAL.SESSION.SETTINGS.METRIC = TRUE )
         THEN
            LNUOMTYPE := 0;
         ELSE
            LNUOMTYPE := 1;
         END IF;
      END IF;

      
      IF ( LNLANGUAGEID IS NOT NULL )
      THEN
         BEGIN
            SELECT LANG_ID
              INTO LNLANGUAGEID
              FROM ITLANG
             WHERE LANG_ID = LNLANGUAGEID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_INVALIDLANGUAGE,
                                                           LNLANGUAGEID ) );
         END;
      ELSE
         
         LNLANGUAGEID := IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID;
      END IF;

      
      
      IF ( LNINTERNATIONALMODE IS NULL )
      THEN
         
         IF (IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL) 
         THEN
            LNINTERNATIONALMODE := 1;
         ELSE
            LNINTERNATIONALMODE := 0;
         END IF;
      END IF;      
      

      
      IF ( LSAPPLICATIONLANGUAGEID IS NULL )
      THEN
         
         LNRETVAL := IAPIUSERPREFERENCES.GETUSERPREFERENCE( 'General',
                                                            'ApplicationLanguage',
                                                            LSAPPLICATIONLANGUAGEID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      IF ( ANRULESETID <> 0)
      THEN
        SELECT COUNT(*)
            INTO LNCOUNT
        FROM ITRULESET
            WHERE RULE_ID = ANRULESETID;
        
        IF (LNCOUNT = 0)
        THEN
             
             RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               
                                                               'RuleSetID: %1 does not exist.',
                                                               ANRULESETID ) );
        END IF;

      END IF;  
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT ITWEBRQ_SEQ.NEXTVAL
        INTO ANID
        FROM DUAL;

      INSERT INTO ITWEBRQ
                  ( USER_ID,
                    PASSWORD,
                    REQ_ID,
                    PART_NO,
                    REVISION,
                    METRIC,
                    LANG_ID,
                    GUI_LANG,
                    
                    
                    
                    RULESET_ID,
                    INTERNATIONAL)
                    
           VALUES ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                    ASPASSWORD,
                    ANID,
                    ASPARTNO,
                    ANREVISION,
                    LNUOMTYPE,
                    LNLANGUAGEID,
                    LSAPPLICATIONLANGUAGEID,
                    
                    
                    
                    ANRULESETID,
                    LNINTERNATIONALMODE);
                    

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREQUEST;

   
   FUNCTION REMOVEREQUEST(
      ANID                       IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveRequest';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITWEBRQ
            WHERE REQ_ID = ANID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEREQUEST;

   
   FUNCTION GETREQUESTDETAILS(
      ANID                       IN       IAPITYPE.ID_TYPE,
      AQREQUESTDETAILS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRequestDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'user_id '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ', password '
            || IAPICONSTANTCOLUMN.PASSWORDCOL
            || ', req_id '
            || IAPICONSTANTCOLUMN.REQUESTIDCOL
            || ', part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', rep_id '
            || IAPICONSTANTCOLUMN.REPORTIDCOL
            || ', metric '
            || IAPICONSTANTCOLUMN.METRICCOL
            || ', lang_id '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
            
            || ', international '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL            
            
            || ', gui_lang '
            || IAPICONSTANTCOLUMN.GUILANGUAGECOL
            || ', reportformat '
            || IAPICONSTANTCOLUMN.REPORTFORMATCOL
            
            || ', ruleset_id '                      
            || IAPICONSTANTCOLUMN.RULESETIDCOL;     
      LSFROM                        IAPITYPE.STRING_TYPE := 'itwebrq';
   BEGIN
      
      
      
      
      
      IF ( AQREQUESTDETAILS%ISOPEN )
      THEN
         CLOSE AQREQUESTDETAILS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE req_id = NULL';

      OPEN AQREQUESTDETAILS FOR LSSQLNULL;

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || '  FROM '
               || LSFROM
               || ' WHERE req_id = :RequestId';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQREQUESTDETAILS%ISOPEN )
      THEN
         CLOSE AQREQUESTDETAILS;
      END IF;

      
      OPEN AQREQUESTDETAILS FOR LSSQL USING ANID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREQUESTDETAILS;
END IAPIWEBREQUEST;