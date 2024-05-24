CREATE OR REPLACE PACKAGE BODY iapiStage
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION GETPROPERTIES(
      ANSTAGEID                  IN       IAPITYPE.ID_TYPE,
      AQSTAGEPROPERTIES          OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProperties';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT sl.property '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ', F_SPH_DESCR(1, sl.property, 0) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ', p.intl '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', p.status '
         || IAPICONSTANTCOLUMN.HISTORICCOL
         || ', F_ASH_DESCR(1, sl.association, 0) '
         || IAPICONSTANTCOLUMN.ASSOCIATIONCOL
         || ', F_UMH_DESCR(1, sl.uom_id, 0) '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', F_ATH_DESCR(1, ap.attribute, 0) '
         || IAPICONSTANTCOLUMN.ATTRIBUTECOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL
         || ', sl.stage '
         || IAPICONSTANTCOLUMN.STAGEIDCOL
         || ', sl.uom_id '
         || IAPICONSTANTCOLUMN.UOMIDCOL
         || ', sl.association '
         || IAPICONSTANTCOLUMN.ASSOCIATIONIDCOL
         || ', NVL(ap.attribute,0) '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ', MAX(ph.revision) '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ', NVL(MAX(ath.revision),100) '
         || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
         || ', MAX(ash.revision) '
         || IAPICONSTANTCOLUMN.ASSOCIATIONREVISIONCOL
         || ', MAX(uh.revision) '
         || IAPICONSTANTCOLUMN.UOMREVISIONCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ' FROM property p, stage_list sl, attribute_property ap, property_h ph, attribute_h ath, association_h ash, uom_h uh'
         || ' WHERE sl.property = ap.property(+) '
         || '   AND ap.attribute = ath.attribute(+) '
         || '   AND sl.association = ash.association(+) '
         || '   AND sl.uom_id = uh.uom_id(+) '
         || '   AND sl.property = ph.property '
         || '   AND sl.stage = :Stage '
         || '   AND ph.max_rev = 1 '
         || '   AND ath.max_rev(+) = 1 '
         || '   AND ash.max_rev(+) = 1 '
         || '   AND sl.property = p.property '
         || ' GROUP BY sl.stage, sl.property, sl.uom_id, sl.association, ap.attribute, p.intl, p.status '
         || ' UNION'
         || ' SELECT DISTINCT sl.property '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ', F_SPH_DESCR(1, sl.property, 0) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ', p.intl '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', p.status '
         || IAPICONSTANTCOLUMN.HISTORICCOL
         || ', F_ASH_DESCR(1, sl.association, 0) '
         || IAPICONSTANTCOLUMN.ASSOCIATIONCOL
         || ', F_UMH_DESCR(1, sl.uom_id, 0) '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', NULL '
         || IAPICONSTANTCOLUMN.ATTRIBUTECOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL
         || ', sl.stage '
         || IAPICONSTANTCOLUMN.STAGEIDCOL
         || ', sl.uom_id '
         || IAPICONSTANTCOLUMN.UOMIDCOL
         || ', sl.association '
         || IAPICONSTANTCOLUMN.ASSOCIATIONIDCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ', MAX(ph.revision) '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ', 100 '
         || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
         || ', MAX(ah.revision) '
         || IAPICONSTANTCOLUMN.ASSOCIATIONREVISIONCOL
         || ', MAX(uh.revision) '
         || IAPICONSTANTCOLUMN.UOMREVISIONCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ' FROM property p, stage_list sl, property_h ph, association_h ah, uom_h uh'
         || ' WHERE sl.association = ah.association(+) '
         || '   AND sl.uom_id = uh.uom_id (+) '
         || '   AND sl.property = ph.property '
         || '   AND sl.stage = :Stage '
         || '   AND ph.max_rev = 1 '
         || '   AND ah.max_rev(+) = 1 '
         || '   AND sl.property = p.property '
         || ' GROUP BY sl.stage, sl.property, sl.uom_id, sl.association, p.intl, p.status '
         || ' ORDER BY 1, 2 ASC ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSTAGEPROPERTIES%ISOPEN )
      THEN
         CLOSE AQSTAGEPROPERTIES;
      END IF;

      
      OPEN AQSTAGEPROPERTIES
       FOR LSSQL USING ANSTAGEID,
       ANSTAGEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTIES;
END IAPISTAGE;