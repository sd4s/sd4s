CREATE OR REPLACE PROCEDURE SP_CHECK_DISPLAY
 (
  AS_FRAME_NO   IN FRAME_HEADER.FRAME_NO%TYPE,
  AI_REVISION   IN FRAME_HEADER.REVISION%TYPE,
  AI_OWNER      IN FRAME_HEADER.OWNER%TYPE,
  AI_LAYOUT_ID  IN LAYOUT.LAYOUT_ID%TYPE,
  AI_LAYOUT_REV IN OUT LAYOUT.REVISION%TYPE,
  AI_CHECK      IN OUT INTEGER
 )
 IS






















    
    LN_LAYOUT_ID  LAYOUT.LAYOUT_ID%TYPE;

 BEGIN
 

    
    
    
    
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
          
    BEGIN
          SELECT MAX(REVISION)
            INTO LN_LAYOUT_ID                
            FROM LAYOUT
           WHERE LAYOUT_ID = AI_LAYOUT_ID
             AND STATUS = 2 ;
    EXCEPTION
        WHEN OTHERS THEN
            
            AI_CHECK := 1;
            AI_LAYOUT_REV := 0;
    END;
            
    IF (LN_LAYOUT_ID IS NOT NULL)
    THEN
        AI_LAYOUT_REV := LN_LAYOUT_ID;
        NULL;        
    
    
    
    END IF;        


     RETURN;

 END SP_CHECK_DISPLAY ;