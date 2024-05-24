CREATE OR REPLACE PACKAGE BODY iapiSpecificationAccess
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





   


    
    
    FUNCTION GETFROMARCACHE(
        ASOBJECT_ID IN VARCHAR2,
        ANACCESS OUT IAPITYPE.BOOLEAN_TYPE )
        RETURN IAPITYPE.ERRORNUM_TYPE
    IS
    BEGIN
        IF (GARCACHEENABLED >= 1) THEN  
            ANACCESS := AR_CACHE(ASOBJECT_ID);
        ELSE
            RETURN IAPICONSTANTDBERROR.DBERR_GENFAIL;
        END IF;
       RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
    EXCEPTION 
        WHEN OTHERS 
        THEN 
            RETURN IAPICONSTANTDBERROR.DBERR_GENFAIL;
    END;
    

    
    
    PROCEDURE WRITETOARCACHE(
        ASOBJECT_ID IN VARCHAR2,
        ANACCESS IN IAPITYPE.BOOLEAN_TYPE
        )
    IS
    BEGIN
        IF (GARCACHEENABLED >= 1) THEN  
            AR_CACHE(ASOBJECT_ID) := ANACCESS;
        END IF;
    EXCEPTION 
        WHEN OTHERS 
        THEN NULL; 
    END;
    

    
    
    PROCEDURE ENABLEARCACHE
    IS
    BEGIN
        GARCACHEENABLED := GARCACHEENABLED + 1; 
    END;
    

    
    
    PROCEDURE DISABLEARCACHE
    IS
    BEGIN
        GARCACHEENABLED := GARCACHEENABLED - 1;
        IF (GARCACHEENABLED <= 0) THEN
            AR_CACHE.DELETE;            
        END IF; 
    END;
    





   FUNCTION GETVIEWACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetViewAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
      LSCACHEID                     VARCHAR(1024);
   BEGIN
   
      
      LSCACHEID := 'V#'||ASPARTNO||'#'||ANREVISION;



      LNRETVAL := GETFROMARCACHE(LSCACHEID, ANACCESS);
      IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
           RETURN LNRETVAL;
      END IF;
      
   



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

      
      IF    ANREVISION = 0
         OR ANREVISION IS NULL
      THEN
         LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                                F_GET_ATT_REV( ASPARTNO,
                                                               0 ) );
      ELSE
         LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                                ANREVISION );
      END IF;

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
      
      ANACCESS := 0;

      IF F_CHECK_ACCESS( ASPARTNO,
                         ANREVISION ) = 1
      THEN
         ANACCESS := 1;
      END IF;

    



      WRITETOARCACHE(LSCACHEID, ANACCESS);
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVIEWACCESS;


   FUNCTION GETBASICACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANMODEINDEPENDANT          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBasicAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;
      
      LSCACHEID                     VARCHAR2(1024);

   BEGIN
    
    LSCACHEID := 'B#'||ASPARTNO||'#'||ANREVISION||'#'||ANMODEINDEPENDANT;



    LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
    IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
        RETURN LNRETVAL;
    END IF;      
    




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ANACCESS := 0;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERPROFILE IN
                                              ( IAPICONSTANT.USERROLE_CONFIGURATOR, IAPICONSTANT.USERROLE_DEVMGR, IAPICONSTANT.USERROLE_FRAMEBUILDER ) )
      THEN
         LNRETVAL := GETVIEWACCESS( ASPARTNO,
                                    ANREVISION,
                                    ANACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         END IF;

         
         IF ( ANACCESS = 1 )
         THEN
            SELECT OWNER,
                   INTL
              INTO LNOWNER,
                   LNINTL
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            IF (      (     (     LNINTL = 0
                              AND IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
                        OR (     LNINTL = 1
                             AND NOT IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL ) )
                 AND ( ANMODEINDEPENDANT <> 1 ) )
            THEN
               ANACCESS := 0;
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'Mode does not match mode of specification '
                                    || ASPARTNO
                                    || ' ['
                                    || ANREVISION
                                    || ']',
                                    IAPICONSTANT.INFOLEVEL_3 );
            END IF;

            IF LNOWNER <> IAPIGENERAL.SESSION.DATABASE.OWNER
            THEN
               ANACCESS := 0;
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'You do not own specification '
                                    || ASPARTNO
                                    || ' ['
                                    || ANREVISION
                                    || ']',
                                    IAPICONSTANT.INFOLEVEL_3 );
            END IF;
         END IF;
      END IF;

    



      WRITETOARCACHE(LSCACHEID, ANACCESS);
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASICACCESS;


   FUNCTION GETSTATUSINDEPMODIFIABLEACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANMODEINDEPENDANT          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStatusIndepModifiableAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUPDATEONACCESSGROUP         VARCHAR2( 1 );
      
      LSCACHEID                     VARCHAR2(1024);

   BEGIN
       
       LSCACHEID := 'SIM#'||ASPARTNO||'#'||ANREVISION||'#'||ANMODEINDEPENDANT;
    
    
    
        LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
       IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
            RETURN LNRETVAL;
       END IF;      
       
   



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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      
      IF    ANREVISION = 0
         OR ANREVISION IS NULL
      THEN
         LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                                F_GET_ATT_REV( ASPARTNO,
                                                               0 ) );
      ELSE
         LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                                ANREVISION );
      END IF;

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
      
      ANACCESS := 0;

      SELECT MAX( UPDATE_ALLOWED )
        INTO LSUPDATEONACCESSGROUP
        FROM USER_ACCESS_GROUP
       WHERE ACCESS_GROUP IN( SELECT ACCESS_GROUP
                               FROM SPECIFICATION_HEADER
                              WHERE PART_NO = ASPARTNO
                                AND REVISION = ANREVISION )
         AND USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                FROM USER_GROUP_LIST
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

      
      IF LSUPDATEONACCESSGROUP = 'Y'
      THEN
         LNRETVAL := GETBASICACCESS( ASPARTNO,
                                     ANREVISION,
                                     ANMODEINDEPENDANT,
                                     ANACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         END IF;
      END IF;

      



      WRITETOARCACHE(LSCACHEID, ANACCESS);
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSTATUSINDEPMODIFIABLEACCESS;


   FUNCTION CROSSGETLOCK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASUSERID                   OUT      IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
	  
	  
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CrossGetLock';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
         
      
      
      
	  

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

	  
	   
	  
      LNRETVAL := IAPISPECIFICATION.GETLOCKED( ASPARTNO,
                                               ANREVISION,
                                               ASUSERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      IF (    ASUSERID IS NULL
           OR ASUSERID = '' )
      THEN
	  	  
	     
         LNRETVAL := IAPISPECIFICATIONSECTION.GETLOCKED( ASPARTNO,
                                                         ANREVISION,
                                                         ASUSERID );
         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

	  END IF;

	  
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );



   
   END CROSSGETLOCK;


   FUNCTION GETMODIFIABLEACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetModifiableAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
	  LSUSERID                      IAPITYPE.USERID_TYPE;
      
      LSCACHEID                     VARCHAR2(1024);

   BEGIN
    
    LSCACHEID := 'M#'||ASPARTNO||'#'||ANREVISION;
    
    
    
    LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
    IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
        RETURN LNRETVAL;
    END IF;
    




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LNRETVAL := GETSTATUSINDEPMODIFIABLEACCESS( ASPARTNO,
                                                  ANREVISION,
                                                  0,
                                                  ANACCESS );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      LSSTATUSTYPE :=  NULL;

      IF ANACCESS = 1
      THEN
         
         










         
         
         LNRETVAL := IAPISPECIFICATION.GETSTATUSTYPE(ASPARTNO, ANREVISION, LSSTATUSTYPE);



         IF (LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS) 
            OR ((LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS)          
                AND (LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT)) 
         THEN
            ANACCESS := 0;
         END IF;
         

		 IF  NOT (ANACCESS = 0) 
		 THEN

		    
	        LNRETVAL := IAPISPECIFICATION.GETLOCKED( ASPARTNO,
	                                                 ANREVISION,
	                                                 LSUSERID );
	        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
	        THEN
	          RETURN( LNRETVAL );
	        END IF;
		 

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
            END IF;
		 
			IF (      LSUSERID  IS NULL
			     OR   LSUSERID  = '' )
			THEN
			  NULL;
			ELSE
			   IF  LSUSERID <> IAPIGENERAL.SESSION.APPLICATIONUSER.USERID 
			   THEN
			   	   
				   ANACCESS := 0;
			   END IF;
			END IF;

		 END IF;

      END IF;

      



      WRITETOARCACHE(LSCACHEID, ANACCESS);
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMODIFIABLEACCESS;


   FUNCTION GETMODIFIABLEACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetModifiableAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
	  LSUSERID                      IAPITYPE.USERID_TYPE;
      
      LSCACHEID                     VARCHAR2(1024);

   BEGIN
   
   
    LSCACHEID := 'M#'||ASPARTNO||'#'||ANREVISION||'#'||ANSECTIONID||'#'||ANSUBSECTIONID;



    LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
    IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
        RETURN LNRETVAL;
    END IF;      
    




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LNRETVAL := GETSTATUSINDEPMODIFIABLEACCESS( ASPARTNO,
                                                  ANREVISION,
                                                  0,
                                                  ANACCESS );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      LSSTATUSTYPE := NULL;

      IF ANACCESS = 1
      THEN
        
        









         
         LNRETVAL := IAPISPECIFICATION.GETSTATUSTYPE(ASPARTNO, ANREVISION, LSSTATUSTYPE);
 


        IF (LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS)
            OR ((LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) 
                AND (LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT))                     
         
         THEN 
            ANACCESS := 0;
         END IF;
		 
		 IF  NOT (ANACCESS = 0) 
		 THEN

		    
	        LNRETVAL := IAPISPECIFICATIONSECTION.GETLOCKED( ASPARTNO,
	                                                        ANREVISION,
															ANSECTIONID,
															ANSUBSECTIONID,
	                                                        LSUSERID );
	        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
	        THEN
	          RETURN( LNRETVAL );
	        END IF;
		 

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
            END IF;
		 
			IF (      LSUSERID  IS NULL
			     OR   LSUSERID  = '' )
			THEN
			  NULL;
			ELSE
			   IF  LSUSERID <> IAPIGENERAL.SESSION.APPLICATIONUSER.USERID 
			   THEN
			   	   
				   ANACCESS := 0;
				   RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

			   END IF;
			END IF;

			
		     
		    LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( ASPARTNO,
		   	    												     ANREVISION,
																     ANACCESS);
	        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
	        THEN
	          RETURN( LNRETVAL );
	        END IF;
	
		 END IF;

      END IF;
      
      



      WRITETOARCACHE(LSCACHEID, ANACCESS);
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMODIFIABLEACCESS;


   FUNCTION GETPRODUCTIONMRPACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProductionMrpAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;
      LSMRPONACCESSGROUP            IAPITYPE.ACCESS_TYPE;
      
      LSCACHEID                     VARCHAR2(1024);
      LRCACHE                       IAPISPECIFICATION.SHCACHE_REC_TYPE;

   BEGIN
    
    LSCACHEID := 'PRMRP#'||ASPARTNO||'#'||ANREVISION;



       LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
       IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
            RETURN LNRETVAL;
       END IF;      
   
   



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ANACCESS := 0;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERPROFILE IN
                   ( IAPICONSTANT.USERROLE_CONFIGURATOR, IAPICONSTANT.USERROLE_DEVMGR, IAPICONSTANT.USERROLE_FRAMEBUILDER, IAPICONSTANT.USERROLE_MRP ) )
      THEN
         LNRETVAL := GETVIEWACCESS( ASPARTNO,
                                    ANREVISION,
                                    ANACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         END IF;

         IF ANACCESS = 1
         THEN
            
            LRCACHE := NULL;
            LNRETVAL := IAPISPECIFICATION.GETSHFROMCACHE(ASPARTNO, ANREVISION, LRCACHE);
            
            IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) 
            THEN
                 IF (LRCACHE.PARTNO IS NULL) 
                 THEN
                   IAPISPECIFICATION.INSERTTOSHCACHE(ASPARTNO, ANREVISION);
                   LNRETVAL := IAPISPECIFICATION.GETSHFROMCACHE(ASPARTNO, ANREVISION, LRCACHE);
                 END IF;
                                                         
                 IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS 
                    AND LRCACHE.PARTNO IS NOT NULL) 
                 THEN
                   LNOWNER := LRCACHE.OWNER;
                   LNINTL := LRCACHE.ISINTERNATIONAL;
                   RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
                 ELSE
                    RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                LSMETHOD,
                                                                IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTFOUND,
                                                                ASPARTNO,
                                                                ANREVISION ) );
                 END IF; 
            END IF;            
            
            
            SELECT OWNER,
                   INTL
              INTO LNOWNER,
                   LNINTL
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            
            IF    LNOWNER <> IAPIGENERAL.SESSION.DATABASE.OWNER
               OR (     LNINTL = 0
                    AND IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
               OR (     LNINTL = 1
                    AND NOT IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
            THEN
               ANACCESS := 0;
               RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
            END IF;

            SELECT MAX( MRP_UPDATE )
              INTO LSMRPONACCESSGROUP
              FROM USER_ACCESS_GROUP
             WHERE ACCESS_GROUP IN( SELECT ACCESS_GROUP
                                     FROM SPECIFICATION_HEADER
                                    WHERE PART_NO = ASPARTNO
                                      AND REVISION = ANREVISION )
               AND USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                      FROM USER_GROUP_LIST
                                     WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

            IF (     ( LSMRPONACCESSGROUP = 'N' )
                 OR ( IAPIGENERAL.SESSION.APPLICATIONUSER.MRPPRODUCTIONACCESS = '0' ) )
            THEN
               ANACCESS := 0;
            END IF;
         END IF;
      END IF;

    



      WRITETOARCACHE(LSCACHEID, ANACCESS);
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPRODUCTIONMRPACCESS;


   FUNCTION GETPLANNINGMRPACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlanningMrpAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;
      LSMRPONACCESSGROUP            IAPITYPE.ACCESS_TYPE;
      
      LSCACHEID                     VARCHAR2(1024);

   BEGIN
       
       LSCACHEID := 'PLMRP#'||ASPARTNO||'#'||ANREVISION;
    
    
    
        LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
       IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
            RETURN LNRETVAL;
       END IF;      
       
   



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ANACCESS := 0;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERPROFILE IN
                   ( IAPICONSTANT.USERROLE_CONFIGURATOR, IAPICONSTANT.USERROLE_DEVMGR, IAPICONSTANT.USERROLE_FRAMEBUILDER, IAPICONSTANT.USERROLE_MRP ) )
      THEN
         LNRETVAL := GETVIEWACCESS( ASPARTNO,
                                    ANREVISION,
                                    ANACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         END IF;

         IF ANACCESS = 1
         THEN
            SELECT OWNER,
                   INTL
              INTO LNOWNER,
                   LNINTL
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            
            IF    LNOWNER <> IAPIGENERAL.SESSION.DATABASE.OWNER
               OR (     LNINTL = 0
                    AND IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
               OR (     LNINTL = 1
                    AND NOT IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
            THEN
               ANACCESS := 0;
               RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
            END IF;

            SELECT MAX( MRP_UPDATE )
              INTO LSMRPONACCESSGROUP
              FROM USER_ACCESS_GROUP
             WHERE ACCESS_GROUP IN( SELECT ACCESS_GROUP
                                     FROM SPECIFICATION_HEADER
                                    WHERE PART_NO = ASPARTNO
                                      AND REVISION = ANREVISION )
               AND USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                      FROM USER_GROUP_LIST
                                     WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

            IF (     ( LSMRPONACCESSGROUP = 'N' )
                 OR ( IAPIGENERAL.SESSION.APPLICATIONUSER.MRPPLANNINGACCESS = '0' ) )
            THEN
               ANACCESS := 0;
            END IF;
         END IF;
      END IF;

     



      WRITETOARCACHE(LSCACHEID, ANACCESS);
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPLANNINGMRPACCESS;


   FUNCTION GETPHASEMRPACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPhaseMrpAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;
      LSMRPONACCESSGROUP            IAPITYPE.ACCESS_TYPE;
      
      LSCACHEID                     VARCHAR2(1024);
   BEGIN
   
    
       LSCACHEID := 'PHMRP#'||ASPARTNO||'#'||ANREVISION;



        LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
       IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
            RETURN LNRETVAL;
       END IF;          
    
       



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ANACCESS := 0;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERPROFILE IN
                   ( IAPICONSTANT.USERROLE_CONFIGURATOR, IAPICONSTANT.USERROLE_DEVMGR, IAPICONSTANT.USERROLE_FRAMEBUILDER, IAPICONSTANT.USERROLE_MRP ) )
      THEN
         LNRETVAL := GETVIEWACCESS( ASPARTNO,
                                    ANREVISION,
                                    ANACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         END IF;

         IF ANACCESS = 1
         THEN
            SELECT OWNER,
                   INTL
              INTO LNOWNER,
                   LNINTL
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            
            IF    LNOWNER <> IAPIGENERAL.SESSION.DATABASE.OWNER
               OR (     LNINTL = 0
                    AND IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
               OR (     LNINTL = 1
                    AND NOT IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL )
            THEN
               ANACCESS := 0;
               RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
            END IF;

            SELECT MAX( MRP_UPDATE )
              INTO LSMRPONACCESSGROUP
              FROM USER_ACCESS_GROUP
             WHERE ACCESS_GROUP IN( SELECT ACCESS_GROUP
                                     FROM SPECIFICATION_HEADER
                                    WHERE PART_NO = ASPARTNO
                                      AND REVISION = ANREVISION )
               AND USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                      FROM USER_GROUP_LIST
                                     WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

            IF (     ( LSMRPONACCESSGROUP = 'N' )
                 OR ( IAPIGENERAL.SESSION.APPLICATIONUSER.MRPPHASEACCESS = '0' ) )
            THEN
               ANACCESS := 0;
            END IF;
         END IF;
      END IF;

    



      WRITETOARCACHE(LSCACHEID, ANACCESS);    
    

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPHASEMRPACCESS;


   FUNCTION GETMODEINDEPMODIFIABLEACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS














      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetModeIndepModifiableAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      
      LSCACHEID                     VARCHAR2(1024);
      
   BEGIN
   
       
       LSCACHEID := 'MIM#'||ASPARTNO||'#'||ANREVISION;



        LNRETVAL := GETFROMARCACHE(LSCACHEID , ANACCESS);
       IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS) THEN
            RETURN LNRETVAL;
       END IF;      
    
      
         



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID = IAPIGENERAL.SCHEMANAME
      THEN
         ANACCESS := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LNRETVAL := GETSTATUSINDEPMODIFIABLEACCESS( ASPARTNO,
                                                  ANREVISION,
                                                  1,
                                                  ANACCESS );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      IF ANACCESS = 1
      THEN
         SELECT B.STATUS_TYPE
           INTO LSSTATUSTYPE
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         IF LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         THEN
            ANACCESS := 0;
         END IF;
      END IF;

    



      WRITETOARCACHE(LSCACHEID, ANACCESS);    
    

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMODEINDEPMODIFIABLEACCESS;

   
END IAPISPECIFICATIONACCESS;