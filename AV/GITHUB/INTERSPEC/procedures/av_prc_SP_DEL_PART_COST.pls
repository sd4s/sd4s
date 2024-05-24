CREATE OR REPLACE PROCEDURE SP_DEL_PART_COST
 (
  AS_PRICE_TYPE   PART_COST.PRICE_TYPE%TYPE,
  AS_PERIOD       PART_COST.PERIOD%TYPE
 ) IS

















 EX_IS_DO_NOT_DELETE EXCEPTION ;
 
 LL_RETCODE           NUMBER ;
 LL_JOB_ID            NUMBER ;
 LS_JOB               VARCHAR2(40) ;
 
 BEGIN
         IF AS_PRICE_TYPE = 'IS' THEN
                 RAISE EX_IS_DO_NOT_DELETE ;
         END IF;

         BEGIN
                 
                 LS_JOB := 'SP_DEL_COST_DATA';
                 LL_RETCODE := IAPIJOBLOGGING.STARTJOB( LS_JOB , LL_JOB_ID ) ;
                 DELETE FROM PART_COST
                 WHERE PERIOD = AS_PERIOD
                   AND PRICE_TYPE = AS_PRICE_TYPE ;
 
                 DELETE FROM PRICE_TYPE
                 WHERE PERIOD = AS_PERIOD
                   AND PRICE_TYPE = AS_PRICE_TYPE ;
 
                 
                 UPDATE ITJOB
                         SET JOB = SUBSTR( LS_JOB || ' ' || AS_PRICE_TYPE||'  '||AS_PERIOD||' deleted', 1, 40 )
          WHERE JOB_ID = LL_JOB_ID ;
                 
                 LL_RETCODE := IAPIJOBLOGGING.ENDJOB( LL_JOB_ID ) ;
         EXCEPTION
                 WHEN OTHERS THEN
                         RAISE_APPLICATION_ERROR(-20650,SQLERRM);
         END ;
 EXCEPTION
         WHEN EX_IS_DO_NOT_DELETE THEN
                 RAISE_APPLICATION_ERROR(-20651,SQLERRM);
 END SP_DEL_PART_COST;