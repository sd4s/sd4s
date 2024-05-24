CREATE OR REPLACE PACKAGE BODY iapiUomGroups
IS
   
   
   
   
   
   
   
   
   
   
   
   
   

   
   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN



       RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.12 (06.07.00.12-01.00) $)' );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;

   
   FUNCTION EXISTUOMID(
      ANUOM                      IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistUomId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ANUOM IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'UOM' );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF UOMFOUND( ANUOM ) = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_UOMNOTFOUND,
                                                         'UOM' );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTUOMID;

   
   FUNCTION UOMFOUND(
      ANUOM                      IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UomFound';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM UOM
       WHERE UOM_ID = ANUOM;

      RETURN( CASE LNCOUNT
                 WHEN 0
                    THEN 0
                 ELSE 1
              END );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END UOMFOUND;

   FUNCTION ADDGROUP(
      ASDESCRIPTION              IN       IAPITYPE.UOMGROUPDESCRIPTION_TYPE,
      ASINTL                     IN       IAPITYPE.INTL_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ANUOMGROUP                 OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNEXTSEQUENCE                IAPITYPE.SEQUENCE_TYPE := 0;
      LSINTL                        UOM.INTL%TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSINTL := CASE IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL
                  WHEN TRUE
                     THEN 'Y'
                  ELSE 'N'
               END;
      LNRETVAL := IAPISEQUENCE.GETNEXTVALUE( LSINTL,
                                             'uom_group',
                                             LNNEXTSEQUENCE );

      INSERT INTO UOM_GROUP
                  ( UOM_GROUP,
                    DESCRIPTION,
                    INTL,
                    STATUS )
           VALUES ( LNNEXTSEQUENCE,
                    ASDESCRIPTION,
                    LSINTL,
                    ANSTATUS );

      ANUOMGROUP := LNNEXTSEQUENCE;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDGROUP;

   
   FUNCTION REMOVEGROUP(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF UOMGROUPFOUND( ANUOMGROUP ) = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_UOMGROUPNOTFOUND ) );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM UOM_UOM_GROUP
       WHERE UOM_GROUP = ANUOMGROUP;

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DELUOMGROUPUSED ) );
      END IF;

      DELETE      UOM_GROUP
            WHERE UOM_GROUP = ANUOMGROUP;

      DELETE      UOM_GROUP_H
            WHERE UOM_GROUP = ANUOMGROUP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEGROUP;

   
   FUNCTION CHANGEGROUP(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.UOMGROUPDESCRIPTION_TYPE,
      ANINTL                     IN       IAPITYPE.INTL_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ChangeGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF UOMGROUPFOUND( ANUOMGROUP ) = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_UOMGROUPNOTFOUND ) );
      END IF;

      UPDATE UOM_GROUP
         SET DESCRIPTION = ASDESCRIPTION,
             INTL = ANINTL,
             STATUS = ANSTATUS
       WHERE UOM_GROUP = ANUOMGROUP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHANGEGROUP;

   FUNCTION ASSIGNUOMTOGROUP(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE,
      ANUOM                      IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AssignUomToGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER := 0;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF UOMFOUND( ANUOM ) = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_UOMNOTFOUND ) );
      END IF;

      IF UOMGROUPFOUND( ANUOMGROUP ) = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_UOMGROUPNOTFOUND ) );
      END IF;

      SELECT   COUNT( UG.UOM_ID ),
               U.DESCRIPTION
          INTO LNCOUNT,
               LSUOM
          FROM UOM U,
               UOM_UOM_GROUP UG
         WHERE UG.UOM_ID = U.UOM_ID
           AND U.UOM_ID = ANUOM
      GROUP BY U.DESCRIPTION;

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_UOMALREADYASSIGNED,
                                                     LSUOM ) );
      END IF;

      INSERT INTO UOM_UOM_GROUP
                  ( UOM_GROUP,
                    UOM_ID )
           VALUES ( ANUOMGROUP,
                    ANUOM );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ASSIGNUOMTOGROUP;

   
   FUNCTION GETGROUPS(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AQGROUPS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetGroups';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQLWHERE                    IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF UOMGROUPFOUND( ANUOMGROUP ) = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_UOMGROUPNOTFOUND ) );
      END IF;

      LSSQLWHERE := CASE
                      WHEN ANUOMGROUP IS NOT NULL
                         THEN    ' WHERE UOM_GROUP ='
                              || TO_CHAR( ANUOMGROUP )
                      ELSE NULL
                   END;

      OPEN AQGROUPS FOR    'SELECT UOM_GROUP, '
                        || '       DESCRIPTION, '
                        || '       INTL, '
                        || '       STATUS '
                        || '  FROM UOM_GROUP '
                        || LSSQLWHERE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETGROUPS;

   FUNCTION GETUOMGROUPDESCRIPTION(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANUOMGROUPREVISION         IN       IAPITYPE.REVISION_TYPE,
      AQGROUPS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomGroupDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQLUOMGROUPCONDITION        IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LNCOUNT                       NUMBER := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID IS NULL )
      THEN
         IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID := 1;
      END IF;

      IF ANUOMGROUP IS NOT NULL
      THEN
         IF UOMGROUPFOUND( ANUOMGROUP ) = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UOMGROUPNOTFOUND ) );
         END IF;
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM UOM_GROUP_H
       WHERE UOM_GROUP = ANUOMGROUP
         AND REVISION = ANUOMGROUPREVISION
         AND LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
         AND MAX_REV = 1;

      IF LNCOUNT > 0
      THEN
         LSSQL :=
               'SELECT description '
            || '  FROM uom_group_h '
            || ' WHERE uom_group = :anUomGroup '
            || '   AND revision = :anUomGroupRevision '
            || '   AND lang_id = '
            || TO_CHAR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID )
            || '   AND max_rev = 1 ';
      ELSE
         LSSQL :=
               'SELECT description '
            || '  FROM uom_group_h '
            || ' WHERE uom_group = :anUomGroup '
            || '   AND revision = :anUomGroupRevision '
            || '   AND max_rev = 1 ';
      END IF;

      LSSQLUOMGROUPCONDITION := CASE
                                  WHEN ANUOMGROUP IS NOT NULL
                                     THEN    ' AND UOM_GROUP = '
                                          || TO_CHAR( ANUOMGROUP )
                                  ELSE NULL
                               END;

      OPEN AQGROUPS FOR    LSSQL
                        || LSSQLUOMGROUPCONDITION USING ANUOMGROUP,
      ANUOMGROUPREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMGROUPDESCRIPTION;

   FUNCTION GETUOMDESCRIPTION(
      ANUOM                      IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANUOMREVISION              IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      

      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQLSELECT                   IAPITYPE.SQLSTRING_TYPE := NULL;
      LNCOUNT                       NUMBER := 0;
      LSSQLLANGCONDITION            IAPITYPE.STRING_TYPE := NULL;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID IS NULL )
      THEN
         IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID := 1;
      END IF;

      IF ANUOM IS NOT NULL
      THEN
         IF UOMFOUND( ANUOM ) = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_UOMNOTFOUND ) );

				 ELSE
						SELECT COUNT( * )
							INTO LNCOUNT
							FROM UOM_H
						 WHERE REVISION = ANUOMREVISION
						   AND UOM_ID = ANUOM
							 AND LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
							 AND MAX_REV = 1;
            LSSQLLANGCONDITION := CASE
                              WHEN LNCOUNT > 0
                                 THEN    ' AND lang_id = '
                                      || TO_CHAR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID )
                              ELSE ' AND lang_id = 1 '
                           END;
							 

         END IF;

      ELSE
					LSSQLLANGCONDITION := ' AND lang_id = '
																|| TO_CHAR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID );

      END IF;

      IF ANUOMGROUP IS NOT NULL
      THEN
         IF UOMGROUPFOUND( ANUOMGROUP ) = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UOMGROUPNOTFOUND ) );
         END IF;
      END IF;














													 
      LSSQLSELECT :=
         CASE
            WHEN     ANUOM IS NULL
                 AND ANUOMGROUP IS NULL
               THEN    'SELECT uom_id, description '
                    || '  FROM uom_h '
                    || ' WHERE 1= 1 '
                    || '   AND max_rev = 1 '
                    || LSSQLLANGCONDITION
            WHEN     ANUOM IS NOT NULL
                 AND ANUOMGROUP IS NULL
               THEN   
                      'SELECT u.uom_id, u.description '
                   || '  FROM uom_h u, '
                   || '       uom_uom_group uu '
                   || ' WHERE uu.uom_group = (select uom_group from uom_uom_group where uom_id = '
                   || TO_CHAR( ANUOM )
                   || ')'
                   || '   AND uu.uom_id = u.uom_id '
                   || '   AND max_rev = 1 '
                   || LSSQLLANGCONDITION
            WHEN     ANUOM IS NULL
                 AND ANUOMGROUP IS NOT NULL
               THEN    'SELECT u.uom_id, u.description '
                    || '  FROM uom_h u, '
                    || '       uom_uom_group uu '
                    || ' WHERE uu.uom_group = '
                    || TO_CHAR( ANUOMGROUP )
                    || '   AND uu.UOM_ID = u.UOM_ID '
                    || '   AND max_rev = 1 '
                    || LSSQLLANGCONDITION
            WHEN     ANUOM IS NOT NULL
                 AND ANUOMGROUP IS NOT NULL
               THEN    'SELECT u.uom_id, u.description '
                    || '  FROM uom_h u, '
                    || '       uom_uom_group uu '
                    || ' WHERE uu.UOM_GROUP = '
                    || TO_CHAR( ANUOMGROUP )
                    || '   AND uu.UOM_ID = '
                    || TO_CHAR( ANUOM )
                    || '   AND uu.UOM_ID = u.UOM_ID '
                    || '   AND max_rev = 1 '
                    || LSSQLLANGCONDITION
         END;

      OPEN AQUOMS FOR LSSQLSELECT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMDESCRIPTION;

   FUNCTION GETUOMID(
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANUOMREVISION              IN       IAPITYPE.REVISION_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ID_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomId';
      LSSQLSELECT                   IAPITYPE.SQLSTRING_TYPE := NULL;
      LNRETUOMDESC                  IAPITYPE.ID_TYPE := NULL;
      LSSQLREVCONDITION             IAPITYPE.STRING_TYPE := NULL;
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMREV                      IAPITYPE.REVISION_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      




























      

        LNRETVAL := F_UMH_ID(ASUOM,
                             NULL,
                             LNRETUOMDESC,
                             LNUOMREV);

        IF (LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS)
        THEN
            RETURN (NULL);
        END IF;
        

      RETURN( LNRETUOMDESC );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( NULL );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( NULL );
   END GETUOMID;

   FUNCTION ADDUOMCONVERSION(
      ANUOMMETRI                 IN       IAPITYPE.ID_TYPE,
      ANUOMNOMETRIC              IN       IAPITYPE.ID_TYPE,
      ANCONVFACTOR               IN       UOMCONVFACTOR_TYPE,
      ANCONVFCT                  IN       UOMCONVFCT_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddUomConversion';
      LNCOUNT                       PLS_INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := EXISTUOMID( ANUOMMETRI );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := EXISTUOMID( ANUOMNOMETRIC );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      


      SELECT COUNT( * )
        INTO LNCOUNT
        FROM UOM
       WHERE UOM_ID = ANUOMMETRI
         AND UOM_BASE = UOMBASE   
         AND UOM_TYPE = IAPICONSTANT.UOMTYPE_METRIC;

      IF ( LNCOUNT = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     DBERR_NOTUOMBASE,   
                                                     ANUOMMETRI ) );
      END IF;


    
    
    
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      INSERT INTO UOMC
                  ( UOM_ID,
                    UOM_ALT_ID,
                    CONV_FACTOR,
                    CONV_FCT )
           VALUES ( ANUOMMETRI,
                    ANUOMNOMETRIC,
                    ANCONVFACTOR,
                    ANCONVFCT );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDUOMCONVERSION;

   FUNCTION GETALTERNATIVEUOMBASE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANUOMALTERNATIVE           OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAlternativeUomBase';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LSSQLWHERE                    IAPITYPE.STRING_TYPE := NULL;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSAMEUOMID                   IAPITYPE.ID_TYPE;
      LNTEMPUOMID                   IAPITYPE.ID_TYPE;
      LNOTHERUOMID                  IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF UOMFOUND( ANUOMID ) = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_UOMNOTFOUND ) );
      END IF;

      LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPSAMETYPE( ANUOMID,
                                                         LNSAMEUOMID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      LNTEMPUOMID := LNSAMEUOMID;
      LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPOTHERTYPE( LNTEMPUOMID,
                                                          LNOTHERUOMID );








      ANUOMALTERNATIVE := LNOTHERUOMID;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ANUOMALTERNATIVE := ANUOMID;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         ROLLBACK;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETALTERNATIVEUOMBASE;

   FUNCTION GETUOMSBASE(
      ANBASE                     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsBase';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LSSQLWHERE                    IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQLWHERE := CASE
                      WHEN ANBASE IS NOT NULL
                         THEN    ' WHERE UOM_BASE ='
                              || TO_CHAR( ANBASE )
                      ELSE NULL
                   END;
      LSSQLSELECT :=    'SELECT uom_id, description, uom_type '
                     || ' FROM uom '
                     || LSSQLWHERE;

      OPEN AQUOMS FOR LSSQLSELECT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSBASE;

   FUNCTION GETUOMSTYPE(
      ANTYPE                     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LSSQLWHERE                    IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQLWHERE := CASE
                      WHEN ANTYPE IS NOT NULL
                         THEN    ' WHERE UOM_TYPE ='
                              || TO_CHAR( ANTYPE )
                      ELSE NULL
                   END;
      LSSQLSELECT :=    'SELECT uom_id, description, uom_base '
                     || ' FROM uom '
                     || LSSQLWHERE;

      OPEN AQUOMS FOR LSSQLSELECT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSTYPE;

   FUNCTION GETUOMSGROUPTYPE(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.BOOLEAN_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQLSELECT :=
            'SELECT u.UOM_ID, u.DESCRIPTION '
         || ' FROM UOM_UOM_GROUP G,UOM U '
         || 'WHERE G.UOM_ID= U.UOM_ID '
         || 'AND G.UOM_GROUP = :anUomGroup '
         || 'AND U.UOM_TYPE = :anType ';

      OPEN AQUOMS FOR LSSQLSELECT USING ANUOMGROUP,
      ANTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPTYPE;

   FUNCTION ISSAMEMODETYPE(
      ANUOMTYPE                  IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN BOOLEAN
   
   
   
   
   
  
   AS
   BEGIN
     RETURN NOT(
                 (NOT IAPIGENERAL.SESSION.SETTINGS.METRIC
                   AND ( ANUOMTYPE = IAPICONSTANT.UOMTYPE_METRIC )
                 )
                OR
                 (
                    IAPIGENERAL.SESSION.SETTINGS.METRIC
                    AND
                    (ANUOMTYPE = IAPICONSTANT.UOMTYPE_NONMETRIC)
                 )
               );
   END ISSAMEMODETYPE;


   FUNCTION GETUOMSGROUPSESSIONTYPE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupSESSIONType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNUOMTYPE                     IAPITYPE.BOOLEAN_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LQUOMS                        IAPITYPE.REF_TYPE;
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LNRETVAL := IAPIUOMGROUPS.GETTYPEUOM( ANUOMID,
                                            LNUOMTYPE );


      IF  (NOT ISSAMEMODETYPE (LNUOMTYPE))
      THEN
        LNRETVAL:=GETUOMSGROUPOTHERTYPE(ANUOMID, AQUOMS);
      ELSE
        LNRETVAL:=GETUOMSGROUPSAMETYPE(ANUOMID, AQUOMS);
      END IF;


      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPSESSIONTYPE;

   FUNCTION GETUOMSGROUPSESSIONTYPE(
      ASUOMID                    IN       IAPITYPE.DESCRIPTION_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupSESSIONType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNUOMID:= GETUOMID(ASUOMID);

      LNRETVAL:= GETUOMSGROUPSESSIONTYPE(LNUOMID, AQUOMS );


      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPSESSIONTYPE;



   FUNCTION GETUOMSGROUPSAMETYPE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupSameType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      OPEN AQUOMS FOR
         SELECT UG.UOM_GROUP,
                U.UOM_ID,
                U.DESCRIPTION,
                U.UOM_TYPE,
                U.UOM_BASE
           FROM UOM_UOM_GROUP UG,
                UOM U
          WHERE U.UOM_ID = UG.UOM_ID
            AND UG.UOM_GROUP = ( SELECT UOM_GROUP
                                   FROM UOM_UOM_GROUP
                                  WHERE UOM_ID = ANUOMID )
            AND U.UOM_ID IN( SELECT UOM_ID
                              FROM UOM
                             WHERE UOM_TYPE = U.UOM_TYPE
                               AND UOM_TYPE = ( SELECT UOM_TYPE
                                                 FROM UOM
                                                WHERE UOM_ID = ANUOMID ) )
       UNION
         SELECT (SELECT UOM_GROUP
                   FROM UOM_UOM_GROUP
                  WHERE UOM_ID = ANUOMID) UOM_GROUP,
                U.UOM_ID,
                U.DESCRIPTION,
                U.UOM_TYPE,
                U.UOM_BASE
           FROM UOM U
          WHERE U.UOM_ID = ANUOMID;


      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPSAMETYPE;


   FUNCTION GETUOMSGROUPSAMETYPE(
      ASUOMID                    IN       IAPITYPE.DESCRIPTION_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupSameType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNUOMID:= GETUOMID(ASUOMID);

      LNRETVAL:= GETUOMSGROUPSAMETYPE(LNUOMID, AQUOMS );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPSAMETYPE;

    
    FUNCTION GETUOMBASEGROUPSAMETYPE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE)
      RETURN IAPITYPE.ID_TYPE
    IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomBaseGroupSameType';
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNUOMBASEID                   IAPITYPE.ID_TYPE;
    BEGIN
      SELECT U.UOM_ID
        INTO LNUOMBASEID
        FROM UOM_UOM_GROUP UG,
             UOM U
       WHERE U.UOM_ID = UG.UOM_ID
         AND UG.UOM_GROUP = ( SELECT UOM_GROUP
                               FROM UOM_UOM_GROUP
                              WHERE UOM_ID = ANUOMID )
         AND U.UOM_ID IN( SELECT UOM_ID
                           FROM UOM
                          WHERE UOM_BASE = 1
                            AND UOM_TYPE = ( SELECT UOM_TYPE
                                              FROM UOM
                                             WHERE UOM_ID = ANUOMID ) );

        RETURN LNUOMBASEID;

    EXCEPTION
      
      WHEN NO_DATA_FOUND
      THEN
         LNUOMBASEID := ANUOMID;

         RETURN LNUOMBASEID;

      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN NULL;
    END GETUOMBASEGROUPSAMETYPE;
    

    
    FUNCTION GETCONVERSIONFACTOR(
       ANVALUE                    IN       IAPITYPE.FLOAT_TYPE DEFAULT 1,
       ANFROMUOMID                IN       IAPITYPE.ID_TYPE,
       ANTOUOMID                  IN       IAPITYPE.ID_TYPE,
       ANRICORSIVELEVEL           IN       IAPITYPE.LEVEL_TYPE DEFAULT 1,
       ANFIRSTVALUE               IN       IAPITYPE.FLOAT_TYPE DEFAULT 0 )
       RETURN IAPITYPE.FLOAT_TYPE
    IS
       
       
       
       
       
       
       
       
       

       
       
       
       
       
       
       
       
       
       
       
       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetConversionFactor';
       LNCONVFCT                     UOMC.CONV_FCT%TYPE;
       LNCOUNT                       NUMBER;
       LSMSGNOCONV                   VARCHAR2(100);
       LNFIRSTVALUE                  NUMBER := ANFIRSTVALUE;

       

       TYPE UOMINFO IS RECORD(
          UOM_BASE                      UOM.UOM_BASE%TYPE,
          UOM_TYPE                      UOM.UOM_TYPE%TYPE,
          DESCRIPTION                   UOM.DESCRIPTION%TYPE,
          UOM_ID                        UOMC.UOM_ID%TYPE,
          UOM_ALT_ID                    UOMC.UOM_ALT_ID%TYPE,
          CONVFACTOR                    UOMC.CONV_FACTOR%TYPE,
          RESULT                        IAPITYPE.FLOAT_TYPE
       );

       UOMC_FROM_INFO                   UOMINFO;
       UOMC_TO_INFO                     UOMINFO;
       UOMC_RESULT_INFO                 UOMINFO;
       MAX_LEVEL               CONSTANT NUMBER := 10;

    BEGIN
       
       
       
       
       
       

       
       LSMSGNOCONV := 'The uom_id: ' || ANFROMUOMID || ' has no conversion value for uom_id:' ||  ANTOUOMID;

       IF ( ANRICORSIVELEVEL = 1 ) 
       THEN
          LNFIRSTVALUE := ANVALUE;
       END IF;

       IF ( 0 = IAPIUOMGROUPS.ISUOMSSAMEGROUP( ANFROMUOMID,
                                               ANTOUOMID ) )
       THEN
          RETURN( LNFIRSTVALUE );
       END IF;


       IF ( ANFROMUOMID = ANTOUOMID )
       THEN
          RETURN( LNFIRSTVALUE );
       END IF;

       IF ( ANRICORSIVELEVEL = MAX_LEVEL )
       THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  ' Max Recursive Level. Exceeded the number of calls recursive function. The layout of conversions is not correct.' );
            RETURN( LNFIRSTVALUE );
       END IF;


       IF (    ANFROMUOMID IS NULL
            OR ANTOUOMID IS NULL )
       THEN
          RETURN( LNFIRSTVALUE );
       END IF;

       
       SELECT U.UOM_BASE,
              U.UOM_TYPE,
              U.DESCRIPTION
         INTO UOMC_FROM_INFO.UOM_BASE,
              UOMC_FROM_INFO.UOM_TYPE,
              UOMC_FROM_INFO.DESCRIPTION
         FROM UOM U
        WHERE UOM_ID = ANFROMUOMID;

       
       SELECT U.UOM_BASE,
              U.UOM_TYPE,
              U.DESCRIPTION
         INTO UOMC_TO_INFO.UOM_BASE,
              UOMC_TO_INFO.UOM_TYPE,
              UOMC_TO_INFO.DESCRIPTION
         FROM UOM U
        WHERE UOM_ID = ANTOUOMID;

       
       IF ( UOMC_FROM_INFO.UOM_TYPE <> UOMC_TO_INFO.UOM_TYPE )
       THEN
          IF ( UOMC_FROM_INFO.UOM_BASE <> UOMC_TO_INFO.UOM_BASE )
          THEN
             


             LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPSAMETYPE( ANFROMUOMID,
                                                                UOMC_FROM_INFO.UOM_ID );
             LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPSAMETYPE( ANTOUOMID,
                                                                UOMC_TO_INFO.UOM_ID );
             
             UOMC_RESULT_INFO.RESULT := GETCONVERSIONFACTOR( ANVALUE,
                                                        ANFROMUOMID,
                                                        UOMC_FROM_INFO.UOM_ID,
                                                          ANRICORSIVELEVEL
                                                        + 1,
                                                        LNFIRSTVALUE );   
             
             UOMC_RESULT_INFO.RESULT :=
                                 GETCONVERSIONFACTOR( UOMC_RESULT_INFO.RESULT,
                                                 UOMC_FROM_INFO.UOM_ID,
                                                 UOMC_TO_INFO.UOM_ID,
                                                   ANRICORSIVELEVEL
                                                 + 1,
                                                 LNFIRSTVALUE );   

             
             UOMC_RESULT_INFO.RESULT := GETCONVERSIONFACTOR( UOMC_RESULT_INFO.RESULT,
                                                        UOMC_TO_INFO.UOM_ID,
                                                        ANTOUOMID,
                                                          ANRICORSIVELEVEL
                                                        + 1,
                                                        LNFIRSTVALUE );   
             RETURN( UOMC_RESULT_INFO.RESULT );
          END IF;
       END IF;

       IF (     UOMC_FROM_INFO.UOM_BASE = 1
            AND UOMC_TO_INFO.UOM_BASE = 1 )
       THEN
          BEGIN
             
             SELECT CONV_FACTOR,
                    UOM_ALT_ID,
                    UOM_ID
               INTO UOMC_RESULT_INFO.CONVFACTOR,
                    UOMC_RESULT_INFO.UOM_ALT_ID,
                    UOMC_RESULT_INFO.UOM_ID
               FROM UOMC
              WHERE UOM_ID = ANFROMUOMID
                AND UOM_ALT_ID = ANTOUOMID;

             UOMC_RESULT_INFO.RESULT :=(   1
                                         * UOMC_RESULT_INFO.CONVFACTOR );
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
             
                SELECT CONV_FACTOR,
                       UOM_ALT_ID,
                       UOM_ID
                  INTO UOMC_RESULT_INFO.CONVFACTOR,
                       UOMC_RESULT_INFO.UOM_ALT_ID,
                       UOMC_RESULT_INFO.UOM_ID
                  FROM UOMC
                 WHERE UOM_ID = ANTOUOMID
                   AND UOM_ALT_ID = ANFROMUOMID;

                UOMC_RESULT_INFO.RESULT := (   1
                                            / UOMC_RESULT_INFO.CONVFACTOR );
          END;
       ELSIF(     UOMC_FROM_INFO.UOM_BASE = 1
              AND UOMC_TO_INFO.UOM_BASE = 0 )
       THEN
          BEGIN
             
             SELECT CONV_FACTOR,
                    UOM_ALT_ID,
                    UOM_ID
               INTO UOMC_RESULT_INFO.CONVFACTOR,
                    UOMC_RESULT_INFO.UOM_ALT_ID,
                    UOMC_RESULT_INFO.UOM_ID
               FROM UOMC
              WHERE UOM_ID = ANFROMUOMID
                AND UOM_ALT_ID = ANTOUOMID;

             UOMC_RESULT_INFO.RESULT :=(   1
                                         * UOMC_RESULT_INFO.CONVFACTOR );
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                       LSMETHOD,
                                       LSMSGNOCONV);
                RETURN( LNFIRSTVALUE );
          END;
       ELSIF(     UOMC_FROM_INFO.UOM_BASE = 0
              AND UOMC_TO_INFO.UOM_BASE = 1 )
       THEN
          
          SELECT CONV_FACTOR,
                 UOM_ALT_ID,
                 UOM_ID
            INTO UOMC_RESULT_INFO.CONVFACTOR,
                 UOMC_RESULT_INFO.UOM_ALT_ID,
                 UOMC_RESULT_INFO.UOM_ID
            FROM UOMC
           WHERE UOM_ID = ANTOUOMID
             AND UOM_ALT_ID = ANFROMUOMID;

          UOMC_RESULT_INFO.RESULT :=(   1
                                      / UOMC_RESULT_INFO.CONVFACTOR );
       ELSIF(     UOMC_FROM_INFO.UOM_BASE = 0
              AND UOMC_TO_INFO.UOM_BASE = 0 )
       THEN
          BEGIN
             


             LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPSAMETYPE( ANFROMUOMID,
                                                                UOMC_FROM_INFO.UOM_ID );

             LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPSAMETYPE( ANTOUOMID,
                                                                UOMC_TO_INFO.UOM_ID );

             
             IF UOMC_FROM_INFO.UOM_ID = UOMC_TO_INFO.UOM_ID
             THEN
                UOMC_RESULT_INFO.RESULT := GETCONVERSIONFACTOR( ANVALUE,
                                                           ANFROMUOMID,
                                                           UOMC_FROM_INFO.UOM_ID,
                                                             ANRICORSIVELEVEL
                                                           + 1,
                                                           LNFIRSTVALUE );

                UOMC_RESULT_INFO.RESULT := GETCONVERSIONFACTOR( UOMC_RESULT_INFO.RESULT,
                                                           UOMC_FROM_INFO.UOM_ID,
                                                           ANTOUOMID,
                                                             ANRICORSIVELEVEL
                                                           + 1,
                                                           LNFIRSTVALUE );
             
             ELSE
                
                UOMC_RESULT_INFO.RESULT := GETCONVERSIONFACTOR( ANVALUE,
                                                           UOMC_FROM_INFO.UOM_ID,
                                                           UOMC_TO_INFO.UOM_ID,
                                                             ANRICORSIVELEVEL
                                                           + 1,
                                                           LNFIRSTVALUE );

                UOMC_RESULT_INFO.RESULT := GETCONVERSIONFACTOR( ANVALUE,
                                                           ANFROMUOMID,
                                                           UOMC_FROM_INFO.UOM_ID,
                                                             ANRICORSIVELEVEL
                                                           + 1,
                                                           LNFIRSTVALUE );

                UOMC_RESULT_INFO.RESULT := GETCONVERSIONFACTOR( UOMC_RESULT_INFO.RESULT,
                                                           UOMC_FROM_INFO.UOM_ID,
                                                           ANTOUOMID,
                                                             ANRICORSIVELEVEL
                                                           + 1,
                                                           LNFIRSTVALUE );
             END IF;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                      LSMETHOD,
                                      LSMSGNOCONV);

                RETURN( LNFIRSTVALUE );
          END;
       END IF;

       RETURN( UOMC_RESULT_INFO.RESULT );
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          
          IAPIGENERAL.LOGERROR( GSSOURCE,
                                LSMETHOD,
                                LSMSGNOCONV);
          RETURN( LNFIRSTVALUE );
       WHEN OTHERS
       THEN
          IAPIGENERAL.LOGERROR( GSSOURCE,
                                LSMETHOD,
                                SQLERRM );
          RETURN( LNFIRSTVALUE );
    END GETCONVERSIONFACTOR;
    

   
   FUNCTION GETUOMSGROUPSAMETYPEEXT(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupSameTypeExt';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      OPEN AQUOMS FOR
         SELECT UG.UOM_GROUP,
                U.UOM_ID,
                U.DESCRIPTION,
                U.UOM_TYPE,
                U.UOM_BASE,
                IAPIUOMGROUPS.GETCONVERSIONFACTOR(1, GETUOMBASEGROUPSAMETYPE(U.UOM_ID), U.UOM_ID ) CONV_FACTOR
           FROM UOM_UOM_GROUP UG,
                UOM U
          WHERE U.UOM_ID = UG.UOM_ID
            AND UG.UOM_GROUP = ( SELECT UOM_GROUP
                                   FROM UOM_UOM_GROUP
                                  WHERE UOM_ID = ANUOMID )
            AND U.UOM_ID IN( SELECT UOM_ID
                              FROM UOM
                             WHERE UOM_TYPE = U.UOM_TYPE
                               AND UOM_TYPE = ( SELECT UOM_TYPE


                                                 FROM UOM
                                                WHERE UOM_ID = ANUOMID ) )
       UNION
         SELECT (SELECT UOM_GROUP
                   FROM UOM_UOM_GROUP
                  WHERE UOM_ID = ANUOMID) UOM_GROUP,
                U.UOM_ID,
                U.DESCRIPTION,
                U.UOM_TYPE,
                U.UOM_BASE,
                IAPIUOMGROUPS.GETCONVERSIONFACTOR(1, GETUOMBASEGROUPSAMETYPE(U.UOM_ID), U.UOM_ID ) CONV_FACTOR
           FROM UOM U
          WHERE U.UOM_ID = ANUOMID;


      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPSAMETYPEEXT;
   

   
   FUNCTION GETUOMSGROUPSAMETYPEEXT(
      ASUOMID                    IN       IAPITYPE.DESCRIPTION_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupSameTypeExt';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNUOMID:= GETUOMID(ASUOMID);

      LNRETVAL:= GETUOMSGROUPSAMETYPEEXT(LNUOMID, AQUOMS );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPSAMETYPEEXT;
   

   FUNCTION GETUOMSGROUPOTHERTYPE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupOtherType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNUOMBASEID                   IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNRETVAL:= GETUOMBASEGROUPOTHERTYPE(ANUOMID, LNUOMBASEID );

      OPEN AQUOMS FOR
         SELECT UG.UOM_GROUP,
                U.UOM_ID,
                U.DESCRIPTION,
                U.UOM_TYPE,
                U.UOM_BASE
           FROM UOM_UOM_GROUP UG,
                UOM U
          WHERE U.UOM_ID = UG.UOM_ID
            AND UG.UOM_GROUP = ( SELECT UOM_GROUP
                                   FROM UOM_UOM_GROUP
                                  WHERE UOM_ID = ANUOMID )
            AND U.UOM_ID IN( SELECT UOM_ID
                              FROM UOM
                             WHERE UOM_TYPE = U.UOM_TYPE
                               AND UOM_TYPE = ( SELECT MOD(   UOM_TYPE
                                                            + 1,
                                                            2 )
                                                 FROM UOM
                                                WHERE UOM_ID = ANUOMID ) )
       UNION
         SELECT (SELECT UOM_GROUP
                   FROM UOM_UOM_GROUP
                  WHERE UOM_ID = ANUOMID) UOM_GROUP,
                U.UOM_ID,
                U.DESCRIPTION,
                U.UOM_TYPE,
                U.UOM_BASE
           FROM UOM U
          WHERE U.UOM_ID = LNUOMBASEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPOTHERTYPE;

   FUNCTION GETUOMSGROUPOTHERTYPE(
      ASUOMID                    IN       IAPITYPE.DESCRIPTION_TYPE,
      AQUOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomsGroupOtherType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNUOMID:= GETUOMID(ASUOMID);

      IF  ( LNUOMID IS NULL )
      THEN
         RETURN( 0 );
      END IF;

      LNRETVAL:= GETUOMSGROUPOTHERTYPE(LNUOMID, AQUOMS );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOMSGROUPOTHERTYPE;

   FUNCTION GETUOMBASEGROUPSAMETYPE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANUOMBASEID                OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomBaseGroupSameType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT U.UOM_ID
        INTO ANUOMBASEID
        FROM UOM_UOM_GROUP UG,
             UOM U
       WHERE U.UOM_ID = UG.UOM_ID
         AND UG.UOM_GROUP = ( SELECT UOM_GROUP
                               FROM UOM_UOM_GROUP
                              WHERE UOM_ID = ANUOMID )
         AND U.UOM_ID IN( SELECT UOM_ID
                           FROM UOM
                          WHERE UOM_BASE = UOMBASE
                            AND UOM_TYPE = ( SELECT UOM_TYPE
                                              FROM UOM
                                             WHERE UOM_ID = ANUOMID ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      
      WHEN NO_DATA_FOUND
      THEN
         ANUOMBASEID := ANUOMID;

         
         



         




         
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END GETUOMBASEGROUPSAMETYPE;

   FUNCTION GETUOMBASEGROUPOTHERTYPE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANUOMBASEID                OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomBaseGroupOtherType';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT U.UOM_ID
        INTO ANUOMBASEID
        FROM UOM_UOM_GROUP UG,
             UOM U
       WHERE U.UOM_ID = UG.UOM_ID
         AND UG.UOM_GROUP = ( SELECT UOM_GROUP
                               FROM UOM_UOM_GROUP
                              WHERE UOM_ID = ANUOMID )
         AND U.UOM_ID IN( SELECT UOM_ID
                           FROM UOM
                          WHERE UOM_BASE = UOMBASE
                            AND UOM_TYPE = ( SELECT MOD(   UOM_TYPE
                                                         + 1,
                                                         2 )
                                              FROM UOM
                                             WHERE UOM_ID = ANUOMID ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      
      WHEN NO_DATA_FOUND
      THEN
         ANUOMBASEID := ANUOMID;

         
         



         




         
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END GETUOMBASEGROUPOTHERTYPE;

   FUNCTION ISUOMSSAMEGROUP(
      ANUOM                    IN       IAPITYPE.ID_TYPE,
      ANUOM_2                  IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsUomsSameGroup';
      LNCOUNT                       PLS_INTEGER;
      LNREVUOM                      PLS_INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LQUOMS                        IAPITYPE.REF_TYPE;
      LBRETVAL                      IAPITYPE.BOOLEAN_TYPE := 0;

      TYPE UOMDESCRIPTIONREC_TYPE IS RECORD(
         UOM_ID                        IAPITYPE.ID_TYPE,
         DESCRIPTION                   IAPITYPE.DESCRIPTION_TYPE
      );

      TYPE UOMDESCRIPTIONTAB_TYPE IS TABLE OF UOMDESCRIPTIONREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTUOMS                         UOMDESCRIPTIONTAB_TYPE;
   BEGIN

      SELECT COUNT( * ) REVISION
        INTO LNCOUNT
        FROM UOM_H
       WHERE UOM_ID = ANUOM
         AND LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
         AND MAX_REV = 1;

      IF LNCOUNT > 0
      THEN
         BEGIN
            
            SELECT REVISION
              INTO LNREVUOM
              FROM UOM_H
             WHERE UOM_ID = ANUOM
               AND LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
               AND MAX_REV = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               
               



                




               
               RETURN 0;
         END;
      ELSE
         BEGIN
            
            SELECT REVISION
              INTO LNREVUOM
              FROM UOM_H
             WHERE UOM_ID = ANUOM
               AND LANG_ID = 1
               AND MAX_REV = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               
               



               




               
               RETURN 0;
         END;
      END IF;

      LNRETVAL := IAPIUOMGROUPS.GETUOMDESCRIPTION( ANUOM,
                                                   NULL,
                                                   LNREVUOM,
                                                   LQUOMS );

      FETCH LQUOMS
      BULK COLLECT INTO LTUOMS;

      IF LTUOMS.COUNT > 0
      THEN
        FOR ELEM IN LTUOMS.FIRST .. LTUOMS.LAST
        LOOP
          IF ( ANUOM_2 = LTUOMS( ELEM ).UOM_ID )
            THEN
              LBRETVAL := 1;
            END IF;
          END LOOP;
      END IF;

      IF ( LQUOMS%ISOPEN )
      THEN
         CLOSE LQUOMS;
      END IF;

      RETURN LBRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( 0 );
   END ISUOMSSAMEGROUP;

   FUNCTION ISUOMSSAMEGROUP(
      ASUOM                    IN       IAPITYPE.DESCRIPTION_TYPE,
      ASUOM_2                  IN       IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsUomsSameGroup';
      LNCOUNT                       PLS_INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LQUOMS                        IAPITYPE.REF_TYPE;
      LBRETVAL                      IAPITYPE.BOOLEAN_TYPE := 0;
      LNUOM                         IAPITYPE.ID_TYPE;
      LNUOM_2                       IAPITYPE.ID_TYPE;

   BEGIN

      LNUOM:= GETUOMID(ASUOM);

      LNUOM_2:= GETUOMID(ASUOM_2);

      IF (     (     ( LNUOM IS NULL )
                 OR ( LNUOM_2 IS NULL ) )
           OR (    LENGTH( RTRIM( LTRIM( ASUOM ) ) ) = 0
                OR LENGTH( RTRIM( LTRIM( ASUOM_2 ) ) ) = 0 ) )
      THEN
         RETURN( 0 );
      END IF;

      RETURN (ISUOMSSAMEGROUP(LNUOM, LNUOM_2 ) );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( 0 );
   END ISUOMSSAMEGROUP;


   FUNCTION GETTYPEUOM(
      ANUOMID                  IN      IAPITYPE.ID_TYPE,
      ANUOMTYPE                OUT     IAPITYPE.BOOLEAN_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetTypeUom';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      ANUOMTYPE:=NULL;

      SELECT U.UOM_TYPE
        INTO ANUOMTYPE
        FROM UOM U
       WHERE U.UOM_ID = ANUOMID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( NULL );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETTYPEUOM;

   FUNCTION GETTYPEUOM(
      ASUOMID                  IN      IAPITYPE.DESCRIPTION_TYPE,
      ANUOMTYPE                OUT     IAPITYPE.BOOLEAN_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetTypeUom';
      LSSQLSELECT                   IAPITYPE.STRING_TYPE := NULL;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNUOMID:= GETUOMID(ASUOMID);

      LNRETVAL:= GETTYPEUOM(LNUOMID, ANUOMTYPE );


      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETTYPEUOM;


   FUNCTION EXISTUOMGROUPID(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistUomGroupId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANUOMGROUP IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'UOM Group' );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF UOMGROUPFOUND( ANUOMGROUP ) = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_UOMGROUPNOTFOUND,
                                                         'UOM Group' );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTUOMGROUPID;

   FUNCTION UOMGROUPFOUND(
      ANUOMGROUP                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UomGroupFound';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM UOM_GROUP
       WHERE UOM_GROUP = ANUOMGROUP;

      RETURN CASE LNCOUNT
         WHEN 0
            THEN 0
         ELSE 1
      END;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END UOMGROUPFOUND;
END IAPIUOMGROUPS;