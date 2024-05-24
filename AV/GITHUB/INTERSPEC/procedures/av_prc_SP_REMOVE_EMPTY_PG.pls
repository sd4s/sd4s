CREATE OR REPLACE PROCEDURE sp_remove_empty_pg
IS

















   
   LL_RETCODE                    NUMBER;
   LS_ERR_MSG                    VARCHAR2( 255 );
   LL_JOB_ID                     NUMBER;
   LS_JOB                        VARCHAR2( 40 );
   LL_COUNT                      NUMBER := 0;

   
   CURSOR CUR_PG
   IS
      SELECT SC.PART_NO,
             SC.REVISION,
             SC.SECTION_ID,
             SC.SUB_SECTION_ID,
             SC.REF_ID
        FROM SPECIFICATION_SECTION SC,
             SPECIFICATION_HEADER SH,
             STATUS SS
       WHERE SC.TYPE = 1
         AND SC.PART_NO = SH.PART_NO
         AND SC.REVISION = SH.REVISION
         AND SS.STATUS = SH.STATUS
         AND SS.STATUS_TYPE <> 'DEVELOPMENT'
      MINUS
      SELECT PART_NO,
             REVISION,
             SECTION_ID,
             SUB_SECTION_ID,
             PROPERTY_GROUP
        FROM SPECIFICATION_PROP
       WHERE PROPERTY_GROUP <> 0;
BEGIN
   LS_JOB := 'REMOVE_EMPTY_PG';
   
   LL_RETCODE := IAPIJOBLOGGING.STARTJOB( LS_JOB,
                                          LL_JOB_ID );

   FOR REC_PG IN CUR_PG
   LOOP
      LL_COUNT :=   LL_COUNT
                  + 1;

      DELETE FROM SPECIFICATION_SECTION
            WHERE PART_NO = REC_PG.PART_NO
              AND REVISION = REC_PG.REVISION
              AND SECTION_ID = REC_PG.SECTION_ID
              AND SUB_SECTION_ID = REC_PG.SUB_SECTION_ID
              AND REF_ID = REC_PG.REF_ID
              AND TYPE = 1;
   END LOOP;

   
   IF LL_COUNT > 0
   THEN
      LS_ERR_MSG :=    TO_CHAR( LL_COUNT )
                    || ' empty property groups that have no properties have been deleted from the specification';
      IAPIGENERAL.LOGWARNING( 'SP_REMOVE_EMPTY_PG',
                              '',
                              LS_ERR_MSG );
   END IF;

   
   LL_RETCODE := IAPIJOBLOGGING.UPDATEJOB( LL_JOB_ID,
                                           SUBSTR(    LS_JOB
                                                   || ' '
                                                   || TO_CHAR( LL_COUNT )
                                                   || ' rows deleted',
                                                   1,
                                                   40 ) );
   
   LL_RETCODE := IAPIJOBLOGGING.ENDJOB( LL_JOB_ID );
EXCEPTION
   WHEN OTHERS
   THEN
      
      IAPIGENERAL.LOGERROR( 'SP_REMOVE_EMPTY_PG',
                            '',
                            SQLERRM );
      LL_RETCODE := IAPIJOBLOGGING.UPDATEJOB( LL_JOB_ID,
                                              SUBSTR(    LS_JOB
                                                      || ' stopped with errors',
                                                      1,
                                                      40 ) );
      
      LL_RETCODE := IAPIJOBLOGGING.ENDJOB( LL_JOB_ID );
END SP_REMOVE_EMPTY_PG;