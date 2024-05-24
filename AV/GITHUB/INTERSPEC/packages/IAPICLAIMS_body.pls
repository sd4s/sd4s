CREATE OR REPLACE PACKAGE BODY iapiClaims
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

   
   
   

   
   
   
   
   FUNCTION GETCOLUMNSCLAIMSLOG(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsClaimsLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.BASECOLUMNS_TYPE := NULL;
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
         || 'log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'log_name '
         || IAPICONSTANTCOLUMN.LOGNAMECOL
         || ','
         || LSALIAS
         || 'status '
         || IAPICONSTANTCOLUMN.STATUSIDCOL
         || ', f_rdstatus_descr( c.status ) '
         || IAPICONSTANTCOLUMN.STATUSCOL
         || ','
         || LSALIAS
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || LSALIAS
         || 'revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', f_shh_descr( 1, c.part_no ) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'Plant '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ','
         || LSALIAS
         || 'alternative '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ','
         || LSALIAS
         || 'bom_usage '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr( c.bom_usage ) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'explosion_date '
         || IAPICONSTANTCOLUMN.EXPLOSIONDATECOL
         || ','
         || LSALIAS
         || 'created_by '
         || IAPICONSTANTCOLUMN.CREATEDBYCOL
         || ','
         || LSALIAS
         || 'created_on '
         || IAPICONSTANTCOLUMN.CREATEDONCOL
         || ','
         || LSALIAS
         || 'report_type '
         || IAPICONSTANTCOLUMN.REPORTTYPECOL
         || ', f_pgh_descr( 1, c.report_type, 0 ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'loggingxml '
         || IAPICONSTANTCOLUMN.LOGGINGXMLCOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSCLAIMSLOG;

   
   FUNCTION GETCOLUMNSCLAIMSLOGRESULTS(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsClaimsLogResults';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.BASECOLUMNS_TYPE := NULL;
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
         || 'log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'property_group '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
         || ','
         || LSALIAS
         || 'property_group_rev '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPREVISIONCOL
         || ', f_pgh_descr( 1, cr.property_group, cr.property_group_rev ) '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
         || ','
         || LSALIAS
         || 'property '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ','
         || LSALIAS
         || 'property_rev '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ', f_sph_descr( 1,  cr.property, cr.property_rev ) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ','
         || LSALIAS
         || 'pg_type '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPTYPECOL
         || ','
         || LSALIAS
         || 'value '
         || IAPICONSTANTCOLUMN.VALUECOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSCLAIMSLOGRESULTS;

   
   

   
   FUNCTION GETREPORTTYPES(
      AQREPORTTYPES              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReportTypes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 2000 );
      LSSELECT                      VARCHAR2( 1000 )
         :=    ' distinct f_pgh_descr(1,property_group,0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', property_group '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
            || ', pg_type '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPTYPECOL;
      LSFROM                        VARCHAR2( 200 ) := ' from property_group,itshly ';
      LSWHERE                       VARCHAR2( 500 ) :=    ' where pg_type in (2,3) '
                                                       || ' and property_group = LY_ID '
                                                       || ' and ly_type = 1 ';
      LSORDERBY                     VARCHAR2( 200 ) := ' ORDER BY 1 ';
   BEGIN
      
      
      
      
      
      LSSQL :=    ' SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;

      OPEN AQREPORTTYPES FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    ' SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      OPEN AQREPORTTYPES FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    ' SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || LSORDERBY;

         OPEN AQREPORTTYPES FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREPORTTYPES;

   
   FUNCTION EXPLODE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANPROPERTYGROUP            IN       IAPITYPE.ID_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      
      ANUSEBOMPATH               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Explode';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNCLAIMSSEQUENCE              IAPITYPE.SEQUENCE_TYPE;
      LNCLAIM                       IAPITYPE.BOOLEAN_TYPE;
      LNCOUNT                       INTEGER;
      
      
      LSINFO1                       IAPITYPE.PARAMETERDATA_TYPE;
      LSINFO2                       IAPITYPE.PARAMETERDATA_TYPE;
      LSPARAMETERDATA               IAPITYPE.PARAMETERDATA_TYPE;
      LTLIST                        SPNUMTABLE_TYPE := SPNUMTABLE_TYPE( );
      LSPROPERTYGROUP               IAPITYPE.CLOB_TYPE;
      LQREPORTTYPES                 IAPITYPE.REF_TYPE;
      LQITEMS                       IAPITYPE.REF_TYPE;
      LQPROPERTIES                  IAPITYPE.REF_TYPE;
      LSPROPERTYGROUPDESC           IAPITYPE.DESCRIPTION_TYPE;
      LNPROPERTYGROUP               IAPITYPE.ID_TYPE;
      LNPROPERTYGROUPTYPE           IAPITYPE.BOOLEAN_TYPE;
      LSCOMPONENTPART               IAPITYPE.PARTNO_TYPE;
      LNCOMPONENTREVISION           IAPITYPE.REVISION_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LNCALCQTY                     IAPITYPE.BOMQUANTITY_TYPE;
      LRCLAIMRESULTDETAILS          IAPITYPE.CLAIMRESULTDETAILSROW_TYPE;
      LRPROPERTIES                  IAPITYPE.SPCLAIMSPROPERTYREC_TYPE;
      LRCLAIMEXPLOSION              IAPITYPE.CLAIMEXPLOSION_TYPE;
      LTCLAIMEXPLOSION              IAPITYPE.CLAIMEXPLOSIONTAB_TYPE;
      LSSELECT                      VARCHAR2( 1000 )
         :=    ' a.Part_no '
            || ', a.revision '
            || ', a.property_group '
            || ', a.property_group_rev '
            || ', a.property '
            || ', a.property_rev '
            || ', a.attribute '
            || ', a.attribute_rev '
            || ', a.num_1 '
            || ', a.num_2 '
            || ', a.num_3 '
            || ', a.num_4 '
            || ', a.num_5 '
            || ', a.num_6 '
            || ', a.num_7 '
            || ', a.num_8 '
            || ', a.num_9 '
            || ', a.num_10 '
            || ', a.char_1 '
            || ', a.char_2 '
            || ', a.char_3 '
            || ', a.char_4 '
            || ', a.char_5 '
            || ', a.char_6 '
            || ', a.info '
            || ', decode(a.boolean_1,''Y'',1,0) '
            || ', decode(a.boolean_2,''Y'',1,0) '
            || ', decode(a.boolean_3,''Y'',1,0) '
            || ', decode(a.boolean_4,''Y'',1,0) '
            || ', a.date_1 '
            || ', a.date_2 '
            || ', a.characteristic '
            || ', a.characteristic_rev '
            || ', a.ch_2 '
            || ', a.ch_rev_2 '
            || ', a.ch_3 '
            || ', a.ch_rev_3 '
            || ', a.association '
            || ', a.association_rev '
            || ', a.as_2 '
            || ', a.as_rev_2 '
            || ', a.as_3 '
            || ', a.as_rev_3 '
            || ', a.test_method '
            || ', a.test_method_rev '
            || ', (select pg_type from property_group where property_group = a.property_group) ';
      LSFROM                        VARCHAR2( 100 ) := ' FROM specification_prop a, specification_section b ';
      LSWHERE                       VARCHAR2( 600 )
         :=    ' WHERE a.property_group IN '
            || ' ( select * from TABLE ( cast(:ltList as SpNumTable_Type)  ) ) '
            || ' AND a.part_no = :lsComponentPart '
            || ' AND a.revision = :lnComponentRevision '
            || ' AND a.part_no = b.part_no '
            || ' AND a.revision = b.revision '
            || ' AND a.section_id = b.section_id '
            || ' AND a.sub_section_id = b.sub_section_id '
            || ' AND a.property_group = b.ref_id '
            || ' AND b.Type = 1 '
            || ' AND a.property_group in (select property_group from property_group where pg_type in (2, 3)) ';
      LSORDERBY                     VARCHAR2( 100 ) := 'ORDER BY a.property,a.property_group';
      LSSQL                         VARCHAR2( 2000 );

      CURSOR LCCLAIMEXPLOSION
      IS
         SELECT *
           FROM ITCLAIMEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID;

      CURSOR LCURRESULT
      IS
         SELECT DISTINCT PROPERTY_GROUP,
                         
                         PROPERTY,
                         
                         PG_TYPE
                    FROM ITCLAIMEXPLOSION
                   WHERE BOM_EXP_NO = ANUNIQUEID;

      LNCLAIMSEQUENCENO             IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      
      
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Explosion Number: '
                           || ANUNIQUEID,
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         IAPISPECIFICATIONBOM.EXPLODE( ANUNIQUEID => ANUNIQUEID,
                                       ASPARTNO => ASPARTNO,
                                       ANREVISION => ANREVISION,
                                       ASPLANT => ASPLANT,
                                       ANALTERNATIVE => ANALTERNATIVE,
                                       ANUSAGE => ANUSAGE,
                                       ADEXPLOSIONDATE => ADEXPLOSIONDATE,
                                       ANINCLUDEINDEVELOPMENT => ANINCLUDEINDEVELOPMENT,
                                      
                                       ANUSEBOMPATH => ANUSEBOMPATH,
                                       AQERRORS => AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITBOMEXPLOSION
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND COMPONENT_REVISION IS NULL;

      
      
      IF LNCOUNT > 0
      THEN
         SELECT COMPONENT_PART,
                COMPONENT_REVISION
           INTO LSPARTNO,
                LNREVISION
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND BOM_LEVEL = 0;

         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_EXPLOSIONINCOMPLETE,
                                                    LSPARTNO,
                                                    LNREVISION );
      END IF;

      DELETE FROM ITCLAIMEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITCLAIMRESULTDETAILS
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITCLAIMRESULT
            WHERE BOM_EXP_NO = ANUNIQUEID;

      IF    ANPROPERTYGROUP < 1
         OR ANPROPERTYGROUP IS NULL
      THEN
         LNRETVAL := IAPICLAIMS.GETREPORTTYPES( LQREPORTTYPES );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LOOP
            FETCH LQREPORTTYPES
             INTO LSPROPERTYGROUPDESC,
                  LNPROPERTYGROUP,
                  LNPROPERTYGROUPTYPE;

            EXIT WHEN LQREPORTTYPES%NOTFOUND;

            IF LQREPORTTYPES%ROWCOUNT = 1
            THEN
               LSPROPERTYGROUP := TO_CHAR( LNPROPERTYGROUP );
            ELSE
               LSPROPERTYGROUP :=    LSPROPERTYGROUP
                                  || ','
                                  || TO_CHAR( LNPROPERTYGROUP );
            END IF;
         END LOOP;
      ELSE
         LSPROPERTYGROUP := TO_CHAR( ANPROPERTYGROUP );
      END IF;

      LNRETVAL := IAPIGENERAL.TRANSFORMSTRINGTONUMARRAY( LSPROPERTYGROUP,
                                                         LTLIST );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'List of Property Groups: '
                           || LSPROPERTYGROUP,
                           IAPICONSTANT.INFOLEVEL_3 );
      LTCLAIMEXPLOSION.DELETE;

      FOR BE IN ( SELECT  COMPONENT_PART,
                          COMPONENT_REVISION,
                          UOM,
                          SUM( CALC_QTY ) CALC_QTY,
                          MAX( SEQUENCE_NO ) SEQUENCE_NO
                     FROM ITBOMEXPLOSION
                    WHERE BOM_EXP_NO = ANUNIQUEID
                 GROUP BY COMPONENT_PART,
                          COMPONENT_REVISION,
                          UOM )
      LOOP
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || LSORDERBY;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL,
                              IAPICONSTANT.INFOLEVEL_3 );
         LNCLAIMSSEQUENCE := 0;

         OPEN LQPROPERTIES FOR LSSQL USING LTLIST,
         BE.COMPONENT_PART,
         BE.COMPONENT_REVISION;

         LOOP
            FETCH LQPROPERTIES
             INTO LRPROPERTIES;

            EXIT WHEN LQPROPERTIES%NOTFOUND;
            LNCLAIMSSEQUENCE :=   LNCLAIMSSEQUENCE
                                + 10;
            LRCLAIMEXPLOSION.BOM_EXP_NO := ANUNIQUEID;
            LRCLAIMEXPLOSION.MOP_SEQUENCE_NO := 1;
            LRCLAIMEXPLOSION.SEQUENCE_NO := BE.SEQUENCE_NO;
            LRCLAIMEXPLOSION.CLAIMS_SEQUENCE_NO := LNCLAIMSSEQUENCE;
            LRCLAIMEXPLOSION.PART_NO := LRPROPERTIES.PARTNO;
            LRCLAIMEXPLOSION.REVISION := LRPROPERTIES.REVISION;
            LRCLAIMEXPLOSION.PROPERTY_GROUP := LRPROPERTIES.PROPERTYGROUP;
            LRCLAIMEXPLOSION.PROPERTY_GROUP_REV := LRPROPERTIES.PROPERTYGROUP_REV;
            LRCLAIMEXPLOSION.PROPERTY := LRPROPERTIES.PROPERTY;
            LRCLAIMEXPLOSION.PROPERTY_REV := LRPROPERTIES.PROPERTY_REV;
            LRCLAIMEXPLOSION.ATTRIBUTE := LRPROPERTIES.ATTRIBUTE;
            LRCLAIMEXPLOSION.ATTRIBUTE_REV := LRPROPERTIES.ATTRIBUTEREV;
            LRCLAIMEXPLOSION.NUM_1 := LRPROPERTIES.NUM1;
            LRCLAIMEXPLOSION.NUM_2 := LRPROPERTIES.NUM2;
            LRCLAIMEXPLOSION.NUM_3 := LRPROPERTIES.NUM3;
            LRCLAIMEXPLOSION.NUM_4 := LRPROPERTIES.NUM4;
            LRCLAIMEXPLOSION.NUM_5 := LRPROPERTIES.NUM5;
            LRCLAIMEXPLOSION.NUM_6 := LRPROPERTIES.NUM6;
            LRCLAIMEXPLOSION.NUM_7 := LRPROPERTIES.NUM7;
            LRCLAIMEXPLOSION.NUM_8 := LRPROPERTIES.NUM8;
            LRCLAIMEXPLOSION.NUM_9 := LRPROPERTIES.NUM9;
            LRCLAIMEXPLOSION.NUM_10 := LRPROPERTIES.NUM10;
            LRCLAIMEXPLOSION.CHAR_1 := LRPROPERTIES.CHAR1;
            LRCLAIMEXPLOSION.CHAR_2 := LRPROPERTIES.CHAR2;
            LRCLAIMEXPLOSION.CHAR_3 := LRPROPERTIES.CHAR3;
            LRCLAIMEXPLOSION.CHAR_4 := LRPROPERTIES.CHAR4;
            LRCLAIMEXPLOSION.CHAR_5 := LRPROPERTIES.CHAR5;
            LRCLAIMEXPLOSION.CHAR_6 := LRPROPERTIES.CHAR6;
            LRCLAIMEXPLOSION.INFO := LRPROPERTIES.INFO;
            LRCLAIMEXPLOSION.BOOLEAN_1 := LRPROPERTIES.BOOLEAN1;
            LRCLAIMEXPLOSION.BOOLEAN_2 := LRPROPERTIES.BOOLEAN2;
            LRCLAIMEXPLOSION.BOOLEAN_3 := LRPROPERTIES.BOOLEAN3;
            LRCLAIMEXPLOSION.BOOLEAN_4 := LRPROPERTIES.BOOLEAN4;
            LRCLAIMEXPLOSION.DATE_1 := LRPROPERTIES.DATE1;
            LRCLAIMEXPLOSION.DATE_2 := LRPROPERTIES.DATE2;
            LRCLAIMEXPLOSION.CHARACTERISTIC_1 := LRPROPERTIES.CHARACTERISTIC1;
            LRCLAIMEXPLOSION.CHARACTERISTIC_REV_1 := LRPROPERTIES.CHARACTERISTICREV1;
            LRCLAIMEXPLOSION.CHARACTERISTIC_2 := LRPROPERTIES.CHARACTERISTIC2;
            LRCLAIMEXPLOSION.CHARACTERISTIC_REV_2 := LRPROPERTIES.CHARACTERISTICREV2;
            LRCLAIMEXPLOSION.CHARACTERISTIC_3 := LRPROPERTIES.CHARACTERISTIC;
            LRCLAIMEXPLOSION.CHARACTERISTIC_REV_3 := LRPROPERTIES.CHARACTERISTICREV3;
            LRCLAIMEXPLOSION.ASSOCIATION_1 := LRPROPERTIES.ASSOCIATION1;
            LRCLAIMEXPLOSION.ASSOCIATION_REV_1 := LRPROPERTIES.ASSOCIATIONREV1;
            LRCLAIMEXPLOSION.ASSOCIATION_2 := LRPROPERTIES.ASSOCIATION2;
            LRCLAIMEXPLOSION.ASSOCIATION_REV_2 := LRPROPERTIES.ASSOCIATIONREV2;
            LRCLAIMEXPLOSION.ASSOCIATION_3 := LRPROPERTIES.ASSOCIATION3;
            LRCLAIMEXPLOSION.ASSOCIATION_REV_3 := LRPROPERTIES.ASSOCIATIONREV3;
            LRCLAIMEXPLOSION.TEST_METHOD := LRPROPERTIES.TESTMETHOD;
            LRCLAIMEXPLOSION.TEST_METHOD_REV := LRPROPERTIES.TESTMETHODREV;
            LRCLAIMEXPLOSION.CALC_QTY := BE.CALC_QTY;
            LRCLAIMEXPLOSION.UOM := BE.UOM;
            LRCLAIMEXPLOSION.PG_TYPE := LRPROPERTIES.PROPERTYGROUPTYPE;
            LTCLAIMEXPLOSION(   LTCLAIMEXPLOSION.COUNT
                              + 1 ) := LRCLAIMEXPLOSION;

            INSERT INTO ITCLAIMEXPLOSION
                        ( BOM_EXP_NO,
                          MOP_SEQUENCE_NO,
                          SEQUENCE_NO,
                          CLAIMS_SEQUENCE_NO,
                          PART_NO,
                          REVISION,
                          PROPERTY_GROUP,
                          PROPERTY_GROUP_REV,
                          PROPERTY,
                          PROPERTY_REV,
                          ATTRIBUTE,
                          ATTRIBUTE_REV,
                          NUM_1,
                          NUM_2,
                          NUM_3,
                          NUM_4,
                          NUM_5,
                          NUM_6,
                          NUM_7,
                          NUM_8,
                          NUM_9,
                          NUM_10,
                          CHAR_1,
                          CHAR_2,
                          CHAR_3,
                          CHAR_4,
                          CHAR_5,
                          CHAR_6,
                          INFO,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CHARACTERISTIC_1,
                          CHARACTERISTIC_REV_1,
                          CHARACTERISTIC_2,
                          CHARACTERISTIC_REV_2,
                          CHARACTERISTIC_3,
                          CHARACTERISTIC_REV_3,
                          ASSOCIATION_1,
                          ASSOCIATION_REV_1,
                          ASSOCIATION_2,
                          ASSOCIATION_REV_2,
                          ASSOCIATION_3,
                          ASSOCIATION_REV_3,
                          TEST_METHOD,
                          TEST_METHOD_REV,
                          CALC_QTY,
                          UOM,
                          PG_TYPE )
                 VALUES ( LRCLAIMEXPLOSION.BOM_EXP_NO,
                          LRCLAIMEXPLOSION.MOP_SEQUENCE_NO,
                          LRCLAIMEXPLOSION.SEQUENCE_NO,
                          LRCLAIMEXPLOSION.CLAIMS_SEQUENCE_NO,
                          LRCLAIMEXPLOSION.PART_NO,
                          LRCLAIMEXPLOSION.REVISION,
                          LRCLAIMEXPLOSION.PROPERTY_GROUP,
                          LRCLAIMEXPLOSION.PROPERTY_GROUP_REV,
                          LRCLAIMEXPLOSION.PROPERTY,
                          LRCLAIMEXPLOSION.PROPERTY_REV,
                          LRCLAIMEXPLOSION.ATTRIBUTE,
                          LRCLAIMEXPLOSION.ATTRIBUTE_REV,
                          LRCLAIMEXPLOSION.NUM_1,
                          LRCLAIMEXPLOSION.NUM_2,
                          LRCLAIMEXPLOSION.NUM_3,
                          LRCLAIMEXPLOSION.NUM_4,
                          LRCLAIMEXPLOSION.NUM_5,
                          LRCLAIMEXPLOSION.NUM_6,
                          LRCLAIMEXPLOSION.NUM_7,
                          LRCLAIMEXPLOSION.NUM_8,
                          LRCLAIMEXPLOSION.NUM_9,
                          LRCLAIMEXPLOSION.NUM_10,
                          LRCLAIMEXPLOSION.CHAR_1,
                          LRCLAIMEXPLOSION.CHAR_2,
                          LRCLAIMEXPLOSION.CHAR_3,
                          LRCLAIMEXPLOSION.CHAR_4,
                          LRCLAIMEXPLOSION.CHAR_5,
                          LRCLAIMEXPLOSION.CHAR_6,
                          LRCLAIMEXPLOSION.INFO,
                          LRCLAIMEXPLOSION.BOOLEAN_1,
                          LRCLAIMEXPLOSION.BOOLEAN_2,
                          LRCLAIMEXPLOSION.BOOLEAN_3,
                          LRCLAIMEXPLOSION.BOOLEAN_4,
                          LRCLAIMEXPLOSION.DATE_1,
                          LRCLAIMEXPLOSION.DATE_2,
                          LRCLAIMEXPLOSION.CHARACTERISTIC_1,
                          LRCLAIMEXPLOSION.CHARACTERISTIC_REV_1,
                          LRCLAIMEXPLOSION.CHARACTERISTIC_2,
                          LRCLAIMEXPLOSION.CHARACTERISTIC_REV_2,
                          LRCLAIMEXPLOSION.CHARACTERISTIC_3,
                          LRCLAIMEXPLOSION.CHARACTERISTIC_REV_3,
                          LRCLAIMEXPLOSION.ASSOCIATION_1,
                          LRCLAIMEXPLOSION.ASSOCIATION_REV_1,
                          LRCLAIMEXPLOSION.ASSOCIATION_2,
                          LRCLAIMEXPLOSION.ASSOCIATION_REV_2,
                          LRCLAIMEXPLOSION.ASSOCIATION_3,
                          LRCLAIMEXPLOSION.ASSOCIATION_REV_3,
                          LRCLAIMEXPLOSION.TEST_METHOD,
                          LRCLAIMEXPLOSION.TEST_METHOD_REV,
                          LRCLAIMEXPLOSION.CALC_QTY,
                          LRCLAIMEXPLOSION.UOM,
                          LRCLAIMEXPLOSION.PG_TYPE );

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Inserted in ITCLAIMSEXPLOSION '
                                 || LNCLAIMSSEQUENCE,
                                 IAPICONSTANT.INFOLEVEL_3 );
         END LOOP;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Get the INFO columns, these are configurable (char_1..6) and shown in the detailed results',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT A.PARAMETER_DATA
        INTO LSPARAMETERDATA
        FROM INTERSPC_CFG A
       WHERE A.SECTION = 'claim_detail'
         AND A.PARAMETER = 'column1';

      IF    UPPER( LSPARAMETERDATA ) IN
               ( 'CHAR_1', 'CHAR_2', 'CHAR_3', 'CHAR_4', 'CHAR_5', 'CHAR_6', 'NUM_1', 'NUM_2', 'NUM_3', 'NUM_4', 'NUM_5', 'NUM_6', 'NUM_7', 'NUM_8',
                 'NUM_9', 'NUM_10' )
         OR LSPARAMETERDATA = NULL
      THEN
         LSINFO1 := UPPER( LSPARAMETERDATA );
      ELSE
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'Invalid Configuration for parameter ''column1'' in section ''claim_detail'' (Value: '
                               || LSPARAMETERDATA
                               || ')' );
      END IF;

      SELECT A.PARAMETER_DATA
        INTO LSPARAMETERDATA
        FROM INTERSPC_CFG A
       WHERE A.SECTION = 'claim_detail'
         AND A.PARAMETER = 'column2';

      IF    UPPER( LSPARAMETERDATA ) IN
               ( 'CHAR_1', 'CHAR_2', 'CHAR_3', 'CHAR_4', 'CHAR_5', 'CHAR_6', 'NUM_1', 'NUM_2', 'NUM_3', 'NUM_4', 'NUM_5', 'NUM_6', 'NUM_7', 'NUM_8',
                 'NUM_9', 'NUM_10' )
         OR LSPARAMETERDATA = NULL
      THEN
         LSINFO2 := UPPER( LSPARAMETERDATA );
      ELSE
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'Invalid Configuration for parameter ''column2'' in section ''claim_detail''(Value: '
                               || LSPARAMETERDATA
                               || ')' );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lnInfo 1:'
                           || LSINFO1,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lnInfo 2:'
                           || LSINFO2,
                           IAPICONSTANT.INFOLEVEL_3 );
      LTCLAIMEXPLOSION.DELETE;

      OPEN LCCLAIMEXPLOSION;

      
      LOOP
         FETCH LCCLAIMEXPLOSION
         BULK COLLECT INTO LTCLAIMEXPLOSION LIMIT 50;

         IF LTCLAIMEXPLOSION.COUNT > 0
         THEN
            FOR I IN LTCLAIMEXPLOSION.FIRST .. LTCLAIMEXPLOSION.LAST
            LOOP
               SELECT   NVL( MAX( SEQUENCE_NO ),
                             0 )
                      + 10
                 INTO LNCLAIMSEQUENCENO
                 FROM ITCLAIMRESULTDETAILS
                WHERE BOM_EXP_NO = ANUNIQUEID
                  AND PART_NO = LTCLAIMEXPLOSION( I ).PART_NO
                  AND REVISION = LTCLAIMEXPLOSION( I ).REVISION
                  AND PROPERTY_GROUP = LTCLAIMEXPLOSION( I ).PROPERTY_GROUP
                  AND PROPERTY = LTCLAIMEXPLOSION( I ).PROPERTY;

               INSERT INTO ITCLAIMRESULTDETAILS
                           ( BOM_EXP_NO,
                             PART_NO,
                             REVISION,
                             PROPERTY_GROUP,
                             PROPERTY_GROUP_REV,
                             PROPERTY,
                             PROPERTY_REV,
                             SEQUENCE_NO,
                             CALC_QTY,
                             UOM,
                             PG_TYPE,
                             CLAIM,
                             INFO1,
                             INFO2 )
                    VALUES ( ANUNIQUEID,
                             LTCLAIMEXPLOSION( I ).PART_NO,
                             LTCLAIMEXPLOSION( I ).REVISION,
                             LTCLAIMEXPLOSION( I ).PROPERTY_GROUP,
                             LTCLAIMEXPLOSION( I ).PROPERTY_GROUP_REV,
                             LTCLAIMEXPLOSION( I ).PROPERTY,
                             LTCLAIMEXPLOSION( I ).PROPERTY_REV,
                             LNCLAIMSEQUENCENO,
                             LTCLAIMEXPLOSION( I ).CALC_QTY,
                             LTCLAIMEXPLOSION( I ).UOM,
                             LTCLAIMEXPLOSION( I ).PG_TYPE,
                             DECODE( LTCLAIMEXPLOSION( I ).BOOLEAN_1,
                                     1, 1,
                                     0 ),
                             DECODE( LSINFO1,
                                     'CHAR_1', LTCLAIMEXPLOSION( I ).CHAR_1,
                                     'CHAR_2', LTCLAIMEXPLOSION( I ).CHAR_2,
                                     'CHAR_3', LTCLAIMEXPLOSION( I ).CHAR_3,
                                     'CHAR_4', LTCLAIMEXPLOSION( I ).CHAR_4,
                                     'CHAR_5', LTCLAIMEXPLOSION( I ).CHAR_5,
                                     'CHAR_6', LTCLAIMEXPLOSION( I ).CHAR_6,
                                     'NUM_1', LTCLAIMEXPLOSION( I ).NUM_1,
                                     'NUM_2', LTCLAIMEXPLOSION( I ).NUM_2,
                                     'NUM_3', LTCLAIMEXPLOSION( I ).NUM_3,
                                     'NUM_4', LTCLAIMEXPLOSION( I ).NUM_4,
                                     'NUM_5', LTCLAIMEXPLOSION( I ).NUM_5,
                                     'NUM_6', LTCLAIMEXPLOSION( I ).NUM_6,
                                     'NUM_7', LTCLAIMEXPLOSION( I ).NUM_7,
                                     'NUM_8', LTCLAIMEXPLOSION( I ).NUM_8,
                                     'NUM_9', LTCLAIMEXPLOSION( I ).NUM_9,
                                     'NUM_10', LTCLAIMEXPLOSION( I ).NUM_10,
                                     NULL ),
                             DECODE( LSINFO2,
                                     'CHAR_1', LTCLAIMEXPLOSION( I ).CHAR_1,
                                     'CHAR_2', LTCLAIMEXPLOSION( I ).CHAR_2,
                                     'CHAR_3', LTCLAIMEXPLOSION( I ).CHAR_3,
                                     'CHAR_4', LTCLAIMEXPLOSION( I ).CHAR_4,
                                     'CHAR_5', LTCLAIMEXPLOSION( I ).CHAR_5,
                                     'CHAR_6', LTCLAIMEXPLOSION( I ).CHAR_6,
                                     'NUM_1', LTCLAIMEXPLOSION( I ).NUM_1,
                                     'NUM_2', LTCLAIMEXPLOSION( I ).NUM_2,
                                     'NUM_3', LTCLAIMEXPLOSION( I ).NUM_3,
                                     'NUM_4', LTCLAIMEXPLOSION( I ).NUM_4,
                                     'NUM_5', LTCLAIMEXPLOSION( I ).NUM_5,
                                     'NUM_6', LTCLAIMEXPLOSION( I ).NUM_6,
                                     'NUM_7', LTCLAIMEXPLOSION( I ).NUM_7,
                                     'NUM_8', LTCLAIMEXPLOSION( I ).NUM_8,
                                     'NUM_9', LTCLAIMEXPLOSION( I ).NUM_9,
                                     'NUM_10', LTCLAIMEXPLOSION( I ).NUM_10,
                                     NULL ) );
            END LOOP;
         END IF;

         EXIT WHEN LCCLAIMEXPLOSION%NOTFOUND;
      END LOOP;

      CLOSE LCCLAIMEXPLOSION;

      INSERT INTO ITCLAIMRESULT
                  ( BOM_EXP_NO,
                    PROPERTY_GROUP,
                    PROPERTY_GROUP_REV,
                    PROPERTY,
                    PROPERTY_REV,
                    PG_TYPE )
         SELECT DISTINCT A.BOM_EXP_NO,
                         A.PROPERTY_GROUP,
                         GETMAXCLAIMSPROPERTYGROUPREV( A.BOM_EXP_NO,
                                                       A.PROPERTY_GROUP ),
                         A.PROPERTY,
                         GETMAXCLAIMSPROPERTYREV( A.BOM_EXP_NO,
                                                  A.PROPERTY,
                                                  A.PROPERTY_GROUP ),
                         A.PG_TYPE
                    FROM ITCLAIMEXPLOSION A
                   WHERE BOM_EXP_NO = ANUNIQUEID;

      FOR LREC IN LCURRESULT
      LOOP
         LRCLAIMRESULTDETAILS := NULL;
         LRCLAIMRESULTDETAILS.BOM_EXP_NO := ANUNIQUEID;
         LRCLAIMRESULTDETAILS.PROPERTY_GROUP := LREC.PROPERTY_GROUP;

         SELECT MAX( PROPERTY_GROUP_REV )
           INTO LRCLAIMRESULTDETAILS.PROPERTY_GROUP_REV
           FROM ITCLAIMEXPLOSION A
          WHERE A.BOM_EXP_NO = ANUNIQUEID
            AND A.PROPERTY_GROUP = LREC.PROPERTY_GROUP;

         LRCLAIMRESULTDETAILS.PROPERTY := LREC.PROPERTY;

         SELECT MAX( PROPERTY_REV )
           INTO LRCLAIMRESULTDETAILS.PROPERTY_REV
           FROM ITCLAIMEXPLOSION A
          WHERE A.BOM_EXP_NO = ANUNIQUEID
            AND A.PROPERTY = LREC.PROPERTY;


         LRCLAIMRESULTDETAILS.PG_TYPE := LREC.PG_TYPE;
         LRCLAIMRESULTDETAILS.CLAIM := -1;
         LRCLAIMRESULTDETAILS.INFO1 := NULL;
         LRCLAIMRESULTDETAILS.INFO2 := NULL;
         LRCLAIMRESULTDETAILS.CLAIM_RESULT := NULL;

         
         
         FOR LRING IN ( SELECT  A.COMPONENT_PART PART_NO,
                                A.COMPONENT_REVISION REVISION,
                                UOM,
                                SUM( CALC_QTY ) CALC_QTY
                           FROM ITBOMEXPLOSION A,
                                CLASS3 B
                          WHERE A.BOM_EXP_NO = ANUNIQUEID
                            AND A.PART_TYPE = B.CLASS
                            AND B.TYPE = IAPICONSTANT.SPECTYPEGROUP_INGREDIENT
                            AND ( A.COMPONENT_PART, A.COMPONENT_REVISION ) NOT IN(
                                             SELECT A.PART_NO,
                                                    A.REVISION
                                               FROM ITCLAIMEXPLOSION A
                                              WHERE A.BOM_EXP_NO = ANUNIQUEID
                                                AND A.PROPERTY_GROUP = LREC.PROPERTY_GROUP
                                                AND A.PROPERTY = LREC.PROPERTY )
                       GROUP BY A.COMPONENT_PART,
                                A.COMPONENT_REVISION,
                                UOM )
         LOOP
            LRCLAIMRESULTDETAILS.PART_NO := LRING.PART_NO;
            LRCLAIMRESULTDETAILS.REVISION := LRING.REVISION;
            LRCLAIMRESULTDETAILS.CALC_QTY := LRING.CALC_QTY;
            LRCLAIMRESULTDETAILS.UOM := LRING.UOM;

            SELECT   NVL( MAX( SEQUENCE_NO ),
                          0 )
                   + 10
              INTO LNCLAIMSEQUENCENO
              FROM ITCLAIMRESULTDETAILS
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND PART_NO = LRCLAIMRESULTDETAILS.PART_NO
               AND REVISION = LRCLAIMRESULTDETAILS.REVISION
               AND PROPERTY_GROUP = LRCLAIMRESULTDETAILS.PROPERTY_GROUP
               AND PROPERTY = LRCLAIMRESULTDETAILS.PROPERTY;

            INSERT INTO ITCLAIMRESULTDETAILS
                        ( BOM_EXP_NO,
                          PART_NO,
                          REVISION,
                          PROPERTY_GROUP,
                          PROPERTY_GROUP_REV,
                          PROPERTY,
                          PROPERTY_REV,
                          SEQUENCE_NO,
                          CALC_QTY,
                          UOM,
                          PG_TYPE,
                          CLAIM,
                          INFO1,
                          INFO2,
                          CLAIM_RESULT )
                 VALUES ( LRCLAIMRESULTDETAILS.BOM_EXP_NO,
                          LRCLAIMRESULTDETAILS.PART_NO,
                          LRCLAIMRESULTDETAILS.REVISION,
                          LRCLAIMRESULTDETAILS.PROPERTY_GROUP,
                          LRCLAIMRESULTDETAILS.PROPERTY_GROUP_REV,
                          LRCLAIMRESULTDETAILS.PROPERTY,
                          LRCLAIMRESULTDETAILS.PROPERTY_REV,

                          LNCLAIMSEQUENCENO,
                          LRCLAIMRESULTDETAILS.CALC_QTY,
                          LRCLAIMRESULTDETAILS.UOM,
                          LRCLAIMRESULTDETAILS.PG_TYPE,
                          LRCLAIMRESULTDETAILS.CLAIM,
                          LRCLAIMRESULTDETAILS.INFO1,
                          LRCLAIMRESULTDETAILS.INFO2,
                          LRCLAIMRESULTDETAILS.CLAIM_RESULT );
         END LOOP;

         
         
         
         
         
         
         
         
         
         
         

         IF LREC.PG_TYPE = 2
         THEN
            
            
            
            
            
            
                
                
                
            
                 
                 
                 
                    
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ( SELECT DISTINCT PART_NO,
                                     REVISION
                               FROM ITCLAIMRESULTDETAILS
                              WHERE BOM_EXP_NO = ANUNIQUEID
                                AND PROPERTY_GROUP = LREC.PROPERTY_GROUP
                                AND PROPERTY = LREC.PROPERTY
                                AND CLAIM = 0 );

            IF LNCOUNT > 0
            THEN
               LNCLAIM := 0;
            ELSE
	       
	       
               
               
               
               
               
               
               
               
               

               
               
               
               
               
               
               
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM ( SELECT DISTINCT PART_NO,
                                        REVISION
                                  FROM ITCLAIMRESULTDETAILS
                                 WHERE BOM_EXP_NO = ANUNIQUEID
                                   AND PROPERTY_GROUP = LREC.PROPERTY_GROUP
                                   AND PROPERTY = LREC.PROPERTY
                                   AND CLAIM = -1 );

               IF LNCOUNT > 0
               THEN
                  LNCLAIM := 3;   
               ELSE
                  LNCLAIM := 1;   
               END IF;
	       
            END IF;
         ELSIF LREC.PG_TYPE = 3
         THEN
            
            
            
            
	    
            
                
                
                
            
                 
                 
                 
                    
	    
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ( SELECT DISTINCT PART_NO,
                                     REVISION
                               FROM ITCLAIMRESULTDETAILS
                              WHERE BOM_EXP_NO = ANUNIQUEID
                                AND PROPERTY_GROUP = LREC.PROPERTY_GROUP
                                AND PROPERTY = LREC.PROPERTY
                                AND CLAIM = 1 );

            IF LNCOUNT > 0
            THEN
               LNCLAIM := 1;
            ELSE

               
               
               
               
               
               
               
               
               
               

               
               
               
               
               
               
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM ( SELECT DISTINCT PART_NO,
                                        REVISION
                                  FROM ITCLAIMRESULTDETAILS
                                 WHERE BOM_EXP_NO = ANUNIQUEID
                                   AND PROPERTY_GROUP = LREC.PROPERTY_GROUP
                                   AND PROPERTY = LREC.PROPERTY
                                   AND CLAIM = -1 );

               IF LNCOUNT > 0
               THEN
                  LNCLAIM := 2;   
               ELSE
                  LNCLAIM := 0;   
               END IF;
               

            END IF;
         END IF;

         UPDATE ITCLAIMRESULT
            SET CLAIM = LNCLAIM
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND PROPERTY_GROUP = LREC.PROPERTY_GROUP
            AND PROPERTY = LREC.PROPERTY;

         UPDATE ITCLAIMRESULTDETAILS
            SET CLAIM_RESULT = LNCLAIM
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND PROPERTY_GROUP = LREC.PROPERTY_GROUP
            AND PROPERTY = LREC.PROPERTY;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODE;

   
   FUNCTION GETEXPLOSION(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExplosion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      VARCHAR2( 1000 )
         :=    ' bom_exp_no '
            || IAPICONSTANTCOLUMN.UNIQUEIDCOL
            || ' ,mop_sequence_no '
            || IAPICONSTANTCOLUMN.MOPSEQUENCECOL
            || ' ,sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ' ,claims_sequence_no '
            || IAPICONSTANTCOLUMN.CLAIMSSEQUENCECOL
            || ' ,part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ' ,revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ' ,f_find_part_descr(part_no) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,property_group '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
            || ' ,property '
            || IAPICONSTANTCOLUMN.PROPERTYCOL
            || ' ,property_rev '
            || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
            || ' ,attribute '
            || IAPICONSTANTCOLUMN.ATTRIBUTECOL
            || ' ,attribute_rev '
            || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
            || ' ,decode(boolean_1,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.BOOLEAN1COL;
      LSFROM                        VARCHAR2( 100 ) := ' FROM itclaimexplosion ';
      LSWHERE                       VARCHAR2( 100 ) := ' WHERE bom_exp_no = :anUniqueId ';
      LSORDERBY                     VARCHAR2( 100 ) := ' ORDER BY 1,2,3,4 ';
      LSSQL                         VARCHAR2( 2000 );
   BEGIN
      
      
      
      
      
      LSSQL :=    ' SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    ' SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    ' SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || LSORDERBY;

         OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXPLOSION;

   
   FUNCTION GETINFOHEADER(
      ANCOLUMN                   IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LDESCRIPTION1                 IAPITYPE.DESCRIPTION_TYPE;
      LDESCRIPTION2                 IAPITYPE.DESCRIPTION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetInfoHeader';
   BEGIN
      SELECT F_HDH_DESCR( 1,
                          A.PARAMETER_DATA,
                          0 ),
             F_HDH_DESCR( 1,
                          B.PARAMETER_DATA,
                          0 )
        INTO LDESCRIPTION1,
             LDESCRIPTION2
        FROM INTERSPC_CFG A,
             INTERSPC_CFG B
       WHERE A.SECTION = 'claim_detail'
         AND B.SECTION = 'claim_detail'
         AND A.PARAMETER = 'column1_header'
         AND B.PARAMETER = 'column2_header';

      IF ANCOLUMN = 1
      THEN
         ASDESCRIPTION := LDESCRIPTION1;
      ELSIF ANCOLUMN = 2
      THEN
         ASDESCRIPTION := LDESCRIPTION2;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINFOHEADER;

   
   FUNCTION GETRESULT(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQRESULT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 20480 );



   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT PROPERTY_GROUP '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
         || ', F_PGH_DESCR(1, PROPERTY_GROUP, PROPERTY_GROUP_REV) '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
         || ', F_SPH_DESCR(1, PROPERTY, PROPERTY_REV) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ', PROPERTY '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ', CLAIM '
         || IAPICONSTANTCOLUMN.CLAIMRESULTCOL
         || ' FROM ITCLAIMRESULT WHERE BOM_EXP_NO = :anUniqueId '
         || ' ORDER BY 2,3 ';

      IF ( AQRESULT%ISOPEN )
      THEN
         CLOSE AQRESULT;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQRESULT FOR LSSQL USING ANUNIQUEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRESULT;


   FUNCTION GETRESULTDETAILS(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQRESULT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetResultDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 20480 );



   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', F_SH_DESCR(1, PART_NO, REVISION) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ', CALC_QTY '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', PROPERTY_GROUP '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
         || ', PROPERTY_GROUP_REV '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPREVISIONCOL
         || ', F_PGH_DESCR(1, PROPERTY_GROUP, PROPERTY_GROUP_REV) '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
         || ', F_SPH_DESCR(1, PROPERTY, PROPERTY_REV) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ', PROPERTY '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ', PROPERTY_REV '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ', CLAIM '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', INFO1 '
         || IAPICONSTANTCOLUMN.INFO1COL
         || ', INFO2 '
         || IAPICONSTANTCOLUMN.INFO2COL
         || ', CLAIM_RESULT '
         || IAPICONSTANTCOLUMN.CLAIMRESULTCOL
         || ', PG_TYPE '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPTYPECOL
         || ' FROM ITCLAIMRESULTDETAILS WHERE BOM_EXP_NO = :anUniqueId  '
         || ' ORDER BY 8,9';

      IF ( AQRESULT%ISOPEN )
      THEN
         CLOSE AQRESULT;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQRESULT FOR LSSQL USING ANUNIQUEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRESULTDETAILS;

   
   FUNCTION GETCLAIMSLOG(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQCLAIMLOGS                OUT      IAPITYPE.REF_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetClaimsLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETCOLUMNSCLAIMSLOG( 'c' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itclaimlog c';
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      
			NROFREV                       NUMBER;
      CURSOR REVISIONCURSOR
       IS
         SELECT REVISION FROM SPECIFICATION_HEADER WHERE PART_NO = ASPARTNO;
      
   BEGIN
      
      
      
      
      
      IF ( AQCLAIMLOGS%ISOPEN )
      THEN
         CLOSE AQCLAIMLOGS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE c.log_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQCLAIMLOGS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      DBMS_SESSION.SET_CONTEXT( 'IACCLAIMLOG',
                                'ASPARTNO',
                                ASPARTNO );
      LSSQL :=    LSSQL
               || ' WHERE part_no = '
               || ' sys_context(''IACCLAIMLOG'',''ASPARTNO'')'

      
       
       
      
			









 


							 || ' AND ( ' ;

			SELECT COUNT(REVISION) INTO NROFREV FROM SPECIFICATION_HEADER WHERE PART_NO = ASPARTNO;
			FOR ANREVISION IN REVISIONCURSOR
			LOOP
					IF NROFREV <> 0
					THEN
						IF F_CHECK_ACCESS(ASPARTNO,ANREVISION.REVISION) = 1
							THEN
									 NROFREV := NROFREV -1;                                           
									 LSSQL :=    LSSQL
														|| ' revision = '
														|| ANREVISION.REVISION 
														|| ' OR ' ;
			                   
						ELSE
									 NROFREV := NROFREV -1; 
						END IF;
					END IF;
			END LOOP;
			LSSQL :=    LSSQL
							 || '  1 = 0 ) '; 
			

      IF ASPLANT IS NOT NULL
      THEN
         DBMS_SESSION.SET_CONTEXT( 'IACCLAIMLOG',
                                   'asPlant',
                                   ASPLANT );
         LSSQL :=    LSSQL
                  || ' AND plant = '
                  || ' sys_context(''IACCLAIMLOG'',''ASPLANT'')';
      END IF;

      IF ANALTERNATIVE IS NOT NULL
      THEN
         DBMS_SESSION.SET_CONTEXT( 'IACCLAIMLOG',
                                   'anAlternative',
                                   ANALTERNATIVE );
         LSSQL :=    LSSQL
                  || ' AND alternative = '
                  || ' sys_context(''IACCLAIMLOG'',''ANALTERNATIVE'')';
      END IF;

      IF ANUSAGE IS NOT NULL
      THEN
         DBMS_SESSION.SET_CONTEXT( 'IACCLAIMLOG',
                                   'anUsage',
                                   ANUSAGE );
         LSSQL :=    LSSQL
                  || ' AND bom_usage = '
                  || ' sys_context(''IACCLAIMLOG'',''ANUSAGE'')';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY c.log_name';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQCLAIMLOGS%ISOPEN )
      THEN
         CLOSE AQCLAIMLOGS;
      END IF;

      OPEN AQCLAIMLOGS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCLAIMSLOG;

   
   FUNCTION GETCLAIMSLOGRESULT(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      AQCLAIMSLOGRESULTS         OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetClaimsLogResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETCOLUMNSCLAIMSLOGRESULTS( 'cr' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itclaimlogresult cr';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE cr.log_id = :LogId';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQCLAIMSLOGRESULTS%ISOPEN )
      THEN
         CLOSE AQCLAIMSLOGRESULTS;
      END IF;

      
      OPEN AQCLAIMSLOGRESULTS FOR LSSQL USING ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCLAIMSLOGRESULT;

   
   FUNCTION ADDCLAIMSLOG(
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ANREPORTTYPE               IN       IAPITYPE.ID_TYPE,
      ALLOGGINGXML               IN       IAPITYPE.CLOB_TYPE,
      ANLOGID                    OUT      IAPITYPE.LOGID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddClaimsLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASLOGNAME IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LogName' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLogName',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSTATUS IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Status' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStatus',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ALLOGGINGXML IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LoggingXml' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'alLoggingXml',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         RETURN IAPICONSTANTDBERROR.DBERR_ERRORLIST;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITCLAIMLOG
                  ( LOG_ID,
                    LOG_NAME,
                    STATUS,
                    PART_NO,
                    REVISION,
                    PLANT,
                    ALTERNATIVE,
                    BOM_USAGE,
                    EXPLOSION_DATE,
                    CREATED_BY,
                    CREATED_ON,
                    REPORT_TYPE,
                    LOGGINGXML )
           VALUES ( RDLOG_SEQ.NEXTVAL,
                    ASLOGNAME,
                    ANSTATUS,
                    ASPARTNO,
                    ANREVISION,
                    ASPLANT,
                    ANALTERNATIVE,
                    ANBOMUSAGE,
                    ADEXPLOSIONDATE,
                    USER,
                    SYSDATE,
                    ANREPORTTYPE,
                    ALLOGGINGXML );

      
      SELECT RDLOG_SEQ.CURRVAL
        INTO ANLOGID
        FROM DUAL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDCLAIMSLOG;

   
   FUNCTION ADDCLAIMSLOGRESULT(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ANPROPERTYGROUP            IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPREV         IN       IAPITYPE.REVISION_TYPE,
      ANPROPERTY                 IN       IAPITYPE.ID_TYPE,
      ANPROPERTYREVISION         IN       IAPITYPE.REVISION_TYPE,
      ANPROPERTYGROUPTYPE        IN       IAPITYPE.BOOLEAN_TYPE,
      ANVALUE                    IN       IAPITYPE.CLAIMSRESULTTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddClaimsLogResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANLOGID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LogId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLogId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTYGROUP IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyGroup' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyGroup',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTYGROUPREV IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyGroupRevision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyGroupRev',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTY IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Property' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anProperty',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTYREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyRevision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyRev',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTYGROUPTYPE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyGroupType' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyGroupType',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANVALUE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Value' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anValue',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         RETURN IAPICONSTANTDBERROR.DBERR_ERRORLIST;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         INSERT INTO ITCLAIMLOGRESULT
                     ( LOG_ID,
                       PROPERTY_GROUP,
                       PROPERTY_GROUP_REV,
                       PROPERTY,
                       PROPERTY_REV,
                       PG_TYPE,
                       VALUE )
              VALUES ( ANLOGID,
                       ANPROPERTYGROUP,
                       ANPROPERTYGROUPREV,
                       ANPROPERTY,
                       ANPROPERTYREVISION,
                       ANPROPERTYGROUPTYPE,
                       ANVALUE );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_CLAIMLOGRESALREADYEXISTS,
                                                        ANLOGID,
                                                        
                                                        
                                                        
                                                        F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANPROPERTYGROUP, 0),
                                                        F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANPROPERTY, 0) ));
                                                        
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDCLAIMSLOGRESULT;

   
   FUNCTION SAVECLAIMSLOG(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveClaimsLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      
      
      
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASLOGNAME IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LogName' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLogName',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSTATUS IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Status' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStatus',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         RETURN IAPICONSTANTDBERROR.DBERR_ERRORLIST;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITCLAIMLOG
         SET LOG_NAME = ASLOGNAME,
             STATUS = ANSTATUS
       WHERE LOG_ID = ANLOGID;

      IF SQL%NOTFOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_CLAIMLOGNOTFOUND,
                                                     ANLOGID ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVECLAIMSLOG;

   
   FUNCTION GETMAXCLAIMSPROPERTYGROUPREV(
      ANUNIQUEID                          IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID                   IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.REVISION_TYPE
   AS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMaxClaimsPropertyGroupRev';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPROPERTYGROUPREV            IAPITYPE.REVISION_TYPE;
   BEGIN
      SELECT MAX( B.PROPERTY_GROUP_REV )
        INTO LNPROPERTYGROUPREV
        FROM ITCLAIMEXPLOSION B
       WHERE B.BOM_EXP_NO = ANUNIQUEID
         AND B.PROPERTY_GROUP = ANPROPERTYGROUPID;

      RETURN LNPROPERTYGROUPREV;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN( 100 );
   END;

   
   FUNCTION GETMAXCLAIMSPROPERTYREV(
      ANUNIQUEID                          IAPITYPE.ID_TYPE,
      ANPROPERTYID                        IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID                   IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.REVISION_TYPE
   AS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMaxClaimsPropertyRev';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPROPERTYREV                 IAPITYPE.REVISION_TYPE;
   BEGIN
      SELECT MAX( C.PROPERTY_REV )
        INTO LNPROPERTYREV
        FROM ITCLAIMEXPLOSION C
       WHERE C.BOM_EXP_NO = ANUNIQUEID
         AND C.PROPERTY = ANPROPERTYID
         AND C.PROPERTY_GROUP = ANPROPERTYGROUPID;

      RETURN LNPROPERTYREV;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN( 100 );
   END;
END IAPICLAIMS;