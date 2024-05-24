CREATE OR REPLACE PACKAGE BODY iapiHealthCheck
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

   
   
   

   
   
   
   
   
   

   
   FUNCTION CHECKORPHANEDITEMSFORBOM(
      ANSPECIFICATIONTYPE        IN       IAPITYPE.ID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANUSEMOP                   IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckOrphanedItemsForBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'h.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ','
            || 'h.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ','
            || 'f_sh_descr(1, h.part_no, h.revision) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_header h, spec_access a, status s';
   BEGIN
      
      
      
      
      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      LSSQLNULL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND upper(a.user_id) = null'
         || ' AND NOT EXISTS ( SELECT 1'
         || ' FROM bom_item'
         || ' WHERE component_part = h.part_no )';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANSPECIFICATIONTYPE IS NOT NULL
      THEN
         LSFILTER :=    ' h.class3_id = '
                     || ANSPECIFICATIONTYPE;
      END IF;

      IF ANSTATUS IS NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=
               LSFILTER
            || '( s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_HISTORIC
            || ''' AND s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_OBSOLETE
            || ''' )';
      ELSIF ANSTATUS IS NOT NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'h.status = '
                     || ANSTATUS;
      END IF;

      
      
      
      
      IF     ASPLANT IS NOT NULL
         AND LENGTH(ASPLANT) > 0
      
      THEN
         LSFROM :=    LSFROM
                   || ', itpp_'
                   || ASPLANT
                   || ' itpp_'
                   || ASPLANT;

         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'itpp_'
                     || ASPLANT
                     || '.part_no = h.part_no';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSFROM :=    LSFROM
                   || ', itshq itshq';

         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || ' itshq.part_no = h.part_no AND itshq.revision = h.revision';
      END IF;

      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND upper(a.user_id) = upper(user) '
         || ' AND NOT EXISTS ( SELECT 1 '
         || ' FROM bom_item'
         || ' WHERE component_part = h.part_no )';

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=
               LSSQL
            || ' AND EXISTS ( select part_no from part_plant'
            || ' where plant_access = ''Y'''
            || ' and part_plant.part_no = h.part_no'
            || ' AND part_plant.plant IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId) )';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSSQL :=    LSSQL
                  || ' AND itshq.user_id = :UserId';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY 1';

      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 )
      THEN
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         END IF;
      ELSE
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL;
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKORPHANEDITEMSFORBOM;

   
   FUNCTION CHECKORPHANEDITEMSFORATH(
      ANSPECIFICATIONTYPE        IN       IAPITYPE.ID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANUSEMOP                   IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckOrphanedItemsForAth';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'h.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ','
            || 'h.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ','
            || 'f_sh_descr(1, h.part_no, h.revision) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_header h, spec_access a, status s';
   BEGIN
      
      
      
      
      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      LSSQLNULL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND upper(a.user_id) = null '
         || ' AND NOT EXISTS ( SELECT attached_part_no '
         || ' FROM attached_specification'
         || ' WHERE attached_part_no = h.part_no )';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANSPECIFICATIONTYPE IS NOT NULL
      THEN
         LSFILTER :=    ' h.class3_id = '
                     || ANSPECIFICATIONTYPE;
      END IF;

      IF ANSTATUS IS NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=
               LSFILTER
            || '( s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_HISTORIC
            || ''' AND s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_OBSOLETE
            || ''' )';
      ELSIF ANSTATUS IS NOT NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'h.status = '
                     || ANSTATUS;
      END IF;

      IF     ASPLANT IS NOT NULL
      
         
          AND LENGTH(TRIM(ASPLANT)) > 0
      
      THEN
         LSFROM :=    LSFROM
                   || ', itpp_'
                   || ASPLANT
                   || ' '
                   || 'itpp_'
                   || ASPLANT;

         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'itpp_'
                     || ASPLANT
                     || '.part_no = h.part_no';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSFROM :=    LSFROM
                   || ', itshq itshq';

         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || ' itshq.part_no = h.part_no AND itshq.revision = h.revision';
      END IF;

      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND upper(a.user_id) = upper(user) '
         || ' AND NOT EXISTS ( SELECT attached_part_no '
         || ' FROM attached_specification'
         || ' WHERE attached_part_no = h.part_no )';

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=
               LSSQL
            || ' AND EXISTS ( select part_no from part_plant'
            || ' where plant_access = ''Y'''
            || ' and part_plant.part_no = h.part_no'
            || ' AND part_plant.plant IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId) )';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSSQL :=    LSSQL
                  || ' AND itshq.user_id = :UserId';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY 1, 2';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );
      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      
      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 )
      THEN
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         END IF;
      ELSE
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL;
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKORPHANEDITEMSFORATH;

   
   FUNCTION CHECKDELETEDITEMSFORPARTS(
      ANSPECIFICATIONTYPE        IN       IAPITYPE.ID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANUSEMOP                   IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckDeletedItemsForParts';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'h.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ','
            || 'h.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ','
            || 'h.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ','
            || 'f_sh_descr(1, h.part_no, h.revision) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
            || ','
            || 's.sort_desc '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_header h, spec_access a, status s, part p';
      LNCOUNT                       NUMBER;
   BEGIN
       
       
       
      
      SELECT COUNT( STATUS )
        INTO LNCOUNT
        FROM STATUS
       WHERE STATUS = ANSTATUS;

      IF     LNCOUNT = 0
         AND ANSTATUS IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      SELECT COUNT( PLANT )
        INTO LNCOUNT
        FROM PLANT
       WHERE PLANT = ASPLANT;

      IF     LNCOUNT = 0
         AND ASPLANT IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      
      
      
      
      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSELECT,
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQLNULL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND h.part_no = p.part_no'
         || ' AND upper(a.user_id) = null '
         || ' AND p.obsolete = 1'
         || ' AND h.owner = null';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF ANSPECIFICATIONTYPE IS NOT NULL
      THEN
         LSFILTER :=    ' h.class3_id = '
                     || ANSPECIFICATIONTYPE;
      END IF;

      IF ANSTATUS IS NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=
               LSFILTER
            || '( s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_HISTORIC
            || ''' AND s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_OBSOLETE
            || ''' )';
      ELSIF ANSTATUS IS NOT NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'h.status = '
                     || ANSTATUS;
      END IF;

      IF ASPLANT IS NOT NULL
      THEN
         LSFROM :=    LSFROM
                   || ', itpp_'
                   || ASPLANT
                   || ' '
                   || 'itpp_'
                   || ASPLANT;

         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'itpp_'
                     || ASPLANT
                     || '.part_no = h.part_no';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSFROM :=    LSFROM
                   || ', itshq itshq';

         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || ' itshq.part_no = h.part_no AND itshq.revision = h.revision';
      END IF;

      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND h.part_no = p.part_no'
         || ' AND upper(a.user_id) = upper(user)'
         || ' AND p.obsolete = 1'
         || ' AND h.owner = '
         || IAPIGENERAL.SESSION.DATABASE.OWNER;

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=
               LSSQL
            || ' AND EXISTS ( select part_no from part_plant'
            || ' where plant_access = ''Y'''
            || ' and part_plant.part_no = h.part_no'
            || ' AND part_plant.plant IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId) )';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSSQL :=    LSSQL
                  || ' AND itshq.user_id = :UserId';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY 1, 2';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      
      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 )
      THEN
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         END IF;
      ELSE
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL;
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKDELETEDITEMSFORPARTS;

   
   FUNCTION CHECKDELETEDITEMSFORPARTPLANTS(
      ANSPECIFICATIONTYPE        IN       IAPITYPE.ID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANUSEMOP                   IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckDeletedItemsForPartPlants';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'h.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ','
            || 'h.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ','
            || 'h.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ','
            || 'f_sh_descr(1, h.part_no, h.revision) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
            || ','
            || 'p.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ','
            || 's.sort_desc '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_header h, spec_access a, status s, part_plant p';
      LNCOUNT                       NUMBER;
   BEGIN
       
       
       
      
      SELECT COUNT( STATUS )
        INTO LNCOUNT
        FROM STATUS
       WHERE STATUS = ANSTATUS;

      IF     LNCOUNT = 0
         AND ANSTATUS IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      SELECT COUNT( PLANT )
        INTO LNCOUNT
        FROM PLANT
       WHERE PLANT = ASPLANT;

      IF     LNCOUNT = 0
         AND ASPLANT IS NOT NULL
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      
      
      
      
      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      LSSQLNULL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND h.part_no = p.part_no'
         || ' AND upper(a.user_id) = null '
         || ' AND p.obsolete = 1'
         || ' AND h.owner = null';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF ANSPECIFICATIONTYPE IS NOT NULL
      THEN
         LSFILTER :=    ' h.class3_id = '
                     || ANSPECIFICATIONTYPE;
      END IF;

      IF ANSTATUS IS NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=
               LSFILTER
            || '( s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_HISTORIC
            || ''' AND s.status_type <> '''
            || IAPICONSTANT.STATUSTYPE_OBSOLETE
            || ''' )';
      ELSIF ANSTATUS IS NOT NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'h.status = '
                     || ANSTATUS;
      END IF;

      IF ASPLANT IS NOT NULL
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || 'p.plant = '''
                     || ASPLANT
                     || '''';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSFROM :=    LSFROM
                   || ', itshq itshq';

         IF LSFILTER IS NOT NULL
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LSFILTER :=    LSFILTER
                     || ' itshq.part_no = h.part_no AND itshq.revision = h.revision';
      END IF;

      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE a.access_group = h.access_group'
         || ' AND h.status = s.status'
         || ' AND h.part_no = p.part_no'
         || ' AND upper(a.user_id) = upper(user)'
         || ' AND p.obsolete = 1'
         || ' AND h.owner = '
         || IAPIGENERAL.SESSION.DATABASE.OWNER;

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=
               LSSQL
            || ' AND EXISTS ( select part_no from part_plant'
            || ' where plant_access = ''Y'''
            || ' and part_plant.part_no = h.part_no'
            || ' AND part_plant.plant IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId) )';
      END IF;

      IF ANUSEMOP = 1
      THEN
         LSSQL :=    LSSQL
                  || ' AND itshq.user_id = :UserId';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY 1, 2, 5';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      
      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 )
      THEN
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         END IF;
      ELSE
         IF ANUSEMOP = 1
         THEN
            OPEN AQITEMS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         ELSE
            OPEN AQITEMS FOR LSSQL;
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKDELETEDITEMSFORPARTPLANTS;
END IAPIHEALTHCHECK;