CREATE OR REPLACE PACKAGE BODY iapiPartPlant
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

   
   
   

   
   
   
   
   FUNCTION GETBASECOLUMNS(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumns';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.SQLSTRING_TYPE := NULL;
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
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || 'part_b.description '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ','
         || 'part_a.part_source '
         || IAPICONSTANTCOLUMN.PARTSOURCECOL
         || ','
         || LSALIAS
         || 'plant '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ','
         || 'plant.description '
         || IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
         || ','
         || 'plant.plant_source '
         || IAPICONSTANTCOLUMN.PLANTSOURCECOL
         || ','
         || LSALIAS
         || 'component_scrap '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ','
         || 'CASE WHEN '
         || 'relevency_to_costing = '
         || '''Y'''
         || ' THEN 1 ELSE 0 END '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ','
         || 'CASE WHEN '
         || LSALIAS
         || 'bulk_material = '
         || '''Y'''
         || ' THEN 1 ELSE 0 END '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ','
         || LSALIAS
         || 'lead_time_offset '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ','
         || LSALIAS
         || 'item_category '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ','
         || LSALIAS
         || 'obsolete '
         || IAPICONSTANTCOLUMN.OBSOLETECOL
         || ','
         || LSALIAS
         || 'issue_location '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ','
         || LSALIAS
         || 'issue_uom '
         || IAPICONSTANTCOLUMN.ISSUEUOMCOL
         || ','
         || LSALIAS
         || 'operational_step '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ','
         || LSALIAS
         || 'component_scrap_sync '
         
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPSYNCCOL; 
         
         
         
         
         
         
         
         
         
         

      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNS;

   
   FUNCTION GETBASECOLUMNSPRPLH
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumnsPrPlH';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LCBASECOLUMNS :=
            'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || 'action '
         || IAPICONSTANTCOLUMN.ACTIONCOL
         || ','
         || 'old_plant '
         || IAPICONSTANTCOLUMN.OLDPLANTCOL
         || ','
         || 'new_plant '
         || IAPICONSTANTCOLUMN.NEWPLANTCOL
         || ','
         || 'old_issue_uom '
         || IAPICONSTANTCOLUMN.OLDISSUEUOMCOL
         || ','
         || 'new_issue_uom '
         || IAPICONSTANTCOLUMN.NEWISSUEUOMCOL
         || ','
         || 'old_assembly_scrap '
         || IAPICONSTANTCOLUMN.OLDASSEMBLYSCRAPCOL
         || ','
         || 'new_assembly_scrap '
         || IAPICONSTANTCOLUMN.NEWASSEMBLYSCRAPCOL
         || ','
         || 'old_component_scrap '
         || IAPICONSTANTCOLUMN.OLDCOMPONENTSCRAPCOL
         || ','
         || 'new_component_scrap '
         || IAPICONSTANTCOLUMN.NEWCOMPONENTSCRAPCOL
         || ','
         || 'old_lead_time_offset '
         || IAPICONSTANTCOLUMN.OLDLEADTIMEOFFSETCOL
         || ','
         || 'new_lead_time_offset '
         || IAPICONSTANTCOLUMN.NEWLEADTIMEOFFSETCOL
         || ','
         || 'old_relevency_to_costing '
         || IAPICONSTANTCOLUMN.OLDRELEVENCYTOCOSTINGCOL
         || ','
         || 'new_relevency_to_costing '
         || IAPICONSTANTCOLUMN.NEWRELEVENCYTOCOSTINGCOL
         || ','
         || 'old_bulk_material '
         || IAPICONSTANTCOLUMN.OLDBULKMATERIALCOL
         || ','
         || 'new_bulk_material '
         || IAPICONSTANTCOLUMN.NEWBULKMATERIALCOL
         || ','
         || 'old_item_category '
         || IAPICONSTANTCOLUMN.OLDITEMCATEGORYCOL
         || ','
         || 'new_item_category '
         || IAPICONSTANTCOLUMN.NEWITEMCATEGORYCOL
         || ','
         || 'old_issue_location '
         || IAPICONSTANTCOLUMN.OLDISSUELOCATIONCOL
         || ','
         || 'new_issue_location '
         || IAPICONSTANTCOLUMN.NEWISSUELOCATIONCOL
         || ','
         || 'old_operational_step '
         || IAPICONSTANTCOLUMN.OLDOPERATIONALSTEPCOL
         || ','
         || 'new_operational_step '
         || IAPICONSTANTCOLUMN.NEWOPERATIONALSTEPCOL
         || ','
         || 'old_obsolete '
         || IAPICONSTANTCOLUMN.OLDOBSOLETECOL
         || ','
         || 'new_obsolete '
         || IAPICONSTANTCOLUMN.NEWOBSOLETECOL
         || ','
         || 'old_plant_access '
         || IAPICONSTANTCOLUMN.OLDPLANTACCESSCOL
         || ','
         || 'new_plant_access '
         || IAPICONSTANTCOLUMN.NEWPLANTACCESSCOL
         || ','
         || 'timestamp '
         || IAPICONSTANTCOLUMN.TIMESTAMPCOL
         || ','
         || 'user_id '
         || IAPICONSTANTCOLUMN.USERIDCOL
         || ','
         || 'forename '
         || IAPICONSTANTCOLUMN.FORENAMECOL
         || ','
         || 'last_name '
         || IAPICONSTANTCOLUMN.LASTNAMECOL
         || ','
         || 'old_component_scrap_sync '
         || IAPICONSTANTCOLUMN.OLDCOMPONENTSCRAPSYNCCOL
         || ','
         || 'new_component_scrap_sync '
         || IAPICONSTANTCOLUMN.NEWCOMPONENTSCRAPSYNCCOL;
      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNSPRPLH;

   
   
   
   
   FUNCTION EXISTID(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PART_NO
        INTO LSPARTNO
        FROM PART_PLANT
       WHERE PART_NO = ASPARTNO
         AND PLANT = ASPLANTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTPLANTNOTFOUND,
                                                     ASPARTNO,
                                                     ASPLANTNO ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION GETPLANTS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      AQPLANTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'pl' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'part_plant pl, part part_a, part part_b, plant ';
   BEGIN
      
      
      
      
      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where pl.part_no = null  ';

      OPEN AQPLANTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

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
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in DefaultFilter <'
                           || ATDEFAULTFILTER.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATDEFAULTFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATDEFAULTFILTER( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'DefaultFilter ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         CASE LRFILTER.LEFTOPERAND
            WHEN IAPICONSTANTCOLUMN.PARTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.part_no';
            WHEN IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'part_b.description';
            WHEN IAPICONSTANTCOLUMN.PARTSOURCECOL
            THEN
               LRFILTER.LEFTOPERAND := 'part_a.part_source';
            WHEN IAPICONSTANTCOLUMN.PLANTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.plant';
            WHEN IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'plant.description';
            WHEN IAPICONSTANTCOLUMN.PLANTSOURCECOL
            THEN
               LRFILTER.LEFTOPERAND := 'plant.plant_source';
            WHEN IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.component_scrap';
            WHEN IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.relevency_to_costing';
            WHEN IAPICONSTANTCOLUMN.BULKMATERIALCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.bulk_material';
            WHEN IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.lead_time_offset';
            WHEN IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.item_category';
            WHEN IAPICONSTANTCOLUMN.OBSOLETECOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.obsolete';
            WHEN IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.issue_location';
            WHEN IAPICONSTANTCOLUMN.ISSUEUOMCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.issue_uom';
            WHEN IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.operational_step';
            WHEN IAPICONSTANTCOLUMN.COMPONENTSCRAPSYNCCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pl.component_sync_scrap';
            ELSE
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                               LRFILTER.LEFTOPERAND );
               RETURN( LNRETVAL );
         END CASE;

         IF ( I > 0 )
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTER :=    LSFILTER
                        || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || 'WHERE '
         || 'pl.follow_on_material = part_b.part_no(+) '
         || 'AND pl.part_no = part_a.part_no '
         || 'AND pl.plant = plant.plant '
         || 'AND pl.part_no = :PartNo ';

      
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN
         LSSQL :=    LSSQL
                  || 'AND pl.plant_access = ''Y'' '
                  || 'AND pl.plant IN( SELECT PLANT '
                  || 'FROM ITUP '
                  || 'WHERE USER_ID = :UserId ) ';
      END IF;

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY pl.part_no ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN
         OPEN AQPLANTS FOR LSSQL USING ASPARTNO,
         IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      ELSE
         OPEN AQPLANTS FOR LSSQL USING ASPARTNO;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPLANTS;

   
   FUNCTION SAVEPLANT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ANCOMPONENTSCRAP           IN       IAPITYPE.SCRAP_TYPE DEFAULT 0,
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANLEADTIMEOFFSET           IN       IAPITYPE.LEADTIMEOFFSET_TYPE DEFAULT 0,
      ASITEMCATEGORY             IN       IAPITYPE.ITEMCATEGORY_TYPE DEFAULT 'L',
      ANOBSOLETE                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASISSUELOCATION            IN       IAPITYPE.ISSUELOCATION_TYPE,
      ASISSUEUOM                 IN       IAPITYPE.ISSUEUOM_TYPE,
      ANOPERATIONALSTEP          IN       IAPITYPE.OPERATIONALSTEP_TYPE,
      ANCOMPONENTSCRAPSYNC       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      
      
      
      
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
       RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SavePlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE PART_PLANT
         SET COMPONENT_SCRAP = ANCOMPONENTSCRAP,
             RELEVENCY_TO_COSTING = CASE
                                      WHEN ANRELEVANCYTOCOSTING = 1
                                         THEN 'Y'
                                      ELSE 'N'
                                   END,
             BULK_MATERIAL = CASE
                               WHEN ANBULKMATERIAL = 1
                                  THEN 'Y'
                               ELSE 'N'
                            END,
             LEAD_TIME_OFFSET = ANLEADTIMEOFFSET,
             ITEM_CATEGORY = ASITEMCATEGORY,
             OBSOLETE = ANOBSOLETE,
             ISSUE_LOCATION = ASISSUELOCATION,
             ISSUE_UOM = ASISSUEUOM,
             OPERATIONAL_STEP = ANOPERATIONALSTEP,
             
             COMPONENT_SCRAP_SYNC = ANCOMPONENTSCRAPSYNC 
             
            
            
            
       WHERE PART_NO = ASPARTNO
         AND PLANT = ASPLANTNO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTPLANTNOTFOUND,
                                                     ASPARTNO,
                                                     ASPLANTNO ) );
      END IF;

      IF ANCOMPONENTSCRAPSYNC = 1
      THEN
         BEGIN
            UPDATE BOM_ITEM
               SET COMPONENT_SCRAP = ANCOMPONENTSCRAP
             WHERE COMPONENT_PART = ASPARTNO
               AND COMPONENT_PLANT = ASPLANTNO
               AND COMPONENT_SCRAP_SYNC = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEPLANT;

   
   FUNCTION GETPLANTS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE DEFAULT NULL,
      AQPLANTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'pl' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'part_plant pl, part part_a, part part_b, plant ';
   BEGIN
      
      
      
      
      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where pl.part_no = null';

      OPEN AQPLANTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AXDEFAULTFILTER IS NOT NULL
      THEN
         LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXDEFAULTFILTER,
                                                  LTDEFAULTFILTER );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      LNRETVAL := IAPIPARTPLANT.GETPLANTS( ASPARTNO,
                                           LTDEFAULTFILTER,
                                           AQPLANTS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
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
   END GETPLANTS;

   
   FUNCTION GETPLANTSPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AXDEFAULTFILTER            IN       IAPITYPE.XMLSTRING_TYPE DEFAULT NULL,
      AQPLANTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXDEFAULTFILTER               IAPITYPE.XMLTYPE_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'pl' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'part_plant pl, part part_a, part part_b, plant ';
   BEGIN
      
      
      
      
      
      IF ( AQPLANTS%ISOPEN )
      THEN
         CLOSE AQPLANTS;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where pl.part_no = null';

      OPEN AQPLANTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AXDEFAULTFILTER IS NOT NULL
      THEN
         LXDEFAULTFILTER := XMLTYPE( AXDEFAULTFILTER );
      END IF;

      LNRETVAL := IAPIPARTPLANT.GETPLANTS( ASPARTNO,
                                           LXDEFAULTFILTER,
                                           AQPLANTS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
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
   END GETPLANTSPB;

   
   FUNCTION REMOVEPLANT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemovePlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNBOMHEADERCOUNT              NUMBER := 0;
      LNBOMITEMCOUNT                NUMBER := 0;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      

      
      
       
      SELECT COUNT( * )
        INTO LNBOMITEMCOUNT
        FROM BOM_ITEM
       WHERE COMPONENT_PART = ASPARTNO
         AND COMPONENT_PLANT = ASPLANTNO;

      IF ( LNBOMITEMCOUNT > 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTPLANTINBOM,
                                                     ASPARTNO,
                                                     ASPLANTNO ) );
      END IF;

      
      
       
      SELECT COUNT( * )
        INTO LNBOMHEADERCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND PLANT = ASPLANTNO;

      IF ( LNBOMHEADERCOUNT > 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTPLANTUSEDINBOM,
                                                     ASPLANTNO,
                                                     ASPARTNO ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM PART_PLANT
            WHERE PART_NO = ASPARTNO
              AND PLANT = ASPLANTNO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTPLANTNOTFOUND,
                                                     ASPARTNO,
                                                     ASPLANTNO ) );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete PartNo <'
                           || ASPARTNO
                           || '> '
                           || 'Plant <'
                           || ASPLANTNO
                           || '> ',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEPLANT;

   
   FUNCTION ADDPLANT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ANCOMPONENTSCRAP           IN       IAPITYPE.SCRAP_TYPE DEFAULT 0,
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANLEADTIMEOFFSET           IN       IAPITYPE.LEADTIMEOFFSET_TYPE DEFAULT 0,
      ASITEMCATEGORY             IN       IAPITYPE.ITEMCATEGORY_TYPE DEFAULT 'L',
      ANOBSOLETE                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASISSUELOCATION            IN       IAPITYPE.ISSUELOCATION_TYPE,
      ASISSUEUOM                 IN       IAPITYPE.ISSUEUOM_TYPE,
      ANOPERATIONALSTEP          IN       IAPITYPE.OPERATIONALSTEP_TYPE,
      ANCOMPONENTSCRAPSYNC       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      
      
      
      
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
        
        
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
       
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      LNRETVAL := IAPIPLANT.EXISTID( ASPLANTNO );

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

      BEGIN
         INSERT INTO PART_PLANT
                     ( PART_NO,
                       PLANT,
                       COMPONENT_SCRAP,
                       RELEVENCY_TO_COSTING,
                       BULK_MATERIAL,
                       LEAD_TIME_OFFSET,
                       ITEM_CATEGORY,
                       OBSOLETE,
                       ISSUE_LOCATION,
                       ISSUE_UOM,
                       OPERATIONAL_STEP,
											 
											 PLANT_ACCESS,
											 
                       
                       COMPONENT_SCRAP_SYNC ) 
                       
                        
                        
                        
              VALUES ( ASPARTNO,
                       ASPLANTNO,
                       ANCOMPONENTSCRAP,
                       CASE
                          WHEN ANRELEVANCYTOCOSTING = 1
                             THEN 'Y'
                          ELSE 'N'
											 END,
                       CASE
                          WHEN ANBULKMATERIAL = 1
                             THEN 'Y'
                          ELSE 'N'
                       END,
                       ANLEADTIMEOFFSET,
                       ASITEMCATEGORY,
                       ANOBSOLETE,
                       ASISSUELOCATION,
                       ASISSUEUOM,
                       ANOPERATIONALSTEP,
                       
                       'Y',
                       
                       
                       ANCOMPONENTSCRAPSYNC ); 
                       
                        
                        
                        
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_DUPLICATEPARTPLANT,
                                                        ASPARTNO,
                                                        ASPLANTNO ) );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      IF ANCOMPONENTSCRAPSYNC = 1
      THEN
         BEGIN
            UPDATE BOM_ITEM
               SET COMPONENT_SCRAP = ANCOMPONENTSCRAP
             WHERE COMPONENT_PART = ASPARTNO
               AND COMPONENT_PLANT = ASPLANTNO
               AND COMPONENT_SCRAP_SYNC = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDPLANT;

   
   FUNCTION GETLOCATIONS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      AQLOCATIONS                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLocations';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
                                   :=    'pl.location '
                                      || IAPICONSTANTCOLUMN.LOCATIONIDCOL
                                      || ','
                                      || 'l.description '
                                      || IAPICONSTANTCOLUMN.LOCATIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'part_location pl, location l';
   BEGIN
      
      
      
      
      
      IF ( AQLOCATIONS%ISOPEN )
      THEN
         CLOSE AQLOCATIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE pl.part_no = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLOCATIONS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIPARTPLANT.EXISTID( ASPARTNO,
                                         ASPLANTNO );

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
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE pl.part_no = :PartNo '
         || ' AND pl.plant = :PlantNo '
         || ' AND pl.plant = l.plant '
         || ' AND pl.location = l.location';
      LSSQL :=    LSSQL
               || ' ORDER BY pl.location ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLOCATIONS%ISOPEN )
      THEN
         CLOSE AQLOCATIONS;
      END IF;

      
      OPEN AQLOCATIONS FOR LSSQL USING ASPARTNO,
      ASPLANTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLOCATIONS;

   
   FUNCTION GETHISTORY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQHISTORY                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNSPRPLH;
      LSFROM                        IAPITYPE.STRING_TYPE := 'itprpl_h ';
   BEGIN
      
      
      
      
      
      IF ( AQHISTORY%ISOPEN )
      THEN
         CLOSE AQHISTORY;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where part_no = null  ';

      OPEN AQHISTORY FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE part_no = :PartNo '
               || ' ORDER BY part_no ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQHISTORY%ISOPEN )
      THEN
         CLOSE AQHISTORY;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Select = '
                           || LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQHISTORY FOR LSSQL USING ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETHISTORY;
END IAPIPARTPLANT;