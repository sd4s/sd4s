CREATE OR REPLACE PACKAGE BODY iapiIngredientNotes
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION GETNOTES(
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      AQNOTES                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNotes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      VARCHAR2( 400 )
         :=    'note_id '
            || IAPICONSTANTCOLUMN.IDCOL
            || ' ,f_ingnote_descr(null,note_id,0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,f_ingnote_text(null,note_id,0) '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ' ,pref '
            || IAPICONSTANTCOLUMN.PREFERREDCOL;
      LSFROM                        VARCHAR2( 100 ) := ' FROM itingnote, itingd ';
      LSWHERE                       VARCHAR2( 100 ) :=    ' WHERE ingredient = :anIngredientId '
                                                       || ' AND note_id = cid '
                                                       || ' AND pid = 5 ';
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

      OPEN AQNOTES FOR LSSQL USING ANINGREDIENTID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      IF AQNOTES%ISOPEN
      THEN
         CLOSE AQNOTES;
      END IF;

      OPEN AQNOTES FOR LSSQL USING ANINGREDIENTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQNOTES%ISOPEN
         THEN
            CLOSE AQNOTES;
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

         OPEN AQNOTES FOR LSSQL USING ANINGREDIENTID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNOTES;
END IAPIINGREDIENTNOTES;