PACKAGE BODY iapiSpecificationStatus
AS



   
   
   
   


   
   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN



        RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.0 (06.07.00.00-08.00) $)' );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;




   FUNCTION EXECUTESTATUSCHANGECUSTOMCODE(
      ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteStatusChangeCustomCode';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPROCEDURENAME               IAPITYPE.STRING_TYPE;
      LBRECORDSFOUND                BOOLEAN := FALSE;
      LNEXECUTECURSOR               IAPITYPE.NUMVAL_TYPE;
      LCSQL                         IAPITYPE.CLOB_TYPE;

      CURSOR LCGETPROCEDURENAME
      IS
         SELECT   PROCEDURE_NAME
             INTO LSPROCEDURENAME
             FROM ITSCCF SC,
                  ITCF CF
            WHERE (    SC.WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID
                    OR SC.WORKFLOW_GROUP_ID = -1 )
              AND STATUS = ANSTATUS
              AND SC.CF_ID = CF.CF_ID
              AND CF.CF_TYPE = IAPICONSTANT.CFTYPE_STATUSCHANGE
         ORDER BY CF.CF_ID;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'About lo launch custom objects for WorkFlow Group <'
                           || ANWORKFLOWGROUPID
                           || '> and '
                           || 'Status <'
                           || ANSTATUS
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNEXECUTECURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LSPROCEDURENAME IN LCGETPROCEDURENAME
      LOOP
         LBRECORDSFOUND := TRUE;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'About lo launch custom object <'
                              || LSPROCEDURENAME.PROCEDURE_NAME
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
         GNRETVAL := IAPICONSTANTDBERROR.DBERR_SUCCESS;
         LCSQL :=    'BEGIN iapiSpecificationStatus.gnRetVal := '
                  || LSPROCEDURENAME.PROCEDURE_NAME
                  || '; END;';
         DBMS_SQL.PARSE( LNEXECUTECURSOR,
                         LCSQL,
                         DBMS_SQL.V7 );
         LNRETVAL := DBMS_SQL.EXECUTE( LNEXECUTECURSOR );

         IF GNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( IAPICONSTANTDBERROR.DBERR_APPLICATIONERROR );
         END IF;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Back in launch function',
                              IAPICONSTANT.INFOLEVEL_3 );
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNEXECUTECURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF ( DBMS_SQL.IS_OPEN( LNEXECUTECURSOR ) )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LNEXECUTECURSOR );
         END IF;

         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_APPLICATIONERROR,
                                               SQLCODE,
                                               SQLERRM );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPICONSTANTDBERROR.DBERR_APPLICATIONERROR );
   END EXECUTESTATUSCHANGECUSTOMCODE;


   FUNCTION EXISTIDSTATUS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSID                 IN       IAPITYPE.STATUSID_TYPE,
      ASSTATUSSORTDESC           IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ANWORKFLOWGROUPID          OUT      IAPITYPE.WORKFLOWGROUPID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistIdStatus';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT WORKFLOW_GROUP_ID
        INTO ANWORKFLOWGROUPID
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND STATUS = ANSTATUSID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECSTATUSNOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASSTATUSSORTDESC ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTIDSTATUS;


   FUNCTION APPROVEFAIL(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASREASON                   IN       IAPITYPE.STRINGVAL_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANESSEQNO                  IN       IAPITYPE.NUMVAL_TYPE,
      ANWORKFLOWID               IN       IAPITYPE.WORKFLOWID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LDDAYTIME                     IAPITYPE.DATE_TYPE := SYSDATE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 0;
      LNNEWSTATUS                   IAPITYPE.STATUSID_TYPE;
      LNREASONID                    IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSTATUSHISTORYREVISION       IAPITYPE.REVISION_TYPE;
      LNSTATUSHISTORYSTATUS         IAPITYPE.STATUSID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ApproveFail';
      LSOPERATION                   IAPITYPE.STRING_TYPE;
      LSSTATUSHISTORYDATE           IAPITYPE.DATE_TYPE;
      LSSTATUSHISTORYPARTNO         IAPITYPE.PARTNO_TYPE;
      LSTABLE                       IAPITYPE.STRING_TYPE;
      LSEMAILENABLED                IAPITYPE.PARAMETERDATA_TYPE := '0';
      INTEGRITY_VIOLATION           EXCEPTION;
      LQERRORS                      IAPITYPE.REF_TYPE;
      PRAGMA EXCEPTION_INIT( INTEGRITY_VIOLATION, -2291 );
   BEGIN





      IF ( LQERRORS%ISOPEN )
      THEN
         CLOSE LQERRORS;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      BEGIN
         SELECT   PART_NO,
                  REVISION,
                  STATUS,
                  MAX( STATUS_DATE_TIME )
             INTO LSSTATUSHISTORYPARTNO,
                  LNSTATUSHISTORYREVISION,
                  LNSTATUSHISTORYSTATUS,
                  LSSTATUSHISTORYDATE
             FROM STATUS_HISTORY
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND STATUS = ANSTATUS
         GROUP BY PART_NO,
                  REVISION,
                  STATUS;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_PARTSTATUSHISTNOTFOUND,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       ANSTATUS );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      SELECT PARAMETER_DATA
        INTO LSEMAILENABLED
        FROM INTERSPC_CFG
       WHERE PARAMETER = 'email';

      
      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM STATUS A,
             WORK_FLOW B
       WHERE A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REJECT
         AND A.STATUS = B.NEXT_STATUS
         AND B.STATUS = ANSTATUS
         AND B.WORK_FLOW_ID = ANWORKFLOWID;

      IF LNCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PARTSTATUSTNOTFOUND,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    IAPICONSTANT.STATUSTYPE_REJECT );
      ELSIF LNCOUNT > 1
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PARTSTATUSTOOMANY,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    IAPICONSTANT.STATUSTYPE_REJECT );
      END IF;

      SELECT A.STATUS
        INTO LNNEWSTATUS
        FROM STATUS A,
             WORK_FLOW B
       WHERE A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REJECT
         AND A.STATUS = B.NEXT_STATUS
         AND B.STATUS = ANSTATUS
         AND B.WORK_FLOW_ID = ANWORKFLOWID;

      LSOPERATION := 'update';
      LSTABLE := 'specification_header';

      UPDATE SPECIFICATION_HEADER
         SET STATUS = LNNEWSTATUS,
             STATUS_CHANGE_DATE = SYSDATE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      LSOPERATION := 'update';
      LSTABLE := 'part';

      UPDATE PART
         SET CHANGED_DATE = SYSDATE
       WHERE PART_NO = ASPARTNO;

      
      SELECT REASON_SEQ.NEXTVAL
        INTO LNREASONID
        FROM DUAL;

      
      LSOPERATION := 'insert';
      LSTABLE := 'status_history';

      INSERT INTO STATUS_HISTORY
                  ( PART_NO,
                    REVISION,
                    STATUS,
                    STATUS_DATE_TIME,
                    USER_ID,
                    SORT_SEQ,
                    REASON_ID,
                    FORENAME,
                    LAST_NAME,
                    ES_SEQ_NO )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    LNNEWSTATUS,
                    LDDAYTIME,
                    ASUSERID,
                    STATUS_HISTORY_SEQ.NEXTVAL,
                    LNREASONID,
                    LSFORENAME,
                    LSLASTNAME,
                    ANESSEQNO );

      
      LSOPERATION := 'insert';
      LSTABLE := 'reason';

      INSERT INTO REASON
                  ( ID,
                    PART_NO,
                    REVISION,
                    STATUS_TYPE,
                    TEXT )
           VALUES ( LNREASONID,
                    ASPARTNO,
                    ANREVISION,
                    IAPICONSTANT.STATUSTYPE_REASONFORREJECTION,   
                    ASREASON );

      IF LSEMAILENABLED = '1'
      THEN
         
         LSOPERATION := 'insert';
         LSTABLE := 'itemail';
         LNRETVAL := IAPIEMAIL.REGISTEREMAIL( ASPARTNO,
                                              ANREVISION,
                                              LNNEWSTATUS,
                                              LDDAYTIME,
                                              'S',
                                              NULL,
                                              NULL,
                                              LNREASONID,
                                              NULL,
                                              LQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
      END IF;

      
      
      LSOPERATION := 'insert';
      LSTABLE := 'approval_history';

      INSERT INTO APPROVAL_HISTORY
                  ( PART_NO,
                    REVISION,
                    STATUS_DATE_TIME,
                    USER_ID,
                    STATUS,
                    APPROVED_DATE,
                    PASS_FAIL,
                    FORENAME,
                    LAST_NAME,
                    ES_SEQ_NO )
         SELECT PART_NO,
                REVISION,
                STATUS_DATE_TIME,
                US.USER_ID,
                STATUS,
                APPROVED_DATE,
                PASS_FAIL,
                FORENAME,
                LAST_NAME,
                USAP.ES_SEQ_NO
           FROM USERS_APPROVED USAP,
                APPLICATION_USER US
          WHERE USAP.USER_ID = US.USER_ID
            AND PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND STATUS = ANSTATUS;

      
      LSOPERATION := 'delete';
      LSTABLE := 'users_approved';

      DELETE FROM USERS_APPROVED
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND STATUS = ANSTATUS;

      
      LSOPERATION := 'insert';
      LSTABLE := 'approval_history';

      INSERT INTO APPROVAL_HISTORY
                  ( PART_NO,
                    REVISION,
                    STATUS_DATE_TIME,
                    USER_ID,
                    STATUS,
                    APPROVED_DATE,
                    PASS_FAIL,
                    FORENAME,
                    LAST_NAME,
                    ES_SEQ_NO )
           VALUES ( LSSTATUSHISTORYPARTNO,
                    LNSTATUSHISTORYREVISION,
                    LSSTATUSHISTORYDATE,
                    ASUSERID,
                    LNSTATUSHISTORYSTATUS,
                    LDDAYTIME,
                    'F',
                    LSFORENAME,
                    LSLASTNAME,
                    ANESSEQNO );

      
      GBAPPROVEDPF := 1;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN INTEGRITY_VIOLATION
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PARTINTEGRITYVIOLATION,
                                                    LSOPERATION,
                                                    LSTABLE );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END APPROVEFAIL;


   FUNCTION APPROVEPASS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASREASON                   IN       IAPITYPE.STRINGVAL_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANESSEQNO                  IN       IAPITYPE.NUMVAL_TYPE,
      ANWORKFLOWID               IN       IAPITYPE.WORKFLOWID_TYPE,
      ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
















      LBSKIPACYCLE                  IAPITYPE.LOGICAL_TYPE := FALSE;
      LBSKIPALLCYCLES               IAPITYPE.LOGICAL_TYPE := FALSE;
      LDDAYTIME                     IAPITYPE.DATE_TYPE := SYSDATE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNT1                      IAPITYPE.NUMVAL_TYPE := 0;
      LNAPPROVEDCOUNT               IAPITYPE.NUMVAL_TYPE := 0;
      LNGROUPID                     IAPITYPE.USERGROUPID_TYPE;
      LNNEWSTATUS                   IAPITYPE.STATUSID_TYPE;
      LNNUMBEREXIST                 IAPITYPE.NUMVAL_TYPE := 0;
      LNNUMBERVOTED                 IAPITYPE.NUMVAL_TYPE := 0;
      LNREASONID                    IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSTATUSHISTORYREVISION       IAPITYPE.REVISION_TYPE;
      LNSTATUSHISTORYSTATUS         IAPITYPE.STATUSID_TYPE;
      LNSUBMITCOUNT                 IAPITYPE.NUMVAL_TYPE;
      LSALLTOAPPROVE                IAPITYPE.STRING_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME;
      LSGENUSERID                   IAPITYPE.USERID_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ApprovePass';
      LSOPERATION                   IAPITYPE.STRING_TYPE;
      LSSTATUSHISTORYDATE           IAPITYPE.DATE_TYPE;
      LSSTATUSHISTORYPARTNO         IAPITYPE.PARTNO_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LSTABLE                       IAPITYPE.STRING_TYPE;
      LSEMAILENABLED                IAPITYPE.PARAMETERDATA_TYPE := '0';
      LQERRORS                      IAPITYPE.REF_TYPE;
      INTEGRITY_VIOLATION           EXCEPTION;
      PRAGMA EXCEPTION_INIT( INTEGRITY_VIOLATION, -2291 );
      LNAPPROVALNUMBER              IAPITYPE.NUMVAL_TYPE := 0;   
      LNREMAINSAPPROVAL             IAPITYPE.NUMVAL_TYPE := 0;   

      CURSOR LQWORKFLOWLIST
      IS
         SELECT A.USER_GROUP_ID,
                A.ALL_TO_APPROVE,
                B.USER_ID
           FROM WORK_FLOW_LIST A,
                USER_GROUP_LIST B
          WHERE A.WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID
            AND A.STATUS = ANSTATUS
            AND A.ALL_TO_APPROVE <> 'Z'
            AND A.EDITABLE = 'N'
            AND A.USER_GROUP_ID = B.USER_GROUP_ID
         UNION
         SELECT A.USER_GROUP_ID,
                DECODE( B.ALL_TO_APPROVE,
                        'S', 'Y',
                        B.ALL_TO_APPROVE ) ALL_TO_APPROVE,
                B.USER_ID USER_ID
           FROM WORK_FLOW_LIST A,
                APPROVER_SELECTED B
          WHERE B.SELECTED = 'Y'
            AND B.APPROVED = 'N'
            AND A.WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID
            AND A.STATUS = ANSTATUS
            AND A.STATUS = B.STATUS
            AND A.ALL_TO_APPROVE <> 'Z'
            AND A.EDITABLE = 'Y'
            AND B.PART_NO = ASPARTNO
            AND B.REVISION = ANREVISION
            AND B.USER_GROUP_ID = A.USER_GROUP_ID;

      CURSOR LQUSERGROUPLIST
      IS
         




         SELECT B.USER_ID
           FROM WORK_FLOW_LIST A,
                USER_GROUP_LIST B
          WHERE A.WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID
            AND A.STATUS = ANSTATUS
            AND A.ALL_TO_APPROVE <> 'Z'
            AND A.EDITABLE = 'N'
            AND A.USER_GROUP_ID = B.USER_GROUP_ID
            AND B.USER_GROUP_ID = LNGROUPID
         UNION
         SELECT B.USER_ID USER_ID
           FROM WORK_FLOW_LIST A,
                APPROVER_SELECTED B
          WHERE B.SELECTED = 'Y'
            AND B.APPROVED = 'N'
            AND A.WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID
            AND A.STATUS = ANSTATUS
            AND A.STATUS = B.STATUS
            AND A.ALL_TO_APPROVE <> 'Z'
            AND A.EDITABLE = 'Y'
            AND B.PART_NO = ASPARTNO
            AND B.REVISION = ANREVISION
            AND B.USER_GROUP_ID = A.USER_GROUP_ID
            AND A.USER_GROUP_ID = LNGROUPID;
   BEGIN





      IF ( LQERRORS%ISOPEN )
      THEN
         CLOSE LQERRORS;
      END IF;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         SELECT   PART_NO,
                  REVISION,
                  STATUS,
                  MAX( STATUS_DATE_TIME )
             INTO LSSTATUSHISTORYPARTNO,
                  LNSTATUSHISTORYREVISION,
                  LNSTATUSHISTORYSTATUS,
                  LSSTATUSHISTORYDATE
             FROM STATUS_HISTORY
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND STATUS = ANSTATUS
         GROUP BY PART_NO,
                  REVISION,
                  STATUS;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_PARTSTATUSHISTNOTFOUND,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       ANSTATUS );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      SELECT PARAMETER_DATA
        INTO LSEMAILENABLED
        FROM INTERSPC_CFG
       WHERE PARAMETER = 'email';

      
      SELECT CASE
                WHEN APPROVERS_NUMBER < 0
                   THEN 0
                ELSE APPROVERS_NUMBER
             END
        INTO LNAPPROVALNUMBER
        FROM WORKFLOW_GROUP
       WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID;

      
      IF LNAPPROVALNUMBER > 0
      THEN
         SELECT   LNAPPROVALNUMBER
                - COUNT( * )
                - 1
           INTO LNREMAINSAPPROVAL
           FROM USERS_APPROVED
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND STATUS = ANSTATUS
            AND PASS_FAIL = 'P';

         
         SELECT CASE
                   WHEN LNREMAINSAPPROVAL < 0
                      THEN 0
                   ELSE LNREMAINSAPPROVAL
                END
           INTO LNREMAINSAPPROVAL
           FROM DUAL;
      END IF;

      
      LSOPERATION := 'insert';
      LSTABLE := 'users_approved';


      SELECT COUNT( * )
        INTO LNCOUNT
        FROM USERS_APPROVED
       WHERE PART_NO = LSSTATUSHISTORYPARTNO
         AND REVISION = LNSTATUSHISTORYREVISION
         AND STATUS_DATE_TIME = LSSTATUSHISTORYDATE
         AND USER_ID = ASUSERID
         AND STATUS = LNSTATUSHISTORYSTATUS;

      IF LNCOUNT = 0
      THEN

         INSERT INTO USERS_APPROVED
                     ( PART_NO,
                       REVISION,
                       STATUS_DATE_TIME,
                       USER_ID,
                       STATUS,
                       APPROVED_DATE,
                       PASS_FAIL,
                       ES_SEQ_NO )
              VALUES ( LSSTATUSHISTORYPARTNO,
                       LNSTATUSHISTORYREVISION,
                       LSSTATUSHISTORYDATE,
                       ASUSERID,
                       LNSTATUSHISTORYSTATUS,
                       LDDAYTIME,
                       'P',
                       ANESSEQNO );

      ELSE
         UPDATE USERS_APPROVED
            SET APPROVED_DATE = LDDAYTIME,
                PASS_FAIL = 'P',
         
                
                ES_SEQ_NO = ANESSEQNO
         WHERE PART_NO = LSSTATUSHISTORYPARTNO
            AND REVISION = LNSTATUSHISTORYREVISION
            AND STATUS_DATE_TIME = LSSTATUSHISTORYDATE
            AND USER_ID = ASUSERID
            AND STATUS = LNSTATUSHISTORYSTATUS;
         
      END IF;



      
      
      
      
      LBSKIPALLCYCLES := FALSE;

      




      FOR LQWORKFLOWLISTREC IN LQWORKFLOWLIST
      LOOP
         IF NOT LBSKIPALLCYCLES
         THEN
            LNGROUPID := LQWORKFLOWLISTREC.USER_GROUP_ID;
            LSALLTOAPPROVE := LQWORKFLOWLISTREC.ALL_TO_APPROVE;
            LNNUMBERVOTED := 0;
            LNNUMBEREXIST := 0;
            LBSKIPACYCLE := FALSE;

            FOR LQUSERGROUPLISTREC IN LQUSERGROUPLIST
            LOOP
               LSGENUSERID := LQUSERGROUPLISTREC.USER_ID;

               IF     ASUSERID = LSGENUSERID
                  AND LSALLTOAPPROVE = 'N'
               THEN
                  LBSKIPACYCLE := TRUE;
               ELSE
                  LNNUMBEREXIST :=   LNNUMBEREXIST
                                   + 1;

                  SELECT COUNT( * )
                    INTO LNCOUNT
                    FROM USERS_APPROVED
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND USER_ID = LSGENUSERID;

                  LNNUMBERVOTED :=   LNNUMBERVOTED
                                   + LNCOUNT;

                  IF LSALLTOAPPROVE = 'N'
                  THEN
                     SELECT COUNT( * )
                       INTO LNCOUNT1
                       FROM USERS_APPROVED
                      WHERE PART_NO = ASPARTNO
                        AND REVISION = ANREVISION
                        AND USER_ID = LSGENUSERID
                        AND PASS_FAIL = 'P';

                     IF LNCOUNT1 > 0
                     THEN
                        LBSKIPACYCLE := TRUE;
                     END IF;
                  ELSIF LSALLTOAPPROVE = 'Y'
                  THEN
                     SELECT COUNT( * )
                       INTO LNCOUNT1
                       FROM USERS_APPROVED
                      WHERE PART_NO = ASPARTNO
                        AND REVISION = ANREVISION
                        AND USER_ID = LSGENUSERID
                        AND PASS_FAIL <> 'P';

                     IF LNCOUNT1 > 0
                     THEN
                        LBSKIPALLCYCLES := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;

            
            
            
            
            IF     NOT LBSKIPACYCLE
               AND NOT LBSKIPALLCYCLES
            THEN
               IF    (      (     LNNUMBEREXIST = LNNUMBERVOTED
                              AND LSALLTOAPPROVE = 'N' )
                       AND LNNUMBEREXIST > 0 )
                  OR ( LNNUMBEREXIST > LNNUMBERVOTED )
               THEN
                  LBSKIPALLCYCLES := TRUE;
               END IF;
            END IF;
         END IF;
      END LOOP;

      
      IF    NOT LBSKIPALLCYCLES
         OR (     LNREMAINSAPPROVAL = 0
              AND LNAPPROVALNUMBER > 0 )
      THEN
         LSOPERATION := 'insert';
         LSTABLE := 'approval_history';

         
         
         INSERT INTO APPROVAL_HISTORY
                     ( PART_NO,
                       REVISION,
                       STATUS_DATE_TIME,
                       USER_ID,
                       STATUS,
                       APPROVED_DATE,
                       PASS_FAIL,
                       FORENAME,
                       LAST_NAME,
                       ES_SEQ_NO )
            SELECT PART_NO,
                   REVISION,
                   STATUS_DATE_TIME,
                   US.USER_ID,
                   STATUS,
                   APPROVED_DATE,
                   PASS_FAIL,
                   FORENAME,
                   LAST_NAME,
                   USAP.ES_SEQ_NO
              FROM USERS_APPROVED USAP,
                   APPLICATION_USER US
             WHERE USAP.USER_ID = US.USER_ID
               AND PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND STATUS = ANSTATUS;

         
         LSOPERATION := 'delete';
         LSTABLE := 'users_approved';

         DELETE FROM USERS_APPROVED
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND STATUS = ANSTATUS;

         
         
         LNSUBMITCOUNT := 0;
         LSSTATUSTYPE := IAPICONSTANT.STATUSTYPE_SUBMIT;

         




         SELECT COUNT( * )
           INTO LNCOUNT
           FROM STATUS A,
                WORK_FLOW B
          WHERE A.STATUS = B.NEXT_STATUS
            AND B.STATUS = ANSTATUS
            AND B.WORK_FLOW_ID = ANWORKFLOWID
            AND A.STATUS_TYPE = LSSTATUSTYPE;

         IF LNCOUNT > 0
         THEN
            SELECT A.STATUS
              INTO LNNEWSTATUS
              FROM STATUS A,
                   WORK_FLOW B
             WHERE A.STATUS = B.NEXT_STATUS
               AND B.STATUS = ANSTATUS
               AND B.WORK_FLOW_ID = ANWORKFLOWID
               AND A.STATUS_TYPE = LSSTATUSTYPE;

            
            LNRETVAL := STATUSCHANGE( ANSTATUS,
                                      ANREVISION,
                                      ASPARTNO,
                                      LNNEWSTATUS,
                                      ASUSERID,
                                      ANESSEQNO,
                                      LQERRORS );

            COMMIT;
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

            LSOPERATION := 'update';
            LSTABLE := 'specification_header';

            UPDATE SPECIFICATION_HEADER
               SET STATUS = LNNEWSTATUS,
                   STATUS_CHANGE_DATE = SYSDATE
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            LSOPERATION := 'update';
            LSTABLE := 'part';

            UPDATE PART
               SET CHANGED_DATE = SYSDATE
             WHERE PART_NO = ASPARTNO;
         END IF;

         IF LNCOUNT = 0
         THEN   
            LSSTATUSTYPE := IAPICONSTANT.STATUSTYPE_APPROVED;

            SELECT COUNT( * )
              INTO LNAPPROVEDCOUNT
              FROM STATUS A,
                   WORK_FLOW B
             WHERE A.STATUS = B.NEXT_STATUS
               AND B.STATUS = ANSTATUS
               AND B.WORK_FLOW_ID = ANWORKFLOWID
               AND A.STATUS_TYPE = LSSTATUSTYPE;

            IF LNAPPROVEDCOUNT = 0
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_PARTSTATUSTNOTFOUND,
                                                          ASPARTNO,
                                                          ANREVISION,
                                                          IAPICONSTANT.STATUSTYPE_APPROVED );
            ELSIF LNAPPROVEDCOUNT > 1
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_PARTSTATUSTOOMANY,
                                                          ASPARTNO,
                                                          ANREVISION,
                                                          IAPICONSTANT.STATUSTYPE_APPROVED );
            ELSE
               SELECT A.STATUS
                 INTO LNNEWSTATUS
                 FROM STATUS A,
                      WORK_FLOW B
                WHERE A.STATUS = B.NEXT_STATUS
                  AND B.STATUS = ANSTATUS
                  AND B.WORK_FLOW_ID = ANWORKFLOWID
                  AND A.STATUS_TYPE = LSSTATUSTYPE;

               LSOPERATION := 'update';
               LSTABLE := 'specification_header';

               UPDATE SPECIFICATION_HEADER
                  SET STATUS = LNNEWSTATUS,
                      STATUS_CHANGE_DATE = SYSDATE
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION;

               LSOPERATION := 'update';
               LSTABLE := 'part';

               UPDATE PART
                  SET CHANGED_DATE = SYSDATE
                WHERE PART_NO = ASPARTNO;
               
               GBAPPROVEDPF := 1;
            END IF;
         END IF;

         
         LSOPERATION := 'insert';
         LSTABLE := 'status_history';

         INSERT INTO STATUS_HISTORY
                     ( PART_NO,
                       REVISION,
                       STATUS,
                       STATUS_DATE_TIME,
                       USER_ID,
                       SORT_SEQ,
                       REASON_ID,
                       FORENAME,
                       LAST_NAME,
                       ES_SEQ_NO )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       LNNEWSTATUS,
                       LDDAYTIME,
                       ASUSERID,
                       STATUS_HISTORY_SEQ.NEXTVAL,
                       
                       NULL, 
                       
                       
                       LSFORENAME,
                       LSLASTNAME,
                       ANESSEQNO );

         IF LSEMAILENABLED = '1'
         THEN
            
            BEGIN
               SELECT MAX( H.REASON_ID )
                 INTO LNREASONID
                 FROM STATUS_HISTORY H,
                      STATUS S
                 
                 WHERE STATUS_TYPE = IAPICONSTANT.STATUSTYPE_SUBMIT 
                 
                 
                  AND H.STATUS = S.STATUS
                  AND PART_NO = ASPARTNO
                  AND REVISION = ANREVISION;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  LNREASONID := -1;
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;

            
            LSOPERATION := 'insert';
            LSTABLE := 'itemail';
            LNRETVAL := IAPIEMAIL.REGISTEREMAIL( ASPARTNO,
                                                 ANREVISION,
                                                 LNNEWSTATUS,
                                                 LDDAYTIME,
                                                 'S',
                                                 NULL,
                                                 NULL,
                                                 LNREASONID,
                                                 NULL,
                                                 LQERRORS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END IF;
         END IF;
      END IF;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN INTEGRITY_VIOLATION
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_PARTINTEGRITYVIOLATION,
                                                    LSOPERATION,
                                                    LSTABLE );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END APPROVEPASS;





   FUNCTION GETNEXTAUTOSTATUS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE,
      ANNEXTAUTOSTATUS           OUT      IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
      LNNEXTAUTOSTATUS              IAPITYPE.STATUSID_TYPE;
      LNWORKFLOWID                  IAPITYPE.WORKFLOWID_TYPE;
      LBANYAPPROVALGROUPS           BOOLEAN := FALSE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNextAutoStatus';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUSERCOUNT                   IAPITYPE.NUMVAL_TYPE := 0;

      CURSOR C_USER_ID(
         ANUSERGROUPID              IN       IAPITYPE.USERGROUPID_TYPE )
      IS
         SELECT USER_ID
           FROM USER_GROUP_LIST
          WHERE USER_GROUP_ID = ANUSERGROUPID;

      CURSOR C_USERGROUPS(
         ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE,
         ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE )
      IS
         SELECT USER_GROUP_ID,
                ALL_TO_APPROVE
           FROM WORK_FLOW_LIST
          WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID
            AND STATUS = ANNEXTSTATUS
            AND ALL_TO_APPROVE <> 'Z';
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT STATUS_TYPE
        INTO LSSTATUSTYPE
        FROM STATUS
       WHERE STATUS = ANNEXTSTATUS;

      IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_SUBMIT
      THEN

         SELECT WORKFLOW_GROUP_ID
           INTO LNWORKFLOWGROUPID
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;


         SELECT WORK_FLOW_ID
           INTO LNWORKFLOWID
           FROM WORKFLOW_GROUP
          WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID;


         BEGIN
            SELECT NEXT_STATUS
              INTO LNNEXTAUTOSTATUS
              FROM WORK_FLOW,
                   STATUS
             WHERE WORK_FLOW_ID = LNWORKFLOWID
               AND WORK_FLOW.STATUS = ANNEXTSTATUS
               AND STATUS.STATUS = WORK_FLOW.NEXT_STATUS
               AND STATUS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               ANNEXTAUTOSTATUS := 0;
               RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         END;

         FOR REC_USERGROUPS IN C_USERGROUPS( LNWORKFLOWGROUPID,
                                             ANNEXTSTATUS )
         LOOP
            LBANYAPPROVALGROUPS := TRUE;













            IF REC_USERGROUPS.USER_GROUP_ID > 0
            THEN
               FOR C_USER_IDREC IN C_USER_ID( REC_USERGROUPS.USER_GROUP_ID )
               LOOP

                  IF     C_USER_IDREC.USER_ID = USER
                     AND REC_USERGROUPS.ALL_TO_APPROVE = 'N'
                  THEN
                     ANNEXTAUTOSTATUS := LNNEXTAUTOSTATUS;
                     RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
                  END IF;

                  LNUSERCOUNT := C_USER_ID%ROWCOUNT;
               END LOOP;

               
               
               IF (     LNUSERCOUNT = 1
                    AND REC_USERGROUPS.ALL_TO_APPROVE = 'Y' )
               THEN
                  ANNEXTAUTOSTATUS := LNNEXTAUTOSTATUS;
                  RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
               END IF;
               
               IF (REC_USERGROUPS.ALL_TO_APPROVE = 'S')
               THEN
                    SELECT COUNT (*)
                      INTO LNUSERCOUNT
                    FROM APPROVER_SELECTED
                    WHERE PART_NO = ASPARTNO
                      AND REVISION = ANREVISION;

                    IF (LNUSERCOUNT = 0)
                    THEN
                        ANNEXTAUTOSTATUS := LNNEXTAUTOSTATUS;
                        RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
                    END IF;
               END IF;
               
            ELSE
               ANNEXTAUTOSTATUS := LNNEXTAUTOSTATUS;
               RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
            END IF;
         END LOOP;

         
         IF LBANYAPPROVALGROUPS = FALSE
         THEN
            ANNEXTAUTOSTATUS := LNNEXTAUTOSTATUS;
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         END IF;
      END IF;

      ANNEXTAUTOSTATUS := 0;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNEXTAUTOSTATUS;


   FUNCTION APPROVE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASAPPROVE                  IN       IAPITYPE.STRINGVAL_TYPE,
      
      
      ASREASON                   IN       IAPITYPE.BUFFER_TYPE,
      
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANESSEQNO                  IN       IAPITYPE.NUMVAL_TYPE DEFAULT NULL,
      
      
      AQERRORS                   OUT      IAPITYPE.REF_TYPE,
      ABCHECKPRECONDITIONS       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1)
      

      RETURN IAPITYPE.ERRORNUM_TYPE
   IS















      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 0;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETVAL1                     IAPITYPE.ERRORNUM_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
      LNWORKFLOWID                  IAPITYPE.WORKFLOWID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Approve';
      LSSTATUSSORTDESC              IAPITYPE.SHORTDESCRIPTION_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LRSTATUSCHANGE                IAPITYPE.STATUSCHANGEREC_TYPE;
   BEGIN
   


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LRSTATUSCHANGE.STATUSID := ANSTATUS;
      LRSTATUSCHANGE.REVISION := ANREVISION;
      LRSTATUSCHANGE.PARTNO := ASPARTNO;
      LRSTATUSCHANGE.NEXTSTATUSID := NULL;
      LRSTATUSCHANGE.USERID := ASUSERID;
      LRSTATUSCHANGE.ES_SEQ_NO := ANESSEQNO;
      GTSTATUSCHANGE( 0 ) := LRSTATUSCHANGE;






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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;


 
 
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF (ABCHECKPRECONDITIONS = 1)
      THEN
      
          LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                         LSMETHOD,
                                                         'PRE',
                                                         GTERRORS );

          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
          THEN
             IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
             THEN
                
                LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

                IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                    



                    

                   
                   LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                          AQERRORS );
                   RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
                
                ELSE
                     IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOERRORINLIST )
                     THEN




                       
                       LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                              AQERRORS );
                       RETURN( IAPICONSTANTDBERROR.DBERR_NOERRORINLIST );
                     END IF;
                
                END IF;
             ELSE
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                      LSMETHOD,
                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
                RETURN( LNRETVAL );
             END IF;
          END IF;
        
        END IF;
        



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
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

      
      IF ( ANSTATUS IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Status' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStatus',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      ELSE
         BEGIN   
            SELECT SORT_DESC   
              INTO LSSTATUSSORTDESC
              FROM STATUS
             WHERE STATUS = ANSTATUS
               AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_SUBMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_SPECSTATUSINVALID );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStatus',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );
         END;
      END IF;

      
      LNRETVAL1 := EXISTIDSTATUS( ASPARTNO,
                                  ANREVISION,
                                  ANSTATUS,
                                  LSSTATUSSORTDESC,
                                  LNWORKFLOWGROUPID );

      IF ( LNRETVAL1 <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         LNRETVAL1,
                                                         ASPARTNO,
                                                         ANREVISION,
                                                         LSSTATUSSORTDESC );
         RETURN( LNRETVAL1 );   
      END IF;

      
      IF ( ASAPPROVE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Approve' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asApprove',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF     UPPER( ASAPPROVE ) <> 'F'
         AND UPPER( ASAPPROVE ) <> 'P'
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_FLAGAPPROVENOTEQUALPF,
                                                         'Approve' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asApprove',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      BEGIN
         SELECT WORK_FLOW_ID
           INTO LNWORKFLOWID
           FROM WORKFLOW_GROUP
          WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_WORKFLOWGROUPNOTFOUND,
                                                            LNWORKFLOWGROUPID );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'lnWorkFlowGroupId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         WHEN OTHERS
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_WORKFLOWGROUPINVALID,
                                                            LNWORKFLOWGROUPID );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'lnWorkFlowGroupId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
      END;

      
      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM WORK_FLOW
       WHERE WORK_FLOW_ID = LNWORKFLOWID
         AND STATUS = ANSTATUS;

      IF LNCOUNT = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_WORKFLOWIDNOTFOUND,
                                                         LNWORKFLOWID,
                                                         ANSTATUS );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'lnWorkFlowId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LSUSERID := NVL( ASUSERID,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );

      BEGIN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM USER_GROUP_LIST UGL,
                WORK_FLOW_LIST WFL
          WHERE UGL.USER_GROUP_ID = WFL.USER_GROUP_ID
            AND WFL.WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
            AND WFL.STATUS = ANSTATUS
            AND WFL.ALL_TO_APPROVE <> 'Z';

         IF LNCOUNT > 0
         THEN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM USER_GROUP_LIST UGL,
                   WORK_FLOW_LIST WFL
             WHERE UGL.USER_ID = LSUSERID
               AND UGL.USER_GROUP_ID = WFL.USER_GROUP_ID
               AND WFL.WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
               AND WFL.STATUS = ANSTATUS
               AND WFL.ALL_TO_APPROVE <> 'Z';

            IF LNCOUNT = 0
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_USERNOTFOUNDINUSERGROUP,
                                                               LSUSERID );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'lsUserId',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );
            END IF;
         END IF;
      END;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      GBAPPROVEDPF := 0;
      IF ASAPPROVE = 'F'
      THEN
         LNRETVAL := APPROVEFAIL( ASPARTNO,
                                  ANREVISION,
                                  ANSTATUS,
                                  ASREASON,
                                  LSUSERID,
                                  ANESSEQNO,
                                  LNWORKFLOWID );
      ELSE
         LNRETVAL := APPROVEPASS( ASPARTNO,
                                  ANREVISION,
                                  ANSTATUS,
                                  ASREASON,
                                  LSUSERID,
                                  ANESSEQNO,
                                  LNWORKFLOWID,
                                  LNWORKFLOWGROUPID );

      END IF;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTNOTAPPROVED,
                                                     IAPIGENERAL.GETLASTERRORTEXT( ),
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      
      
      
      IF (GBAPPROVEDPF = 1)
      THEN
      

 
 
          IAPIGENERAL.LOGINFO( GSSOURCE,
                               LSMETHOD,
                               'Call CUSTOM Pre-Action',
                               IAPICONSTANT.INFOLEVEL_3 );
          LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                         'StatusChange',
                                                         'POST',
                                                         GTERRORS );

          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
          THEN
             IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
             THEN
                
                LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

                IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                   
                   LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                          AQERRORS );
                   RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
                
                
                ELSE
                     IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOERRORINLIST )
                     THEN
                       
                       LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                              AQERRORS );
                       RETURN( IAPICONSTANTDBERROR.DBERR_NOERRORINLIST );
                     END IF;
                
                
                END IF;
             ELSE
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                      LSMETHOD,
                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
                RETURN( LNRETVAL );
             END IF;
          END IF;

      
      END IF;
      

      
      
      
      
      
      
      
      
      
      
      
      

      
      GBAPPROVEDPF := 0;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         GBAPPROVEDPF := 0;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END APPROVE;


   FUNCTION CHECKSTATUSCHANGESIGNATURE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANSTATUSFROM               IN       IAPITYPE.STATUSID_TYPE DEFAULT NULL,
      ANSTATUSTO                 IN       IAPITYPE.STATUSID_TYPE DEFAULT NULL,
      ANMOP                      IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANSIGNATUREREQUIRED        OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckStatusChangeSignature';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSTATUSTO                    IAPITYPE.STATUSID_TYPE;
      LNNEXTSTATUS                  IAPITYPE.STATUSID_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE;
      LQNEXTSTATUSLIST              IAPITYPE.REF_TYPE;

      TYPE STATUSREC_TYPE IS RECORD(
         STATUSID                      IAPITYPE.STATUSID_TYPE,
         STATUSTYPE                    IAPITYPE.STATUSTYPE_TYPE,
         DESCRIPTION                   IAPITYPE.DESCRIPTION_TYPE,
         PROMPTFORREASON               IAPITYPE.MANDATORY_TYPE,
         REASONMANDATORY               IAPITYPE.MANDATORY_TYPE,
         ES                            IAPITYPE.MANDATORY_TYPE,
         COLOR                         IAPITYPE.NUMVAL_TYPE
      );

      TYPE STATUSTAB_TYPE IS TABLE OF STATUSREC_TYPE
         INDEX BY BINARY_INTEGER;

      LRSTATUS                      STATUSREC_TYPE;
      LTSTATUS                      STATUSTAB_TYPE;

      CURSOR LQNEXTSTATUS
      IS
         SELECT IT.PART_NO PARTNO,
                IT.REVISION REVISION
           FROM ITSHQ IT,
                SPECIFICATION_HEADER SH
          WHERE IT.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
            AND IT.PART_NO = SH.PART_NO
            AND IT.REVISION = SH.REVISION;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ANSIGNATUREREQUIRED := 0;

      IF ANMOP = 1
      THEN
         FOR LRNEXTSTATUS IN LQNEXTSTATUS
         LOOP
            LNRETVAL := GETNEXTSTATUSLIST( LRNEXTSTATUS.PARTNO,
                                           LRNEXTSTATUS.REVISION,
                                           LQNEXTSTATUSLIST );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               
               FETCH LQNEXTSTATUSLIST
               BULK COLLECT INTO LTSTATUS;

               
               IF ( LTSTATUS.COUNT > 0 )
               THEN
                  FOR LNINDEX IN LTSTATUS.FIRST .. LTSTATUS.LAST
                  LOOP
                     LRSTATUS := LTSTATUS( LNINDEX );

                     SELECT TO_NUMBER( ES )
                       INTO ANSIGNATUREREQUIRED
                       FROM STATUS
                      WHERE STATUS = LRSTATUS.STATUSID;

                     EXIT WHEN ANSIGNATUREREQUIRED = 1;
                  END LOOP;
               END IF;
            ELSE
               RETURN IAPIGENERAL.GETLASTERRORTEXT( );
            END IF;

            EXIT WHEN ANSIGNATUREREQUIRED = 1;
         END LOOP;
      ELSE
         SELECT TO_NUMBER( ES )
           INTO ANSIGNATUREREQUIRED
           FROM STATUS
          WHERE STATUS = ANSTATUSTO;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKSTATUSCHANGESIGNATURE;


   FUNCTION VALIDATESTATUSCHANGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSFROM               IN       IAPITYPE.STATUSID_TYPE,
      ANSTATUSTO                 IN       IAPITYPE.STATUSID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS














      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateStatusChange';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPISPECIFICATIONVALIDATION.GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      LNRETVAL := IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESWARNING( ANSTATUSFROM,
                                                                      ANREVISION,
                                                                      ASPARTNO,
                                                                      ANSTATUSTO,
                                                                      AQERRORS );

      IF     LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         AND LNRETVAL <> IAPICONSTANTDBERROR.DBERR_ERRORLIST
      THEN
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'ExecuteValRulesWarning',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 IAPISPECIFICATIONVALIDATION.GTERRORS );
      END IF;

      LNRETVAL := IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESERROR( ANSTATUSFROM,
                                                                    ANREVISION,
                                                                    ASPARTNO,
                                                                    ANSTATUSTO );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'ExecuteValRulesError',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 IAPISPECIFICATIONVALIDATION.GTERRORS );
      END IF;

      
      IF ( IAPISPECIFICATIONVALIDATION.GTERRORS.COUNT > 0 )
      THEN
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( IAPISPECIFICATIONVALIDATION.GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATESTATUSCHANGE;




  FUNCTION CHECKALLPRECONDITIONS(
    AQERRORS                   OUT      IAPITYPE.REF_TYPE )
    RETURN IAPITYPE.ERRORNUM_TYPE
  IS



    LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
    LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckAllPreconditions';
    LQERRORS                      IAPITYPE.REF_TYPE;
    LRSTATUSCHANGE                IAPITYPE.STATUSCHANGEREC_TYPE;
        
        
        
    LNINFO                        IAPITYPE.NUMVAL_TYPE := 0;


    CURSOR LQSPECSINMOP
    IS
        SELECT Q.PART_NO, Q.REVISION, Q.STATUS_TO, SH.STATUS
        FROM ITSHQ Q
        INNER JOIN  SPECIFICATION_HEADER SH ON
            (SH.PART_NO = Q.PART_NO
             AND SH.REVISION = Q.REVISION)
        WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

    BEGIN
        
        
        
        IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

        
        
        
        
        
        IF ( AQERRORS%ISOPEN )
        THEN
         CLOSE AQERRORS;
        END IF;

        GTERRORS.DELETE;
        LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );


        IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
        THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
        END IF;

        FOR LQSPECREC IN LQSPECSINMOP
        LOOP
            LRSTATUSCHANGE.STATUSID := LQSPECREC.STATUS;
            LRSTATUSCHANGE.REVISION := LQSPECREC.REVISION;
            LRSTATUSCHANGE.PARTNO := LQSPECREC.PART_NO;
            LRSTATUSCHANGE.NEXTSTATUSID := LQSPECREC.STATUS_TO;
            LRSTATUSCHANGE.USERID := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
            
            LRSTATUSCHANGE.ES_SEQ_NO := NULL;
            GTSTATUSCHANGE( 0 ) := LRSTATUSCHANGE;

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            

            
            
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Call CUSTOM Pre-Action for: ' || LQSPECREC.PART_NO || ' [' || LQSPECREC.REVISION || ']',
                                 IAPICONSTANT.INFOLEVEL_3 );

            LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                           'StatusChange',
                                                           'PRE',
                                                            GTERRORS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
                IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
                THEN
                    
                    LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

                    IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                    THEN
                        LNINFO := 2;
                    ELSE
                         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOERRORINLIST )
                         THEN
                            
                            IF (LNINFO = 0)
                            THEN
                                LNINFO := 1;
                            END IF;
                         END IF;
                    END IF;
                ELSE
                    IAPIGENERAL.LOGERROR( GSSOURCE,
                                          LSMETHOD,
                                          IAPIGENERAL.GETLASTERRORTEXT( ) );
                    RETURN( LNRETVAL );
                END IF;
            END IF;

        END LOOP;

        IF (LNINFO = 1)
        THEN




            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
           RETURN( IAPICONSTANTDBERROR.DBERR_NOERRORINLIST );
        ELSE
            IF (LNINFO = 2)
            THEN




                
                LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                       AQERRORS );
                RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
        END IF;

        RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   END;





   FUNCTION CHECKPRECONDITIONS(
      ANCURRENTSTATUS            IN       IAPITYPE.STATUSID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANESSEQNO                  IN       IAPITYPE.NUMVAL_TYPE DEFAULT NULL,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













                   


                   


      LNCOUNT                       NUMBER;

      LRSTATUSCHANGE                IAPITYPE.STATUSCHANGEREC_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckPreconditions';
      LQERRORS                      IAPITYPE.REF_TYPE;

   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LRSTATUSCHANGE.STATUSID := ANCURRENTSTATUS;
      LRSTATUSCHANGE.REVISION := ANREVISION;
      LRSTATUSCHANGE.PARTNO := ASPARTNO;
      LRSTATUSCHANGE.NEXTSTATUSID := ANNEXTSTATUS;
      LRSTATUSCHANGE.USERID := ASUSERID;
      LRSTATUSCHANGE.ES_SEQ_NO := ANESSEQNO;
      GTSTATUSCHANGE( 0 ) := LRSTATUSCHANGE;






      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      































      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );


      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     'StatusChange',
                                                     'PRE',
                                                     GTERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            
            LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
                



                

               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            
            ELSE
                 IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOERRORINLIST )
                 THEN




                   
                   LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                          AQERRORS );
                   RETURN( IAPICONSTANTDBERROR.DBERR_NOERRORINLIST );
                 END IF;
            
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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
   END CHECKPRECONDITIONS;



   FUNCTION STATUSCHANGE(
      ANCURRENTSTATUS            IN       IAPITYPE.STATUSID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANESSEQNO                  IN       IAPITYPE.NUMVAL_TYPE DEFAULT NULL,
      
      
      AQERRORS                   OUT      IAPITYPE.REF_TYPE,
      ABCHECKPRECONDITIONS       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1)
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















                   


                   


      LNPEG                         IAPITYPE.ID_TYPE;
      LNCOUNT                       NUMBER;
      LSREASON                      IAPITYPE.BUFFER_TYPE := NULL;
      LDDAYTIME                     IAPITYPE.DATE_TYPE;
      LNUSERCOUNT                   NUMBER := 0;
      LNAPPROVEDCOUNT               NUMBER := 0;
      LSUSEREXIST                   IAPITYPE.STRINGVAL_TYPE( 1 ) := 'N';
      LSGROUPEXIST                  IAPITYPE.STRINGVAL_TYPE( 1 ) := 'N';
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSWORKFLOWEXIST               IAPITYPE.STRINGVAL_TYPE( 1 ) := 'N';
      LSEMAILENABLED                IAPITYPE.STRINGVAL_TYPE( 1 ) := '0';
      LNWORKFLOWID                  IAPITYPE.WORKFLOWID_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
      LSSTATUSTYPENOW               IAPITYPE.STATUSTYPE_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LNNEWSTATUS                   IAPITYPE.STATUSID_TYPE;
      LNREASONID                    IAPITYPE.ID_TYPE;
      LNHISTORICSS                  IAPITYPE.STATUSID_TYPE;
      LSTEXT                        IAPITYPE.BUFFER_TYPE;
      LSEXPORTERP                   IAPITYPE.STRING_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StatusChange';
      LQERRORS                      IAPITYPE.REF_TYPE;
      LRSTATUSCHANGE                IAPITYPE.STATUSCHANGEREC_TYPE;
      LNNEXTAUTOSTATUS              IAPITYPE.STATUSID_TYPE;

      CURSOR C_STATUS(
         ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE )
      IS
         SELECT *
           FROM STATUS
          WHERE STATUS = ANSTATUS;

      CURSOR C_USER_GROUP
      IS
         SELECT USER_GROUP_ID
           FROM WORK_FLOW_LIST
          WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
            AND STATUS = ANNEXTSTATUS
            AND ALL_TO_APPROVE <> 'Z';

      CURSOR C_USER_ID
      IS
         SELECT USER_ID
           FROM USER_GROUP_LIST
          WHERE USER_GROUP_ID = LNUSERGROUPID;

      CURSOR C_PREV_CUR(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT PART_NO,
                REVISION,
                STATUS,
                WORKFLOW_GROUP_ID
           FROM SPECIFICATION_HEADER
          WHERE STATUS IN( SELECT STATUS
                            FROM STATUS
                           WHERE STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
                             AND PHASE_IN_STATUS = 'N' )
            AND PART_NO = ASPARTNO;
      
      
      
      CURSOR CUR_ING_DETAIL_MANDATORY
      IS
      SELECT  ASPARTNO,
                ANREVISION,
                A.SECTION_ID,
                A.SUB_SECTION_ID,
                A.INGREDIENT,
                A.SEQ_NO,
                B.INGDETAIL_TYPE,
                B.INGDETAIL_ASSOCIATION,
                B.INGDETAIL_CHARACTERISTIC,
                B.STATUS
         FROM SPECIFICATION_ING A, ITINGDETAILCONFIG_CHARASSOC B
         WHERE A.PART_NO = ASPARTNO
            AND A.REVISION = ANREVISION
            AND A.INGREDIENT = B.INGREDIENT
            AND B.STATUS = 0
            AND (A.SECTION_ID, A.SUB_SECTION_ID) IN
              (SELECT C.SECTION_ID, C.SUB_SECTION_ID
                FROM SPECIFICATION_SECTION C
                WHERE C.PART_NO = ASPARTNO
                  AND C.REVISION = ANREVISION
                  AND C.TYPE = 9) ;
  
  BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LRSTATUSCHANGE.STATUSID := ANCURRENTSTATUS;
      LRSTATUSCHANGE.REVISION := ANREVISION;
      LRSTATUSCHANGE.PARTNO := ASPARTNO;
      LRSTATUSCHANGE.NEXTSTATUSID := ANNEXTSTATUS;
      LRSTATUSCHANGE.USERID := ASUSERID;
      LRSTATUSCHANGE.ES_SEQ_NO := ANESSEQNO;
      GTSTATUSCHANGE( 0 ) := LRSTATUSCHANGE;






      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      LNRETVAL := IAPISPECIFICATIONACCESS.CROSSGETLOCK( ASPARTNO,
                                                        ANREVISION,
                                                        LSUSERID );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      IF (    LSUSERID IS NULL
           OR LSUSERID = '' )
      THEN
         NULL;
      ELSE
         
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECALREADYLOCKED,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     LSUSERID ) );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );


      
      IF (ABCHECKPRECONDITIONS = 1)
      THEN
      
          LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                         LSMETHOD,
                                                         'PRE',
                                                         GTERRORS );

          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
          THEN
             IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
             THEN
                
                LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

                IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                    



                    

                   
                   LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                          AQERRORS );
                   RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
                
                ELSE
                     IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOERRORINLIST )
                     THEN




                       
                       LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                              AQERRORS );
                       RETURN( IAPICONSTANTDBERROR.DBERR_NOERRORINLIST );
                     END IF;
                
                END IF;
             ELSE
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                      LSMETHOD,
                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
                RETURN( LNRETVAL );
             END IF;
          END IF;
        
        END IF;
        


      LSUSERID := NVL( ASUSERID,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      LDDAYTIME := SYSDATE;


      SELECT FORENAME,
             LAST_NAME
        INTO LSFORENAME,
             LSLASTNAME
        FROM APPLICATION_USER
       WHERE USER_ID = LSUSERID;


      IF ASPARTNO IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Part No',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      ELSIF ANREVISION IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Revision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      ELSIF ANCURRENTSTATUS IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Current Status',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      ELSIF ANNEXTSTATUS IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Next Status',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      SELECT PARAMETER_DATA
        INTO LSEMAILENABLED
        FROM INTERSPC_CFG
       WHERE PARAMETER = 'email';



      BEGIN
         SELECT STATUS,
                WORKFLOW_GROUP_ID
           INTO LNSTATUS,
                LNWORKFLOWGROUPID
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTFOUND );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'SPECIFICATION_HEADER',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
      END;



      IF LNSTATUS != ANCURRENTSTATUS
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_SPECSTATUSCURRENT );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Status',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      FOR R_STATUS IN C_STATUS( ANCURRENTSTATUS )
      LOOP
         LSSTATUSTYPENOW := R_STATUS.STATUS_TYPE;
      END LOOP;


      BEGIN
         SELECT WORK_FLOW_ID
           INTO LNWORKFLOWID
           FROM WORKFLOW_GROUP
          WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_WORKFLOWGROUPNOTEXIST );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'WORKFLOW_GROUP',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
      END;



      BEGIN
         SELECT 'Y'
           INTO LSWORKFLOWEXIST
           FROM WORK_FLOW
          WHERE WORK_FLOW_ID = LNWORKFLOWID
            AND STATUS = ANCURRENTSTATUS
            AND NEXT_STATUS = ANNEXTSTATUS;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_WORKFLOWIDNOTFOUND );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'WORK_FLOW',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
      END;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;
      END IF;

      SELECT MAX( EXPORT_ERP )
        INTO LSEXPORTERP
        FROM WORK_FLOW
       WHERE NEXT_STATUS = ANNEXTSTATUS
         AND STATUS = ANCURRENTSTATUS;




      FOR R_STATUS IN C_STATUS( ANNEXTSTATUS )
      LOOP
         LSSTATUSTYPE := R_STATUS.STATUS_TYPE;


         IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_HISTORIC
         THEN
            DELETE FROM ITSHVALD
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            
            


































            

         END IF;

         IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_SUBMIT
         THEN
            SP_SET_SPEC_CURRENT( ASPARTNO,
                                 ANREVISION );
         END IF;

         IF     R_STATUS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
            AND R_STATUS.PHASE_IN_STATUS = 'N'
         THEN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM BOM_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT_EFFECTIVE_DATE = TRUNC( SYSDATE );

            
            
            IF LNCOUNT = 0
            THEN
               
               UPDATE BOM_HEADER BH
                  SET PLANT_EFFECTIVE_DATE = TRUNC( SYSDATE )
                WHERE BH.PART_NO = ASPARTNO
                  AND BH.REVISION = ANREVISION
                  AND ( BH.PART_NO, BH.REVISION, BH.PLANT_EFFECTIVE_DATE ) =
                         ( SELECT PART_NO,
                                  REVISION,
                                  PLANT_EFFECTIVE_DATE
                            FROM SPECIFICATION_HEADER SH
                           WHERE BH.PART_NO = SH.PART_NO
                             AND BH.REVISION = SH.REVISION
                             
                             
                             
                             
                             AND TRUNC( BH.PLANT_EFFECTIVE_DATE ) = TRUNC( SH.PLANNED_EFFECTIVE_DATE ) )
                             AND NOT EXISTS(
                              SELECT *
                              FROM BOM_HEADER BH2
                              WHERE  BH2.PART_NO = BH.PART_NO
                                AND BH2.REVISION = (BH.REVISION - 1)
                                AND BH2.PLANT = BH.PLANT
                                AND BH2.PLANT_EFFECTIVE_DATE > TRUNC( SYSDATE ));
                             

               
               
               
               
               
               UPDATE SPECIFICATION_HEADER
                  SET ISSUED_DATE = SYSDATE,
                      STATUS_CHANGE_DATE = SYSDATE,
                      PLANNED_EFFECTIVE_DATE = TRUNC( SYSDATE )
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION;
               
               

               
               
               LNRETVAL := IAPISPECIFICATION.SETPEDINSYNC(ASPARTNO, ANREVISION);

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT() );
                     RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
               END IF;
               

            END IF;

            UPDATE SPECIFICATION_HEADER
               SET ISSUED_DATE = SYSDATE,
                   STATUS_CHANGE_DATE = SYSDATE,
                   PLANNED_EFFECTIVE_DATE = TRUNC( SYSDATE )
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;


            IF LSEXPORTERP = '1'
            THEN
               UPDATE PART
                  SET CHANGED_DATE = SYSDATE
                WHERE PART_NO = ASPARTNO;
            END IF;




            BEGIN
               SELECT PED_GROUP_ID
                 INTO LNPEG
                 FROM SPEC_PED_GROUP
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION;

               DELETE      SPEC_PED_GROUP
                     WHERE PART_NO = ASPARTNO
                       AND REVISION = ANREVISION;

               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM SPEC_PED_GROUP
                WHERE PED_GROUP_ID = LNPEG;

               IF LNCOUNT = 0
               THEN
                  DELETE      SPEC_PED_GROUP
                        WHERE PED_GROUP_ID = LNPEG;

                  DELETE      PED_GROUP
                        WHERE PED_GROUP_ID = LNPEG;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;




            FOR L_PREV_CUR IN C_PREV_CUR( ASPARTNO )
            LOOP



               SELECT MIN( A.NEXT_STATUS )
                 INTO LNHISTORICSS
                 FROM WORK_FLOW A,
                      WORKFLOW_GROUP B,
                      STATUS C
                WHERE A.WORK_FLOW_ID = B.WORK_FLOW_ID
                  AND C.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC
                  AND A.NEXT_STATUS = C.STATUS
                  AND B.WORKFLOW_GROUP_ID = L_PREV_CUR.WORKFLOW_GROUP_ID
                  AND A.STATUS = L_PREV_CUR.STATUS;

               IF LNHISTORICSS IS NULL
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
                  RETURN LNRETVAL;
               ELSE



                  UPDATE SPECIFICATION_HEADER
                     SET STATUS = LNHISTORICSS,
                         
                         
                         OBSOLESCENCE_DATE = DECODE(OBSOLESCENCE_DATE, NULL, SYSDATE, OBSOLESCENCE_DATE),
                         
                         STATUS_CHANGE_DATE = SYSDATE
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = L_PREV_CUR.REVISION;


                  INSERT INTO STATUS_HISTORY
                              ( PART_NO,
                                REVISION,
                                STATUS,
                                STATUS_DATE_TIME,
                                USER_ID,
                                SORT_SEQ,
                                REASON_ID,
                                FORENAME,
                                LAST_NAME,
                                ES_SEQ_NO )
                       VALUES ( ASPARTNO,
                                L_PREV_CUR.REVISION,
                                LNHISTORICSS,
                                LDDAYTIME,
                                LSUSERID,
                                STATUS_HISTORY_SEQ.NEXTVAL,
                                NULL,
                                LSFORENAME,
                                LSLASTNAME,
                                ANESSEQNO );

                  IF LSEMAILENABLED = '1'
                  THEN
                     BEGIN
                        SELECT MAX( ID )
                          INTO LNREASONID
                          FROM REASON
                         WHERE PART_NO = ASPARTNO
                           AND REVISION = ANREVISION
                           AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           LNREASONID := 0;
                     END;

                     LNRETVAL :=
                        IAPIEMAIL.REGISTEREMAIL( ASPARTNO,
                                                 L_PREV_CUR.REVISION,
                                                 LNHISTORICSS,
                                                 LDDAYTIME,
                                                 'S',
                                                 NULL,
                                                 NULL,
                                                 LNREASONID,
                                                 NULL,
                                                 LQERRORS );

                     IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                     THEN
                        IAPIGENERAL.LOGERROR( GSSOURCE,
                                              LSMETHOD,
                                              IAPIGENERAL.GETLASTERRORTEXT( ) );
                        RETURN( LNRETVAL );
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         ELSIF(    R_STATUS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE
                OR R_STATUS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC )
         THEN
            UPDATE SPECIFICATION_HEADER
               
               
               SET OBSOLESCENCE_DATE = DECODE(OBSOLESCENCE_DATE, NULL, SYSDATE, OBSOLESCENCE_DATE),
               
                   STATUS_CHANGE_DATE = SYSDATE
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;



            UPDATE PART
               SET CHANGED_DATE = SYSDATE
             WHERE PART_NO = ASPARTNO;
         END IF;
      END LOOP;



      UPDATE SPECIFICATION_HEADER
         SET STATUS = ANNEXTSTATUS,
             STATUS_CHANGE_DATE = SYSDATE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;


      IF LSEXPORTERP = '1'
      THEN
         UPDATE PART
            SET CHANGED_DATE = SYSDATE
          WHERE PART_NO = ASPARTNO;
      END IF;

      IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
      THEN
         
         
         
         
         
         



































         IF LSSTATUSTYPENOW = IAPICONSTANT.STATUSTYPE_SUBMIT
         THEN
            
             SELECT MAX( ID )
               INTO LNREASONID
               FROM REASON
              WHERE PART_NO = ASPARTNO
                AND REVISION = ANREVISION
                AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE;

             SELECT TEXT
               INTO LSTEXT
               FROM REASON
              WHERE PART_NO = ASPARTNO
                AND REVISION = ANREVISION
                AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE
                AND ID = LNREASONID;

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
                           ASPARTNO,
                           ANREVISION,
                           IAPICONSTANT.STATUSTYPE_REASONFORISSUE,
                           LSTEXT );



         ELSE
             
             IF LSSTATUSTYPENOW = IAPICONSTANT.STATUSTYPE_REJECT
             THEN
                
                 SELECT MAX( ID )
                   INTO LNREASONID
                   FROM REASON
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE;

                 SELECT TEXT
                   INTO LSTEXT
                   FROM REASON
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE
                    AND ID = LNREASONID;

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
                               ASPARTNO,
                               ANREVISION,
                               IAPICONSTANT.STATUSTYPE_REASONFORISSUE,
                               LSTEXT );


            ELSE
            IF LSSTATUSTYPENOW = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
            THEN
                 
                 BEGIN
                 
                     SELECT TEXT
                       INTO LSTEXT
                       FROM REASON
                      WHERE ID = (SELECT MAX( ID )
                                   FROM REASON
                                  WHERE PART_NO = ASPARTNO
                                    AND REVISION = ANREVISION
                                    AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG);
                
                EXCEPTION WHEN NO_DATA_FOUND THEN
                  LSTEXT := 'Reason for status change';
                END;
                

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
                               ASPARTNO,
                               ANREVISION,
                               IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG,
                               LSTEXT );
            END IF;
            
            END IF;
          END IF;

         
         




         DELETE FROM SPECIFICATION_CD
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION;


         UPDATE SPECIFICATION_ING
            SET INGREDIENT_REV = 0
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         UPDATE ITSHBN
            SET BASE_NAME_REV = 0
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      END IF;

      LNREASONID := NULL;


      
      
      
      
      
      IF LSSTATUSTYPE IN (IAPICONSTANT.STATUSTYPE_SUBMIT
                        , IAPICONSTANT.STATUSTYPE_CURRENT
                        , IAPICONSTANT.STATUSTYPE_HISTORIC
                        , IAPICONSTANT.STATUSTYPE_OBSOLETE)
      
      THEN
         BEGIN
            SELECT MAX( ID )
              INTO LNREASONID
              FROM REASON
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNREASONID := 0;
         END;
      ELSE
         BEGIN
            SELECT MAX( ID )
              INTO LNREASONID
              FROM REASON
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNREASONID := 0;
         END;
      END IF;


      INSERT INTO STATUS_HISTORY
                  ( PART_NO,
                    REVISION,
                    STATUS,
                    STATUS_DATE_TIME,
                    USER_ID,
                    SORT_SEQ,
                    REASON_ID,
                    FORENAME,
                    LAST_NAME,
                    ES_SEQ_NO )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANNEXTSTATUS,
                    LDDAYTIME,
                    LSUSERID,
                    STATUS_HISTORY_SEQ.NEXTVAL,
                    LNREASONID,
                    LSFORENAME,
                    LSLASTNAME,
                    ANESSEQNO );

      IF LSEMAILENABLED = '1'
      THEN
         LNRETVAL := IAPIEMAIL.REGISTEREMAIL( ASPARTNO,
                                              ANREVISION,
                                              ANNEXTSTATUS,
                                              LDDAYTIME,
                                              'S',
                                              NULL,
                                              NULL,
                                              LNREASONID,
                                              NULL,
                                              LQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
      
      IF ( LSSTATUSTYPENOW NOT IN
              ( IAPICONSTANT.STATUSTYPE_SUBMIT,
                IAPICONSTANT.STATUSTYPE_APPROVED,
                IAPICONSTANT.STATUSTYPE_CURRENT,
                IAPICONSTANT.STATUSTYPE_HISTORIC,
                IAPICONSTANT.STATUSTYPE_OBSOLETE ) )
      THEN
         DELETE FROM APPROVAL_HISTORY
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION;
      END IF;

      
      
      
      
      IF     LSSTATUSTYPENOW = IAPICONSTANT.STATUSTYPE_SUBMIT
         AND LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
      THEN
         DELETE FROM USERS_APPROVED
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND STATUS = ANCURRENTSTATUS;

      END IF;








      IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_SUBMIT
      THEN
         FOR C_USER_GROUPREC IN C_USER_GROUP
         LOOP
            LSGROUPEXIST := 'Y';
            LNUSERGROUPID := C_USER_GROUPREC.USER_GROUP_ID;

            FOR C_USER_IDREC IN C_USER_ID
            LOOP
               IF LSUSERID = C_USER_IDREC.USER_ID
               THEN
                  LSUSEREXIST := 'Y';
               END IF;

               LNUSERCOUNT :=   LNUSERCOUNT
                              + 1;
            END LOOP;
         END LOOP;

         IF    LSGROUPEXIST = 'N'
            OR LSUSEREXIST = 'Y'
            OR LNUSERCOUNT = 0
         THEN
            
            
            LNRETVAL := GETNEXTAUTOSTATUS( ASPARTNO,
                                           ANREVISION,
                                           ANNEXTSTATUS,
                                           LNNEXTAUTOSTATUS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Automatic status change for: '
                                 || ASPARTNO
                                 || '['
                                 || ANREVISION
                                 || '] from <'
                                 || ANCURRENTSTATUS
                                 || '> to <'
                                 || ANNEXTSTATUS
                                 || '> automatic to <'
                                 || LNNEXTAUTOSTATUS
                                 || '>',
                                 IAPICONSTANT.INFOLEVEL_3 );

            IF ( LNNEXTAUTOSTATUS <> 0 )
            THEN
               
               
               
               LNRETVAL := IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESWARNING( ANNEXTSTATUS,
                                                                               ANREVISION,
                                                                               ASPARTNO,
                                                                               LNNEXTAUTOSTATUS,
                                                                               LQERRORS );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;

               
               LNRETVAL := IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESERROR( ANNEXTSTATUS,
                                                                             ANREVISION,
                                                                             ASPARTNO,
                                                                             LNNEXTAUTOSTATUS );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;
            END IF;

            LNRETVAL := APPROVE( ASPARTNO,
                                 ANREVISION,
                                 ANNEXTSTATUS,
                                 'P',
                                 LSREASON,
                                 ASUSERID,
                                 NULL,
                                 
                                 
                                 LQERRORS,
                                 ABCHECKPRECONDITIONS);
                                 
         END IF;
      END IF;

      
      IF   LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_SUBMIT
      THEN
         
         FOR REC_ING_DETAIL_MANDATORY IN CUR_ING_DETAIL_MANDATORY
         LOOP
              BEGIN
               INSERT INTO ITSPECINGDETAIL
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          INGREDIENT_SEQ_NO,
                          INGDETAIL_CHARACTERISTIC,
                          INGDETAIL_TYPE,
                          MANDATORY)
                  VALUES ( ASPARTNO,
                          ANREVISION,
                          REC_ING_DETAIL_MANDATORY.SECTION_ID,
                          REC_ING_DETAIL_MANDATORY.SUB_SECTION_ID,
                          REC_ING_DETAIL_MANDATORY.INGREDIENT,
                          REC_ING_DETAIL_MANDATORY.SEQ_NO,
                          REC_ING_DETAIL_MANDATORY.INGDETAIL_CHARACTERISTIC,
                          REC_ING_DETAIL_MANDATORY.INGDETAIL_TYPE,
                          'Y'
                          );
              EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                   UPDATE ITSPECINGDETAIL SET MANDATORY = 'Y'
                    WHERE PART_NO = ASPARTNO
                      AND REVISION = ANREVISION
                      AND SECTION_ID = REC_ING_DETAIL_MANDATORY.SECTION_ID
                      AND SUB_SECTION_ID = REC_ING_DETAIL_MANDATORY.SUB_SECTION_ID
                      AND INGREDIENT = REC_ING_DETAIL_MANDATORY.INGREDIENT
                      AND INGREDIENT_SEQ_NO = REC_ING_DETAIL_MANDATORY.SEQ_NO
                      AND INGDETAIL_CHARACTERISTIC = REC_ING_DETAIL_MANDATORY.INGDETAIL_CHARACTERISTIC
                      AND INGDETAIL_TYPE = REC_ING_DETAIL_MANDATORY.INGDETAIL_TYPE;
              END;
         END LOOP;
       END IF;
      
      
       IF LSSTATUSTYPENOW = IAPICONSTANT.STATUSTYPE_REJECT AND LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT THEN 
          DELETE ITSPECINGDETAIL
           WHERE PART_NO = ASPARTNO
             AND REVISION = ANREVISION
             AND MANDATORY = 'Y';

          DELETE ITSPECINGDETAIL
           WHERE (PART_NO,
                  REVISION,
                  INGREDIENT,
                  INGDETAIL_TYPE,
                  INGDETAIL_CHARACTERISTIC) IN
                       (SELECT A.PART_NO,
                               A.REVISION,
                               A.INGREDIENT,
                               A.INGDETAIL_TYPE,
                               A.INGDETAIL_CHARACTERISTIC
                          FROM ITSPECINGDETAIL A, ITINGDETAILCONFIG_CHARASSOC B
                         WHERE     A.PART_NO = ASPARTNO
                               AND A.REVISION = ANREVISION
                               AND A.INGREDIENT = B.INGREDIENT
                               AND A.INGDETAIL_TYPE = B.INGDETAIL_TYPE
                               AND A.INGDETAIL_CHARACTERISTIC =
                                     B.INGDETAIL_CHARACTERISTIC
                         );

       END IF;
         



      LNRETVAL := IAPIPLANTPART.SETPLANTACCESS( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            
            LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               



               
               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            
            ELSE
                 IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_NOERRORINLIST )
                 THEN




                   
                   LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                          AQERRORS );
                   RETURN( IAPICONSTANTDBERROR.DBERR_NOERRORINLIST );
                 END IF;
            
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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
   END STATUSCHANGE;


   FUNCTION GETNEXTSTATUSLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQNEXTSTATUSLIST           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNextStatusList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSWORKFLOWGROUP               IAPITYPE.SHORTDESCRIPTION_TYPE;
      LNWORKFLOWID                  IAPITYPE.ID_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN




      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT WFG.SORT_DESC,
             WFG.WORK_FLOW_ID,
             SH.STATUS
        INTO LSWORKFLOWGROUP,
             LNWORKFLOWID,
             LNSTATUS
        FROM WORKFLOW_GROUP WFG,
             SPECIFICATION_HEADER SH
       WHERE WFG.WORKFLOW_GROUP_ID = SH.WORKFLOW_GROUP_ID
         AND SH.PART_NO = ASPARTNO
         AND SH.REVISION = ANREVISION;

      LSSQL :=
            ' SELECT a.next_status,             '
         || '        STATUS_TYPE,               '
         || '        DESCRIPTION,               '
         || '        PROMPT_FOR_REASON,         '
         || '        REASON_MANDATORY,          '
         || '        ES,                        '
         || '        COLOR                      '
         || ' FROM WORK_FLOW a,                 '
         || '      STATUS b                     '
         || ' WHERE a.next_status = b.status    '
         || '  AND a.status = :status           '
         || '  AND a.work_flow_id = :WorkFlowId ';

      OPEN AQNEXTSTATUSLIST FOR LSSQL USING LNSTATUS,
      LNWORKFLOWID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNEXTSTATUSLIST;


   FUNCTION ADDREASONFORISSUE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASTEXT                     IN       IAPITYPE.BUFFER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReasonForIssue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREASONID                    IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

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
                    ASPARTNO,
                    ANREVISION,
                    IAPICONSTANT.STATUSTYPE_REASONFORISSUE,
                    ASTEXT );

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END ADDREASONFORISSUE;


   FUNCTION ADDREASONFORREJECTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASTEXT                     IN       IAPITYPE.BUFFER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReasonForRejection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREASONID                    IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

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
                    ASPARTNO,
                    ANREVISION,
                    IAPICONSTANT.STATUSTYPE_REASONFORREJECTION,
                    ASTEXT );

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END ADDREASONFORREJECTION;


   FUNCTION ADDREASONFORSTATUSCHANGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASTEXT                     IN       IAPITYPE.BUFFER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReasonForStatusChange';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREASONID                    IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

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
                    ASPARTNO,
                    ANREVISION,
                    IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG,
                    ASTEXT );

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END ADDREASONFORSTATUSCHANGE;


   FUNCTION SAVEREASONFORISSUE(
      ANREASONID                 IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASTEXT                     IN       IAPITYPE.TEXT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveReasonForIssue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      
      
      
   BEGIN
   


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( ASPARTNO,
                                                               ANREVISION,
                                                               LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNACCESS = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      IF ( ANREASONID IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Id' ) );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );






      
      
      UPDATE REASON
         SET TEXT = ASTEXT
       WHERE ID = ANREASONID
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE;
       

        
        
        
        
         
         
         
         
         
         
         
         
         
         
         


      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEREASONFORISSUE;


   FUNCTION SAVEREASONFORREJECTION(
      ANREASONID                 IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASTEXT                     IN       IAPITYPE.TEXT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveReasonForRejection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( ASPARTNO,
                                                               ANREVISION,
                                                               LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNACCESS = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      IF ( ANREASONID IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Id' ) );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      UPDATE REASON
         SET TEXT = ASTEXT
       WHERE ID = ANREASONID
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORREJECTION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEREASONFORREJECTION;


   FUNCTION SAVEREASONFORSTATUSCHANGE(
      ANREASONID                 IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASTEXT                     IN       IAPITYPE.TEXT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveReasonForStatusChange';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANREASONID IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Id' ) );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      UPDATE REASON
         SET TEXT = ASTEXT
       WHERE ID = ANREASONID
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEREASONFORSTATUSCHANGE;


   FUNCTION GETREASONFORSTATUSCHANGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASREASON                   IN       IAPITYPE.STATUSTYPE_TYPE,
      AQREASON                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReasonForStatusChange';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'select r.id                                      '
         || ',       r.part_no                                 '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ',       r.revision                                '
         || ',       r.status_type                             '
         || IAPICONSTANTCOLUMN.STATUSTYPECOL
         || ',       r.text                                    '
         || ',       sh.status                                 '
         || ',       s.sort_desc                               '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ',       sh.status_date_time                       '
         || IAPICONSTANTCOLUMN.STATUSDATETIMECOL
         || ',       sh.user_id                                '
         || IAPICONSTANTCOLUMN.USERIDCOL
         || ',       f_check_editable(r.part_no, r.revision,r.status_type,s1.status_type)                                '
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || '   FROM reason r,                                 '
         || '        status_history sh,                        '
         || '        specification_header sph,                        '
         || '        status s,                                  '
         || '        status s1                                  '
         || '  WHERE r.part_no = :part_no                      '
         || '    AND r.revision = :revision                    '
         || '    AND (     (      ( :reason != ''ALL'' )       '
         || '                AND ( r.status_type = :reason ) ) '
         || '          OR ( :reason = ''ALL'' ) )              '
         || '    AND r.part_no = sh.part_no                    '
         || '    AND r.revision = sh.revision                  '
         || '    AND r.ID = sh.reason_id                       '
         || '    AND s.status = sh.status                      '
         || '    AND r.part_no = sph.part_no                    '
         || '    AND r.revision = sph.revision                  '
         || '    AND s1.status = sph.status                      '
         || 'UNION                                             '
         || 'SELECT   r.ID                                     '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ',        r.part_no                                '
         || ',        r.revision                               '
         || ',        r.status_type                            '
         || IAPICONSTANTCOLUMN.STATUSTYPECOL
         || ',        r.text                                   '
         || ',        0 AS status                              '
         || ',        ''''                          '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ',        SYSDATE               '
         || IAPICONSTANTCOLUMN.STATUSDATETIMECOL
         || ',        ''''  '
         || IAPICONSTANTCOLUMN.USERIDCOL
         || ',       0                                         '
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || '   FROM reason r                                  '
         || '  WHERE r.part_no = :part_no                      '
         || '    AND r.revision = :revision                    '
         || '    AND (     (      ( :reason != ''ALL'' )       '
         || '                AND ( r.status_type = :reason ) ) '
         || '          OR ( :reason = ''ALL'' ) )              '
         || '    AND ( r.ID NOT IN( SELECT sh.reason_id        '
         || '                        FROM status_history sh    '
         || '                       WHERE sh.part_no = :part_no '
         || '                         AND sh.revision = :revision '
         || '                         AND sh.reason_id IS NOT NULL ) ) '
         || 'ORDER BY ID DESC ';

      OPEN AQREASON FOR LSSQL
      USING ASPARTNO,
            ANREVISION,
            ASREASON,
            ASREASON,
            ASREASON,
            ASPARTNO,
            ANREVISION,
            ASREASON,
            ASREASON,
            ASREASON,
            ASPARTNO,
            ANREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREASONFORSTATUSCHANGE;


   FUNCTION GETSTATUSHISTORY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQSTATUSHISTORY            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStatusHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            ' SELECT status_history.part_no,                                  '
         || '        status_history.revision,                                 '
         || '        status_history.status_date_time,                         '
         || '        status_history.forename,                                 '
         || '        status_history.last_name,                                '
         || '        status_history.user_id,                                  '
         || '        status_history.reason_id,                                '
         || '        status_history.status,                                   '
         || '        reason.status_type,                                      '
         || '        status.sort_desc,                                         '
         
         || '        reason.text                                              '
         || '   FROM status,                                                  '
         || '        status_history,                                          '
         || '        reason                                                   '
         || '  WHERE (      ( status_history.part_no = :partno )              '
         || '          AND ( status_history.revision = :revision )            '
         || '          AND ( status_history.status = status.status )          '
         || '          AND ( status_history.part_no = reason.part_no (+))     '
         || '          AND ( status_history.revision = reason.revision(+))    '
         || '          AND ( status_history.reason_id = reason.ID(+) ) )      '
         || ' ORDER BY status_history.sort_seq DESC                   ';


      OPEN AQSTATUSHISTORY FOR LSSQL USING ASPARTNO,
      ANREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSTATUSHISTORY;


   FUNCTION GETLASTREASONFORISSUE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQREASONFORISSUE           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLastReasonForIssue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT reason.ID,                        '
         || '       reason.part_no,                   '
         || '       reason.revision,                  '
         || '       reason.status_type,               '
         || '       reason.text                       '
         || '  FROM reason                            '
         || ' WHERE ID = f_get_reason_id( :partno,    '
         || '                             :revision,  '
         || '                             ''RI'' )    ';

      OPEN AQREASONFORISSUE FOR LSSQL USING ASPARTNO,
      ANREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLASTREASONFORISSUE;


   PROCEDURE AUTOSTATUS
   IS















      LNNEXTSTATUS                  IAPITYPE.STATUSID_TYPE;
      LNNEXTSTATUSTYPE              IAPITYPE.STATUSTYPE_TYPE;
      LSPHASEINSTATUS               IAPITYPE.PHASEINSTATUS_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBID                       NUMBER := 0;
      LDNEWPED                      IAPITYPE.DATE_TYPE;
      LSPREVIOUSPARTNO              IAPITYPE.PARTNO_TYPE;
      LDPREVIOUSPED                 IAPITYPE.DATE_TYPE;
      LNPREVIOUSPIT                 IAPITYPE.PHASEINTOLERANCE_TYPE;
      LNCOUNTER                     PLS_INTEGER := 0;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNHISTORICSTATUS              IAPITYPE.STATUSID_TYPE;
      LDDAYTIME                     DATE;
      LNREASONID                    IAPITYPE.ID_TYPE;
      LNSYNCCOUNT                   PLS_INTEGER;
      LNCOUNT                       PLS_INTEGER;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AutoStatus';
      
      LRSTATUSCHANGE                IAPITYPE.STATUSCHANGEREC_TYPE;
      LRERROR                       ERRORRECORD_TYPE;
      LNERRORINLIST               BOOLEAN := FALSE;
      

      
      CURSOR SC1
      IS
         SELECT A.PART_NO,
                A.REVISION,
                A.STATUS,
                A.WORKFLOW_GROUP_ID,
                A.PLANNED_EFFECTIVE_DATE,
                B.STATUS_TYPE
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND B.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED
            AND A.PHASE_IN_TOLERANCE = 0
            AND A.PLANNED_EFFECTIVE_DATE <= SYSDATE
            AND A.OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER;

      
      CURSOR SC2
      IS
         SELECT A.PART_NO,
                A.REVISION,
                A.STATUS,
                A.WORKFLOW_GROUP_ID,
                A.PLANNED_EFFECTIVE_DATE,
                B.STATUS_TYPE
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND B.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED
            AND SYSDATE >=(   A.PLANNED_EFFECTIVE_DATE
                            - A.PHASE_IN_TOLERANCE )
            AND A.PHASE_IN_TOLERANCE <> 0
            AND A.OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER;

      
      CURSOR SC3
      IS
         SELECT A.PART_NO,
                A.REVISION,
                A.STATUS,
                A.WORKFLOW_GROUP_ID,
                B.STATUS_TYPE
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.STATUS = B.STATUS
            AND B.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
            AND SYSDATE >=(   A.PLANNED_EFFECTIVE_DATE
                            + A.PHASE_IN_TOLERANCE )
            AND B.PHASE_IN_STATUS = 'Y'
            AND A.OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER;

      
      
      
      
      
      
      CURSOR C_PED
      IS
         SELECT   A.PART_NO,
                  A.REVISION,
                  A.PHASE_IN_TOLERANCE,
                  A.WORKFLOW_GROUP_ID
             FROM SPECIFICATION_HEADER A,
                  STATUS B
            WHERE B.STATUS_TYPE IN
                     ( IAPICONSTANT.STATUSTYPE_DEVELOPMENT,
                       IAPICONSTANT.STATUSTYPE_SUBMIT,
                       IAPICONSTANT.STATUSTYPE_REJECT,
                       IAPICONSTANT.STATUSTYPE_APPROVED )
              AND PLANNED_EFFECTIVE_DATE <= SYSDATE
              AND A.STATUS = B.STATUS
              AND A.OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER
         UNION
         SELECT DISTINCT A.PART_NO,
                         A.REVISION,
                         A.PHASE_IN_TOLERANCE,
                         A.WORKFLOW_GROUP_ID
                    FROM SPECIFICATION_HEADER A,
                         STATUS B,
                         WORKFLOW_GROUP WFG,
                         WORK_FLOW WF
                   WHERE B.STATUS_TYPE =( IAPICONSTANT.STATUSTYPE_APPROVED )
                     AND PLANNED_EFFECTIVE_DATE <= SYSDATE
                     AND A.STATUS = B.STATUS
                     AND A.STATUS = WF.STATUS
                     AND A.WORKFLOW_GROUP_ID = WFG.WORKFLOW_GROUP_ID
                     AND WFG.WORK_FLOW_ID = WF.WORK_FLOW_ID
                     AND WF.NEXT_STATUS NOT IN( SELECT STATUS
                                                 FROM STATUS
                                                WHERE STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT )
                     AND A.OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER
                ORDER BY 1,
                         2 ASC;

      CURSOR C_PED_GROUP
      IS
         SELECT A.PED_GROUP_ID
           FROM PED_GROUP A
          WHERE A.PED <= SYSDATE;

      CURSOR C_REVISION(
         ASPARTNO                            IAPITYPE.PARTNO_TYPE,
         ANREVISION                          IAPITYPE.REVISION_TYPE,
         ADDATE                              IAPITYPE.DATE_TYPE )
      IS
         SELECT REVISION
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION > ANREVISION
            AND PLANNED_EFFECTIVE_DATE <= ADDATE
            AND OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER;

      FUNCTION CHECKPED(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
         RETURN VARCHAR
      IS
         
         
         LNBOMPEDCOUNT                 PLS_INTEGER;
         LNCOUNT                       PLS_INTEGER;
         LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckPed';
      BEGIN



         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Body of FUNCTION',
                              IAPICONSTANT.INFOLEVEL_3 );

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         IF LNCOUNT = 0
         THEN
            RETURN 1;
         ELSE
            SELECT COUNT( * )
              INTO LNBOMPEDCOUNT
              FROM BOM_HEADER BH,
                   SPECIFICATION_SECTION SHC,
                   SPECIFICATION_HEADER SH
             WHERE BH.PART_NO = SH.PART_NO
               AND BH.REVISION = SH.REVISION
               AND SH.PART_NO = SHC.PART_NO
               AND SH.REVISION = SHC.REVISION
               AND SH.PART_NO = ASPARTNO
               AND SH.REVISION = ANREVISION
               AND SHC.TYPE = IAPICONSTANT.SECTIONTYPE_BOM
               AND BH.PLANT_EFFECTIVE_DATE <= SH.PLANNED_EFFECTIVE_DATE;

            RETURN LNBOMPEDCOUNT;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN 0;
      END CHECKPED;

      
      FUNCTION MESSAGE_TYPE(
        ANMESSAGETYPE   IN INTEGER)
      RETURN VARCHAR
      IS
      BEGIN

        IF  ANMESSAGETYPE IS NULL
        THEN
            RETURN '';

        ELSIF ANMESSAGETYPE =  IAPICONSTANT.ERRORMESSAGE_ERROR
        THEN
            RETURN '[Error] ';

        ELSIF ANMESSAGETYPE =  IAPICONSTANT.ERRORMESSAGE_WARNING
        THEN
            RETURN '[Warning] ';

        ELSIF ANMESSAGETYPE =  IAPICONSTANT.ERRORMESSAGE_INFO
        THEN
            RETURN '[Info] ';

        ELSE
            RETURN '';
        END IF;

      END;
      
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETCONNECTION( USER,
                                                'AUTO STATUS JOB' );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
         END IF;
      END IF;

      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
                                           LNJOBID );

      FOR SC1REC IN SC1
      LOOP
                


         
         BEGIN
            
            LNRETVAL :=
               IAPISPECIFICATION.GETNEXTSTATUSTYPE( SC1REC.PART_NO,
                                                    SC1REC.REVISION,
                                                    SC1REC.WORKFLOW_GROUP_ID,
                                                    IAPICONSTANT.STATUSTYPE_CURRENT,
                                                    SC1REC.STATUS,
                                                    'N',
                                                    LNNEXTSTATUS,
                                                    LNNEXTSTATUSTYPE,
                                                    LSPHASEINSTATUS );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            ELSE
               LNRETVAL := IAPISPECIFICATION.CURRENTPHASEINTOCURRENT( SC1REC.PART_NO,
                                                                      LNNEXTSTATUSTYPE,
                                                                      LSPHASEINSTATUS,
                                                                      LNNEXTSTATUS,
                                                                      NULL );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
               ELSE
                  LNRETVAL := IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESERROR( SC1REC.STATUS,
                                                                                SC1REC.REVISION,
                                                                                SC1REC.PART_NO,
                                                                                LNNEXTSTATUS );

                  IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT( ) );
																					 
                     
                           LNERRORINLIST:=TRUE;
                           IF (LNERRORINLIST) 
                             THEN
                                   ROLLBACK;
                                   LNERRORINLIST:=FALSE;
                           END IF;
                     
                  ELSE
                     
                     
                       GTERRORSAUTOSTATUS.DELETE;

                      IAPIGENERAL.LOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       'Call CUSTOM Pre-Action',
                                                       IAPICONSTANT.INFOLEVEL_3 );

                      LRSTATUSCHANGE.PARTNO := SC1REC.PART_NO;
                      LRSTATUSCHANGE.REVISION := SC1REC.REVISION;
                      LRSTATUSCHANGE.STATUSID := SC1REC.STATUS;
                      LRSTATUSCHANGE.NEXTSTATUSID := LNNEXTSTATUS;
                      LRSTATUSCHANGE.USERID := USER;
                      LRSTATUSCHANGE.ES_SEQ_NO := NULL;
                      GTSTATUSCHANGE( 0 ) := LRSTATUSCHANGE;

                      LNERRORINLIST := FALSE;

                      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                                 LSMETHOD,
                                                                 'PRE',
                                                                 GTERRORSAUTOSTATUS );

                     IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                     THEN
                          IAPIGENERAL.LOGERROR( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                           THEN
                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                    LSMETHOD,
                                                   'Pre Custom function returned warning(s)/error(s) for PartNo: ' || SC1REC.PART_NO || ' - revision: ' || SC1REC.REVISION );

                             FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                             LOOP
                                LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );

                                IF (LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR)
                                THEN
                                    LNERRORINLIST := TRUE;
                                END IF;

                             END LOOP;

                           END IF;
                     END IF;

                    IF (LNERRORINLIST) 
                    THEN
                            LNERRORINLIST := FALSE;

                           ROLLBACK;
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                LSMETHOD,
                                               'Pre Custom function returned error(s) for PartNo: ' || SC1REC.PART_NO || ' - revision: ' || SC1REC.REVISION || '. This item will not be processed.');

                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                           THEN
                                 FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                 LOOP
                                    LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                    IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );
                                 END LOOP;
                           END IF;
                        ELSE
                       
                     LNRETVAL :=
                               IAPISPECIFICATION.UPDATESPECIFICATIONHEADER( LNNEXTSTATUS,
                                                                            SC1REC.PART_NO,
                                                                            SC1REC.REVISION,
                                                                            SC1REC.STATUS_TYPE,
                                                                            NULL );

                         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
                     THEN
                        IAPIGENERAL.LOGERROR( GSSOURCE,
                                              LSMETHOD,
                                              IAPIGENERAL.GETLASTERRORTEXT( ) );
                     ELSE
                             
                              LNERRORINLIST := FALSE;

                              LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                                         LSMETHOD,
                                                                         'POST',
                                                                         GTERRORSAUTOSTATUS );

                             IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                             THEN
                                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPIGENERAL.GETLASTERRORTEXT( ) );

                                   IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                                   THEN
                                      IAPIGENERAL.LOGERROR( GSSOURCE,
                                                            LSMETHOD,
                                                           'Post Custom function returned warning(s)/error(s) for PartNo: ' || SC1REC.PART_NO || ' - revision: ' || SC1REC.REVISION );

                                     FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                     LOOP
                                        LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                        IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );

                                        IF (LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR)
                                        THEN
                                            LNERRORINLIST := TRUE;
                                        END IF;
                                     END LOOP;

                                   END IF;
                             END IF;

                             IF (LNERRORINLIST) 
                             THEN
                                   ROLLBACK;
                                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                                        LSMETHOD,
                                                       'Post Custom function returned error(s) for PartNo: ' || SC1REC.PART_NO || ' - revision: ' || SC1REC.REVISION || '. This item will not be processed.');

                                   IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                                   THEN
                                         FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                         LOOP
                                            LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                            IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );
                                         END LOOP;
                                   END IF;
                             ELSE
                             
                              COMMIT;
                             
                             END IF; 
                         END IF; 
                    
                    END IF;  
                  END IF; 
               END IF; 
            END IF; 
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
         END;
      END LOOP;

      FOR SC2REC IN SC2
      LOOP
         


         IF CHECKPED( SC2REC.PART_NO,
                      SC2REC.REVISION ) > 0  
         THEN
            BEGIN
               LNRETVAL :=
                  IAPISPECIFICATION.GETNEXTSTATUSTYPE( SC2REC.PART_NO,
                                                       SC2REC.REVISION,
                                                       SC2REC.WORKFLOW_GROUP_ID,
                                                       IAPICONSTANT.STATUSTYPE_CURRENT,
                                                       SC2REC.STATUS,
                                                       'Y',
                                                       LNNEXTSTATUS,
                                                       LNNEXTSTATUSTYPE,
                                                       LSPHASEINSTATUS );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
               ELSE	 							
                  LNRETVAL := IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESERROR( SC2REC.STATUS,
                                                                                SC2REC.REVISION,
                                                                                SC2REC.PART_NO,
                                                                                LNNEXTSTATUS );
                  IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT( ) );
                     
                           LNERRORINLIST:=TRUE;
                           IF (LNERRORINLIST) 
                             THEN
                                   ROLLBACK;
																	 LNERRORINLIST:=FALSE;
                           END IF;
                     
                  ELSE
                    
                     
                       GTERRORSAUTOSTATUS.DELETE;

                      IAPIGENERAL.LOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       'Call CUSTOM Pre-Action',
                                                       IAPICONSTANT.INFOLEVEL_3 );

                      LRSTATUSCHANGE.PARTNO := SC2REC.PART_NO;
                      LRSTATUSCHANGE.REVISION := SC2REC.REVISION;
                      LRSTATUSCHANGE.STATUSID := SC2REC.STATUS;
                      LRSTATUSCHANGE.NEXTSTATUSID := LNNEXTSTATUS;
                      LRSTATUSCHANGE.USERID := USER;
                      LRSTATUSCHANGE.ES_SEQ_NO := NULL;
                      GTSTATUSCHANGE( 0 ) := LRSTATUSCHANGE;

                      LNERRORINLIST := FALSE;

                      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                                 LSMETHOD,
                                                                 'PRE',
                                                                 GTERRORSAUTOSTATUS );

                     IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                     THEN
                          IAPIGENERAL.LOGERROR( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                           THEN
                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                    LSMETHOD,
                                                   'Pre Custom function returned warning(s)/error(s) for PartNo: ' || SC2REC.PART_NO || ' - revision: ' || SC2REC.REVISION );

                             FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                             LOOP
                                LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );

                                IF (LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR)
                                THEN
                                    LNERRORINLIST := TRUE;
                                END IF;

                             END LOOP;
                           END IF;
                     END IF;

                     IF (LNERRORINLIST) 
                     THEN
                            LNERRORINLIST := FALSE;

                           ROLLBACK;
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                LSMETHOD,
                                               'Pre Custom function returned error(s) for PartNo: ' || SC2REC.PART_NO || ' - revision: ' || SC2REC.REVISION || '. This item will not be processed.');

                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                           THEN
                                 FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                 LOOP
                                    LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                    IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );
                                 END LOOP;
                           END IF;
                     ELSE
                     
                     LNRETVAL :=
                               IAPISPECIFICATION.UPDATESPECIFICATIONHEADER( LNNEXTSTATUS,
                                                                            SC2REC.PART_NO,
                                                                            SC2REC.REVISION,
                                                                            SC2REC.STATUS_TYPE,
                                                                            NULL );

                         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
                     THEN
                        IAPIGENERAL.LOGERROR( GSSOURCE,
                                              LSMETHOD,
                                              IAPIGENERAL.GETLASTERRORTEXT( ) );
                     ELSE
                              
                              LNERRORINLIST := FALSE;

                              LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                                         LSMETHOD,
                                                                         'POST',
                                                                         GTERRORSAUTOSTATUS );

                             IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                             THEN
                                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPIGENERAL.GETLASTERRORTEXT( ) );

                                   IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                                   THEN
                                      IAPIGENERAL.LOGERROR( GSSOURCE,
                                                            LSMETHOD,
                                                           'Post Custom function returned warning(s)/error(s) for PartNo: ' || SC2REC.PART_NO || ' - revision: ' || SC2REC.REVISION );

                                     FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                     LOOP
                                        LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                        IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );

                                        IF (LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR)
                                        THEN
                                            LNERRORINLIST := TRUE;
                                        END IF;

                                     END LOOP;

                                   END IF;
                              END IF;

                             IF (LNERRORINLIST) 
                             THEN
                                   ROLLBACK;
                                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                                        LSMETHOD,
                                                       'Post Custom function returned error(s) for PartNo: ' || SC2REC.PART_NO || ' - revision: ' || SC2REC.REVISION || '. This item will not be processed.');

                                   IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                                   THEN
                                         FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                         LOOP
                                            LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                            IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );
                                         END LOOP;
                                   END IF;
                             ELSE
                                
                                COMMIT;
                               
                                END IF; 
                         END IF; 
                       
                       END IF; 
                  END IF; 
               END IF; 
            EXCEPTION
               WHEN OTHERS
               THEN
                  ROLLBACK;
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
            END;
         END IF;
      END LOOP;

      FOR SC3REC IN SC3
      LOOP
         BEGIN
            LNRETVAL :=
               IAPISPECIFICATION.GETNEXTSTATUSTYPE( SC3REC.PART_NO,
                                                    SC3REC.REVISION,
                                                    SC3REC.WORKFLOW_GROUP_ID,
                                                    IAPICONSTANT.STATUSTYPE_CURRENT,
                                                    SC3REC.STATUS,
                                                    'N',
                                                    LNNEXTSTATUS,
                                                    LNNEXTSTATUSTYPE,
                                                    LSPHASEINSTATUS );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            ELSE
               LNRETVAL := IAPISPECIFICATION.CURRENTPHASEINTOCURRENT( SC3REC.PART_NO,
                                                                      LNNEXTSTATUSTYPE,
                                                                      LSPHASEINSTATUS,
                                                                      LNNEXTSTATUS,
                                                                      NULL );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
               ELSE
                  LNRETVAL := IAPISPECIFICATIONVALIDATION.EXECUTEVALRULESERROR( SC3REC.STATUS,
                                                                                SC3REC.REVISION,
                                                                                SC3REC.PART_NO,
                                                                                LNNEXTSTATUS );

                  IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT( ) );
                     
                           LNERRORINLIST:=TRUE;
                           IF (LNERRORINLIST) 
                             THEN
                                   ROLLBACK;
                                   LNERRORINLIST:=FALSE;
                           END IF;
                     
                  ELSE
                    
                     
                       GTERRORSAUTOSTATUS.DELETE;

                      IAPIGENERAL.LOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       'Call CUSTOM Pre-Action',
                                                       IAPICONSTANT.INFOLEVEL_3 );

                      LRSTATUSCHANGE.PARTNO := SC3REC.PART_NO;
                      LRSTATUSCHANGE.REVISION := SC3REC.REVISION;
                      LRSTATUSCHANGE.STATUSID := SC3REC.STATUS;
                      LRSTATUSCHANGE.NEXTSTATUSID := LNNEXTSTATUS;
                      LRSTATUSCHANGE.USERID := USER;
                      LRSTATUSCHANGE.ES_SEQ_NO := NULL;
                      GTSTATUSCHANGE( 0 ) := LRSTATUSCHANGE;

                      LNERRORINLIST := FALSE;

                      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                                 LSMETHOD,
                                                                 'PRE',
                                                                 GTERRORSAUTOSTATUS );

                     IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                     THEN
                          IAPIGENERAL.LOGERROR( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );

                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                           THEN
                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                    LSMETHOD,
                                                   'Pre Custom function returned info/warning(s)/error(s) for PartNo: ' || SC3REC.PART_NO || ' - revision: ' || SC3REC.REVISION );

                             FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                             LOOP
                                LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );

                                IF (LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR)
                                THEN
                                    LNERRORINLIST := TRUE;
                                END IF;

                             END LOOP;

                           END IF;
                     END IF;

                    IF (LNERRORINLIST) 
                    THEN
                            LNERRORINLIST := FALSE;

                           ROLLBACK;
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                LSMETHOD,
                                               'Pre Custom function returned error(s) for PartNo: ' || SC3REC.PART_NO || ' - revision: ' || SC3REC.REVISION || '. This item will not be processed.');

                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                           THEN
                                 FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                 LOOP
                                    LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                    IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );
                                 END LOOP;
                           END IF;
                     ELSE
                     
                     LNRETVAL :=
                               IAPISPECIFICATION.UPDATESPECIFICATIONHEADER( LNNEXTSTATUS,
                                                                            SC3REC.PART_NO,
                                                                            SC3REC.REVISION,
                                                                            SC3REC.STATUS_TYPE,
                                                                            NULL );

                                 IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS 
                     THEN
                        IAPIGENERAL.LOGERROR( GSSOURCE,
                                              LSMETHOD,
                                              IAPIGENERAL.GETLASTERRORTEXT( ) );
                     ELSE
                                    
                                      LNERRORINLIST := FALSE;

                                      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                                                 LSMETHOD,
                                                                                 'POST',
                                                                                 GTERRORSAUTOSTATUS );

                                     IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                                     THEN
                                          IAPIGENERAL.LOGERROR( GSSOURCE,
                                                                LSMETHOD,
                                                                IAPIGENERAL.GETLASTERRORTEXT( ) );

                                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                                           THEN
                                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                                    LSMETHOD,
                                                                   'Post Custom function returned warning(s)/error(s) for PartNo: ' || SC3REC.PART_NO || ' - revision: ' || SC3REC.REVISION );

                                             FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                             LOOP
                                                LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                                IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );

                                                IF (LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR)
                                                THEN
                                                    LNERRORINLIST := TRUE;
                                                END IF;

                                             END LOOP;

                                           END IF;
                                     END IF;

                                     IF (LNERRORINLIST) 
                                     THEN
                                           ROLLBACK;
                                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                                LSMETHOD,
                                                               'Post Custom function returned error(s) for PartNo: ' || SC3REC.PART_NO || ' - revision: ' || SC3REC.REVISION || '. This item will not be processed.');

                                           IF ( GTERRORSAUTOSTATUS.COUNT > 0 )
                                           THEN
                                                 FOR LNINDEX IN GTERRORSAUTOSTATUS.FIRST .. GTERRORSAUTOSTATUS.LAST
                                                 LOOP
                                                    LRERROR := GTERRORSAUTOSTATUS( LNINDEX );
                                                    IAPIGENERAL.LOGERROR( GSSOURCE, LSMETHOD, MESSAGE_TYPE(LRERROR.MESSAGETYPE) || LRERROR.ERRORTEXT );
                                                 END LOOP;
                                           END IF;
                                     ELSE
                                     
                                        COMMIT;
                                     
                                     END IF; 
                                 END IF; 
                     
                     END IF; 
                  END IF; 
               END IF; 
            END IF; 
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
         END;
      END LOOP;

      

      FOR L_PED IN C_PED
      LOOP
         IF LSPREVIOUSPARTNO = L_PED.PART_NO
         THEN
            LDNEWPED :=   LDPREVIOUSPED
                        + LNPREVIOUSPIT
                        + L_PED.PHASE_IN_TOLERANCE
                        + 1;
         ELSE
            LDNEWPED :=   TRUNC( SYSDATE )
                        + 1;
         END IF;

         

         LNREVISION := 0;

         FOR L_ROW IN C_REVISION( L_PED.PART_NO,
                                  L_PED.REVISION,
                                  LDNEWPED )
         LOOP
            LNREVISION := L_ROW.REVISION;
         END LOOP;

         IF LNREVISION > 0
         THEN
            
            SELECT MIN( NEXT_STATUS )
              INTO LNHISTORICSTATUS
              FROM WORK_FLOW WF,
                   WORKFLOW_GROUP WFG,
                   STATUS SS
             WHERE WFG.WORKFLOW_GROUP_ID = L_PED.WORKFLOW_GROUP_ID
               AND WFG.WORK_FLOW_ID = WF.WORK_FLOW_ID
               AND WF.NEXT_STATUS = SS.STATUS
               AND SS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC;

            IF LNHISTORICSTATUS IS NOT NULL
            THEN
               LDDAYTIME := SYSDATE;

               UPDATE SPECIFICATION_HEADER
                  SET STATUS = LNHISTORICSTATUS,
                      
                      
                      OBSOLESCENCE_DATE = DECODE(OBSOLESCENCE_DATE, NULL, SYSDATE, OBSOLESCENCE_DATE),
                      
                      STATUS_CHANGE_DATE = SYSDATE
                WHERE PART_NO = L_PED.PART_NO
                  AND REVISION = L_PED.REVISION;

               UPDATE PART
                  SET CHANGED_DATE = SYSDATE
                WHERE PART_NO = L_PED.PART_NO;

               INSERT INTO STATUS_HISTORY
                           ( PART_NO,
                             REVISION,
                             STATUS,
                             STATUS_DATE_TIME,
                             USER_ID,
                             SORT_SEQ,
                             REASON_ID,
                             FORENAME,
                             LAST_NAME )
                    VALUES ( L_PED.PART_NO,
                             L_PED.REVISION,
                             LNHISTORICSTATUS,
                             LDDAYTIME,
                             IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                             STATUS_HISTORY_SEQ.NEXTVAL,
                             NULL,
                             IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                             IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );

               BEGIN
                  SELECT MAX( ID )
                    INTO LNREASONID
                    FROM REASON
                   WHERE PART_NO = L_PED.PART_NO
                     AND REVISION = L_PED.REVISION
                     AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     LNREASONID := 0;
               END;

               LNRETVAL :=
                    IAPIEMAIL.REGISTEREMAIL( L_PED.PART_NO,
                                             L_PED.REVISION,
                                             LNHISTORICSTATUS,
                                             LDDAYTIME,
                                             'S',
                                             NULL,
                                             NULL,
                                             LNREASONID,
                                             NULL,
                                             LQERRORS );
            ELSE
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     'Tried to change status to status type HISTORIC, but could not find a valid status.' );
            END IF;
         ELSE
            UPDATE BOM_HEADER
               SET PLANT_EFFECTIVE_DATE = LDNEWPED
             WHERE PART_NO = L_PED.PART_NO
               AND REVISION = L_PED.REVISION
               AND PLANT_EFFECTIVE_DATE = ( SELECT PLANNED_EFFECTIVE_DATE
                                             FROM SPECIFICATION_HEADER
                                            WHERE PART_NO = L_PED.PART_NO
                                              AND REVISION = L_PED.REVISION );

            UPDATE SPECIFICATION_HEADER
               SET PLANNED_EFFECTIVE_DATE = LDNEWPED
             WHERE PART_NO = L_PED.PART_NO
               AND REVISION = L_PED.REVISION;

            
            SELECT COUNT( * )
              INTO LNSYNCCOUNT
              FROM BOM_HEADER
             WHERE PLANT_EFFECTIVE_DATE <> ( SELECT PLANNED_EFFECTIVE_DATE
                                              FROM SPECIFICATION_HEADER
                                             WHERE PART_NO = L_PED.PART_NO
                                               AND REVISION = L_PED.REVISION )
               AND PART_NO = L_PED.PART_NO
               AND REVISION = L_PED.REVISION;

            IF LNSYNCCOUNT = 0
            THEN
               UPDATE SPECIFICATION_HEADER
                  SET PED_IN_SYNC = 'Y'
                WHERE PART_NO = L_PED.PART_NO
                  AND REVISION = L_PED.REVISION
                  AND PED_IN_SYNC = 'N';
            END IF;
         END IF;

         COMMIT;
         LSPREVIOUSPARTNO := L_PED.PART_NO;
         LDPREVIOUSPED := LDNEWPED;
         LNPREVIOUSPIT := L_PED.PHASE_IN_TOLERANCE;
      END LOOP;

      FOR L_ROW IN C_PED_GROUP
      LOOP
         
         UPDATE PED_GROUP
            SET PED =   PED
                      + 1
          WHERE PED_GROUP_ID = L_ROW.PED_GROUP_ID;
      END LOOP;

      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END AUTOSTATUS;


   FUNCTION GETSPECIFICATIONAPPROVE(
      AQSPECIFICATIONAPPROVELIST OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSpecificationApprove';
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      LSSQL :=
            'SELECT SPECIFICATION_HEADER.WORKFLOW_GROUP_ID, '
         || '        SPECIFICATION_HEADER.PART_NO, '
         || '        SPECIFICATION_HEADER.REVISION, '
         || '        SUBSTR (f_sh_descr (0, SPECIFICATION_HEADER.PART_NO, SPECIFICATION_HEADER.REVISION), 1, '
         || '                60) DESCRIPTION, SPECIFICATION_HEADER.STATUS, SPECIFICATION_HEADER.PLANNED_EFFECTIVE_DATE, '
         || '        ''X'' cf_pass_fail, WORKFLOW_GROUP.SORT_DESC, LPAD ('''', 2000), STATUS.DESCRIPTION from_description '
         || '   FROM WORKFLOW_GROUP, '
         || '        SPECIFICATION_HEADER, '
         || '        STATUS '
         || '  WHERE (WORKFLOW_GROUP.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID) '
         || '    AND (STATUS.STATUS = SPECIFICATION_HEADER.STATUS) '
         || '    AND (    (STATUS.STATUS_TYPE = ''SUBMIT'') '
         || '         AND EXISTS ( '
         || '                SELECT ''X'' '
         || '                  FROM DUAL '
         || '                 WHERE (f_user_approve (SPECIFICATION_HEADER.PART_NO, '
         || '                                        SPECIFICATION_HEADER.REVISION, '
         || '                                        SPECIFICATION_HEADER.WORKFLOW_GROUP_ID, '
         || '                                        :iapiGeneral.SESSION.ApplicationUser.UserId '
         || '                                       ) = ''Y'' '
         || '                       )) '
         || '        ) '
         || ' ORDER BY SPECIFICATION_HEADER.PART_NO ASC ';

      OPEN AQSPECIFICATIONAPPROVELIST FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSPECIFICATIONAPPROVE;

   FUNCTION CLEARSPECIFICATIONTOAPPROVE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSWORKFLOWLIST       IN       IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ClearSpecificationToApprove';
   BEGIN
      
      DELETE      SPECIFICATION_TO_APPROVE
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND STATUS = ANSTATUSWORKFLOWLIST;

      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CLEARSPECIFICATIONTOAPPROVE;

   FUNCTION XMLAPPROVERSLISTINTOTABLE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSWORKFLOWLIST       IN       IAPITYPE.STATUSID_TYPE,
      AXAPPROVERSLISTSELECTED    IN       IAPITYPE.XMLTYPE_TYPE,
      AXPATHLISTUSER             IN       IAPITYPE.XMLSTRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE;

   FUNCTION GETAPPROVERSLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSWORKFLOWLIST       IN       IAPITYPE.STATUSID_TYPE,
      AQAPPROVERSLIST            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetApproversList';
      LNUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      END IF;

      
      
      LSSELECT :=
            'user_group_list.user_id '
         || IAPICONSTANTCOLUMN.USERIDCOL
         || ','
         || 'SUBSTR (f_us_descr (user_group_list.user_id), 1, 80) '
         || IAPICONSTANTCOLUMN.USERNAMECOL
         || ','
         || 'work_flow_list.user_group_id '
         || IAPICONSTANTCOLUMN.GROUPIDCOL
         || ','
         || 'USER_GROUP.description '
         || IAPICONSTANTCOLUMN.GROUPNAMECOL
         || ','
         || 'SUBSTR (f_us_detail (user_group_list.user_id, ''telephone''), 1, 80) '
         || IAPICONSTANTCOLUMN.TELEPHONENUMBERCOL
         || ','
         || 'work_flow_list.all_to_approve '
         || IAPICONSTANTCOLUMN.ALLTOAPPROVECOL
         || ','
         || 'work_flow_list.EDITABLE '
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || ','
         || ' ''N'' '
         || IAPICONSTANTCOLUMN.SELECTIONCOL;
      LSSQL :=
            'SELECT '
         || LSSELECT
         || '  FROM WORK_FLOW_LIST, USER_GROUP_LIST, USER_GROUP, STATUS, SPECIFICATION_HEADER'
         || ' WHERE work_flow_list.status = status.status'
         || '   AND status.status = :anStatusWorkFlowList'
         || '   AND status.status_type = ''SUBMIT'' '
         || '   AND work_flow_list.workflow_group_id = specification_header.workflow_group_id '
         || '   AND user_group_list.user_group_id = work_flow_list.user_group_id '
         || '   AND USER_GROUP.user_group_id = user_group_list.user_group_id '
         || '   AND specification_header.part_no = :asPartNo '
         || '   AND specification_header.revision = :anRevision '
         || '   AND work_flow_list.all_to_approve <>''Z'' '
         || '   AND EXISTS (SELECT wfl.EDITABLE '
         || '                 FROM work_flow_list wfl '
         || '                WHERE wfl.workflow_group_id = specification_header.workflow_group_id '
         || '                  AND wfl.EDITABLE = ''Y'' '
         || '                  AND wfl.STATUS = :anStatusWorkFlowList )'
         || ' ORDER BY  3, 2 ASC';

      OPEN AQAPPROVERSLIST FOR LSSQL USING ANSTATUSWORKFLOWLIST,
      ASPARTNO,
      ANREVISION,
      ANSTATUSWORKFLOWLIST;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETAPPROVERSLIST;

   FUNCTION SETAPPROVERSLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSWORKFLOWLIST       IN       IAPITYPE.STATUSID_TYPE,
      ACAPPROVERSLISTSELECTED    IN       IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetApproversList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXDOC                         IAPITYPE.XMLTYPE_TYPE;
   BEGIN
      LXDOC := XMLTYPE( ACAPPROVERSLISTSELECTED );
      LNRETVAL := SETAPPROVERSLIST( ASPARTNO,
                                    ANREVISION,
                                    ANSTATUSWORKFLOWLIST,
                                    LXDOC );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETAPPROVERSLIST;


   
   
   FUNCTION SETAPPROVERSLISTPB(
      ASPARTNOLIST               IN       IAPITYPE.XMLSTRING_TYPE,
      ASREVISIONLIST             IN       IAPITYPE.XMLSTRING_TYPE,
      ANSTATUSWORKFLOW           IN       IAPITYPE.STATUSID_TYPE,
      ACAPPROVERSLISTSELECTED    IN       IAPITYPE.CLOB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetApproversListPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARTNOLIST                  IAPITYPE.XMLTYPE_TYPE;
      LXREVISIONLIST                IAPITYPE.XMLTYPE_TYPE;
   BEGIN

      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LXPARTNOLIST := XMLTYPE( ASPARTNOLIST );
      LXREVISIONLIST := XMLTYPE( ASREVISIONLIST );

      LNRETVAL := SETAPPROVERSLIST( LXPARTNOLIST,
                                     LXREVISIONLIST,
                                     ANSTATUSWORKFLOW,
                                     ACAPPROVERSLISTSELECTED,
                                     AQERRORS );

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
   END SETAPPROVERSLISTPB;
  

   
   
   FUNCTION SETAPPROVERSLIST(
      AXPARTNOLIST               IN       IAPITYPE.XMLTYPE_TYPE,
      AXREVISIONLIST             IN       IAPITYPE.XMLTYPE_TYPE,
      ANSTATUSWORKFLOW           IN       IAPITYPE.STATUSID_TYPE,
      ACAPPROVERSLISTSELECTED    IN       IAPITYPE.CLOB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetApproversList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTPARTNOLIST                  IAPITYPE.PARTNOTAB_TYPE;
      LTREVISIONLIST                IAPITYPE.REVISIONTAB_TYPE;
      LNRETVALTMP                   IAPITYPE.ERRORNUM_TYPE;

   BEGIN

      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LNRETVAL := IAPIGENERAL.APPENDXMLPARTNO( AXPARTNOLIST,
                                               LTPARTNOLIST );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIGENERAL.APPENDXMLREVISION( AXREVISIONLIST,
                                               LTREVISIONLIST );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      FOR LNCOUNT IN LTPARTNOLIST.FIRST .. LTREVISIONLIST.LAST
      LOOP
         LNRETVAL := SETAPPROVERSLIST(LTPARTNOLIST(LNCOUNT),
                                      LTREVISIONLIST(LNCOUNT),
                                      ANSTATUSWORKFLOW,
                                      ACAPPROVERSLISTSELECTED);

         LNRETVALTMP := LNRETVAL;
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST('Result',
                                                 LNRETVALTMP,
                                                 GTERRORS,
                                                 IAPICONSTANT.ERRORMESSAGE_INFO);
       END LOOP;

      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETAPPROVERSLIST;
  

   FUNCTION SETAPPROVERSLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSWORKFLOWLIST       IN       IAPITYPE.STATUSID_TYPE,
      AXAPPROVERSLISTSELECTED    IN       IAPITYPE.XMLTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetApproversList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      LNRETVAL := CLEARSPECIFICATIONTOAPPROVE( ASPARTNO,
                                               ANREVISION,
                                               ANSTATUSWORKFLOWLIST );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      END IF;

      INSERT INTO SPECIFICATION_TO_APPROVE
                  ( PART_NO,
                    REVISION,
                    STATUS )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSTATUSWORKFLOWLIST );

      LNRETVAL := XMLAPPROVERSLISTINTOTABLE( ASPARTNO,
                                             ANREVISION,
                                             ANSTATUSWORKFLOWLIST,
                                             AXAPPROVERSLISTSELECTED,
                                             IAPICONSTANT.XPATHUSERAPPROVER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETAPPROVERSLIST;

   FUNCTION XMLAPPROVERSLISTINTOTABLE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUSWORKFLOWLIST       IN       IAPITYPE.STATUSID_TYPE,
      AXAPPROVERSLISTSELECTED    IN       IAPITYPE.XMLTYPE_TYPE,
      AXPATHLISTUSER             IN       IAPITYPE.XMLSTRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

















      
      
      
      
      
      
      
      

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'XmlApproversListIntoTable';

      TYPE TAPPROVERSLIST IS TABLE OF APPROVER_SELECTED%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTUSERS                       TAPPROVERSLIST;
      LNUSERS                       IAPITYPE.NUMVAL_TYPE := 0;
      LNGRPID                       IAPITYPE.NUMVAL_TYPE := 0;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTONEEDITNOSELECT        IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTSELECT                 IAPITYPE.NUMVAL_TYPE := 0;
      LNCOUNTALLSELECTEDITNOSELECT  IAPITYPE.NUMVAL_TYPE := 0;
      LNERROR                       IAPITYPE.NUMVAL_TYPE := 0;
      LQAPPROVERSSELECTEDLIST       IAPITYPE.REF_TYPE;
      
      LNWORKFLOWGROUPID             IAPITYPE.NUMVAL_TYPE := 0;
      LNCONFIGURED                  IAPITYPE.NUMVAL_TYPE := 0;
      LNSELECTED                    IAPITYPE.NUMVAL_TYPE := 0;
      
      
      LSUSERIDVAL                   APPROVER_SELECTED.USER_ID%TYPE;
      LSALLTOAPPROVEVAL             APPROVER_SELECTED.ALL_TO_APPROVE%TYPE;
      LSSELECTEDVAL                 APPROVER_SELECTED.SELECTED%TYPE;
      LSUSERGROUPIDVAL              APPROVER_SELECTED.USER_GROUP_ID%TYPE;
      
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      


      SELECT COUNT( * )
        INTO LNUSERS
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXAPPROVERSLISTSELECTED,
                                                  UPPER( AXPATHLISTUSER ) ) ) ) T ) R;

      FOR INDX IN 1 .. LNUSERS
      LOOP
         
         
































         

           LSUSERIDVAL := AXAPPROVERSLISTSELECTED.EXTRACT(UPPER( AXPATHLISTUSER )
                || '['|| INDX|| ']/' || UPPER( IAPICONSTANTCOLUMN.USERIDCOL )
                || '/text()').GETSTRINGVAL();

           LSALLTOAPPROVEVAL := AXAPPROVERSLISTSELECTED.EXTRACT(UPPER( AXPATHLISTUSER )
                || '['|| INDX|| ']/' || UPPER( IAPICONSTANTCOLUMN.ALLTOAPPROVECOL )
                || '/text()').GETSTRINGVAL();

           LSSELECTEDVAL := AXAPPROVERSLISTSELECTED.EXTRACT(UPPER( AXPATHLISTUSER )
                || '['|| INDX|| ']/' || UPPER( IAPICONSTANTCOLUMN.SELECTIONCOL )
                || '/text()').GETSTRINGVAL();

           LSUSERGROUPIDVAL := AXAPPROVERSLISTSELECTED.EXTRACT(UPPER( AXPATHLISTUSER )
                || '['|| INDX|| ']/' || UPPER( IAPICONSTANTCOLUMN.GROUPIDCOL )
                || '/text()').GETSTRINGVAL();

           SELECT  ASPARTNO PART_NO
                 , ANREVISION REVISION
                 , LSUSERIDVAL USER_ID
                 , 'N' APPROVED
                 , LSALLTOAPPROVEVAL ALL_TO_APPROVE
                 , ANSTATUSWORKFLOWLIST STATUS
                 , LSSELECTEDVAL SELECTED
                 , LSUSERGROUPIDVAL USER_GROUP_ID
           INTO LTUSERS( INDX ) FROM DUAL;
         

      END LOOP;

      

      
      
      

      





      

      
      
      
      FOR INDX IN 1 .. LTUSERS.COUNT
      LOOP
          IF LTUSERS( INDX ).SELECTED = 'Y'
          THEN
             INSERT INTO APPROVER_SELECTED
                  VALUES LTUSERS( INDX );
          END IF;
      END LOOP;
      

      

      
      SELECT COUNT( ALL_TO_APPROVE )
        INTO LNCOUNT
        FROM APPROVER_SELECTED
       WHERE ALL_TO_APPROVE = 'N'
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND STATUS = ANSTATUSWORKFLOWLIST;

      IF LNCOUNT > 0
      THEN
         
         


































         

         BEGIN
            
            

            SELECT WORKFLOW_GROUP_ID
                INTO LNWORKFLOWGROUPID
                FROM SPECIFICATION_HEADER
                WHERE PART_NO = ASPARTNO
                AND REVISION = ANREVISION;

            SELECT COUNT(USER_GROUP_ID)
                INTO LNCONFIGURED
                FROM WORK_FLOW_LIST TBL
                WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
                AND STATUS = ANSTATUSWORKFLOWLIST
                AND ALL_TO_APPROVE = 'N';

            SELECT COUNT (*)
                INTO LNSELECTED
                FROM (
                    SELECT DISTINCT USER_GROUP_ID
                    FROM APPROVER_SELECTED
                    WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND STATUS = ANSTATUSWORKFLOWLIST
                    AND ALL_TO_APPROVE = 'N'
                    AND SELECTED = 'Y'
                    GROUP BY USER_GROUP_ID
                );

            
            IF  LNCONFIGURED != LNSELECTED
            THEN
                LNERROR := 1;
            END IF;

         EXCEPTION
            WHEN OTHERS
            THEN
                LNERROR := 1;
         END;
         

      END IF;

      
      IF LNERROR = 1
      THEN
         ROLLBACK;
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_WRONGAPPROVERSELECTION ) );
      END IF;
      

      
      SELECT COUNT( ALL_TO_APPROVE )
        INTO LNCOUNT
        FROM APPROVER_SELECTED
       WHERE ALL_TO_APPROVE = 'S'
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND STATUS = ANSTATUSWORKFLOWLIST;

        IF LNCOUNT > 0
      THEN
         


































          

         
         BEGIN
            
            

            SELECT WORKFLOW_GROUP_ID
                INTO LNWORKFLOWGROUPID
                FROM SPECIFICATION_HEADER
                WHERE PART_NO = ASPARTNO
                AND REVISION = ANREVISION;

            SELECT COUNT(USER_GROUP_ID)
                INTO LNCONFIGURED
                FROM WORK_FLOW_LIST TBL
                WHERE WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
                AND STATUS = ANSTATUSWORKFLOWLIST
                AND ALL_TO_APPROVE = 'S';

            SELECT COUNT (*)
                INTO LNSELECTED
                FROM (
                    SELECT DISTINCT USER_GROUP_ID
                    FROM APPROVER_SELECTED
                    WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND STATUS = ANSTATUSWORKFLOWLIST
                    AND ALL_TO_APPROVE = 'S'
                    AND SELECTED = 'Y'
                    GROUP BY USER_GROUP_ID
                );

            
            IF  LNCONFIGURED != LNSELECTED
            THEN
                LNERROR := 1;
            END IF;

         EXCEPTION
            WHEN OTHERS
            THEN
                LNERROR := 1;
         END;
         

      END IF;

      


      IF LNERROR = 0
      THEN
         
         
         
         DELETE      APPROVER_SELECTED
               WHERE SELECTED = 'N';
         

         DELETE      APPROVER_SELECTED
               WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                 AND PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND STATUS = ANSTATUSWORKFLOWLIST;
      

































      ELSE
         ROLLBACK;
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_WRONGAPPROVERSELECTION ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         





         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END XMLAPPROVERSLISTINTOTABLE;

   FUNCTION WHO_HAS_HASNOT_APPROVED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQWHOHASHASNOTAPPROVEDLIST OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := ' Who_Has_HasNot_Approved';
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'USER_GROUP.DESCRIPTION '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ','
            || 'WORK_FLOW_LIST.ALL_TO_APPROVE '
            || IAPICONSTANTCOLUMN.ALLTOAPPROVECOL
            || ','
            || 'USER_GROUP_LIST.USER_ID '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ','
            || 'SUBSTR (F_Us_Descr (USER_GROUP_LIST.USER_ID), 1, 80) '
            || IAPICONSTANTCOLUMN.LASTNAMECOL
            || ','
            || 'SUBSTR (F_Us_Detail (USER_GROUP_LIST.USER_ID, ''telephone''), 1, 80) '
            || IAPICONSTANTCOLUMN.TELEPHONENUMBERCOL
            || ','
            || 'USERS_APPROVED.APPROVED_DATE  '
            || IAPICONSTANTCOLUMN.APPROVEDDATECOL;
      




      LSSQL                         IAPITYPE.SQLSTRING_TYPE
         :=    '(SELECT '
            || LSSELECT
            || '   FROM USER_GROUP, USER_GROUP_LIST,   '
            || '        USERS_APPROVED,    '
            || '        WORK_FLOW_LIST,    '
            || '        STATUS,            '
            || '        SPECIFICATION_HEADER '
            || '  WHERE USER_GROUP_LIST.USER_ID  = USERS_APPROVED.USER_ID(+) '
            || '   AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID) '
            || '   AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID) '
            || '   AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS) '
            || '   AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID) '
            || '        AND (WORK_FLOW_LIST.STATUS = SPECIFICATION_HEADER.STATUS) '
            || '        AND (USERS_APPROVED.PART_NO(+)  = :asPartNo) '
            || '        AND (USERS_APPROVED.REVISION(+) = :anRevision)) '
            || '   AND SPECIFICATION_HEADER.PART_NO  = :asPartNo '
            || '   AND SPECIFICATION_HEADER.REVISION = :anRevision '
            || '   AND STATUS.STATUS_TYPE = ''SUBMIT'' '
            || '   AND WORK_FLOW_LIST.ALL_TO_APPROVE <> ''Z'' '
            || '  MINUS '
            || '  SELECT USER_GROUP.DESCRIPTION, WORK_FLOW_LIST.ALL_TO_APPROVE, USER_GROUP_LIST.USER_ID, '
            || '         SUBSTR (F_Us_Descr (USER_GROUP_LIST.USER_ID), 1, 80) last_name, '
            || '         SUBSTR (F_Us_Detail (USER_GROUP_LIST.USER_ID, ''telephone''), 1, 80) telephone, '
            || '         USERS_APPROVED.APPROVED_DATE '
            || '    FROM USER_GROUP, '
            || '         USER_GROUP_LIST, '
            || '         USERS_APPROVED, '
            || '         WORK_FLOW_LIST, '
            || '         STATUS, '
            || '         SPECIFICATION_HEADER '
            || '   WHERE USER_GROUP_LIST.USER_ID = USERS_APPROVED.USER_ID(+) '
            || '    AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID) '
            || '    AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID) '
            || '    AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS) '
            || '    AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID) '
            || '        AND (WORK_FLOW_LIST.STATUS = SPECIFICATION_HEADER.STATUS) '
            || '        AND (USERS_APPROVED.PART_NO(+)  = :asPartNo) '
            || '        AND (USERS_APPROVED.REVISION(+) = :anRevision) ) '
            || '    AND SPECIFICATION_HEADER.PART_NO  = :asPartNo '
            || '    AND SPECIFICATION_HEADER.REVISION = :anRevision '
            || '    AND STATUS.STATUS_TYPE = ''SUBMIT'' '
            || '    AND WORK_FLOW_LIST.ALL_TO_APPROVE <> ''Z'' '
            || '    AND WORK_FLOW_LIST.EDITABLE = ''Y'') '
            || 'UNION '
            || '( '
            || 'SELECT '
            || LSSELECT
            || '    FROM USER_GROUP, '
            || '         USER_GROUP_LIST, '
            || '         USERS_APPROVED, '
            || '         WORK_FLOW_LIST, '
            || '         STATUS, '
            || '         SPECIFICATION_HEADER, '
            || '         APPROVER_SELECTED '
            || '   WHERE USER_GROUP_LIST.USER_ID = USERS_APPROVED.USER_ID(+) '
            || '    AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID) '
            || '    AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID) '
            || '    AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS) '
            || '    AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID) '
            || '        AND (WORK_FLOW_LIST.STATUS = SPECIFICATION_HEADER.STATUS) '
            || '        AND (USERS_APPROVED.PART_NO(+)  = :asPartNo) '
            || '        AND (USERS_APPROVED.REVISION(+) = :anRevision) '
            || '       ) '
            || '    AND SPECIFICATION_HEADER.PART_NO = :asPartNo '
            || '    AND SPECIFICATION_HEADER.REVISION = :anRevision '
            || '    AND STATUS.STATUS_TYPE = ''SUBMIT'' '
            || '    AND WORK_FLOW_LIST.ALL_TO_APPROVE <> ''Z'' '
            || '    AND WORK_FLOW_LIST.EDITABLE =''Y'' '
            || '    AND SPECIFICATION_HEADER.PART_NO  = APPROVER_SELECTED.part_no '
            || '    AND SPECIFICATION_HEADER.REVISION = APPROVER_SELECTED.REVISION '
            || '    AND SPECIFICATION_HEADER.status   = APPROVER_SELECTED.status '
            || '    AND USER_GROUP_LIST.USER_ID       = APPROVER_SELECTED.USER_ID '
            || '    AND WORK_FLOW_LIST.ALL_TO_APPROVE = APPROVER_SELECTED.ALL_TO_APPROVE'
            || '    AND WORK_FLOW_LIST.USER_GROUP_ID = APPROVER_SELECTED.USER_GROUP_ID )'
            || 'UNION '
            || '( '
            || 'SELECT DISTINCT '
            || LSSELECT
            || '        FROM USER_GROUP, '
            || '             USER_GROUP_LIST, '
            || '             USERS_APPROVED, '
            || '             WORK_FLOW_LIST, '
            || '             STATUS, '
            || '             SPECIFICATION_HEADER, '
            || '             APPROVER_SELECTED '
            || '       WHERE USER_GROUP_LIST.USER_ID=USERS_APPROVED.USER_ID(+) '
            || '        AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID) '
            || '        AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID) '
            || '        AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS) '
            || '        AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID) '
            || '            AND (WORK_FLOW_LIST.STATUS = SPECIFICATION_HEADER.STATUS) '
            || '            AND (USERS_APPROVED.PART_NO(+)  = :asPartNo) '
            || '            AND (USERS_APPROVED.REVISION(+) = :anRevision) '
            || '           ) '
            || '        AND SPECIFICATION_HEADER.PART_NO =  :asPartNo '
            || '        AND SPECIFICATION_HEADER.REVISION = :anRevision '
            || '        AND STATUS.STATUS_TYPE = ''SUBMIT'' '
            || '        AND WORK_FLOW_LIST.ALL_TO_APPROVE <> ''Z'' '
            || '        AND WORK_FLOW_LIST.editable =''Y'' '
            || '        AND SPECIFICATION_HEADER.PART_NO  = USERS_APPROVED.part_no '
            || '        AND SPECIFICATION_HEADER.REVISION = USERS_APPROVED.REVISION '
            || '        AND SPECIFICATION_HEADER.status  = USERS_APPROVED.status '
            || '        AND USER_GROUP_LIST.USER_ID     = USERS_APPROVED.USER_ID)';
   BEGIN
      OPEN AQWHOHASHASNOTAPPROVEDLIST FOR LSSQL
      USING ASPARTNO,
            ANREVISION,
            ASPARTNO,
            ANREVISION,
            ASPARTNO,
            ANREVISION,
            ASPARTNO,
            ANREVISION,
            ASPARTNO,
            ANREVISION,
            ASPARTNO,
            ANREVISION,
            ASPARTNO,
            ANREVISION,
            ASPARTNO,
            ANREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END WHO_HAS_HASNOT_APPROVED;


   
   FUNCTION CHECKAPPROVERSFORBLOCKEDSPEC (
      ASPARTNO          IN     IAPITYPE.PARTNO_TYPE,
      ANREVISION        IN     IAPITYPE.REVISION_TYPE,
      ANTOAPPROVE       OUT IAPITYPE.NUMVAL_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSSQL             IAPITYPE.SQLSTRING_TYPE;
      LS_USER_ID        USER_GROUP_LIST.USER_ID%TYPE;
      LN_USER_PRESENT   NUMBER;
      LSMETHOD IAPITYPE.METHOD_TYPE
            := 'CheckApproversForBlockedSpec' ;


      CURSOR SELECTED_APPROVERS (
         A_PARTNO       IN            SPECIFICATION_HEADER.PART_NO%TYPE,
         A_REVISIONNO   IN            SPECIFICATION_HEADER.REVISION%TYPE
      )
      IS
         SELECT   USER_GROUP_LIST.USER_ID
           FROM   USER_GROUP,
                  USER_GROUP_LIST,
                  USERS_APPROVED,
                  WORK_FLOW_LIST,
                  STATUS,
                  SPECIFICATION_HEADER,
                  APPROVER_SELECTED
          WHERE   USER_GROUP_LIST.USER_ID = USERS_APPROVED.USER_ID(+)
                  AND (USER_GROUP.USER_GROUP_ID =
                          USER_GROUP_LIST.USER_GROUP_ID)
                  AND (USER_GROUP_LIST.USER_GROUP_ID =
                          WORK_FLOW_LIST.USER_GROUP_ID)
                  AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS)
                  AND ( (WORK_FLOW_LIST.WORKFLOW_GROUP_ID =
                            SPECIFICATION_HEADER.WORKFLOW_GROUP_ID)
                       AND (WORK_FLOW_LIST.STATUS =
                               SPECIFICATION_HEADER.STATUS)
                       AND (USERS_APPROVED.PART_NO(+) = A_PARTNO)
                       AND (USERS_APPROVED.REVISION(+) = A_REVISIONNO))
                  AND SPECIFICATION_HEADER.PART_NO = A_PARTNO
                  AND SPECIFICATION_HEADER.REVISION = A_REVISIONNO
                  AND STATUS.STATUS_TYPE = 'SUBMIT'
                  AND WORK_FLOW_LIST.ALL_TO_APPROVE <> 'Z'
                  AND WORK_FLOW_LIST.EDITABLE = 'Y'
                  AND SPECIFICATION_HEADER.PART_NO =
                        APPROVER_SELECTED.PART_NO
                  AND SPECIFICATION_HEADER.REVISION =
                        APPROVER_SELECTED.REVISION
                  AND SPECIFICATION_HEADER.STATUS = APPROVER_SELECTED.STATUS
                  AND USER_GROUP_LIST.USER_ID = APPROVER_SELECTED.USER_ID
                  AND WORK_FLOW_LIST.ALL_TO_APPROVE =
                        APPROVER_SELECTED.ALL_TO_APPROVE
                  AND WORK_FLOW_LIST.USER_GROUP_ID =
                        APPROVER_SELECTED.USER_GROUP_ID;


      CURSOR USERS_APPROVED (
         A_PARTNO      IN            SPECIFICATION_HEADER.PART_NO%TYPE,
         A_REVISONNO   IN            SPECIFICATION_HEADER.REVISION%TYPE,
         
         A_USERID      IN            USER_GROUP_LIST.USER_ID%TYPE
      )
      IS
         SELECT   DISTINCT USER_GROUP_LIST.USER_ID
           FROM   USER_GROUP,
                  USER_GROUP_LIST,
                  USERS_APPROVED,
                  WORK_FLOW_LIST,
                  STATUS,
                  SPECIFICATION_HEADER
          
          WHERE   USER_GROUP_LIST.USER_ID = USERS_APPROVED.USER_ID(+)
                  AND (USER_GROUP.USER_GROUP_ID =
                          USER_GROUP_LIST.USER_GROUP_ID)
                  AND (USER_GROUP_LIST.USER_GROUP_ID =
                          WORK_FLOW_LIST.USER_GROUP_ID)
                  AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS)
                  AND ( (WORK_FLOW_LIST.WORKFLOW_GROUP_ID =
                            SPECIFICATION_HEADER.WORKFLOW_GROUP_ID)
                       AND (WORK_FLOW_LIST.STATUS =
                               SPECIFICATION_HEADER.STATUS)
                       AND (USERS_APPROVED.PART_NO(+) = A_PARTNO)
                       AND (USERS_APPROVED.REVISION(+) = A_REVISONNO))
                  AND SPECIFICATION_HEADER.PART_NO = A_PARTNO
                  AND SPECIFICATION_HEADER.REVISION = A_REVISONNO
                  
                  AND USERS_APPROVED.USER_ID = A_USERID
                  
                  AND STATUS.STATUS_TYPE = 'SUBMIT'
                  AND WORK_FLOW_LIST.ALL_TO_APPROVE <> 'Z'
                  AND WORK_FLOW_LIST.EDITABLE = 'Y'
                  AND SPECIFICATION_HEADER.PART_NO = USERS_APPROVED.PART_NO
                  AND SPECIFICATION_HEADER.REVISION = USERS_APPROVED.REVISION
                  AND SPECIFICATION_HEADER.STATUS = USERS_APPROVED.STATUS
                  AND USER_GROUP_LIST.USER_ID = USERS_APPROVED.USER_ID;
   
   
   
   
   BEGIN
      
      ANTOAPPROVE := 0;

      
      IAPIGENERAL.LOGINFO (GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3);

      
      










      
      
      FOR L_ROW IN SELECTED_APPROVERS (ASPARTNO, ANREVISION)
      LOOP
         LS_USER_ID := L_ROW.USER_ID;

         
         LN_USER_PRESENT := 0;

         FOR L_ROW2 IN USERS_APPROVED (ASPARTNO, ANREVISION, LS_USER_ID)
         LOOP
            LN_USER_PRESENT := 1;
         
         END LOOP;

         
         IF LN_USER_PRESENT = 0
         THEN
            
            
            RETURN (IAPICONSTANTDBERROR.DBERR_SUCCESS);
         END IF;
      END LOOP;


      
      
      ANTOAPPROVE := 1;

      RETURN (IAPICONSTANTDBERROR.DBERR_SUCCESS);
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR (GSSOURCE, LSMETHOD, SQLERRM);
         RETURN (IAPIGENERAL.SETERRORTEXT (IAPICONSTANTDBERROR.DBERR_GENFAIL));
   END CHECKAPPROVERSFORBLOCKEDSPEC;
   

END IAPISPECIFICATIONSTATUS;
