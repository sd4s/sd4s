CREATE OR REPLACE PACKAGE BODY iapiNutritional
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

   
   FUNCTION CONTRIBUTESTOCALORIES(
      ASNUTRITIONALREFERENCE     IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      LNCOUNTRECS                   IAPITYPE.NUMVAL_TYPE;
      LRETVAL                       IAPITYPE.BOOLEAN_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ContributesToCalories';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNCOUNTRECS := 0;
      LRETVAL := 0;

      
      SELECT COUNT( ITNUTPROPERTYCONFIG.ATTRIBUTE_ID )
        INTO LNCOUNTRECS
        FROM ITNUTPROPERTYCONFIG
       WHERE ITNUTPROPERTYCONFIG.FUNCTION_ID = 5
         AND ITNUTPROPERTYCONFIG.REF_TYPE = ASNUTRITIONALREFERENCE
         AND ITNUTPROPERTYCONFIG.PROPETY_ID = ANPROPERTYID
         AND ITNUTPROPERTYCONFIG.ATTRIBUTE_ID = ANATTRIBUTEID;

      IF LNCOUNTRECS > 1
      THEN
         LRETVAL := 1;
      END IF;

      RETURN LRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN NULL;
   END;

   
   FUNCTION ISPROPERTY(
      ASNUTRITIONALREFERENCE     IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANFUNCTIONID               IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      LNCOUNTRECS                   IAPITYPE.NUMVAL_TYPE;
      LRETVAL                       IAPITYPE.BOOLEAN_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsProperty';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNCOUNTRECS := 0;
      LRETVAL := 0;

      SELECT COUNT( ITNUTPROPERTYCONFIG.ROWID )
        INTO LNCOUNTRECS
        FROM ITNUTPROPERTYCONFIG
       WHERE ITNUTPROPERTYCONFIG.FUNCTION_ID = ANFUNCTIONID
         AND ITNUTPROPERTYCONFIG.REF_TYPE = ASNUTRITIONALREFERENCE
         AND ITNUTPROPERTYCONFIG.PROPETY_ID = ANPROPERTYID
         AND NVL( ITNUTPROPERTYCONFIG.ATTRIBUTE_ID,
                  0 ) = NVL( ANATTRIBUTEID,
                             0 );

      
      
      IF LNCOUNTRECS > 0
      
      THEN
         LRETVAL := 1;
      END IF;

      RETURN LRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN NULL;
   END;

   
   PROCEDURE GETNUTRIENTINFO(
      ASNUTRITIONALREFERENCE     IN       IAPITYPE.NUTREFTYPE_TYPE,
      AQNUTRIENTINFO             OUT      IAPITYPE.REF_TYPE )
   IS
      LNFIELDIDSOLUBLE              IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutrientInfo';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNFIELDIDSOLUBLE := 0;

      
       
      BEGIN
         SELECT PROPERTY_LAYOUT.FIELD_ID
           INTO LNFIELDIDSOLUBLE
           FROM PROPERTY_GROUP_DISPLAY,
                ITNUTREFTYPE,
                PROPERTY_LAYOUT,
                LAYOUT
          WHERE PROPERTY_GROUP_DISPLAY.PROPERTY_GROUP = ITNUTREFTYPE.PROPERTY_GROUP
            AND PROPERTY_GROUP_DISPLAY.DISPLAY_FORMAT = PROPERTY_LAYOUT.LAYOUT_ID
            AND ITNUTREFTYPE.REF_TYPE = ASNUTRITIONALREFERENCE
            AND PROPERTY_LAYOUT.HEADER_ID =
                                         ( SELECT ITNUTCONFIG.VALUE
                                            FROM ITNUTCONFIG
                                           WHERE ITNUTCONFIG.FUNCTION_ID = 1   
                                             AND ITNUTCONFIG.REF_TYPE = ASNUTRITIONALREFERENCE )
            AND LAYOUT.LAYOUT_ID = PROPERTY_LAYOUT.LAYOUT_ID
            AND LAYOUT.REVISION = PROPERTY_LAYOUT.REVISION
            AND LAYOUT.STATUS = 2;   
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNFIELDIDSOLUBLE := 0;
      END;

      IF LNFIELDIDSOLUBLE = 17
      THEN
         OPEN AQNUTRIENTINFO FOR
            SELECT SPECIFICATION_PROP.PROPERTY AS PROPERTYID,
                   SPECIFICATION_PROP.ATTRIBUTE AS ATTRIBUTEID,
                   TO_NUMBER( REPLACE( REPLACE( NVL( SPECIFICATION_PROP.BOOLEAN_1,
                                                     'N' ),
                                                'N',
                                                '0' ),
                                       'Y',
                                       '1' ) ) AS ISFATSOLUBLE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               2,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISMOISTURE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               3,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISFAT,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               4,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISCALORIES,
                   CONTRIBUTESTOCALORIES( ASNUTRITIONALREFERENCE,
                                          SPECIFICATION_PROP.PROPERTY,
                                          SPECIFICATION_PROP.ATTRIBUTE ) AS CONTRIBUTESTOTOTALCALORIES
              FROM SPECIFICATION_PROP,
                   ITNUTREFTYPE
             WHERE ITNUTREFTYPE.PART_NO = SPECIFICATION_PROP.PART_NO
               AND ITNUTREFTYPE.REF_TYPE = ASNUTRITIONALREFERENCE;
      ELSIF LNFIELDIDSOLUBLE = 18
      THEN
         OPEN AQNUTRIENTINFO FOR
            SELECT SPECIFICATION_PROP.PROPERTY AS PROPERTYID,
                   SPECIFICATION_PROP.ATTRIBUTE AS ATTRIBUTEID,
                   TO_NUMBER( REPLACE( REPLACE( NVL( SPECIFICATION_PROP.BOOLEAN_2,
                                                     'N' ),
                                                'N',
                                                '0' ),
                                       'Y',
                                       '1' ) ) AS ISFATSOLUBLE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               2,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISMOISTURE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               3,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISFAT,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               4,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISCALORIES,
                   CONTRIBUTESTOCALORIES( ASNUTRITIONALREFERENCE,
                                          SPECIFICATION_PROP.PROPERTY,
                                          SPECIFICATION_PROP.ATTRIBUTE ) AS CONTRIBUTESTOTOTALCALORIES
              FROM SPECIFICATION_PROP,
                   ITNUTREFTYPE
             WHERE ITNUTREFTYPE.PART_NO = SPECIFICATION_PROP.PART_NO
               AND ITNUTREFTYPE.REF_TYPE = ASNUTRITIONALREFERENCE;
      ELSIF LNFIELDIDSOLUBLE = 19
      THEN
         OPEN AQNUTRIENTINFO FOR
            SELECT SPECIFICATION_PROP.PROPERTY AS PROPERTYID,
                   SPECIFICATION_PROP.ATTRIBUTE AS ATTRIBUTEID,
                   TO_NUMBER( REPLACE( REPLACE( NVL( SPECIFICATION_PROP.BOOLEAN_3,
                                                     'N' ),
                                                'N',
                                                '0' ),
                                       'Y',
                                       '1' ) ) AS ISFATSOLUBLE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               2,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISMOISTURE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               3,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISFAT,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               4,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISCALORIES,
                   CONTRIBUTESTOCALORIES( ASNUTRITIONALREFERENCE,
                                          SPECIFICATION_PROP.PROPERTY,
                                          SPECIFICATION_PROP.ATTRIBUTE ) AS CONTRIBUTESTOTOTALCALORIES
              FROM SPECIFICATION_PROP,
                   ITNUTREFTYPE
             WHERE ITNUTREFTYPE.PART_NO = SPECIFICATION_PROP.PART_NO
               AND ITNUTREFTYPE.REF_TYPE = ASNUTRITIONALREFERENCE;
      ELSIF LNFIELDIDSOLUBLE = 20
      THEN
         OPEN AQNUTRIENTINFO FOR
            SELECT SPECIFICATION_PROP.PROPERTY AS PROPERTYID,
                   SPECIFICATION_PROP.ATTRIBUTE AS ATTRIBUTEID,
                   TO_NUMBER( REPLACE( REPLACE( NVL( SPECIFICATION_PROP.BOOLEAN_4,
                                                     'N' ),
                                                'N',
                                                '0' ),
                                       'Y',
                                       '1' ) ) AS ISFATSOLUBLE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               2,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISMOISTURE,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               3,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISFAT,
                   ISPROPERTY( ASNUTRITIONALREFERENCE,
                               4,
                               SPECIFICATION_PROP.PROPERTY,
                               SPECIFICATION_PROP.ATTRIBUTE ) AS ISCALORIES,
                   CONTRIBUTESTOCALORIES( ASNUTRITIONALREFERENCE,
                                          SPECIFICATION_PROP.PROPERTY,
                                          SPECIFICATION_PROP.ATTRIBUTE ) AS CONTRIBUTESTOTOTALCALORIES
              FROM SPECIFICATION_PROP,
                   ITNUTREFTYPE
             WHERE ITNUTREFTYPE.PART_NO = SPECIFICATION_PROP.PART_NO
               AND ITNUTREFTYPE.REF_TYPE = ASNUTRITIONALREFERENCE;
      ELSE
         OPEN AQNUTRIENTINFO FOR
            SELECT SPECIFICATION_PROP.PROPERTY AS PROPERTYID,
                   SPECIFICATION_PROP.ATTRIBUTE AS ATTRIBUTEID,
                   0 AS ISFATSOLUBLE,
                   0 AS ISMOISTURE,
                   0 AS ISFAT,
                   0 AS ISCALORIES,
                   0 AS CONTRIBUTESTOTOTALCALORIES
              FROM SPECIFICATION_PROP,
                   ITNUTREFTYPE
             WHERE ITNUTREFTYPE.PART_NO = SPECIFICATION_PROP.PART_NO
               AND ITNUTREFTYPE.REF_TYPE = ASNUTRITIONALREFERENCE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;

   
   PROCEDURE GETDISPLAYFORMATCOLUMNS(
      AQDISPLAYFORMATCOLUMNS     OUT      IAPITYPE.REF_TYPE )
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDisplayFormatColumns';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQDISPLAYFORMATCOLUMNS FOR
         SELECT ITNUTLYITEM.HEADER_ID AS ID,
                F_HDH_DESCR( 1,
                             ITNUTLYITEM.HEADER_ID,
                             ITNUTLYITEM.HEADER_REV ) AS DESCRIPTION
           FROM ITNUTLY,
                ITNUTLYITEM
          WHERE ITNUTLY.LAYOUT_ID = ITNUTLYITEM.LAYOUT_ID
            AND ITNUTLYITEM.COL_TYPE = 1
            AND ITNUTLY.STATUS = 2;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;

   
   PROCEDURE SAVEFOOTNOTE(
      ANPANELID                  IN       IAPITYPE.ID_TYPE,
      ALFOOTNOTETEXT             IN       IAPITYPE.CLOB_TYPE )
   IS
      LNFOORNOTEID                  IAPITYPE.SEQUENCENR_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveFootNote';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ITFOOTNOTE_SEQ.NEXTVAL
        INTO LNFOORNOTEID
        FROM DUAL;

      INSERT INTO ITFOOTNOTE
                  ( ITFOOTNOTE.FOOTNOTE_ID,
                    ITFOOTNOTE.PANEL_ID,
                    ITFOOTNOTE.TEXT )
           VALUES ( LNFOORNOTEID,
                    ANPANELID,
                    ALFOOTNOTETEXT );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;

   
   PROCEDURE GETFOOTNOTES(
      ANPANELID                  IN       IAPITYPE.ID_TYPE,
      AQFOOTNOTES                OUT      IAPITYPE.REF_TYPE )
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFootNotes';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOOTNOTES FOR
         SELECT ITFOOTNOTE.FOOTNOTE_ID AS FOOTNOTEID,
                ITFOOTNOTE.HEADER AS HEADER,
                ITFOOTNOTE.TEXT AS DESCRIPTION
           FROM ITFOOTNOTE
          WHERE ITFOOTNOTE.PANEL_ID = ANPANELID;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;

   
   PROCEDURE GETFOOTNOTESLIST(
      AQFOOTNOTES                OUT      IAPITYPE.REF_TYPE )
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFootNotesList';

     LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'nut_note_id '
            || IAPICONSTANTCOLUMN.IDCOL
            || ', f_nutnote_descr( nut_note_id, 0 ) '
            || IAPICONSTANTCOLUMN.HEADERCOL
            || ', f_nutnote_long_descr( nut_note_id, 0 ) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', Intl '
            || IAPICONSTANTCOLUMN.INTLCOL
            || ', Status '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE :=    ' FROM ITNUTNOTE ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;      


   BEGIN

      
      
      
      
      
      IF ( AQFOOTNOTES%ISOPEN )
      THEN
         CLOSE AQFOOTNOTES;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOOTNOTES FOR LSSQL;   

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      
      
      
      
     
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQFOOTNOTES%ISOPEN )
      THEN
         CLOSE AQFOOTNOTES;
      END IF;

      OPEN AQFOOTNOTES FOR LSSQL;      
     
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END;

   
   PROCEDURE DELETEFOOTNOTE(
      ANFOOTNOTEID               IN       IAPITYPE.ID_TYPE )
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteFootNote';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITFOOTNOTE
            WHERE FOOTNOTE_ID = ANFOOTNOTEID;
   END;

END IAPINUTRITIONAL;