CREATE OR REPLACE PROCEDURE SP_CHK_FRM_INT_REV
 (
         A_PART_NO               IN SPECIFICATION_HEADER.PART_NO%TYPE,
         A_REVISION              IN SPECIFICATION_HEADER.REVISION%TYPE,
         A_INT_PART_NO           IN OUT SPECIFICATION_HEADER.INT_PART_NO%TYPE,
         A_INT_PART_REV          IN OUT SPECIFICATION_HEADER.INT_PART_REV%TYPE,
         A_FRAME_NO              IN OUT FRAME_HEADER.FRAME_NO%TYPE,
         A_FRAME_OWNER           IN OUT FRAME_HEADER.OWNER%TYPE,
         A_NEW_FRAME_REV         IN OUT FRAME_HEADER.REVISION%TYPE,
         A_WORKFLOW_GROUP_ID     IN OUT FRAME_HEADER.WORKFLOW_GROUP_ID%TYPE,
         A_ACCESS_GROUP          IN OUT FRAME_HEADER.ACCESS_GROUP%TYPE,
         A_CLASS3_ID             IN OUT FRAME_HEADER.CLASS3_ID%TYPE,
         A_INTL                  IN FRAME_HEADER.INTL%TYPE, 
         A_SRC_INTL              IN FRAME_HEADER.INTL%TYPE,  
         A_LOCAL                 IN OUT NUMBER 
 )
 IS



























 V_SRC_INTL FRAME_HEADER.INTL%TYPE;
 V_COUNTER  NUMBER :=0 ;

 BEGIN
         V_SRC_INTL := A_SRC_INTL ;
 
         IF V_SRC_INTL IS NULL THEN
            
            V_SRC_INTL := '1' ;
         END IF ;
 
         
         IF A_INTL = '0'AND A_LOCAL = 0 THEN
                 BEGIN
                         SELECT REVISION, WORKFLOW_GROUP_ID, ACCESS_GROUP, CLASS3_ID
                         INTO A_NEW_FRAME_REV, A_WORKFLOW_GROUP_ID, A_ACCESS_GROUP, A_CLASS3_ID
                         FROM FRAME_HEADER
                         WHERE FRAME_NO = A_FRAME_NO
                         AND OWNER = A_FRAME_OWNER
                         AND STATUS = 2;
                 EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                         A_NEW_FRAME_REV := 0;
                 END;
         ELSIF A_INTL = '0' AND A_LOCAL = 1 THEN
                 BEGIN
                                             
                                             
 
                                             
                                                 
                                                 
                                                 
                         SELECT REVISION, WORKFLOW_GROUP_ID, ACCESS_GROUP, CLASS3_ID
                         INTO A_NEW_FRAME_REV, A_WORKFLOW_GROUP_ID, A_ACCESS_GROUP, A_CLASS3_ID
                         FROM FRAME_HEADER
                         WHERE FRAME_NO = A_FRAME_NO
                         AND OWNER = A_FRAME_OWNER
                         AND REVISION =
                                                 (SELECT MAX(A.REVISION)
                           FROM FRAME_HEADER A, SPECIFICATION_HEADER B
                         WHERE FRAME_NO = A_FRAME_NO
                         AND A.OWNER = A_FRAME_OWNER
                         AND A.FRAME_NO = B.FRAME_ID
                                                 AND A.OWNER = B.FRAME_OWNER
                                                 AND A.REVISION BETWEEN (B.FRAME_REV - 0.01) AND (B.FRAME_REV + 0.7)
                                                 AND B.PART_NO = A_PART_NO
                                                 AND B.REVISION  = A_REVISION) ;
 
                         SELECT COUNT(*)
                         INTO V_COUNTER
                         FROM FRAME_HEADER
                         WHERE FRAME_NO = A_FRAME_NO
                         AND OWNER = A_FRAME_OWNER
                                                 AND REVISION = A_NEW_FRAME_REV
                         AND STATUS IN (2, 7);
 
                                                 IF V_COUNTER = 0 THEN
                                                    A_LOCAL := 0 ;
                                                 END IF ;
                 EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                         A_NEW_FRAME_REV := 0;
                 END;
         ELSIF A_INTL = '1' AND V_SRC_INTL = '0' THEN
                 RAISE_APPLICATION_ERROR(-20061,'A local specification cannot be copied by an intl user');
         ELSIF A_INTL = '1' AND V_SRC_INTL = '1' THEN
                 
                 
                 BEGIN
                         

                         SELECT MAX(REVISION)
                         INTO A_NEW_FRAME_REV
                         FROM FRAME_HEADER
                         WHERE FRAME_NO = A_FRAME_NO
                         AND OWNER = A_FRAME_OWNER
                         AND MOD (REVISION * 100, 100) = 0
                         AND STATUS IN (2,6,7);
 
                         SELECT WORKFLOW_GROUP_ID, ACCESS_GROUP, CLASS3_ID
                         INTO A_WORKFLOW_GROUP_ID, A_ACCESS_GROUP, A_CLASS3_ID
                         FROM FRAME_HEADER
                         WHERE FRAME_NO = A_FRAME_NO
                         AND REVISION = A_NEW_FRAME_REV
                         AND OWNER = A_FRAME_OWNER;
                 EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                                 A_NEW_FRAME_REV := 0;
                 END;
         END IF;
 EXCEPTION
         WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20001,SQLERRM);
 END SP_CHK_FRM_INT_REV;