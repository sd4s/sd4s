CREATE OR REPLACE PACKAGE BODY iapiSpecificationFilter
AS
   
   
   
   
   
   

   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                 IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
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

   

   FUNCTION CREATECLASSIFICATIONFILTER(
      ANFILTERID                 IN       IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ASCLASSIFY                 IN       IAPITYPE.STRING_TYPE,
      ASCODE                     IN       IAPITYPE.STRING_TYPE,
      ASTYPE                     IN       IAPITYPE.CLASSIFICATIONTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateClassificationFilter (2)';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE := 0;
      
      LXCLASSIFY                    IAPITYPE.XMLTYPE_TYPE ;
      LXCODE                        IAPITYPE.XMLTYPE_TYPE ;
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
   BEGIN
      
      
      

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LXCLASSIFY    := XMLTYPE.CREATEXML(ASCLASSIFY);
      LXCODE        := XMLTYPE.CREATEXML(ASCODE);
      
      LNRETVAL:= CREATECLASSIFICATIONFILTER(ANFILTERID,
                                            ANARRAY,
                                            LXCLASSIFY,
                                            LXCODE,
                                            ASTYPE );
                                 
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
        
    END CREATECLASSIFICATIONFILTER;

  
   FUNCTION CREATECLASSIFICATIONFILTER(
      ANFILTERID                 IN       IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      AXCLASSIFY                 IN       IAPITYPE.XMLTYPE_TYPE,
      AXCODE                     IN       IAPITYPE.XMLTYPE_TYPE,
      ASTYPE                     IN       IAPITYPE.CLASSIFICATIONTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateClassificationFilter (1)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      
      LTCLASSIFY                    IAPITYPE.CHARTAB_TYPE;
      LTCODE                        IAPITYPE.CHARTAB_TYPE;
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
      LXPATHLISTCLASSIFY       IAPITYPE.STRING_TYPE := '/keywords/classify';
      LXPATHLISTCODE           IAPITYPE.STRING_TYPE := '/keywords/code';
      
  BEGIN
      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXCLASSIFY, LXPATHLISTCLASSIFY))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTCLASSIFY) || '[' || INDX || ']' ) 
            INTO LTCLASSIFY(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXCLASSIFY, '/'))) T
          ) R;
      END LOOP;
      
      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXCODE, LXPATHLISTCODE))) T 
      ) R;
      
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTCODE) || '[' || INDX || ']' ) 
            INTO LTCODE(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXCODE, '/'))) T
          ) R;
      END LOOP;

     LNRETVAL:= CREATECLASSIFICATIONFILTER( ANFILTERID,
                                            ANARRAY,
                                            LTCLASSIFY,
                                            LTCODE,
                                            ASTYPE );
      
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
         
        
    END CREATECLASSIFICATIONFILTER;


    FUNCTION CREATECLASSIFICATIONFILTER(
      ANFILTERID                 IN       IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ATCLASSIFY                 IN       IAPITYPE.CHARTAB_TYPE,
      ATCODE                     IN       IAPITYPE.CHARTAB_TYPE,
      ASTYPE                     IN       IAPITYPE.CLASSIFICATIONTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateClassificationFilter';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );


      BEGIN
         DELETE FROM ITCLFLT
               WHERE FILTER_ID = ANFILTERID;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      FOR LNCOUNTER IN 1 .. ANARRAY
      LOOP
         BEGIN
            
            
            IF ATCODE( LNCOUNTER ) = ' '
            THEN
               INSERT INTO ITCLFLT
                           ( FILTER_ID,
                             MATL_CLASS_ID,
                             CODE,
                             TYPE )
                    VALUES ( ANFILTERID,
                             ATCLASSIFY( LNCOUNTER ),
                             NULL,
                             ASTYPE );
            ELSE
               INSERT INTO ITCLFLT
                           ( FILTER_ID,
                             MATL_CLASS_ID,
                             CODE,
                             TYPE )
                    VALUES ( ANFILTERID,
                             ATCLASSIFY( LNCOUNTER ),
                             ATCODE( LNCOUNTER ),
                             ASTYPE );
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATECLASSIFICATIONFILTER;

   FUNCTION CREATEKEYWORDFILTER(
      ANFILTERID                 IN       IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ANKEYWORDNO                IN       IAPITYPE.NUMVAL_TYPE,
      ASKEYWORDID                IN       IAPITYPE.STRING_TYPE,
      ASKEYWORDVALUE             IN       IAPITYPE.STRING_TYPE,
      ASKEYWORDVALUELIST         IN       IAPITYPE.STRING_TYPE,
      ASKEYWORDTYPE              IN       IAPITYPE.STRING_TYPE,
      ASOPERATOR                 IN       IAPITYPE.STRING_TYPE )
   RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateKeywordFilter (2)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      
      LXKEYWORDID         SYS.XMLTYPE;
      LXKEYWORDVALUE      SYS.XMLTYPE;
      LXKEYWORDVALUELIST  SYS.XMLTYPE;
      LXKEYWORDTYPE       SYS.XMLTYPE;
      LXOPERATOR          SYS.XMLTYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LXKEYWORDID         := XMLTYPE.CREATEXML(ASKEYWORDID);
      LXKEYWORDVALUE      := XMLTYPE.CREATEXML(ASKEYWORDVALUE);
      LXKEYWORDVALUELIST  := XMLTYPE.CREATEXML(ASKEYWORDVALUELIST);
      LXKEYWORDTYPE       := XMLTYPE.CREATEXML(ASKEYWORDTYPE);
      LXOPERATOR          := XMLTYPE.CREATEXML(ASOPERATOR);

      LNRETVAL:=CREATEKEYWORDFILTER(ANFILTERID ,
                                    ANARRAY    ,
                                    ANKEYWORDNO,
                                    LXKEYWORDID  ,
                                    LXKEYWORDVALUE ,
                                    LXKEYWORDVALUELIST ,
                                    LXKEYWORDTYPE,
                                    LXOPERATOR);


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
   END CREATEKEYWORDFILTER;


   FUNCTION CREATEKEYWORDFILTER(
      ANFILTERID                 IN       IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ANKEYWORDNO                IN       IAPITYPE.NUMVAL_TYPE,
      AXKEYWORDID                IN       IAPITYPE.XMLTYPE_TYPE,
      AXKEYWORDVALUE             IN       IAPITYPE.XMLTYPE_TYPE,
      AXKEYWORDVALUELIST         IN       IAPITYPE.XMLTYPE_TYPE,
      AXKEYWORDTYPE              IN       IAPITYPE.XMLTYPE_TYPE,
      AXOPERATOR                 IN       IAPITYPE.XMLTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                 IAPITYPE.METHOD_TYPE := 'CreateKeywordFilter (1)';
      LNCURSOR                 IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                 IAPITYPE.ERRORNUM_TYPE;
      
      LXPATHLISTID             IAPITYPE.STRING_TYPE := '/keywords/id';
      LXPATHLISTVALUE          IAPITYPE.STRING_TYPE := '/keywords/value';
      LXPATHLISTVALUELIST      IAPITYPE.STRING_TYPE := '/keywords/valuelist';
      LXPATHLISTTYPE           IAPITYPE.STRING_TYPE := '/keywords/type';
      LXPATHLISTOPERATOR       IAPITYPE.STRING_TYPE := '/keywords/operator';

      LTKEYWORDID              IAPITYPE.NUMBERTAB_TYPE;
      LTKEYWORDVALUE           IAPITYPE.CHARTAB_TYPE;
      LTKEYWORDVALUELIST       IAPITYPE.CHARTAB_TYPE;
      LTKEYWORDTYPE            IAPITYPE.CHARTAB_TYPE;
      LTOPERATOR               IAPITYPE.CHARTAB_TYPE;
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
                           
      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDID, LXPATHLISTID))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTID) || '[' || INDX || ']' ) 
            INTO LTKEYWORDID(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDID, '/'))) T
          ) R;
      END LOOP;


      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDVALUE, LXPATHLISTVALUE))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTVALUE) || '[' || INDX || ']' ) 
            INTO LTKEYWORDVALUE(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDVALUE, '/'))) T
          ) R;
      END LOOP;


      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDVALUELIST, LXPATHLISTVALUELIST))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTVALUELIST) || '[' || INDX || ']' ) 
            INTO LTKEYWORDVALUELIST(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDVALUELIST, '/'))) T
          ) R;
      END LOOP;

      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDTYPE, LXPATHLISTTYPE))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTTYPE) || '[' || INDX || ']' ) 
            INTO LTKEYWORDTYPE(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXKEYWORDTYPE, '/'))) T
          ) R;
      END LOOP;

      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXOPERATOR, LXPATHLISTOPERATOR))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTOPERATOR) || '[' || INDX || ']' ) 
            INTO LTOPERATOR(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXOPERATOR, '/'))) T
          ) R;
      END LOOP;

      LNRETVAL:=CREATEKEYWORDFILTER(ANFILTERID,
                                    ANARRAY ,
                                    ANKEYWORDNO ,
                                    LTKEYWORDID,
                                    LTKEYWORDVALUE,
                                    LTKEYWORDVALUELIST,
                                    LTKEYWORDTYPE,
                                    LTOPERATOR);
      
      
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

   END  CREATEKEYWORDFILTER;

   
   FUNCTION CREATEKEYWORDFILTER(
      ANFILTERID                 IN       IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ANKEYWORDNO                IN       IAPITYPE.NUMVAL_TYPE,
      ATKEYWORDID                IN       IAPITYPE.NUMBERTAB_TYPE,
      ATKEYWORDVALUE             IN       IAPITYPE.CHARTAB_TYPE,
      ATKEYWORDVALUELIST         IN       IAPITYPE.CHARTAB_TYPE,
      ATKEYWORDTYPE              IN       IAPITYPE.CHARTAB_TYPE,
      ATOPERATOR                 IN       IAPITYPE.CHARTAB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateKeyWordFilter';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   IAPITYPE.BUFFER_TYPE;
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LTKEYWORDVALUE                IAPITYPE.CHARTAB_TYPE;
      LTKEYWORDVALUELIST            IAPITYPE.CHARTAB_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LTKEYWORDVALUE := ATKEYWORDVALUE;
      LTKEYWORDVALUELIST := ATKEYWORDVALUELIST;

      BEGIN
         DELETE FROM ITKWFLT
               WHERE FILTER_ID = ANFILTERID
                 AND KW_NO = ANKEYWORDNO;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LNCOUNTER IN 1 .. ANARRAY
      LOOP
         IF LTKEYWORDVALUE( LNCOUNTER ) = '?#?#?'
         THEN
            LTKEYWORDVALUE( LNCOUNTER ) := NULL;
         END IF;

         IF LTKEYWORDVALUELIST( LNCOUNTER ) = '?#?#?'
         THEN
            LTKEYWORDVALUELIST( LNCOUNTER ) := NULL;
         END IF;

         LSSQLSTRING :=
               'INSERT INTO itkwflt (filter_id, kw_id, kw_no, kw_value, kw_value_list, kw_type, operator)'
            || 'VALUES ('
            || ANFILTERID
            || ','
            || ATKEYWORDID( LNCOUNTER )
            || ','
            || ANKEYWORDNO
            || ','''
            || LTKEYWORDVALUE( LNCOUNTER )
            || ''','''
            || LTKEYWORDVALUELIST( LNCOUNTER )
            || ''','
            || ATKEYWORDTYPE( LNCOUNTER )
            || ','''
            || ATOPERATOR( LNCOUNTER )
            || ''')';

         BEGIN
            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATEKEYWORDFILTER;


   
   
   FUNCTION CREATESPECIFICATIONFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      AXCOLUMN                   IN       IAPITYPE.XMLTYPE_TYPE,
      AXOPERATOR                 IN       IAPITYPE.XMLTYPE_TYPE,
      AXVALUECHAR                IN       IAPITYPE.XMLTYPE_TYPE,
      AXVALUEDATE                IN       IAPITYPE.XMLTYPE_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ANOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE,
      ANOPTIONS                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

      
      
      
      
       
      
      
      
      
       
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateSpecificationFilter (1)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
      LSNLSPARAMETERVALUE           IAPITYPE.STRING_TYPE;
      
      LXPATHLISTCOLUMN              IAPITYPE.STRING_TYPE := '/columns/columnname';
      LXPATHLISTOPERATOR            IAPITYPE.STRING_TYPE := '/operators/operator';
      LXPATHLISTVALUECHAR           IAPITYPE.STRING_TYPE := '/valuechar/stopword';
      LXPATHLISTVALUEDATE           IAPITYPE.STRING_TYPE := '/valuedate/stopword';

      LTCOLUMN      IAPITYPE.CHARTAB_TYPE;
      LTOPERATOR    IAPITYPE.CHARTAB_TYPE;
      LTVALUECHAR   IAPITYPE.CHARTAB_TYPE;
      LTVALUEDATE   IAPITYPE.DATETAB_TYPE;
      
      LSVALUEDATE    IAPITYPE.STRING_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXCOLUMN, LXPATHLISTCOLUMN))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
          
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTCOLUMN) || '[' || INDX || ']' ) 
            INTO LTCOLUMN(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXCOLUMN, '/'))) T
          ) R;

      END LOOP;
      
      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXOPERATOR, LXPATHLISTOPERATOR))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTOPERATOR) || '[' || INDX || ']' ) 
            INTO LTOPERATOR(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXOPERATOR, '/'))) T
          ) R;

      END LOOP;
      
      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXVALUECHAR, LXPATHLISTVALUECHAR))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTVALUECHAR) || '[' || INDX || ']' ) 
            INTO LTVALUECHAR(INDX)               
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXVALUECHAR, '/'))) T
          ) R;

      END LOOP;
      
      
      
      
      SELECT COUNT(*) INTO LNCURSOR FROM 
      (
        SELECT VALUE(T) REPORT 
          FROM TABLE(XMLSEQUENCE(EXTRACT(AXVALUEDATE, LXPATHLISTVALUEDATE))) T 
      ) R;
      FOR INDX IN 1..LNCURSOR
      LOOP
      
          SELECT EXTRACTVALUE(R.REPORT, LOWER(LXPATHLISTVALUEDATE) || '[' || INDX || ']' ) 
            INTO LSVALUEDATE 
          FROM 
          (
           SELECT VALUE(T) REPORT 
               FROM TABLE(XMLSEQUENCE(EXTRACT(AXVALUEDATE, '/'))) T
          ) R;
          
          LTVALUEDATE(INDX) := TO_DATE(LSVALUEDATE, 'YYYYMMDD');
          

      END LOOP;
      
      LNRETVAL:=CREATESPECIFICATIONFILTER(ANFILTERID,
                                          ANARRAY,
                                          LTCOLUMN,
                                          LTOPERATOR,
                                          LTVALUECHAR, 
                                          LTVALUEDATE, 
                                          ASSORTDESC,
                                          ASCOMMENT,
                                          ANOVERWRITE,
                                          ANOPTIONS);
      
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
   END CREATESPECIFICATIONFILTER;
          

  FUNCTION CREATESPECIFICATIONFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ASCOLUMN                   IN       IAPITYPE.STRING_TYPE,
      ASOPERATOR                 IN       IAPITYPE.STRING_TYPE,
      ASVALUECHAR                IN       IAPITYPE.STRING_TYPE,
      ASVALUEDATE                IN       IAPITYPE.STRING_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ANOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE,
      ANOPTIONS                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

      
      
      
      

      
      
      
      

      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateSpecificationFilter (2)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      LXCOLUMN         SYS.XMLTYPE;
      LXOPERATOR       SYS.XMLTYPE;
      LXVALUECHAR      SYS.XMLTYPE;
      LXVALUEDATE      SYS.XMLTYPE;


   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LXCOLUMN    := XMLTYPE.CREATEXML(ASCOLUMN);
      LXOPERATOR  := XMLTYPE.CREATEXML(ASOPERATOR);
      LXVALUECHAR := XMLTYPE.CREATEXML(ASVALUECHAR);
      LXVALUEDATE := XMLTYPE.CREATEXML(ASVALUEDATE);

      LNRETVAL:=CREATESPECIFICATIONFILTER(ANFILTERID,
                                          ANARRAY,
                                          LXCOLUMN,
                                          LXOPERATOR,
                                          LXVALUECHAR,
                                          LXVALUEDATE,
                                          ASSORTDESC,
                                          ASCOMMENT,
                                          ANOVERWRITE,
                                          ANOPTIONS);


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
   END CREATESPECIFICATIONFILTER;
   
FUNCTION CREATESPECIFICATIONFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ATCOLUMN                   IN       IAPITYPE.CHARTAB_TYPE,
      ATOPERATOR                 IN       IAPITYPE.CHARTAB_TYPE,
      ATVALUECHAR                IN       IAPITYPE.CHARTAB_TYPE,
      ATVALUEDATE                IN       IAPITYPE.DATETAB_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ANOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE,
      ANOPTIONS                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateSpecificationFilter';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   IAPITYPE.BUFFER_TYPE;
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LNFILTERID                    IAPITYPE.FILTERID_TYPE;

      CURSOR L_COLUMN_CURSOR
      IS
         SELECT COLUMN_NAME
           FROM DBA_TAB_COLUMNS
          WHERE TABLE_NAME = 'ITSHFLT';

      CURSOR L_OPERATOR_CURSOR
      IS
         SELECT COLUMN_NAME
           FROM DBA_TAB_COLUMNS
          WHERE TABLE_NAME = 'ITSHFLTOP';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNFILTERID := ANFILTERID;

      IF ANOVERWRITE = 1
      THEN
         BEGIN
            UPDATE ITSHFLTD
               SET SORT_DESC = ASSORTDESC,
                   DESCRIPTION = ASCOMMENT,
                   OPTIONS = ANOPTIONS
             WHERE FILTER_ID = ANFILTERID;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      ELSE
         BEGIN
            SELECT SHFLT_SEQ.NEXTVAL
              INTO LNFILTERID
              FROM DUAL;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;

         ANFILTERID := LNFILTERID;

         BEGIN
            INSERT INTO ITSHFLTD
                        ( FILTER_ID,
                          USER_ID,
                          SORT_DESC,
                          DESCRIPTION,
                          OPTIONS )
                 VALUES ( LNFILTERID,
                          USER,
                          ASSORTDESC,
                          ASCOMMENT,
                          ANOPTIONS );

            INSERT INTO ITSHFLT
                        ( FILTER_ID )
                 VALUES ( LNFILTERID );

            INSERT INTO ITSHFLTOP
                        ( FILTER_ID )
                 VALUES ( LNFILTERID );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LNROW IN L_COLUMN_CURSOR
      LOOP
         IF LNROW.COLUMN_NAME <> 'FILTER_ID'
         THEN
            LSSQLSTRING :=    'UPDATE itshflt SET '
                           || LNROW.COLUMN_NAME
                           || ' = NULL WHERE filter_id = '
                           || LNFILTERID;

            BEGIN
               DBMS_SQL.PARSE( LNCURSOR,
                               LSSQLSTRING,
                               DBMS_SQL.V7 );
               LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;

            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LNROW IN L_OPERATOR_CURSOR
      LOOP
         IF LNROW.COLUMN_NAME <> 'FILTER_ID'
         THEN
            LSSQLSTRING :=    'UPDATE itshfltop SET '
                           || LNROW.COLUMN_NAME
                           || ' = NULL WHERE filter_id = '
                           || LNFILTERID;

            BEGIN
               DBMS_SQL.PARSE( LNCURSOR,
                               LSSQLSTRING,
                               DBMS_SQL.V7 );
               LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;

            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LNCOUNTER IN 1 .. ANARRAY
      LOOP
         IF ATCOLUMN( LNCOUNTER ) IN
               ( 'PHASE_IN_DATE',
                 'PLANNED_EFFECTIVE_DATE',
                 'ISSUED_DATE',
                 'OBSOLESCENCE_DATE',
                 'CHANGED_DATE',
                 'STATUS_CHANGE_DATE',
                 'LAST_MODIFIED_ON',
                 'CREATED_ON' )
         THEN
            LSSQLSTRING :=
                            'UPDATE itshflt SET '
                         || ATCOLUMN( LNCOUNTER )
                         || ' = '''
                         || ATVALUEDATE( LNCOUNTER )
                         || ''' WHERE filter_id = '
                         || LNFILTERID;
         ELSE
            LSSQLSTRING :=
                            'UPDATE itshflt SET '
                         || ATCOLUMN( LNCOUNTER )
                         || ' = '''
                         || ATVALUECHAR( LNCOUNTER )
                         || ''' WHERE filter_id = '
                         || LNFILTERID;
         END IF;

         BEGIN
            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LNCOUNTER IN 1 .. ANARRAY
      LOOP
         LSSQLSTRING :=
                'UPDATE itshfltop SET LOG_'
             || ATCOLUMN( LNCOUNTER )
             || ' = Lower('''
             || ATOPERATOR( LNCOUNTER )
             || ''') WHERE filter_id = '
             || LNFILTERID;

         BEGIN
            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATESPECIFICATIONFILTER;


END IAPISPECIFICATIONFILTER;