CREATE OR REPLACE PROCEDURE SP_CHK_FRMDATA(
   A_PART_NO                  IN       SPECIFICATION_HEADER.PART_NO%TYPE,
   A_REVISION                 IN       SPECIFICATION_HEADER.REVISION%TYPE,
   A_FRAME_NO                 IN       FRAME_HEADER.FRAME_NO%TYPE,
   A_FRAME_OWNER              IN       FRAME_HEADER.OWNER%TYPE,
   A_NEW_FRAME_REV            IN OUT   FRAME_HEADER.REVISION%TYPE,
   A_WORKFLOW_GROUP_ID        IN OUT   FRAME_HEADER.WORKFLOW_GROUP_ID%TYPE,
   A_ACCESS_GROUP             IN OUT   FRAME_HEADER.ACCESS_GROUP%TYPE,
   A_CLASS3_ID                IN OUT   FRAME_HEADER.CLASS3_ID%TYPE,
   A_INTL                     IN       FRAME_HEADER.INTL%TYPE,   
   A_SRC_INTL                 IN       FRAME_HEADER.INTL%TYPE,   
   A_LOCAL                    IN OUT   NUMBER   
                                             )
IS

























   V_SRC_INTL                    FRAME_HEADER.INTL%TYPE;
   V_COUNTER                     NUMBER := 0;
   V_FRM_INTL                    FRAME_HEADER.INTL%TYPE;
   V_REVISION                    SPECIFICATION_HEADER.REVISION%TYPE;
BEGIN
   V_SRC_INTL := A_SRC_INTL;

   IF V_SRC_INTL IS NULL
   THEN
      
      V_SRC_INTL := '1';
   END IF;

   
   IF     A_INTL = '0'
      AND A_LOCAL = 0
   THEN
      BEGIN
         SELECT REVISION,
                WORKFLOW_GROUP_ID,
                ACCESS_GROUP,
                CLASS3_ID
           INTO A_NEW_FRAME_REV,
                A_WORKFLOW_GROUP_ID,
                A_ACCESS_GROUP,
                A_CLASS3_ID
           FROM FRAME_HEADER
          WHERE FRAME_NO = A_FRAME_NO
            AND OWNER = A_FRAME_OWNER
            AND STATUS = 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            A_NEW_FRAME_REV := 0;
      END;
   ELSIF     A_INTL = '0'
         AND A_LOCAL = 1
   THEN
      BEGIN
         


         
         
        
            SELECT MAX( A.REVISION )
              INTO V_REVISION
              FROM SPECIFICATION_HEADER A,
                   STATUS B
             WHERE A.PART_NO = A_PART_NO
               AND A.REVISION >= A_REVISION
               AND A.STATUS = B.STATUS
               AND B.STATUS_TYPE = 'CURRENT';

			IF V_REVISION IS NULL THEN
                     RAISE_APPLICATION_ERROR( -20060,
                                              'Copy - Invalid intl spec' );
			END IF;

         
         
         
         
         SELECT REVISION,
                WORKFLOW_GROUP_ID,
                ACCESS_GROUP,
                CLASS3_ID
           INTO A_NEW_FRAME_REV,
                A_WORKFLOW_GROUP_ID,
                A_ACCESS_GROUP,
                A_CLASS3_ID
           FROM FRAME_HEADER
          WHERE FRAME_NO = A_FRAME_NO
            AND OWNER = A_FRAME_OWNER
            AND REVISION =
                   ( SELECT MAX( A.REVISION )
                      FROM FRAME_HEADER A,
                           SPECIFICATION_HEADER B
                     WHERE FRAME_NO = A_FRAME_NO
                       AND A.OWNER = A_FRAME_OWNER
                       AND A.FRAME_NO = B.FRAME_ID
                       AND A.OWNER = B.FRAME_OWNER
                       AND A.REVISION BETWEEN TRUNC( B.FRAME_REV ) AND(   TRUNC( B.FRAME_REV )
                                                                        + 0.99 )
                       AND B.PART_NO = A_PART_NO
                       AND B.REVISION = V_REVISION
                       AND A.STATUS <> 1 );

         



         SELECT COUNT( * )
           INTO V_COUNTER
           FROM FRAME_HEADER
          WHERE FRAME_NO = A_FRAME_NO
            AND OWNER = A_FRAME_OWNER
            AND REVISION = A_NEW_FRAME_REV
            AND STATUS IN( 2, 7 );

         IF V_COUNTER = 0
         THEN
            A_LOCAL := 0;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            A_LOCAL := 0;
            A_NEW_FRAME_REV := 0;
      END;
   ELSIF     A_INTL = '1'
         AND V_SRC_INTL = '0'
   THEN
      


      BEGIN
         
         IF A_LOCAL <> 2
         THEN
            

            RAISE_APPLICATION_ERROR( -20061,
                                     'A local specification cannot be copied by an intl user' );
         ELSE
            
            BEGIN
               

               SELECT MAX( REVISION )
                 INTO A_NEW_FRAME_REV
                 FROM FRAME_HEADER
                WHERE FRAME_NO = A_FRAME_NO
                  AND OWNER = A_FRAME_OWNER
                  AND MOD(   REVISION
                           * 100,
                           100 ) = 0
                  AND STATUS IN( 2, 6, 7 );

               SELECT WORKFLOW_GROUP_ID,
                      ACCESS_GROUP,
                      CLASS3_ID
                 INTO A_WORKFLOW_GROUP_ID,
                      A_ACCESS_GROUP,
                      A_CLASS3_ID
                 FROM FRAME_HEADER
                WHERE FRAME_NO = A_FRAME_NO
                  AND REVISION = A_NEW_FRAME_REV
                  AND OWNER = A_FRAME_OWNER;

               
               SELECT INTL
                 INTO V_FRM_INTL
                 FROM FRAME_HEADER
                WHERE FRAME_NO = A_FRAME_NO
                  AND REVISION = A_NEW_FRAME_REV
                  AND OWNER = A_FRAME_OWNER;

               IF V_FRM_INTL = '0'
               THEN
                  

                  RAISE_APPLICATION_ERROR( -20062,
                                           'A local specification cannot be made international if the frame is local' );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  A_NEW_FRAME_REV := 0;
            END;
         END IF;
      END;
   ELSIF     A_INTL = '1'
         AND V_SRC_INTL = '1'
   THEN
      
      
      BEGIN
         

         SELECT MAX( REVISION )
           INTO A_NEW_FRAME_REV
           FROM FRAME_HEADER
          WHERE FRAME_NO = A_FRAME_NO
            AND OWNER = A_FRAME_OWNER
            AND MOD(   REVISION
                     * 100,
                     100 ) = 0
            AND STATUS IN( 2, 6, 7 );

         SELECT WORKFLOW_GROUP_ID,
                ACCESS_GROUP,
                CLASS3_ID
           INTO A_WORKFLOW_GROUP_ID,
                A_ACCESS_GROUP,
                A_CLASS3_ID
           FROM FRAME_HEADER
          WHERE FRAME_NO = A_FRAME_NO
            AND REVISION = A_NEW_FRAME_REV
            AND OWNER = A_FRAME_OWNER;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            A_NEW_FRAME_REV := 0;
      END;
   END IF;
END SP_CHK_FRMDATA;