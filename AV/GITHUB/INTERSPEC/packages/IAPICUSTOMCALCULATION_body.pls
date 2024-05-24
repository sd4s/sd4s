CREATE OR REPLACE PACKAGE BODY iapiCustomCalculation
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION VALIDATECONFIGEXIST(
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASFIELDVALUE               IN       IAPITYPE.STRINGVAL_TYPE,
      ASTABLE                    IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE  )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateConfigExist';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LSTABLE                       IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSTABLE := UPPER( ASTABLE );

      IF LSTABLE = 'ITNUTCONFIG'
      THEN
         SELECT COUNT( ITNUTCONFIG.VALUE )
           INTO LNRESULT
           FROM ITNUTCONFIG,
                ITFUNCTION
          WHERE ITNUTCONFIG.FUNCTION_ID = ITFUNCTION.FUNCTION_ID
            AND ITNUTCONFIG.REF_TYPE = ASREFERENCETYPE
            AND ITFUNCTION.DESCRIPTION = ASFIELDVALUE;
      ELSIF LSTABLE = 'ITNUTPROPERTYCONFIG'
      THEN
         SELECT COUNT( ITNUTPROPERTYCONFIG.ROWID )
           INTO LNRESULT
           FROM ITNUTPROPERTYCONFIG,
                ITFUNCTION
          WHERE ITNUTPROPERTYCONFIG.FUNCTION_ID = ITFUNCTION.FUNCTION_ID
            AND ITNUTPROPERTYCONFIG.REF_TYPE = ASREFERENCETYPE
            AND ITFUNCTION.DESCRIPTION = ASFIELDVALUE;
      END IF;

      IF LNRESULT = 0
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_PROPERTYNOTCONFIGURED,
                                                ASFIELDVALUE,
                                                ASTABLE,
                                                ASREFERENCETYPE );
         RETURN( IAPICONSTANTDBERROR.DBERR_PROPERTYNOTCONFIGURED );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END;

   
   FUNCTION VALIDATEMA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      
      ABLOGERROR                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1)      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateMa';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSERRORMSG                    IAPITYPE.INFO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
                           
      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'FatSollubleHeaderId',
                                       'ITNUTCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;  
        
         RETURN( LNRETVAL );       
      END IF;

      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'MoistureId',
                                       'ITNUTPROPERTYCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;                                     
         
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
   END;

   
   FUNCTION VALIDATEFA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      
      ABLOGERROR                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateFa';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSERRORMSG                    IAPITYPE.INFO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
                           
      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'FatSollubleHeaderId',
                                       'ITNUTCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;                                     
         
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'MoistureId',
                                       'ITNUTPROPERTYCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;  
                                            
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'FatId',
                                       'ITNUTPROPERTYCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;  
                                        
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
   END;

   
   FUNCTION VALIDATEMFA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      
      ABLOGERROR                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1) 
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateMFa';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
                           
      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'FatSollubleHeaderId',
                                       'ITNUTCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;  
                  
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'MoistureId',
                                       'ITNUTPROPERTYCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;  
                  
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'FatId',
                                       'ITNUTPROPERTYCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;  
                 
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
   END;

   
   FUNCTION VALIDATERF(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      
      ABLOGERROR                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateRF';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
                           
      LNRETVAL := VALIDATECONFIGEXIST( ASREFERENCETYPE,
                                       'rfPartNo',
                                       'ITNUTCONFIG',
                                       ASCULTURE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
        
        IF ABLOGERROR = 1
        THEN
       
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
        
         END IF;  
         
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
   END;

   
   FUNCTION VALIDATECUSTOMCALCULATION(
      ASVALIDATIONFUNCTION       IN       IAPITYPE.STRINGVAL_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      
      ABLOGERROR                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateCustomCalculation';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'BEGIN '
               || ':lnRetVal := '
               || ASVALIDATIONFUNCTION
               || '('
               || ':asPartNo,'
               || ':asReferenceType,'                              
               || ':asCulture,'
               
               || ':abLogError);'               
               || ' END;';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      EXECUTE IMMEDIATE LSSQL
                  USING OUT LNRETVAL,
                        ASPARTNO,
                        ASREFERENCETYPE,
                        ASCULTURE,
	                
                        ABLOGERROR;

      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
        
        
        
        IF ABLOGERROR = 1
        THEN
        
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   SQLERRM );
         
         END IF;
                      
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END;

   
   PROCEDURE GETCUSTOMCALCULATIONS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      AQCALCULATIONS             OUT      IAPITYPE.REF_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCustomCalculations';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQCALCULATIONS FOR
         SELECT ITCUSTOMCALCULATION.CUSTOMCALCULATION_ID AS ID,
                ITCUSTOMCALCULATION.CUSTOMCALCULATION_GUID AS GUID,
                F_CUSTCALC_DESCR( ITCUSTOMCALCULATION.CUSTOMCALCULATION_ID ) AS NAME,
                ITCUSTOMCALCULATION.STATUS AS STATUSID,
                '' AS STATUS,
                ITCUSTOMCALCULATION.PLUGINURL AS PLUGINURL,
                ITCUSTOMCALCULATION.CLASSNAME AS CLASSNAME,
                1 AS VERSION,            
                IAPICUSTOMCALCULATION.VALIDATECUSTOMCALCULATION( ITCUSTOMCALCULATION.VALIDATIONFUNCTION,
                                                                 ASPARTNO,
                                                                 ASREFERENCETYPE,
                                                                 
                                                                 
                                                                 'en',
                                                                 0) AS MESSAGEID,          
                                                                 
                DECODE( IAPICUSTOMCALCULATION.VALIDATECUSTOMCALCULATION( ITCUSTOMCALCULATION.VALIDATIONFUNCTION,
                                                                          ASPARTNO,
                                                                         ASREFERENCETYPE,
                                                                         
                                                                         
                                                                         'en',
                                                                         0 ), 
                                                                         
                        IAPICONSTANTDBERROR.DBERR_SUCCESS, ' ',
                        IAPIGENERAL.GETLASTERRORTEXT( ) ) AS MESSAGE,                 
                1 AS MESSAGELEVEL
           FROM ITCUSTOMCALCULATION;
           
   EXCEPTION
      WHEN OTHERS
      THEN     
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );                      
   END;

   
   PROCEDURE GETRETENTIONFACTORGROUPS(
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      AQRFGROUP                  OUT      IAPITYPE.REF_TYPE )
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRetentionFactorGroups';
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSFRAME                       IAPITYPE.STRING_TYPE;
      LNDISPLAYFORMAT               IAPITYPE.ID_TYPE;
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT ITNUTCONFIG.VALUE,
             SPECIFICATION_HEADER.FRAME_ID,
             SPECIFICATION_HEADER.FRAME_REV
        INTO LSPARTNO,
             LSFRAME,
             LNFRAMEREVISION
        FROM ITNUTCONFIG,
             SPECIFICATION_HEADER
       WHERE ITNUTCONFIG.FUNCTION_ID = 6
         AND ITNUTCONFIG.REF_TYPE = ASREFERENCETYPE
         AND SPECIFICATION_HEADER.PART_NO = ITNUTCONFIG.VALUE;

      
      SELECT ITNUTCONFIG.VALUE
        INTO LNDISPLAYFORMAT
        FROM ITNUTCONFIG
       WHERE ITNUTCONFIG.FUNCTION_ID = 7
         AND ITNUTCONFIG.REF_TYPE = ASREFERENCETYPE;

      OPEN AQRFGROUP FOR
         SELECT SECTION.SECTION_ID AS ID,
                SECTION.DESCRIPTION AS DESCRIPTION,
                FRAME_SECTION.SUB_SECTION_ID AS DETAILID,
                SUB_SECTION.DESCRIPTION AS DETAILDESCRIPTION,
                PROPERTY_GROUP.DESCRIPTION AS CODE
           FROM FRAME_SECTION,
                SECTION,
                SUB_SECTION,
                PROPERTY_GROUP
          WHERE FRAME_NO = LSFRAME
            AND FRAME_SECTION.DISPLAY_FORMAT = LNDISPLAYFORMAT
            AND FRAME_SECTION.SECTION_ID = SECTION.SECTION_ID
            AND FRAME_SECTION.SUB_SECTION_ID = SUB_SECTION.SUB_SECTION_ID
            AND FRAME_SECTION.REVISION = LNFRAMEREVISION
            AND FRAME_SECTION.REF_ID = PROPERTY_GROUP.PROPERTY_GROUP;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;

   
   PROCEDURE GETRETENTIONFACTOR(
      ANID                       IN       IAPITYPE.ID_TYPE,
      ANDETAILID                 IN       IAPITYPE.ID_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      AQRFGROUP                  OUT      IAPITYPE.REF_TYPE )
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRetentionFactor';
      LSRFPARTNO                    IAPITYPE.PARTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ITNUTCONFIG.VALUE
        INTO LSRFPARTNO
        FROM ITNUTCONFIG,
             SPECIFICATION_HEADER
       WHERE ITNUTCONFIG.FUNCTION_ID = 6
         AND ITNUTCONFIG.REF_TYPE = ASREFERENCETYPE
         AND SPECIFICATION_HEADER.PART_NO = ITNUTCONFIG.VALUE;

      OPEN AQRFGROUP FOR
         SELECT SPECDATA.PROPERTY AS PROPERTYID,
                PROPERTY.DESCRIPTION AS PROPERTYDESCRIPTION,
                SPECDATA.ATTRIBUTE AS ATTRIBUTEID,
                ATTRIBUTE.DESCRIPTION AS ATTRIBUTEDESCRIPTION,
                SPECDATA.VALUE AS VALUE
           FROM SPECDATA,
                PROPERTY,
                ATTRIBUTE
          WHERE SPECDATA.PART_NO = LSRFPARTNO
            AND SPECDATA.SUB_SECTION_ID = ANDETAILID
            AND SPECDATA.SECTION_ID = ANID
            AND SPECDATA.PROPERTY = PROPERTY.PROPERTY
            AND SPECDATA.ATTRIBUTE = ATTRIBUTE.ATTRIBUTE;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;

   
   PROCEDURE GETCUSTOMCALCULATIONVALUES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASREFERENCETYPE            IN       IAPITYPE.STRINGVAL_TYPE,
      ASCULTURE                  IN       IAPITYPE.STRINGVAL_TYPE,
      AQCALCULATIONVALUES        OUT      IAPITYPE.REF_TYPE )
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCustomCalculationValues';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQCALCULATIONVALUES FOR
         SELECT ITCUSTOMCALCULATIONVALUES.CUSTOMCALCULATION_ID AS CALCULATIONID,
                ITCUSTOMCALCULATIONVALUES.VALUEDESCRIPTION AS NAME,
                SPECDATA.VALUE_S AS VALUE
           FROM ITCUSTOMCALCULATIONVALUES,
                SPECDATA
          WHERE SPECDATA.PART_NO = ASPARTNO
            AND SPECDATA.REVISION = ANREVISION
            AND SPECDATA.SECTION_ID = ITCUSTOMCALCULATIONVALUES.SECTION_ID
            AND SPECDATA.SUB_SECTION_ID = ITCUSTOMCALCULATIONVALUES.SUB_SECTION_ID
            AND SPECDATA.PROPERTY_GROUP = ITCUSTOMCALCULATIONVALUES.PROPERTY_GROUP
            AND SPECDATA.PROPERTY = ITCUSTOMCALCULATIONVALUES.PROPERTY
            AND SPECDATA.ATTRIBUTE = ITCUSTOMCALCULATIONVALUES.ATTRIBUTE;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;
END IAPICUSTOMCALCULATION;