CREATE OR REPLACE PACKAGE BODY iapiWorkFlow
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









   
















































   FUNCTION GETSTATUSTYPES(
      AQSTATUSTYPES              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStatusTypes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
                                     :=    'st.status_type '                                        
                                        
                                        
                                        || IAPICONSTANTCOLUMN.STATUSTYPECOL;
                                        
                                        
                                        
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM STATUS_TYPE st ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQSTATUSTYPES%ISOPEN )
      THEN
         CLOSE AQSTATUSTYPES;
      END IF;

      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM;

      OPEN AQSTATUSTYPES FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSTATUSTYPES;

  
















































END IAPIWORKFLOW;