CREATE OR REPLACE PACKAGE BODY iapiQueue
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

   
   
   

   
   
   
   PROCEDURE LOGQUEUE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      
      
      
      
      
      
      ASMESSAGE                  IN       IAPITYPE.ERRORTEXT_TYPE,  
      
      
      
      LSCULTUREID                IN       IAPITYPE.CULTURE_TYPE DEFAULT 'en',
      LNPROCESSED                IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0 )
      
   IS







      
      
      
      
      
      
      LSMESSAGE                     IAPITYPE.ERRORTEXT_TYPE;  
      LSMESSAGE2                    IAPITYPE.STRING_TYPE;  
      
    LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogQueue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCONSTANTDBERROR             IAPITYPE.ERRORNUM_TYPE;

      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.ISNUMERIC( ASMESSAGE );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN   
         LNCONSTANTDBERROR := TO_NUMBER( ASMESSAGE );
         LSMESSAGE := F_GET_MESSAGE( LNCONSTANTDBERROR,
                                     LSCULTUREID );
      ELSE
         LSMESSAGE := ASMESSAGE;
      END IF;

      
      IF (LNPROCESSED = 0)
      THEN
      
          LSMESSAGE := SUBSTR(    'Specification '
                               || ASPARTNO
                               || ' ['
                               || ANREVISION
                               || '] not processed: '
                               || LSMESSAGE,
                               1,
          
          
          
          
          
          
                               2048 );

          LSMESSAGE2 := 'Specification '
                               || ASPARTNO
                               || ' ['
                               || ANREVISION
                               || '] not processed: ';

          
      
      ELSE
        IF (LNPROCESSED = 1)
        THEN
          LSMESSAGE := SUBSTR(    'Specification '
                               || ASPARTNO
                               || ' ['
                               || ANREVISION
                               || '] processed: '
                               || LSMESSAGE,
                               1,
                              
                               
                               2048 );

          LSMESSAGE2 := 'Specification '
                               || ASPARTNO
                               || ' ['
                               || ANREVISION
                               || '] processed: ';

                               
       
            
       END IF;

    END IF;
    

      
      IF ( LENGTH(LSMESSAGE) > GNMAXLENGTH )
      THEN
          BEGIN
              INSERT INTO ITJOBQ
                      ( JOB_SEQ,
                        USER_ID,
                        LOGDATE,
                        ERROR_MSG )
               VALUES ( JOBQ_SEQ.NEXTVAL,
                        IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                        SYSDATE,
                        LSMESSAGE2 || 'Error message too long. Please consult Specification Note for further details.' );


             
             INSERT INTO ITPRNOTE
                         ( PART_NO,
                           TEXT )
                  VALUES ( ASPARTNO,
                           LSMESSAGE );
          EXCEPTION
             WHEN DUP_VAL_ON_INDEX
             THEN
                UPDATE ITPRNOTE
                   SET TEXT = TEXT || LSMESSAGE
                 WHERE PART_NO = ASPARTNO;
          END;

          BEGIN
            SP_NOTE_HISTORY (ASPARTNO);
          END;
      ELSE
      
          INSERT INTO ITJOBQ
                      ( JOB_SEQ,
                        USER_ID,
                        LOGDATE,
                        ERROR_MSG )
               VALUES ( JOBQ_SEQ.NEXTVAL,
                        IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                        SYSDATE,
                        LSMESSAGE );
      
      END IF;
      

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END LOGQUEUE;



   PROCEDURE LOGQUEUE2(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASMESSAGE                  IN       IAPITYPE.STRING_TYPE,
      ANMESSAGETYPE              IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0
      )





   IS
      LSMESSAGE                     IAPITYPE.STRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := ' LogQueue2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF (ANMESSAGETYPE = 2)
      THEN
        LSMESSAGE := SUBSTR(    'Specification '
                               || ASPARTNO
                               || ' ['
                               || ANREVISION
                               || '] partially processed: '
                               || ASMESSAGE,
                            1,
                            255 );
      ELSE 
        LSMESSAGE := SUBSTR(    'Specification '
                               || ASPARTNO
                               || ' ['
                               || ANREVISION
                               || '] not processed: '
                               || ASMESSAGE,
                            1,
                            255 );
      END IF;

      INSERT INTO ITJOBQ
                  ( JOB_SEQ,
                    USER_ID,
                    LOGDATE,
                    ERROR_MSG )
           VALUES ( JOBQ_SEQ.NEXTVAL,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                    SYSDATE,
                    LSMESSAGE );

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END LOGQUEUE2;


   
   PROCEDURE JOBCANCELLED(
      ANPROGRESS                 IN       IAPITYPE.NUMVAL_TYPE,
      ANCOUNT                    IN       IAPITYPE.NUMVAL_TYPE )
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'JobCancelled';
      LSMESSAGE                     IAPITYPE.STRING_TYPE;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITQ
         SET PROGRESS = ANPROGRESS,
             END_DATE = SYSDATE
       WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      INSERT INTO ITJOBQ
                  ( JOB_SEQ,
                    USER_ID,
                    LOGDATE,
                    ERROR_MSG )
           VALUES ( JOBQ_SEQ.NEXTVAL,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                    SYSDATE,
                       'Job cancelled / '
                    || ANCOUNT
                    || ' items processed' );

      DBMS_ALERT.SIGNAL(    'CL_Q'
                         || IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                         'Q_CANCELLED' );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END JOBCANCELLED;

   
   PROCEDURE JOBFINISHED(
      ANPROGRESS                 IN       IAPITYPE.NUMVAL_TYPE )
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'JobFinished';
      LSMESSAGE                     IAPITYPE.STRING_TYPE;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITQ
         SET PROGRESS = ANPROGRESS,
             STATUS = IAPICONSTANT.FINISHED_TEXT,
             END_DATE = SYSDATE
       WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      DBMS_ALERT.SIGNAL(    'CL_Q'
                         || IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                         'Q_CANCELLED' );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END;

   
   
   PROCEDURE RELEASELOCK  
   (ASLOCKNAME       IN        VARCHAR2,
    ASLOCKHANDLE     IN        VARCHAR2)
   IS
   LNRETURNCODE                   INTEGER;
   BEGIN
      
      LNRETURNCODE := DBMS_LOCK.RELEASE(ASLOCKHANDLE);
      IF LNRETURNCODE = 4 THEN
         RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||ASLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');
      ELSIF LNRETURNCODE <> 0 THEN
         RAISE_APPLICATION_ERROR(-20000, 'Release Lock for '||ASLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.RELEASE doc for details)');
      END IF;
   END RELEASELOCK;
   
   

   
   
   PROCEDURE EXECUTEQUEUE
   IS
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteQueue';
      LSALERTMESSAGE                VARCHAR2( 200 );
      LNSTATUSID                    IAPITYPE.ID_TYPE;
      
      
      LSERRORMESSAGE                VARCHAR2( 1024 );
      LSSTATUS                      VARCHAR2( 18 );
      LNTOTALRECORDS                PLS_INTEGER;
      LNRECCOUNT                    PLS_INTEGER;
      LNPROGRESS                    PLS_INTEGER;
      LSJOB                         VARCHAR2( 255 );
      
      
      
      
      
      LSSQLERRORMESSAGE             VARCHAR2( 2048 );
      
      
      LNMULTIINDEV                  IAPITYPE.BOOLEAN_TYPE;
      LNLOCAL                       PLS_INTEGER;
      LNNEWFRAMEREVISION            IAPITYPE.REVISION_TYPE;
      LNOLDFRAMEREVISION            IAPITYPE.REVISION_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LNNEXTREVISION                IAPITYPE.REVISION_TYPE;
      LBFIRSTTIME                   BOOLEAN := TRUE;
      LBALLOWED                     BOOLEAN := TRUE;
      LBCONTINUE                    BOOLEAN := TRUE;
      LSTOUNIT                      PART.BASE_TO_UNIT%TYPE;
      LSUOM                         BOM_ITEM.UOM%TYPE;
      LNMRP                         IAPITYPE.ID_TYPE;
      LNEFFECTIVEDATEOFFSET         PLS_INTEGER;
      LNWORKFLOWGROUPID             IAPITYPE.ID_TYPE;
      LNACCESSGROUPID               IAPITYPE.ID_TYPE;
      LNCLASS3ID                    IAPITYPE.ID_TYPE;
      LNERRORCODE                   VARCHAR2( 5 );
      LSCURRENTCOMPONENTUOM         BOM_ITEM.UOM%TYPE;
      LSAUTOCALC                    IAPITYPE.BOMITEMCALCFLAG_TYPE;
      LSCOMPONENTPLANT              IAPITYPE.PLANT_TYPE;
      LSCOMPONENTPLANTCOUNT         PLS_INTEGER;
      LSCOMPONENTUOM                BOM_ITEM.TO_UNIT%TYPE;
      LNSUM                         BOM_HEADER.BASE_QUANTITY%TYPE;
      LSPLANTCOUNT                  PLS_INTEGER;
      LSBASEUOM                     PART.BASE_UOM%TYPE;
      LSPEDINSYNC                   SPECIFICATION_HEADER.PED_IN_SYNC%TYPE;
      LDNEWPED                      IAPITYPE.DATE_TYPE;
      LSPREFIX_COUNT                PLS_INTEGER;
      LSPREFIX_OK                   BOOLEAN;
      LSPREFIX                      SPEC_PREFIX_DESCR.PREFIX%TYPE;
      LNPIT                         IAPITYPE.PHASEINTOLERANCE_TYPE;
      LDPED                         IAPITYPE.DATE_TYPE;
      LSBASETOUNIT                  PART.BASE_TO_UNIT%TYPE;
      LNBASECONVFACTOR              PART.BASE_CONV_FACTOR%TYPE;
      LNOBSOLETE                    PART_PLANT.OBSOLETE%TYPE;
      LNLEADTIMEOFFSET              PART_PLANT.LEAD_TIME_OFFSET%TYPE;
      LNRELEVENCYTOCOSTING          PART_PLANT.RELEVENCY_TO_COSTING%TYPE;
      LNBULKMATERIAL                PART_PLANT.BULK_MATERIAL%TYPE;
      LNITEMCATEGORY                PART_PLANT.ITEM_CATEGORY%TYPE;
      LSISSUELOCATION               PART_PLANT.ISSUE_LOCATION%TYPE;
      LNASSEMBLYSCRAP               PART_PLANT.ASSEMBLY_SCRAP%TYPE;
      LSCOMPONENTSCRAP              PART_PLANT.COMPONENT_SCRAP%TYPE;
      LSSTATUSTYPETO                IAPITYPE.STATUSTYPE_TYPE;
      LSSTATUSTYPEFROM              IAPITYPE.STATUSTYPE_TYPE;
      LNITEMNUMBER                  IAPITYPE.BOMITEMNUMBER_TYPE;
      LNSEMI1                       PLS_INTEGER;
      LNSEMI2                       PLS_INTEGER;
      LNSEMI3                       PLS_INTEGER;
      LNSEMI4                       PLS_INTEGER;
      LNSEMI5                       PLS_INTEGER;
      LNSEMI6                       PLS_INTEGER;
      LNSEMI7                       PLS_INTEGER;
      LNDISPLAYFORMATID             IAPITYPE.ID_TYPE;
      LNDISPLAYFORMATREV            IAPITYPE.REVISION_TYPE;
      LNCOLTYPE                     PLS_INTEGER;
      LNTYPE2                       PLS_INTEGER;
      LNFIELDID                     PLS_INTEGER;
      LNREFID                       IAPITYPE.ID_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNPROPERTYGROUPID             IAPITYPE.ID_TYPE;
      LNPROPERTYID                  IAPITYPE.ID_TYPE;
      LNATTRIBUTEID                 IAPITYPE.ID_TYPE;
      LNHEADERID                    IAPITYPE.ID_TYPE;
      LNCONFIGURATIONID             IAPITYPE.ID_TYPE;
      LNSTAGEID                     IAPITYPE.ID_TYPE;
      LNCONVFACTOR                  IAPITYPE.BOMCONVFACTOR_TYPE;
      LSTYPE                        VARCHAR2( 1 );
      LSPLANT                       VARCHAR2( 8 );
      LSLINE                        VARCHAR2( 4 );
      LSCOMP                        VARCHAR2( 18 );
      LSCULTUREID                   IAPITYPE.CULTURE_TYPE;
      
      LSLOCKNAME                    VARCHAR2(30);
      LSLOCKHANDLE                  VARCHAR2(200);
      LBLOCKED                      BOOLEAN;
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      
      LRSTANDARDQ                   IAPITYPE.STANDARDQREC_TYPE;
      LTSTANDARDQ                   IAPITYPE.STANDARDQTAB_TYPE;
      
      
      LSREASONMANDATORY             IAPITYPE.MANDATORY_TYPE;
      LSSTATUSTYPE                  REASON.STATUS_TYPE%TYPE;
      LNREASONID                    IAPITYPE.ID_TYPE;
      
      
      
      LSTEXT                        IAPITYPE.BUFFER_TYPE;
      
      LRERROR                       IAPITYPE.ERRORREC_TYPE;
      
      LSITEMCATEGORY                PART_PLANT.ITEM_CATEGORY%TYPE;
      LSRELEVENCYTOCOSTING          PART_PLANT.RELEVENCY_TO_COSTING%TYPE;
      LSBULKMATERIAL                PART_PLANT.BULK_MATERIAL%TYPE;
      LNCOMPONENTSCRAP              PART_PLANT.COMPONENT_SCRAP%TYPE;
      LNCOMPONENTSCRAPSYNC          PART_PLANT.COMPONENT_SCRAP_SYNC%TYPE;
      LSISSUELOCATION2              PART_PLANT.ISSUE_LOCATION%TYPE;
      LNLEADTIMEOFFSET2             PART_PLANT.LEAD_TIME_OFFSET%TYPE;
      LNOPERATIONALSTEP             PART_PLANT.OPERATIONAL_STEP%TYPE;
      
      
      LNWFGID                       SPECIFICATION_HEADER.WORKFLOW_GROUP_ID%TYPE;

      AQERRORS                      IAPITYPE.REF_TYPE;
      ARERROR                       IAPITYPE.ERRORREC_TYPE;


      CURSOR C_STANDARD_Q(
         ASUSER                              IAPITYPE.USERID_TYPE )
      IS
         SELECT SH.STATUS,
                Q.REVISION,
                Q.PART_NO,
                Q.STATUS_TO,
                Q.TEXT,
                SS.STATUS_TYPE,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              ASUSER,
                              Q.USER_INTL ) CF_ACCESS,
                USER_ID,
                Q.ES_SEQ_NO,
                Q.USER_INTL,
                SH.INTL
           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS SS
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND SH.STATUS = SS.STATUS
            

            AND USER_ID = ASUSER
            AND SELECTED = 1;
            

      
      
      TYPE FRRREC_TYPE IS RECORD(
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         USER_INTL                     ITSHQ.USER_INTL%TYPE,
         FRAME_ID                      IAPITYPE.FRAMENO_TYPE,
         FRAME_OWNER                   IAPITYPE.OWNER_TYPE,
         NEW_FRAME_NO                  IAPITYPE.FRAMENO_TYPE,
         NEW_FRAME_OWNER               IAPITYPE.OWNER_TYPE,
         FRAME_REV                     IAPITYPE.FRAMEREVISION_TYPE,
         STATUS                        IAPITYPE.STATUSID_TYPE,
         STATUS_TYPE                   IAPITYPE.STATUSTYPE_TYPE,
         WORKFLOW_GROUP_ID             IAPITYPE.ID_TYPE,
         ACCESS_GROUP                  IAPITYPE.ID_TYPE,
         CLASS3_ID                     IAPITYPE.ID_TYPE,
         INTL                          IAPITYPE.INTL_TYPE,
         INT_PART_NO                   IAPITYPE.PARTNO_TYPE,
         INT_PART_REV                  IAPITYPE.REVISION_TYPE,
         CF_ACCESS                     NUMBER,
         VIEW_ID                       IAPITYPE.ID_TYPE
      );

      LRFRR                         FRRREC_TYPE;

      TYPE FRRTAB_TYPE IS TABLE OF FRRREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTFRR                         FRRTAB_TYPE;

      CURSOR C_FRR(
         LSUSER                              ITSHQ.USER_ID%TYPE )
      IS
         SELECT Q.PART_NO,
                Q.REVISION,
                Q.USER_INTL,
                SH.FRAME_ID,
                SH.FRAME_OWNER,
                Q.FRAME_NO NEW_FRAME_NO,
                Q.FRAME_OWNER NEW_FRAME_OWNER,
                SH.FRAME_REV,
                SH.STATUS,
                S.STATUS_TYPE,
                SH.WORKFLOW_GROUP_ID,
                SH.ACCESS_GROUP,
                SH.CLASS3_ID,
                SH.INTL,
                SH.INT_PART_NO,
                SH.INT_PART_REV,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              LSUSER,
                              Q.USER_INTL ) CF_ACCESS,
                Q.VIEW_ID
           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS S
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND USER_ID = LSUSER
            AND SH.STATUS = S.STATUS;

      
      
      TYPE RBIREC_TYPE IS RECORD(
         STATUS                        IAPITYPE.STATUSID_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         STATUS_TO                     IAPITYPE.STATUSID_TYPE,
         USER_INTL                     ITSHQ.USER_INTL%TYPE,
         INTL                          IAPITYPE.INTL_TYPE,
         STATUS_TYPE                   IAPITYPE.STATUSTYPE_TYPE,
         FROM_PART                     ITSHQ.TEXT%TYPE,
         TO_PART                       ITSHQ.TEXT%TYPE,
         CF_ACCESS                     NUMBER,
         USER_ID                       IAPITYPE.USERID_TYPE
      );

      LRRBI                         RBIREC_TYPE;

      TYPE RBITAB_TYPE IS TABLE OF RBIREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTRBI                         RBITAB_TYPE;

      CURSOR C_RBI(
         LSUSER                              ITSHQ.USER_ID%TYPE )
      IS
         SELECT SH.STATUS,
                Q.REVISION,
                Q.PART_NO,
                Q.STATUS_TO,
                Q.USER_INTL,
                SH.INTL,
                S.STATUS_TYPE,
                SUBSTR( Q.TEXT,
                        1,
                          INSTR( Q.TEXT,
                                 '##@##' )
                        - 1 ) FROM_PART,
                SUBSTR( Q.TEXT,
                          INSTR( Q.TEXT,
                                 '##@##' )
                        + 5 ) TO_PART,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              LSUSER,
                              Q.USER_INTL ) CF_ACCESS,
                USER_ID
           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS S
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND USER_ID = LSUSER
            AND SH.STATUS = S.STATUS
            AND Q.TEXT LIKE '%##@##%';

      
      TYPE BIREC_TYPE IS RECORD(
         STATUS                        IAPITYPE.STATUSID_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         STATUS_TO                     IAPITYPE.STATUSID_TYPE,
         USER_INTL                     ITSHQ.USER_INTL%TYPE,
         INTL                          IAPITYPE.INTL_TYPE,
         STATUS_TYPE                   IAPITYPE.STATUSTYPE_TYPE,
         B_PART                        ITSHQ.TEXT%TYPE,
         PLANT                         IAPITYPE.PLANTNO_TYPE,
         CF_ACCESS                     NUMBER,
         USER_ID                       IAPITYPE.USERID_TYPE,
         NEW_VALUE_NUM                 ITSHQ.NEW_VALUE_NUM%TYPE
      );

      LRBI                          BIREC_TYPE;

      TYPE BITAB_TYPE IS TABLE OF BIREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTBI                          BITAB_TYPE;

      CURSOR C_BI(
         LSUSER                              ITSHQ.USER_ID%TYPE )
      IS
         SELECT SH.STATUS,
                Q.REVISION,
                Q.PART_NO,
                Q.STATUS_TO,
                Q.USER_INTL,
                SH.INTL,
                S.STATUS_TYPE,
                Q.TEXT B_PART,
                Q.PLANT,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              LSUSER,
                              Q.USER_INTL ) CF_ACCESS,
                USER_ID,
                NEW_VALUE_NUM
           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS S
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND USER_ID = LSUSER
            AND SH.STATUS = S.STATUS
            AND Q.TEXT IS NOT NULL;

      
      
      TYPE BOMHEADERREC_TYPE IS RECORD(
         ALTERNATIVE                   IAPITYPE.BOMALTERNATIVE_TYPE,
         BOM_USAGE                     IAPITYPE.BOMUSAGE_TYPE,
         PLANT                         IAPITYPE.PLANTNO_TYPE
      );

      LRBOMHEADER                   BOMHEADERREC_TYPE;

      TYPE BOMHEADERTAB_TYPE IS TABLE OF BOMHEADERREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTBOMHEADER                   BOMHEADERTAB_TYPE;

      CURSOR C_BOM_HEADER(
         ASPARTNO                            BOM_HEADER.PART_NO%TYPE,
         ANREVISION                          BOM_HEADER.REVISION%TYPE,
         A_COMPONENT_PART                    BOM_ITEM.COMPONENT_PART%TYPE )
      IS
         SELECT BH.ALTERNATIVE,
                BH.BOM_USAGE,
                BH.PLANT
           FROM BOM_ITEM BI,
                BOM_HEADER BH
          WHERE BH.PART_NO = ASPARTNO
            AND BH.REVISION = ANREVISION
            AND BH.PART_NO = BI.PART_NO
            AND BH.REVISION = BI.REVISION
            AND BH.PLANT = BI.PLANT
            AND BH.ALTERNATIVE = BI.ALTERNATIVE
            AND BH.BOM_USAGE = BI.BOM_USAGE
            AND BI.COMPONENT_PART = A_COMPONENT_PART;

      
      
      TYPE BOMHEADERSREC_TYPE IS RECORD(
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         PLANT                         IAPITYPE.PLANTNO_TYPE,
         ALTERNATIVE                   IAPITYPE.BOMALTERNATIVE_TYPE,
         CALC_FLAG                     VARCHAR2( 2 BYTE ),
         BOM_USAGE                     IAPITYPE.BOMUSAGE_TYPE
      );

      LRBOMHEADERS                  BOMHEADERSREC_TYPE;

      TYPE BOMHEADERSTAB_TYPE IS TABLE OF BOMHEADERSREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTBOMHEADERS                  BOMHEADERSTAB_TYPE;

      CURSOR C_BOM_HEADERS(
         ASPARTNO                            BOM_HEADER.PART_NO%TYPE,
         ANREVISION                          BOM_HEADER.REVISION%TYPE,
         A_PLANT                             BOM_HEADER.PLANT%TYPE )
      IS
         SELECT PART_NO,
                REVISION,
                PLANT,
                ALTERNATIVE,
                CALC_FLAG,
                BOM_USAGE
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = NVL( A_PLANT,
                             PLANT );

      
      
      TYPE CPRREC_TYPE IS RECORD(
         STATUS                        IAPITYPE.STATUSID_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         USER_INTL                     ITSHQ.USER_INTL%TYPE,
         INTL                          IAPITYPE.INTL_TYPE,
         STATUS_TYPE                   IAPITYPE.STATUSTYPE_TYPE,
         PLANNED_EFFECTIVE_DATE        IAPITYPE.DATE_TYPE,
         WORKFLOW_GROUP_ID             ITSHQ.WORKFLOW_GROUP_ID%TYPE,
         ACCESS_GROUP                  ITSHQ.ACCESS_GROUP%TYPE,
         MULTILANG                     IAPITYPE.BOOLEAN_TYPE,
         UOM_TYPE                      SPECIFICATION_HEADER.UOM_TYPE%TYPE,
         FRAME_NO                      IAPITYPE.FRAMENO_TYPE,
         FRAME_OWNER                   IAPITYPE.OWNER_TYPE,
         CLASS3_ID                     SPECIFICATION_HEADER.CLASS3_ID%TYPE,
         INT_PART_NO                   IAPITYPE.PARTNO_TYPE,
         INT_PART_REV                  IAPITYPE.REVISION_TYPE,
         CF_ACCESS                     NUMBER,
         USER_ID                       IAPITYPE.USERID_TYPE,
         VIEW_ID                       ITSHQ.VIEW_ID%TYPE
      );

      LRCPR                         CPRREC_TYPE;

      TYPE CPRTAB_TYPE IS TABLE OF CPRREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTCPR                         CPRTAB_TYPE;

      CURSOR C_CPR(
         LSUSER                              ITSHQ.USER_ID%TYPE )
      IS
         SELECT SH.STATUS,
                Q.REVISION,
                Q.PART_NO,
                Q.USER_INTL,
                SH.INTL,
                S.STATUS_TYPE,
                SH.PLANNED_EFFECTIVE_DATE,
                SH.WORKFLOW_GROUP_ID,
                SH.ACCESS_GROUP,
                SH.MULTILANG,
                SH.UOM_TYPE,
                Q.FRAME_NO,
                Q.FRAME_OWNER,
                SH.CLASS3_ID,
                SH.INT_PART_NO,
                SH.INT_PART_REV,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              LSUSER,
                              Q.USER_INTL ) CF_ACCESS,
                USER_ID,
                NVL( Q.VIEW_ID,
                     SH.MASK_ID ) VIEW_ID
           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS S
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND USER_ID = LSUSER
            AND SH.STATUS = S.STATUS;

       
      
      TYPE CAWREC_TYPE IS RECORD(
         REVISION                      IAPITYPE.REVISION_TYPE,
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         WORKFLOW_GROUP_ID             ITSHQ.WORKFLOW_GROUP_ID%TYPE,
         ACCESS_GROUP                  ITSHQ.ACCESS_GROUP%TYPE,
         CF_ACCESS                     NUMBER,
         USER_ID                       ITSHQ.USER_ID%TYPE,
         
         
         STATUS_TYPE                   IAPITYPE.STATUSTYPE_TYPE,
         MOD_ACCESS                     NUMBER
         
      );

      LRCAW                         CAWREC_TYPE;

      TYPE CAWTAB_TYPE IS TABLE OF CAWREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTCAW                         CAWTAB_TYPE;

      CURSOR C_CAW(
         LSUSER                              ITSHQ.USER_ID%TYPE )
      IS
         SELECT Q.REVISION,
                Q.PART_NO,
                Q.WORKFLOW_GROUP_ID,
                Q.ACCESS_GROUP,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              LSUSER,
                              Q.USER_INTL ) CF_ACCESS,
                Q.USER_ID,
                
                
                S.STATUS_TYPE,
                F_GET_MODIFIABLE_ACCESS(Q.PART_NO,
                                         Q.REVISION) MOD_ACCESS
                

           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS S
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND USER_ID = LSUSER
            AND SH.STATUS = S.STATUS;

      
      
      TYPE RPVREC_TYPE IS RECORD(
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         USER_INTL                     ITSHQ.USER_INTL%TYPE,
         INTL                          IAPITYPE.INTL_TYPE,
         STATUS                        IAPITYPE.STATUSID_TYPE,
         STATUS_TYPE                   IAPITYPE.STATUSTYPE_TYPE,
         CF_ACCESS                     NUMBER,
         TEXT                          ITSHQ.TEXT%TYPE,
         NEW_VALUE_CHAR                ITSHQ.NEW_VALUE_CHAR%TYPE,
         NEW_VALUE_NUM                 ITSHQ.NEW_VALUE_NUM%TYPE,
         NEW_VALUE_DATE                ITSHQ.NEW_VALUE_DATE%TYPE,
         INTL_PART_NO                  IAPITYPE.PARTNO_TYPE
      );

      LRRPV                         RPVREC_TYPE;

      TYPE RPVTAB_TYPE IS TABLE OF RPVREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTRPV                         RPVTAB_TYPE;

      CURSOR C_RPV(
         LSUSER                              ITSHQ.USER_ID%TYPE )
      IS
         SELECT Q.PART_NO,
                Q.REVISION,
                Q.USER_INTL,
                SH.INTL,
                SH.STATUS,
                S.STATUS_TYPE,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              LSUSER,
                              Q.USER_INTL ) CF_ACCESS,
                Q.TEXT,
                Q.NEW_VALUE_CHAR,
                Q.NEW_VALUE_NUM,
                Q.NEW_VALUE_DATE,
                SH.INT_PART_NO INTL_PART_NO
           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS S
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND USER_ID = LSUSER
            AND SH.STATUS = S.STATUS;

      
      
      TYPE QREC_TYPE IS RECORD(
         USER_ID                       IAPITYPE.USERID_TYPE,
         STATUS                        ITQ.STATUS%TYPE,
         PROGRESS                      ITQ.PROGRESS%TYPE,
         START_DATE                    IAPITYPE.DATE_TYPE,
         END_DATE                      IAPITYPE.DATE_TYPE,
         JOB_DESCR                     ITQ.JOB_DESCR%TYPE
      );

      LRQ                           QREC_TYPE;

      TYPE QTAB_TYPE IS TABLE OF QREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTQ                           QTAB_TYPE;

      
      
      CURSOR C_Q
      IS
         SELECT   USER_ID,
                  STATUS,
                  PROGRESS,
                  START_DATE,
                  END_DATE,
                  JOB_DESCR
             FROM ITQ
            WHERE STATUS = IAPICONSTANT.STARTED_TEXT
              AND JOB_DESCR <> 'Report'
         ORDER BY START_DATE ASC;

      
      
      TYPE UBUREC_TYPE IS RECORD(
         STATUS                        IAPITYPE.STATUSID_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         PART_NO                       IAPITYPE.PARTNO_TYPE,
         USER_INTL                     ITSHQ.USER_INTL%TYPE,
         INTL                          IAPITYPE.INTL_TYPE,
         STATUS_TYPE                   IAPITYPE.STATUSTYPE_TYPE,
         TEXT                          ITSHQ.TEXT%TYPE,
         CF_ACCESS                     NUMBER,
         USER_ID                       IAPITYPE.USERID_TYPE
      );

      LRUBU                         UBUREC_TYPE;

      TYPE UBUTAB_TYPE IS TABLE OF UBUREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTUBU                         UBUTAB_TYPE;

      CURSOR C_UBU(
         LSUSER                              ITSHQ.USER_ID%TYPE )
      IS
         SELECT SH.STATUS,
                Q.REVISION,
                Q.PART_NO,
                USER_INTL,
                SH.INTL,
                S.STATUS_TYPE,
                Q.TEXT,
                F_GET_ACCESS( Q.PART_NO,
                              Q.REVISION,
                              LSUSER,
                              Q.USER_INTL ) CF_ACCESS,
                USER_ID
           FROM ITSHQ Q,
                SPECIFICATION_HEADER SH,
                STATUS S
          WHERE SH.PART_NO = Q.PART_NO
            AND SH.REVISION = Q.REVISION
            AND USER_ID = LSUSER
            AND SH.STATUS = S.STATUS
            AND Q.TEXT LIKE '%;%';

      CURSOR C_CONV_ITEMS(
         LSPART                              BOM_ITEM.PART_NO%TYPE,
         LNREV                               BOM_ITEM.REVISION%TYPE,
         LSCOMP                              BOM_ITEM.COMPONENT_PART%TYPE )
      IS
         SELECT DISTINCT PLANT,
                         ALTERNATIVE,
                         BOM_USAGE,
                         ITEM_NUMBER,
                         TO_UNIT,
                         CONV_FACTOR
                    FROM BOM_ITEM
                   WHERE PART_NO = LSPART
                     AND REVISION = LNREV
                     AND COMPONENT_PART = LSCOMP;

      CURSOR C_ITEMS(
         LSPART                              BOM_ITEM.PART_NO%TYPE,
         LNREV                               BOM_ITEM.REVISION%TYPE,
         LSCOMP                              BOM_ITEM.COMPONENT_PART%TYPE )
      IS
         SELECT DISTINCT PLANT,
                         ALTERNATIVE,
                         BOM_USAGE,
                         ITEM_NUMBER
                    FROM BOM_ITEM
                   WHERE PART_NO = LSPART
                     AND REVISION = LNREV
                     AND COMPONENT_PART = LSCOMP
                     AND CONV_FACTOR IS NOT NULL
                     AND CONV_FACTOR <> 0;

      LBGOON                        BOOLEAN := TRUE;
      LNSPECCOUNT                   NUMBER := 0;
   BEGIN
      LNRETVAL := IAPIUSERPREFERENCES.GETUSERPREFERENCE( 'General',
                                                         'ApplicationLanguage',
                                                         IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                                         LSCULTUREID );
      DBMS_APPLICATION_INFO.SET_MODULE( 'MOP JOB',
                                        NULL );
      
      LBLOCKED := FALSE;
      
      
      
      
      
      
      
      
      
      LSLOCKNAME := 'ISPEC_MOPJOB_RUN';
      DBMS_LOCK.ALLOCATE_UNIQUE(LOCKNAME => LSLOCKNAME,
                                LOCKHANDLE => LSLOCKHANDLE,
                                EXPIRATION_SECS => 2144448000); 
      

      
      
      LNRETVAL := DBMS_LOCK.REQUEST(LOCKHANDLE => LSLOCKHANDLE,
                                    LOCKMODE => DBMS_LOCK.X_MODE,
                                    TIMEOUT => 0.01,
                                    RELEASE_ON_COMMIT => FALSE);  
      IF LNRETVAL = 1 THEN  
         NULL;
         
      ELSIF LNRETVAL = 4 THEN
         RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||LSLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');
      ELSIF LNRETVAL <> 0 THEN
         RAISE_APPLICATION_ERROR(-20000, 'Request Lock for '||LSLOCKNAME||' failed with:'||TO_CHAR(LNRETVAL)||' (see DBMS_LOCK.REQUEST doc for details)');
      ELSE
         LBLOCKED := TRUE;
      
         
         DBMS_ALERT.REGISTER( GSMOPJOBNAME );
         COMMIT;

         
         
         BEGIN
             SELECT CHAR_LENGTH
             INTO  GNMAXLENGTH
             FROM USER_TAB_COLUMNS
             WHERE TABLE_NAME = 'ITJOBQ'
             AND COLUMN_NAME = 'ERROR_MSG'
             
             AND DATA_TYPE = 'VARCHAR2'; 
         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  'There is a possible error: ITJOQ.ERROR_MSG field does not exist or it has other type than VARCHAR2!');
         END;
         

         LOOP
            DBMS_APPLICATION_INFO.SET_ACTION( 'MOP IS WAITING ...' );

            IF LBFIRSTTIME
            THEN
               LBFIRSTTIME := FALSE;
               LNSTATUSID := 0;
            ELSE
               
               DBMS_ALERT.WAITONE( GSMOPJOBNAME,
                                   LSALERTMESSAGE,
                                   LNSTATUSID,
                                   120 );
            END IF;

            IF LNSTATUSID = 0
            THEN
               
               IF LSALERTMESSAGE = 'Q_STOP'
               THEN
                  DBMS_ALERT.SIGNAL( 'CL_Q',
                                     'Q_STOPPED' );
                  DBMS_ALERT.REMOVE( GSMOPJOBNAME );
                  EXIT;
               END IF;

               IF LSALERTMESSAGE = 'Q_LOGGING'
               THEN
                  IAPIGENERAL.ENABLELOGGING;
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'MOP logging started' );
               ELSE
                  
                  LBGOON := TRUE;

                  WHILE( LBGOON = TRUE )
                  LOOP
                     LBGOON := FALSE;

                     OPEN C_Q;

                     FETCH C_Q
                     BULK COLLECT INTO LTQ;

                     CLOSE C_Q;

                     FOR I IN 1 .. LTQ.COUNT
                     LOOP
                        
                        LBGOON := TRUE;
                        LRQ := LTQ( I );
                        
                        DBMS_ALERT.SIGNAL(    'CL_Q'
                                           || LRQ.USER_ID,
                                           'Q_STARTED' );
                        COMMIT;
                        LSALERTMESSAGE := LRQ.USER_ID;
                        LSSTATUS := LRQ.STATUS;
                        LSJOB := LRQ.JOB_DESCR;

                        IF     LSJOB <> 'ssc'
                           AND LSJOB <> 'frr'
                           AND LSJOB <> 'cpr'
                           AND LSJOB <> 'rbi'
                           AND LSJOB <> 'caw'
                           AND LSJOB <> 'rpv'
                           AND LSJOB <> 'ubu'
                           AND LSJOB <> 'del'
                           AND LSJOB <> 'dbi'
                           AND LSJOB <> 'abi'
                        THEN
                           EXIT;
                        END IF;

                        DBMS_APPLICATION_INFO.SET_ACTION(    'MOP IS PROCESSING <'
                                                          || LSJOB
                                                          || '>' );
                        
                        IAPIGENERAL.SESSION.APPLICATIONUSER.USERID := LSALERTMESSAGE;
                        LNRETVAL := IAPIGENERAL.INITIALISESESSION( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                        IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                    'User Id '
                                                 || LSALERTMESSAGE
                                                 || ' is not a valid Application User' );
                           EXIT;
                        END IF;

                        SELECT COUNT( * )
                          INTO LNTOTALRECORDS
                          FROM ITSHQ
                         WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                                'MOP operation <'
                                             || LSJOB
                                             || '> started with '
                                             || LNTOTALRECORDS
                                             || ' specification(s)' );
                        LNRECCOUNT := 0;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'frr'
                        THEN
                           OPEN C_FRR( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_FRR
                           BULK COLLECT INTO LTFRR;

                           CLOSE C_FRR;

                           FOR I IN 1 .. LTFRR.COUNT
                           LOOP
                              LRFRR := LTFRR( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRFRR.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRFRR.PART_NO,
                                              LRFRR.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    IF LRFRR.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                    THEN
                                       BEGIN
                                          IF LRFRR.USER_INTL <> LRFRR.INTL
                                          THEN
                                             IF LRFRR.USER_INTL = '1'
                                             THEN
                                                LOGQUEUE( LRFRR.PART_NO,
                                                          LRFRR.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                             ELSE
                                                LOGQUEUE( LRFRR.PART_NO,
                                                          LRFRR.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                             END IF;
                                          ELSE
                                             BEGIN
                                                
                                                LNOLDFRAMEREVISION := LRFRR.FRAME_REV;
                                                LNNEWFRAMEREVISION := 0;

                                                IF LRFRR.INT_PART_NO IS NOT NULL
                                                THEN
                                                   LNLOCAL := 1;
                                                   LSPARTNO := LRFRR.INT_PART_NO;
                                                   LNREVISION := LRFRR.INT_PART_REV;
                                                ELSE
                                                   LNLOCAL := 0;
                                                   LSPARTNO := LRFRR.PART_NO;
                                                   LNREVISION := LRFRR.REVISION;
                                                END IF;

                                                
                                                SP_CHK_FRMDATA( LSPARTNO,
                                                                LNREVISION,
                                                                LRFRR.NEW_FRAME_NO,
                                                                LRFRR.NEW_FRAME_OWNER,
                                                                LNNEWFRAMEREVISION,
                                                                LRFRR.WORKFLOW_GROUP_ID,
                                                                LRFRR.ACCESS_GROUP,
                                                                LRFRR.CLASS3_ID,
                                                                LRFRR.USER_INTL,
                                                                LRFRR.INTL,
                                                                LNLOCAL );
                                             EXCEPTION
                                                WHEN OTHERS
                                                THEN
                                                   ROLLBACK;
                                                   LOGQUEUE( LRFRR.PART_NO,
                                                             LRFRR.REVISION,
                                                             SQLERRM );
                                                   LNNEWFRAMEREVISION := 0;
                                             END;

                                             IF LNNEWFRAMEREVISION > 0
                                             THEN
                                                IF     LNLOCAL = 0
                                                   AND ( LRFRR.INT_PART_NO ) IS NOT NULL
                                                THEN
                                                   LOGQUEUE( LRFRR.PART_NO,
                                                             LRFRR.REVISION,
                                                             IAPICONSTANTDBERROR.DBERR_LOCALWARNING );
                                                END IF;

                                                BEGIN
                                                   UPDATE SPECIFICATION_HEADER
                                                      SET FRAME_ID = LRFRR.NEW_FRAME_NO,
                                                          FRAME_REV = LNNEWFRAMEREVISION,
                                                          FRAME_OWNER = LRFRR.NEW_FRAME_OWNER,
                                                          LAST_MODIFIED_ON = SYSDATE,
                                                          LAST_MODIFIED_BY = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                                          MASK_ID = LRFRR.VIEW_ID
                                                    WHERE PART_NO = LRFRR.PART_NO
                                                      AND REVISION = LRFRR.REVISION;
                                                   
                                                   LNRETVAL := IAPISPECIFICATION.UPDATE_DISPLAY_FORMAT_STAGE(LRFRR.PART_NO,LRFRR.REVISION);
                                                   IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                                                   THEN
                                                      ROLLBACK;
                                                      LOGQUEUE( LRFRR.PART_NO,
                                                                LRFRR.REVISION,
                                                                SQLERRM );
                                                   END IF;																									                                                   
                                                   
                                                   LNRETVAL :=
                                                      IAPISPECIFICATION.VALIDATIONFRAME( LRFRR.PART_NO,
                                                                                         LRFRR.REVISION,
                                                                                         LRFRR.FRAME_ID,
                                                                                         LNOLDFRAMEREVISION,
                                                                                         LRFRR.FRAME_OWNER,
                                                                                         LRFRR.NEW_FRAME_NO,
                                                                                         LNNEWFRAMEREVISION,
                                                                                         LRFRR.NEW_FRAME_OWNER );

                                                   IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                                                   THEN
                                                      ROLLBACK;
                                                      LOGQUEUE( LRFRR.PART_NO,
                                                                LRFRR.REVISION,
                                                                SQLERRM );
                                                   END IF;

                                                   LNRETVAL :=
                                                      IAPISPECIFICATION.UPDATEFROMFRAME( LRFRR.PART_NO,
                                                                                         LRFRR.REVISION,
                                                                                         LRFRR.FRAME_ID,
                                                                                         LNOLDFRAMEREVISION,
                                                                                         LRFRR.FRAME_OWNER,
                                                                                         LRFRR.NEW_FRAME_NO,
                                                                                         LNNEWFRAMEREVISION,
                                                                                         LRFRR.NEW_FRAME_OWNER );

                                                   IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                                                   THEN
                                                      ROLLBACK;
                                                      LOGQUEUE( LRFRR.PART_NO,
                                                                LRFRR.REVISION,
                                                                SQLERRM );
                                                   END IF;
                                                EXCEPTION
                                                   WHEN OTHERS
                                                   THEN
                                                      ROLLBACK;
                                                      LOGQUEUE( LRFRR.PART_NO,
                                                                LRFRR.REVISION,
                                                                SQLERRM );
                                                END;
                                             ELSE
                                                LOGQUEUE( LRFRR.PART_NO,
                                                          LRFRR.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_FRAMEOUTOFDATE );
                                             END IF;

                                             COMMIT;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             ROLLBACK;
                                             LOGQUEUE( LRFRR.PART_NO,
                                                       LRFRR.REVISION,
                                                       SQLERRM );
                                       END;
                                    ELSE
                                       LOGQUEUE( LRFRR.PART_NO,
                                                 LRFRR.REVISION,
                                                    'Status '
                                                 || LRFRR.STATUS_TYPE
                                                 || ' is not of type DEVELOPMENT' );
                                    END IF;

                                    COMMIT;
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'rbi'
                        THEN
                           OPEN C_RBI( LSALERTMESSAGE );

                           FETCH C_RBI
                           BULK COLLECT INTO LTRBI;

                           CLOSE C_RBI;

                           FOR I IN 1 .. LTRBI.COUNT
                           LOOP
                              LRRBI := LTRBI( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRRBI.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRRBI.PART_NO,
                                              LRRBI.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    SELECT COUNT( PART_NO )
                                      INTO LNSPECCOUNT
                                      FROM SPECIFICATION_HEADER
                                     WHERE PART_NO = LRRBI.TO_PART;

                                    IF ( LNSPECCOUNT < 1 )
                                    THEN
                                       LOGQUEUE( LRRBI.PART_NO,
                                                 LRRBI.REVISION,
                                                    'No specification found for new Bom item '
                                                 || LRRBI.TO_PART );
                                    ELSE
                                       
                                       IF LRRBI.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                       THEN
                                          BEGIN
                                             IF LRRBI.USER_INTL <> LRRBI.INTL
                                             THEN
                                                IF LRRBI.USER_INTL = '1'
                                                THEN
                                                   LOGQUEUE( LRRBI.PART_NO,
                                                             LRRBI.REVISION,
                                                             IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                                ELSE
                                                   LOGQUEUE( LRRBI.PART_NO,
                                                             LRRBI.REVISION,
                                                             IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                                END IF;
                                             ELSE
                                                OPEN C_BOM_HEADER( LRRBI.PART_NO,
                                                                   LRRBI.REVISION,
                                                                   LRRBI.FROM_PART );

                                                FETCH C_BOM_HEADER
                                                BULK COLLECT INTO LTBOMHEADER;

                                                CLOSE C_BOM_HEADER;

                                                FOR I IN 1 .. LTBOMHEADER.COUNT
                                                LOOP
                                                   LRBOMHEADER := LTBOMHEADER( I );

                                                   


                                                   SELECT MIN( COMPONENT_PLANT )
                                                     INTO LSCOMPONENTPLANT
                                                     FROM BOM_ITEM
                                                    WHERE PART_NO = LRRBI.PART_NO
                                                      AND REVISION = LRRBI.REVISION
                                                      AND COMPONENT_PART = LRRBI.FROM_PART
                                                      AND PLANT = LRBOMHEADER.PLANT
                                                      AND ALTERNATIVE = LRBOMHEADER.ALTERNATIVE
                                                      AND BOM_USAGE = LRBOMHEADER.BOM_USAGE;

                                                   SELECT COUNT( * )
                                                     INTO LSCOMPONENTPLANTCOUNT
                                                     FROM PART_PLANT
                                                    WHERE PLANT = LSCOMPONENTPLANT
                                                      AND PART_NO = LRRBI.TO_PART;

                                                   SELECT COUNT( * )
                                                     INTO LSPLANTCOUNT
                                                     FROM PART_PLANT
                                                    WHERE PLANT = LRBOMHEADER.PLANT
                                                      AND PART_NO = LRRBI.TO_PART;

                                                   IF     LSPLANTCOUNT > 0
                                                      AND LSCOMPONENTPLANTCOUNT > 0
                                                   THEN
                                                      
                                                      BEGIN
                                                         SELECT BASE_UOM,
                                                                BASE_TO_UNIT,
                                                                BASE_CONV_FACTOR
                                                           INTO LSBASEUOM,
                                                                LSBASETOUNIT,
                                                                LNBASECONVFACTOR
                                                           FROM PART
                                                          WHERE PART_NO = LRRBI.TO_PART;

                                                         SELECT MAX( UOM )
                                                           INTO LSCURRENTCOMPONENTUOM
                                                           FROM BOM_ITEM
                                                          WHERE PART_NO = LRRBI.PART_NO
                                                            AND REVISION = LRRBI.REVISION
                                                            AND PLANT = LRBOMHEADER.PLANT
                                                            AND ALTERNATIVE = LRBOMHEADER.ALTERNATIVE
                                                            AND BOM_USAGE = LRBOMHEADER.BOM_USAGE
                                                            AND COMPONENT_PART = LRRBI.FROM_PART;

                                                         SELECT UOM,
                                                                TO_UNIT
                                                           INTO LSUOM,
                                                                LSTOUNIT
                                                           FROM BOM_ITEM
                                                          WHERE PART_NO = LRRBI.PART_NO
                                                            AND REVISION = LRRBI.REVISION
                                                            AND PLANT = LRBOMHEADER.PLANT
                                                            AND ALTERNATIVE = LRBOMHEADER.ALTERNATIVE
                                                            AND BOM_USAGE = LRBOMHEADER.BOM_USAGE
                                                            AND COMPONENT_PART = LRRBI.FROM_PART
                                                            AND ROWNUM = 1;

                                                         IF    ( LSUOM <> LSBASEUOM )
                                                            OR ( LSTOUNIT <> LSBASETOUNIT )
                                                         THEN
                                                            LSBASETOUNIT := NULL;
                                                            LNBASECONVFACTOR := NULL;
                                                         END IF;

                                                        
                                                        BEGIN
                                                            
                                                            SELECT
                                                                   B.ITEM_CATEGORY,
                                                                   B.RELEVENCY_TO_COSTING,
                                                                   B.BULK_MATERIAL,
                                                                   B.COMPONENT_SCRAP,
                                                                   B.COMPONENT_SCRAP_SYNC,
                                                                   B.ISSUE_LOCATION,
                                                                   B.LEAD_TIME_OFFSET,
                                                                   B.OPERATIONAL_STEP
                                                              INTO LSITEMCATEGORY,
                                                                   LSRELEVENCYTOCOSTING,
                                                                   LSBULKMATERIAL,
                                                                   LNCOMPONENTSCRAP,
                                                                   LNCOMPONENTSCRAPSYNC,
                                                                   LSISSUELOCATION2,
                                                                   LNLEADTIMEOFFSET2,
                                                                   LNOPERATIONALSTEP
                                                              FROM PART_PLANT B
                                                             WHERE B.PART_NO = LRRBI.TO_PART
                                                               AND B.PLANT = LRBOMHEADER.PLANT;
                                                          EXCEPTION
                                                            WHEN NO_DATA_FOUND
                                                            THEN
                                                                
                                                                NULL;
                                                          END;
                                                         

                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         

                                                         IF (LSRELEVENCYTOCOSTING = 'N')
                                                         THEN
                                                            LNRELEVENCYTOCOSTING := 0;
                                                         ELSE
                                                            LNRELEVENCYTOCOSTING := 1;
                                                         END IF;

                                                         IF (LSBULKMATERIAL = 'N')
                                                         THEN
                                                            LNBULKMATERIAL := 0;
                                                         ELSE
                                                            LNBULKMATERIAL := 1;
                                                         END IF;

                                                         LNRETVAL := IAPISPECIFICATIONBOM.SAVEITEM_MOP(LRRBI.PART_NO,
                                                                                                       LRRBI.REVISION,
                                                                                                       LRBOMHEADER.PLANT,
                                                                                                       LRBOMHEADER.ALTERNATIVE,
                                                                                                       LRBOMHEADER.BOM_USAGE,
                                                                                                       LRRBI.FROM_PART,
                                                                                                       LRRBI.TO_PART,
                                                                                                       LSBASEUOM,
                                                                                                       LNBASECONVFACTOR,
                                                                                                       LSBASETOUNIT,
                                                                                                       LSCURRENTCOMPONENTUOM,
                                                                                                       LNCOMPONENTSCRAP,
                                                                                                       LNLEADTIMEOFFSET2,
                                                                                                       LNRELEVENCYTOCOSTING,
                                                                                                       LNBULKMATERIAL,
                                                                                                       LSITEMCATEGORY,
                                                                                                       LSISSUELOCATION2,
                                                                                                       LNOPERATIONALSTEP,
                                                                                                       LNCOMPONENTSCRAPSYNC);

                                                         

                                                         
                                                         LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRRBI.PART_NO,
                                                                                                   LRRBI.REVISION );
                                                      EXCEPTION
                                                         WHEN OTHERS
                                                         THEN
                                                            LOGQUEUE( LRRBI.PART_NO,
                                                                      LRRBI.REVISION,
                                                                      SQLERRM );
                                                      END;
                                                   ELSE
                                                      LOGQUEUE
                                                         ( LRRBI.PART_NO,
                                                           LRRBI.REVISION,
                                                              'The new bom item is not linked to the plant in of the bom header or the component plant of the old item for plant '
                                                           || LRBOMHEADER.PLANT
                                                           || ' alternative '
                                                           || LRBOMHEADER.ALTERNATIVE
                                                           || ' usage '
                                                           || LRBOMHEADER.BOM_USAGE );
                                                   END IF;
                                                END LOOP;
                                             END IF;
                                          EXCEPTION
                                             WHEN OTHERS
                                             THEN
                                                LOGQUEUE( LRRBI.PART_NO,
                                                          LRRBI.REVISION,
                                                          SQLERRM );
                                          END;
                                       ELSE
                                          LOGQUEUE( LRRBI.PART_NO,
                                                    LRRBI.REVISION,
                                                       'Status '
                                                    || LRRBI.STATUS_TYPE
                                                    || ' is not of type DEVELOPMENT' );
                                       END IF;
                                    END IF;

                                    COMMIT;
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'dbi'
                        THEN
                           OPEN C_BI( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_BI
                           BULK COLLECT INTO LTBI;

                           CLOSE C_BI;

                           FOR I IN 1 .. LTBI.COUNT
                           LOOP
                              LRBI := LTBI( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRBI.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRBI.PART_NO,
                                              LRBI.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    IF LRBI.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                    THEN
                                       BEGIN
                                          IF LRBI.USER_INTL <> LRBI.INTL
                                          THEN
                                             IF LRBI.USER_INTL = '1'
                                             THEN
                                                LOGQUEUE( LRBI.PART_NO,
                                                          LRBI.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                             ELSE
                                                LOGQUEUE( LRBI.PART_NO,
                                                          LRBI.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                             END IF;
                                          ELSE
                                             BEGIN
                                                IF LRBI.PLANT IS NULL
                                                THEN
                                                   SELECT COUNT( * )
                                                     INTO LSPLANTCOUNT
                                                     FROM BOM_ITEM
                                                    WHERE PART_NO = LRBI.PART_NO
                                                      AND REVISION = LRBI.REVISION
                                                      AND COMPONENT_PART = LRBI.B_PART;
                                                ELSE
                                                   SELECT COUNT( * )
                                                     INTO LSPLANTCOUNT
                                                     FROM BOM_ITEM
                                                    WHERE PART_NO = LRBI.PART_NO
                                                      AND REVISION = LRBI.REVISION
                                                      AND COMPONENT_PART = LRBI.B_PART
                                                      AND BOM_ITEM.PLANT = LRBI.PLANT;
                                                END IF;

                                                IF LSPLANTCOUNT > 0
                                                THEN
                                                   OPEN C_BOM_HEADERS( LRBI.PART_NO,
                                                                       LRBI.REVISION,
                                                                       LRBI.PLANT );

                                                   FETCH C_BOM_HEADERS
                                                   BULK COLLECT INTO LTBOMHEADERS;

                                                   CLOSE C_BOM_HEADERS;

                                                   FOR I IN 1 .. LTBOMHEADERS.COUNT
                                                   LOOP
                                                      LRBOMHEADERS := LTBOMHEADERS( I );

                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      

                                                      LNRETVAL := IAPISPECIFICATIONBOM.REMOVEITEM_MOP(LRBI.PART_NO,


                                                                                                      LRBI.REVISION,
                                                                                                      LRBOMHEADERS.PLANT,
                                                                                                      LRBI.B_PART, 
                                                                                                      LRBI.PLANT);
                                                      

                                                      IAPISPECIFICATIONBOM.APPLYAUTOCALC( LRBI.PART_NO,
                                                                                          LRBI.REVISION,
                                                                                          LRBOMHEADERS.PLANT,
                                                                                          LRBOMHEADERS.BOM_USAGE,
                                                                                          LRBOMHEADERS.ALTERNATIVE );
                                                   END LOOP;

                                                   
                                                   LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRBI.PART_NO,
                                                                                             LRBI.REVISION );
                                                END IF;
                                             EXCEPTION
                                                WHEN OTHERS
                                                THEN
                                                   ROLLBACK;
                                                   LOGQUEUE( LRBI.PART_NO,
                                                             LRBI.REVISION,
                                                             SQLERRM );
                                             END;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             ROLLBACK;
                                             LOGQUEUE( LRBI.PART_NO,
                                                       LRBI.REVISION,
                                                       SQLERRM );
                                       END;
                                    ELSE   
                                       LOGQUEUE( LRBI.PART_NO,
                                                 LRBI.REVISION,
                                                    'Status '
                                                 || LRBI.STATUS_TYPE
                                                 || ' is not of type DEVELOPMENT' );
                                    END IF;

                                    COMMIT;
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'abi'
                        THEN
                           OPEN C_BI( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_BI
                           BULK COLLECT INTO LTBI;

                           CLOSE C_BI;

                           FOR I IN 1 .. LTBI.COUNT
                           LOOP
                              LRBI := LTBI( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRBI.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRBI.PART_NO,
                                              LRBI.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    IF LRBI.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                    THEN
                                       BEGIN
                                          IF LRBI.USER_INTL <> LRBI.INTL
                                          THEN
                                             IF LRBI.USER_INTL = '1'
                                             THEN
                                                LOGQUEUE( LRBI.PART_NO,
                                                          LRBI.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                             ELSE
                                                LOGQUEUE( LRBI.PART_NO,
                                                          LRBI.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                             END IF;
                                          ELSE
                                             BEGIN
                                                OPEN C_BOM_HEADERS( LRBI.PART_NO,
                                                                    LRBI.REVISION,
                                                                    LRBI.PLANT );

                                                FETCH C_BOM_HEADERS
                                                BULK COLLECT INTO LTBOMHEADERS;

                                                CLOSE C_BOM_HEADERS;

                                                FOR I IN 1 .. LTBOMHEADERS.COUNT
                                                LOOP
                                                   
                                                   
                                                   LRBOMHEADERS := LTBOMHEADERS( I );

                                                   BEGIN
                                                      SELECT OBSOLETE,
                                                             LEAD_TIME_OFFSET,
                                                             DECODE( RELEVENCY_TO_COSTING,
                                                                     'Y', 1,
                                                                     0 ),
                                                             DECODE( BULK_MATERIAL,
                                                                     'Y', 1,
                                                                     0 ),
                                                             ITEM_CATEGORY,
                                                             ISSUE_LOCATION,
                                                             ASSEMBLY_SCRAP,
                                                             COMPONENT_SCRAP,
                                                             LEAD_TIME_OFFSET
                                                        INTO LNOBSOLETE,
                                                             LNLEADTIMEOFFSET,
                                                             LNRELEVENCYTOCOSTING,
                                                             LNBULKMATERIAL,
                                                             LNITEMCATEGORY,
                                                             LSISSUELOCATION,
                                                             LNASSEMBLYSCRAP,
                                                             LSCOMPONENTSCRAP,
                                                             LNLEADTIMEOFFSET
                                                        FROM PART_PLANT
                                                       WHERE PART_NO = LRBI.B_PART
                                                         AND PLANT = LRBOMHEADERS.PLANT;

                                                      IF LNOBSOLETE = 1
                                                      THEN
                                                         LOGQUEUE( LRBI.PART_NO,
                                                                   LRBI.REVISION,
                                                                      'The part-plant relation of plant '
                                                                   || LRBOMHEADERS.PLANT
                                                                   || ' is marked obsolete' );
                                                      ELSE
                                                         SELECT BASE_UOM,
                                                                BASE_CONV_FACTOR,
                                                                BASE_TO_UNIT
                                                           INTO LSBASEUOM,
                                                                LNBASECONVFACTOR,
                                                                LSBASETOUNIT
                                                           FROM PART
                                                          WHERE PART_NO = LRBI.B_PART;

                                                         SELECT   MAX( ITEM_NUMBER )
                                                                + 10
                                                           INTO LNITEMNUMBER
                                                           FROM BOM_ITEM
                                                          WHERE PART_NO = LRBOMHEADERS.PART_NO
                                                            AND REVISION = LRBOMHEADERS.REVISION
                                                            AND PLANT = LRBOMHEADERS.PLANT
                                                            AND ALTERNATIVE = LRBOMHEADERS.ALTERNATIVE
                                                            AND BOM_USAGE = LRBOMHEADERS.BOM_USAGE;

                                                         IF LNITEMNUMBER IS NULL
                                                         THEN
                                                            LNITEMNUMBER := 10;
                                                         END IF;


                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         

                                                        LNRETVAL := IAPISPECIFICATIONBOM.ADDITEM_MOP(
                                                                      LRBI.PART_NO,
                                                                      LRBI.REVISION,
                                                                      LRBOMHEADERS.PLANT,
                                                                      LRBOMHEADERS.ALTERNATIVE,
                                                                      LRBOMHEADERS.BOM_USAGE,
                                                                      LNITEMNUMBER,
                                                                      LRBI.B_PART,
                                                                      LRBOMHEADERS.PLANT,
                                                                      LRBI.NEW_VALUE_NUM,
                                                                      LSBASEUOM,
                                                                      LNBASECONVFACTOR,
                                                                      LSBASETOUNIT,
                                                                      100,
                                                                      LNASSEMBLYSCRAP,
                                                                      LSCOMPONENTSCRAP,
                                                                      LNLEADTIMEOFFSET,
                                                                      LNRELEVENCYTOCOSTING,
                                                                      LNBULKMATERIAL,
                                                                      LNITEMCATEGORY,
                                                                      LSISSUELOCATION,
                                                                      LRBOMHEADERS.CALC_FLAG
                                                                    );
                                                         

                                                         IAPISPECIFICATIONBOM.APPLYAUTOCALC( LRBI.PART_NO,
                                                                                             LRBI.REVISION,
                                                                                             LRBOMHEADERS.PLANT,
                                                                                             LRBOMHEADERS.ALTERNATIVE,
                                                                                             LRBOMHEADERS.BOM_USAGE );
                                                         
                                                         LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRBI.PART_NO,
                                                                                                   LRBI.REVISION );
                                                      END IF;
                                                   EXCEPTION
                                                      WHEN NO_DATA_FOUND
                                                      THEN
                                                         LOGQUEUE( LRBI.PART_NO,
                                                                   LRBI.REVISION,
                                                                      'The plant '
                                                                   || LRBOMHEADERS.PLANT
                                                                   || ' has not been assigned' );
                                                   END;
                                                END LOOP;
                                             EXCEPTION
                                                WHEN OTHERS
                                                THEN
                                                   ROLLBACK;
                                                   LOGQUEUE( LRBI.PART_NO,
                                                             LRBI.REVISION,
                                                             SQLERRM );
                                             END;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             LOGQUEUE( LRBI.PART_NO,
                                                       LRBI.REVISION,
                                                       SQLERRM );
                                       END;
                                    ELSE   
                                       LOGQUEUE( LRBI.PART_NO,
                                                 LRBI.REVISION,
                                                    'Status '
                                                 || LRBI.STATUS_TYPE
                                                 || ' is not of type DEVELOPMENT' );
                                    END IF;
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'del'
                        THEN
                           OPEN C_STANDARD_Q( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_STANDARD_Q
                           BULK COLLECT INTO LTSTANDARDQ;

                           CLOSE C_STANDARD_Q;

                           FOR I IN 1 .. LTSTANDARDQ.COUNT
                           LOOP
                              LRSTANDARDQ := LTSTANDARDQ( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRSTANDARDQ.CFACCESS = 1
                                 THEN
                                    LOGQUEUE( LRSTANDARDQ.PARTNO,
                                              LRSTANDARDQ.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    IF LRSTANDARDQ.STATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                    THEN
                                       BEGIN
                                          IF LRSTANDARDQ.USER_INTL <> LRSTANDARDQ.INTL
                                          THEN
                                             IF LRSTANDARDQ.USER_INTL = '1'
                                             THEN
                                                LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                          LRSTANDARDQ.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                             ELSE
                                                LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                          LRSTANDARDQ.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                             END IF;
                                          ELSE
                                             BEGIN
                                                LNRETVAL := IAPISPECIFICATION.REMOVESPECIFICATION( LRSTANDARDQ.PARTNO,
                                                                                                   LRSTANDARDQ.REVISION );

                                                IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                                                THEN
                                                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                                                         LSMETHOD,
                                                                         IAPIGENERAL.GETLASTERRORTEXT );
                                                   LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                             LRSTANDARDQ.REVISION,
                                                             IAPIGENERAL.GETLASTERRORTEXT );
                                                END IF;

                                                COMMIT;
                                             EXCEPTION
                                                WHEN OTHERS
                                                THEN
                                                   ROLLBACK;
                                                   LSSQLERRORMESSAGE := SQLERRM;
                                                   LNERRORCODE := SUBSTR( SQLERRM,
                                                                          5,
                                                                          5 );
                                                   LSSQLERRORMESSAGE := F_GET_MESSAGE( -LNERRORCODE,
                                                                                       LSCULTUREID );
                                                   LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                             LRSTANDARDQ.REVISION,
                                                             LSSQLERRORMESSAGE );
                                             END;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             ROLLBACK;
                                             LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                       LRSTANDARDQ.REVISION,
                                                       SQLERRM );
                                       END;
                                    ELSE   
                                       LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                 LRSTANDARDQ.REVISION,
                                                    'Status '
                                                 || LRSTANDARDQ.STATUSTYPE
                                                 || ' is not of type DEVELOPMENT' );
                                    END IF;

                                    COMMIT;
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'cpr'
                        THEN
                           OPEN C_CPR( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_CPR
                           BULK COLLECT INTO LTCPR;

                           CLOSE C_CPR;

                           FOR I IN 1 .. LTCPR.COUNT
                           LOOP
                              LRCPR := LTCPR( I );
                              
                              IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL :=( LRCPR.USER_INTL = '1' );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 
                                 SELECT SUBSTR( LRCPR.PART_NO,
                                                1,
                                                3 )
                                   INTO LSPREFIX
                                   FROM DUAL;

                                 
                                 SELECT COUNT( * )
                                   INTO LSPREFIX_COUNT
                                   FROM SPEC_PREFIX_DESCR
                                  WHERE PREFIX = LSPREFIX;

                                 IF LSPREFIX_COUNT = 0
                                 THEN
                                    
                                    LSPREFIX_OK := TRUE;
                                 ELSE
                                    
                                    SELECT COUNT( * )
                                      INTO LSPREFIX_COUNT
                                      FROM ( SELECT DISTINCT SPEC_PREFIX.PREFIX,
                                                             SPEC_PREFIX_DESCR.DESCRIPTION
                                                       FROM SPEC_PREFIX,
                                                            SPEC_PREFIX_ACCESS_GROUP,
                                                            USER_ACCESS_GROUP,
                                                            USER_GROUP_LIST,
                                                            SPEC_PREFIX_DESCR
                                                      WHERE SPEC_PREFIX_ACCESS_GROUP.ACCESS_GROUP = USER_ACCESS_GROUP.ACCESS_GROUP
                                                        AND USER_GROUP_LIST.USER_GROUP_ID = USER_ACCESS_GROUP.USER_GROUP_ID
                                                        AND SPEC_PREFIX.PREFIX = SPEC_PREFIX_ACCESS_GROUP.PREFIX
                                                        AND SPEC_PREFIX.PREFIX = SPEC_PREFIX_DESCR.PREFIX
                                                        AND SPEC_PREFIX.OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER
                                                        AND USER_GROUP_LIST.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                                        AND USER_ACCESS_GROUP.UPDATE_ALLOWED = 'Y'
                                                        AND SPEC_PREFIX.PREFIX = LSPREFIX
                                            UNION
                                            SELECT DISTINCT SPEC_PREFIX.PREFIX,
                                                            SPEC_PREFIX_DESCR.DESCRIPTION
                                                       FROM SPEC_PREFIX,
                                                            SPEC_PREFIX_DESCR
                                                      WHERE SPEC_PREFIX.PREFIX NOT IN( SELECT PREFIX
                                                                                        FROM SPEC_PREFIX_ACCESS_GROUP )
                                                        AND SPEC_PREFIX.PREFIX = SPEC_PREFIX_DESCR.PREFIX
                                                        AND SPEC_PREFIX.OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER
                                                        AND SPEC_PREFIX.PREFIX = LSPREFIX );

                                    IF LSPREFIX_COUNT = 0
                                    THEN
                                       LSPREFIX_OK := FALSE;
                                    ELSE
                                       LSPREFIX_OK := TRUE;
                                    END IF;
                                 END IF;

                                 IF LRCPR.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRCPR.PART_NO,
                                              LRCPR.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSIF NOT LSPREFIX_OK
                                 THEN
                                    LOGQUEUE( LRCPR.PART_NO,
                                              LRCPR.REVISION,
                                              'You do not have access to the prefix' );
                                 ELSE
                                    
                                    IF LRCPR.STATUS_TYPE IN
                                                 ( IAPICONSTANT.STATUSTYPE_DEVELOPMENT, IAPICONSTANT.STATUSTYPE_REJECT, IAPICONSTANT.STATUSTYPE_SUBMIT )
                                    THEN
                                       SELECT COUNT( * )
                                         INTO LNMULTIINDEV
                                         FROM INTERSPC_CFG
                                        WHERE PARAMETER = 'multi_in_dev'
                                          AND PARAMETER_DATA = '1';

                                       IF LNMULTIINDEV = 1
                                       THEN
                                          LBALLOWED := TRUE;
                                       ELSE
                                          LBALLOWED := FALSE;
                                       END IF;
                                    ELSE
                                       LBALLOWED := TRUE;
                                    END IF;

                                    IF LBALLOWED = TRUE
                                    THEN
                                       BEGIN
                                          IF LRCPR.USER_INTL <> LRCPR.INTL
                                          THEN
                                             IF LRCPR.USER_INTL = '1'
                                             THEN
                                                LOGQUEUE( LRCPR.PART_NO,
                                                          LRCPR.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                             ELSE
                                                LOGQUEUE( LRCPR.PART_NO,
                                                          LRCPR.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                             END IF;
                                          ELSE
                                             BEGIN
                                                
                                                LNNEWFRAMEREVISION := 0;

                                                IF LRCPR.INT_PART_NO IS NOT NULL
                                                THEN
                                                   LNLOCAL := 1;
                                                   LSPARTNO := LRCPR.INT_PART_NO;
                                                   LNREVISION := LRCPR.INT_PART_REV;
                                                ELSE
                                                   LNLOCAL := 0;
                                                   LSPARTNO := LRCPR.PART_NO;
                                                   LNREVISION := LRCPR.REVISION;
                                                END IF;

                                                

                                                SP_CHK_FRMDATA( LSPARTNO,
                                                                LNREVISION,
                                                                LRCPR.FRAME_NO,
                                                                LRCPR.FRAME_OWNER,
                                                                LNNEWFRAMEREVISION,
                                                                LNWORKFLOWGROUPID,
                                                                LNACCESSGROUPID,
                                                                LNCLASS3ID,
                                                                LRCPR.USER_INTL,
                                                                LRCPR.INTL,
                                                                LNLOCAL );
                                             EXCEPTION
                                                WHEN OTHERS
                                                THEN
                                                   ROLLBACK;
                                                   LOGQUEUE( LRCPR.PART_NO,
                                                             LRCPR.REVISION,
                                                             SQLERRM );
                                                   LNNEWFRAMEREVISION := 0;
                                             END;

                                             IF     LNNEWFRAMEREVISION <> 0
                                                AND LNNEWFRAMEREVISION IS NOT NULL
                                             THEN
                                                IF     LNLOCAL = 0
                                                   AND ( LRCPR.INT_PART_NO ) IS NOT NULL
                                                THEN
                                                   LOGQUEUE( LRCPR.PART_NO,
                                                             LRCPR.REVISION,
                                                             IAPICONSTANTDBERROR.DBERR_LOCALWARNING );
                                                END IF;

                                                
                                                BEGIN
                                                   SELECT   MAX( REVISION )
                                                          + 1
                                                     INTO LNNEXTREVISION
                                                     FROM SPECIFICATION_HEADER
                                                    WHERE PART_NO = LRCPR.PART_NO
                                                      AND REVISION = LRCPR.REVISION;

                                                   
                                                   SELECT MAX( REVISION )
                                                     INTO LNREVISION
                                                     FROM SPECIFICATION_HEADER,
                                                          STATUS
                                                    WHERE PART_NO = LRCPR.PART_NO
                                                      AND STATUS.STATUS = SPECIFICATION_HEADER.STATUS
                                                      AND (    STATUS.STATUS_TYPE IN
                                                                  ( IAPICONSTANT.STATUSTYPE_SUBMIT,
                                                                    IAPICONSTANT.STATUSTYPE_APPROVED,
                                                                    IAPICONSTANT.STATUSTYPE_REJECT,
                                                                    IAPICONSTANT.STATUSTYPE_DEVELOPMENT )
                                                            OR (     STATUS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
                                                                 AND STATUS.PHASE_IN_STATUS = 'Y' ) );

                                                   IF LNREVISION IS NULL
                                                   THEN
                                                      SELECT MAX( REVISION )
                                                        INTO LNREVISION
                                                        FROM SPECIFICATION_HEADER
                                                       WHERE PART_NO = LRCPR.PART_NO
                                                         AND REVISION = LRCPR.REVISION;
                                                   END IF;

                                                   
                                                   SELECT TO_NUMBER( PARAMETER_DATA )
                                                     INTO LNEFFECTIVEDATEOFFSET
                                                     FROM INTERSPC_CFG
                                                    WHERE PARAMETER = 'def_effdate_offset';

                                                   SELECT PLANNED_EFFECTIVE_DATE,
                                                          PHASE_IN_TOLERANCE,
                                                          DESCRIPTION
                                                     INTO LDPED,
                                                          LNPIT,
                                                          LSDESCRIPTION
                                                     FROM SPECIFICATION_HEADER
                                                    WHERE PART_NO = LRCPR.PART_NO
                                                      AND REVISION = LNREVISION;

                                                   
                                                   
                                                   
                                                   
                                                   LSDESCRIPTION := NVL(F_FIND_PART_DESCR(LRCPR.PART_NO), LSDESCRIPTION);
                                                   
                                                   IF   LDPED
                                                      + LNPIT >= TRUNC(   SYSDATE
                                                                        + LNEFFECTIVEDATEOFFSET )
                                                   THEN
                                                      LDNEWPED := TRUNC(   LDPED
                                                                         + LNPIT
                                                                         + 1 );
                                                   ELSE
                                                      LDNEWPED := TRUNC(   SYSDATE
                                                                         + LNEFFECTIVEDATEOFFSET );
                                                   END IF;

                                                   IF LRCPR.INT_PART_NO IS NOT NULL
                                                   THEN
                                                      LNLOCAL := 1;
                                                   ELSE
                                                      LNLOCAL := 0;
                                                   END IF;

                                                   
                                                   IAPISPECIFICATION.GBLOGINTOITSCHS := FALSE;

                                                   LNRETVAL :=
                                                      IAPISPECIFICATION.COPYSPECIFICATION( LRCPR.PART_NO,
                                                                                           LRCPR.REVISION,
                                                                                           LRCPR.PART_NO,
                                                                                           LRCPR.FRAME_NO,
                                                                                           LNNEWFRAMEREVISION,
                                                                                           LRCPR.FRAME_OWNER,
                                                                                           LRCPR.WORKFLOW_GROUP_ID,
                                                                                           LRCPR.ACCESS_GROUP,
                                                                                           LRCPR.CLASS3_ID,
                                                                                           LDNEWPED,
                                                                                           LNNEXTREVISION,
                                                                                           
                                                                                           
                                                                                           
                                                                                           
                                                                                           LRCPR.MULTILANG,
                                                                                           LRCPR.UOM_TYPE,
                                                                                           LRCPR.VIEW_ID,
                                                                                           LSDESCRIPTION,
                                                                                           LNLOCAL,
                                                                                           
                                                                                           
                                                                                           LQERRORS,
                                                                                           1 );
                                                                                           

                                                      
                                                      IAPISPECIFICATION.GBLOGINTOITSCHS := TRUE;

                                                   
                                                   
                                                   
                                                   IF ( LQERRORS%ISOPEN )
                                                   THEN
                                                      CLOSE LQERRORS;
                                                   END IF;
                                                   

                                                   IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                                                   THEN
                                                      LSSQLERRORMESSAGE := F_GET_MESSAGE( LNRETVAL,
                                                                                          LSCULTUREID );
                                                      ROLLBACK;
                                                      LOGQUEUE( LRCPR.PART_NO,
                                                                LRCPR.REVISION,
                                                                LSSQLERRORMESSAGE );
                                                   END IF;

                                                EXCEPTION
                                                   WHEN OTHERS
                                                   THEN
                                                      LNERRORCODE := SUBSTR( SQLERRM,
                                                                             5,
                                                                             5 );
                                                      LSSQLERRORMESSAGE := F_GET_MESSAGE( -LNERRORCODE,
                                                                                          LSCULTUREID );
                                                      ROLLBACK;
                                                      LOGQUEUE( LRCPR.PART_NO,
                                                                LRCPR.REVISION,
                                                                LSSQLERRORMESSAGE );
                                                END;
                                             ELSE
                                                LOGQUEUE( LRCPR.PART_NO,
                                                          LRCPR.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_FRAMEOUTOFDATE );
                                             END IF;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             ROLLBACK;
                                             LOGQUEUE( LRCPR.PART_NO,
                                                       LRCPR.REVISION,
                                                       SQLERRM );
                                       END;
                                    ELSE
                                       
                                       LSSQLERRORMESSAGE := F_GET_MESSAGE( '-20006',
                                                                           LSCULTUREID );
                                       LOGQUEUE( LRCPR.PART_NO,
                                                 LRCPR.REVISION,
                                                 LSSQLERRORMESSAGE );
                                    END IF;

                                    COMMIT;
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'caw'
                        THEN
                           OPEN C_CAW( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_CAW
                           BULK COLLECT INTO LTCAW;

                           CLOSE C_CAW;

                           FOR I IN 1 .. LTCAW.COUNT
                           LOOP
                              LRCAW := LTCAW( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRCAW.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRCAW.PART_NO,
                                              LRCAW.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                     
                                     
                                     IF LRCAW.MOD_ACCESS = 0
                                     THEN

                                        BEGIN
                                            SELECT WORKFLOW_GROUP_ID
                                            INTO LNWFGID
                                            FROM SPECIFICATION_HEADER
                                            WHERE PART_NO = LRCAW.PART_NO
                                              AND REVISION = LRCAW.REVISION;

                                            IF (LNWFGID <> LRCAW.WORKFLOW_GROUP_ID)
                                            THEN
                                                LOGQUEUE2( LRCAW.PART_NO,
                                                           LRCAW.REVISION,
                                                           'Specification workflow group is not modifiable.',
                                                           2 );
                                            END IF;

                                        
                                           UPDATE SPECIFICATION_HEADER
                                              SET ACCESS_GROUP = LRCAW.ACCESS_GROUP,
                                                  LAST_MODIFIED_ON = SYSDATE,
                                                  LAST_MODIFIED_BY = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                            WHERE PART_NO = LRCAW.PART_NO
                                              AND REVISION = LRCAW.REVISION;
                                        EXCEPTION
                                           WHEN OTHERS
                                           THEN
                                              ROLLBACK;
                                              LOGQUEUE( LRCAW.PART_NO,
                                                        LRCAW.REVISION,
                                                        LSSQLERRORMESSAGE );
                                        END;

                                     
                                     ELSE
                                    

                                    BEGIN
                                       UPDATE SPECIFICATION_HEADER
                                          SET ACCESS_GROUP = LRCAW.ACCESS_GROUP,
                                              WORKFLOW_GROUP_ID = LRCAW.WORKFLOW_GROUP_ID,
                                              LAST_MODIFIED_ON = SYSDATE,
                                              LAST_MODIFIED_BY = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                        WHERE PART_NO = LRCAW.PART_NO
                                          AND REVISION = LRCAW.REVISION;
                                    EXCEPTION
                                       WHEN OTHERS
                                       THEN
                                          ROLLBACK;
                                          LOGQUEUE( LRCAW.PART_NO,
                                                    LRCAW.REVISION,
                                                    LSSQLERRORMESSAGE );
                                    END;
                                 
                                 END IF;
                                 
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'ssc'
                        THEN
                           SELECT   DECODE( PROD_ACCESS,
                                            'Y', 1,
                                            'N', 0 )
                                  +   2
                                    * DECODE( PLAN_ACCESS,
                                              'Y', 1,
                                              'N', 0 )
                                  +   4
                                    * DECODE( PHASE_ACCESS,
                                              'Y', 1,
                                              'N', 0 )
                             INTO LNMRP
                             FROM APPLICATION_USER
                            WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                           OPEN C_STANDARD_Q( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_STANDARD_Q
                           BULK COLLECT INTO LTSTANDARDQ;

                           CLOSE C_STANDARD_Q;

                           FOR I IN 1 .. LTSTANDARDQ.COUNT
                           LOOP
                              LRSTANDARDQ := LTSTANDARDQ( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRSTANDARDQ.CFACCESS = 1
                                 THEN
                                    LOGQUEUE( LRSTANDARDQ.PARTNO,
                                              LRSTANDARDQ.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    IF     LRSTANDARDQ.STATUS IS NOT NULL
                                       AND LRSTANDARDQ.REVISION IS NOT NULL
                                       AND LRSTANDARDQ.PARTNO IS NOT NULL
                                       AND LRSTANDARDQ.STATUSTO IS NOT NULL
                                    THEN
   
   
   
                                       BEGIN

                                       
                                       
                                       
                                       

                                          
                                          
                                          SELECT STATUS_TYPE
                                            INTO LSSTATUSTYPETO
                                            FROM STATUS
                                           WHERE STATUS = LRSTANDARDQ.STATUSTO;

                                          
                                          
                                          SELECT STATUS_TYPE
                                            INTO LSSTATUSTYPEFROM
                                            FROM STATUS
                                           WHERE STATUS = LRSTANDARDQ.STATUS;

                                      
                                       
                                       SELECT REASON_MANDATORY
                                         INTO LSREASONMANDATORY
                                         FROM STATUS
                                        WHERE STATUS = LRSTANDARDQ.STATUSTO;
                                       
                                       

                                          
                                          LBCONTINUE := TRUE;

                                          IF LSSTATUSTYPETO = IAPICONSTANT.STATUSTYPE_CURRENT
                                          THEN
                                             SELECT PED_IN_SYNC
                                               INTO LSPEDINSYNC
                                               FROM SPECIFICATION_HEADER
                                              WHERE PART_NO = LRSTANDARDQ.PARTNO
                                                AND REVISION = LRSTANDARDQ.REVISION;

                                             IF LSPEDINSYNC <> 'Y'
                                             THEN
                                                ROLLBACK;
                                                LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                          LRSTANDARDQ.REVISION,
                                                          'Status can only be changed when PEDs are in sync' );
                                                LBCONTINUE := FALSE;
                                             END IF;
                                          END IF;

                                          IF     LSSTATUSTYPEFROM NOT IN( IAPICONSTANT.STATUSTYPE_DEVELOPMENT, IAPICONSTANT.STATUSTYPE_REJECT )
                                             AND (     LNMRP <> 2
                                                   AND LNMRP <> 3
                                                   AND LNMRP <> 7 )
                                          THEN
                                             LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                       LRSTANDARDQ.REVISION,
                                                       'You are not allowed to change the status (no planning access)' );
                                             LBCONTINUE := FALSE;
                                          END IF;

                                          IF LBCONTINUE
                                          THEN
                                         
                                         
                                         
                                         
                                         
                                         

                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          

                                          IF     LRSTANDARDQ.TEXT IS NOT NULL
                                             AND LSREASONMANDATORY = 1
                                          THEN

                                                IF LSSTATUSTYPETO = IAPICONSTANT.STATUSTYPE_SUBMIT
                                                THEN
                                                    
                                                    
                                                    
                                                    
                                                    
                                                     UPDATE REASON
                                                        SET TEXT = LRSTANDARDQ.TEXT
                                                      WHERE 
                                                        
                                                        
                                                        
                                                        ID =
                                                               ( SELECT MAX( ID )
                                                                  FROM REASON
                                                                 WHERE STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE
                                                                   AND PART_NO = LRSTANDARDQ.PARTNO
                                                                   AND REVISION = LRSTANDARDQ.REVISION );
                                                      
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                         
                                                       
                                                      COMMIT;
                                                ELSE
                                                    IF LSSTATUSTYPETO = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                                    THEN
                                                   
                                                        
                                                        
                                                        IF  LSSTATUSTYPEFROM = IAPICONSTANT.STATUSTYPE_REJECT
                                                           THEN
                                                                SELECT REASON_SEQ.NEXTVAL
                                                                       INTO LNREASONID
                                                                       FROM DUAL;

                                                                INSERT INTO REASON
                                                                         ( ID,
                                                                           PART_NO,
                                                                           REVISION,
                                                                           STATUS_TYPE,
                                                                           TEXT )
                                                                  VALUES ( LNREASONID,
                                                                                LRSTANDARDQ.PARTNO,
                                                                                LRSTANDARDQ.REVISION,
                                                                                IAPICONSTANT.STATUSTYPE_REASONFORISSUE,
                                                                                LRSTANDARDQ.TEXT );
                                                                COMMIT;
                                                        ELSE
                                                       
                                                             UPDATE REASON
                                                                SET TEXT = LRSTANDARDQ.TEXT
                                                              WHERE ID =
                                                                       ( SELECT MAX( ID )
                                                                          FROM REASON
                                                                         WHERE STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG
                                                                           AND PART_NO = LRSTANDARDQ.PARTNO
                                                                           AND REVISION = LRSTANDARDQ.REVISION );

                                                             COMMIT;
                                                         
                                                         END IF;
                                                    END IF;

                                                END IF;

                                          END IF;
                                         
                                         

                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        IF LSREASONMANDATORY = 1
                                           AND LSSTATUSTYPETO = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                        THEN

                                             SELECT MAX( ID )
                                               INTO LNREASONID
                                             FROM REASON
                                             WHERE STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG
                                               AND PART_NO = LRSTANDARDQ.PARTNO
                                               AND REVISION = LRSTANDARDQ.REVISION;

                                             IF (LNREASONID IS NULL)
                                             THEN
                                                
                                                IF LRSTANDARDQ.TEXT IS NOT NULL
                                                THEN
                                                    LSTEXT := LRSTANDARDQ.TEXT;
                                                ELSE
                                                    LSTEXT := '';
                                                END IF;

                                                SELECT REASON_SEQ.NEXTVAL
                                                  INTO LNREASONID
                                                  FROM DUAL;

                                                INSERT INTO REASON
                                                            ( ID,
                                                              PART_NO,
                                                              REVISION,
                                                              STATUS_TYPE,
                                                              TEXT )
                                                     VALUES ( LNREASONID,
                                                              LRSTANDARDQ.PARTNO,
                                                              LRSTANDARDQ.REVISION,
                                                              IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG,
                                                              LSTEXT );

                                                COMMIT;

                                             END IF;

                                         END IF;

                                         LNRETVAL :=
                                                IAPISPECIFICATIONVALIDATION.VALIDATIONRULESERRORLIST( LRSTANDARDQ.STATUS,
                                                                                                      LRSTANDARDQ.REVISION,
                                                                                                      LRSTANDARDQ.PARTNO,
                                                                                                      LRSTANDARDQ.STATUSTO,
                                                                                                      AQERRORS );
                                          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                                             THEN
                                                    LOOP
                                                          FETCH AQERRORS INTO ARERROR;
                                                          EXIT WHEN AQERRORS%NOTFOUND;
                                                              LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                                        LRSTANDARDQ.REVISION,
                                                                        ARERROR.ERRORTEXT );
                                                    END LOOP;
                                                    CLOSE AQERRORS;
                                                    ROLLBACK;
                                                    GOTO END_LOOP;
                                             ELSE

                                         
                                             LNRETVAL :=
                                                IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESERROR( LRSTANDARDQ.STATUS,
                                                                                                  LRSTANDARDQ.REVISION,
                                                                                                  LRSTANDARDQ.PARTNO,
                                                                                                  LRSTANDARDQ.STATUSTO );

                                             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                                             THEN
                                                LSSQLERRORMESSAGE := IAPIGENERAL.GETLASTERRORTEXT( );
                                                ROLLBACK;
                                                LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                          LRSTANDARDQ.REVISION,
                                                          LSSQLERRORMESSAGE );
                                                GOTO END_LOOP;
                                             END IF;
                                           END IF; 

                                             LNRETVAL :=
                                                IAPISPECIFICATIONSTATUS.STATUSCHANGE( LRSTANDARDQ.STATUS,
                                                                                      LRSTANDARDQ.REVISION,
                                                                                      LRSTANDARDQ.PARTNO,
                                                                                      LRSTANDARDQ.STATUSTO,
                                                                                      LRSTANDARDQ.USERID,
                                                                                      LRSTANDARDQ.ES_SEQ_NO,
                                                                                      
                                                                                      
                                                                                      LQERRORS,
                                                                                      0);
                                                                                      

                                             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                                             THEN

                                                
                                                IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOERRORINLIST)
                                                THEN








                                                    
                                                    LOOP
                                                          FETCH LQERRORS
                                                           INTO LRERROR;

                                                          EXIT WHEN LQERRORS%NOTFOUND;

                                                          LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                                    LRSTANDARDQ.REVISION,
                                                                    LRERROR.ERRORTEXT,
                                                                    'en',
                                                                    1 );
                                                    END LOOP;

                                                    CLOSE LQERRORS;

                                                    
                                                    GOTO OK_SPEC;
                                                ELSE
                                                    IF (LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST)
                                                    THEN








                                                        
                                                        LOOP
                                                              FETCH LQERRORS
                                                               INTO LRERROR;

                                                              EXIT WHEN LQERRORS%NOTFOUND;

                                                              LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                                        LRSTANDARDQ.REVISION,
                                                                        LRERROR.ERRORTEXT,
                                                                        'en',
                                                                        0 );
                                                        END LOOP;

                                                        CLOSE LQERRORS;
                                                    END IF;
                                                END IF;
                                                

                                                LSSQLERRORMESSAGE := IAPIGENERAL.GETLASTERRORTEXT( );
                                                ROLLBACK;
                                                LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                          LRSTANDARDQ.REVISION,
                                                          LSSQLERRORMESSAGE );
                                                GOTO END_LOOP;
                                             END IF;

                                             
                                             <<OK_SPEC>>
                                             NULL;
                                             

                                             UPDATE ITSHQ
                                                SET STATUS_TO = NULL
                                              WHERE USER_ID = LRSTANDARDQ.USERID
                                                AND PART_NO = LRSTANDARDQ.PARTNO
                                                AND REVISION = LRSTANDARDQ.REVISION;

                                             COMMIT;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             LSSQLERRORMESSAGE := IAPIGENERAL.GETLASTERRORTEXT( );
                                             ROLLBACK;
                                             LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                       LRSTANDARDQ.REVISION,
                                                       LSSQLERRORMESSAGE );
                                       END;
                                    ELSE
                                       LOGQUEUE( LRSTANDARDQ.PARTNO,
                                                 LRSTANDARDQ.REVISION,
                                                 'Mandatory column not filled in' );
                                    END IF;
                                 END IF;

                                 <<END_LOOP>>
                                 NULL;   
                                 
                                 COMMIT;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'rpv'
                        THEN
                           OPEN C_RPV( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_RPV
                           BULK COLLECT INTO LTRPV;

                           CLOSE C_RPV;

                           FOR I IN 1 .. LTRPV.COUNT
                           LOOP
                              LRRPV := LTRPV( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRRPV.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRRPV.PART_NO,
                                              LRRPV.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    IF LRRPV.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                    THEN
                                       BEGIN
                                          IF LRRPV.USER_INTL <> LRRPV.INTL
                                          THEN
                                             IF LRRPV.USER_INTL = '1'
                                             THEN
                                                LOGQUEUE( LRRPV.PART_NO,
                                                          LRRPV.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                             ELSE
                                                LOGQUEUE( LRRPV.PART_NO,
                                                          LRRPV.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                             END IF;
                                          ELSE
                                             

                                             
                                             LSTYPE := SUBSTR( LRRPV.TEXT,
                                                               1,
                                                               1 );
                                             LNSEMI1 := INSTR( LRRPV.TEXT,
                                                               ';',
                                                               1,
                                                               1 );
                                             LNSEMI2 := INSTR( LRRPV.TEXT,
                                                               ';',
                                                               1,
                                                               2 );
                                             LNSEMI3 := INSTR( LRRPV.TEXT,
                                                               ';',
                                                               1,
                                                               3 );
                                             LNSEMI4 := INSTR( LRRPV.TEXT,
                                                               ';',
                                                               1,
                                                               4 );
                                             LNSEMI5 := INSTR( LRRPV.TEXT,
                                                               ';',
                                                               1,
                                                               5 );
                                             LNSEMI6 := INSTR( LRRPV.TEXT,
                                                               ';',
                                                               1,
                                                               6 );
                                             LNSEMI7 := INSTR( LRRPV.TEXT,
                                                               ';',
                                                               1,
                                                               7 );

                                             IF LSTYPE = 'S'
                                             THEN
                                                LNSECTIONID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                    LNSEMI1
                                                                                  + 1,
                                                                                    LNSEMI2
                                                                                  - LNSEMI1
                                                                                  - 1 ) );
                                                LNSUBSECTIONID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                       LNSEMI2
                                                                                     + 1,
                                                                                       LNSEMI3
                                                                                     - LNSEMI2
                                                                                     - 1 ) );
                                                LNPROPERTYGROUPID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                          LNSEMI3
                                                                                        + 1,
                                                                                          LNSEMI4
                                                                                        - LNSEMI3
                                                                                        - 1 ) );
                                                LNPROPERTYID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                     LNSEMI4
                                                                                   + 1,
                                                                                     LNSEMI5
                                                                                   - LNSEMI4
                                                                                   - 1 ) );
                                                LNATTRIBUTEID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                      LNSEMI5
                                                                                    + 1,
                                                                                      LNSEMI6
                                                                                    - LNSEMI5
                                                                                    - 1 ) );
                                                LNHEADERID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                   LNSEMI6
                                                                                 + 1,
                                                                                   LNSEMI7
                                                                                 - LNSEMI6
                                                                                 - 1 ) );
                                                LNCOLTYPE := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                  LNSEMI7
                                                                                + 1 ) );
                                                LSPLANT := NULL;
                                                LSLINE := NULL;
                                                LNCONFIGURATIONID := NULL;
                                                LNSTAGEID := NULL;
                                             ELSE
                                                LNSEMI7 := INSTR( LRRPV.TEXT,
                                                                  ';',
                                                                  1,
                                                                  7 );
                                                LSPLANT := SUBSTR( LRRPV.TEXT,
                                                                     LNSEMI1
                                                                   + 1,
                                                                     LNSEMI2
                                                                   - LNSEMI1
                                                                   - 1 );
                                                LSLINE := SUBSTR( LRRPV.TEXT,
                                                                    LNSEMI2
                                                                  + 1,
                                                                    LNSEMI3
                                                                  - LNSEMI2
                                                                  - 1 );
                                                LNCONFIGURATIONID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                          LNSEMI3
                                                                                        + 1,
                                                                                          LNSEMI4
                                                                                        - LNSEMI3
                                                                                        - 1 ) );
                                                LNSTAGEID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                  LNSEMI4
                                                                                + 1,
                                                                                  LNSEMI5
                                                                                - LNSEMI4
                                                                                - 1 ) );
                                                LNPROPERTYID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                     LNSEMI5
                                                                                   + 1,
                                                                                     LNSEMI6
                                                                                   - LNSEMI5
                                                                                   - 1 ) );
                                                LNATTRIBUTEID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                      LNSEMI6
                                                                                    + 1,
                                                                                      LNSEMI7
                                                                                    - LNSEMI6
                                                                                    - 1 ) );
                                                LNHEADERID := TO_NUMBER( SUBSTR( LRRPV.TEXT,
                                                                                   LNSEMI7
                                                                                 + 1 ) );
                                                LNSECTIONID := NULL;
                                                LNSUBSECTIONID := NULL;
                                                LNPROPERTYGROUPID := NULL;
                                             END IF;

                                             BEGIN
                                                IF LSTYPE = 'S'
                                                THEN
                                                   SELECT INTL
                                                     INTO LNLOCAL
                                                     FROM SPECIFICATION_PROP
                                                    WHERE PART_NO = LRRPV.PART_NO
                                                      AND REVISION = LRRPV.REVISION
                                                      AND SECTION_ID = LNSECTIONID
                                                      AND SUB_SECTION_ID = LNSUBSECTIONID
                                                      AND PROPERTY_GROUP = LNPROPERTYGROUPID
                                                      AND PROPERTY = LNPROPERTYID
                                                      AND ATTRIBUTE = LNATTRIBUTEID;
                                                ELSE
                                                   SELECT INTL
                                                     INTO LNLOCAL
                                                     FROM SPECIFICATION_LINE_PROP
                                                    WHERE PART_NO = LRRPV.PART_NO
                                                      AND REVISION = LRRPV.REVISION
                                                      AND SECTION_ID = LNSECTIONID
                                                      AND SUB_SECTION_ID = LNSUBSECTIONID
                                                      AND PLANT = LSPLANT
                                                      AND LINE = LSLINE
                                                      AND CONFIGURATION = LNCONFIGURATIONID
                                                      AND STAGE = LNSTAGEID
                                                      AND PROPERTY = LNPROPERTYID
                                                      AND ATTRIBUTE = LNATTRIBUTEID;
                                                END IF;
                                             EXCEPTION
                                                WHEN NO_DATA_FOUND
                                                THEN
                                                   LNLOCAL := 0;
                                             END;

                                             
                                             IF     NOT LRRPV.INTL_PART_NO IS NULL
                                                AND LNLOCAL = 1
                                             THEN
                                                LOGQUEUE( LRRPV.PART_NO,
                                                          LRRPV.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_ITEMNOTLOCALMODIFIABLE );
                                             ELSE
                                                BEGIN
                                                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                                                        LSMETHOD,
                                                                        'Calling iapiSpecification.ChangeValue' );
                                                   LSERRORMESSAGE := NULL;

                                                   IF LSTYPE <> 'S'
                                                   THEN
                                                      LNRETVAL :=
                                                         IAPISPECIFICATION.CHANGEVALUE( LRRPV.PART_NO,
                                                                                        LRRPV.REVISION,
                                                                                        LSTYPE,
                                                                                        LNSECTIONID,
                                                                                        LNSUBSECTIONID,
                                                                                        LNPROPERTYGROUPID,
                                                                                        LNPROPERTYID,
                                                                                        LNATTRIBUTEID,
                                                                                        LNHEADERID,
                                                                                        LSPLANT,
                                                                                        LSLINE,
                                                                                        LNCONFIGURATIONID,
                                                                                        LNSTAGEID,
                                                                                        LRRPV.NEW_VALUE_CHAR,
                                                                                        LRRPV.NEW_VALUE_NUM,
                                                                                        LRRPV.NEW_VALUE_DATE );
                                                   ELSE   
                                                      IF LNPROPERTYGROUPID = 0
                                                      THEN
                                                         LNTYPE2 := 4;
                                                         LNREFID := LNPROPERTYID;
                                                      ELSE
                                                         LNTYPE2 := 1;
                                                         LNREFID := LNPROPERTYGROUPID;
                                                      END IF;

                                                      
                                                      BEGIN

                                                      
                                                         BEGIN

                                                         SELECT DISPLAY_FORMAT,
                                                                DISPLAY_FORMAT_REV
                                                           INTO LNDISPLAYFORMATID,
                                                                LNDISPLAYFORMATREV
                                                           FROM SPECIFICATION_SECTION
                                                          WHERE PART_NO = LRRPV.PART_NO
                                                            AND REVISION = LRRPV.REVISION
                                                            AND SECTION_ID = LNSECTIONID
                                                            AND SUB_SECTION_ID = LNSUBSECTIONID
                                                            AND TYPE = LNTYPE2
                                                            AND REF_ID = LNREFID;

                                                    
                                                         EXCEPTION
                                                            WHEN NO_DATA_FOUND
                                                            THEN

                                                                SELECT DISPLAY_FORMAT,
                                                                        DISPLAY_FORMAT_REV
                                                                INTO LNDISPLAYFORMATID,
                                                                    LNDISPLAYFORMATREV
                                                                FROM FRAME_SECTION FS, SPECIFICATION_HEADER SH
                                                                WHERE SH.PART_NO = LRRPV.PART_NO
                                                                AND SH.REVISION = LRRPV.REVISION
                                                                AND FS.FRAME_NO = SH.FRAME_ID
                                                                AND FS.REVISION = SH.FRAME_REV
                                                                AND FS.OWNER = SH.OWNER
                                                                AND SECTION_ID = LNSECTIONID
                                                                AND SUB_SECTION_ID = LNSUBSECTIONID
                                                                AND TYPE = LNTYPE2
                                                                AND REF_ID = LNREFID;
                                                         END;
                                                   


                                                         
                                                         BEGIN
                                                            SELECT FIELD_ID
                                                              INTO LNFIELDID
                                                              FROM PROPERTY_LAYOUT
                                                             WHERE LAYOUT_ID = LNDISPLAYFORMATID
                                                               AND REVISION = LNDISPLAYFORMATREV
                                                               AND HEADER_ID = LNHEADERID;

                                                            IF    (     LNFIELDID < 11   
                                                                    AND LNCOLTYPE = 1 )
                                                               OR (      (     LNFIELDID > 10
                                                                           AND LNFIELDID < 17 )   
                                                                    AND LNCOLTYPE = 2 )
                                                               OR (      (     LNFIELDID > 16
                                                                           AND LNFIELDID < 21 )   
                                                                    AND LNCOLTYPE = 3 )
                                                               OR (      (    LNFIELDID = 21
                                                                           OR LNFIELDID = 22 )   
                                                                    AND LNCOLTYPE = 4 )
                                                               OR (      (    LNFIELDID = 26
                                                                           OR LNFIELDID = 30
                                                                           OR LNFIELDID = 31 )   
                                                                    AND (    LNCOLTYPE = 5
                                                                          OR LNCOLTYPE = 7
                                                                          OR LNCOLTYPE = 8 ) )
                                                               OR (     LNFIELDID = 25
                                                                    AND LNCOLTYPE = 6 )   
                                                            THEN
                                                               LNRETVAL :=
                                                                  IAPISPECIFICATION.CHANGEVALUE( LRRPV.PART_NO,
                                                                                                 LRRPV.REVISION,
                                                                                                 LSTYPE,
                                                                                                 LNSECTIONID,
                                                                                                 LNSUBSECTIONID,
                                                                                                 LNPROPERTYGROUPID,
                                                                                                 LNPROPERTYID,
                                                                                                 LNATTRIBUTEID,
                                                                                                 LNHEADERID,
                                                                                                 LSPLANT,
                                                                                                 LSLINE,
                                                                                                 LNCONFIGURATIONID,
                                                                                                 LNSTAGEID,
                                                                                                 LRRPV.NEW_VALUE_CHAR,
                                                                                                 LRRPV.NEW_VALUE_NUM,
                                                                                                 LRRPV.NEW_VALUE_DATE );
                                                            END IF;
                                                         EXCEPTION
                                                            WHEN NO_DATA_FOUND
                                                            THEN
                                                               LNRETVAL :=
                                                                  IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_PROPERTYDFNOTFOUND,
                                                                                            LNDISPLAYFORMATID,
                                                                                            LNDISPLAYFORMATREV );
                                                         END;
                                                      EXCEPTION
                                                         WHEN NO_DATA_FOUND
                                                         THEN
                                                            LNRETVAL :=
                                                               IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NODISPLAYFRMTFOUND,
                                                                                         LRRPV.PART_NO,
                                                                                         LRRPV.REVISION,
                                                                                         
                                                                                         
                                                                                         
                                                                                         
                                                                                         
                                                                                         
                                                                                          
                                                                                          F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LNSECTIONID, 0),
                                                                                          F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LNSUBSECTIONID, 0),
                                                                                          F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LNPROPERTYGROUPID, 0),
                                                                                          F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LNPROPERTYID, 0),
                                                                                          F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LNATTRIBUTEID, 0));
                                                                                          
                                                      END;
                                                   END IF;

                                                   IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                                                   THEN
                                                      LSERRORMESSAGE := IAPIGENERAL.GETLASTERRORTEXT( );
                                                   END IF;

                                                   IF LSERRORMESSAGE IS NOT NULL
                                                   THEN
                                                      ROLLBACK;
                                                      LOGQUEUE( LRRPV.PART_NO,
                                                                LRRPV.REVISION,
                                                                LSERRORMESSAGE );
                                                   END IF;
                                                EXCEPTION
                                                   WHEN OTHERS
                                                   THEN
                                                      ROLLBACK;
                                                      LOGQUEUE( LRRPV.PART_NO,
                                                                LRRPV.REVISION,
                                                                SQLERRM );
                                                END;
                                             END IF;

                                             COMMIT;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             ROLLBACK;
                                             LOGQUEUE( LRRPV.PART_NO,
                                                       LRRPV.REVISION,
                                                       SQLERRM );
                                       END;
                                    ELSE
                                       LOGQUEUE( LRRPV.PART_NO,
                                                 LRRPV.REVISION,
                                                    'Status '
                                                 || LRRPV.STATUS_TYPE
                                                 || ' is not of type DEVELOPMENT' );
                                    END IF;
                                 END IF;

                                 COMMIT;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );

                                 
                                 UPDATE ITSHQ
                                    SET NEW_VALUE_CHAR = NULL,
                                        NEW_VALUE_NUM = NULL,
                                        NEW_VALUE_DATE = NULL
                                  WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                                 COMMIT;
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );

                                 
                                 UPDATE ITSHQ
                                    SET NEW_VALUE_CHAR = NULL,
                                        NEW_VALUE_NUM = NULL,
                                        NEW_VALUE_DATE = NULL
                                  WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                                 COMMIT;
                                 EXIT;
                              END IF;
                           END LOOP;

                           
                           UPDATE ITSHQ
                              SET NEW_VALUE_CHAR = NULL,
                                  NEW_VALUE_NUM = NULL,
                                  NEW_VALUE_DATE = NULL
                            WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                           COMMIT;
                        END IF;

   
   
   
                        IF     LSALERTMESSAGE <> ' '
                           AND LSJOB = 'ubu'
                        THEN
                           OPEN C_UBU( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

                           FETCH C_UBU
                           BULK COLLECT INTO LTUBU;

                           CLOSE C_UBU;

                           FOR I IN 1 .. LTUBU.COUNT
                           LOOP
                              LRUBU := LTUBU( I );
                              LNRECCOUNT :=   LNRECCOUNT
                                            + 1;
                              LNPROGRESS :=   (   100
                                                / LNTOTALRECORDS )
                                            * LNRECCOUNT;

                              UPDATE ITQ
                                 SET PROGRESS = LNPROGRESS
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              COMMIT;

                              SELECT STATUS
                                INTO LSSTATUS
                                FROM ITQ
                               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

                              IF LSSTATUS = IAPICONSTANT.STARTED_TEXT
                              THEN
                                 IF LRUBU.CF_ACCESS = 1
                                 THEN
                                    LOGQUEUE( LRUBU.PART_NO,
                                              LRUBU.REVISION,
                                              IAPICONSTANTDBERROR.DBERR_NOACCESSSPEC );
                                 ELSE
                                    
                                    IF LRUBU.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                                    THEN
                                       BEGIN
                                          IF LRUBU.USER_INTL <> LRUBU.INTL
                                          THEN
                                             IF LRUBU.USER_INTL = '1'
                                             THEN
                                                LOGQUEUE( LRUBU.PART_NO,
                                                          LRUBU.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATELOCAL );
                                             ELSE
                                                LOGQUEUE( LRUBU.PART_NO,
                                                          LRUBU.REVISION,
                                                          IAPICONSTANTDBERROR.DBERR_NOUPDATEINTERNATIONAL );
                                             END IF;
                                          ELSE
                                             LNSEMI1 := INSTR( LRUBU.TEXT,
                                                               ';',
                                                               1,
                                                               1 );
                                             
                                             LNCONVFACTOR := TO_NUMBER( SUBSTR( LRUBU.TEXT,
                                                                                1,
                                                                                  LNSEMI1
                                                                                - 1 ) );
                                             LSCOMP := SUBSTR( LRUBU.TEXT,
                                                                 LNSEMI1
                                                               + 1 );

                                             BEGIN
                                                SELECT BASE_TO_UNIT
                                                  INTO LSBASETOUNIT
                                                  FROM PART
                                                 WHERE PART_NO = LSCOMP;

                                                FOR REC_ITEM IN C_CONV_ITEMS( LRUBU.PART_NO,
                                                                              LRUBU.REVISION,
                                                                              LSCOMP )
                                                LOOP
                                                   IF    REC_ITEM.CONV_FACTOR IS NULL
                                                      OR REC_ITEM.CONV_FACTOR = 0
                                                   THEN
                                                      LOGQUEUE( LRUBU.PART_NO,
                                                                LRUBU.REVISION,
                                                                'Conversion factor must be filled in' );
                                                   ELSE
                                                      IF REC_ITEM.TO_UNIT = LSBASETOUNIT
                                                      THEN
                                                         UPDATE BOM_ITEM
                                                            SET CONV_FACTOR = LNCONVFACTOR
                                                          WHERE PART_NO = LRUBU.PART_NO
                                                            AND REVISION = LRUBU.REVISION
                                                            AND PLANT = REC_ITEM.PLANT
                                                            AND ALTERNATIVE = REC_ITEM.ALTERNATIVE
                                                            AND BOM_USAGE = REC_ITEM.BOM_USAGE
                                                            AND ITEM_NUMBER = REC_ITEM.ITEM_NUMBER;
                                                      ELSE
                                                         LOGQUEUE( LRUBU.PART_NO,
                                                                   LRUBU.REVISION,
                                                                   'Base conv. UOM does not match component conv. UOM' );
                                                      END IF;
                                                   END IF;
                                                END LOOP;

                                                
                                                FOR REC_ITEM IN C_ITEMS( LRUBU.PART_NO,
                                                                         LRUBU.REVISION,
                                                                         LSCOMP )
                                                LOOP
                                                   
                                                   SELECT CALC_FLAG,
                                                          TO_UNIT
                                                     INTO LSAUTOCALC,
                                                          LSCOMPONENTUOM
                                                     FROM BOM_ITEM
                                                    WHERE PART_NO = LRUBU.PART_NO
                                                      AND REVISION = LRUBU.REVISION
                                                      AND PLANT = REC_ITEM.PLANT
                                                      AND ALTERNATIVE = REC_ITEM.ALTERNATIVE
                                                      AND BOM_USAGE = REC_ITEM.BOM_USAGE
                                                      AND ITEM_NUMBER = REC_ITEM.ITEM_NUMBER;

                                                   IF LSAUTOCALC <> 'N'
                                                   THEN
                                                      
                                                      
                                                      SELECT CALC_FLAG
                                                        INTO LSAUTOCALC
                                                        FROM BOM_HEADER
                                                       WHERE PART_NO = LRUBU.PART_NO
                                                         AND REVISION = LRUBU.REVISION
                                                         AND PLANT = REC_ITEM.PLANT
                                                         AND ALTERNATIVE = REC_ITEM.ALTERNATIVE
                                                         AND BOM_USAGE = REC_ITEM.BOM_USAGE;

                                                      IF LSAUTOCALC <> 'N'
                                                      THEN
                                                         
                                                         SELECT BASE_UOM,
                                                                BASE_TO_UNIT
                                                           INTO LSBASEUOM,
                                                                LSTOUNIT
                                                           FROM PART
                                                          WHERE PART_NO = LRUBU.PART_NO;

                                                         IF    LSCOMPONENTUOM = LSBASEUOM
                                                            OR LSCOMPONENTUOM = LSTOUNIT
                                                         THEN
                                                            
                                                            SELECT SUM( DECODE( LSCOMPONENTUOM,
                                                                                UOM, QUANTITY,
                                                                                TO_UNIT, CONV_FACTOR
                                                                                 * QUANTITY,
                                                                                0 ) )
                                                              INTO LNSUM
                                                              FROM BOM_ITEM
                                                             WHERE PART_NO = LRUBU.PART_NO
                                                               AND REVISION = LRUBU.REVISION
                                                               AND PLANT = REC_ITEM.PLANT
                                                               AND ALTERNATIVE = REC_ITEM.ALTERNATIVE
                                                               AND BOM_USAGE = REC_ITEM.BOM_USAGE
                                                               AND CALC_FLAG <> 'N';

                                                            IF LSBASEUOM = LSCOMPONENTUOM
                                                            THEN
                                                               
                                                               UPDATE BOM_HEADER
                                                                  SET BASE_QUANTITY = LNSUM
                                                                WHERE PART_NO = LRUBU.PART_NO
                                                                  AND REVISION = LRUBU.REVISION
                                                                  AND PLANT = REC_ITEM.PLANT
                                                                  AND ALTERNATIVE = REC_ITEM.ALTERNATIVE
                                                                  AND BOM_USAGE = REC_ITEM.BOM_USAGE;
                                                            ELSIF LSTOUNIT = LSCOMPONENTUOM
                                                            THEN
                                                               
                                                               UPDATE BOM_HEADER
                                                                  SET CONV_FACTOR = LNSUM
                                                                WHERE PART_NO = LRUBU.PART_NO
                                                                  AND REVISION = LRUBU.REVISION
                                                                  AND PLANT = REC_ITEM.PLANT
                                                                  AND ALTERNATIVE = REC_ITEM.ALTERNATIVE
                                                                  AND BOM_USAGE = REC_ITEM.BOM_USAGE;
                                                            END IF;
                                                         END IF;
                                                      END IF;
                                                   END IF;
                                                END LOOP;

                                                
                                                LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRUBU.PART_NO,
                                                                                          LRUBU.REVISION );
                                                COMMIT;
                                             EXCEPTION
                                                WHEN OTHERS
                                                THEN
                                                   ROLLBACK;
                                                   LOGQUEUE( LRUBU.PART_NO,
                                                             LRUBU.REVISION,
                                                             SQLERRM );
                                             END;
                                          END IF;
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             ROLLBACK;
                                             LOGQUEUE( LRUBU.PART_NO,
                                                       LRUBU.REVISION,
                                                       SQLERRM );
                                       END;
                                    ELSE
                                       LOGQUEUE( LRUBU.PART_NO,
                                                 LRUBU.REVISION,
                                                    'Status '
                                                 || LRUBU.STATUS_TYPE
                                                 || ' is not of type DEVELOPMENT' );
                                    END IF;

                                    COMMIT;
                                 END IF;
                              ELSIF LSSTATUS = IAPICONSTANT.CANCELLED_TEXT
                              THEN
                                 JOBCANCELLED( LNPROGRESS,
                                               LNRECCOUNT );
                                 EXIT;
                              ELSE
                                 JOBFINISHED( LNPROGRESS );
                                 EXIT;
                              END IF;
                           END LOOP;
                        END IF;

                        IF LSSTATUS <> IAPICONSTANT.CANCELLED_TEXT
                        THEN
                           DBMS_ALERT.SIGNAL(    'CL_Q'
                                              || IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                              'Q_FINISHED' );

                           INSERT INTO ITJOBQ
                                       ( JOB_SEQ,
                                         USER_ID,
                                         LOGDATE,
                                         ERROR_MSG )
                                VALUES ( JOBQ_SEQ.NEXTVAL,
                                         LSALERTMESSAGE,
                                         SYSDATE,
                                            'Job completed '
                                         || LNRECCOUNT
                                         || ' items processed' );

                           UPDATE ITQ
                              SET PROGRESS = 100,
                                  STATUS = IAPICONSTANT.FINISHED_TEXT,
                                  END_DATE = SYSDATE
                            WHERE USER_ID = LSALERTMESSAGE;

                           COMMIT;
                        END IF;
                     END LOOP;
                  END LOOP;   
               END IF;
            END IF;
         END LOOP;
      
      END IF;
      IF LBLOCKED THEN
         RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
         LBLOCKED := FALSE;
      END IF;
      DBMS_APPLICATION_INFO.SET_ACTION( 'MOP JOB GOING TO SLEEP' );
     

   EXCEPTION
      WHEN OTHERS
      THEN
        
         
         
         IF LBLOCKED THEN
        
            INSERT INTO ITJOBQ
                        ( JOB_SEQ,
                          USER_ID,
                          LOGDATE,
                          ERROR_MSG )
                 VALUES ( JOBQ_SEQ.NEXTVAL,
                          IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                          SYSDATE,
                             'Job aborted / '
                          || LNRECCOUNT
                          || ' items processed' );

            UPDATE ITQ
               SET PROGRESS = 0,
                   STATUS = IAPICONSTANT.FINISHED_TEXT,
                   END_DATE = SYSDATE
             WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
         
         END IF;
         IF LBLOCKED THEN
            BEGIN
               RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
               LBLOCKED := FALSE;
            EXCEPTION
            WHEN OTHERS THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
            END;
         END IF;
         

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         COMMIT;
   END EXECUTEQUEUE;

   
   FUNCTION EDITQUEUE(
      ASPARTNO                   IN       IAPITYPE.PARTNOTAB_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISIONTAB_TYPE,
      ANNBRPARTS                 IN       IAPITYPE.NUMVAL_TYPE,
      ASACTION                   IN       IAPITYPE.ACTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LIACCESS                      PLS_INTEGER;
      LICOUNTER                     PLS_INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EditQueue';

      CURSOR SH_CUR(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT PART_NO,
                REVISION
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANNBRPARTS > 0
      THEN
         FOR LNCOUNTER IN 1 .. ANNBRPARTS
         LOOP
            BEGIN
               IF    ANREVISION( LNCOUNTER ) IS NULL
                  OR ANREVISION( LNCOUNTER ) = 0
               THEN
                  IF ASACTION = 'A'
                  THEN
                     FOR SH_REC IN SH_CUR( ASPARTNO( LNCOUNTER ) )
                     LOOP
                        BEGIN
                           
                           LIACCESS := F_CHECK_ACCESS( ASPARTNO( LNCOUNTER ),
                                                       SH_REC.REVISION );

                           IF LIACCESS > 0
                           THEN
                              INSERT INTO ITSHQ
                                          ( USER_ID,
                                            PART_NO,
                                            REVISION )
                                   VALUES ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                            ASPARTNO( LNCOUNTER ),
                                            SH_REC.REVISION );

                              COMMIT;
                           END IF;
                        EXCEPTION
                           WHEN DUP_VAL_ON_INDEX
                           THEN
                              NULL;
                        END;
                     END LOOP;
                  ELSE
                     SELECT MAX( REVISION )
                       INTO LNREVISION
                       FROM SPECIFICATION_HEADER
                      WHERE PART_NO = ASPARTNO( LNCOUNTER );

                     DELETE FROM ITSHQ
                           WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                             AND PART_NO = ASPARTNO( LNCOUNTER )
                             AND REVISION = LNREVISION;

                     COMMIT;
                  END IF;
               ELSE
                  LNREVISION := ANREVISION( LNCOUNTER );

                  IF ASACTION = 'A'
                  THEN
                     
                     LIACCESS := F_CHECK_ACCESS( ASPARTNO( LNCOUNTER ),
                                                 LNREVISION );

                     IF LIACCESS > 0
                     THEN
                        INSERT INTO ITSHQ
                                    ( USER_ID,
                                      PART_NO,
                                      REVISION )
                             VALUES ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                      ASPARTNO( LNCOUNTER ),
                                      LNREVISION );

                        COMMIT;
                     END IF;
                  ELSE
                     DELETE FROM ITSHQ
                           WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                             AND PART_NO = ASPARTNO( LNCOUNTER )
                             AND REVISION = LNREVISION;

                     COMMIT;
                  END IF;
               END IF;
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
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
   END EDITQUEUE;

   
   FUNCTION STARTQUEUE
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LIJOBNO                       BINARY_INTEGER;
      LIJOBS                        PLS_INTEGER;
      LICOUNT                       PLS_INTEGER;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StartQueue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT COUNT( JOB )
        INTO LIJOBS
        FROM DBA_JOBS
       WHERE UPPER( WHAT ) LIKE    '%'
                                || UPPER( GSMOPJOB )
                                || '%';

      IF LIJOBS > 0
      THEN
         
         NULL;
      ELSE
         DBMS_JOB.SUBMIT( LIJOBNO,
                             GSMOPJOB
                          || ';',
                          SYSDATE,
                          '' );
         COMMIT;
      END IF;

      LICOUNT := 0;

      LOOP
         LICOUNT :=   LICOUNT
                    + 1;
         DBMS_ALERT.SIGNAL( GSMOPJOBNAME,
                            USER );
         COMMIT;

         IF SQL%ROWCOUNT > 0
         THEN
            EXIT;
         END IF;

         DBMS_LOCK.SLEEP( 2 );

         IF LICOUNT > 60
         THEN
            EXIT;
         END IF;
      END LOOP;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STARTQUEUE;

   
   FUNCTION ADDTOQUEUE(
      ASJOB                      IN       IAPITYPE.JOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      
      
      
      
      
      
      
      
      LICOUNT                       PLS_INTEGER;
      LSSTATUS                      ITQ.STATUS%TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddToQueue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      


      BEGIN
         UPDATE ITQ
            SET STATUS = IAPICONSTANT.CANCELLED_TEXT
          WHERE JOB_DESCR = 'Report'
            AND END_DATE IS NULL
            AND STATUS = IAPICONSTANT.STARTED_TEXT
            AND PROGRESS = 0
            AND START_DATE <   SYSDATE
                             -   10
                               * (    (   1
                                        / 24 )
                                   / 60 );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      SELECT COUNT( * )
        INTO LICOUNT
        FROM ITQ
       WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      IF LICOUNT = 0
      THEN
         INSERT INTO ITQ
                     ( USER_ID,
                       STATUS,
                       JOB_DESCR,
                       PROGRESS,
                       START_DATE )
              VALUES ( IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       IAPICONSTANT.STARTED_TEXT,
                       ASJOB,
                       0,
                       SYSDATE );
      ELSE
         UPDATE ITQ
            SET STATUS = IAPICONSTANT.STARTED_TEXT,
                JOB_DESCR = ASJOB,
                PROGRESS = 0,
                START_DATE = SYSDATE,
                END_DATE = NULL
          WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      END IF;

      IF IAPIGENERAL.LOGGINGENABLED
      THEN
         DBMS_ALERT.SIGNAL( GSMOPJOBNAME,
                            'Q_LOGGING' );
         COMMIT;
      END IF;

      IF    ASJOB = 'ssc'
         OR ASJOB = 'frr'
         OR ASJOB = 'cpr'
         OR ASJOB = 'rbi'
         OR ASJOB = 'caw'
         OR ASJOB = 'rpv'
         OR ASJOB = 'ubu'
         OR ASJOB = 'del'
         OR ASJOB = 'dbi'
         OR ASJOB = 'abi'
      THEN
         DBMS_ALERT.SIGNAL( GSMOPJOBNAME,
                            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDTOQUEUE;

   
   FUNCTION STOPQUEUE
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StopQueue';
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      DBMS_ALERT.SIGNAL( GSMOPJOBNAME,
                         'Q_STOP' );
      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STOPQUEUE;

   
   FUNCTION CHECKQUEUE
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckQueue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIRETURNCODE                  PLS_INTEGER;
      LIJOBS                        PLS_INTEGER;
      LSWHAT                        VARCHAR2( 128 );
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      


      BEGIN
         UPDATE ITQ
            SET STATUS = IAPICONSTANT.CANCELLED_TEXT
          WHERE JOB_DESCR = 'Report'
            AND END_DATE IS NULL
            AND STATUS = IAPICONSTANT.STARTED_TEXT
            AND PROGRESS = 0
            AND START_DATE <   SYSDATE
                             -   10
                               * (    (   1
                                        / 24 )
                                   / 60 );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      
      SELECT COUNT( JOB )
        INTO LIJOBS
        FROM DBA_JOBS
       WHERE UPPER( WHAT ) LIKE    '%'
                                || UPPER( GSMOPJOB )
                                || '%';

      IF LIJOBS > 0
      THEN
         
         LIRETURNCODE := 1;
         DBMS_ALERT.SIGNAL(    'CL_Q'
                            || IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                            'Q_RUNNING' );
         COMMIT;
      ELSE
         LNRETVAL := STARTQUEUE;
         DBMS_ALERT.SIGNAL( GSMOPJOBNAME,
                            USER );
         COMMIT;

         SELECT COUNT( JOB )
           INTO LIJOBS
           FROM DBA_JOBS
          WHERE UPPER( WHAT ) LIKE    '%'
                                   || UPPER( GSMOPJOB )
                                   || '%';

         IF LIJOBS > 0
         THEN
            
            LIRETURNCODE := 1;
            DBMS_ALERT.SIGNAL(    'CL_Q'
                               || IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                               'Q_RUNNING' );
            COMMIT;
         ELSE
            LIRETURNCODE := 0;
            DBMS_ALERT.SIGNAL(    'CL_Q'
                               || IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                               'Q_STOPPED' );
            COMMIT;
         END IF;
      END IF;

      IF LIRETURNCODE = 1
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_QUEUENOTRUNNING ) );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKQUEUE;

   
   FUNCTION CANCELQUEUE
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CancelQueue';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITQ
         SET STATUS = IAPICONSTANT.CANCELLED_TEXT
       WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CANCELQUEUE;

   
   FUNCTION GETMAXREV
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      CURSOR CUR_SPECS
      IS
         SELECT PART_NO,
                REVISION,
                ROWID
           FROM ITSHQ
          WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      LNMAXREVISION                 IAPITYPE.REVISION_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMaxRev';
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR REC_SPEC IN CUR_SPECS
      LOOP
         
         SELECT MAX( REVISION )
           INTO LNMAXREVISION
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = REC_SPEC.PART_NO;

         BEGIN
            UPDATE ITSHQ
               SET REVISION = LNMAXREVISION
             WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
               AND PART_NO = REC_SPEC.PART_NO;
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               DELETE FROM ITSHQ
                     WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                       AND PART_NO = REC_SPEC.PART_NO
                       AND REVISION = REC_SPEC.REVISION;
            WHEN OTHERS
            THEN
               NULL;
         END;
      END LOOP;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMAXREV;
END IAPIQUEUE;