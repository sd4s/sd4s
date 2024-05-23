    1 PACKAGE BODY iapiDeletion
    2 AS
    3    
    4    
    5    
    6    
    7    
    8    
    9    
   10    
   11    
   12    
   13    
   14    
   15    
   16    
   17    
   18    
   19    
   20    
   21 
   22    
   23    FUNCTION GETPACKAGEVERSION
   24       RETURN IAPITYPE.STRING_TYPE
   25    IS
   26       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   27    BEGIN
   28       
   29       
   30       
   31        RETURN(    IAPIGENERAL.GETVERSION
   32               || ' ($Revision: 6.7.0.0 (06.07.00.00-01.00) $)' );
   33 
   34    EXCEPTION
   35       WHEN OTHERS
   36       THEN
   37          IAPIGENERAL.LOGERROR( GSSOURCE,
   38                                LSMETHOD,
   39                                SQLERRM );
   40          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   41    END GETPACKAGEVERSION;
   42 
   43    
   44    
   45    
   46 
   47    
   48    
   49    
   50    FUNCTION GETDAYSTODELETE(
   51       ASPARAMETER                IN       IAPITYPE.PARAMETER_TYPE,
   52       ANDAYS                     OUT      IAPITYPE.NUMVAL_TYPE )
   53       RETURN IAPITYPE.ERRORNUM_TYPE
   54    IS
   55       
   56       
   57       
   58       
   59       
   60       
   61       
   62       
   63       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDaysToDelete';
   64       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   65    BEGIN
   66       
   67       
   68       
   69       IAPIGENERAL.LOGINFO( GSSOURCE,
   70                            LSMETHOD,
   71                            'Body of FUNCTION',
   72                            IAPICONSTANT.INFOLEVEL_3 );
   73 
   74       SELECT TO_NUMBER( PARAMETER_DATA )
   75         INTO ANDAYS
   76         FROM INTERSPC_CFG
   77        WHERE SECTION = 'DELETION'
   78          AND PARAMETER = ASPARAMETER;
   79 
   80       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   81    EXCEPTION
   82       WHEN NO_DATA_FOUND
   83       THEN
   84          LNRETVAL :=
   85                 IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
   86                                                     LSMETHOD,
   87                                                     IAPICONSTANTDBERROR.DBERR_CONFIGPARAMVALUENOTFOUND,
   88                                                     ASPARAMETER,
   89                                                     'DELETION' );
   90          IAPIGENERAL.LOGERROR( GSSOURCE,
   91                                LSMETHOD,
   92                                IAPIGENERAL.GETLASTERRORTEXT( ) );
   93          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   94       WHEN OTHERS
   95       THEN
   96          IAPIGENERAL.LOGERROR( GSSOURCE,
   97                                LSMETHOD,
   98                                SQLERRM );
   99          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  100    END GETDAYSTODELETE;
  101 
  102    
  103    FUNCTION GETUSERDELETEDSPEC(
  104       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  105       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
  106       ADSTATUSCHANGEDATE         IN       IAPITYPE.DATE_TYPE,
  107       ASUSERID                   OUT      IAPITYPE.USERID_TYPE,
  108       ASFORENAME                 OUT      IAPITYPE.FORENAME_TYPE,
  109       ASLASTNAME                 OUT      IAPITYPE.LASTNAME_TYPE )
  110       RETURN IAPITYPE.ERRORNUM_TYPE
  111    IS
  112       
  113       
  114       
  115       
  116       
  117       
  118       
  119       
  120       
  121       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserDeletedSpec';
  122       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  123       LSUSERID                      IAPITYPE.USERID_TYPE;
  124       LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
  125       LDSTATUSCHANGEDATE            IAPITYPE.DATE_TYPE;
  126       LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
  127       
  128       LNCOUNT                       IAPITYPE.NUMVAL_TYPE;      
  129    BEGIN
  130       
  131       
  132       
  133       IAPIGENERAL.LOGINFO( GSSOURCE,
  134                            LSMETHOD,
  135                            'Body of FUNCTION',
  136                            IAPICONSTANT.INFOLEVEL_3 );
  137       LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );
  138 
  139       IF USER <> LSSCHEMANAME
  140       THEN
  141          BEGIN
  142             SELECT FORENAME,
  143                    LAST_NAME
  144               INTO ASFORENAME,
  145                    ASLASTNAME
  146               FROM ITUS
  147              WHERE USER_ID = USER;
  148          EXCEPTION
  149             WHEN NO_DATA_FOUND
  150             THEN
  151                ASFORENAME := 'user';
  152                ASLASTNAME := 'unknown';
  153          END;
  154 
  155          ASUSERID := USER;
  156          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  157       ELSE
  158          SELECT MAX( STATUS_DATE_TIME )
  159            INTO LDSTATUSCHANGEDATE
  160            FROM STATUS_HISTORY
  161           WHERE PART_NO = ASPARTNO
  162             AND REVISION = ANREVISION
  163             AND STATUS_DATE_TIME < ADSTATUSCHANGEDATE;
  164 
  165           
  166          
  167          
  168          
  169          
  170          
  171          
  172          
  173          
  174          
  175 
  176         
  177         
  178          SELECT COUNT(*)
  179            INTO LNCOUNT
  180            FROM STATUS_HISTORY SH,
  181                 STATUS SS
  182           WHERE SH.PART_NO = ASPARTNO
  183             AND SH.REVISION = ANREVISION
  184             AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
  185             AND SH.STATUS = SS.STATUS;
  186 
  187          IF (LNCOUNT = 1)
  188          THEN
  189          
  190 
  191              SELECT SS.STATUS_TYPE,
  192                     USER_ID
  193                INTO LSSTATUSTYPE,
  194                     LSUSERID
  195                FROM STATUS_HISTORY SH,
  196                     STATUS SS
  197               WHERE SH.PART_NO = ASPARTNO
  198                 AND SH.REVISION = ANREVISION
  199                 AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
  200                 AND SH.STATUS = SS.STATUS;
  201         
  202         ELSE              
  203               
  204              SELECT COUNT(*)
  205                INTO LNCOUNT
  206                FROM STATUS_HISTORY SH,
  207                     STATUS SS
  208               WHERE SH.PART_NO = ASPARTNO
  209                 AND SH.REVISION = ANREVISION
  210                 AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
  211                 AND SH.STATUS = SS.STATUS
  212                 AND SS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC;
  213              
  214              IF (LNCOUNT = 1)
  215              THEN
  216                  
  217                  SELECT SS.STATUS_TYPE,
  218                         USER_ID
  219                    INTO LSSTATUSTYPE,
  220                         LSUSERID
  221                    FROM STATUS_HISTORY SH,
  222                         STATUS SS
  223                   WHERE SH.PART_NO = ASPARTNO
  224                     AND SH.REVISION = ANREVISION
  225                     AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
  226                     AND SH.STATUS = SS.STATUS
  227                     AND SS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC;                
  228              ELSE
  229                    
  230                    SELECT USER_ID
  231                    INTO LSUSERID
  232                    FROM STATUS_HISTORY SH,
  233                         STATUS SS
  234                   WHERE SH.PART_NO = ASPARTNO
  235                     AND SH.REVISION = ANREVISION
  236                     AND SH.STATUS_DATE_TIME = LDSTATUSCHANGEDATE
  237                     AND SH.STATUS = SS.STATUS;                                      
  238              END IF;                              
  239         END IF;
  240         
  241 
  242          IF LSUSERID <> LSSCHEMANAME
  243          THEN
  244             BEGIN
  245                SELECT FORENAME,
  246                       LAST_NAME
  247                  INTO ASFORENAME,
  248                       ASLASTNAME
  249                  FROM ITUS
  250                 WHERE USER_ID = LSUSERID;
  251             EXCEPTION
  252                WHEN NO_DATA_FOUND
  253                THEN
  254                   ASFORENAME := 'user';
  255                   ASLASTNAME := 'unknown';
  256             END;
  257 
  258             ASUSERID := LSUSERID;
  259             RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  260          ELSIF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_HISTORIC
  261          THEN
  262             ASUSERID := LSUSERID;
  263             ASFORENAME := 'system';
  264             ASLASTNAME := 'user';
  265             RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  266          ELSE
  267             LNRETVAL := GETUSERDELETEDSPEC( ASPARTNO,
  268                                             ANREVISION,
  269                                             LDSTATUSCHANGEDATE,
  270                                             ASUSERID,
  271                                             ASFORENAME,
  272                                             ASLASTNAME );
  273             RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  274          END IF;
  275       END IF;
  276    EXCEPTION
  277       WHEN OTHERS
  278       THEN
  279          IAPIGENERAL.LOGERROR( GSSOURCE,
  280                                LSMETHOD,
  281                                SQLERRM );
  282          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  283    END GETUSERDELETEDSPEC;
  284 
  285    
  286    FUNCTION ISCURRENT(
  287       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  288       ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
  289       RETURN IAPITYPE.LOGICAL_TYPE
  290    IS
  291       
  292       
  293       
  294       
  295       
  296       
  297       LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
  298       LBCURRENT                     IAPITYPE.LOGICAL_TYPE := FALSE;
  299       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsCurrent';
  300    BEGIN
  301       SELECT COUNT( PART_NO )
  302         INTO LNCOUNT
  303         FROM SPECIFICATION_HEADER
  304        WHERE PLANNED_EFFECTIVE_DATE <= SYSDATE
  305          AND NVL( OBSOLESCENCE_DATE,
  306                   SYSDATE ) >= SYSDATE
  307          AND PART_NO = ASPARTNO
  308          AND REVISION = ANREVISION;
  309 
  310       IF LNCOUNT >= 1
  311       THEN
  312          LBCURRENT := TRUE;
  313       END IF;
  314 
  315       RETURN LBCURRENT;
  316    EXCEPTION
  317       WHEN OTHERS
  318       THEN
  319          IAPIGENERAL.LOGERROR( GSSOURCE,
  320                                LSMETHOD,
  321                                SQLERRM );
  322          RETURN TRUE;
  323    END ISCURRENT;
  324 
  325    
  326    FUNCTION EXISTINATTACHEDSPEC(
  327       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  328       ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
  329       RETURN IAPITYPE.LOGICAL_TYPE
  330    IS
  331       
  332       
  333       
  334       
  335       
  336       
  337 
  338       
  339       
  340       
  341       LBEXISTS                      IAPITYPE.LOGICAL_TYPE := FALSE;
  342       LSPARTNO                      IAPITYPE.PARTNO_TYPE;
  343       LSATTACHEDPARTNO              IAPITYPE.PARTNO_TYPE;
  344       LNREVISION                    IAPITYPE.REVISION_TYPE;
  345       LNATTACHEDREVISION            IAPITYPE.REVISION_TYPE;
  346       LESPECUSED                    EXCEPTION;
  347       LESPECUSEDASPHANTOM           EXCEPTION;
  348       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistInAttachedSpec';
  349 
  350       CURSOR C_SH_IN_ASH(
  351          ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
  352       IS
  353          SELECT   PART_NO,
  354                   REVISION,
  355                   ATTACHED_PART_NO,
  356                   ATTACHED_REVISION
  357              FROM ATTACHED_SPECIFICATION
  358             WHERE ATTACHED_PART_NO = ASPARTNO
  359          ORDER BY ATTACHED_REVISION;
  360    BEGIN
  361       OPEN C_SH_IN_ASH( ASPARTNO );
  362 
  363       FETCH C_SH_IN_ASH
  364        INTO LSPARTNO,
  365             LNREVISION,
  366             LSATTACHEDPARTNO,
  367             LNATTACHEDREVISION;
  368 
  369       WHILE C_SH_IN_ASH%FOUND
  370       LOOP
  371          IF LNATTACHEDREVISION = 0
  372          THEN
  373             
  374             IF ISLASTONE( ASPARTNO ) = 1
  375             THEN
  376                RAISE LESPECUSEDASPHANTOM;
  377             ELSE
  378                
  379                IF ISCURRENT( ASPARTNO,
  380                              ANREVISION ) = TRUE
  381                THEN
  382                   RAISE LESPECUSEDASPHANTOM;
  383                END IF;
  384             END IF;
  385          ELSIF LNATTACHEDREVISION = ANREVISION
  386          THEN
  387             RAISE LESPECUSED;
  388          ELSE
  389             LBEXISTS := LBEXISTS;
  390          END IF;
  391 
  392          FETCH C_SH_IN_ASH
  393           INTO LSPARTNO,
  394                LNREVISION,
  395                LSATTACHEDPARTNO,
  396                LNATTACHEDREVISION;
  397       END LOOP;
  398 
  399       CLOSE C_SH_IN_ASH;
  400 
  401       RETURN LBEXISTS;
  402    EXCEPTION
  403       WHEN LESPECUSEDASPHANTOM
  404       THEN
  405          IF C_SH_IN_ASH%ISOPEN
  406          THEN
  407             CLOSE C_SH_IN_ASH;
  408          END IF;
  409 
  410          RETURN TRUE;
  411       WHEN LESPECUSED
  412       THEN
  413          IF C_SH_IN_ASH%ISOPEN
  414          THEN
  415             CLOSE C_SH_IN_ASH;
  416          END IF;
  417 
  418          RETURN TRUE;
  419       WHEN OTHERS
  420       THEN
  421          IAPIGENERAL.LOGERROR( GSSOURCE,
  422                                LSMETHOD,
  423                                SQLERRM );
  424 
  425          IF C_SH_IN_ASH%ISOPEN
  426          THEN
  427             CLOSE C_SH_IN_ASH;
  428          END IF;
  429 
  430          RETURN TRUE;
  431    END EXISTINATTACHEDSPEC;
  432 
  433 
  434    FUNCTION EXISTINBOM(
  435       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  436       ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
  437       RETURN IAPITYPE.LOGICAL_TYPE
  438    IS
  439 
  440 
  441 
  442 
  443 
  444 
  445       LBEXISTS                      IAPITYPE.LOGICAL_TYPE := FALSE;
  446       LSPARTNO                      IAPITYPE.PARTNO_TYPE;
  447       LNREVISION                    IAPITYPE.REVISION_TYPE;
  448       LSCOMPONENTPARTNO             IAPITYPE.PARTNO_TYPE;
  449       LNCOMPONENTREVISION           IAPITYPE.REVISION_TYPE;
  450       LESPECUSED                    EXCEPTION;
  451       LESPECUSEDASPHANTOM           EXCEPTION;
  452       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistInBom';
  453 
  454       CURSOR C_SH_IN_BOM(
  455          ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
  456       IS
  457          SELECT   PART_NO,
  458                   REVISION,
  459                   COMPONENT_PART,
  460                   COMPONENT_REVISION
  461              FROM BOM_ITEM
  462             WHERE COMPONENT_PART = ASPARTNO
  463               AND ( PART_NO, REVISION ) NOT IN( SELECT PART_NO,
  464                                                        REVISION
  465                                                  FROM BOM_ITEM
  466                                                 WHERE COMPONENT_PART = ASPARTNO
  467                                                   AND PART_NO = ASPARTNO
  468                                                   AND REVISION = ANREVISION )
  469          ORDER BY COMPONENT_REVISION;
  470    BEGIN
  471       OPEN C_SH_IN_BOM( ASPARTNO );
  472 
  473       FETCH C_SH_IN_BOM
  474        INTO LSPARTNO,
  475             LNREVISION,
  476             LSCOMPONENTPARTNO,
  477             LNCOMPONENTREVISION;
  478 
  479       WHILE C_SH_IN_BOM%FOUND
  480       LOOP
  481          IF LNCOMPONENTREVISION IS NULL
  482          THEN
  483             
  484             IF ISLASTONE( ASPARTNO ) = 1
  485             THEN
  486                RAISE LESPECUSEDASPHANTOM;
  487             ELSE
  488                
  489                IF ISCURRENT( ASPARTNO,
  490                              ANREVISION ) = TRUE
  491                THEN
  492                   
  493                   RAISE LESPECUSEDASPHANTOM;
  494                END IF;
  495             END IF;
  496          ELSIF LNCOMPONENTREVISION = ANREVISION
  497          THEN
  498             RAISE LESPECUSED;
  499          ELSE
  500             LBEXISTS := LBEXISTS;
  501          END IF;
  502 
  503          FETCH C_SH_IN_BOM
  504           INTO LSPARTNO,
  505                LNREVISION,
  506                LSCOMPONENTPARTNO,
  507                LNCOMPONENTREVISION;
  508       END LOOP;
  509 
  510       CLOSE C_SH_IN_BOM;
  511 
  512       RETURN LBEXISTS;
  513    EXCEPTION
  514       WHEN LESPECUSEDASPHANTOM
  515       THEN
  516          
  517          IF C_SH_IN_BOM%ISOPEN
  518          THEN
  519             CLOSE C_SH_IN_BOM;
  520          END IF;
  521 
  522          RETURN TRUE;
  523       WHEN LESPECUSED
  524       THEN
  525          
  526          IF C_SH_IN_BOM%ISOPEN
  527          THEN
  528             CLOSE C_SH_IN_BOM;
  529          END IF;
  530 
  531          RETURN TRUE;
  532       WHEN OTHERS
  533       THEN
  534          IAPIGENERAL.LOGERROR( GSSOURCE,
  535                                LSMETHOD,
  536                                SQLERRM );
  537 
  538          IF C_SH_IN_BOM%ISOPEN
  539          THEN
  540             CLOSE C_SH_IN_BOM;
  541          END IF;
  542 
  543          RETURN TRUE;
  544    END EXISTINBOM;
  545 
  546    
  547    FUNCTION SETSPECOBSOLETE(
  548       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  549       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
  550       ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE,
  551       ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE )
  552       RETURN IAPITYPE.NUMVAL_TYPE
  553    IS
  554       
  555       
  556       
  557       
  558       
  559       
  560       
  561       
  562       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  563       LNWORKFLOWID                  IAPITYPE.ID_TYPE;
  564       LNWORKFLOWID_2                IAPITYPE.ID_TYPE;
  565       LNNEXTSTATUS                  IAPITYPE.ID_TYPE;
  566       LNNEXTSTATUS_2                IAPITYPE.ID_TYPE;
  567       LEUNIQUEWORKFLOW              EXCEPTION;
  568       LEUNIQUESTATUS                EXCEPTION;
  569       LEWORKFLOWNOTFOUND            EXCEPTION;
  570       LENEXTSTATUSNOTFOUND          EXCEPTION;
  571       LQERRORS                      IAPITYPE.REF_TYPE;
  572       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetSpecObsolete';
  573 
  574       CURSOR C_WORKFLOW(
  575          ANWORKFLOWGROUPID          IN       IAPITYPE.WORKFLOWGROUPID_TYPE )
  576       IS
  577          SELECT WORK_FLOW_ID
  578            FROM WORKFLOW_GROUP
  579           WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID;
  580 
  581       CURSOR C_NEXTSTATUS(
  582          ANWORKFLOWID               IN       IAPITYPE.WORKFLOWID_TYPE,
  583          ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE )
  584       IS
  585          SELECT NEXT_STATUS
  586            FROM WORK_FLOW A,
  587                 STATUS B,
  588                 STATUS C
  589           WHERE A.STATUS = B.STATUS
  590             AND A.NEXT_STATUS = C.STATUS
  591             AND C.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE
  592             AND WORK_FLOW_ID = ANWORKFLOWID
  593             AND A.STATUS = ANSTATUS;
  594    BEGIN
  595       OPEN C_WORKFLOW( ANWORKFLOWGROUPID );
  596 
  597       FETCH C_WORKFLOW
  598        INTO LNWORKFLOWID;
  599 
  600       IF C_WORKFLOW%FOUND
  601       THEN
  602          FETCH C_WORKFLOW
  603           INTO LNWORKFLOWID_2;
  604 
  605          IF C_WORKFLOW%FOUND
  606          THEN
  607             RAISE LEUNIQUEWORKFLOW;
  608          ELSE
  609             OPEN C_NEXTSTATUS( LNWORKFLOWID,
  610                                ANSTATUS );
  611 
  612             FETCH C_NEXTSTATUS
  613              INTO LNNEXTSTATUS;
  614 
  615             IF C_NEXTSTATUS%FOUND
  616             THEN
  617                FETCH C_NEXTSTATUS
  618                 INTO LNNEXTSTATUS_2;
  619 
  620                IF C_NEXTSTATUS%FOUND
  621                THEN
  622                   RAISE LEUNIQUESTATUS;
  623                ELSE
  624                   
  625                   
  626                   
  627                   UPDATE SPECIFICATION_HEADER
  628                      SET STATUS = LNNEXTSTATUS,
  629                          STATUS_CHANGE_DATE = SYSDATE
  630                    WHERE PART_NO = ASPARTNO
  631                      AND REVISION = ANREVISION
  632                      AND STATUS = ANSTATUS;
  633 
  634                   UPDATE PART
  635                      SET CHANGED_DATE = SYSDATE
  636                    WHERE PART_NO = ASPARTNO;
  637 
  638                   INSERT INTO STATUS_HISTORY
  639                               ( PART_NO,
  640                                 REVISION,
  641                                 STATUS,
  642                                 STATUS_DATE_TIME,
  643                                 USER_ID,
  644                                 SORT_SEQ,
  645                                 FORENAME,
  646                                 LAST_NAME )
  647                        VALUES ( ASPARTNO,
  648                                 ANREVISION,
  649                                 LNNEXTSTATUS,
  650                                 SYSDATE,
  651                                 IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
  652                                 STATUS_HISTORY_SEQ.NEXTVAL,
  653                                 IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
  654                                 IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );
  655 
  656                   LNRETVAL := IAPIEMAIL.REGISTEREMAIL( ASPARTNO,
  657                                                        ANREVISION,
  658                                                        LNNEXTSTATUS,
  659                                                        SYSDATE,
  660                                                        'S',
  661                                                        NULL,
  662                                                        NULL,
  663                                                        LQERRORS );
  664 
  665                   IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
  666                   THEN
  667                      IAPIGENERAL.LOGERROR( GSSOURCE,
  668                                            LSMETHOD,
  669                                            IAPIGENERAL.GETLASTERRORTEXT( ) );
  670 
  671                      IF C_WORKFLOW%ISOPEN
  672                      THEN
  673                         CLOSE C_WORKFLOW;
  674                      END IF;
  675 
  676                      IF C_NEXTSTATUS%ISOPEN
  677                      THEN
  678                         CLOSE C_NEXTSTATUS;
  679                      END IF;
  680 
  681                      ROLLBACK;
  682                      RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  683                   END IF;
  684 
  685                   COMMIT;
  686                END IF;
  687             ELSE
  688                RAISE LENEXTSTATUSNOTFOUND;
  689             END IF;
  690 
  691             CLOSE C_NEXTSTATUS;
  692          END IF;
  693       ELSE
  694          RAISE LEWORKFLOWNOTFOUND;
  695       END IF;
  696 
  697       IF C_WORKFLOW%ISOPEN
  698       THEN
  699          CLOSE C_WORKFLOW;
  700       END IF;
  701 
  702       IF C_NEXTSTATUS%ISOPEN
  703       THEN
  704          CLOSE C_NEXTSTATUS;
  705       END IF;
  706 
  707       RETURN 0;
  708    EXCEPTION
  709       WHEN LEUNIQUEWORKFLOW
  710       THEN
  711          ROLLBACK;
  712 
  713          IF C_WORKFLOW%ISOPEN
  714          THEN
  715             CLOSE C_WORKFLOW;
  716          END IF;
  717 
  718          IF C_NEXTSTATUS%ISOPEN
  719          THEN
  720             CLOSE C_NEXTSTATUS;
  721          END IF;
  722 
  723          IAPIGENERAL.LOGWARNING( GSSOURCE,
  724                                  LSMETHOD,
  725                                  'More than one Workflow fetched' );
  726          RETURN LNRETVAL;
  727       WHEN LEUNIQUESTATUS
  728       THEN
  729          ROLLBACK;
  730 
  731          IF C_WORKFLOW%ISOPEN
  732          THEN
  733             CLOSE C_WORKFLOW;
  734          END IF;
  735 
  736          IF C_NEXTSTATUS%ISOPEN
  737          THEN
  738             CLOSE C_NEXTSTATUS;
  739          END IF;
  740 
  741          IAPIGENERAL.LOGWARNING( GSSOURCE,
  742                                  LSMETHOD,
  743                                  'More than one Status for obsolete fetched' );
  744          RETURN LNRETVAL;
  745       WHEN LEWORKFLOWNOTFOUND
  746       THEN
  747          ROLLBACK;
  748 
  749          IF C_WORKFLOW%ISOPEN
  750          THEN
  751             CLOSE C_WORKFLOW;
  752          END IF;
  753 
  754          IF C_NEXTSTATUS%ISOPEN
  755          THEN
  756             CLOSE C_NEXTSTATUS;
  757          END IF;
  758 
  759          IAPIGENERAL.LOGWARNING( GSSOURCE,
  760                                  LSMETHOD,
  761                                  'Workflow not found' );
  762          RETURN LNRETVAL;
  763       WHEN LENEXTSTATUSNOTFOUND
  764       THEN
  765          ROLLBACK;
  766 
  767          IF C_WORKFLOW%ISOPEN
  768          THEN
  769             CLOSE C_WORKFLOW;
  770          END IF;
  771 
  772          IF C_NEXTSTATUS%ISOPEN
  773          THEN
  774             CLOSE C_NEXTSTATUS;
  775          END IF;
  776 
  777          IAPIGENERAL.LOGWARNING( GSSOURCE,
  778                                  LSMETHOD,
  779                                     'Next status not found of type = OBSOLETE for part '
  780                                  || ASPARTNO );
  781          RETURN LNRETVAL;
  782       WHEN OTHERS
  783       THEN
  784          IAPIGENERAL.LOGWARNING( GSSOURCE,
  785                                  LSMETHOD,
  786                                  SQLERRM );
  787 
  788          IF C_WORKFLOW%ISOPEN
  789          THEN
  790             CLOSE C_WORKFLOW;
  791          END IF;
  792 
  793          IF C_NEXTSTATUS%ISOPEN
  794          THEN
  795             CLOSE C_NEXTSTATUS;
  796          END IF;
  797 
  798          ROLLBACK;
  799          RETURN LNRETVAL;
  800    END SETSPECOBSOLETE;
  801 
  802    
  803    FUNCTION DELETESPECIFICATION(
  804       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  805       ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
  806       RETURN IAPITYPE.NUMVAL_TYPE
  807    IS
  808       
  809       
  810       
  811       
  812       
  813       
  814       
  815       
  816 
  817       
  818        
  819        
  820        
  821        
  822        
  823        
  824        
  825        
  826        
  827        
  828        
  829        
  830        
  831        
  832        
  833        
  834        
  835        
  836        
  837        
  838        
  839        
  840        
  841        
  842        
  843        
  844        
  845        
  846        
  847        
  848        
  849        
  850        
  851        
  852       
  853       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  854       LNSPECIFCATIONCOUNT           IAPITYPE.NUMVAL_TYPE := 0;
  855       LNSTATUS                      IAPITYPE.STATUSID_TYPE;
  856       LSUSERID                      IAPITYPE.USERID_TYPE;
  857       LSFORENAME                    IAPITYPE.FORENAME_TYPE;
  858       LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
  859       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteSpecification';
  860    BEGIN
  861       
  862       
  863       IF EXISTINBOM( ASPARTNO,
  864                      ANREVISION ) = FALSE
  865       THEN
  866          
  867          IF EXISTINATTACHEDSPEC( ASPARTNO,
  868                                  ANREVISION ) = FALSE
  869          THEN
  870             SELECT STATUS
  871               INTO LNSTATUS
  872               FROM SPECIFICATION_HEADER
  873              WHERE PART_NO = ASPARTNO
  874                AND REVISION = ANREVISION;
  875 
  876             LNRETVAL := GETUSERDELETEDSPEC( ASPARTNO,
  877                                             ANREVISION,
  878                                             SYSDATE,
  879                                             LSUSERID,
  880                                             LSFORENAME,
  881                                             LSLASTNAME );
  882 
  883             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
  884             THEN
  885                IAPIGENERAL.LOGERROR( GSSOURCE,
  886                                      LSMETHOD,
  887                                      SQLERRM );
  888                ROLLBACK;
  889                RETURN LNRETVAL;
  890             END IF;
  891 
  892             DELETE FROM SPECDATA_SERVER
  893                   WHERE PART_NO = ASPARTNO
  894                     AND REVISION = ANREVISION;
  895 
  896             DELETE FROM SPECDATA
  897                   WHERE PART_NO = ASPARTNO
  898                     AND REVISION = ANREVISION;
  899 
  900             DELETE FROM SPECIFICATION_LINE_TEXT
  901                   WHERE PART_NO = ASPARTNO
  902                     AND REVISION = ANREVISION;
  903 
  904             DELETE FROM SPECIFICATION_LINE
  905                   WHERE PART_NO = ASPARTNO
  906                     AND REVISION = ANREVISION;
  907 
  908             DELETE FROM SPECIFICATION_STAGE
  909                   WHERE PART_NO = ASPARTNO
  910                     AND REVISION = ANREVISION;
  911 
  912             DELETE FROM SPECIFICATION_LINE_PROP
  913                   WHERE PART_NO = ASPARTNO
  914                     AND REVISION = ANREVISION;
  915 
  916             DELETE FROM ITSHLNPROPLANG
  917                   WHERE PART_NO = ASPARTNO
  918                     AND REVISION = ANREVISION;
  919 
  920             DELETE FROM SPECIFICATION_TEXT
  921                   WHERE PART_NO = ASPARTNO
  922                     AND REVISION = ANREVISION;
  923 
  924             DELETE FROM SPECIFICATION_SECTION
  925                   WHERE PART_NO = ASPARTNO
  926                     AND REVISION = ANREVISION;
  927 
  928             DELETE FROM SPECIFICATION_PROP
  929                   WHERE PART_NO = ASPARTNO
  930                     AND REVISION = ANREVISION;
  931 
  932             DELETE FROM SPECIFICATION_PROP_LANG
  933                   WHERE PART_NO = ASPARTNO
  934                     AND REVISION = ANREVISION;
  935 
  936             DELETE FROM BOM_ITEM
  937                   WHERE PART_NO = ASPARTNO
  938                     AND REVISION = ANREVISION;
  939 
  940             DELETE FROM BOM_HEADER
  941                   WHERE PART_NO = ASPARTNO
  942                     AND REVISION = ANREVISION;
  943 
  944             DELETE FROM ATTACHED_SPECIFICATION
  945                   WHERE PART_NO = ASPARTNO
  946                     AND REVISION = ANREVISION;
  947 
  948             DELETE FROM USERS_APPROVED
  949                   WHERE PART_NO = ASPARTNO
  950                     AND REVISION = ANREVISION;
  951 
  952             DELETE FROM REASON
  953                   WHERE PART_NO = ASPARTNO
  954                     AND REVISION = ANREVISION;
  955 
  956             DELETE FROM STATUS_HISTORY
  957                   WHERE PART_NO = ASPARTNO
  958                     AND REVISION = ANREVISION;
  959 
  960             DELETE FROM APPROVAL_HISTORY
  961                   WHERE PART_NO = ASPARTNO
  962                     AND REVISION = ANREVISION;
  963 
  964             DELETE FROM ITSHVALD
  965                   WHERE PART_NO = ASPARTNO
  966                     AND REVISION = ANREVISION;
  967 
  968             DELETE FROM ITBOMJRNL
  969                   WHERE PART_NO = ASPARTNO
  970                     AND REVISION = ANREVISION;
  971 
  972             DELETE FROM JRNL_SPECIFICATION_HEADER
  973                   WHERE PART_NO = ASPARTNO
  974                     AND REVISION = ANREVISION;
  975 
  976             DELETE FROM SPECIFICATION_ING
  977                   WHERE PART_NO = ASPARTNO
  978                     AND REVISION = ANREVISION;
  979 
  980             
  981             DELETE FROM ITSPECINGALLERGEN
  982                   WHERE PART_NO = ASPARTNO
  983                     AND REVISION = ANREVISION;            
  984             
  985 
  986             
  987             DELETE FROM ITSPECINGDETAIL
  988                   WHERE PART_NO = ASPARTNO
  989                     AND REVISION = ANREVISION;            
  990             
  991             
  992             DELETE FROM ITSHBN
  993                   WHERE PART_NO = ASPARTNO
  994                     AND REVISION = ANREVISION;
  995 
  996             DELETE FROM ITCMPPARTS
  997                   WHERE PART_NO = ASPARTNO
  998                     AND REVISION = ANREVISION;
  999 
 1000             DELETE FROM ITSHDESCR_L
 1001                   WHERE PART_NO = ASPARTNO
 1002                     AND REVISION = ANREVISION;
 1003 
 1004             DELETE FROM ITLABELLOG
 1005                   WHERE PART_NO = ASPARTNO
 1006                     AND REVISION = ANREVISION;
 1007 
 1008             DELETE FROM ITSHLY
 1009                   WHERE ( LY_ID, LY_TYPE, DISPLAY_FORMAT ) IN( SELECT LY_ID,
 1010                                                                       1,
 1011                                                                       DISPLAY_FORMAT
 1012                                                                 FROM ITSHLY
 1013                                                               MINUS
 1014                                                               SELECT DISTINCT REF_ID,
 1015                                                                               1,
 1016                                                                               DISPLAY_FORMAT
 1017                                                                          FROM SPECIFICATION_SECTION
 1018                                                                         WHERE TYPE IN( 1, 4 ) )
 1019                     AND LY_TYPE = 1;
 1020 
 1021             DELETE FROM ITSHLY
 1022                   WHERE ( LY_ID, LY_TYPE, DISPLAY_FORMAT ) IN( SELECT LY_ID,
 1023                                                                       2,
 1024                                                                       DISPLAY_FORMAT
 1025                                                                 FROM ITSHLY
 1026                                                               MINUS
 1027                                                               SELECT DISTINCT STAGE,
 1028                                                                               2,
 1029                                                                               DISPLAY_FORMAT
 1030                                                                          FROM SPECIFICATION_STAGE )
 1031                     AND LY_TYPE = 2;
 1032 
 1033             DELETE FROM ITSCHS
 1034                   WHERE PART_NO = ASPARTNO
 1035                     AND REVISION = ANREVISION;
 1036 
 1037             DELETE FROM ITSHEXT
 1038                   WHERE PART_NO = ASPARTNO
 1039                     AND REVISION = ANREVISION;
 1040 
 1041             DELETE FROM ITSHHS
 1042                   WHERE PART_NO = ASPARTNO
 1043                     AND REVISION = ANREVISION;
 1044 
 1045             DELETE FROM ITSHQ
 1046                   WHERE PART_NO = ASPARTNO
 1047                     AND REVISION = ANREVISION;
 1048 
 1049             DELETE FROM ITSPPHS
 1050                   WHERE PART_NO = ASPARTNO
 1051                     AND REVISION = ANREVISION;
 1052 
 1053             DELETE FROM ITWEBRQ
 1054                   WHERE PART_NO = ASPARTNO
 1055                     AND REVISION = ANREVISION;
 1056 
 1057             DELETE FROM SPEC_PED_GROUP
 1058                   WHERE PART_NO = ASPARTNO
 1059                     AND REVISION = ANREVISION;
 1060 
 1061             DELETE FROM SPECDATA_CHECK
 1062                   WHERE PART_NO = ASPARTNO
 1063                     AND REVISION = ANREVISION;
 1064 
 1065             DELETE FROM SPECDATA_PROCESS
 1066                   WHERE PART_NO = ASPARTNO
 1067                     AND REVISION = ANREVISION;
 1068 
 1069             DELETE FROM SPECIFICATION_CD
 1070                   WHERE PART_NO = ASPARTNO
 1071                     AND REVISION = ANREVISION;
 1072 
 1073             DELETE FROM SPECIFICATION_ING_LANG
 1074                   WHERE PART_NO = ASPARTNO
 1075                     AND REVISION = ANREVISION;
 1076 
 1077             DELETE FROM SPECIFICATION_TM
 1078                   WHERE PART_NO = ASPARTNO
 1079                     AND REVISION = ANREVISION;
 1080 
 1081             DELETE FROM ITNUTEXPORTEDPANELS
 1082                   WHERE PART_NO = ASPARTNO
 1083                     AND REVISION = ANREVISION;
 1084 
 1085             
 1086             DELETE FROM ITNUTLOG
 1087                   WHERE PART_NO = ASPARTNO
 1088                     AND REVISION = ANREVISION;
 1089             
 1090                
 1091                
 1092                
 1093                
 1094                
 1095                
 1096                
 1097                
 1098                
 1099             
 1100                
 1101             IF ISLASTONE( ASPARTNO ) = 1
 1102             THEN
 1103                
 1104                DELETE FROM SPECIFICATION_KW
 1105                      WHERE PART_NO = ASPARTNO;
 1106 
 1107                DELETE FROM EXEMPTION
 1108                      WHERE PART_NO = ASPARTNO;
 1109 
 1110 
 1111 
 1112 
 1113 
 1114                DELETE FROM ITPRNOTE
 1115                      WHERE PART_NO = ASPARTNO;
 1116 
 1117                DELETE FROM PART_LOCATION
 1118                      WHERE PART_NO = ASPARTNO;
 1119 
 1120                DELETE FROM PART_PLANT
 1121                      WHERE PART_NO = ASPARTNO;
 1122 
 1123                DELETE FROM PART_L
 1124                      WHERE PART_NO = ASPARTNO;
 1125 
 1126                DELETE FROM ITPRCL
 1127                      WHERE PART_NO = ASPARTNO;
 1128 
 1129                DELETE FROM ITPRCL_H
 1130                      WHERE PART_NO = ASPARTNO;
 1131 
 1132                DELETE FROM ITPRMFC
 1133                      WHERE PART_NO = ASPARTNO;
 1134 
 1135                DELETE FROM ITPRMFC_H
 1136                      WHERE PART_NO = ASPARTNO;
 1137 
 1138                DELETE FROM ITPRNOTE_H
 1139                      WHERE PART_NO = ASPARTNO;
 1140 
 1141                DELETE FROM ITPRPL_H
 1142                      WHERE PART_NO = ASPARTNO;
 1143 
 1144                DELETE FROM ITSH_H
 1145                      WHERE PART_NO = ASPARTNO;
 1146 
 1147                DELETE FROM PART_COST
 1148                      WHERE PART_NO = ASPARTNO;
 1149 
 1150                DELETE FROM SPECIFICATION_KW_H
 1151                      WHERE PART_NO = ASPARTNO;
 1152 
 1153                DELETE FROM ITPROBJ
 1154                      WHERE PART_NO = ASPARTNO;
 1155 
 1156                DELETE FROM ITPROBJ_H
 1157                      WHERE PART_NO = ASPARTNO;
 1158 
 1159                
 1160                
 1161                
 1162                
 1163                
 1164                
 1165                
 1166 
 1167                DELETE FROM ITNUTREFTYPE
 1168                      WHERE PART_NO = ASPARTNO;
 1169             END IF;
 1170 
 1171             DELETE FROM SPECIFICATION_HEADER
 1172                   WHERE PART_NO = ASPARTNO
 1173                     AND REVISION = ANREVISION;
 1174 
 1175             INSERT INTO ITSHDEL
 1176                  VALUES ( ASPARTNO,
 1177                           ANREVISION,
 1178                           SYSDATE,
 1179                           LNSTATUS,
 1180                           LSUSERID,
 1181                           LSFORENAME,
 1182                           LSLASTNAME );
 1183 
 1184             
 1185             
 1186             IF ISLASTONE( ASPARTNO ) = 0
 1187             THEN
 1188                DELETE FROM PART
 1189                      WHERE PART_NO = ASPARTNO
 1190                        AND PART_SOURCE = IAPICONSTANT.PARTSOURCE_INTERNAL;            
 1191             END IF;            
 1192             
 1193 
 1194             COMMIT;
 1195             
 1196             LNRETVAL := IAPIPLANTPART.SETPLANTACCESS( ASPARTNO );
 1197 
 1198             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 1199             THEN
 1200                IAPIGENERAL.LOGERROR( GSSOURCE,
 1201                                      LSMETHOD,
 1202                                      SQLERRM );
 1203                IAPIGENERAL.LOGERROR( GSSOURCE,
 1204                                      LSMETHOD,
 1205                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
 1206                ROLLBACK;
 1207                RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 1208             END IF;
 1209          ELSE
 1210             
 1211             LNRETVAL := 1;
 1212          END IF;
 1213       ELSE
 1214          
 1215          LNRETVAL := 2;
 1216       END IF;
 1217 
 1218       RETURN LNRETVAL;
 1219    EXCEPTION
 1220       WHEN OTHERS
 1221       THEN
 1222          IAPIGENERAL.LOGERROR( GSSOURCE,
 1223                                LSMETHOD,
 1224                                SQLERRM );
 1225          ROLLBACK;
 1226          RETURN LNRETVAL;
 1227    END DELETESPECIFICATION;
 1228 
 1229    
 1230    FUNCTION DELETEFRAME(
 1231       ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
 1232       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 1233       ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
 1234       RETURN IAPITYPE.NUMVAL_TYPE
 1235    IS
 1236       
 1237       
 1238       
 1239       
 1240       
 1241       
 1242       
 1243       
 1244       
 1245       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1246       LNSTATUS                      IAPITYPE.STATUSID_TYPE;
 1247       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteFrame';
 1248    BEGIN
 1249       SELECT STATUS
 1250         INTO LNSTATUS
 1251         FROM FRAME_HEADER
 1252        WHERE FRAME_NO = ASFRAMENO
 1253          AND REVISION = ANREVISION
 1254          AND OWNER = ANOWNER;
 1255 
 1256       DELETE FROM FRAME_TEXT
 1257             WHERE FRAME_NO = ASFRAMENO
 1258               AND REVISION = ANREVISION
 1259               AND OWNER = ANOWNER;
 1260 
 1261       DELETE FROM FRAME_PROP
 1262             WHERE FRAME_NO = ASFRAMENO
 1263               AND REVISION = ANREVISION
 1264               AND OWNER = ANOWNER;
 1265 
 1266       DELETE FROM FRAME_SECTION
 1267             WHERE FRAME_NO = ASFRAMENO
 1268               AND REVISION = ANREVISION
 1269               AND OWNER = ANOWNER;
 1270 
 1271       DELETE FROM FRAMEDATA_SERVER
 1272             WHERE FRAME_NO = ASFRAMENO
 1273               AND REVISION = ANREVISION
 1274               AND OWNER = ANOWNER;
 1275 
 1276       DELETE FROM FRAMEDATA
 1277             WHERE FRAME_NO = ASFRAMENO
 1278               AND REVISION = ANREVISION
 1279               AND OWNER = ANOWNER;
 1280 
 1281       DELETE FROM ITFRMV
 1282             WHERE FRAME_NO = ASFRAMENO
 1283               AND REVISION = ANREVISION
 1284               AND OWNER = ANOWNER;
 1285 
 1286       DELETE FROM ITFRMVPG
 1287             WHERE FRAME_NO = ASFRAMENO
 1288               AND REVISION = ANREVISION
 1289               AND OWNER = ANOWNER;
 1290 
 1291       DELETE FROM ITFRMVSC
 1292             WHERE FRAME_NO = ASFRAMENO
 1293               AND REVISION = ANREVISION
 1294               AND OWNER = ANOWNER;
 1295 
 1296       DELETE FROM ITFRMVALD
 1297             WHERE VAL_ID IN( SELECT VAL_ID
 1298                               FROM ITFRMVAL
 1299                              WHERE FRAME_NO = ASFRAMENO
 1300                                AND REVISION = ANREVISION
 1301                                AND OWNER = ANOWNER );
 1302 
 1303       DELETE FROM ITFRMVAL
 1304             WHERE FRAME_NO = ASFRAMENO
 1305               AND REVISION = ANREVISION
 1306               AND OWNER = ANOWNER;
 1307 
 1308       DELETE FROM FRAME_HEADER
 1309             WHERE FRAME_NO = ASFRAMENO
 1310               AND REVISION = ANREVISION
 1311               AND OWNER = ANOWNER;
 1312 
 1313       INSERT INTO ITFRMDEL
 1314            VALUES ( ASFRAMENO,
 1315                     ANREVISION,
 1316                     ANOWNER,
 1317                     SYSDATE,
 1318                     LNSTATUS,
 1319                     IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
 1320                     IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
 1321                     IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );
 1322 
 1323       COMMIT;
 1324       RETURN 0;
 1325    EXCEPTION
 1326       WHEN OTHERS
 1327       THEN
 1328          IAPIGENERAL.LOGERROR( GSSOURCE,
 1329                                LSMETHOD,
 1330                                SQLERRM );
 1331          ROLLBACK;
 1332          RETURN 1;
 1333    END DELETEFRAME;
 1334 
 1335 
 1336    FUNCTION DELETEOBJECT(
 1337       ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
 1338       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 1339       ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
 1340       RETURN IAPITYPE.NUMVAL_TYPE
 1341    IS
 1342       
 1343       
 1344       
 1345       
 1346       
 1347       
 1348       
 1349       
 1350       
 1351 
 1352       
 1353       
 1354       
 1355       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1356       LNCOUNTOBJECT                 IAPITYPE.NUMVAL_TYPE;
 1357       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteObject';
 1358    BEGIN
 1359       IF IAPIOBJECT.CHECKUSED( ANOBJECTID,
 1360                                ANREVISION,
 1361                                ANOWNER ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
 1362       THEN
 1363          DELETE FROM ITOIRAW
 1364                WHERE OBJECT_ID = ANOBJECTID
 1365                  AND REVISION = ANREVISION
 1366                  AND OWNER = ANOWNER;
 1367 
 1368          DELETE FROM ITOID
 1369                WHERE OBJECT_ID = ANOBJECTID
 1370                  AND REVISION = ANREVISION
 1371                  AND OWNER = ANOWNER;
 1372 
 1373          BEGIN
 1374             SELECT COUNT( * )
 1375               INTO LNCOUNTOBJECT
 1376               FROM ITOID
 1377              WHERE OBJECT_ID = ANOBJECTID
 1378                AND OWNER = ANOWNER;
 1379          EXCEPTION
 1380             WHEN NO_DATA_FOUND
 1381             THEN
 1382                LNCOUNTOBJECT := 0;
 1383          END;
 1384 
 1385          IF LNCOUNTOBJECT = 0
 1386          THEN
 1387             DELETE FROM ITOIH
 1388                   WHERE OBJECT_ID = ANOBJECTID
 1389                     AND OWNER = ANOWNER;
 1390 
 1391             DELETE FROM ITOIKW
 1392                   WHERE OBJECT_ID = ANOBJECTID
 1393                     AND OWNER = ANOWNER;
 1394          END IF;
 1395 
 1396          COMMIT;
 1397       END IF;
 1398 
 1399       RETURN 0;
 1400    EXCEPTION
 1401       WHEN OTHERS
 1402       THEN
 1403          IAPIGENERAL.LOGERROR( GSSOURCE,
 1404                                LSMETHOD,
 1405                                SQLERRM );
 1406          ROLLBACK;
 1407          RETURN 1;
 1408    END DELETEOBJECT;
 1409 
 1410 
 1411    FUNCTION DELETEREFERENCETEXT(
 1412       ANREFTEXTTYPE              IN       IAPITYPE.ID_TYPE,
 1413       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 1414       ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
 1415       RETURN IAPITYPE.NUMVAL_TYPE
 1416    IS
 1417       
 1418       
 1419       
 1420       
 1421       
 1422       
 1423       
 1424       
 1425       
 1426 
 1427       
 1428       
 1429       
 1430       
 1431       
 1432       
 1433       
 1434       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1435       LNCOUNTREFTEXT                IAPITYPE.NUMVAL_TYPE;
 1436       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteReferenceText';
 1437    BEGIN
 1438       IF IAPIREFERENCETEXT.CHECKUSED( ANREFTEXTTYPE,
 1439                                       ANREVISION,
 1440                                       ANOWNER ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
 1441       THEN
 1442          SELECT COUNT( * )
 1443            INTO LNCOUNTREFTEXT
 1444            FROM REFERENCE_TEXT
 1445           WHERE REF_TEXT_TYPE = ANREFTEXTTYPE
 1446             AND OWNER = ANOWNER;
 1447 
 1448          IF LNCOUNTREFTEXT = 1
 1449          THEN
 1450             
 1451             DELETE FROM REF_TEXT_TYPE
 1452                   WHERE REF_TEXT_TYPE = ANREFTEXTTYPE
 1453                     AND OWNER = ANOWNER;
 1454          END IF;
 1455 
 1456          DELETE FROM REFERENCE_TEXT
 1457                WHERE REF_TEXT_TYPE = ANREFTEXTTYPE
 1458                  AND TEXT_REVISION = ANREVISION
 1459                  AND OWNER = ANOWNER;
 1460 
 1461          COMMIT;
 1462       END IF;
 1463 
 1464       RETURN 0;
 1465    EXCEPTION
 1466       WHEN OTHERS
 1467       THEN
 1468          IAPIGENERAL.LOGERROR( GSSOURCE,
 1469                                LSMETHOD,
 1470                                SQLERRM );
 1471          ROLLBACK;
 1472          RETURN 1;
 1473    END DELETEREFERENCETEXT;
 1474 
 1475    
 1476    FUNCTION SETFRAMEOBSOLETE(
 1477       ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
 1478       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 1479       ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
 1480       RETURN IAPITYPE.NUMVAL_TYPE
 1481    IS
 1482       
 1483       
 1484       
 1485       
 1486       
 1487       
 1488       
 1489       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetFrameObsolete';
 1490    BEGIN
 1491       UPDATE FRAME_HEADER
 1492          SET STATUS = 4
 1493        WHERE FRAME_NO = ASFRAMENO
 1494          AND REVISION = ANREVISION
 1495          AND OWNER = ANOWNER;
 1496 
 1497       RETURN 1;
 1498    EXCEPTION
 1499       WHEN OTHERS
 1500       THEN
 1501          IAPIGENERAL.LOGERROR( GSSOURCE,
 1502                                LSMETHOD,
 1503                                SQLERRM );
 1504          ROLLBACK;
 1505          RETURN -1;
 1506    END SETFRAMEOBSOLETE;
 1507 
 1508    
 1509    PROCEDURE REMOVEJOBS
 1510    IS
 1511       
 1512       
 1513       
 1514       
 1515       
 1516       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1517       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 1518       LNJOBID                       IAPITYPE.JOBID_TYPE;
 1519       LNROWSDELETEDINJOB            IAPITYPE.NUMVAL_TYPE := 0;
 1520       LNROWSDELETEDINJOBQ           IAPITYPE.NUMVAL_TYPE := 0;
 1521       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveJobs';
 1522    BEGIN
 1523       IAPIGENERAL.LOGINFO( GSSOURCE,
 1524                            LSMETHOD,
 1525                            'Body of PROCEDURE',
 1526                            IAPICONSTANT.INFOLEVEL_3 );
 1527       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 1528                                            LNJOBID );
 1529       LNRETVAL := GETDAYSTODELETE( 'ITJOB (d)',
 1530                                    LNDAYS );
 1531 
 1532       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 1533       THEN
 1534          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1535       ELSE
 1536          DELETE FROM ITJOB
 1537                WHERE (   START_DATE
 1538                        + LNDAYS ) <= SYSDATE;
 1539 
 1540          LNROWSDELETEDINJOB := SQL%ROWCOUNT;
 1541 
 1542          DELETE FROM ITJOBQ
 1543                WHERE (   LOGDATE
 1544                        + LNDAYS ) <= SYSDATE;
 1545 
 1546          LNROWSDELETEDINJOBQ := SQL%ROWCOUNT;
 1547          COMMIT;
 1548 
 1549          
 1550          UPDATE ITJOB
 1551             SET JOB =
 1552                    SUBSTR(    LSMETHOD
 1553                            || ' '
 1554                            || LNROWSDELETEDINJOB
 1555                            || ' deleted in ITJOB'
 1556                            || ' '
 1557                            || LNROWSDELETEDINJOBQ
 1558                            || ' deleted in ITJOBQ',
 1559                            1,
 1560                            60 )
 1561           WHERE JOB_ID = LNJOBID;
 1562 
 1563          COMMIT;
 1564 
 1565          
 1566          DELETE FROM ITQ
 1567                WHERE END_DATE IS NULL
 1568                  AND START_DATE <(   SYSDATE
 1569                                    - 1 );
 1570 
 1571          COMMIT;
 1572          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1573       END IF;
 1574    EXCEPTION
 1575       WHEN OTHERS
 1576       THEN
 1577          IAPIGENERAL.LOGERROR( GSSOURCE,
 1578                                LSMETHOD,
 1579                                SQLERRM );
 1580          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1581    END REMOVEJOBS;
 1582 
 1583    
 1584    PROCEDURE REMOVEERRORS
 1585    IS
 1586       
 1587       
 1588       
 1589       
 1590       
 1591       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1592       LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
 1593       LNJOBID                       IAPITYPE.JOBID_TYPE;
 1594       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 1595       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 1596       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 1597       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveErrors';
 1598    BEGIN
 1599       IAPIGENERAL.LOGINFO( GSSOURCE,
 1600                            LSMETHOD,
 1601                            'Body of PROCEDURE',
 1602                            IAPICONSTANT.INFOLEVEL_3 );
 1603       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 1604                                            LNJOBID );
 1605       LNRETVAL := GETDAYSTODELETE( 'ITERROR (d)',
 1606                                    LNDAYS );
 1607 
 1608       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 1609       THEN
 1610          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1611       ELSE
 1612          
 1613          SELECT COUNT( * )
 1614            INTO LNCOUNTBEFORE
 1615            FROM ITERROR;
 1616 
 1617          DELETE FROM ITERROR
 1618                WHERE (   LOGDATE
 1619                        + LNDAYS ) <= SYSDATE;
 1620 
 1621          
 1622          SELECT COUNT( * )
 1623            INTO LNCOUNTAFTER
 1624            FROM ITERROR;
 1625 
 1626          LNROWSDELETED :=   LNCOUNTBEFORE
 1627                           - LNCOUNTAFTER;
 1628          COMMIT;
 1629 
 1630          
 1631          UPDATE ITJOB
 1632             SET JOB = SUBSTR(    LSMETHOD
 1633                               || ' '
 1634                               || LNROWSDELETED
 1635                               || ' deleted',
 1636                               1,
 1637                               60 )
 1638           WHERE JOB_ID = LNJOBID;
 1639 
 1640          COMMIT;
 1641          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1642       END IF;
 1643    EXCEPTION
 1644       WHEN OTHERS
 1645       THEN
 1646          IAPIGENERAL.LOGERROR( GSSOURCE,
 1647                                LSMETHOD,
 1648                                SQLERRM );
 1649          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1650    END REMOVEERRORS;
 1651 
 1652    
 1653    PROCEDURE REMOVESPECIFICATIONS
 1654    IS
 1655       
 1656       
 1657       
 1658       
 1659       
 1660       
 1661       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1662       LSPARTNO                      IAPITYPE.PARTNO_TYPE;
 1663       LNREVISION                    IAPITYPE.REVISION_TYPE;
 1664       LNWORKFLOWGROUPID             IAPITYPE.WORKFLOWGROUPID_TYPE;
 1665       LNSTATUS                      IAPITYPE.STATUSID_TYPE;
 1666       LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
 1667       LNJOBID                       IAPITYPE.JOBID_TYPE;
 1668       LNMAXHISTORICDAYS             IAPITYPE.NUMVAL_TYPE := 0;
 1669       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 1670       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSpecifications';
 1671 
 1672       CURSOR C_HISTORIC_TO_OBSOLETE(
 1673          ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
 1674       IS
 1675          SELECT A.PART_NO,
 1676                 A.REVISION,
 1677                 A.WORKFLOW_GROUP_ID,
 1678                 A.STATUS
 1679            FROM SPECIFICATION_HEADER A,
 1680                 STATUS B
 1681           WHERE A.STATUS = B.STATUS
 1682             AND B.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_HISTORIC
 1683             AND (   A.STATUS_CHANGE_DATE                  
 1684             
 1685                   --+ anDays ) <= SYSDATE; --orig      
 1686                   + ANDAYS ) <= SYSDATE                  
 1687             AND            
 1688             (
 1689                 (NOT EXISTS (SELECT *
 1690                              FROM SPECIFICATION_LINE_PROP
 1691                              WHERE COMPONENT_PART = A.PART_NO))                
 1692                 OR
 1693                 ((EXISTS (SELECT *
 1694                              FROM SPECIFICATION_LINE_PROP
 1695                              WHERE COMPONENT_PART = A.PART_NO))
 1696                   AND 
 1697                   (DECODE ((SELECT COUNT( * )
 1698                             FROM SPECIFICATION_HEADER
 1699                             WHERE PART_NO = A.PART_NO), 0, 0, 1, 0, 1) = 1)            
 1700                 )
 1701             );             
 1702             
 1703                   
 1704 
 1705       CURSOR C_DEL_OBS_SH(
 1706          ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
 1707       IS
 1708          SELECT A.PART_NO,
 1709                 A.REVISION
 1710            FROM SPECIFICATION_HEADER A,
 1711                 STATUS B
 1712           WHERE A.STATUS = B.STATUS
 1713             AND B.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE
 1714             AND (   A.STATUS_CHANGE_DATE                  
 1715             
 1716                   --+ anDays ) <= SYSDATE; --orig
 1717                   + ANDAYS ) <= SYSDATE      
 1718             AND            
 1719             (
 1720                 (NOT EXISTS (SELECT *
 1721                              FROM SPECIFICATION_LINE_PROP
 1722                              WHERE COMPONENT_PART = A.PART_NO))
 1723                 OR
 1724                 ((EXISTS (SELECT *
 1725                              FROM SPECIFICATION_LINE_PROP
 1726                              WHERE COMPONENT_PART = A.PART_NO))
 1727                   AND 
 1728                   (DECODE ((SELECT COUNT( * )
 1729                             FROM SPECIFICATION_HEADER
 1730                             WHERE PART_NO = A.PART_NO), 0, 0, 1, 0, 1) = 1))
 1731             );             
 1732             
 1733                   
 1734    BEGIN
 1735       IAPIGENERAL.LOGINFO( GSSOURCE,
 1736                            LSMETHOD,
 1737                            'Body of PROCEDURE',
 1738                            IAPICONSTANT.INFOLEVEL_3 );
 1739       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 1740                                            LNJOBID );
 1741       LNRETVAL := GETDAYSTODELETE( 'SPEC TO OBSOLETE (d)',
 1742                                    LNMAXHISTORICDAYS );
 1743 
 1744       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 1745       THEN
 1746          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1747       ELSE
 1748          OPEN C_HISTORIC_TO_OBSOLETE( LNMAXHISTORICDAYS );
 1749 
 1750          FETCH C_HISTORIC_TO_OBSOLETE
 1751           INTO LSPARTNO,
 1752                LNREVISION,
 1753                LNWORKFLOWGROUPID,
 1754                LNSTATUS;
 1755 
 1756          WHILE C_HISTORIC_TO_OBSOLETE%FOUND
 1757          LOOP
 1758             
 1759             LNRETVAL := SETSPECOBSOLETE( LSPARTNO,
 1760                                          LNREVISION,
 1761                                          LNWORKFLOWGROUPID,
 1762                                          LNSTATUS );
 1763 
 1764             FETCH C_HISTORIC_TO_OBSOLETE
 1765              INTO LSPARTNO,
 1766                   LNREVISION,
 1767                   LNWORKFLOWGROUPID,
 1768                   LNSTATUS;
 1769          END LOOP;
 1770 
 1771          CLOSE C_HISTORIC_TO_OBSOLETE;
 1772 
 1773          LNRETVAL := GETDAYSTODELETE( 'SPECIFICATIONS (d)',
 1774                                       LNDAYS );
 1775 
 1776          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 1777          THEN
 1778             LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1779          ELSE
 1780             OPEN C_DEL_OBS_SH( LNDAYS );
 1781 
 1782             FETCH C_DEL_OBS_SH
 1783              INTO LSPARTNO,
 1784                   LNREVISION;
 1785 
 1786             WHILE C_DEL_OBS_SH%FOUND
 1787             LOOP
 1788                LNRETVAL := DELETESPECIFICATION( LSPARTNO,
 1789                                                 LNREVISION );
 1790 
 1791                IF LNRETVAL = 0
 1792                THEN
 1793                   LNROWSDELETED :=   LNROWSDELETED
 1794                                    + 1;
 1795                END IF;
 1796 
 1797                FETCH C_DEL_OBS_SH
 1798                 INTO LSPARTNO,
 1799                      LNREVISION;
 1800             END LOOP;
 1801 
 1802             CLOSE C_DEL_OBS_SH;
 1803 
 1804             
 1805             UPDATE ITJOB
 1806                SET JOB = SUBSTR(    LSMETHOD
 1807                                  || ' '
 1808                                  || LNROWSDELETED
 1809                                  || ' deleted',
 1810                                  1,
 1811                                  60 )
 1812              WHERE JOB_ID = LNJOBID;
 1813 
 1814             COMMIT;
 1815             LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1816          END IF;
 1817       END IF;
 1818    EXCEPTION
 1819       WHEN OTHERS
 1820       THEN
 1821          IAPIGENERAL.LOGERROR( GSSOURCE,
 1822                                LSMETHOD,
 1823                                SQLERRM );
 1824 
 1825          
 1826          UPDATE ITJOB
 1827             SET JOB = SUBSTR(    LSMETHOD
 1828                               || ' '
 1829                               || LNROWSDELETED
 1830                               || ' deleted with errors',
 1831                               1,
 1832                               60 )
 1833           WHERE JOB_ID = LNJOBID;
 1834 
 1835          COMMIT;
 1836 
 1837          IF C_HISTORIC_TO_OBSOLETE%ISOPEN
 1838          THEN
 1839             CLOSE C_HISTORIC_TO_OBSOLETE;
 1840          END IF;
 1841 
 1842          IF C_DEL_OBS_SH%ISOPEN
 1843          THEN
 1844             CLOSE C_DEL_OBS_SH;
 1845          END IF;
 1846 
 1847          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1848    END REMOVESPECIFICATIONS;
 1849 
 1850    
 1851    PROCEDURE REMOVEFRAMES
 1852    IS
 1853       
 1854       
 1855       
 1856       
 1857       
 1858       
 1859       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1860       LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
 1861       LNREVISION                    IAPITYPE.REVISION_TYPE;
 1862       LNOWNER                       IAPITYPE.OWNER_TYPE;
 1863       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 1864       LNJOBID                       IAPITYPE.JOBID_TYPE;
 1865       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 1866       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFrames';
 1867 
 1868       CURSOR C_SET_OBSOLETE(
 1869          ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
 1870       IS
 1871          SELECT FRAME_NO,
 1872                 REVISION,
 1873                 OWNER
 1874            FROM FRAME_HEADER
 1875           WHERE STATUS = 3
 1876             AND (   STATUS_CHANGE_DATE
 1877                   + ANDAYS ) <= SYSDATE;
 1878 
 1879       CURSOR C_DEL_OBS_FH(
 1880          ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
 1881       IS
 1882          SELECT A.FRAME_NO,
 1883                 A.REVISION,
 1884                 A.OWNER
 1885            FROM FRAME_HEADER A
 1886           WHERE A.STATUS = 4
 1887             AND (   A.STATUS_CHANGE_DATE
 1888                   + ANDAYS ) <= SYSDATE;
 1889    BEGIN
 1890       IAPIGENERAL.LOGINFO( GSSOURCE,
 1891                            LSMETHOD,
 1892                            'Body of PROCEDURE',
 1893                            IAPICONSTANT.INFOLEVEL_3 );
 1894       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 1895                                            LNJOBID );
 1896       LNRETVAL := GETDAYSTODELETE( 'FRAME TO OBSOLETE(d)',
 1897                                    LNDAYS );
 1898 
 1899       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 1900       THEN
 1901          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1902       ELSE
 1903          FOR L_ROW IN C_SET_OBSOLETE( LNDAYS )
 1904          LOOP
 1905             LNRETVAL := SETFRAMEOBSOLETE( L_ROW.FRAME_NO,
 1906                                           L_ROW.REVISION,
 1907                                           L_ROW.OWNER );
 1908          END LOOP;
 1909 
 1910          LNRETVAL := GETDAYSTODELETE( 'FRAMES (d)',
 1911                                       LNDAYS );
 1912 
 1913          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 1914          THEN
 1915             LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1916          ELSE
 1917             OPEN C_DEL_OBS_FH( LNDAYS );
 1918 
 1919             FETCH C_DEL_OBS_FH
 1920              INTO LSFRAMENO,
 1921                   LNREVISION,
 1922                   LNOWNER;
 1923 
 1924             WHILE C_DEL_OBS_FH%FOUND
 1925             LOOP
 1926                LNRETVAL := DELETEFRAME( LSFRAMENO,
 1927                                         LNREVISION,
 1928                                         LNOWNER );
 1929 
 1930                IF LNRETVAL = 0
 1931                THEN
 1932                   LNROWSDELETED :=   LNROWSDELETED
 1933                                    + 1;
 1934                END IF;
 1935 
 1936                FETCH C_DEL_OBS_FH
 1937                 INTO LSFRAMENO,
 1938                      LNREVISION,
 1939                      LNOWNER;
 1940             END LOOP;
 1941 
 1942             CLOSE C_DEL_OBS_FH;
 1943 
 1944             COMMIT;
 1945 
 1946             
 1947             UPDATE ITJOB
 1948                SET JOB = SUBSTR(    LSMETHOD
 1949                                  || ' '
 1950                                  || LNROWSDELETED
 1951                                  || ' deleted',
 1952                                  1,
 1953                                  60 )
 1954              WHERE JOB_ID = LNJOBID;
 1955 
 1956             COMMIT;
 1957             LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1958          END IF;
 1959       END IF;
 1960    EXCEPTION
 1961       WHEN OTHERS
 1962       THEN
 1963          IAPIGENERAL.LOGERROR( GSSOURCE,
 1964                                LSMETHOD,
 1965                                SQLERRM );
 1966 
 1967          
 1968          UPDATE ITJOB
 1969             SET JOB = SUBSTR(    LSMETHOD
 1970                               || ' '
 1971                               || LNROWSDELETED
 1972                               || ' deleted with errors',
 1973                               1,
 1974                               60 )
 1975           WHERE JOB_ID = LNJOBID;
 1976 
 1977          COMMIT;
 1978 
 1979          IF C_DEL_OBS_FH%ISOPEN
 1980          THEN
 1981             CLOSE C_DEL_OBS_FH;
 1982          END IF;
 1983 
 1984          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 1985    END REMOVEFRAMES;
 1986 
 1987    
 1988    PROCEDURE REMOVEOBJECTS
 1989    IS
 1990       
 1991       
 1992       
 1993       
 1994       
 1995       
 1996       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1997       LNOBJECTID                    IAPITYPE.ID_TYPE;
 1998       LNREVISION                    IAPITYPE.REVISION_TYPE;
 1999       LNOWNER                       IAPITYPE.OWNER_TYPE;
 2000       LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
 2001       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2002       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2003       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveObjects';
 2004 
 2005       CURSOR C_DEL_OBS_OB(
 2006          ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
 2007       IS
 2008          SELECT A.OBJECT_ID,
 2009                 A.REVISION,
 2010                 A.OWNER
 2011            FROM ITOID A
 2012           WHERE A.STATUS = 4
 2013             AND (   A.LAST_MODIFIED_ON
 2014                   + ANDAYS ) <= SYSDATE;
 2015    BEGIN
 2016       IAPIGENERAL.LOGINFO( GSSOURCE,
 2017                            LSMETHOD,
 2018                            'Body of PROCEDURE',
 2019                            IAPICONSTANT.INFOLEVEL_3 );
 2020       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2021                                            LNJOBID );
 2022       LNRETVAL := GETDAYSTODELETE( 'OBJECTS IMAGES (d)',
 2023                                    LNDAYS );
 2024 
 2025       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2026       THEN
 2027          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2028       ELSE
 2029          OPEN C_DEL_OBS_OB( LNDAYS );
 2030 
 2031          FETCH C_DEL_OBS_OB
 2032           INTO LNOBJECTID,
 2033                LNREVISION,
 2034                LNOWNER;
 2035 
 2036          WHILE C_DEL_OBS_OB%FOUND
 2037          LOOP
 2038             LNRETVAL := DELETEOBJECT( LNOBJECTID,
 2039                                       LNREVISION,
 2040                                       LNOWNER );
 2041 
 2042             IF LNRETVAL = 0
 2043             THEN
 2044                LNROWSDELETED :=   LNROWSDELETED
 2045                                 + 1;
 2046             END IF;
 2047 
 2048             FETCH C_DEL_OBS_OB
 2049              INTO LNOBJECTID,
 2050                   LNREVISION,
 2051                   LNOWNER;
 2052          END LOOP;
 2053 
 2054          CLOSE C_DEL_OBS_OB;
 2055 
 2056          COMMIT;
 2057 
 2058          
 2059          UPDATE ITJOB
 2060             SET JOB = SUBSTR(    LSMETHOD
 2061                               || ' '
 2062                               || LNROWSDELETED
 2063                               || ' deleted',
 2064                               1,
 2065                               60 )
 2066           WHERE JOB_ID = LNJOBID;
 2067 
 2068          COMMIT;
 2069          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2070       END IF;
 2071    EXCEPTION
 2072       WHEN OTHERS
 2073       THEN
 2074          IAPIGENERAL.LOGERROR( GSSOURCE,
 2075                                LSMETHOD,
 2076                                SQLERRM );
 2077          LNRETVAL := SQLCODE;
 2078          ROLLBACK;
 2079 
 2080          
 2081          UPDATE ITJOB
 2082             SET JOB = SUBSTR(    LSMETHOD
 2083                               || ' '
 2084                               || LNROWSDELETED
 2085                               || ' deleted with errors',
 2086                               1,
 2087                               60 )
 2088           WHERE JOB_ID = LNJOBID;
 2089 
 2090          COMMIT;
 2091 
 2092          IF C_DEL_OBS_OB%ISOPEN
 2093          THEN
 2094             CLOSE C_DEL_OBS_OB;
 2095          END IF;
 2096 
 2097          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2098    END REMOVEOBJECTS;
 2099 
 2100    
 2101    PROCEDURE REMOVEREFERENCETEXTS
 2102    IS
 2103       
 2104       
 2105       
 2106       
 2107       
 2108       
 2109       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2110       LNREFTEXTTYPE                 IAPITYPE.ID_TYPE;
 2111       LNREVISION                    IAPITYPE.REVISION_TYPE;
 2112       LNOWNER                       IAPITYPE.OWNER_TYPE;
 2113       LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
 2114       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2115       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2116       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveReferenceTexts';
 2117 
 2118       CURSOR C_DEL_OBS_RT(
 2119          ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
 2120       IS
 2121          SELECT A.REF_TEXT_TYPE,
 2122                 A.TEXT_REVISION,
 2123                 A.OWNER
 2124            FROM REFERENCE_TEXT A
 2125           WHERE A.STATUS = 4
 2126             AND (   A.LAST_MODIFIED_ON
 2127                   + ANDAYS ) <= SYSDATE;
 2128    BEGIN
 2129       IAPIGENERAL.LOGINFO( GSSOURCE,
 2130                            LSMETHOD,
 2131                            'Body of PROCEDURE',
 2132                            IAPICONSTANT.INFOLEVEL_3 );
 2133       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2134                                            LNJOBID );
 2135       LNRETVAL := GETDAYSTODELETE( 'REFERENCE TEXTS (d)',
 2136                                    LNDAYS );
 2137 
 2138       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2139       THEN
 2140          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2141       ELSE
 2142          OPEN C_DEL_OBS_RT( LNDAYS );
 2143 
 2144          FETCH C_DEL_OBS_RT
 2145           INTO LNREFTEXTTYPE,
 2146                LNREVISION,
 2147                LNOWNER;
 2148 
 2149          WHILE C_DEL_OBS_RT%FOUND
 2150          LOOP
 2151             LNRETVAL := DELETEREFERENCETEXT( LNREFTEXTTYPE,
 2152                                              LNREVISION,
 2153                                              LNOWNER );
 2154 
 2155             IF LNRETVAL = 0
 2156             THEN
 2157                LNROWSDELETED :=   LNROWSDELETED
 2158                                 + 1;
 2159             END IF;
 2160 
 2161             FETCH C_DEL_OBS_RT
 2162              INTO LNREFTEXTTYPE,
 2163                   LNREVISION,
 2164                   LNOWNER;
 2165          END LOOP;
 2166 
 2167          CLOSE C_DEL_OBS_RT;
 2168 
 2169          COMMIT;
 2170 
 2171          
 2172          UPDATE ITJOB
 2173             SET JOB = SUBSTR(    LSMETHOD
 2174                               || ' '
 2175                               || LNROWSDELETED
 2176                               || ' deleted',
 2177                               1,
 2178                               60 )
 2179           WHERE JOB_ID = LNJOBID;
 2180 
 2181          COMMIT;
 2182          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2183       END IF;
 2184    EXCEPTION
 2185       WHEN OTHERS
 2186       THEN
 2187          IAPIGENERAL.LOGERROR( GSSOURCE,
 2188                                LSMETHOD,
 2189                                SQLERRM );
 2190          ROLLBACK;
 2191 
 2192          
 2193          UPDATE ITJOB
 2194             SET JOB = SUBSTR(    LSMETHOD
 2195                               || ' '
 2196                               || LNROWSDELETED
 2197                               || ' deleted with errors',
 2198                               1,
 2199                               60 )
 2200           WHERE JOB_ID = LNJOBID;
 2201 
 2202          COMMIT;
 2203 
 2204          IF C_DEL_OBS_RT%ISOPEN
 2205          THEN
 2206             CLOSE C_DEL_OBS_RT;
 2207          END IF;
 2208 
 2209          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2210    END REMOVEREFERENCETEXTS;
 2211 
 2212    
 2213    PROCEDURE REMOVEBOMIMPLOSION
 2214    IS
 2215       
 2216       
 2217       
 2218       
 2219       
 2220       
 2221       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2222       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2223       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2224       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2225       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2226       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveBomImplosion';
 2227    BEGIN
 2228       IAPIGENERAL.LOGINFO( GSSOURCE,
 2229                            LSMETHOD,
 2230                            'Body of PROCEDURE',
 2231                            IAPICONSTANT.INFOLEVEL_3 );
 2232       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2233                                            LNJOBID );
 2234 
 2235       
 2236       SELECT COUNT( * )
 2237         INTO LNCOUNTBEFORE
 2238         FROM ITBOMIMPLOSION;
 2239 
 2240       DELETE FROM ITBOMIMPLOSION;
 2241 
 2242       
 2243       SELECT COUNT( * )
 2244         INTO LNCOUNTAFTER
 2245         FROM ITBOMIMPLOSION;
 2246 
 2247       LNROWSDELETED :=   LNCOUNTBEFORE
 2248                        - LNCOUNTAFTER;
 2249       COMMIT;
 2250 
 2251       
 2252       UPDATE ITJOB
 2253          SET JOB = SUBSTR(    LSMETHOD
 2254                            || ' '
 2255                            || LNROWSDELETED
 2256                            || ' deleted',
 2257                            1,
 2258                            60 )
 2259        WHERE JOB_ID = LNJOBID;
 2260 
 2261       COMMIT;
 2262       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2263    EXCEPTION
 2264       WHEN OTHERS
 2265       THEN
 2266          IAPIGENERAL.LOGERROR( GSSOURCE,
 2267                                LSMETHOD,
 2268                                SQLERRM );
 2269          ROLLBACK;
 2270          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2271    END REMOVEBOMIMPLOSION;
 2272 
 2273    
 2274    PROCEDURE REMOVEBOMEXPLOSION
 2275    IS
 2276       
 2277       
 2278       
 2279       
 2280       
 2281       
 2282       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2283       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2284       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2285       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2286       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2287       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveBomExplosion';
 2288    BEGIN
 2289       IAPIGENERAL.LOGINFO( GSSOURCE,
 2290                            LSMETHOD,
 2291                            'Body of PROCEDURE',
 2292                            IAPICONSTANT.INFOLEVEL_3 );
 2293       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2294                                            LNJOBID );
 2295 
 2296       
 2297       SELECT COUNT( * )
 2298         INTO LNCOUNTBEFORE
 2299         FROM ITBOMEXPLOSION;
 2300 
 2301       DELETE FROM ITBOMEXPLOSION;
 2302 
 2303       DELETE FROM ITATTEXPLOSION;
 2304 
 2305       DELETE FROM ITINGEXPLOSION;
 2306 
 2307       DELETE FROM ITBOMPATH;
 2308 
 2309       
 2310       SELECT COUNT( * )
 2311         INTO LNCOUNTAFTER
 2312         FROM ITBOMEXPLOSION;
 2313 
 2314       LNROWSDELETED :=   LNCOUNTBEFORE
 2315                        - LNCOUNTAFTER;
 2316       COMMIT;
 2317 
 2318       
 2319       UPDATE ITJOB
 2320          SET JOB = SUBSTR(    LSMETHOD
 2321                            || ' '
 2322                            || LNROWSDELETED
 2323                            || ' deleted',
 2324                            1,
 2325                            60 )
 2326        WHERE JOB_ID = LNJOBID;
 2327 
 2328       COMMIT;
 2329       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2330    EXCEPTION
 2331       WHEN OTHERS
 2332       THEN
 2333          IAPIGENERAL.LOGERROR( GSSOURCE,
 2334                                LSMETHOD,
 2335                                SQLERRM );
 2336          ROLLBACK;
 2337          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2338    END REMOVEBOMEXPLOSION;
 2339 
 2340    
 2341    PROCEDURE REMOVECOMPARE
 2342    IS
 2343       
 2344       
 2345       
 2346       
 2347       
 2348       
 2349       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2350       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2351       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2352       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2353       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2354       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveCompare';
 2355    BEGIN
 2356       IAPIGENERAL.LOGINFO( GSSOURCE,
 2357                            LSMETHOD,
 2358                            'Body of PROCEDURE',
 2359                            IAPICONSTANT.INFOLEVEL_3 );
 2360       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2361                                            LNJOBID );
 2362 
 2363       
 2364       SELECT COUNT( * )
 2365         INTO LNCOUNTBEFORE
 2366         FROM ITSHCMP;
 2367 
 2368       DELETE FROM ITSHCMP;
 2369 
 2370       
 2371       SELECT COUNT( * )
 2372         INTO LNCOUNTAFTER
 2373         FROM ITSHCMP;
 2374 
 2375       LNROWSDELETED :=   LNCOUNTBEFORE
 2376                        - LNCOUNTAFTER;
 2377       COMMIT;
 2378 
 2379       
 2380       UPDATE ITJOB
 2381          SET JOB = SUBSTR(    LSMETHOD
 2382                            || ' '
 2383                            || LNROWSDELETED
 2384                            || ' deleted',
 2385                            1,
 2386                            60 )
 2387        WHERE JOB_ID = LNJOBID;
 2388 
 2389       COMMIT;
 2390       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2391    EXCEPTION
 2392       WHEN OTHERS
 2393       THEN
 2394          IAPIGENERAL.LOGERROR( GSSOURCE,
 2395                                LSMETHOD,
 2396                                SQLERRM );
 2397          ROLLBACK;
 2398          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2399    END REMOVECOMPARE;
 2400 
 2401    
 2402    PROCEDURE REMOVETEXTSEARCH
 2403    IS
 2404       
 2405       
 2406       
 2407       
 2408       
 2409       
 2410       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2411       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2412       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2413       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2414       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2415       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveTextSearch';
 2416    BEGIN
 2417       IAPIGENERAL.LOGINFO( GSSOURCE,
 2418                            LSMETHOD,
 2419                            'Body of PROCEDURE',
 2420                            IAPICONSTANT.INFOLEVEL_3 );
 2421       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2422                                            LNJOBID );
 2423 
 2424       
 2425       SELECT COUNT( * )
 2426         INTO LNCOUNTBEFORE
 2427         FROM ITTSRESULTS;
 2428 
 2429       DELETE FROM ITTSRESULTS;
 2430 
 2431       
 2432       SELECT COUNT( * )
 2433         INTO LNCOUNTAFTER
 2434         FROM ITTSRESULTS;
 2435 
 2436       LNROWSDELETED :=   LNCOUNTBEFORE
 2437                        - LNCOUNTAFTER;
 2438       COMMIT;
 2439 
 2440       
 2441       UPDATE ITJOB
 2442          SET JOB = SUBSTR(    LSMETHOD
 2443                            || ' '
 2444                            || LNROWSDELETED
 2445                            || ' deleted',
 2446                            1,
 2447                            60 )
 2448        WHERE JOB_ID = LNJOBID;
 2449 
 2450       COMMIT;
 2451       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2452    EXCEPTION
 2453       WHEN OTHERS
 2454       THEN
 2455          IAPIGENERAL.LOGERROR( GSSOURCE,
 2456                                LSMETHOD,
 2457                                SQLERRM );
 2458          ROLLBACK;
 2459          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2460    END REMOVETEXTSEARCH;
 2461 
 2462    
 2463    PROCEDURE REMOVESERVER
 2464    IS
 2465       
 2466       
 2467       
 2468       
 2469       
 2470       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2471       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2472       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2473       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2474       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2475       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveServer';
 2476    BEGIN
 2477       IAPIGENERAL.LOGINFO( GSSOURCE,
 2478                            LSMETHOD,
 2479                            'Body of PROCEDURE',
 2480                            IAPICONSTANT.INFOLEVEL_3 );
 2481       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2482                                            LNJOBID );
 2483 
 2484       
 2485       SELECT COUNT( * )
 2486         INTO LNCOUNTBEFORE
 2487         FROM SPECDATA_SERVER;
 2488 
 2489       DELETE FROM SPECDATA_SERVER
 2490             WHERE DATE_PROCESSED IS NOT NULL
 2491               AND DATE_PROCESSED <   TRUNC( SYSDATE )
 2492                                    - 7;
 2493 
 2494       
 2495       SELECT COUNT( * )
 2496         INTO LNCOUNTAFTER
 2497         FROM SPECDATA_SERVER;
 2498 
 2499       LNROWSDELETED :=   LNCOUNTBEFORE
 2500                        - LNCOUNTAFTER;
 2501       COMMIT;
 2502 
 2503       
 2504       SELECT COUNT( * )
 2505         INTO LNCOUNTBEFORE
 2506         FROM FRAMEDATA_SERVER;
 2507 
 2508       DELETE FROM FRAMEDATA_SERVER
 2509             WHERE DATE_PROCESSED IS NOT NULL
 2510               AND DATE_PROCESSED <   TRUNC( SYSDATE )
 2511                                    - 7;
 2512 
 2513       
 2514       SELECT COUNT( * )
 2515         INTO LNCOUNTAFTER
 2516         FROM FRAMEDATA_SERVER;
 2517 
 2518       LNROWSDELETED :=   LNROWSDELETED
 2519                        + LNCOUNTBEFORE
 2520                        - LNCOUNTAFTER;
 2521       COMMIT;
 2522 
 2523       
 2524       UPDATE ITJOB
 2525          SET JOB = SUBSTR(    LSMETHOD
 2526                            || ' '
 2527                            || LNROWSDELETED
 2528                            || ' deleted',
 2529                            1,
 2530                            60 )
 2531        WHERE JOB_ID = LNJOBID;
 2532 
 2533       COMMIT;
 2534       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2535    EXCEPTION
 2536       WHEN OTHERS
 2537       THEN
 2538          IAPIGENERAL.LOGERROR( GSSOURCE,
 2539                                LSMETHOD,
 2540                                SQLERRM );
 2541          ROLLBACK;
 2542          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2543    END REMOVESERVER;
 2544 
 2545    
 2546    PROCEDURE REMOVEJRNLSPEC
 2547    IS
 2548       
 2549       
 2550       
 2551       
 2552       
 2553       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2554       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 2555       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2556       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2557       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2558       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2559       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveJrnlSpec';
 2560    BEGIN
 2561       IAPIGENERAL.LOGINFO( GSSOURCE,
 2562                            LSMETHOD,
 2563                            'Body of PROCEDURE',
 2564                            IAPICONSTANT.INFOLEVEL_3 );
 2565       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2566                                            LNJOBID );
 2567       LNRETVAL := GETDAYSTODELETE( 'JRNL SPECS (d)',
 2568                                    LNDAYS );
 2569 
 2570       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2571       THEN
 2572          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2573       ELSE
 2574          
 2575          SELECT COUNT( * )
 2576            INTO LNCOUNTBEFORE
 2577            FROM JRNL_SPECIFICATION_HEADER;
 2578 
 2579          DELETE FROM JRNL_SPECIFICATION_HEADER
 2580                WHERE   TIMESTAMP
 2581                      + LNDAYS < SYSDATE;
 2582 
 2583          
 2584          SELECT COUNT( * )
 2585            INTO LNCOUNTAFTER
 2586            FROM JRNL_SPECIFICATION_HEADER;
 2587 
 2588          LNROWSDELETED :=   LNCOUNTBEFORE
 2589                           - LNCOUNTAFTER;
 2590          COMMIT;
 2591 
 2592          
 2593          UPDATE ITJOB
 2594             SET JOB = SUBSTR(    LSMETHOD
 2595                               || ' '
 2596                               || LNROWSDELETED
 2597                               || ' deleted',
 2598                               1,
 2599                               60 )
 2600           WHERE JOB_ID = LNJOBID;
 2601 
 2602          COMMIT;
 2603          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2604       END IF;
 2605    EXCEPTION
 2606       WHEN OTHERS
 2607       THEN
 2608          IAPIGENERAL.LOGERROR( GSSOURCE,
 2609                                LSMETHOD,
 2610                                SQLERRM );
 2611          ROLLBACK;
 2612          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2613    END REMOVEJRNLSPEC;
 2614 
 2615    
 2616    PROCEDURE REMOVEJRNLBOM
 2617    IS
 2618       
 2619       
 2620       
 2621       
 2622       
 2623       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2624       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 2625       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2626       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2627       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2628       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2629       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveJrnlBom';
 2630    BEGIN
 2631       IAPIGENERAL.LOGINFO( GSSOURCE,
 2632                            LSMETHOD,
 2633                            'Body of PROCEDURE',
 2634                            IAPICONSTANT.INFOLEVEL_3 );
 2635       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2636                                            LNJOBID );
 2637       LNRETVAL := GETDAYSTODELETE( 'JRNL BOMS (d)',
 2638                                    LNDAYS );
 2639 
 2640       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2641       THEN
 2642          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2643       ELSE
 2644          
 2645          SELECT COUNT( * )
 2646            INTO LNCOUNTBEFORE
 2647            FROM ITBOMJRNL;
 2648 
 2649          DELETE FROM ITBOMJRNL
 2650                WHERE   TIMESTAMP
 2651                      + LNDAYS < SYSDATE;
 2652 
 2653          
 2654          SELECT COUNT( * )
 2655            INTO LNCOUNTAFTER
 2656            FROM ITBOMJRNL;
 2657 
 2658          LNROWSDELETED :=   LNCOUNTBEFORE
 2659                           - LNCOUNTAFTER;
 2660          COMMIT;
 2661 
 2662          
 2663          UPDATE ITJOB
 2664             SET JOB = SUBSTR(    LSMETHOD
 2665                               || ' '
 2666                               || LNROWSDELETED
 2667                               || ' deleted',
 2668                               1,
 2669                               60 )
 2670           WHERE JOB_ID = LNJOBID;
 2671 
 2672          COMMIT;
 2673          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2674       END IF;
 2675    EXCEPTION
 2676       WHEN OTHERS
 2677       THEN
 2678          IAPIGENERAL.LOGERROR( GSSOURCE,
 2679                                LSMETHOD,
 2680                                SQLERRM );
 2681          ROLLBACK;
 2682          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2683    END REMOVEJRNLBOM;
 2684 
 2685    
 2686    PROCEDURE REMOVEIMPORTLOG
 2687    IS
 2688       
 2689       
 2690       
 2691       
 2692       
 2693       CURSOR C_IMP_LOG(
 2694          ANDAYS                     IN       IAPITYPE.NUMVAL_TYPE )
 2695       IS
 2696          SELECT TYPE,
 2697                 PART_NO,
 2698                 REVISION,
 2699                 OWNER,
 2700                 TIMESTAMP
 2701            FROM ITIMP_LOG
 2702           WHERE   TIMESTAMP
 2703                 + ANDAYS < SYSDATE;
 2704 
 2705       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2706       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2707       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2708       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2709       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2710       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveImportLog';
 2711       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 2712    BEGIN
 2713       IAPIGENERAL.LOGINFO( GSSOURCE,
 2714                            LSMETHOD,
 2715                            'Body of PROCEDURE',
 2716                            IAPICONSTANT.INFOLEVEL_3 );
 2717       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2718                                            LNJOBID );
 2719       LNRETVAL := GETDAYSTODELETE( 'ITIMP_LOG(d)',
 2720                                    LNDAYS );
 2721 
 2722       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2723       THEN
 2724          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2725       ELSE
 2726          
 2727          SELECT COUNT( * )
 2728            INTO LNCOUNTBEFORE
 2729            FROM ITIMP_LOG;
 2730 
 2731          DELETE FROM ITIMP_LOG
 2732                WHERE   TIMESTAMP
 2733                      + LNDAYS < SYSDATE;
 2734 
 2735          
 2736          SELECT COUNT( * )
 2737            INTO LNCOUNTAFTER
 2738            FROM ITIMP_LOG;
 2739 
 2740          LNROWSDELETED :=   LNCOUNTBEFORE
 2741                           - LNCOUNTAFTER;
 2742          COMMIT;
 2743 
 2744          
 2745          UPDATE ITJOB
 2746             SET JOB = SUBSTR(    LSMETHOD
 2747                               || ' '
 2748                               || LNROWSDELETED
 2749                               || ' deleted',
 2750                               1,
 2751                               60 )
 2752           WHERE JOB_ID = LNJOBID;
 2753 
 2754          COMMIT;
 2755          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2756       END IF;
 2757    EXCEPTION
 2758       WHEN OTHERS
 2759       THEN
 2760          IAPIGENERAL.LOGERROR( GSSOURCE,
 2761                                LSMETHOD,
 2762                                SQLERRM );
 2763          ROLLBACK;
 2764          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2765    END REMOVEIMPORTLOG;
 2766 
 2767    
 2768    PROCEDURE REMOVESECTIONSLOG
 2769    IS
 2770       
 2771       
 2772       
 2773       
 2774       
 2775       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2776       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2777       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2778       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2779       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2780       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSectionsLog';
 2781    BEGIN
 2782       IAPIGENERAL.LOGINFO( GSSOURCE,
 2783                            LSMETHOD,
 2784                            'Body of PROCEDURE',
 2785                            IAPICONSTANT.INFOLEVEL_3 );
 2786       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2787                                            LNJOBID );
 2788 
 2789       
 2790       SELECT COUNT( * )
 2791         INTO LNCOUNTBEFORE
 2792         FROM ITSCUSRLOG;
 2793 
 2794       DELETE FROM ITSCUSRLOG
 2795             WHERE TIMESTAMP <=   SYSDATE
 2796                                - 2;
 2797 
 2798       
 2799       SELECT COUNT( * )
 2800         INTO LNCOUNTAFTER
 2801         FROM ITSCUSRLOG;
 2802 
 2803       LNROWSDELETED :=   LNCOUNTBEFORE
 2804                        - LNCOUNTAFTER;
 2805       COMMIT;
 2806 
 2807       
 2808       UPDATE ITJOB
 2809          SET JOB = SUBSTR(    LSMETHOD
 2810                            || ' '
 2811                            || LNROWSDELETED
 2812                            || ' deleted',
 2813                            1,
 2814                            60 )
 2815        WHERE JOB_ID = LNJOBID;
 2816 
 2817       COMMIT;
 2818       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2819    EXCEPTION
 2820       WHEN OTHERS
 2821       THEN
 2822          LNRETVAL := SQLCODE;
 2823          IAPIGENERAL.LOGERROR( GSSOURCE,
 2824                                LSMETHOD,
 2825                                SQLERRM );
 2826          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2827    END REMOVESECTIONSLOG;
 2828 
 2829    
 2830    PROCEDURE REMOVEIMPORTPROPBOMLOG
 2831    
 2832    
 2833    
 2834    
 2835    
 2836    
 2837    IS
 2838       
 2839       CURSOR LQIMPORTTODELETE
 2840       IS
 2841          SELECT DISTINCT IMPGETDATA_NO
 2842                     FROM ITIMPLOG
 2843                    WHERE TIMESTAMP <   SYSDATE
 2844                                      - 1;
 2845 
 2846       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2847       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2848       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2849       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2850       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2851       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveImportPropBomLog';
 2852    BEGIN
 2853       IAPIGENERAL.LOGINFO( GSSOURCE,
 2854                            LSMETHOD,
 2855                            'Body of PROCEDURE',
 2856                            IAPICONSTANT.INFOLEVEL_3 );
 2857       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2858                                            LNJOBID );
 2859 
 2860       
 2861       SELECT COUNT( * )
 2862         INTO LNCOUNTBEFORE
 2863         FROM ITIMPLOG;
 2864 
 2865       
 2866       FOR LRIMPORTTODELETE IN LQIMPORTTODELETE
 2867       LOOP
 2868          DELETE FROM ITIMPPROP
 2869                WHERE IMPGETDATA_NO = LRIMPORTTODELETE.IMPGETDATA_NO;
 2870 
 2871          DELETE FROM ITIMPBOM
 2872                WHERE IMPGETDATA_NO = LRIMPORTTODELETE.IMPGETDATA_NO;
 2873 
 2874          DELETE FROM ITIMPLOG
 2875                WHERE IMPGETDATA_NO = LRIMPORTTODELETE.IMPGETDATA_NO;
 2876       END LOOP;
 2877 
 2878       
 2879       SELECT COUNT( * )
 2880         INTO LNCOUNTAFTER
 2881         FROM ITIMPLOG;
 2882 
 2883       LNROWSDELETED :=   LNCOUNTBEFORE
 2884                        - LNCOUNTAFTER;
 2885       COMMIT;
 2886 
 2887       
 2888       UPDATE ITJOB
 2889          SET JOB = SUBSTR(    LSMETHOD
 2890                            || ' '
 2891                            || LNROWSDELETED
 2892                            || ' deleted',
 2893                            1,
 2894                            60 )
 2895        WHERE JOB_ID = LNJOBID;
 2896 
 2897       COMMIT;
 2898       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2899    EXCEPTION
 2900       WHEN OTHERS
 2901       THEN
 2902          IAPIGENERAL.LOGERROR( GSSOURCE,
 2903                                LSMETHOD,
 2904                                SQLERRM );
 2905          ROLLBACK;
 2906          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2907    END REMOVEIMPORTPROPBOMLOG;
 2908 
 2909    
 2910    PROCEDURE REMOVESPECIFICATIONSLOG
 2911    IS
 2912       
 2913       
 2914       
 2915       
 2916       
 2917       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2918       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 2919       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2920       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2921       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2922       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2923       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSpecificationsLog';
 2924    BEGIN
 2925       IAPIGENERAL.LOGINFO( GSSOURCE,
 2926                            LSMETHOD,
 2927                            'Body of PROCEDURE',
 2928                            IAPICONSTANT.INFOLEVEL_3 );
 2929       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 2930                                            LNJOBID );
 2931       LNRETVAL := GETDAYSTODELETE( 'DEL LOG SPECS (d)',
 2932                                    LNDAYS );
 2933 
 2934       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2935       THEN
 2936          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2937       ELSE
 2938          
 2939          SELECT COUNT( * )
 2940            INTO LNCOUNTBEFORE
 2941            FROM ITSHDEL;
 2942 
 2943          IF LNDAYS <> 9999
 2944          THEN
 2945             DELETE FROM ITSHDEL
 2946                   WHERE (   DELETION_DATE
 2947                           + LNDAYS ) <= SYSDATE;
 2948          END IF;
 2949 
 2950          
 2951          SELECT COUNT( * )
 2952            INTO LNCOUNTAFTER
 2953            FROM ITSHDEL;
 2954 
 2955          LNROWSDELETED :=   LNCOUNTBEFORE
 2956                           - LNCOUNTAFTER;
 2957          COMMIT;
 2958 
 2959          
 2960          UPDATE ITJOB
 2961             SET JOB = SUBSTR(    LSMETHOD
 2962                               || ' '
 2963                               || LNROWSDELETED
 2964                               || ' deleted',
 2965                               1,
 2966                               60 )
 2967           WHERE JOB_ID = LNJOBID;
 2968 
 2969          COMMIT;
 2970          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2971       END IF;
 2972    EXCEPTION
 2973       WHEN OTHERS
 2974       THEN
 2975          IAPIGENERAL.LOGERROR( GSSOURCE,
 2976                                LSMETHOD,
 2977                                SQLERRM );
 2978          ROLLBACK;
 2979          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 2980    END REMOVESPECIFICATIONSLOG;
 2981 
 2982    
 2983    PROCEDURE REMOVEFRAMESLOG
 2984    IS
 2985       
 2986       
 2987       
 2988       
 2989       
 2990       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2991       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 2992       LNJOBID                       IAPITYPE.JOBID_TYPE;
 2993       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 2994       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 2995       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 2996       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFramesLog';
 2997    BEGIN
 2998       IAPIGENERAL.LOGINFO( GSSOURCE,
 2999                            LSMETHOD,
 3000                            'Body of PROCEDURE',
 3001                            IAPICONSTANT.INFOLEVEL_3 );
 3002       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3003                                            LNJOBID );
 3004       LNRETVAL := GETDAYSTODELETE( 'DEL LOG FRAMES (d)',
 3005                                    LNDAYS );
 3006 
 3007       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 3008       THEN
 3009          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3010       ELSE
 3011          
 3012          SELECT COUNT( * )
 3013            INTO LNCOUNTBEFORE
 3014            FROM ITFRMDEL;
 3015 
 3016          IF LNDAYS <> 9999
 3017          THEN
 3018             DELETE FROM ITFRMDEL
 3019                   WHERE (   DELETION_DATE
 3020                           + LNDAYS ) <= SYSDATE;
 3021          END IF;
 3022 
 3023          
 3024          SELECT COUNT( * )
 3025            INTO LNCOUNTAFTER
 3026            FROM ITFRMDEL;
 3027 
 3028          LNROWSDELETED :=   LNCOUNTBEFORE
 3029                           - LNCOUNTAFTER;
 3030          COMMIT;
 3031 
 3032          
 3033          UPDATE ITJOB
 3034             SET JOB = SUBSTR(    LSMETHOD
 3035                               || ' '
 3036                               || LNROWSDELETED
 3037                               || ' deleted',
 3038                               1,
 3039                               60 )
 3040           WHERE JOB_ID = LNJOBID;
 3041 
 3042          COMMIT;
 3043          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3044       END IF;
 3045    EXCEPTION
 3046       WHEN OTHERS
 3047       THEN
 3048          IAPIGENERAL.LOGERROR( GSSOURCE,
 3049                                LSMETHOD,
 3050                                SQLERRM );
 3051          ROLLBACK;
 3052          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3053    END REMOVEFRAMESLOG;
 3054 
 3055    
 3056    PROCEDURE REMOVEDATAIMPORTLOG
 3057    IS
 3058       
 3059       
 3060       
 3061       
 3062       
 3063       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3064       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3065       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3066       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 3067       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 3068       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveDataImportLog (prop)';
 3069    BEGIN
 3070       IAPIGENERAL.LOGINFO( GSSOURCE,
 3071                            LSMETHOD,
 3072                            'Body of PROCEDURE',
 3073                            IAPICONSTANT.INFOLEVEL_3 );
 3074       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3075                                            LNJOBID );
 3076 
 3077       
 3078       SELECT COUNT( * )
 3079         INTO LNCOUNTBEFORE
 3080         FROM ITIMPPROP;
 3081 
 3082       DELETE FROM ITIMPPROP;
 3083 
 3084       
 3085       SELECT COUNT( * )
 3086         INTO LNCOUNTAFTER
 3087         FROM ITIMPPROP;
 3088 
 3089       LNROWSDELETED :=   LNCOUNTBEFORE
 3090                        - LNCOUNTAFTER;
 3091       COMMIT;
 3092 
 3093       
 3094       UPDATE ITJOB
 3095          SET JOB = SUBSTR(    LSMETHOD
 3096                            || ' '
 3097                            || LNROWSDELETED
 3098                            || ' deleted',
 3099                            1,
 3100                            60 )
 3101        WHERE JOB_ID = LNJOBID;
 3102 
 3103       COMMIT;
 3104       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3105       LSMETHOD := 'RemoveDataImportLog (bom)';
 3106       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3107                                            LNJOBID );
 3108 
 3109       
 3110       SELECT COUNT( * )
 3111         INTO LNCOUNTBEFORE
 3112         FROM ITIMPBOM;
 3113 
 3114       DELETE FROM ITIMPBOM;
 3115 
 3116       
 3117       SELECT COUNT( * )
 3118         INTO LNCOUNTAFTER
 3119         FROM ITIMPBOM;
 3120 
 3121       LNROWSDELETED :=   LNCOUNTBEFORE
 3122                        - LNCOUNTAFTER;
 3123       COMMIT;
 3124 
 3125       
 3126       UPDATE ITJOB
 3127          SET JOB = SUBSTR(    LSMETHOD
 3128                            || ' '
 3129                            || LNROWSDELETED
 3130                            || ' deleted',
 3131                            1,
 3132                            60 )
 3133        WHERE JOB_ID = LNJOBID;
 3134 
 3135       COMMIT;
 3136       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3137    EXCEPTION
 3138       WHEN OTHERS
 3139       THEN
 3140          IAPIGENERAL.LOGERROR( GSSOURCE,
 3141                                LSMETHOD,
 3142                                SQLERRM );
 3143          ROLLBACK;
 3144          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3145    END REMOVEDATAIMPORTLOG;
 3146 
 3147    
 3148    PROCEDURE REMOVENUTRITIONALLOG
 3149    IS
 3150       
 3151       
 3152       
 3153       
 3154       
 3155       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3156       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3157       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3158       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 3159       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 3160       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveNutritionalLog';
 3161    BEGIN
 3162       IAPIGENERAL.LOGINFO( GSSOURCE,
 3163                            LSMETHOD,
 3164                            'Body of PROCEDURE',
 3165                            IAPICONSTANT.INFOLEVEL_3 );
 3166       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3167                                            LNJOBID );
 3168 
 3169       
 3170       SELECT COUNT( * )
 3171         INTO LNCOUNTBEFORE
 3172         FROM ITNUTLOG;
 3173 
 3174       DELETE FROM ITNUTLOGRESULTDETAILS
 3175             WHERE LOG_ID IN( SELECT LOG_ID
 3176                               FROM ITNUTLOG I,
 3177                                    ITRDSTATUS S
 3178                              WHERE I.STATUS = S.STATUS
 3179                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3180 
 3181       DELETE FROM ITNUTLOGRESULT
 3182             WHERE LOG_ID IN( SELECT LOG_ID
 3183                               FROM ITNUTLOG I,
 3184                                    ITRDSTATUS S
 3185                              WHERE I.STATUS = S.STATUS
 3186                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3187 
 3188       DELETE FROM ITNUTLOG
 3189             WHERE LOG_ID IN( SELECT LOG_ID
 3190                               FROM ITNUTLOG I,
 3191                                    ITRDSTATUS S
 3192                              WHERE I.STATUS = S.STATUS
 3193                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3194 
 3195       
 3196       SELECT COUNT( * )
 3197         INTO LNCOUNTAFTER
 3198         FROM ITNUTLOG;
 3199 
 3200       LNROWSDELETED :=   LNCOUNTBEFORE
 3201                        - LNCOUNTAFTER;
 3202       COMMIT;
 3203 
 3204       
 3205       UPDATE ITJOB
 3206          SET JOB = SUBSTR(    LSMETHOD
 3207                            || ' '
 3208                            || LNROWSDELETED
 3209                            || ' deleted',
 3210                            1,
 3211                            60 )
 3212        WHERE JOB_ID = LNJOBID;
 3213 
 3214       COMMIT;
 3215       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3216    EXCEPTION
 3217       WHEN OTHERS
 3218       THEN
 3219          IAPIGENERAL.LOGERROR( GSSOURCE,
 3220                                LSMETHOD,
 3221                                SQLERRM );
 3222          ROLLBACK;
 3223          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3224    END REMOVENUTRITIONALLOG;
 3225 
 3226    
 3227    PROCEDURE REMOVETRANSLATIONGLOSSARY
 3228    IS
 3229       
 3230       
 3231       
 3232       
 3233       
 3234       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3235       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3236       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3237       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 3238       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 3239       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveTranslationGlossary';
 3240       LNDAYS                        IAPITYPE.NUMVAL_TYPE;
 3241    BEGIN
 3242       IAPIGENERAL.LOGINFO( GSSOURCE,
 3243                            LSMETHOD,
 3244                            'Body of PROCEDURE',
 3245                            IAPICONSTANT.INFOLEVEL_3 );
 3246       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3247                                            LNJOBID );
 3248       LNRETVAL := GETDAYSTODELETE( 'PRLOG (d)',
 3249                                    LNDAYS );
 3250 
 3251       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 3252       THEN
 3253          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3254       ELSE
 3255          
 3256          SELECT COUNT( * )
 3257            INTO LNCOUNTBEFORE
 3258            FROM IT_TR_JRNL;
 3259 
 3260          DELETE FROM IT_TR_JRNL
 3261                WHERE   LAST_MODIFIED_ON
 3262                      + LNDAYS < SYSDATE;
 3263 
 3264          
 3265          SELECT COUNT( * )
 3266            INTO LNCOUNTAFTER
 3267            FROM IT_TR_JRNL;
 3268 
 3269          LNROWSDELETED :=   LNCOUNTBEFORE
 3270                           - LNCOUNTAFTER;
 3271          COMMIT;
 3272 
 3273          
 3274          UPDATE ITJOB
 3275             SET JOB = SUBSTR(    LSMETHOD
 3276                               || ' '
 3277                               || LNROWSDELETED
 3278                               || ' deleted',
 3279                               1,
 3280                               60 )
 3281           WHERE JOB_ID = LNJOBID;
 3282 
 3283          COMMIT;
 3284          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3285       END IF;
 3286    EXCEPTION
 3287       WHEN OTHERS
 3288       THEN
 3289          IAPIGENERAL.LOGERROR( GSSOURCE,
 3290                                LSMETHOD,
 3291                                SQLERRM );
 3292          ROLLBACK;
 3293          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3294    END REMOVETRANSLATIONGLOSSARY;
 3295 
 3296    
 3297    PROCEDURE REMOVELABELLOG
 3298    IS
 3299       
 3300       
 3301       
 3302       
 3303       
 3304       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3305       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3306       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3307       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 3308       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 3309       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveLabelLog';
 3310    BEGIN
 3311       IAPIGENERAL.LOGINFO( GSSOURCE,
 3312                            LSMETHOD,
 3313                            'Body of PROCEDURE',
 3314                            IAPICONSTANT.INFOLEVEL_3 );
 3315       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3316                                            LNJOBID );
 3317 
 3318       
 3319       SELECT COUNT( * )
 3320         INTO LNCOUNTBEFORE
 3321         FROM ITLABELLOG;
 3322 
 3323       DELETE FROM ITLABELLOGRESULTDETAILS
 3324             WHERE LOG_ID IN( SELECT L.LOG_ID
 3325                               FROM ITLABELLOG L,
 3326                                    ITRDSTATUS S
 3327                              WHERE L.STATUS = S.STATUS
 3328                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3329 
 3330       DELETE FROM ITLABELLOG
 3331             WHERE LOG_ID IN( SELECT L.LOG_ID
 3332                               FROM ITLABELLOG L,
 3333                                    ITRDSTATUS S
 3334                              WHERE L.STATUS = S.STATUS
 3335                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3336 
 3337       
 3338       SELECT COUNT( * )
 3339         INTO LNCOUNTAFTER
 3340         FROM ITLABELLOG;
 3341 
 3342       LNROWSDELETED :=   LNCOUNTBEFORE
 3343                        - LNCOUNTAFTER;
 3344       COMMIT;
 3345 
 3346       
 3347       UPDATE ITJOB
 3348          SET JOB = SUBSTR(    LSMETHOD
 3349                            || ' '
 3350                            || LNROWSDELETED
 3351                            || ' deleted',
 3352                            1,
 3353                            60 )
 3354        WHERE JOB_ID = LNJOBID;
 3355 
 3356       COMMIT;
 3357       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3358    EXCEPTION
 3359       WHEN OTHERS
 3360       THEN
 3361          IAPIGENERAL.LOGERROR( GSSOURCE,
 3362                                LSMETHOD,
 3363                                SQLERRM );
 3364          ROLLBACK;
 3365          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3366    END REMOVELABELLOG;
 3367 
 3368    
 3369    PROCEDURE REMOVECLAIMLOG
 3370    IS
 3371       
 3372       
 3373       
 3374       
 3375       
 3376       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3377       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3378       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3379       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 3380       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 3381       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveClaimLog';
 3382    BEGIN
 3383       IAPIGENERAL.LOGINFO( GSSOURCE,
 3384                            LSMETHOD,
 3385                            'Body of PROCEDURE',
 3386                            IAPICONSTANT.INFOLEVEL_3 );
 3387       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3388                                            LNJOBID );
 3389 
 3390       
 3391       SELECT COUNT( * )
 3392         INTO LNCOUNTBEFORE
 3393         FROM ITCLAIMLOG;
 3394 
 3395       DELETE FROM ITCLAIMLOGRESULT
 3396             WHERE LOG_ID IN( SELECT L.LOG_ID
 3397                               FROM ITCLAIMLOG L,
 3398                                    ITRDSTATUS S
 3399                              WHERE L.STATUS = S.STATUS
 3400                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3401 
 3402       DELETE FROM ITCLAIMLOG
 3403             WHERE LOG_ID IN( SELECT L.LOG_ID
 3404                               FROM ITCLAIMLOG L,
 3405                                    ITRDSTATUS S
 3406                              WHERE L.STATUS = S.STATUS
 3407                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3408 
 3409       
 3410       SELECT COUNT( * )
 3411         INTO LNCOUNTAFTER
 3412         FROM ITCLAIMLOG;
 3413 
 3414       LNROWSDELETED :=   LNCOUNTBEFORE
 3415                        - LNCOUNTAFTER;
 3416       COMMIT;
 3417 
 3418       
 3419       UPDATE ITJOB
 3420          SET JOB = SUBSTR(    LSMETHOD
 3421                            || ' '
 3422                            || LNROWSDELETED
 3423                            || ' deleted',
 3424                            1,
 3425                            60 )
 3426        WHERE JOB_ID = LNJOBID;
 3427 
 3428       COMMIT;
 3429       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3430    EXCEPTION
 3431       WHEN OTHERS
 3432       THEN
 3433          IAPIGENERAL.LOGERROR( GSSOURCE,
 3434                                LSMETHOD,
 3435                                SQLERRM );
 3436          ROLLBACK;
 3437          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3438    END REMOVECLAIMLOG;
 3439 
 3440    
 3441    PROCEDURE REMOVENUTRITIONALEXPLOSION
 3442    IS
 3443       
 3444       
 3445       
 3446       
 3447       
 3448       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3449       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3450       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3451       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveNutritionalExplosion';
 3452    BEGIN
 3453       IAPIGENERAL.LOGINFO( GSSOURCE,
 3454                            LSMETHOD,
 3455                            'Body of PROCEDURE',
 3456                            IAPICONSTANT.INFOLEVEL_3 );
 3457       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3458                                            LNJOBID );
 3459 
 3460       DELETE FROM ITNUTEXPLOSION;
 3461 
 3462       LNROWSDELETED := SQL%ROWCOUNT;
 3463 
 3464       DELETE FROM ITNUTPATH;
 3465 
 3466       DELETE FROM ITNUTRESULT;
 3467 
 3468       DELETE FROM ITNUTRESULTDETAIL;
 3469 
 3470       COMMIT;
 3471 
 3472       
 3473       UPDATE ITJOB
 3474          SET JOB = SUBSTR(    LSMETHOD
 3475                            || ' '
 3476                            || LNROWSDELETED
 3477                            || ' deleted',
 3478                            1,
 3479                            60 )
 3480        WHERE JOB_ID = LNJOBID;
 3481 
 3482       COMMIT;
 3483       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3484    EXCEPTION
 3485       WHEN OTHERS
 3486       THEN
 3487          IAPIGENERAL.LOGERROR( GSSOURCE,
 3488                                LSMETHOD,
 3489                                SQLERRM );
 3490          ROLLBACK;
 3491          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3492    END REMOVENUTRITIONALEXPLOSION;
 3493 
 3494    
 3495    PROCEDURE REMOVEFOODCLAIMLOG
 3496    IS
 3497       
 3498       
 3499       
 3500       
 3501       
 3502       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3503       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3504       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3505       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 3506       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 3507       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFoodClaimLog';
 3508    BEGIN
 3509       IAPIGENERAL.LOGINFO( GSSOURCE,
 3510                            LSMETHOD,
 3511                            'Body of PROCEDURE',
 3512                            IAPICONSTANT.INFOLEVEL_3 );
 3513       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3514                                            LNJOBID );
 3515 
 3516       
 3517       SELECT COUNT( * )
 3518         INTO LNCOUNTBEFORE
 3519         FROM ITFOODCLAIMLOG;
 3520 
 3521       DELETE FROM ITFOODCLAIMLOGRESULTDETAILS
 3522             WHERE LOG_ID IN( SELECT L.LOG_ID
 3523                               FROM ITFOODCLAIMLOG L,
 3524                                    ITRDSTATUS S
 3525                              WHERE L.STATUS = S.STATUS
 3526                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3527 
 3528       DELETE FROM ITFOODCLAIMLOGRESULT
 3529             WHERE LOG_ID IN( SELECT L.LOG_ID
 3530                               FROM ITFOODCLAIMLOG L,
 3531                                    ITRDSTATUS S
 3532                              WHERE L.STATUS = S.STATUS
 3533                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3534 
 3535       DELETE FROM ITFOODCLAIMLOG
 3536             WHERE LOG_ID IN( SELECT L.LOG_ID
 3537                               FROM ITFOODCLAIMLOG L,
 3538                                    ITRDSTATUS S
 3539                              WHERE L.STATUS = S.STATUS
 3540                                AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_OBSOLETE );
 3541 
 3542       
 3543       SELECT COUNT( * )
 3544         INTO LNCOUNTAFTER
 3545         FROM ITFOODCLAIMLOG;
 3546 
 3547       LNROWSDELETED :=   LNCOUNTBEFORE
 3548                        - LNCOUNTAFTER;
 3549       COMMIT;
 3550 
 3551       
 3552       UPDATE ITJOB
 3553          SET JOB = SUBSTR(    LSMETHOD
 3554                            || ' '
 3555                            || LNROWSDELETED
 3556                            || ' deleted',
 3557                            1,
 3558                            60 )
 3559        WHERE JOB_ID = LNJOBID;
 3560 
 3561       COMMIT;
 3562       LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3563    EXCEPTION
 3564       WHEN OTHERS
 3565       THEN
 3566          IAPIGENERAL.LOGERROR( GSSOURCE,
 3567                                LSMETHOD,
 3568                                SQLERRM );
 3569          ROLLBACK;
 3570          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3571    END REMOVEFOODCLAIMLOG;
 3572 
 3573    
 3574    PROCEDURE REMOVEEVENTLOG
 3575    IS
 3576       
 3577       
 3578       
 3579       
 3580       
 3581       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3582       LNDAYS                        IAPITYPE.NUMVAL_TYPE := 0;
 3583       LNJOBID                       IAPITYPE.JOBID_TYPE;
 3584       LNROWSDELETED                 IAPITYPE.NUMVAL_TYPE := 0;
 3585       LNCOUNTBEFORE                 IAPITYPE.NUMVAL_TYPE := 0;
 3586       LNCOUNTAFTER                  IAPITYPE.NUMVAL_TYPE := 0;
 3587       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveEventLog';
 3588    BEGIN
 3589       IAPIGENERAL.LOGINFO( GSSOURCE,
 3590                            LSMETHOD,
 3591                            'Body of PROCEDURE',
 3592                            IAPICONSTANT.INFOLEVEL_3 );
 3593       LNRETVAL := IAPIJOBLOGGING.STARTJOB( LSMETHOD,
 3594                                            LNJOBID );
 3595       LNRETVAL := GETDAYSTODELETE( 'EVENT LOG (days)',
 3596                                    LNDAYS );
 3597 
 3598       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 3599       THEN
 3600          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3601       ELSE
 3602          
 3603          SELECT COUNT( * )
 3604            INTO LNCOUNTBEFORE
 3605            FROM ITEVENTLOG;
 3606 
 3607          DELETE FROM ITEVENTLOG
 3608                WHERE (   CREATED_ON
 3609                        + LNDAYS ) <= SYSDATE;
 3610 
 3611          
 3612          SELECT COUNT( * )
 3613            INTO LNCOUNTAFTER
 3614            FROM ITEVENTLOG;
 3615 
 3616          LNROWSDELETED :=   LNCOUNTBEFORE
 3617                           - LNCOUNTAFTER;
 3618          COMMIT;
 3619 
 3620          
 3621          UPDATE ITJOB
 3622             SET JOB = SUBSTR(    LSMETHOD
 3623                               || ' '
 3624                               || LNROWSDELETED
 3625                               || ' deleted',
 3626                               1,
 3627                               60 )
 3628           WHERE JOB_ID = LNJOBID;
 3629 
 3630          COMMIT;
 3631          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3632       END IF;
 3633    EXCEPTION
 3634       WHEN OTHERS
 3635       THEN
 3636          IAPIGENERAL.LOGERROR( GSSOURCE,
 3637                                LSMETHOD,
 3638                                SQLERRM );
 3639          LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNJOBID );
 3640    END REMOVEEVENTLOG;
 3641 
 3642    
 3643    
 3644    
 3645    
 3646    PROCEDURE REMOVEOBSOLETEDATA
 3647    IS
 3648       
 3649       
 3650       
 3651       
 3652       
 3653       
 3654       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveObsoleteData';
 3655       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3656    BEGIN
 3657       
 3658       
 3659       
 3660       IAPIGENERAL.LOGINFO( GSSOURCE,
 3661                            LSMETHOD,
 3662                            'Body of PROCEDURE',
 3663                            IAPICONSTANT.INFOLEVEL_3 );
 3664 
 3665       
 3666       IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
 3667       THEN
 3668          LNRETVAL := IAPIGENERAL.SETCONNECTION( USER,
 3669                                                 'DELETE OBSOLETE DATA JOB' );
 3670 
 3671          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 3672          THEN
 3673             RAISE_APPLICATION_ERROR( -20000,
 3674                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
 3675          END IF;
 3676       END IF;
 3677 
 3678       
 3679       REMOVEJOBS;
 3680       
 3681       REMOVEERRORS;
 3682       
 3683       REMOVESPECIFICATIONS;
 3684       
 3685       REMOVEFRAMES;
 3686       
 3687       REMOVEOBJECTS;
 3688       
 3689       REMOVEREFERENCETEXTS;
 3690       
 3691       REMOVEBOMIMPLOSION;
 3692       
 3693       REMOVEBOMEXPLOSION;
 3694       
 3695       REMOVECOMPARE;
 3696       
 3697       REMOVETEXTSEARCH;
 3698       
 3699       REMOVESERVER;
 3700       
 3701       REMOVEJRNLSPEC;
 3702       
 3703       REMOVEJRNLBOM;
 3704       
 3705       REMOVETRANSLATIONGLOSSARY;
 3706       
 3707       REMOVEIMPORTLOG;
 3708       
 3709       REMOVEIMPORTPROPBOMLOG;
 3710       
 3711       REMOVESECTIONSLOG;
 3712       
 3713       REMOVESPECIFICATIONSLOG;
 3714       
 3715       REMOVEFRAMESLOG;
 3716       
 3717       REMOVEDATAIMPORTLOG;
 3718       
 3719       REMOVENUTRITIONALLOG;
 3720       
 3721       REMOVELABELLOG;
 3722       
 3723       REMOVECLAIMLOG;
 3724       
 3725       REMOVENUTRITIONALEXPLOSION;
 3726       
 3727       REMOVEFOODCLAIMLOG;
 3728       
 3729       REMOVEEVENTLOG;
 3730    EXCEPTION
 3731       WHEN OTHERS
 3732       THEN
 3733          IAPIGENERAL.LOGERROR( GSSOURCE,
 3734                                LSMETHOD,
 3735                                SQLERRM );
 3736          LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
 3737          RAISE_APPLICATION_ERROR( -20000,
 3738                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
 3739    END REMOVEOBSOLETEDATA;
 3740 
 3741    
 3742    FUNCTION ISLASTONE(
 3743       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
 3744       RETURN IAPITYPE.NUMVAL_TYPE
 3745    IS
 3746       
 3747       
 3748       
 3749       
 3750       
 3751       LNSPECIFCATIONCOUNT           IAPITYPE.NUMVAL_TYPE := 0;
 3752       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsLastOne';
 3753    BEGIN
 3754       SELECT COUNT( * )
 3755         INTO LNSPECIFCATIONCOUNT
 3756         FROM SPECIFICATION_HEADER
 3757        WHERE PART_NO = ASPARTNO;
 3758 
 3759       RETURN LNSPECIFCATIONCOUNT;
 3760    EXCEPTION
 3761       WHEN OTHERS
 3762       THEN
 3763          IAPIGENERAL.LOGERROR( GSSOURCE,
 3764                                LSMETHOD,
 3765                                SQLERRM );
 3766          RETURN LNSPECIFCATIONCOUNT;
 3767    END ISLASTONE;
 3768 END IAPIDELETION;
 