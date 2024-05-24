CREATE OR REPLACE PACKAGE BODY iapiSmartClient
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION GETSTEPS(
      AQSTEPS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSteps';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECTSTD                   IAPITYPE.SQLSTRING_TYPE
         :=    ' Guid '
            || IAPICONSTANTCOLUMN.GUIDCOL
            || ', Type '
            || IAPICONSTANTCOLUMN.TYPECOL
            || ', Description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', 1 '
            || IAPICONSTANTCOLUMN.VALIDCOL;
      LSSELECTLIB                   IAPITYPE.SQLSTRING_TYPE
         :=    ' Guid '
            || IAPICONSTANTCOLUMN.GUIDCOL
            || ', Type '
            || IAPICONSTANTCOLUMN.TYPECOL
            || ', Description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', iapiGeneral.CheckLicensesRD '
            || IAPICONSTANTCOLUMN.VALIDCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM ITSMCLSTEPS ';
      LSWHERESTD                    IAPITYPE.SQLSTRING_TYPE := ' WHERE TYPE = ''STD'' ';
      LSWHERELIB                    IAPITYPE.SQLSTRING_TYPE := ' WHERE TYPE = ''LIB'' ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
      LSSQL :=    'Select '
               || LSSELECTSTD
               || LSFROM
               || ' WHERE 1=2 ';

      OPEN AQSTEPS FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECTSTD
               || LSFROM
               || LSWHERESTD
               || ' UNION '
               || 'SELECT '
               || LSSELECTLIB
               || LSFROM
               || LSWHERELIB;

      IF ( AQSTEPS%ISOPEN )
      THEN
         CLOSE AQSTEPS;
      END IF;

      OPEN AQSTEPS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECTSTD
                  || LSFROM
                  || ' WHERE 1=2 ';

         IF AQSTEPS%ISOPEN
         THEN
            CLOSE AQSTEPS;
         END IF;

         OPEN AQSTEPS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSTEPS;
END IAPISMARTCLIENT;