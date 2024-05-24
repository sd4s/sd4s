CREATE OR REPLACE PACKAGE BODY iapiDeletion
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

   
   
   

   
   
   
   FUNCTION GETDAYSTODELETE(
      ASPARAMETER                IN       IAPITYPE.PARAMETER_TYPE,
      ANDAYS                     OUT      IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDaysToDelete';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT TO_NUMBER( PARAMETER_DATA )
        INTO ANDAYS
        FROM INTERSPC_CFG
       WHERE SECTION = 'DELETION'
         AND PARAMETER = ASPARAMETER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LNRETVAL :=
                IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_CONFIGPARAMVALUENOTFOUND,
                                                    ASPARAMETER,
                                                    'DELETION' );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDAYSTODELETE;

   
   FUNCTION GETUSERDELETEDSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ADSTATUSCHANGEDATE         IN       IAPITYPE.DATE_TYPE,
      ASUSERID                   OUT      IAPITYPE.USERID_TYPE,
      ASFORENAME                 OUT      IAPITYPE.FORENAME_TYPE,
      ASLASTNAME                 OUT      IAPITYPE.LASTNAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserDeletedSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LDSTATUSCHANGEDATE            IAPITYPE.DATE_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;      
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF USER <> LSSCHEMANAME
      THEN
         BEGIN
            SELECT FORENAME,
                   LAST_NAME
              INTO ASFORENAME,
                   ASLASTNAME
              FROM ITUS
             WHERE USER_ID = USER;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               ASFORENAME := 'user';
               ASLASTNAME := 'unknown';
         END;

         ASUSERID := USER;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         SELECT MAX( STATUS_DATE_TIME )
           INTO LDSTATUSCHANGEDATE
           FROM STATUS_HISTORY
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND STATUS_DATE_TIME < ADSTATUSCHANGEDATE;

          
         
         
         
         
         
         
         
         
         

        
        
         SELECT COUNT(*)
           INTO LNCOUNT
           FROM STATUS_HISTORY SH,
                STATUS SS
          WHERE SH.PART_NO = ASPARTNO
            AND SH.REVISION = ANREVISION
            AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
            AND SH.STATUS = SS.STATUS;

         IF (LNCOUNT = 1)
         THEN
         

             SELECT SS.STATUS_TYPE,
                    USER_ID
               INTO LSSTATUSTYPE,
                    LSUSERID
               FROM STATUS_HISTORY SH,
                    STATUS SS
              WHERE SH.PART_NO = ASPARTNO
                AND SH.REVISION = ANREVISION
                AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
                AND SH.STATUS = SS.STATUS;
        
        ELSE              
              
             SELECT COUNT(*)
               INTO LNCOUNT
               FROM STATUS_HISTORY SH,
                    STATUS SS
              WHERE SH.PART_NO = ASPARTNO
                AND SH.REVISION = ANREVISION
                AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
                AND SH.STATUS = SS.STATUS
                AND SS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC;
             
             IF (LNCOUNT = 1)
             THEN
                 
                 SELECT SS.STATUS_TYPE,
                        USER_ID
                   INTO LSSTATUSTYPE,
                        LSUSERID
                   FROM STATUS_HISTORY SH,
                        STATUS SS
                  WHERE SH.PART_NO = ASPARTNO
                    AND SH.REVISION = ANREVISION
                    AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
                    AND SH.STATUS = SS.STATUS
                    AND SS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC;                
             ELSE
                   
                   SELECT USER_ID
                   INTO LSUSERID
                   FROM STATUS_HISTORY SH,
                        STATUS SS
                  WHERE SH.PART_NO = ASPARTNO
                    AND SH.REVISION = ANREVISION
                    AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
                    AND SH.STATUS = SS.STATUS;                                      
             END IF;                              
        END IF;
        

         IF LSUSERID <> LSSCHEMANAME
         THEN
            BEGIN
               SELECT FORENAME,
                      LAST_NAME
                 INTO ASFORENAME,
                      ASLASTNAME
                 FROM ITUS
                WHERE USER_ID = LSUSERID;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ASFORENAME := 'user';
                  ASLASTNAME := 'unknown';
            END;

            ASUSERID := LSUSERID;
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         ELSIF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_HISTORIC
         THEN
            ASUSERID := LSUSERID;
            ASFORENAME := 'system';
            ASLASTNAME := 'user';
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         ELSE
            LNRETVAL := GETUSERDELETEDSPEC( ASPARTNO,
                                            ANREVISION,
                                            LDSTATUSCHANGEDATE,
                                            ASUSERID,
                                            ASFORENAME,
                                            ASLASTNAME );
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERDELETEDSPEC;

   
   FUNCTION ISCURRENT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.LOGICAL_TYPE
   IS
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LBCURRENT                     IAPITYPE.LOGICAL_TYPE := FALSE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsCurrent';
   BEGIN
      SELECT COUNT( PART_NO )
        INTO LNCOUNT
        FROM SPECIFICATION_HEADER
       WHERE PLANNED_EFFECTIVE_DATE <= SYSDATE
         AND NVL( OBSOLESCENCE_DATE,
                  SYSDATE ) >= SYSDATE
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF LNCOUNT >= 1
      THEN
         LBCURRENT := TRUE;
      END IF;

      RETURN LBCURRENT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN TRUE;
   END ISCURRENT;

   
   FUNCTION EXISTINATTACHEDSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.LOGICAL_TYPE
   IS
      
      
      
      
      
      

      
      
      
      LBEXISTS                      IAPITYPE.LOGICAL_TYPE := FALSE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSATTACHEDPARTNO              IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNATTACHEDREVISION            IAPITYPE.REVISION_TYPE;
      LESPECUSED                    EXCEPTION;
      LESPECUSEDASPHANTOM           EXCEPTION;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistInAttachedSpec';

      CURSOR C_SH_IN_ASH(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT   PART_NO,
                  REVISION,
                  ATTACHED_PART_NO,
                  ATTACHED_REVISION
             FROM ATTACHED_SPECIFICATION
            WHERE ATTACHED_PART_NO = ASPARTNO
         ORDER BY ATTACHED_REVISION;
   BEGIN
      OPEN C_SH_IN_ASH( ASPARTNO );

      FETCH C_SH_IN_ASH
       INTO LSPARTNO,
            LNREVISION,
            LSATTACHEDPARTNO,
            LNATTACHEDREVISION;

      WHILE C_SH_IN_ASH%FOUND
      LOOP
         IF LNATTACHEDREVISION = 0
         THEN
            
            IF ISLASTONE( ASPARTNO ) = 1
            THEN
               RAISE LESPECUSEDASPHANTOM;
            ELSE
               
               IF ISCURRENT( ASPARTNO,
                             ANREVISION ) = TRUE
               THEN
                  RAISE LESPECUSEDASPHANTOM;
               END IF;
            END IF;
         ELSIF LNATTACHEDREVISION = ANREVISION
         THEN
            RAISE LESPECUSED;
         ELSE
            LBEXISTS := LBEXISTS;
         END IF;

         FETCH C_SH_IN_ASH
          INTO LSPARTNO,
               LNREVISION,
               LSATTACHEDPARTNO,
               LNATTACHEDREVISION;
      END LOOP;

      CLOSE C_SH_IN_ASH;

      RETURN LBEXISTS;
   EXCEPTION
      WHEN LESPECUSEDASPHANTOM
      THEN
         IF C_SH_IN_ASH%ISOPEN
         THEN
            CLOSE C_SH_IN_ASH;
         END IF;

         RETURN TRUE;
      WHEN LESPECUSED
      THEN
         IF C_SH_IN_ASH%ISOPEN
         THEN
            CLOSE C_SH_IN_ASH;
         END IF;

         RETURN TRUE;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF C_SH_IN_ASH%ISOPEN
         THEN
            CLOSE C_SH_IN_ASH;
         END IF;

         RETURN TRUE;
   END EXISTINATTACHEDSPEC;


   FUNCTION EXISTINBOM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.LOGICAL_TYPE
   IS






      LBEXISTS                      IAPITYPE.LOGICAL_TYPE := FALSE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LSCOMPONENTPARTNO             IAPITYPE.PARTNO_TYPE;
      LNCOMPONENTREVISION           IAPITYPE.REVISION_TYPE;
      LESPECUSED                    EXCEPTION;
      LESPECUSEDASPHANTOM           EXCEPTION;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistInBom';

      CURSOR C_SH_IN_BOM(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT   PART_NO,
                  REVISION,
                  COMPONENT_PART,
                  COMPONENT_REVISION
             FROM BOM_ITEM
            WHERE COMPONENT_PART = ASPARTNO
              AND ( PART_NO, REVISION ) NOT IN( SELECT PART_NO,
                                                       REVISION
                                                 FROM BOM_ITEM
                                                WHERE COMPONENT_PART = ASPARTNO
                                                  AND PART_NO = ASPARTNO
                                                  AND REVISION = ANREVISION )
         ORDER BY COMPONENT_REVISION;
   BEGIN
      OPEN C_SH_IN_BOM( ASPARTNO );

      FETCH C_SH_IN_BOM
       INTO LSPARTNO,
            LNREVISION,
            LSCOMPONENTPARTNO,
            LNCOMPONENTREVISION;

      WHILE C_SH_IN_BOM%FOUND
      LOOP
         IF LNCOMPONENTREVISION IS NULL
         THEN
            
            IF ISLASTONE( ASPARTNO ) = 1
            THEN
               RAISE LESPECUSEDASPHANTOM;
            ELSE
               
               IF ISCURRENT( ASPARTNO,
                             ANREVISION ) = TRUE
               THEN
                  
                  RAISE LESPECUSEDASPHANTOM;
               END IF;
            END IF;
         ELSIF LNCOMPONENTREVISION = ANREVISION
         THEN
            RAISE LESPECUSED;
         ELSE
            LBEXISTS := LBEXISTS;
         END IF;

         FETCH C_SH_IN_BOM
          INTO LSPARTNO,
               LNREVISION,
               LSCOMPONENTPARTNO,
               LNCOMPONENTREVISION;
      END LOOP;

      CLOSE C_SH_IN_BOM;

      RETURN LBEXISTS;
   EXCEPTION
      WHEN LESPECUSEDASPHANTOM
      THEN
         
         IF C_SH_IN_BOM%ISOPEN
         THEN
            CLOSE C_SH_IN_BOM;
         END IF;

         RETURN TRUE;
      WHEN LESPECUSED
      THEN
         
         IF C_SH_IN_BOM%ISOPEN
         THEN
            CLOSE C_SH_IN_BOM;
         END IF;

         RETURN TRUE;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF C_SH_IN_BOM%ISOPEN
         THEN
            CLOSE C_SH_IN_BOM;
         END IF;

         RETURN TRUE;
   END EXISTINBOM;

   
   FUNCTION SETSPECOBSOLETE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNWORKFLOWID                  IAPITYPE.ID_TYPE;
      LNWORKFLOWID_2                IAPITYPE.ID_TYPE;
      LNNEXTSTATUS                  IAPITYPE.ID_TYPE;
      LNNEXTSTATUS_2                IAPITYPE.ID_TYPE;
      LEUNIQUEWORKFLOW              EXCEPTION;
      LEUNIQUESTATUS                EXCEPTION;
      LEWORKFLOWNOTFOUND            EXCEPTION;
      LENEXTSTATUSNOTFOUND          EXCEPTION;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetSpecObsolete';

      CURSOR C_WORKFLOW(
         ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE )
      IS
         SELECT WORK_FLOW_ID
           FROM WORKFLOW_GROUP
          WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID;

      CURSOR C_NEXTSTATUS(
         ANWORKFLOWID               IN       IAPITYPE.WORKFLOWID_TYPE,
         ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE )
      IS
         SELECT NEXT_STATUS
           FROM WORK_FLOW A,
                STATUS B,
                STATUS C
          WHERE A.STATUS = B.STATUS
            AND A.NEXT_STATUS = C.STATUS
            AND C.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE
            AND WORK_FLOW_ID = ANWORKFLOWID
            AND A.STATUS = ANSTATUS;
   BEGIN
      OPEN C_WORKFLOW( ANWORKFLOWGROUPID );

      FETCH C_WORKFLOW
       INTO LNWORKFLOWID;

      IF C_WORKFLOW%FOUND
      THEN
         FETCH C_WORKFLOW
          INTO LNWORKFLOWID_2;

         IF C_WORKFLOW%FOUND
         THEN
            RAISE LEUNIQUEWORKFLOW;
         ELSE
            OPEN C_NEXTSTATUS( LNWORKFLOWID,
                               ANSTATUS );

            FETCH C_NEXTSTATUS
             INTO LNNEXTSTATUS;

            IF C_NEXTSTATUS%FOUND
            THEN
               FETCH C_NEXTSTATUS
                INTO LNNEXTSTATUS_2;

               IF C_NEXTSTATUS%FOUND
               THEN
                  RAISE LEUNIQUESTATUS;
               ELSE
                  
                  
                  
                  UPDATE SPECIFICATION_HEADER
                     SET STATUS = LNNEXTSTATUS,
                         STATUS_CHANGE_DATE = SYSDATE
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND STATUS = ANSTATUS;

                  UPDATE PART
                     SET CHANGED_DATE = SYSDATE
                   WHERE PART_NO = ASPARTNO;

                  INSERT INTO STATUS_HISTORY
                              ( PART_NO,
                                REVISION,
                                STATUS,
                                STATUS_DATE_TIME,
                                USER_ID,
                                SORT_SEQ,
                                FORENAME,
                                LAST_NAME )
                       VALUES ( ASPARTNO,
                                ANREVISION,
                                LNNEXTSTATUS,
                                SYSDATE,
                                IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                STATUS_HISTORY_SEQ.NEXTVAL,
                                IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                                IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );

                  LNRETVAL := IAPIEMAIL.REGISTEREMAIL( ASPARTNO,
                                                       ANREVISION,
                                                       LNNEXTSTATUS,
                                                       SYSDATE,
                                                       'S',
                                                       NULL,
                                                       NULL,
                                                       LQERRORS );

                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT( ) );

                     IF C_WORKFLOW%ISOPEN
                     THEN
                        CLOSE C_WORKFLOW;
                     END IF;

                     IF C_NEXTSTATUS%ISOPEN
                     THEN
                        CLOSE C_NEXTSTATUS;
                     END IF;

                     ROLLBACK;
                     RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                  END IF;

                  COMMIT;
               END IF;
            ELSE
               RAISE LENEXTSTATUSNOTFOUND;
            END IF;

            CLOSE C_NEXTSTATUS;
         END IF;
      ELSE
         RAISE LEWORKFLOWNOTFOUND;
      END IF;

      IF C_WORKFLOW%ISOPEN
      THEN
         CLOSE C_WORKFLOW;
      END IF;

      IF C_NEXTSTATUS%ISOPEN
      THEN
         CLOSE C_NEXTSTATUS;
      END IF;

      RETURN 0;
   EXCEPTION
      WHEN LEUNIQUEWORKFLOW
      THEN
         ROLLBACK;

         IF C_WORKFLOW%ISOPEN
         THEN
            CLOSE C_WORKFLOW;
         END IF;

         IF C_NEXTSTATUS%ISOPEN
         THEN
            CLOSE C_NEXTSTATUS;
         END IF;

         IAPIGENERAL.LOGWARNING( GSSOURCE,
                                 LSMETHOD,
                                 'More than one Workflow fetched' );
         RETURN LNRETVAL;
      WHEN LEUNIQUESTATUS
      THEN
         ROLLBACK;

         IF C_WORKFLOW%ISOPEN
         THEN
            CLOSE C_WORKFLOW;
         END IF;

         IF C_NEXTSTATUS%ISOPEN
         THEN
            CLOSE C_NEXTSTATUS;
         END IF;

         IAPIGENERAL.LOGWARNING( GSSOURCE,
                                 LSMETHOD,
                                 'More than one Status for obsolete fetched' );
         RETURN LNRETVAL;
      WHEN LEWORKFLOWNOTFOUND
      THEN
         ROLLBACK;

         IF C_WORKFLOW%ISOPEN
         THEN
            CLOSE C_WORKFLOW;
         END IF;

         IF C_NEXTSTATUS%ISOPEN
         THEN
            CLOSE C_NEXTSTATUS;
         END IF;

         IAPIGENERAL.LOGWARNING( GSSOURCE,
                                 LSMETHOD,
                                 'Workflow not found' );
         RETURN LNRETVAL;
      WHEN LENEXTSTATUSNOTFOUND
      THEN
         ROLLBACK;

         IF C_WORKFLOW%ISOPEN
         THEN
            CLOSE C_WORKFLOW;
         END IF;

         IF C_NEXTSTATUS%ISOPEN
         THEN
            CLOSE C_NEXTSTATUS;
         END IF;

         IAPIGENERAL.LOGWARNING( GSSOURCE,
                                 LSMETHOD,
                                    'Next status not found of type = OBSOLETE for part '
                                 || ASPARTNO );
         RETURN LNRETVAL;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGWARNING( GSSOURCE,
                                 LSMETHOD,
                                 SQLERRM );

         IF C_WORKFLOW%ISOPEN
         THEN
            CLOSE C_WORKFLOW;
         END IF;

         IF C_NEXTSTATUS%ISOPEN
         THEN
            CLOSE C_NEXTSTATUS;
         END IF;

         ROLLBACK;
         RETURN LNRETVAL;
   END SETSPECOBSOLETE;

   
   FUNCTION DELETESPECIFICATION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      

      
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSPECIFCATIONCOUNT           IAPITYPE.NUMVAL_TYPE := 0;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteSpecification';
   BEGIN
      
      
      IF EXISTINBOM( ASPARTNO,
                     ANREVISION ) = FALSE
      THEN
         
         IF EXISTINATTACHEDSPEC( ASPARTNO,
                                 ANREVISION ) = FALSE
         THEN
            SELECT STATUS
              INTO LNSTATUS
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            LNRETVAL := GETUSERDELETEDSPEC( ASPARTNO,
                                            ANREVISION,
                                            SYSDATE,
                                            LSUSERID,
                                            LSFORENAME,
                                            LSLASTNAME );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               ROLLBACK;
               RETURN LNRETVAL;
            END IF;

            DELETE FROM SPECDATA_SERVER
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECDATA
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_LINE_TEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_LINE
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_STAGE
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_LINE_PROP
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHLNPROPLANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_TEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_SECTION
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_PROP
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_PROP_LANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM BOM_ITEM
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM BOM_HEADER
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ATTACHED_SPECIFICATION
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM USERS_APPROVED
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM REASON
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM STATUS_HISTORY
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM APPROVAL_HISTORY
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHVALD
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITBOMJRNL
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM JRNL_SPECIFICATION_HEADER
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_ING
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            
            DELETE FROM ITSPECINGALLERGEN
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;            
            

            
            DELETE FROM ITSPECINGDETAIL
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;            
            
            
            DELETE FROM ITSHBN
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITCMPPARTS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHDESCR_L
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITLABELLOG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHLY
                  WHERE ( LY_ID, LY_TYPE, DISPLAY_FORMAT ) IN( SELECT LY_ID,
                                                                      1,
                                                                      DISPLAY_FORMAT
                                                                FROM ITSHLY
                                                              MINUS
                                                              SELECT DISTINCT REF_ID,
                                                                              1,
                                                                              DISPLAY_FORMAT
                                                                         FROM SPECIFICATION_SECTION
                                                                        WHERE TYPE IN( 1, 4 ) )
                    AND LY_TYPE = 1;

            DELETE FROM ITSHLY
                  WHERE ( LY_ID, LY_TYPE, DISPLAY_FORMAT ) IN( SELECT LY_ID,
                                                                      2,
                                                                      DISPLAY_FORMAT
                                                                FROM ITSHLY
                                                              MINUS
                                                              SELECT DISTINCT STAGE,
                                                                              2,
                                                                              DISPLAY_FORMAT
                                                                         FROM SPECIFICATION_STAGE )
                    AND LY_TYPE = 2;

            DELETE FROM ITSCHS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHHS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHQ
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSPPHS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITWEBRQ
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPEC_PED_GROUP
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECDATA_CHECK
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECDATA_PROCESS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_CD
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_ING_LANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_TM
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITNUTEXPORTEDPANELS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            
            DELETE FROM ITNUTLOG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;
            
               
               
               
               
               
               
               
               
               
            
               
            IF ISLASTONE( ASPARTNO ) = 1
            THEN
               
               DELETE FROM SPECIFICATION_KW
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM EXEMPTION
                     WHERE PART_NO = ASPARTNO;





               DELETE FROM ITPRNOTE
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM PART_LOCATION
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM PART_PLANT
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM PART_L
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPRCL
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPRCL_H
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPRMFC
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPRMFC_H
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPRNOTE_H
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPRPL_H
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITSH_H
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM PART_COST
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM SPECIFICATION_KW_H
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPROBJ
                     WHERE PART_NO = ASPARTNO;

               DELETE FROM ITPROBJ_H
                     WHERE PART_NO = ASPARTNO;

               
               
               
               
               
               
               

               DELETE FROM ITNUTREFTYPE
                     WHERE PART_NO = ASPARTNO;
            END IF;

            DELETE FROM SPECIFICATION_HEADER
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            INSERT INTO ITSHDEL
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          SYSDATE,
                          LNSTATUS,
                          LSUSERID,
                          LSFORENAME,
                          LSLASTNAME );

            
            
            IF ISLASTONE( ASPARTNO ) = 0
            THEN
               DELETE FROM PART
                     WHERE PART_NO = ASPARTNO
                       AND PART_SOURCE = IAPICONSTANT.PARTSOURCE_INTERNAL;            
            END IF;            
            

            COMMIT;
            
            LNRETVAL := IAPIPLANTPART.SETPLANTACCESS( ASPARTNO );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END IF;
         ELSE
            
            LNRETVAL := 1;
         END IF;
      ELSE
         
         LNRETVAL := 2;
      END IF;

      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN LNRETVAL;
   END DELETESPECIFICATION;

   
   FUNCTION DELETEFRAME(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteFrame';
   BEGIN
      SELECT STATUS
        INTO LNSTATUS
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      DELETE FROM FRAME_TEXT
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM FRAME_PROP
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM FRAME_SECTION
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM FRAMEDATA_SERVER
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM FRAMEDATA
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM ITFRMV
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM ITFRMVPG
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM ITFRMVSC
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM ITFRMVALD
            WHERE VAL_ID IN( SELECT VAL_ID
                              FROM ITFRMVAL
                             WHERE FRAME_NO = ASFRAMENO
                               AND REVISION = ANREVISION
                               AND OWNER = ANOWNER );

      DELETE FROM ITFRMVAL
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      DELETE FROM FRAME_HEADER
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      INSERT INTO ITFRMDEL
           VALUES ( ASFRAMENO,
                    ANREVISION,
                    ANOWNER,
                    SYSDATE,
                    LNSTATUS,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );

      COMMIT;
      RETURN 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN 1;
   END DELETEFRAME;


   FUNCTION DELETEOBJECT(
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      

      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNTOBJECT                 IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteObject';
   BEGIN
      IF IAPIOBJECT.CHECKUSED( ANOBJECTID,
                               ANREVISION,
                               ANOWNER ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         DELETE FROM ITOIRAW
               WHERE OBJECT_ID = ANOBJECTID
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;

         DELETE FROM ITOID
               WHERE OBJECT_ID = ANOBJECTID
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;

         BEGIN
            SELECT COUNT( * )
              INTO LNCOUNTOBJECT
              FROM ITOID
             WHERE OBJECT_ID = ANOBJECTID
               AND OWNER = ANOWNER;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNCOUNTOBJECT := 0;
         END;

         IF LNCOUNTOBJECT = 0
         THEN
            DELETE FROM ITOIH
                  WHERE OBJECT_ID = ANOBJECTID
                    AND OWNER = ANOWNER;

            DELETE FROM ITOIKW
                  WHERE OBJECT_ID = ANOBJECTID
                    AND OWNER = ANOWNER;
         END IF;

         COMMIT;
      END IF;

      RETURN 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN 1;
   END DELETEOBJECT;


   FUNCTION DELETEREFERENCETEXT(
      ANREFTEXTTYPE              IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      

      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNTREFTEXT                IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteReferenceText';
   BEGIN
      IF IAPIREFERENCETEXT.CHECKUSED( ANREFTEXTTYPE,
                                      ANREVISION,
                                      ANOWNER ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         SELECT COUNT( * )
           INTO LNCOUNTREFTEXT
           FROM REFERENCE_TEXT
          WHERE REF_TEXT_TYPE = ANREFTEXTTYPE
            AND OWNER = ANOWNER;

         IF LNCOUNTREFTEXT = 1
         THEN
            
            DELETE FROM REF_TEXT_TYPE
                  WHERE REF_TEXT_TYPE = ANREFTEXTTYPE
                    AND OWNER = ANOWNER;
         END IF;

         DELETE FROM REFERENCE_TEXT
               WHERE REF_TEXT_TYPE = ANREFTEXTTYPE
                 AND TEXT_REVISION = ANREVISION
                 AND OWNER = ANOWNER;

         COMMIT;
      END IF;

      RETURN 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN 1;
   END DELETEREFERENCETEXT;

   
   FUNCTION SETFRAMEOBSOLETE(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetFrameObsolete';
   BEGIN
      UPDATE FRAME_HEADER
         SET STATUS = 4
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      RETURN 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN -1;
   END SETFRAMEOBSOLETE;

   
   PROCEDURE REMOVEJOBS
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETEDINJOB            IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETEDINJOBQ           IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveJobs';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'ITJOB (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         DELETE FROM ITJOB
               WHERE (   START_DATE
                       + LNDAYS ) <= SYSDATE;

         LNROWSDELETEDINJOB := SQL%ROWCOUNT;

         DELETE FROM ITJOBQ
               WHERE (   LOGDATE
                       + LNDAYS ) <= SYSDATE;

         LNROWSDELETEDINJOBQ := SQL%ROWCOUNT;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB =
                   SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETEDINJOB
                           || ' deleted in ITJOB'
                           || ' '
                           || LNROWSDELETEDINJOBQ
                           || ' deleted in ITJOBQ',
                           1,
                           60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;

         
         DELETE FROM ITQ
               WHERE END_DATE IS NULL
                 AND START_DATE <(   SYSDATE
                                   - 1 );

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEJOBS;

   
   PROCEDURE REMOVEERRORS
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveErrors';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'ITERROR (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM ITERROR;

         DELETE FROM ITERROR
               WHERE (   LOGDATE
                       + LNDAYS ) <= SYSDATE;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM ITERROR;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEERRORS;

   
   PROCEDURE REMOVESPECIFICATIONS
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNMAXHISTORICDAYS             IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSpecifications';

      CURSOR C_HISTORIC_TO_OBSOLETE(
         ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT A.PART_NO,
                A.REVISION,
                A.WORKFLOW_GROUP_ID,
                A.STATUS
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND B.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC
            AND (   A.STATUS_CHANGE_DATE                  
            
                  --+ anDays ) <= SYSDATE; --orig      
                  + ANDAYS ) <= SYSDATE                  
            AND            
            (
                (NOT EXISTS (SELECT *
                             FROM SPECIFICATION_LINE_PROP
                             WHERE COMPONENT_PART = A.PART_NO))                
                OR
                ((EXISTS (SELECT *
                             FROM SPECIFICATION_LINE_PROP
                             WHERE COMPONENT_PART = A.PART_NO))
                  AND 
                  (DECODE ((SELECT COUNT( * )
                            FROM SPECIFICATION_HEADER
                            WHERE PART_NO = A.PART_NO), 0, 0, 1, 0, 1) = 1)            
                )
            );             
            
                  

      CURSOR C_DEL_OBS_SH(
         ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT A.PART_NO,
                A.REVISION
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND B.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE
            AND (   A.STATUS_CHANGE_DATE                  
            
                  --+ anDays ) <= SYSDATE; --orig
                  + ANDAYS ) <= SYSDATE      
            AND            
            (
                (NOT EXISTS (SELECT *
                             FROM SPECIFICATION_LINE_PROP
                             WHERE COMPONENT_PART = A.PART_NO))
                OR
                ((EXISTS (SELECT *
                             FROM SPECIFICATION_LINE_PROP
                             WHERE COMPONENT_PART = A.PART_NO))
                  AND 
                  (DECODE ((SELECT COUNT( * )
                            FROM SPECIFICATION_HEADER
                            WHERE PART_NO = A.PART_NO), 0, 0, 1, 0, 1) = 1))
            );             
            
                  
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'SPEC TO OBSOLETE (d)',
                                   LNMAXHISTORICDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         OPEN C_HISTORIC_TO_OBSOLETE( LNMAXHISTORICDAYS );

         FETCH C_HISTORIC_TO_OBSOLETE
          INTO LSPARTNO,
               LNREVISION,
               LNWORKFLOWGROUPID,
               LNSTATUS;

         WHILE C_HISTORIC_TO_OBSOLETE%FOUND
         LOOP
            
            LNRETVAL := SETSPECOBSOLETE( LSPARTNO,
                                         LNREVISION,
                                         LNWORKFLOWGROUPID,
                                         LNSTATUS );

            FETCH C_HISTORIC_TO_OBSOLETE
             INTO LSPARTNO,
                  LNREVISION,
                  LNWORKFLOWGROUPID,
                  LNSTATUS;
         END LOOP;

         CLOSE C_HISTORIC_TO_OBSOLETE;

         LNRETVAL := GETDAYSTODELETE( 'SPECIFICATIONS (d)',
                                      LNDAYS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
         ELSE
            OPEN C_DEL_OBS_SH( LNDAYS );

            FETCH C_DEL_OBS_SH
             INTO LSPARTNO,
                  LNREVISION;

            WHILE C_DEL_OBS_SH%FOUND
            LOOP
               LNRETVAL := DELETESPECIFICATION( LSPARTNO,
                                                LNREVISION );

               IF LNRETVAL = 0
               THEN
                  LNROWSDELETED :=   LNROWSDELETED
                                   + 1;
               END IF;

               FETCH C_DEL_OBS_SH
                INTO LSPARTNO,
                     LNREVISION;
            END LOOP;

            CLOSE C_DEL_OBS_SH;

            
            UPDATE ITJOB
               SET JOB = SUBSTR(    LSMETHOD
                                 || ' '
                                 || LNROWSDELETED
                                 || ' deleted',
                                 1,
                                 60 )
             WHERE JOB_ID = LNJOBID;

            COMMIT;
            LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted with errors',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;

         IF C_HISTORIC_TO_OBSOLETE%ISOPEN
         THEN
            CLOSE C_HISTORIC_TO_OBSOLETE;
         END IF;

         IF C_DEL_OBS_SH%ISOPEN
         THEN
            CLOSE C_DEL_OBS_SH;
         END IF;

         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVESPECIFICATIONS;

   
   PROCEDURE REMOVEFRAMES
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFrames';

      CURSOR C_SET_OBSOLETE(
         ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT FRAME_NO,
                REVISION,
                OWNER
           FROM FRAME_HEADER
          WHERE STATUS = 3
            AND (   STATUS_CHANGE_DATE
                  + ANDAYS ) <= SYSDATE;

      CURSOR C_DEL_OBS_FH(
         ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT A.FRAME_NO,
                A.REVISION,
                A.OWNER
           FROM FRAME_HEADER A
          WHERE A.STATUS = 4
            AND (   A.STATUS_CHANGE_DATE
                  + ANDAYS ) <= SYSDATE;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'FRAME TO OBSOLETE(d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         FOR L_ROW IN C_SET_OBSOLETE( LNDAYS )
         LOOP
            LNRETVAL := SETFRAMEOBSOLETE( L_ROW.FRAME_NO,
                                          L_ROW.REVISION,
                                          L_ROW.OWNER );
         END LOOP;

         LNRETVAL := GETDAYSTODELETE( 'FRAMES (d)',
                                      LNDAYS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
         ELSE
            OPEN C_DEL_OBS_FH( LNDAYS );

            FETCH C_DEL_OBS_FH
             INTO LSFRAMENO,
                  LNREVISION,
                  LNOWNER;

            WHILE C_DEL_OBS_FH%FOUND
            LOOP
               LNRETVAL := DELETEFRAME( LSFRAMENO,
                                        LNREVISION,
                                        LNOWNER );

               IF LNRETVAL = 0
               THEN
                  LNROWSDELETED :=   LNROWSDELETED
                                   + 1;
               END IF;

               FETCH C_DEL_OBS_FH
                INTO LSFRAMENO,
                     LNREVISION,
                     LNOWNER;
            END LOOP;

            CLOSE C_DEL_OBS_FH;

            COMMIT;

            
            UPDATE ITJOB
               SET JOB = SUBSTR(    LSMETHOD
                                 || ' '
                                 || LNROWSDELETED
                                 || ' deleted',
                                 1,
                                 60 )
             WHERE JOB_ID = LNJOBID;

            COMMIT;
            LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted with errors',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;

         IF C_DEL_OBS_FH%ISOPEN
         THEN
            CLOSE C_DEL_OBS_FH;
         END IF;

         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEFRAMES;

   
   PROCEDURE REMOVEOBJECTS
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOBJECTID                    IAPITYPE.ID_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveObjects';

      CURSOR C_DEL_OBS_OB(
         ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT A.OBJECT_ID,
                A.REVISION,
                A.OWNER
           FROM ITOID A
          WHERE A.STATUS = 4
            AND (   A.LAST_MODIFIED_ON
                  + ANDAYS ) <= SYSDATE;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'OBJECTS IMAGES (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         OPEN C_DEL_OBS_OB( LNDAYS );

         FETCH C_DEL_OBS_OB
          INTO LNOBJECTID,
               LNREVISION,
               LNOWNER;

         WHILE C_DEL_OBS_OB%FOUND
         LOOP
            LNRETVAL := DELETEOBJECT( LNOBJECTID,
                                      LNREVISION,
                                      LNOWNER );

            IF LNRETVAL = 0
            THEN
               LNROWSDELETED :=   LNROWSDELETED
                                + 1;
            END IF;

            FETCH C_DEL_OBS_OB
             INTO LNOBJECTID,
                  LNREVISION,
                  LNOWNER;
         END LOOP;

         CLOSE C_DEL_OBS_OB;

         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := SQLCODE;
         ROLLBACK;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted with errors',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;

         IF C_DEL_OBS_OB%ISOPEN
         THEN
            CLOSE C_DEL_OBS_OB;
         END IF;

         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEOBJECTS;

   
   PROCEDURE REMOVEREFERENCETEXTS
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREFTEXTTYPE                 IAPITYPE.ID_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveReferenceTexts';

      CURSOR C_DEL_OBS_RT(
         ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT A.REF_TEXT_TYPE,
                A.TEXT_REVISION,
                A.OWNER
           FROM REFERENCE_TEXT A
          WHERE A.STATUS = 4
            AND (   A.LAST_MODIFIED_ON
                  + ANDAYS ) <= SYSDATE;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'REFERENCE TEXTS (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         OPEN C_DEL_OBS_RT( LNDAYS );

         FETCH C_DEL_OBS_RT
          INTO LNREFTEXTTYPE,
               LNREVISION,
               LNOWNER;

         WHILE C_DEL_OBS_RT%FOUND
         LOOP
            LNRETVAL := DELETEREFERENCETEXT( LNREFTEXTTYPE,
                                             LNREVISION,
                                             LNOWNER );

            IF LNRETVAL = 0
            THEN
               LNROWSDELETED :=   LNROWSDELETED
                                + 1;
            END IF;

            FETCH C_DEL_OBS_RT
             INTO LNREFTEXTTYPE,
                  LNREVISION,
                  LNOWNER;
         END LOOP;

         CLOSE C_DEL_OBS_RT;

         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted with errors',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;

         IF C_DEL_OBS_RT%ISOPEN
         THEN
            CLOSE C_DEL_OBS_RT;
         END IF;

         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEREFERENCETEXTS;

   
   PROCEDURE REMOVEBOMIMPLOSION
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveBomImplosion';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITBOMIMPLOSION;

      DELETE FROM ITBOMIMPLOSION;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITBOMIMPLOSION;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEBOMIMPLOSION;

   
   PROCEDURE REMOVEBOMEXPLOSION
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveBomExplosion';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITBOMEXPLOSION;

      DELETE FROM ITBOMEXPLOSION;

      DELETE FROM ITATTEXPLOSION;

      DELETE FROM ITINGEXPLOSION;

      DELETE FROM ITBOMPATH;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITBOMEXPLOSION;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEBOMEXPLOSION;

   
   PROCEDURE REMOVECOMPARE
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveCompare';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITSHCMP;

      DELETE FROM ITSHCMP;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITSHCMP;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVECOMPARE;

   
   PROCEDURE REMOVETEXTSEARCH
   IS
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveTextSearch';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITTSRESULTS;

      DELETE FROM ITTSRESULTS;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITTSRESULTS;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVETEXTSEARCH;

   
   PROCEDURE REMOVESERVER
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveServer';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM SPECDATA_SERVER;

      DELETE FROM SPECDATA_SERVER
            WHERE DATE_PROCESSED IS NOT NULL
              AND DATE_PROCESSED <   TRUNC( SYSDATE )
                                   - 7;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM SPECDATA_SERVER;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM FRAMEDATA_SERVER;

      DELETE FROM FRAMEDATA_SERVER
            WHERE DATE_PROCESSED IS NOT NULL
              AND DATE_PROCESSED <   TRUNC( SYSDATE )
                                   - 7;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM FRAMEDATA_SERVER;

      LNROWSDELETED :=   LNROWSDELETED
                       + LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVESERVER;

   
   PROCEDURE REMOVEJRNLSPEC
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveJrnlSpec';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'JRNL SPECS (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM JRNL_SPECIFICATION_HEADER;

         DELETE FROM JRNL_SPECIFICATION_HEADER
               WHERE   TIMESTAMP
                     + LNDAYS < SYSDATE;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM JRNL_SPECIFICATION_HEADER;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEJRNLSPEC;

   
   PROCEDURE REMOVEJRNLBOM
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveJrnlBom';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'JRNL BOMS (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM ITBOMJRNL;

         DELETE FROM ITBOMJRNL
               WHERE   TIMESTAMP
                     + LNDAYS < SYSDATE;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM ITBOMJRNL;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEJRNLBOM;

   
   PROCEDURE REMOVEIMPORTLOG
   IS
      
      
      
      
      
      CURSOR C_IMP_LOG(
         ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT TYPE,
                PART_NO,
                REVISION,
                OWNER,
                TIMESTAMP
           FROM ITIMP_LOG
          WHERE   TIMESTAMP
                + ANDAYS < SYSDATE;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveImportLog';
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'ITIMP_LOG(d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM ITIMP_LOG;

         DELETE FROM ITIMP_LOG
               WHERE   TIMESTAMP
                     + LNDAYS < SYSDATE;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM ITIMP_LOG;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEIMPORTLOG;

   
   PROCEDURE REMOVESECTIONSLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSectionsLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITSCUSRLOG;

      DELETE FROM ITSCUSRLOG
            WHERE TIMESTAMP <=   SYSDATE
                               - 2;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITSCUSRLOG;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         LNRETVAL := SQLCODE;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVESECTIONSLOG;

   
   PROCEDURE REMOVEIMPORTPROPBOMLOG
   
   
   
   
   
   
   IS
      
      CURSOR LQIMPORTTODELETE
      IS
         SELECT DISTINCT IMPGETDATA_NO
                    FROM ITIMPLOG
                   WHERE TIMESTAMP <   SYSDATE
                                     - 1;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveImportPropBomLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITIMPLOG;

      
      FOR LRIMPORTTODELETE IN LQIMPORTTODELETE
      LOOP
         DELETE FROM ITIMPPROP
               WHERE IMPGETDATA_NO = LRIMPORTTODELETE.IMPGETDATA_NO;

         DELETE FROM ITIMPBOM
               WHERE IMPGETDATA_NO = LRIMPORTTODELETE.IMPGETDATA_NO;

         DELETE FROM ITIMPLOG
               WHERE IMPGETDATA_NO = LRIMPORTTODELETE.IMPGETDATA_NO;
      END LOOP;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITIMPLOG;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEIMPORTPROPBOMLOG;

   
   PROCEDURE REMOVESPECIFICATIONSLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSpecificationsLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'DEL LOG SPECS (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM ITSHDEL;

         IF LNDAYS <> 9999
         THEN
            DELETE FROM ITSHDEL
                  WHERE (   DELETION_DATE
                          + LNDAYS ) <= SYSDATE;
         END IF;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM ITSHDEL;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVESPECIFICATIONSLOG;

   
   PROCEDURE REMOVEFRAMESLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFramesLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'DEL LOG FRAMES (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM ITFRMDEL;

         IF LNDAYS <> 9999
         THEN
            DELETE FROM ITFRMDEL
                  WHERE (   DELETION_DATE
                          + LNDAYS ) <= SYSDATE;
         END IF;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM ITFRMDEL;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEFRAMESLOG;

   
   PROCEDURE REMOVEDATAIMPORTLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveDataImportLog (prop)';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITIMPPROP;

      DELETE FROM ITIMPPROP;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITIMPPROP;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      LSMETHOD := 'RemoveDataImportLog (bom)';
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITIMPBOM;

      DELETE FROM ITIMPBOM;

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITIMPBOM;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEDATAIMPORTLOG;

   
   PROCEDURE REMOVENUTRITIONALLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveNutritionalLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITNUTLOG;

      DELETE FROM ITNUTLOGRESULTDETAILS
            WHERE LOG_ID IN( SELECT LOG_ID
                              FROM ITNUTLOG I,
                                   ITRDSTATUS S
                             WHERE I.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      DELETE FROM ITNUTLOGRESULT
            WHERE LOG_ID IN( SELECT LOG_ID
                              FROM ITNUTLOG I,
                                   ITRDSTATUS S
                             WHERE I.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      DELETE FROM ITNUTLOG
            WHERE LOG_ID IN( SELECT LOG_ID
                              FROM ITNUTLOG I,
                                   ITRDSTATUS S
                             WHERE I.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITNUTLOG;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVENUTRITIONALLOG;

   
   PROCEDURE REMOVETRANSLATIONGLOSSARY
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveTranslationGlossary';
      LNDAYS                        IAPITYPE.NUMVAL_TYPE;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'PRLOG (d)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM IT_TR_JRNL;

         DELETE FROM IT_TR_JRNL
               WHERE   LAST_MODIFIED_ON
                     + LNDAYS < SYSDATE;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM IT_TR_JRNL;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVETRANSLATIONGLOSSARY;

   
   PROCEDURE REMOVELABELLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveLabelLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITLABELLOG;

      DELETE FROM ITLABELLOGRESULTDETAILS
            WHERE LOG_ID IN( SELECT L.LOG_ID
                              FROM ITLABELLOG L,
                                   ITRDSTATUS S
                             WHERE L.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      DELETE FROM ITLABELLOG
            WHERE LOG_ID IN( SELECT L.LOG_ID
                              FROM ITLABELLOG L,
                                   ITRDSTATUS S
                             WHERE L.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITLABELLOG;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVELABELLOG;

   
   PROCEDURE REMOVECLAIMLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveClaimLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITCLAIMLOG;

      DELETE FROM ITCLAIMLOGRESULT
            WHERE LOG_ID IN( SELECT L.LOG_ID
                              FROM ITCLAIMLOG L,
                                   ITRDSTATUS S
                             WHERE L.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      DELETE FROM ITCLAIMLOG
            WHERE LOG_ID IN( SELECT L.LOG_ID
                              FROM ITCLAIMLOG L,
                                   ITRDSTATUS S
                             WHERE L.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITCLAIMLOG;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVECLAIMLOG;

   
   PROCEDURE REMOVENUTRITIONALEXPLOSION
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveNutritionalExplosion';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      DELETE FROM ITNUTEXPLOSION;

      LNROWSDELETED := SQL%ROWCOUNT;

      DELETE FROM ITNUTPATH;

      DELETE FROM ITNUTRESULT;

      DELETE FROM ITNUTRESULTDETAIL;

      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVENUTRITIONALEXPLOSION;

   
   PROCEDURE REMOVEFOODCLAIMLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFoodClaimLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      
      SELECT COUNT( * )
        INTO LNCOUNTBEFORE
        FROM ITFOODCLAIMLOG;

      DELETE FROM ITFOODCLAIMLOGRESULTDETAILS
            WHERE LOG_ID IN( SELECT L.LOG_ID
                              FROM ITFOODCLAIMLOG L,
                                   ITRDSTATUS S
                             WHERE L.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      DELETE FROM ITFOODCLAIMLOGRESULT
            WHERE LOG_ID IN( SELECT L.LOG_ID
                              FROM ITFOODCLAIMLOG L,
                                   ITRDSTATUS S
                             WHERE L.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      DELETE FROM ITFOODCLAIMLOG
            WHERE LOG_ID IN( SELECT L.LOG_ID
                              FROM ITFOODCLAIMLOG L,
                                   ITRDSTATUS S
                             WHERE L.STATUS = S.STATUS
                               AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );

      
      SELECT COUNT( * )
        INTO LNCOUNTAFTER
        FROM ITFOODCLAIMLOG;

      LNROWSDELETED :=   LNCOUNTBEFORE
                       - LNCOUNTAFTER;
      COMMIT;

      
      UPDATE ITJOB
         SET JOB = SUBSTR(    LSMETHOD
                           || ' '
                           || LNROWSDELETED
                           || ' deleted',
                           1,
                           60 )
       WHERE JOB_ID = LNJOBID;

      COMMIT;
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEFOODCLAIMLOG;

   
   PROCEDURE REMOVEEVENTLOG
   IS
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
      LNJOBID                       IAPITYPE.JOBID_TYPE;
      LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveEventLog';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );
      LNRETVAL := GETDAYSTODELETE( 'EVENT LOG (days)',
                                   LNDAYS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNTBEFORE
           FROM ITEVENTLOG;

         DELETE FROM ITEVENTLOG
               WHERE (   CREATED_ON
                       + LNDAYS ) <= SYSDATE;

         
         SELECT COUNT( * )
           INTO LNCOUNTAFTER
           FROM ITEVENTLOG;

         LNROWSDELETED :=   LNCOUNTBEFORE
                          - LNCOUNTAFTER;
         COMMIT;

         
         UPDATE ITJOB
            SET JOB = SUBSTR(    LSMETHOD
                              || ' '
                              || LNROWSDELETED
                              || ' deleted',
                              1,
                              60 )
          WHERE JOB_ID = LNJOBID;

         COMMIT;
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
   END REMOVEEVENTLOG;

   
   
   
   
   PROCEDURE REMOVEOBSOLETEDATA
   IS
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveObsoleteData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETCONNECTION( USER,
                                                'DELETE OBSOLETE DATA JOB' );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
         END IF;
      END IF;

      
      REMOVEJOBS;
      
      REMOVEERRORS;
      
      REMOVESPECIFICATIONS;
      
      REMOVEFRAMES;
      
      REMOVEOBJECTS;
      
      REMOVEREFERENCETEXTS;
      
      REMOVEBOMIMPLOSION;
      
      REMOVEBOMEXPLOSION;
      
      REMOVECOMPARE;
      
      REMOVETEXTSEARCH;
      
      REMOVESERVER;
      
      REMOVEJRNLSPEC;
      
      REMOVEJRNLBOM;
      
      REMOVETRANSLATIONGLOSSARY;
      
      REMOVEIMPORTLOG;
      
      REMOVEIMPORTPROPBOMLOG;
      
      REMOVESECTIONSLOG;
      
      REMOVESPECIFICATIONSLOG;
      
      REMOVEFRAMESLOG;
      
      REMOVEDATAIMPORTLOG;
      
      REMOVENUTRITIONALLOG;
      
      REMOVELABELLOG;
      
      REMOVECLAIMLOG;
      
      REMOVENUTRITIONALEXPLOSION;
      
      REMOVEFOODCLAIMLOG;
      
      REMOVEEVENTLOG;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END REMOVEOBSOLETEDATA;

   
   FUNCTION ISLASTONE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      LNSPECIFCATIONCOUNT           IAPITYPE.NUMVAL_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsLastOne';
   BEGIN
      SELECT COUNT( * )
        INTO LNSPECIFCATIONCOUNT
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO;

      RETURN LNSPECIFCATIONCOUNT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN LNSPECIFCATIONCOUNT;
   END ISLASTONE;
END IAPIDELETION;