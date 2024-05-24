CREATE OR REPLACE PROCEDURE SP_APPROVE_BLOCKED_SPEC
IS














   LSSOURCE                      IAPITYPE.SOURCE_TYPE := 'SP_APPROVE_BLOCKED_SPEC';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

   CURSOR SUBMITTED_CURSOR
   IS
      SELECT PART_NO,
             REVISION,
             SH.STATUS,
             WORKFLOW_GROUP_ID
        FROM SPECIFICATION_HEADER SH,
             STATUS SS
       WHERE SS.STATUS_TYPE = 'SUBMIT'
         AND SS.STATUS = SH.STATUS;

   


   CURSOR USERS_TO_APPROVE(
      A_STATUS                   IN       STATUS.STATUS%TYPE,
      A_WORKFLOW_GROUP_ID        IN       WORKFLOW_GROUP.WORKFLOW_GROUP_ID%TYPE )
   IS
      SELECT   USER_ID,
               ALL_TO_APPROVE,
               B.USER_GROUP_ID
          FROM WORK_FLOW_LIST B,
               USER_GROUP_LIST A
         WHERE STATUS = A_STATUS
           AND WORKFLOW_GROUP_ID = A_WORKFLOW_GROUP_ID
           AND A.USER_GROUP_ID = B.USER_GROUP_ID
           AND ALL_TO_APPROVE <> 'Z'
      ORDER BY ALL_TO_APPROVE,
               B.USER_GROUP_ID DESC;

   CURSOR C8(
      A_STATUS                   IN       STATUS.STATUS%TYPE,
      A_WORKFLOW_GROUP           IN       WORKFLOW_GROUP.WORKFLOW_GROUP_ID%TYPE )
   IS
      SELECT B.NEXT_STATUS,
             A.STATUS_TYPE
        FROM STATUS A,
             WORK_FLOW B,
             WORKFLOW_GROUP C
       WHERE A.STATUS = B.NEXT_STATUS
         AND B.WORK_FLOW_ID = C.WORK_FLOW_ID
         AND C.WORKFLOW_GROUP_ID = A_WORKFLOW_GROUP
         AND B.STATUS = A_STATUS;

   L_USER_ID                     USERS_APPROVED.USER_ID%TYPE;
   L_USER_ID2                    USERS_APPROVED.USER_ID%TYPE;
   L_TO_APPROVE                  NUMBER;
   L_STATUS                      STATUS.STATUS%TYPE;
   L_WORKFLOW_GROUP_ID           WORKFLOW_GROUP.WORKFLOW_GROUP_ID%TYPE;
   V_SUBMIT_COUNT                NUMBER := 0;
   V_APPROVED_COUNT              NUMBER := 0;
   V_NEW_STATUS                  STATUS.STATUS%TYPE;
   V_SORT_SEQ                    NUMBER;
   V_REASON_ID                   NUMBER;
   L_COUNT                       NUMBER;
   L_USER_GROUP_OLD              USER_GROUP.USER_GROUP_ID%TYPE;
   LQERRORS                      IAPITYPE.REF_TYPE;
   
   ANTOAPPROVE                   IAPITYPE.NUMVAL_TYPE;
   
   LNCHECKAPPRRES                IAPITYPE.NUMVAL_TYPE;
   
