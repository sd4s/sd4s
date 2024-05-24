CREATE OR REPLACE PACKAGE BODY iapiIngredientGroups
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION GETSUBGROUPS(
      ANGROUPID                  IN       IAPITYPE.ID_TYPE,
      AQSUBGROUPS                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSubGroups';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      VARCHAR2( 400 )
         :=    'cid '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ' ,f_ingcfg_descr(1,1,cid,0) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ' ,Case '
            || ' when cid >= 700000 then 1 '
            || ' else 0 '
            || ' end '
            || IAPICONSTANTCOLUMN.INGREDIENTINTERNATIONALCOL;
      LSFROM                        VARCHAR2( 100 ) := ' FROM itinggroupd ';
      LSWHERE                       VARCHAR2( 100 ) := ' WHERE cid_type = 1 AND pid = :anGroupId ';
      LSORDERBY                     VARCHAR2( 100 ) := ' ORDER BY 2 ';
      LSSQL                         VARCHAR2( 500 );
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSUBGROUPS FOR LSSQL USING ANGROUPID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      IF AQSUBGROUPS%ISOPEN
      THEN
         CLOSE AQSUBGROUPS;
      END IF;

      OPEN AQSUBGROUPS FOR LSSQL USING ANGROUPID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQSUBGROUPS%ISOPEN
         THEN
            CLOSE AQSUBGROUPS;
         END IF;

         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || LSORDERBY;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL,
                              IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQSUBGROUPS FOR LSSQL USING ANGROUPID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSUBGROUPS;

   
   FUNCTION GETPARENTGROUPS(
      ANGROUPID                  IN       IAPITYPE.ID_TYPE,
      AQPARENTGROUPS             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetParentGroups';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      VARCHAR2( 400 )
         :=    'Pid '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ' ,f_ingcfg_descr(1,1,pid,0) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ' ,Case '
            || ' when pid >= 700000 then 1 '
            || ' else 0 '
            || ' end '
            || IAPICONSTANTCOLUMN.INGREDIENTINTERNATIONALCOL;
      LSFROM                        VARCHAR2( 100 ) := ' FROM itinggroupd ';
      LSWHERE                       VARCHAR2( 100 ) := ' WHERE cid_type = 1 AND cid = :anGroupId ';
      LSORDERBY                     VARCHAR2( 100 ) := ' ORDER BY 2 ';
      LSSQL                         VARCHAR2( 500 );
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPARENTGROUPS FOR LSSQL USING ANGROUPID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      IF AQPARENTGROUPS%ISOPEN
      THEN
         CLOSE AQPARENTGROUPS;
      END IF;

      OPEN AQPARENTGROUPS FOR LSSQL USING ANGROUPID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQPARENTGROUPS%ISOPEN
         THEN
            CLOSE AQPARENTGROUPS;
         END IF;

         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || LSORDERBY;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL,
                              IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQPARENTGROUPS FOR LSSQL USING ANGROUPID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPARENTGROUPS;

   
   FUNCTION GETGROUPS(
      AQGROUPS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetGroups';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      VARCHAR2( 400 )
         :=    ' pid '
            || IAPICONSTANTCOLUMN.INGREDIENTPARENTIDCOL
            || ' ,f_ingcfg_descr(1,1,pid,0) '
            || IAPICONSTANTCOLUMN.INGREDIENTPARENTCOL
            || ' ,Case '
            || ' when pid >= 700000 then 1 '
            || ' else 0 '
            || ' end '
            || IAPICONSTANTCOLUMN.INGREDIENTPARENTINTLCOL
            || ' ,cid '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ' ,f_ingcfg_descr(1,1,cid,0) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ' ,Case '
            || ' when cid >= 700000 then 1 '
            || ' else 0 '
            || ' end '
            || IAPICONSTANTCOLUMN.INGREDIENTINTERNATIONALCOL;
      LSFROM                        VARCHAR2( 100 ) := ' FROM itinggroupd ';
      LSORDERBY                     VARCHAR2( 100 ) := ' ORDER BY 2,5 ';
      LSSQL                         VARCHAR2( 500 );
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQGROUPS FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' WHERE cid_type = 1 '
               || LSORDERBY;

      IF AQGROUPS%ISOPEN
      THEN
         CLOSE AQGROUPS;
      END IF;

      OPEN AQGROUPS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQGROUPS%ISOPEN
         THEN
            CLOSE AQGROUPS;
         END IF;

         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 '
                  || LSORDERBY;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL,
                              IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQGROUPS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETGROUPS;

   
   FUNCTION GETFUNCTIONS(
      ANGROUPID                  IN       IAPITYPE.ID_TYPE,
      AQFUNCTIONS                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFunctions';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      VARCHAR2( 400 )
         :=    'cid '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ' ,f_ingcfg_descr(1,2,cid,0) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ' ,Case '
            || ' when cid >= 700000 then 1 '
            || ' else 0 '
            || ' end '
            || IAPICONSTANTCOLUMN.INGREDIENTINTERNATIONALCOL;
      LSFROM                        VARCHAR2( 100 ) := ' FROM itinggroupd ';
      LSWHERE                       VARCHAR2( 100 ) := ' WHERE cid_type = 2 AND pid = :anGroupId ';
      LSORDERBY                     VARCHAR2( 100 ) := ' ORDER BY 2 ';
      LSSQL                         VARCHAR2( 500 );
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFUNCTIONS FOR LSSQL USING ANGROUPID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      IF AQFUNCTIONS%ISOPEN
      THEN
         CLOSE AQFUNCTIONS;
      END IF;

      OPEN AQFUNCTIONS FOR LSSQL USING ANGROUPID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQFUNCTIONS%ISOPEN
         THEN
            CLOSE AQFUNCTIONS;
         END IF;

         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || LSORDERBY;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL,
                              IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQFUNCTIONS FOR LSSQL USING ANGROUPID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFUNCTIONS;
END IAPIINGREDIENTGROUPS;