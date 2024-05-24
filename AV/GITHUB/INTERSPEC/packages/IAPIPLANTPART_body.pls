CREATE OR REPLACE PACKAGE BODY iapiPlantPart
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

   
   
   

   
   
   
   FUNCTION CREATEPLANTTABLE(
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LNRESULT                      PLS_INTEGER;
      LNCURSOR                      PLS_INTEGER;
      LSTABLE                       IAPITYPE.STRING_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreatePlantTable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSTABLE :=    'ITPP_'
                 || ASPLANT;
      
      LSSQL :=    'DROP TABLE '
               || LSTABLE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      LSSQL :=    'DROP PUBLIC SYNONYM '
               || LSTABLE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      
      LSSQL :=
            'CREATE TABLE '
         || LSTABLE
         || '  ('
         || ' Part_NO  VARCHAR2(18)  NOT NULL, '
         || ' CONSTRAINT XPK'
         || LSTABLE
         || ' PRIMARY KEY ( Part_NO ) '
         || ' USING INDEX  PCTFREE 10 '
         || ' STORAGE(INITIAL 34816 NEXT 34816 PCTINCREASE 0 ) '
         || ' TABLESPACE SPECI) '
         || ' TABLESPACE SPECD PCTFREE 10 '
         || ' STORAGE(INITIAL 22528 NEXT 22528 PCTINCREASE 0 ) '
         || ' PARALLEL (DEGREE 1 INSTANCES 1) NOCACHE ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            IF SQLCODE IN( -911, -922 )
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FOUNDINVALIDCHARSINPLANT,
                                                           ASPLANT ) );
            ELSE
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                           ASPLANT ) );
            END IF;
      END;

      
      LSSQL :=    'INSERT INTO '
               || LSTABLE
               || ' SELECT DISTINCT PART_NO FROM PART_PLANT WHERE PLANT = '''
               || ASPLANT
               || '''';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      
      LSSQL :=    'GRANT SELECT ON '
               || LSTABLE
               || ' TO APPROVER';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT ON '
               || LSTABLE
               || ' TO MRP';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT ON '
               || LSTABLE
               || ' TO VIEW_ONLY';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT, INSERT, DELETE, UPDATE ON '
               || LSTABLE
               || ' TO CONFIGURATOR';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT, INSERT, DELETE, UPDATE ON '
               || LSTABLE
               || ' TO DEV_MGR';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT, INSERT, DELETE, UPDATE ON '
               || LSTABLE
               || ' TO FRAME_BUILDER';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      
      LSSQL :=    'CREATE PUBLIC SYNONYM '
               || LSTABLE
               || ' FOR '
               || LSTABLE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATEPLANTTABLE;

   
   FUNCTION REMOVEPLANTTABLE(
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LNRESULT                      PLS_INTEGER;
      LNCURSOR                      PLS_INTEGER;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSTABLE                       IAPITYPE.STRING_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemovePlantTable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PLANT = ASPLANT;

      IF LNCOUNT > 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PLANTUSED,
                                                    ASPLANT );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM PART_PLANT
       WHERE PLANT = ASPLANT;

      IF LNCOUNT > 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PLANTUSED,
                                                    ASPLANT );
      END IF;

      LSTABLE :=    'ITPP_'
                 || ASPLANT;
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;
      LSSQL :=    'DROP TABLE '
               || LSTABLE
               || ' CASCADE CONSTRAINTS ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
      END;

      LSSQL :=    'DROP PUBLIC SYNONYM '
               || LSTABLE;

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
      END;

      
      DELETE FROM ITUP
            WHERE PLANT = ASPLANT;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEPLANTTABLE;

   
   
   
   FUNCTION ASSIGNPARTTOPLANT(
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSTABLE                       IAPITYPE.STRING_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSDEFAULTCURRENCY             IAPITYPE.CURRENCY_TYPE;
      LSBASEUOM                     IAPITYPE.BASEUOM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AssignPartToPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSTABLE :=    'ITPP_'
                 || ASPLANT;
      LSSQL :=    'INSERT INTO '
               || LSTABLE
               || ' VALUES (:asPartNo )';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      EXECUTE IMMEDIATE LSSQL
                  USING ASPARTNO;

      
      BEGIN
         SELECT PARAMETER_DATA
           INTO LSDEFAULTCURRENCY
           FROM INTERSPC_CFG
          WHERE PARAMETER = 'def_part_currency'
            AND SECTION = 'interspec';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            IAPIGENERAL.LOGWARNING( GSSOURCE,
                                    LSMETHOD,
                                    'No DEFAULT currency defined IN configuration' );
            LSDEFAULTCURRENCY := 'EU';
      END;

      SELECT BASE_UOM
        INTO LSBASEUOM
        FROM PART
       WHERE PART_NO = ASPARTNO;

      INSERT INTO PART_COST
                  ( PART_NO,
                    PERIOD,
                    CURRENCY,
                    PRICE,
                    PRICE_TYPE,
                    UOM,
                    PLANT )
           VALUES ( ASPARTNO,
                    'manual',
                    LSDEFAULTCURRENCY,
                    NULL,
                    'IS',
                    LSBASEUOM,
                    ASPLANT );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ASSIGNPARTTOPLANT;

   
   FUNCTION GETPLANTACCESS(
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTACCESS              OUT      IAPITYPE.PLANTACCESS_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
      
       
       
       
       
       
       
      CURSOR LQSPECTYPE(
         LSPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT DISTINCT DECODE( ST.STATUS_TYPE,
                                 IAPICONSTANT.STATUSTYPE_DEVELOPMENT, 1,
                                 IAPICONSTANT.STATUSTYPE_SUBMIT, 1,
                                 IAPICONSTANT.STATUSTYPE_REJECT, 1,
                                 IAPICONSTANT.STATUSTYPE_APPROVED, 1,
                                 IAPICONSTANT.STATUSTYPE_CURRENT, 1,
                                 IAPICONSTANT.STATUSTYPE_HISTORIC, 2,
                                 IAPICONSTANT.STATUSTYPE_OBSOLETE, 2,
                                 1 ) STATUS_TYPE_GROUP
                    FROM STATUS ST,
                         SPECIFICATION_HEADER SH
                   WHERE ST.STATUS = SH.STATUS
                     AND SH.PART_NO = LSPARTNO
                ORDER BY 1;

      LNSTATUS                      PLS_INTEGER;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlantAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNSTATUS := 0;

      FOR LRSPECTYPE IN LQSPECTYPE( ASPARTNO )
      LOOP
         LNSTATUS := LRSPECTYPE.STATUS_TYPE_GROUP;
         EXIT;
      END LOOP;

      IF LNSTATUS = 0
      THEN
         
         ASPLANTACCESS := 'Y';
      ELSIF LNSTATUS = 1
      THEN
         
         
         SELECT COUNT( 1 )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION SS,
                STATUS ST,
                SPECIFICATION_HEADER SH
          WHERE SS.TYPE = IAPICONSTANT.SECTIONTYPE_BOM
            AND SS.REVISION = SH.REVISION
            AND SS.PART_NO = SH.PART_NO
            AND ST.STATUS_TYPE NOT IN( IAPICONSTANT.STATUSTYPE_HISTORIC, IAPICONSTANT.STATUSTYPE_OBSOLETE )
            AND ST.STATUS = SH.STATUS
            AND SH.PART_NO = ASPARTNO;

         IF LNCOUNT = 0
         THEN
            
            ASPLANTACCESS := 'Y';
         ELSE
            
            
            SELECT COUNT( 1 )
              INTO LNCOUNT
              FROM BOM_HEADER BH,
                   STATUS ST,
                   SPECIFICATION_HEADER SH
             WHERE BH.PLANT = ASPLANT
               AND BH.REVISION = SH.REVISION
               AND BH.PART_NO = SH.PART_NO
               AND ST.STATUS_TYPE NOT IN( IAPICONSTANT.STATUSTYPE_HISTORIC, IAPICONSTANT.STATUSTYPE_OBSOLETE )
               AND ST.STATUS = SH.STATUS
               AND SH.PART_NO = ASPARTNO;

            IF LNCOUNT = 0
            THEN
							
               
               
							 ASPLANTACCESS := 'Y';
							
            ELSE
               
               ASPLANTACCESS := 'Y';
            END IF;
         END IF;
      ELSE
         
         
         SELECT COUNT( 1 )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION SS
          WHERE SS.TYPE = IAPICONSTANT.SECTIONTYPE_BOM
            AND SS.PART_NO = ASPARTNO;

         IF LNCOUNT = 0
         THEN
            
            ASPLANTACCESS := 'Y';
         ELSE
					 
            
            
            
						ASPLANTACCESS := 'Y';
					 
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
   END GETPLANTACCESS;

   
   FUNCTION SETPLANTACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQPARTPLANTS(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT PLANT
           FROM PART_PLANT
          WHERE PART_NO = ASPARTNO;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetPlantAccess';
      LSPLANTACCESS                 IAPITYPE.PLANTACCESS_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRPARTPLANTS IN LQPARTPLANTS( ASPARTNO )
      LOOP
         LNRETVAL := GETPLANTACCESS( LRPARTPLANTS.PLANT,
                                     ASPARTNO,
                                     LSPLANTACCESS );

         UPDATE PART_PLANT
            SET PLANT_ACCESS = LSPLANTACCESS
          WHERE PLANT = LRPARTPLANTS.PLANT
            AND PART_NO = ASPARTNO;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETPLANTACCESS;

   
   FUNCTION REMOVEPARTFROMPLANT(
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSTABLE                       IAPITYPE.STRING_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemovePartFromPlant';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSTABLE :=    'ITPP_'
                 || ASPLANT;
      LSSQL :=    'DELETE FROM '
               || LSTABLE
               || ' WHERE Part_NO = :asPartNo';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      EXECUTE IMMEDIATE LSSQL
                  USING ASPARTNO;

      
      DELETE FROM PART_COST
            WHERE PART_NO = ASPARTNO
              AND PLANT = ASPLANT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEPARTFROMPLANT;

   
   FUNCTION INSERTPLANTPART
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      CURSOR CUR_PLANTS(
         ASSCHEMANAME               IN       IAPITYPE.DATABASESCHEMANAME_TYPE )
      IS
         SELECT PLANT
           FROM PLANT
          WHERE    'ITPP_'
                || UPPER( PLANT ) NOT IN( SELECT OBJECT_NAME
                                           FROM DBA_OBJECTS
                                          WHERE OWNER = ASSCHEMANAME
                                            AND OBJECT_TYPE = 'TABLE'
                                            AND OBJECT_NAME LIKE 'ITPP_%' );

      CURSOR CUR_PARTS(
         ASPLANT                    IN       IAPITYPE.PLANT_TYPE )
      IS
         SELECT PART_NO
           FROM PART_PLANT
          WHERE PLANT = ASPLANT;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'InsertPlantPart';
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      ELSE
         
         
         FOR REC_PLANT IN CUR_PLANTS( LSSCHEMANAME )
         LOOP
            BEGIN
               LNRETVAL := CREATEPLANTTABLE( REC_PLANT.PLANT );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;
         END LOOP;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END INSERTPLANTPART;
END IAPIPLANTPART;