BEGIN
   
   IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
   THEN
      LNRETVAL := IAPIGENERAL.SETCONNECTION( USER,
                                             'APPROVE BLOCKED SPEC JOB' );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
      END IF;
   END IF;

   FOR L_ROW IN SUBMITTED_CURSOR
   LOOP
      
      L_TO_APPROVE := 1;
      L_WORKFLOW_GROUP_ID := L_ROW.WORKFLOW_GROUP_ID;
      L_STATUS := L_ROW.STATUS;
      DBMS_OUTPUT.PUT_LINE(    'spec '
                            || L_ROW.STATUS );
      DBMS_OUTPUT.PUT_LINE(    'spec '
                            || L_ROW.PART_NO );
      L_USER_GROUP_OLD := 9999;
      
      
      LNCHECKAPPRRES := 1;

      FOR L_ROW2 IN USERS_TO_APPROVE( L_ROW.STATUS,
                                      L_ROW.WORKFLOW_GROUP_ID )
      LOOP
         IF L_USER_GROUP_OLD <> L_ROW2.USER_GROUP_ID
         THEN
            L_USER_GROUP_OLD := L_ROW2.USER_GROUP_ID;
            DBMS_OUTPUT.PUT_LINE(    'New user group '
                                  || L_ROW2.USER_GROUP_ID );
            DBMS_OUTPUT.PUT_LINE(    'All to approve '
                                  || L_ROW2.ALL_TO_APPROVE );

            IF L_TO_APPROVE = 0
            THEN
                
               
               EXIT;
            END IF;

                
            
            L_TO_APPROVE := 0;
            
            
            
            IF L_ROW2.ALL_TO_APPROVE = 'S'
            THEN
               LNRETVAL :=
                  IAPISPECIFICATIONSTATUS.CHECKAPPROVERSFORBLOCKEDSPEC (
                     L_ROW.PART_NO,
                     L_ROW.REVISION,
                     LNCHECKAPPRRES);

               
               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                    LNCHECKAPPRRES := 1;
               END IF;                                            
            END IF;
           
            
         END IF;

         BEGIN
            SELECT MAX( USER_ID )
              INTO L_USER_ID
              FROM USERS_APPROVED
             WHERE PART_NO = L_ROW.PART_NO
               AND REVISION = L_ROW.REVISION
               AND USER_ID = L_ROW2.USER_ID;

            IF L_USER_ID IS NULL
            THEN
               
               IF L_ROW2.ALL_TO_APPROVE = 'Y'
               THEN
                  L_TO_APPROVE := 0;
                  EXIT;
               ELSIF L_ROW2.ALL_TO_APPROVE = 'N'
               THEN
                  IF L_TO_APPROVE > 0
                  THEN
                     
                     NULL;
                  ELSE
                     L_TO_APPROVE := 0;
                  END IF;
               
               ELSIF L_ROW2.ALL_TO_APPROVE = 'S'
               THEN
                    IF LNCHECKAPPRRES = 0
                    THEN   
                        L_TO_APPROVE := 0;
                    
                    ELSE
                        L_TO_APPROVE := 1;
                    
                    END IF;
               
                  
               END IF;
            ELSE
               
               


               
               IF L_ROW2.ALL_TO_APPROVE = 'S'
               THEN
                    IF LNCHECKAPPRRES = 0
                    THEN   
                        L_TO_APPROVE := 0;
                    
                    ELSE
                        L_TO_APPROVE := 1;
                    
                    END IF;
               ELSE
                    L_TO_APPROVE := L_TO_APPROVE + 1;
               END IF;               
               
            END IF;
         END;
      END LOOP;

      IF L_TO_APPROVE > 0
      THEN
         SELECT COUNT( * )
           INTO L_COUNT
           FROM USERS_APPROVED
          WHERE PART_NO = L_ROW.PART_NO
            AND REVISION = L_ROW.REVISION
            AND STATUS = L_ROW.STATUS;

         IF L_COUNT = 0
         THEN
            
            
            
            SELECT MAX( USER_ID )
              INTO L_USER_ID2
              FROM STATUS_HISTORY
             WHERE PART_NO = L_ROW.PART_NO
               AND REVISION = L_ROW.REVISION
               AND STATUS = L_ROW.STATUS;

            INSERT INTO USERS_APPROVED
                 VALUES ( L_ROW.PART_NO,
                          L_ROW.REVISION,
                          SYSDATE,
                          L_USER_ID2,
                          L_ROW.STATUS,
                          SYSDATE,
                          'P',
                          NULL );
         END IF;

         
         
         INSERT INTO APPROVAL_HISTORY
            SELECT PART_NO,
                   REVISION,
                   STATUS_DATE_TIME,
                   USERS_APPROVED.USER_ID,
                   STATUS,
                   APPROVED_DATE,
                   PASS_FAIL,
                   FORENAME,
                   LAST_NAME,
                   NULL
              FROM USERS_APPROVED,
                   APPLICATION_USER
             WHERE PART_NO = L_ROW.PART_NO
               AND REVISION = L_ROW.REVISION
               AND STATUS = L_ROW.STATUS
               AND USERS_APPROVED.USER_ID = APPLICATION_USER.USER_ID;

         
         
         
         




         
         

         FOR C8REC IN C8( L_STATUS,
                          L_WORKFLOW_GROUP_ID )
         LOOP
            IF C8REC.STATUS_TYPE = 'SUBMIT'
            THEN
               V_SUBMIT_COUNT :=   V_SUBMIT_COUNT
                                 + 1;   
               V_NEW_STATUS := C8REC.NEXT_STATUS;
            END IF;
         END LOOP;

         DBMS_OUTPUT.PUT_LINE(    'v_submit_count) : '
                               || V_SUBMIT_COUNT );

         IF V_SUBMIT_COUNT = 0
         THEN
            NULL;
         
         ELSE
            LNRETVAL := IAPISPECIFICATIONSTATUS.STATUSCHANGE( L_STATUS,
                                                              L_ROW.REVISION,
                                                              L_ROW.PART_NO,
                                                              V_NEW_STATUS,
                                                              USER,
                                                              NULL,
                                                              LQERRORS );
         END IF;

         IF V_SUBMIT_COUNT = 0
         THEN   
            FOR C8REC IN C8( L_STATUS,
                             L_WORKFLOW_GROUP_ID )
            LOOP
               IF C8REC.STATUS_TYPE = 'APPROVED'
               THEN
                  V_APPROVED_COUNT :=   V_APPROVED_COUNT
                                      + 1;
                  V_NEW_STATUS := C8REC.NEXT_STATUS;
               END IF;
            END LOOP;

            IF V_APPROVED_COUNT = 0
            THEN
               
               
               
               RAISE_APPLICATION_ERROR( -20208,
                                           ' No Record found in table STATUS'
                                        || ' WHERE field STATUS_TYPE = '
                                        || L_STATUS
                                        || ', PART_NO = '
                                        || L_ROW.PART_NO
                                        || ' AND REVISION = '
                                        || L_ROW.REVISION
                                        || ' for STATUS_TYPE = '
                                        || ' APPROVED ' );
            ELSIF V_APPROVED_COUNT > 1
            THEN
               RAISE_APPLICATION_ERROR( -20209,
                                           ' To many rows in table STATUS'
                                        || ' WHERE field STATUS_TYPE = APPROVED for PART_NO = '
                                        || L_ROW.PART_NO
                                        || ' AND REVISION = '
                                        || L_ROW.REVISION );
            ELSE
               
               





               
                              
               
               
               LNRETVAL := 
                    IAPISPECIFICATIONSTATUS.CHECKAPPROVERSFORBLOCKEDSPEC (L_ROW.PART_NO,
                                                                          L_ROW.REVISION,    
                                                                          ANTOAPPROVE);

               IF LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  IF ANTOAPPROVE = 1
                  THEN                     
                     UPDATE   SPECIFICATION_HEADER
                        SET   STATUS = V_NEW_STATUS,
                              STATUS_CHANGE_DATE = SYSDATE
                      WHERE   PART_NO = L_ROW.PART_NO
                              AND REVISION = L_ROW.REVISION;
                  END IF;
               ELSE
                  
                  NULL;                  
               END IF;               
               
                  
            END IF;

            
            IF ANTOAPPROVE = 1
            THEN
            
                UPDATE PART
                   SET CHANGED_DATE = SYSDATE
                 WHERE PART_NO = L_ROW.PART_NO;
            
            END IF;
            
         END IF;

         
         
         
         DELETE FROM USERS_APPROVED
               WHERE PART_NO = L_ROW.PART_NO
                 AND REVISION = L_ROW.REVISION
                 AND STATUS = L_ROW.STATUS;
         

         
         
         IF (V_SUBMIT_COUNT = 0 AND ANTOAPPROVE = 1)
         
         THEN
            
            
            SELECT STATUS_HISTORY_SEQ.NEXTVAL
              INTO V_SORT_SEQ
              FROM DUAL;

            
            INSERT INTO STATUS_HISTORY
                        ( PART_NO,
                          REVISION,
                          STATUS,
                          STATUS_DATE_TIME,
                          USER_ID,
                          SORT_SEQ,
                          REASON_ID )
                 VALUES ( L_ROW.PART_NO,
                          L_ROW.REVISION,
                          V_NEW_STATUS,
                          SYSDATE,
                          'INTERSPC',
                          V_SORT_SEQ,
                          NULL );

            BEGIN
               SELECT MAX( H.REASON_ID )
                 INTO V_REASON_ID
                 FROM STATUS_HISTORY H,
                      STATUS S
                WHERE STATUS_TYPE = 'SUBMIT'
                  AND H.STATUS = S.STATUS
                  AND PART_NO = L_ROW.PART_NO
                  AND REVISION = L_ROW.REVISION;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  V_REASON_ID := -1;
               WHEN OTHERS
               THEN
                  RAISE_APPLICATION_ERROR( -20001,
                                           'tot hier 1' );
            END;

            LNRETVAL := IAPIEMAIL.REGISTEREMAIL( L_ROW.PART_NO,
                                                 L_ROW.REVISION,
                                                 V_NEW_STATUS,
                                                 SYSDATE,
                                                 'S',
                                                 NULL,
                                                 NULL,
                                                 V_REASON_ID,
                                                 NULL,
                                                 LQERRORS );
         END IF;
      END IF;

      V_SUBMIT_COUNT := 0;
      V_APPROVED_COUNT := 0;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      IAPIGENERAL.LOGERROR( LSSOURCE,
                            '',
                            SQLERRM );
      LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
END;