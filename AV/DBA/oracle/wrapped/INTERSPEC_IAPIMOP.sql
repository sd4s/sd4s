   1 PACKAGE BODY iapiMop
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
   18    PSMOPJOB                      VARCHAR2( 32 ) := 'iapiQueue.ExecuteQueue';
   19    PSMOPJOBNAME                  VARCHAR2( 32 ) := 'DB_Q';
   20 
   21    
   22    FUNCTION GETPACKAGEVERSION
   23       RETURN IAPITYPE.STRING_TYPE
   24    IS
   25       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   26    BEGIN
   27       
   28       
   29       
   30         RETURN(    IAPIGENERAL.GETVERSION
   31               || ' ($Revision: 6.7.0.0 (06.07.00.00-01.00) $)' );
   32    EXCEPTION
   33       WHEN OTHERS
   34       THEN
   35          IAPIGENERAL.LOGERROR( GSSOURCE,
   36                                LSMETHOD,
   37                                SQLERRM );
   38          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   39    END GETPACKAGEVERSION;
   40 
   41    
   42    
   43    
   44 
   45    
   46    
   47    
   48    
   49    
   50    
   51    
   52    FUNCTION ADDSPECIFICATION(
   53       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
   54       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
   55       ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
   56       RETURN IAPITYPE.ERRORNUM_TYPE
   57    IS
   58       
   59       
   60       
   61       
   62       
   63       
   64       
   65       
   66       
   67       
   68       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddSpecification';
   69       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   70    BEGIN
   71       
   72       
   73       
   74       IAPIGENERAL.LOGINFO( GSSOURCE,
   75                            LSMETHOD,
   76                            'PreConditions',
   77                            IAPICONSTANT.INFOLEVEL_3 );
   78       
   79       
   80 
   81       
   82       LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
   83                                              ANREVISION );
   84 
   85       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
   86       THEN
   87          IAPIGENERAL.LOGINFO( GSSOURCE,
   88                               LSMETHOD,
   89                               IAPIGENERAL.GETLASTERRORTEXT( ) );
   90          RETURN( LNRETVAL );
   91       END IF;
   92 
   93       
   94       
   95       
   96       IAPIGENERAL.LOGINFO( GSSOURCE,
   97                            LSMETHOD,
   98                            'Body of PROCEDURE',
   99                            IAPICONSTANT.INFOLEVEL_3 );
  100 
  101       BEGIN
  102          INSERT INTO ITSHQ
  103                      ( USER_ID,
  104                        PART_NO,
  105                        REVISION )
  106               VALUES ( ASUSERID,
  107                        ASPARTNO,
  108                        ANREVISION );
  109       EXCEPTION
  110          
  111          WHEN DUP_VAL_ON_INDEX
  112          THEN
  113             NULL;
  114       END;
  115 
  116       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  117    EXCEPTION
  118       WHEN OTHERS
  119       THEN
  120          IAPIGENERAL.LOGERROR( GSSOURCE,
  121                                LSMETHOD,
  122                                SQLERRM );
  123          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  124    END ADDSPECIFICATION;
  125 
  126 
  127 
  128    
  129    FUNCTION SAVESPECIFICATION(
  130       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
  131       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  132       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
  133       ANSELECTED                 IN       IAPITYPE.BOOLEAN_TYPE)
  134       RETURN IAPITYPE.ERRORNUM_TYPE
  135    IS
  136       
  137       
  138       
  139       
  140       
  141       
  142       
  143       
  144       
  145       
  146       
  147       
  148       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveSpecification';
  149       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  150    BEGIN
  151       
  152       
  153       
  154       IAPIGENERAL.LOGINFO( GSSOURCE,
  155                            LSMETHOD,
  156                            'PreConditions',
  157                            IAPICONSTANT.INFOLEVEL_3 );
  158 
  159       
  160       
  161       
  162       IAPIGENERAL.LOGINFO( GSSOURCE,
  163                            LSMETHOD,
  164                            'Body of PROCEDURE',
  165                            IAPICONSTANT.INFOLEVEL_3 );
  166 
  167 
  168          UPDATE ITSHQ
  169             SET SELECTED = ANSELECTED
  170          WHERE USER_ID = ASUSERID
  171             AND PART_NO = ASPARTNO
  172             AND REVISION = ANREVISION;
  173 
  174          COMMIT;
  175 
  176 
  177 
  178 
  179 
  180 
  181       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  182    EXCEPTION
  183       WHEN OTHERS
  184       THEN
  185          IAPIGENERAL.LOGERROR( GSSOURCE,
  186                                LSMETHOD,
  187                                SQLERRM );
  188          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  189    END SAVESPECIFICATION;
  190 
  191 
  192 
  193    
  194    FUNCTION SAVESPECIFICATIONS(
  195       ASUSERID                   IN       IAPITYPE.USERID_TYPE)
  196       RETURN IAPITYPE.ERRORNUM_TYPE
  197    IS
  198       
  199       
  200       
  201       
  202       
  203       
  204       
  205       
  206       
  207       
  208       
  209       
  210       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveSpecifications';
  211       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  212    BEGIN
  213       
  214       
  215       
  216       IAPIGENERAL.LOGINFO( GSSOURCE,
  217                            LSMETHOD,
  218                            'PreConditions',
  219                            IAPICONSTANT.INFOLEVEL_3 );
  220 
  221       
  222       
  223       
  224       IAPIGENERAL.LOGINFO( GSSOURCE,
  225                            LSMETHOD,
  226                            'Body of PROCEDURE',
  227                            IAPICONSTANT.INFOLEVEL_3 );
  228 
  229 
  230          UPDATE ITSHQ
  231             SET SELECTED = 1
  232          WHERE USER_ID = ASUSERID;
  233 
  234          COMMIT;
  235 
  236 
  237 
  238 
  239 
  240 
  241       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  242    EXCEPTION
  243       WHEN OTHERS
  244       THEN
  245          IAPIGENERAL.LOGERROR( GSSOURCE,
  246                                LSMETHOD,
  247                                SQLERRM );
  248          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  249    END SAVESPECIFICATIONS;
  250 
  251    
  252    FUNCTION GETLIST(
  253       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
  254       AQLIST                     OUT      IAPITYPE.REF_TYPE )
  255       RETURN IAPITYPE.ERRORNUM_TYPE
  256    IS
  257       
  258       
  259       
  260       
  261       
  262       
  263       
  264       
  265       
  266       
  267       
  268       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetList';
  269       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  270       LSSQL                         VARCHAR2( 8192 ) := NULL;
  271       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
  272       LSSELECT                      VARCHAR2( 4096 )
  273          :=    'i.part_no '
  274             || IAPICONSTANTCOLUMN.PARTNOCOL
  275             || ', i.revision '
  276             || IAPICONSTANTCOLUMN.REVISIONCOL
  277             || ', f_sh_descr(1, i.part_no, i.revision) '
  278             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
  279             || ', sh.status '
  280             || IAPICONSTANTCOLUMN.STATUSIDCOL
  281             || ', f_ss_descr(sh.status) '
  282             || IAPICONSTANTCOLUMN.STATUSCOL
  283             || ', ss.status_type '
  284             || IAPICONSTANTCOLUMN.STATUSTYPECOL
  285             || ', f_get_access(i.part_no, i.revision, i.user_id, i.user_intl) '
  286             || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
  287             || ', sh.workflow_group_id '
  288             || IAPICONSTANTCOLUMN.WORKFLOWGROUPIDCOL
  289             || ', sh.frame_id '
  290             || IAPICONSTANTCOLUMN.FRAMENOCOL
  291             || ', sh.frame_rev '
  292             || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
  293             || ', sh.frame_owner '
  294             || IAPICONSTANTCOLUMN.FRAMEOWNERCOL
  295             || ', sh.frame_id||'
  296             || ''' ['''
  297             || '||sh.frame_rev||'
  298             || ''']'' '
  299             || IAPICONSTANTCOLUMN.FORMATTEDFRAMECOL
  300             || ', sh.mask_id '
  301             || IAPICONSTANTCOLUMN.MASKIDCOL
  302             || ', iv.description '
  303             || IAPICONSTANTCOLUMN.MASKCOL
  304             || ', f_wf_descr(sh.workflow_group_id) '
  305             || IAPICONSTANTCOLUMN.WORKFLOWGROUPCOL
  306             || ', sh.access_group '
  307             || IAPICONSTANTCOLUMN.ACCESSGROUPIDCOL
  308             || ', f_ac_descr(sh.access_group) '
  309             
  310 
  311             || IAPICONSTANTCOLUMN.ACCESSGROUPCOL
  312             || ', i.selected '
  313             
  314             || IAPICONSTANTCOLUMN.SELECTEDCOL
  315             
  316             
  317             || ', DECODE( ss.STATUS_TYPE, ''' || IAPICONSTANT.STATUSTYPE_DEVELOPMENT || ''', ' 
  318             || '  ( SELECT TEXT '
  319             || '    FROM REASON '
  320             || '    WHERE REASON.PART_NO = i.PART_NO '
  321             || '    AND REASON.REVISION = i.REVISION '
  322             || '    AND REASON.STATUS_TYPE = ''' || IAPICONSTANT.STATUSTYPE_REASONFORISSUE || ''' '
  323             || '    AND REASON.ID = ( SELECT MAX( ID ) '
  324             || '                      FROM REASON '
  325             || '                      WHERE REASON.id > 0 ' 
  326             || '                      AND REASON.PART_NO = i.PART_NO '
  327             || '                      AND REASON.REVISION = i.REVISION '
  328             || '                      AND REASON.STATUS_TYPE = ''' || IAPICONSTANT.STATUSTYPE_REASONFORISSUE || ''' ) ), NULL ) '             
  329             || IAPICONSTANTCOLUMN.REASONFORISSUECOL;
  330             
  331             
  332       LSFROM                        IAPITYPE.STRING_TYPE := 'status ss, itfrmv iv, specification_header sh, itshq i ';
  333    BEGIN
  334       
  335       
  336       
  337       
  338       
  339       IF ( AQLIST%ISOPEN )
  340       THEN
  341          CLOSE AQLIST;
  342       END IF;
  343 
  344       LSSQLNULL :=    'SELECT '
  345                    || LSSELECT
  346                    || ' FROM '
  347                    || LSFROM
  348                    || ' WHERE i.part_no = NULL';
  349       LSSQLNULL :=    'SELECT a.*, RowNum '
  350                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
  351                    || ' FROM ('
  352                    || LSSQLNULL
  353                    || ') a';
  354       IAPIGENERAL.LOGINFO( GSSOURCE,
  355                            LSMETHOD,
  356                            LSSQLNULL,
  357                            IAPICONSTANT.INFOLEVEL_3 );
  358 
  359       OPEN AQLIST FOR LSSQLNULL;
  360 
  361       
  362       
  363       
  364       IAPIGENERAL.LOGINFO( GSSOURCE,
  365                            LSMETHOD,
  366                            'PreConditions',
  367                            IAPICONSTANT.INFOLEVEL_3 );
  368       
  369       
  370 
  371       
  372       
  373       
  374       IAPIGENERAL.LOGINFO( GSSOURCE,
  375                            LSMETHOD,
  376                            'Body of FUNCTION',
  377                            IAPICONSTANT.INFOLEVEL_3 );
  378       
  379       LSSQL :=
  380             'SELECT '
  381          || LSSELECT
  382          || ' FROM '
  383          || LSFROM
  384          || ' WHERE i.user_id=:id '
  385          || '   AND i.part_no = sh.part_no AND i.revision = sh.revision AND sh.status = ss.status '
  386          || '   AND sh.frame_id = iv.frame_no(+) AND sh.frame_rev = iv.revision(+) AND sh.frame_owner = iv.owner(+) AND sh.mask_id = iv.view_id(+) ';
  387       LSSQL :=    LSSQL
  388                || ' ORDER BY '
  389                || IAPICONSTANTCOLUMN.PARTNOCOL
  390                || ','
  391                || IAPICONSTANTCOLUMN.REVISIONCOL;
  392       LSSQL :=    'SELECT a.*, RowNum '
  393                || IAPICONSTANTCOLUMN.ROWINDEXCOL
  394                || ' FROM ('
  395                || LSSQL
  396                || ') a';
  397       IAPIGENERAL.LOGINFO( GSSOURCE,
  398                            LSMETHOD,
  399                            LSSQL,
  400                            IAPICONSTANT.INFOLEVEL_3 );
  401 
  402       
  403       IF ( AQLIST%ISOPEN )
  404       THEN
  405          CLOSE AQLIST;
  406       END IF;
  407 
  408       
  409       OPEN AQLIST FOR LSSQL USING ASUSERID;
  410 
  411       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  412    EXCEPTION
  413       WHEN OTHERS
  414       THEN
  415          IAPIGENERAL.LOGERROR( GSSOURCE,
  416                                LSMETHOD,
  417                                SQLERRM );
  418          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  419    END GETLIST;
  420 
  421    
  422    FUNCTION REMOVEALL(
  423       ASUSERID                   IN       IAPITYPE.USERID_TYPE )
  424       RETURN IAPITYPE.ERRORNUM_TYPE
  425    IS
  426       
  427       
  428       
  429       
  430       
  431       
  432       
  433       
  434       
  435       
  436       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveAll';
  437       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  438    BEGIN
  439       
  440       
  441       
  442       IAPIGENERAL.LOGINFO( GSSOURCE,
  443                            LSMETHOD,
  444                            'PreConditions',
  445                            IAPICONSTANT.INFOLEVEL_3 );
  446       
  447       
  448       
  449 
  450       
  451       
  452       
  453       IAPIGENERAL.LOGINFO( GSSOURCE,
  454                            LSMETHOD,
  455                            'Body of FUNCTION',
  456                            IAPICONSTANT.INFOLEVEL_3 );
  457 
  458       DELETE FROM ITSHQ
  459             WHERE USER_ID = ASUSERID;
  460 
  461       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  462    EXCEPTION
  463       WHEN OTHERS
  464       THEN
  465          IAPIGENERAL.LOGERROR( GSSOURCE,
  466                                LSMETHOD,
  467                                SQLERRM );
  468          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  469    END REMOVEALL;
  470 
  471    
  472    FUNCTION REMOVESPECIFICATION(
  473       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
  474       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  475       ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
  476       RETURN IAPITYPE.ERRORNUM_TYPE
  477    IS
  478       
  479       
  480       
  481       
  482       
  483       
  484       
  485       
  486       
  487       
  488       
  489       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSpecification';
  490       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  491    BEGIN
  492       
  493       
  494       
  495       IAPIGENERAL.LOGINFO( GSSOURCE,
  496                            LSMETHOD,
  497                            'PreConditions',
  498                            IAPICONSTANT.INFOLEVEL_3 );
  499       
  500       
  501       
  502 
  503       
  504       
  505       
  506       IAPIGENERAL.LOGINFO( GSSOURCE,
  507                            LSMETHOD,
  508                            'Body of FUNCTION',
  509                            IAPICONSTANT.INFOLEVEL_3 );
  510 
  511       DELETE FROM ITSHQ
  512             WHERE USER_ID = ASUSERID
  513               AND PART_NO = ASPARTNO
  514               AND REVISION = ANREVISION;
  515 
  516       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  517    EXCEPTION
  518       WHEN OTHERS
  519       THEN
  520          IAPIGENERAL.LOGERROR( GSSOURCE,
  521                                LSMETHOD,
  522                                SQLERRM );
  523          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  524    END REMOVESPECIFICATION;
  525 
  526    
  527    FUNCTION GETJOBSTATUS(
  528       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
  529       AQLIST                     OUT      IAPITYPE.REF_TYPE )
  530       RETURN IAPITYPE.ERRORNUM_TYPE
  531    IS
  532       
  533       
  534       
  535       
  536       
  537       
  538       
  539       
  540       
  541       
  542       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetJobStatus';
  543       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  544       LSSQL                         VARCHAR2( 8192 ) := NULL;
  545       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
  546       LSSELECT                      VARCHAR2( 4096 )
  547          :=    'i.job_descr '
  548             || IAPICONSTANTCOLUMN.JOBDESCRIPTIONCOL
  549             || ', au.last_name '
  550             || IAPICONSTANTCOLUMN.LASTNAMECOL
  551             || ', au.forename '
  552             || IAPICONSTANTCOLUMN.FORENAMECOL
  553             || ', i.status '
  554             || IAPICONSTANTCOLUMN.JOBSTATUSCOL
  555             || ', i.progress '
  556             || IAPICONSTANTCOLUMN.PROGRESSCOL
  557             || ', i.user_id '
  558             || IAPICONSTANTCOLUMN.USERIDCOL
  559             || ', i.start_date '
  560             || IAPICONSTANTCOLUMN.STARTDATECOL
  561             || ', i.end_date '
  562             || IAPICONSTANTCOLUMN.ENDDATECOL;
  563       LSFROM                        IAPITYPE.STRING_TYPE := 'application_user au, itq i ';
  564    BEGIN
  565       
  566       
  567       
  568       
  569       
  570       IF ( AQLIST%ISOPEN )
  571       THEN
  572          CLOSE AQLIST;
  573       END IF;
  574 
  575       LSSQLNULL :=    'SELECT '
  576                    || LSSELECT
  577                    || ' FROM '
  578                    || LSFROM
  579                    || ' WHERE i.user_id = NULL';
  580       IAPIGENERAL.LOGINFO( GSSOURCE,
  581                            LSMETHOD,
  582                            LSSQLNULL,
  583                            IAPICONSTANT.INFOLEVEL_3 );
  584 
  585       OPEN AQLIST FOR LSSQLNULL;
  586 
  587       
  588       
  589       
  590       IAPIGENERAL.LOGINFO( GSSOURCE,
  591                            LSMETHOD,
  592                            'PreConditions',
  593                            IAPICONSTANT.INFOLEVEL_3 );
  594       
  595       
  596 
  597       
  598       
  599       
  600       IAPIGENERAL.LOGINFO( GSSOURCE,
  601                            LSMETHOD,
  602                            'Body of FUNCTION',
  603                            IAPICONSTANT.INFOLEVEL_3 );
  604       
  605       LSSQL :=
  606             'SELECT '
  607          || LSSELECT
  608          || ' FROM '
  609          || LSFROM
  610          || ' WHERE i.user_id = au.user_id '
  611          || '   AND ( i.status = ''Started'' OR i.user_id = :userid ) ';
  612       LSSQL :=    LSSQL
  613                || ' ORDER BY '
  614                || IAPICONSTANTCOLUMN.STARTDATECOL;
  615       IAPIGENERAL.LOGINFO( GSSOURCE,
  616                            LSMETHOD,
  617                            LSSQL,
  618                            IAPICONSTANT.INFOLEVEL_3 );
  619 
  620       
  621       IF ( AQLIST%ISOPEN )
  622       THEN
  623          CLOSE AQLIST;
  624       END IF;
  625 
  626       
  627       OPEN AQLIST FOR LSSQL USING ASUSERID;
  628 
  629       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  630    EXCEPTION
  631       WHEN OTHERS
  632       THEN
  633          IAPIGENERAL.LOGERROR( GSSOURCE,
  634                                LSMETHOD,
  635                                SQLERRM );
  636          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  637    END GETJOBSTATUS;
  638 
  639    
  640    FUNCTION GETJOBLOG(
  641       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
  642       ADLOGDATE                  IN       IAPITYPE.DATE_TYPE,
  643       AQLIST                     OUT      IAPITYPE.REF_TYPE )
  644       RETURN IAPITYPE.ERRORNUM_TYPE
  645    IS
  646       
  647       
  648       
  649       
  650       
  651       
  652       
  653       
  654       
  655       
  656       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetJobLog';
  657       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  658       LSSQL                         VARCHAR2( 8192 ) := NULL;
  659       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
  660       LSSELECT                      VARCHAR2( 4096 )
  661                                                     :=    'error_msg '
  662                                                        || IAPICONSTANTCOLUMN.ERRORTEXTCOL
  663                                                        || ', logdate '
  664                                                        || IAPICONSTANTCOLUMN.DATE1COL;
  665       LSFROM                        IAPITYPE.STRING_TYPE := 'itjobq ';
  666    BEGIN
  667       
  668       
  669       
  670       
  671       
  672       IF ( AQLIST%ISOPEN )
  673       THEN
  674          CLOSE AQLIST;
  675       END IF;
  676 
  677       LSSQLNULL :=    'SELECT '
  678                    || LSSELECT
  679                    || ' FROM '
  680                    || LSFROM
  681                    || ' WHERE user_id = NULL';
  682       IAPIGENERAL.LOGINFO( GSSOURCE,
  683                            LSMETHOD,
  684                            LSSQLNULL,
  685                            IAPICONSTANT.INFOLEVEL_3 );
  686 
  687       OPEN AQLIST FOR LSSQLNULL;
  688 
  689       
  690       
  691       
  692       IAPIGENERAL.LOGINFO( GSSOURCE,
  693                            LSMETHOD,
  694                            'Body of FUNCTION',
  695                            IAPICONSTANT.INFOLEVEL_3 );
  696       
  697       LSSQL :=    'SELECT '
  698                || LSSELECT
  699                || ' FROM '
  700                || LSFROM
  701                || ' WHERE user_id = :userid '
  702                || '   AND logdate >= :logdate ';
  703       LSSQL :=    LSSQL
  704                || ' ORDER BY '
  705                || IAPICONSTANTCOLUMN.DATE1COL;
  706       IAPIGENERAL.LOGINFO( GSSOURCE,
  707                            LSMETHOD,
  708                            LSSQL,
  709                            IAPICONSTANT.INFOLEVEL_3 );
  710 
  711       
  712       IF ( AQLIST%ISOPEN )
  713       THEN
  714          CLOSE AQLIST;
  715       END IF;
  716 
  717       
  718       OPEN AQLIST FOR LSSQL USING ASUSERID,
  719       ADLOGDATE;
  720 
  721       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  722    EXCEPTION
  723       WHEN OTHERS
  724       THEN
  725          IAPIGENERAL.LOGERROR( GSSOURCE,
  726                                LSMETHOD,
  727                                SQLERRM );
  728          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  729    END GETJOBLOG;
  730 
  731    
  732    FUNCTION GETPARTINBOMLIST(
  733       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
  734       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
  735       AQLIST                     OUT      IAPITYPE.REF_TYPE )
  736       RETURN IAPITYPE.ERRORNUM_TYPE
  737    IS
  738       
  739       
  740       
  741       
  742       
  743       
  744       
  745       
  746       
  747       
  748       
  749       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPartInBomList';
  750       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  751       LSSQL                         VARCHAR2( 8192 ) := NULL;
  752       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
  753       LSSELECT                      VARCHAR2( 4096 )
  754          :=    'i.user_id '
  755             || IAPICONSTANTCOLUMN.USERIDCOL
  756             || ', i.part_no '
  757             || IAPICONSTANTCOLUMN.PARTNOCOL
  758             || ', i.revision '
  759             || IAPICONSTANTCOLUMN.REVISIONCOL
  760             || ', i.user_intl '
  761             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
  762             || ', i.text '
  763             || IAPICONSTANTCOLUMN.TEXTCOL
  764             || ', f_sh_descr(1, i.part_no, i.revision) '
  765             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
  766             || ', bi.conv_factor '
  767             || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
  768             || ', p.base_conv_factor '
  769             || IAPICONSTANTCOLUMN.NEWCONVERSIONFACTORCOL
  770             || ', s.status '
  771             || IAPICONSTANTCOLUMN.STATUSIDCOL
  772             || ', f_ss_descr(s.status) '
  773             || IAPICONSTANTCOLUMN.STATUSCOL
  774             || ', f_get_access(i.part_no, i.revision, i.user_id, i.user_intl) '
  775             || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
  776             || ', bi.plant '
  777             || IAPICONSTANTCOLUMN.PLANTNOCOL
  778             || ', pl.description '
  779             || IAPICONSTANTCOLUMN.PLANTCOL
  780             || ', bi.alternative '
  781             || IAPICONSTANTCOLUMN.ALTERNATIVECOL
  782             || ', bu.descr '
  783             || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL;
  784       LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bi, part p, specification_header s, itbu bu, plant pl, itshq i ';
  785    BEGIN
  786       
  787       
  788       
  789       
  790       
  791       IF ( AQLIST%ISOPEN )
  792       THEN
  793          CLOSE AQLIST;
  794       END IF;
  795 
  796       LSSQLNULL :=    'SELECT '
  797                    || LSSELECT
  798                    || ' FROM '
  799                    || LSFROM
  800                    || ' WHERE user_id = NULL';
  801       LSSQLNULL :=    'SELECT a.*, RowNum '
  802                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
  803                    || ' FROM ('
  804                    || LSSQLNULL
  805                    || ') a';
  806       IAPIGENERAL.LOGINFO( GSSOURCE,
  807                            LSMETHOD,
  808                            LSSQLNULL,
  809                            IAPICONSTANT.INFOLEVEL_3 );
  810 
  811       OPEN AQLIST FOR LSSQLNULL;
  812 
  813       
  814       IF    ( ASPARTNO IS NULL )
  815          OR ( ASPARTNO = '' )
  816       THEN
  817          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  818       END IF;
  819 
  820       
  821       
  822       
  823       IAPIGENERAL.LOGINFO( GSSOURCE,
  824                            LSMETHOD,
  825                            'PreConditions',
  826                            IAPICONSTANT.INFOLEVEL_3 );
  827       
  828       
  829       
  830       LNRETVAL := IAPIPART.EXISTID( ASPARTNO );
  831 
  832       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
  833       THEN
  834          IAPIGENERAL.LOGINFO( GSSOURCE,
  835                               LSMETHOD,
  836                               IAPIGENERAL.GETLASTERRORTEXT( ) );
  837          RETURN( LNRETVAL );
  838       END IF;
  839 
  840       
  841       
  842       
  843       IAPIGENERAL.LOGINFO( GSSOURCE,
  844                            LSMETHOD,
  845                            'Body of FUNCTION',
  846                            IAPICONSTANT.INFOLEVEL_3 );
  847       
  848       LSSQL :=
  849             'SELECT '
  850          || LSSELECT
  851          || ' FROM '
  852          || LSFROM
  853          || ' WHERE i.user_id=:id '
  854          || '   AND i.part_no = bi.part_no AND i.revision = bi.revision '
  855          || '   AND p.part_no = bi.component_part '
  856          || '   AND bi.component_part = :partno '
  857          || '   AND i.part_no = s.part_no AND i.revision = s.revision '
  858          || '   AND bi.bom_usage = bu.bom_usage '
  859          || '   AND pl.plant = bi.plant ';
  860       LSSQL :=    LSSQL
  861                || ' ORDER BY '
  862                || IAPICONSTANTCOLUMN.PARTNOCOL
  863                || ','
  864                || IAPICONSTANTCOLUMN.REVISIONCOL;
  865       LSSQL :=    'SELECT a.*, RowNum '
  866                || IAPICONSTANTCOLUMN.ROWINDEXCOL
  867                || ' FROM ('
  868                || LSSQL
  869                || ') a';
  870       IAPIGENERAL.LOGINFO( GSSOURCE,
  871                            LSMETHOD,
  872                            LSSQL,
  873                            IAPICONSTANT.INFOLEVEL_3 );
  874 
  875       
  876       IF ( AQLIST%ISOPEN )
  877       THEN
  878          CLOSE AQLIST;
  879       END IF;
  880 
  881       
  882       OPEN AQLIST FOR LSSQL USING ASUSERID,
  883       ASPARTNO;
  884 
  885       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
  886    EXCEPTION
  887       WHEN OTHERS
  888       THEN
  889          IAPIGENERAL.LOGERROR( GSSOURCE,
  890                                LSMETHOD,
  891                                SQLERRM );
  892          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
  893    END GETPARTINBOMLIST;
  894 
  895    
  896    FUNCTION GETUSEDSUBSECTIONS(
  897       ANSECTIONID                IN       IAPITYPE.ID_TYPE,
  898       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
  899       AQUSEDSUBSECTIONS          OUT      IAPITYPE.REF_TYPE )
  900       RETURN IAPITYPE.ERRORNUM_TYPE
  901    IS
  902       
  903       
  904       
  905       
  906       
  907       
  908       
  909       
  910       
  911       
  912       
  913       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedSubSections';
  914       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  915       LSSQL                         VARCHAR2( 8192 ) := NULL;
  916       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
  917       LSSELECT                      VARCHAR2( 4096 )
  918          :=    'sbs.sub_section_id '
  919             || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
  920             || ', sbs.intl '
  921             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
  922             || ', f_sbh_descr(1, sbs.sub_section_id, 0) '
  923             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
  924       LSFROM                        IAPITYPE.STRING_TYPE := 'specification_section sps, sub_section sbs ';
  925    BEGIN
  926       
  927       
  928       
  929       
  930       
  931       IF ( AQUSEDSUBSECTIONS%ISOPEN )
  932       THEN
  933          CLOSE AQUSEDSUBSECTIONS;
  934       END IF;
  935 
  936       LSSQLNULL :=    'SELECT '
  937                    || LSSELECT
  938                    || ' FROM '
  939                    || LSFROM
  940                    || ' WHERE sps.sub_section_id = sbs.sub_section_id AND part_no = NULL';
  941       LSSQLNULL :=    'SELECT a.*, RowNum '
  942                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
  943                    || ' FROM ('
  944                    || LSSQLNULL
  945                    || ') a';
  946       IAPIGENERAL.LOGINFO( GSSOURCE,
  947                            LSMETHOD,
  948                            LSSQLNULL,
  949                            IAPICONSTANT.INFOLEVEL_3 );
  950 
  951       OPEN AQUSEDSUBSECTIONS FOR LSSQLNULL;
  952 
  953       
  954       
  955       
  956       IAPIGENERAL.LOGINFO( GSSOURCE,
  957                            LSMETHOD,
  958                            'Body of FUNCTION',
  959                            IAPICONSTANT.INFOLEVEL_3 );
  960       
  961       LSSQL :=
  962             'SELECT DISTINCT '
  963          || LSSELECT
  964          || ' FROM '
  965          || LSFROM
  966          || ' WHERE sps.sub_section_id = sbs.sub_section_id '
  967          || '   AND sps.section_id = :sectionid ';
  968 
  969       IF NOT( ASDESCRIPTIONLIKE IS NULL )
  970       THEN
  971          LSSQL :=    LSSQL
  972                   || ' AND f_sbh_descr(1, sbs.sub_section_id, 0) LIKE ''%'
  973                   || ASDESCRIPTIONLIKE
  974                   || '%''';
  975       END IF;
  976 
  977       LSSQL :=    LSSQL
  978                || ' ORDER BY '
  979                || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
  980       LSSQL :=    'SELECT a.*, RowNum '
  981                || IAPICONSTANTCOLUMN.ROWINDEXCOL
  982                || ' FROM ('
  983                || LSSQL
  984                || ') a';
  985       IAPIGENERAL.LOGINFO( GSSOURCE,
  986                            LSMETHOD,
  987                            LSSQL,
  988                            IAPICONSTANT.INFOLEVEL_3 );
  989 
  990       
  991       IF ( AQUSEDSUBSECTIONS%ISOPEN )
  992       THEN
  993          CLOSE AQUSEDSUBSECTIONS;
  994       END IF;
  995 
  996       
  997       OPEN AQUSEDSUBSECTIONS FOR LSSQL USING ANSECTIONID;
  998 
  999       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 1000    EXCEPTION
 1001       WHEN OTHERS
 1002       THEN
 1003          IAPIGENERAL.LOGERROR( GSSOURCE,
 1004                                LSMETHOD,
 1005                                SQLERRM );
 1006          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 1007    END GETUSEDSUBSECTIONS;
 1008 
 1009    
 1010    FUNCTION GETUSEDPROPERTYGROUPS(
 1011       ANSECTIONID                IN       IAPITYPE.ID_TYPE,
 1012       ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
 1013       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 1014       AQUSEDPROPERTYGROUPS       OUT      IAPITYPE.REF_TYPE )
 1015       RETURN IAPITYPE.ERRORNUM_TYPE
 1016    IS
 1017       
 1018       
 1019       
 1020       
 1021       
 1022       
 1023       
 1024       
 1025       
 1026       
 1027       
 1028       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedPropertyGroups';
 1029       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1030       LSSQL                         VARCHAR2( 8192 ) := NULL;
 1031       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 1032       LSSELECT                      VARCHAR2( 4096 )
 1033          :=    'p.property_group '
 1034             || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
 1035             || ', p.intl '
 1036             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 1037             || ', f_pgh_descr(1, p.property_group, 0) '
 1038             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1039       LSFROM                        IAPITYPE.STRING_TYPE := 'specification_section s, property_group p ';
 1040    BEGIN
 1041       
 1042       
 1043       
 1044       
 1045       
 1046       IF ( AQUSEDPROPERTYGROUPS%ISOPEN )
 1047       THEN
 1048          CLOSE AQUSEDPROPERTYGROUPS;
 1049       END IF;
 1050 
 1051       LSSQLNULL :=    'SELECT '
 1052                    || LSSELECT
 1053                    || ' FROM '
 1054                    || LSFROM
 1055                    || ' WHERE s.ref_id = p.property_group AND part_no = NULL';
 1056       LSSQLNULL :=    'SELECT a.*, RowNum '
 1057                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1058                    || ' FROM ('
 1059                    || LSSQLNULL
 1060                    || ') a';
 1061       IAPIGENERAL.LOGINFO( GSSOURCE,
 1062                            LSMETHOD,
 1063                            LSSQLNULL,
 1064                            IAPICONSTANT.INFOLEVEL_3 );
 1065 
 1066       OPEN AQUSEDPROPERTYGROUPS FOR LSSQLNULL;
 1067 
 1068       
 1069       
 1070       
 1071       IAPIGENERAL.LOGINFO( GSSOURCE,
 1072                            LSMETHOD,
 1073                            'Body of FUNCTION',
 1074                            IAPICONSTANT.INFOLEVEL_3 );
 1075       
 1076       LSSQL :=
 1077             'SELECT '
 1078          || LSSELECT
 1079          || ' FROM '
 1080          || LSFROM
 1081          || ' WHERE s.ref_id = p.property_group '
 1082          || '   AND s.section_id = :sectionid '
 1083          || '   AND s.sub_section_id = :subsectionid '
 1084          || '   AND s.type = :type ';
 1085 
 1086       IF NOT( ASDESCRIPTIONLIKE IS NULL )
 1087       THEN
 1088          LSSQL :=    LSSQL
 1089                   || ' AND f_pgh_descr(1, p.property_group, 0) LIKE ''%'
 1090                   || ASDESCRIPTIONLIKE
 1091                   || '%''';
 1092       END IF;
 1093 
 1094       LSSQL :=    LSSQL
 1095                || ' UNION '
 1096                || 'SELECT 0, ''0'', ''(none)'' FROM DUAL';
 1097       LSSQL :=    LSSQL
 1098                || ' ORDER BY '
 1099                || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1100       LSSQL :=    'SELECT a.*, RowNum '
 1101                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1102                || ' FROM ('
 1103                || LSSQL
 1104                || ') a';
 1105       IAPIGENERAL.LOGINFO( GSSOURCE,
 1106                            LSMETHOD,
 1107                            LSSQL,
 1108                            IAPICONSTANT.INFOLEVEL_3 );
 1109 
 1110       
 1111       IF ( AQUSEDPROPERTYGROUPS%ISOPEN )
 1112       THEN
 1113          CLOSE AQUSEDPROPERTYGROUPS;
 1114       END IF;
 1115 
 1116       
 1117       OPEN AQUSEDPROPERTYGROUPS FOR LSSQL USING ANSECTIONID,
 1118       ANSUBSECTIONID,
 1119       IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;
 1120 
 1121       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 1122    EXCEPTION
 1123       WHEN OTHERS
 1124       THEN
 1125          IAPIGENERAL.LOGERROR( GSSOURCE,
 1126                                LSMETHOD,
 1127                                SQLERRM );
 1128          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 1129    END GETUSEDPROPERTYGROUPS;
 1130 
 1131    
 1132    FUNCTION GETPROPERTIES(
 1133       ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
 1134       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 1135       AQPROPERTIES               OUT      IAPITYPE.REF_TYPE )
 1136       RETURN IAPITYPE.ERRORNUM_TYPE
 1137    IS
 1138       
 1139       
 1140       
 1141       
 1142       
 1143       
 1144       
 1145       
 1146       
 1147       
 1148       
 1149       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProperties';
 1150       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1151       LSSQL                         VARCHAR2( 8192 ) := NULL;
 1152       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 1153       LSSELECTPG                    VARCHAR2( 4096 )
 1154          :=    'p.property '
 1155             || IAPICONSTANTCOLUMN.PROPERTYIDCOL
 1156             || ', p.intl '
 1157             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 1158             || ', f_sph_descr(1, p.property, 0) '
 1159             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1160       LSFROMPG                      IAPITYPE.STRING_TYPE := 'property_group_list p ';
 1161       LSSELECTSP                    VARCHAR2( 4096 )
 1162          :=    'pd.property '
 1163             || IAPICONSTANTCOLUMN.PROPERTYIDCOL
 1164             || ', p.intl '
 1165             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 1166             || ', f_sph_descr(1, p.property, 0) '
 1167             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1168       LSFROMSP                      IAPITYPE.STRING_TYPE := 'property_display pd, property p ';
 1169    BEGIN
 1170       
 1171       
 1172       
 1173       
 1174       
 1175       IF ( AQPROPERTIES%ISOPEN )
 1176       THEN
 1177          CLOSE AQPROPERTIES;
 1178       END IF;
 1179 
 1180       LSSQLNULL :=    'SELECT '
 1181                    || LSSELECTPG
 1182                    || ' FROM '
 1183                    || LSFROMPG
 1184                    || ' WHERE p.property_group = NULL';
 1185       LSSQLNULL :=    'SELECT a.*, RowNum '
 1186                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1187                    || ' FROM ('
 1188                    || LSSQLNULL
 1189                    || ') a';
 1190       IAPIGENERAL.LOGINFO( GSSOURCE,
 1191                            LSMETHOD,
 1192                            LSSQLNULL,
 1193                            IAPICONSTANT.INFOLEVEL_3 );
 1194 
 1195       OPEN AQPROPERTIES FOR LSSQLNULL;
 1196 
 1197       
 1198       
 1199       
 1200       IAPIGENERAL.LOGINFO( GSSOURCE,
 1201                            LSMETHOD,
 1202                            'Body of FUNCTION',
 1203                            IAPICONSTANT.INFOLEVEL_3 );
 1204 
 1205       
 1206       IF ( ANPROPERTYGROUPID <> 0 )
 1207       THEN
 1208          LSSQL :=    'SELECT DISTINCT '
 1209                   || LSSELECTPG
 1210                   || ' FROM '
 1211                   || LSFROMPG
 1212                   || ' WHERE p.property_group = :propertygroup ';
 1213       ELSE
 1214          LSSQL :=    'SELECT DISTINCT '
 1215                   || LSSELECTSP
 1216                   || ' FROM '
 1217                   || LSFROMSP
 1218                   || ' WHERE pd.property = p.property ';
 1219       END IF;
 1220 
 1221       IF NOT( ASDESCRIPTIONLIKE IS NULL )
 1222       THEN
 1223          LSSQL :=    LSSQL
 1224                   || ' AND f_sph_descr(1, p.property, 0) LIKE ''%'
 1225                   || ASDESCRIPTIONLIKE
 1226                   || '%''';
 1227       END IF;
 1228 
 1229       LSSQL :=    LSSQL
 1230                || ' ORDER BY '
 1231                || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1232       LSSQL :=    'SELECT a.*, RowNum '
 1233                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1234                || ' FROM ('
 1235                || LSSQL
 1236                || ') a';
 1237       IAPIGENERAL.LOGINFO( GSSOURCE,
 1238                            LSMETHOD,
 1239                            LSSQL,
 1240                            IAPICONSTANT.INFOLEVEL_3 );
 1241 
 1242       
 1243       IF ( AQPROPERTIES%ISOPEN )
 1244       THEN
 1245          CLOSE AQPROPERTIES;
 1246       END IF;
 1247 
 1248       
 1249       IF ( ANPROPERTYGROUPID <> 0 )
 1250       THEN
 1251          OPEN AQPROPERTIES FOR LSSQL USING ANPROPERTYGROUPID;
 1252       ELSE
 1253          OPEN AQPROPERTIES FOR LSSQL;
 1254       END IF;
 1255 
 1256       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 1257    EXCEPTION
 1258       WHEN OTHERS
 1259       THEN
 1260          IAPIGENERAL.LOGERROR( GSSOURCE,
 1261                                LSMETHOD,
 1262                                SQLERRM );
 1263          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 1264    END GETPROPERTIES;
 1265 
 1266    
 1267    FUNCTION GETATTRIBUTES(
 1268       ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
 1269       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 1270       AQATTRIBUTES               OUT      IAPITYPE.REF_TYPE )
 1271       RETURN IAPITYPE.ERRORNUM_TYPE
 1272    IS
 1273       
 1274       
 1275       
 1276       
 1277       
 1278       
 1279       
 1280       
 1281       
 1282       
 1283       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAttributes';
 1284       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1285       LSSQL                         VARCHAR2( 8192 ) := NULL;
 1286       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 1287       LSSELECT                      VARCHAR2( 4096 )
 1288          :=    'ap.property '
 1289             || IAPICONSTANTCOLUMN.PROPERTYIDCOL
 1290             || ', ap.attribute '
 1291             || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
 1292             || ', ap.intl '
 1293             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 1294             || ', f_ath_descr(1, ap.attribute, 0) '
 1295             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1296       LSFROM                        IAPITYPE.STRING_TYPE := 'attribute_property ap, attribute a ';
 1297    BEGIN
 1298       
 1299       
 1300       
 1301       
 1302       
 1303       IF ( AQATTRIBUTES%ISOPEN )
 1304       THEN
 1305          CLOSE AQATTRIBUTES;
 1306       END IF;
 1307 
 1308       LSSQLNULL :=    'SELECT '
 1309                    || LSSELECT
 1310                    || ' FROM '
 1311                    || LSFROM
 1312                    || ' WHERE ap.property = NULL';
 1313       LSSQLNULL :=    'SELECT a.*, RowNum '
 1314                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1315                    || ' FROM ('
 1316                    || LSSQLNULL
 1317                    || ') a';
 1318       IAPIGENERAL.LOGINFO( GSSOURCE,
 1319                            LSMETHOD,
 1320                            LSSQLNULL,
 1321                            IAPICONSTANT.INFOLEVEL_3 );
 1322 
 1323       OPEN AQATTRIBUTES FOR LSSQLNULL;
 1324 
 1325       
 1326       
 1327       
 1328       IAPIGENERAL.LOGINFO( GSSOURCE,
 1329                            LSMETHOD,
 1330                            'Body of FUNCTION',
 1331                            IAPICONSTANT.INFOLEVEL_3 );
 1332       
 1333       LSSQL :=    'SELECT '
 1334                || LSSELECT
 1335                || ' FROM '
 1336                || LSFROM
 1337                || ' WHERE ap.attribute = a.attribute AND ap.property = :property AND a.status = 0 ';
 1338 
 1339       IF NOT( ASDESCRIPTIONLIKE IS NULL )
 1340       THEN
 1341          LSSQL :=    LSSQL
 1342                   || ' AND f_ath_descr(1, ap.attribute, 0) LIKE ''%'
 1343                   || ASDESCRIPTIONLIKE
 1344                   || '%''';
 1345       END IF;
 1346 
 1347       LSSQL :=    LSSQL
 1348                || ' UNION '
 1349                || 'SELECT 0, 0, ''1'', '' - '' FROM DUAL';
 1350       LSSQL :=    LSSQL
 1351                || ' ORDER BY '
 1352                || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1353       LSSQL :=    'SELECT a.*, RowNum '
 1354                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1355                || ' FROM ('
 1356                || LSSQL
 1357                || ') a';
 1358       IAPIGENERAL.LOGINFO( GSSOURCE,
 1359                            LSMETHOD,
 1360                            LSSQL,
 1361                            IAPICONSTANT.INFOLEVEL_3 );
 1362 
 1363       
 1364       IF ( AQATTRIBUTES%ISOPEN )
 1365       THEN
 1366          CLOSE AQATTRIBUTES;
 1367       END IF;
 1368 
 1369       
 1370       OPEN AQATTRIBUTES FOR LSSQL USING ANPROPERTYID;
 1371 
 1372       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 1373    EXCEPTION
 1374       WHEN OTHERS
 1375       THEN
 1376          IAPIGENERAL.LOGERROR( GSSOURCE,
 1377                                LSMETHOD,
 1378                                SQLERRM );
 1379          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 1380    END GETATTRIBUTES;
 1381 
 1382    
 1383    FUNCTION GETHEADERS(
 1384       ANLAYOUTTYPE               IN       IAPITYPE.ID_TYPE,
 1385       ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
 1386       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 1387       AQHEADERS                  OUT      IAPITYPE.REF_TYPE )
 1388       RETURN IAPITYPE.ERRORNUM_TYPE
 1389    IS
 1390       
 1391       
 1392       
 1393       
 1394       
 1395       
 1396       
 1397       
 1398       
 1399       
 1400       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetHeaders';
 1401       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1402       LSSQL                         VARCHAR2( 8192 ) := NULL;
 1403       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 1404       LSSELECT                      VARCHAR2( 4096 )
 1405          :=    'pl.header_id '
 1406             || IAPICONSTANTCOLUMN.HEADERIDCOL
 1407             || ', f_hdh_descr (1, pl.header_id, 0) '
 1408             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
 1409             || ', f_get_field_datatype(pl.field_id) '
 1410             || IAPICONSTANTCOLUMN.FIELDTYPECOL
 1411             || ', pl.header_id + (1000000 * f_get_field_datatype(pl.field_id)) '
 1412             || IAPICONSTANTCOLUMN.FIELDIDCOL;
 1413       LSFROM                        IAPITYPE.STRING_TYPE := 'property_layout pl, layout l ';
 1414    BEGIN
 1415       
 1416       
 1417       
 1418       
 1419       
 1420       IF ( AQHEADERS%ISOPEN )
 1421       THEN
 1422          CLOSE AQHEADERS;
 1423       END IF;
 1424 
 1425       LSSQLNULL :=
 1426             'SELECT '
 1427          || LSSELECT
 1428          || ' FROM '
 1429          || LSFROM
 1430          || ' WHERE l.layout_id = pl.layout_id '
 1431          || '   AND l.revision = pl.revision '
 1432          || '   AND l.layout_id = NULL';
 1433       LSSQLNULL :=    'SELECT a.*, RowNum '
 1434                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1435                    || ' FROM ('
 1436                    || LSSQLNULL
 1437                    || ') a';
 1438       IAPIGENERAL.LOGINFO( GSSOURCE,
 1439                            LSMETHOD,
 1440                            LSSQLNULL,
 1441                            IAPICONSTANT.INFOLEVEL_3 );
 1442 
 1443       OPEN AQHEADERS FOR LSSQLNULL;
 1444 
 1445       
 1446       
 1447       
 1448       IAPIGENERAL.LOGINFO( GSSOURCE,
 1449                            LSMETHOD,
 1450                            'Body of FUNCTION',
 1451                            IAPICONSTANT.INFOLEVEL_3 );
 1452       
 1453       LSSQL :=
 1454             'SELECT DISTINCT '
 1455          || LSSELECT
 1456          || ' FROM '
 1457          || LSFROM
 1458          || ' WHERE l.layout_id = pl.layout_id '
 1459          || '   AND l.revision = pl.revision '
 1460          || '   AND l.status > 1 '
 1461          || '   AND (pl.field_id < 23 OR pl.field_id IN ( 25, 26, 30, 31 )) '
 1462          || '   AND pl.layout_id IN ';
 1463 
 1464       IF ( ANLAYOUTTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
 1465       THEN
 1466          LSSQL :=
 1467                LSSQL
 1468             || '( SELECT i.display_format '
 1469             || '                           FROM itshly i, property_group_list pgl '
 1470             || '                          WHERE i.ly_id = pgl.property_group '
 1471             || '                            AND pgl.property = :property '
 1472             || '                            AND i.ly_type = '
 1473             || ANLAYOUTTYPE
 1474             || ')';
 1475       ELSIF( ANLAYOUTTYPE IN( IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY, IAPICONSTANT.SECTIONTYPE_REFERENCETEXT ) )
 1476       THEN
 1477          LSSQL :=
 1478                LSSQL
 1479             || '( SELECT DISTINCT i.display_format '
 1480             || '                           FROM itshly i '
 1481             || '                          WHERE i.ly_id = :property '
 1482             || '                            AND i.ly_type = '
 1483             || ANLAYOUTTYPE
 1484             || ')';
 1485       END IF;
 1486 
 1487       IF NOT( ASDESCRIPTIONLIKE IS NULL )
 1488       THEN
 1489          LSSQL :=    LSSQL
 1490                   || ' AND f_hdh_descr (1, pl.header_id, 0) LIKE ''%'
 1491                   || ASDESCRIPTIONLIKE
 1492                   || '%''';
 1493       END IF;
 1494 
 1495       LSSQL :=    LSSQL
 1496                || ' ORDER BY '
 1497                || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 1498       LSSQL :=    'SELECT a.*, RowNum '
 1499                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1500                || ' FROM ('
 1501                || LSSQL
 1502                || ') a';
 1503       IAPIGENERAL.LOGINFO( GSSOURCE,
 1504                            LSMETHOD,
 1505                            LSSQL,
 1506                            IAPICONSTANT.INFOLEVEL_3 );
 1507 
 1508       
 1509       IF ( AQHEADERS%ISOPEN )
 1510       THEN
 1511          CLOSE AQHEADERS;
 1512       END IF;
 1513 
 1514       
 1515       OPEN AQHEADERS FOR LSSQL USING ANPROPERTYID;
 1516 
 1517       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 1518    EXCEPTION
 1519       WHEN OTHERS
 1520       THEN
 1521          IAPIGENERAL.LOGERROR( GSSOURCE,
 1522                                LSMETHOD,
 1523                                SQLERRM );
 1524          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 1525    END GETHEADERS;
 1526 
 1527    
 1528    FUNCTION GETSECTIONDATA(
 1529       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
 1530       ANFIELDTYPE                IN       IAPITYPE.NUMVAL_TYPE,
 1531       ANSECTIONID                IN       IAPITYPE.ID_TYPE,
 1532       ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
 1533       ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
 1534       ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
 1535       ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
 1536       ANHEADERID                 IN       IAPITYPE.ID_TYPE,
 1537       AQSECTIONDATA              OUT      IAPITYPE.REF_TYPE )
 1538       RETURN IAPITYPE.ERRORNUM_TYPE
 1539    IS
 1540       
 1541       
 1542       
 1543       
 1544       
 1545       
 1546       
 1547       
 1548       
 1549       
 1550       
 1551       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSectionData';
 1552       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 1553       LSSQL                         VARCHAR2( 8192 ) := NULL;
 1554       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 1555       LSSELECTBASE                  VARCHAR2( 4096 )
 1556          :=    'i.user_id '
 1557             || IAPICONSTANTCOLUMN.USERIDCOL
 1558             || ', i.part_no '
 1559             || IAPICONSTANTCOLUMN.PARTNOCOL
 1560             || ', i.revision '
 1561             || IAPICONSTANTCOLUMN.REVISIONCOL
 1562             || ', i.text '
 1563             || IAPICONSTANTCOLUMN.TEXTCOL
 1564             || ', To_NUMBER(i.user_intl) '
 1565             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 1566             || ', ''X'' '
 1567             || IAPICONSTANTCOLUMN.FIELDTYPECOL
 1568             || ', i.new_value_char '
 1569             || IAPICONSTANTCOLUMN.OLDVALUECHARCOL
 1570             || ', i.new_value_char '
 1571             || IAPICONSTANTCOLUMN.NEWVALUECHARCOL
 1572             || ', i.new_value_num '
 1573             || IAPICONSTANTCOLUMN.OLDVALUENUMCOL
 1574             || ', i.new_value_num '
 1575             || IAPICONSTANTCOLUMN.NEWVALUENUMCOL
 1576             || ', i.new_value_date '
 1577             || IAPICONSTANTCOLUMN.OLDVALUEDATECOL
 1578             || ', i.new_value_date '
 1579             || IAPICONSTANTCOLUMN.NEWVALUEDATECOL
 1580             || ', i.new_value_num '
 1581             || IAPICONSTANTCOLUMN.OLDVALUETMIDCOL
 1582             || ', i.new_value_num '
 1583             || IAPICONSTANTCOLUMN.NEWVALUETMIDCOL
 1584             || ', null '
 1585             || IAPICONSTANTCOLUMN.OLDVALUETMCOL   
 1586             || ', i.new_value_num '
 1587             || IAPICONSTANTCOLUMN.OLDVALUEASSIDCOL
 1588             || ', i.new_value_num '
 1589             || IAPICONSTANTCOLUMN.NEWVALUEASSIDCOL
 1590             || ', null '
 1591             || IAPICONSTANTCOLUMN.OLDVALUEASSCOL;   
 1592       LSFROMBASE                    IAPITYPE.STRING_TYPE := 'itshq i ';
 1593       LRSECTIONDAT                  IAPITYPE.MOPRPVSECTIONDATAREC_TYPE;
 1594       LRSECTIONDATA                 MOPRPVSECTIONDATARECORD_TYPE
 1595          := MOPRPVSECTIONDATARECORD_TYPE( NULL,
 1596                                           NULL,
 1597                                           NULL,
 1598                                           NULL,
 1599                                           NULL,
 1600                                           NULL,
 1601                                           NULL,
 1602                                           NULL,
 1603                                           NULL,
 1604                                           NULL,
 1605                                           NULL,
 1606                                           NULL,
 1607                                           NULL,
 1608                                           NULL,
 1609                                           NULL,
 1610                                           NULL,
 1611                                           NULL,
 1612                                           NULL,
 1613                                           NULL );
 1614       LTSECTIONDATA                 MOPRPVSECTIONDATATABLE_TYPE := MOPRPVSECTIONDATATABLE_TYPE( );
 1615       LSTYPE                        VARCHAR2( 16 );
 1616       LSOLDDATA                     VARCHAR2( 4096 );
 1617       LQOLDDATA                     IAPITYPE.REF_TYPE;
 1618       LNCOUNT                       NUMBER;
 1619       LSPARTNO                      IAPITYPE.PARTNO_TYPE;
 1620       LNREVISION                    IAPITYPE.REVISION_TYPE;
 1621       LNCOUNTOLD                    NUMBER;
 1622 
 1623       TYPE OLDDATADEFAULTREC_TYPE IS RECORD(
 1624          PARTNO                        IAPITYPE.PARTNO_TYPE,
 1625          REVISION                      IAPITYPE.REVISION_TYPE,
 1626          VALUE                         IAPITYPE.FLOAT_TYPE,
 1627          VALUE_S                       IAPITYPE.STRING_TYPE,
 1628          VALUE_DT                      IAPITYPE.DATE_TYPE
 1629       );
 1630 
 1631       TYPE LTOLDDATADEFAULT_TYPE IS TABLE OF OLDDATADEFAULTREC_TYPE
 1632          INDEX BY BINARY_INTEGER;
 1633 
 1634       LTOLDDATADEFAULT              LTOLDDATADEFAULT_TYPE;
 1635 
 1636       TYPE OLDDATATESTMETHODREC_TYPE IS RECORD(
 1637          PARTNO                        IAPITYPE.PARTNO_TYPE,
 1638          REVISION                      IAPITYPE.REVISION_TYPE,
 1639          TESTMETHODID                  IAPITYPE.ID_TYPE,
 1640          TESTMETHOD                    IAPITYPE.DESCRIPTION_TYPE
 1641       );
 1642 
 1643       TYPE LTOLDDATATESTMETHOD_TYPE IS TABLE OF OLDDATATESTMETHODREC_TYPE
 1644          INDEX BY BINARY_INTEGER;
 1645 
 1646       LTOLDDATATESTMETHOD           LTOLDDATATESTMETHOD_TYPE;
 1647 
 1648       TYPE OLDDATAASSOCIATIONREC_TYPE IS RECORD(
 1649          PARTNO                        IAPITYPE.PARTNO_TYPE,
 1650          REVISION                      IAPITYPE.REVISION_TYPE,
 1651          CHARACTERISTIC1               IAPITYPE.ID_TYPE,
 1652          CHARACTERISTIC1_DESCR         IAPITYPE.DESCRIPTION_TYPE,
 1653          ASSOCIATION1                  IAPITYPE.ID_TYPE,
 1654          ASSOCIATION1_DESCR            IAPITYPE.DESCRIPTION_TYPE,
 1655          CHARACTERISTIC2               IAPITYPE.ID_TYPE,
 1656          CHARACTERISTIC2_DESCR         IAPITYPE.DESCRIPTION_TYPE,
 1657          ASSOCIATION2                  IAPITYPE.ID_TYPE,
 1658          ASSOCIATION2_DESCR            IAPITYPE.DESCRIPTION_TYPE,
 1659          CHARACTERISTIC3               IAPITYPE.ID_TYPE,
 1660          CHARACTERISTIC3_DESCR         IAPITYPE.DESCRIPTION_TYPE,
 1661          ASSOCIATION3                  IAPITYPE.ID_TYPE,
 1662          ASSOCIATION3_DESCR            IAPITYPE.DESCRIPTION_TYPE
 1663       );
 1664 
 1665       TYPE LTOLDDATAASSOCIATION_TYPE IS TABLE OF OLDDATAASSOCIATIONREC_TYPE
 1666          INDEX BY BINARY_INTEGER;
 1667 
 1668       LTOLDDATAASSOCIATION          LTOLDDATAASSOCIATION_TYPE;
 1669    BEGIN
 1670       
 1671       
 1672       
 1673       
 1674       
 1675       IF ( AQSECTIONDATA%ISOPEN )
 1676       THEN
 1677          CLOSE AQSECTIONDATA;
 1678       END IF;
 1679 
 1680       LSSQLNULL :=    'SELECT '
 1681                    || LSSELECTBASE
 1682                    || ' FROM '
 1683                    || LSFROMBASE
 1684                    || ' WHERE i.user_id = NULL';
 1685       LSSQLNULL :=    'SELECT a.*, RowNum '
 1686                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1687                    || ' FROM ('
 1688                    || LSSQLNULL
 1689                    || ') a';
 1690       IAPIGENERAL.LOGINFO( GSSOURCE,
 1691                            LSMETHOD,
 1692                            LSSQLNULL,
 1693                            IAPICONSTANT.INFOLEVEL_3 );
 1694 
 1695       OPEN AQSECTIONDATA FOR LSSQLNULL;
 1696 
 1697       
 1698       
 1699       
 1700       IAPIGENERAL.LOGINFO( GSSOURCE,
 1701                            LSMETHOD,
 1702                            'Body of FUNCTION',
 1703                            IAPICONSTANT.INFOLEVEL_3 );
 1704       
 1705       LSSQL :=    'SELECT '
 1706                || LSSELECTBASE
 1707                || ' FROM '
 1708                || LSFROMBASE
 1709                || ' WHERE i.user_id = :userid ';
 1710       LSSQL :=    'SELECT a.*, RowNum '
 1711                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 1712                || ' FROM ('
 1713                || LSSQL
 1714                || ') a';
 1715       IAPIGENERAL.LOGINFO( GSSOURCE,
 1716                            LSMETHOD,
 1717                            LSSQL,
 1718                            IAPICONSTANT.INFOLEVEL_3 );
 1719 
 1720       
 1721       IF ( AQSECTIONDATA%ISOPEN )
 1722       THEN
 1723          CLOSE AQSECTIONDATA;
 1724       END IF;
 1725 
 1726       
 1727       OPEN AQSECTIONDATA FOR LSSQL USING ASUSERID;
 1728 
 1729       IAPIGENERAL.LOGINFO( GSSOURCE,
 1730                            LSMETHOD,
 1731                            'About to fetch data',
 1732                            IAPICONSTANT.INFOLEVEL_3 );
 1733       
 1734       LTSECTIONDATA.DELETE;
 1735 
 1736       LOOP
 1737          LRSECTIONDAT := NULL;
 1738 
 1739          FETCH AQSECTIONDATA
 1740           INTO LRSECTIONDAT;
 1741 
 1742          EXIT WHEN AQSECTIONDATA%NOTFOUND;
 1743          LRSECTIONDATA.ROWINDEX := LRSECTIONDAT.ROWINDEX;
 1744          LRSECTIONDATA.USERID := LRSECTIONDAT.USERID;
 1745          LRSECTIONDATA.PARTNO := LRSECTIONDAT.PARTNO;
 1746          LRSECTIONDATA.REVISION := LRSECTIONDAT.REVISION;
 1747          LRSECTIONDATA.TEXT := LRSECTIONDAT.TEXT;
 1748          LRSECTIONDATA.INTERNATIONAL := LRSECTIONDAT.INTERNATIONAL;
 1749          LRSECTIONDATA.FIELDTYPE := LRSECTIONDAT.FIELDTYPE;
 1750          LRSECTIONDATA.OLDVALUECHAR := LRSECTIONDAT.OLDVALUECHAR;
 1751          LRSECTIONDATA.NEWVALUECHAR := LRSECTIONDAT.NEWVALUECHAR;
 1752          LRSECTIONDATA.OLDVALUENUM := LRSECTIONDAT.OLDVALUENUM;
 1753          LRSECTIONDATA.NEWVALUENUM := LRSECTIONDAT.NEWVALUENUM;
 1754          LRSECTIONDATA.OLDVALUEDATE := LRSECTIONDAT.OLDVALUEDATE;
 1755          LRSECTIONDATA.NEWVALUEDATE := LRSECTIONDAT.NEWVALUEDATE;
 1756          LRSECTIONDATA.OLDVALUETMID := LRSECTIONDAT.OLDVALUETMID;
 1757          LRSECTIONDATA.NEWVALUETMID := LRSECTIONDAT.NEWVALUETMID;
 1758          LRSECTIONDATA.OLDVALUETM := LRSECTIONDAT.OLDVALUETM;
 1759          LRSECTIONDATA.OLDVALUEASSID := LRSECTIONDAT.OLDVALUEASSID;
 1760          LRSECTIONDATA.NEWVALUEASSID := LRSECTIONDAT.NEWVALUEASSID;
 1761          LRSECTIONDATA.OLDVALUEASS := LRSECTIONDAT.OLDVALUEASS;
 1762          LTSECTIONDATA.EXTEND;
 1763          LTSECTIONDATA( LTSECTIONDATA.COUNT ) := LRSECTIONDATA;
 1764       END LOOP;
 1765 
 1766       IAPIGENERAL.LOGINFO( GSSOURCE,
 1767                            LSMETHOD,
 1768                               'Number of items fetched: <'
 1769                            || LTSECTIONDATA.COUNT
 1770                            || '>',
 1771                            IAPICONSTANT.INFOLEVEL_3 );
 1772 
 1773       
 1774       CASE ANFIELDTYPE
 1775          WHEN 1   
 1776          THEN
 1777             LSTYPE := 'DEFAULT';
 1778          WHEN 4   
 1779          THEN
 1780             LSTYPE := 'DEFAULT';
 1781          WHEN 5   
 1782          THEN
 1783             LSTYPE := 'ASSOCIATION';
 1784          WHEN 6   
 1785          THEN
 1786             LSTYPE := 'TESTMETHOD';
 1787          WHEN 7   
 1788          THEN
 1789             LSTYPE := 'ASSOCIATION';
 1790          WHEN 8   
 1791          THEN
 1792             LSTYPE := 'ASSOCIATION';
 1793          ELSE   
 1794             LSTYPE := 'DEFAULT';
 1795       END CASE;
 1796 
 1797       
 1798       IF ( LQOLDDATA%ISOPEN )
 1799       THEN
 1800          CLOSE LQOLDDATA;
 1801       END IF;
 1802 
 1803       
 1804       CASE LSTYPE
 1805          WHEN 'ASSOCIATION'
 1806          THEN
 1807             LSOLDDATA := 'SELECT s.part_no, s.revision, ';
 1808             LSOLDDATA :=    LSOLDDATA
 1809                          || ' s.characteristic, f_chh_descr(1, s.characteristic, s.characteristic_rev), ';
 1810             LSOLDDATA :=    LSOLDDATA
 1811                          || ' s.association, f_ash_descr(1, s.association, s.association_rev), ';
 1812             LSOLDDATA :=    LSOLDDATA
 1813                          || ' s.ch_2, f_chh_descr(1, s.ch_2, s.ch_rev_2), s.as_2, f_ash_descr(1, s.as_2, s.as_rev_2), ';
 1814             LSOLDDATA :=    LSOLDDATA
 1815                          || ' s.ch_3, f_chh_descr(1, s.ch_3, s.ch_rev_3), s.as_3, f_ash_descr(1, s.as_3, s.as_rev_3) ';
 1816             LSOLDDATA :=    LSOLDDATA
 1817                          || ' FROM specification_prop s, itshq i ';
 1818             LSOLDDATA :=    LSOLDDATA
 1819                          || ' WHERE s.part_no = i.part_no ';
 1820             LSOLDDATA :=    LSOLDDATA
 1821                          || ' AND s.revision = i.revision ';
 1822             LSOLDDATA :=    LSOLDDATA
 1823                          || ' AND i.user_id = :userid ';
 1824             LSOLDDATA :=    LSOLDDATA
 1825                          || ' AND s.section_id = :sectionid ';
 1826             LSOLDDATA :=    LSOLDDATA
 1827                          || ' AND s.sub_section_id = :subsectionid ';
 1828             LSOLDDATA :=    LSOLDDATA
 1829                          || ' AND s.property_group = :propertygroupid ';
 1830             LSOLDDATA :=    LSOLDDATA
 1831                          || ' AND s.property = :propertyid ';
 1832             LSOLDDATA :=    LSOLDDATA
 1833                          || ' AND s.attribute = :attributeid ';
 1834             IAPIGENERAL.LOGINFO( GSSOURCE,
 1835                                  LSMETHOD,
 1836                                  LSOLDDATA,
 1837                                  IAPICONSTANT.INFOLEVEL_3 );
 1838             IAPIGENERAL.LOGINFO( GSSOURCE,
 1839                                  LSMETHOD,
 1840                                     ASUSERID
 1841                                  || '/'
 1842                                  || ANSECTIONID
 1843                                  || '/'
 1844                                  || ANSUBSECTIONID
 1845                                  || '/'
 1846                                  || ANPROPERTYGROUPID
 1847                                  || '/'
 1848                                  || ANPROPERTYID
 1849                                  || '/'
 1850                                  || ANATTRIBUTEID,
 1851                                  IAPICONSTANT.INFOLEVEL_3 );
 1852 
 1853             OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
 1854             ANSECTIONID,
 1855             ANSUBSECTIONID,
 1856             ANPROPERTYGROUPID,
 1857             ANPROPERTYID,
 1858             ANATTRIBUTEID;
 1859 
 1860             FETCH LQOLDDATA
 1861             BULK COLLECT INTO LTOLDDATAASSOCIATION;
 1862 
 1863             CLOSE LQOLDDATA;
 1864          WHEN 'TESTMETHOD'
 1865          THEN
 1866             LSOLDDATA := 'SELECT s.part_no, s.revision, s.test_method, f_tmh_descr(1, s.test_method, s.test_method_rev ) ';
 1867             LSOLDDATA :=    LSOLDDATA
 1868                          || ' FROM specdata s, itshq i ';
 1869             LSOLDDATA :=    LSOLDDATA
 1870                          || ' WHERE s.part_no = i.part_no ';
 1871             LSOLDDATA :=    LSOLDDATA
 1872                          || ' AND s.revision = i.revision ';
 1873             LSOLDDATA :=    LSOLDDATA
 1874                          || ' AND i.user_id = :userid ';
 1875             LSOLDDATA :=    LSOLDDATA
 1876                          || ' AND s.section_id = :sectionid ';
 1877             LSOLDDATA :=    LSOLDDATA
 1878                          || ' AND s.sub_section_id = :subsectionid ';
 1879             LSOLDDATA :=    LSOLDDATA
 1880                          || ' AND s.property_group = :propertygroupid ';
 1881             LSOLDDATA :=    LSOLDDATA
 1882                          || ' AND s.property = :propertyid ';
 1883             LSOLDDATA :=    LSOLDDATA
 1884                          || ' AND s.attribute = :attributeid ';
 1885             LSOLDDATA :=    LSOLDDATA
 1886                          || ' AND s.test_method <> -1 ';
 1887             IAPIGENERAL.LOGINFO( GSSOURCE,
 1888                                  LSMETHOD,
 1889                                  LSOLDDATA,
 1890                                  IAPICONSTANT.INFOLEVEL_3 );
 1891             IAPIGENERAL.LOGINFO( GSSOURCE,
 1892                                  LSMETHOD,
 1893                                     ASUSERID
 1894                                  || '/'
 1895                                  || ANSECTIONID
 1896                                  || '/'
 1897                                  || ANSUBSECTIONID
 1898                                  || '/'
 1899                                  || ANPROPERTYGROUPID
 1900                                  || '/'
 1901                                  || ANPROPERTYID
 1902                                  || '/'
 1903                                  || ANATTRIBUTEID,
 1904                                  IAPICONSTANT.INFOLEVEL_3 );
 1905 
 1906             OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
 1907             ANSECTIONID,
 1908             ANSUBSECTIONID,
 1909             ANPROPERTYGROUPID,
 1910             ANPROPERTYID,
 1911             ANATTRIBUTEID;
 1912 
 1913             FETCH LQOLDDATA
 1914             BULK COLLECT INTO LTOLDDATATESTMETHOD;
 1915 
 1916             CLOSE LQOLDDATA;
 1917          ELSE   
 1918             LSOLDDATA := 'SELECT s.part_no, s.revision, s.value, s.value_s, s.value_dt ';
 1919             LSOLDDATA :=    LSOLDDATA
 1920                          || ' FROM specdata s, itshq i ';
 1921             LSOLDDATA :=    LSOLDDATA
 1922                          || ' WHERE s.part_no = i.part_no ';
 1923             LSOLDDATA :=    LSOLDDATA
 1924                          || ' AND s.revision = i.revision ';
 1925             LSOLDDATA :=    LSOLDDATA
 1926                          || ' AND i.user_id = :userid ';
 1927             LSOLDDATA :=    LSOLDDATA
 1928                          || ' AND s.section_id = :sectionid ';
 1929             LSOLDDATA :=    LSOLDDATA
 1930                          || ' AND s.sub_section_id = :subsectionid ';
 1931             LSOLDDATA :=    LSOLDDATA
 1932                          || ' AND s.property_group = :propertygroupid ';
 1933             LSOLDDATA :=    LSOLDDATA
 1934                          || ' AND s.property = :propertyid ';
 1935             LSOLDDATA :=    LSOLDDATA
 1936                          || ' AND s.attribute = :attributeid ';
 1937             LSOLDDATA :=    LSOLDDATA
 1938                          || ' AND s.header_id = :headerid ';
 1939             IAPIGENERAL.LOGINFO( GSSOURCE,
 1940                                  LSMETHOD,
 1941                                  LSOLDDATA,
 1942                                  IAPICONSTANT.INFOLEVEL_3 );
 1943             IAPIGENERAL.LOGINFO( GSSOURCE,
 1944                                  LSMETHOD,
 1945                                     ASUSERID
 1946                                  || '/'
 1947                                  || ANSECTIONID
 1948                                  || '/'
 1949                                  || ANSUBSECTIONID
 1950                                  || '/'
 1951                                  || ANPROPERTYGROUPID
 1952                                  || '/'
 1953                                  || ANPROPERTYID
 1954                                  || '/'
 1955                                  || ANATTRIBUTEID
 1956                                  || '/'
 1957                                  || ANHEADERID,
 1958                                  IAPICONSTANT.INFOLEVEL_3 );
 1959 
 1960             OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
 1961             ANSECTIONID,
 1962             ANSUBSECTIONID,
 1963             ANPROPERTYGROUPID,
 1964             ANPROPERTYID,
 1965             ANATTRIBUTEID,
 1966             ANHEADERID;
 1967 
 1968             FETCH LQOLDDATA
 1969             BULK COLLECT INTO LTOLDDATADEFAULT;
 1970 
 1971             CLOSE LQOLDDATA;
 1972       END CASE;
 1973 
 1974       
 1975       
 1976       IF ( LTSECTIONDATA.COUNT > 0 )
 1977       THEN
 1978          FOR LNCOUNT IN LTSECTIONDATA.FIRST .. LTSECTIONDATA.LAST
 1979          LOOP
 1980             
 1981             LSPARTNO := LTSECTIONDATA( LNCOUNT ).PARTNO;
 1982             LNREVISION := LTSECTIONDATA( LNCOUNT ).REVISION;
 1983 
 1984             CASE LSTYPE
 1985                WHEN 'ASSOCIATION'
 1986                THEN
 1987                   
 1988                   IF ( LTOLDDATAASSOCIATION.COUNT > 0 )
 1989                   THEN
 1990                      FOR LNCOUNTOLD IN LTOLDDATAASSOCIATION.FIRST .. LTOLDDATAASSOCIATION.LAST
 1991                      LOOP
 1992                         IF (      ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).PARTNO = LSPARTNO )
 1993                              AND ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).REVISION = LNREVISION ) )
 1994                         THEN
 1995                            IAPIGENERAL.LOGINFO( GSSOURCE,
 1996                                                 LSMETHOD,
 1997                                                    'Part/revision <'
 1998                                                 || LSPARTNO
 1999                                                 || ' / '
 2000                                                 || LNREVISION
 2001                                                 || '> found',
 2002                                                 IAPICONSTANT.INFOLEVEL_3 );
 2003                            
 2004                            
 2005                            
 2006                            
 2007                            
 2008 
 2009 
 2010 
 2011 
 2012 
 2013 
 2014 
 2015 
 2016 
 2017 
 2018 
 2019 
 2020 
 2021 
 2022 
 2023 
 2024 
 2025 
 2026 
 2027 
 2028 
 2029 
 2030 
 2031 
 2032 
 2033 
 2034 
 2035 
 2036 
 2037 
 2038 
 2039 
 2040 
 2041 
 2042 
 2043 
 2044 
 2045 
 2046 
 2047 
 2048 
 2049 
 2050 
 2051 
 2052 
 2053                            
 2054 
 2055                            
 2056                            IF (ANFIELDTYPE = 5)
 2057                            THEN
 2058                                IAPIGENERAL.LOGINFO( GSSOURCE,
 2059                                                     LSMETHOD,
 2060                                                        'ASSOCIATION1 <'
 2061                                                     || LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION1
 2062                                                     || '> with CHARACTERISTIC1 <'
 2063                                                     || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC1
 2064                                                     || ' > description < '
 2065                                                     || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC1_DESCR
 2066                                                     || '> found',
 2067                                                     IAPICONSTANT.INFOLEVEL_3 );
 2068                                
 2069                                LTSECTIONDATA( LNCOUNT ).OLDVALUEASSID := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION1;
 2070                                LTSECTIONDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC1_DESCR;
 2071                            ELSE
 2072                                
 2073                                IF (ANFIELDTYPE = 7)
 2074                                THEN
 2075                                   IAPIGENERAL.LOGINFO( GSSOURCE,
 2076                                                        LSMETHOD,
 2077                                                           'ASSOCIATION2 <'
 2078                                                        || LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION2
 2079                                                        || '> with CHARACTERISTIC2 <'
 2080                                                        || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC2
 2081                                                        || ' > description < '
 2082                                                        || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC2_DESCR
 2083                                                        || '> found',
 2084                                                        IAPICONSTANT.INFOLEVEL_3 );
 2085                                   LTSECTIONDATA( LNCOUNT ).OLDVALUEASSID := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION2;
 2086                                   LTSECTIONDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC2_DESCR;
 2087                                
 2088                                
 2089                                ELSE
 2090                                     IAPIGENERAL.LOGINFO( GSSOURCE,
 2091                                                           LSMETHOD,
 2092                                                              'ASSOCIATION3 <'
 2093                                                           || LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION3
 2094                                                           || '> with CHARACTERISTIC3 <'
 2095                                                           || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC3
 2096                                                           || ' > description < '
 2097                                                           || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC3_DESCR
 2098                                                           || '> found',
 2099                                                           IAPICONSTANT.INFOLEVEL_3 );
 2100                                      LTSECTIONDATA( LNCOUNT ).OLDVALUEASSID := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION3;
 2101                                      LTSECTIONDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC3_DESCR;
 2102                                END IF;
 2103                            END IF;
 2104                            
 2105                         END IF;
 2106                      END LOOP;
 2107                   END IF;
 2108               WHEN 'TESTMETHOD'
 2109                THEN
 2110                   
 2111                   IF ( LTOLDDATATESTMETHOD.COUNT > 0 )
 2112                   THEN
 2113                      FOR LNCOUNTOLD IN LTOLDDATATESTMETHOD.FIRST .. LTOLDDATATESTMETHOD.LAST
 2114                      LOOP
 2115                         IF (      ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).PARTNO = LSPARTNO )
 2116                              AND ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).REVISION = LNREVISION ) )
 2117                         THEN
 2118                            IAPIGENERAL.LOGINFO( GSSOURCE,
 2119                                                 LSMETHOD,
 2120                                                    'Part/revision <'
 2121                                                 || LSPARTNO
 2122                                                 || ' / '
 2123                                                 || LNREVISION
 2124                                                 || '> found, tm = '
 2125                                                 || LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD,
 2126                                                 IAPICONSTANT.INFOLEVEL_3 );
 2127                            LTSECTIONDATA( LNCOUNT ).OLDVALUETMID := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHODID;
 2128                            LTSECTIONDATA( LNCOUNT ).OLDVALUETM := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD;
 2129                         END IF;
 2130                      END LOOP;
 2131                   END IF;
 2132                ELSE
 2133                   
 2134                   IF ( LTOLDDATADEFAULT.COUNT > 0 )
 2135                   THEN
 2136                      FOR LNCOUNTOLD IN LTOLDDATADEFAULT.FIRST .. LTOLDDATADEFAULT.LAST
 2137                      LOOP
 2138                         IF (      ( LTOLDDATADEFAULT( LNCOUNTOLD ).PARTNO = LSPARTNO )
 2139                              AND ( LTOLDDATADEFAULT( LNCOUNTOLD ).REVISION = LNREVISION ) )
 2140                         THEN
 2141                            IAPIGENERAL.LOGINFO( GSSOURCE,
 2142                                                 LSMETHOD,
 2143                                                    'Part/revision <'
 2144                                                 || LSPARTNO
 2145                                                 || ' / '
 2146                                                 || LNREVISION
 2147                                                 || '> found',
 2148                                                 IAPICONSTANT.INFOLEVEL_3 );
 2149                            LTSECTIONDATA( LNCOUNT ).OLDVALUENUM := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE;
 2150                            LTSECTIONDATA( LNCOUNT ).OLDVALUECHAR := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_S;
 2151                            LTSECTIONDATA( LNCOUNT ).OLDVALUEDATE := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_DT;
 2152                         END IF;
 2153                      END LOOP;
 2154                   END IF;
 2155             END CASE;
 2156          END LOOP;
 2157       END IF;
 2158 
 2159       
 2160       IF ( AQSECTIONDATA%ISOPEN )
 2161       THEN
 2162          CLOSE AQSECTIONDATA;
 2163       END IF;
 2164 
 2165       OPEN AQSECTIONDATA FOR
 2166          SELECT *
 2167            FROM TABLE( CAST( LTSECTIONDATA AS MOPRPVSECTIONDATATABLE_TYPE ) );
 2168 
 2169       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2170    EXCEPTION
 2171       WHEN OTHERS
 2172       THEN
 2173          IAPIGENERAL.LOGERROR( GSSOURCE,
 2174                                LSMETHOD,
 2175                                SQLERRM );
 2176          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2177    END GETSECTIONDATA;
 2178 
 2179    
 2180    FUNCTION GETUSEDPLANTINBOM(
 2181       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
 2182       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 2183       ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
 2184       ASPLANTNOLIKE              IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 2185       AQUSEDPLANTINBOM           OUT      IAPITYPE.REF_TYPE )
 2186       RETURN IAPITYPE.ERRORNUM_TYPE
 2187    IS
 2188       
 2189       
 2190       
 2191       
 2192       
 2193       
 2194       
 2195       
 2196       
 2197       
 2198       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedPlantInBom';
 2199       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2200       LSSQL                         VARCHAR2( 8192 ) := NULL;
 2201       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 2202       LSSELECT                      VARCHAR2( 4096 )
 2203                                                   :=    'p.plant '
 2204                                                      || IAPICONSTANTCOLUMN.PLANTNOCOL
 2205                                                      || ', p.description '
 2206                                                      || IAPICONSTANTCOLUMN.PLANTCOL;
 2207       LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bi, plant p ';
 2208    BEGIN
 2209       
 2210       
 2211       
 2212       
 2213       
 2214       IF ( AQUSEDPLANTINBOM%ISOPEN )
 2215       THEN
 2216          CLOSE AQUSEDPLANTINBOM;
 2217       END IF;
 2218 
 2219       LSSQLNULL :=    'SELECT DISTINCT '
 2220                    || LSSELECT
 2221                    || ' FROM '
 2222                    || LSFROM
 2223                    || ' WHERE bi.plant = p.plant AND p.plant = NULL';
 2224       LSSQLNULL :=    'SELECT a.*, RowNum '
 2225                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2226                    || ' FROM ('
 2227                    || LSSQLNULL
 2228                    || ') a';
 2229       IAPIGENERAL.LOGINFO( GSSOURCE,
 2230                            LSMETHOD,
 2231                            LSSQLNULL,
 2232                            IAPICONSTANT.INFOLEVEL_3 );
 2233 
 2234       OPEN AQUSEDPLANTINBOM FOR LSSQLNULL;
 2235 
 2236       
 2237       
 2238       
 2239       IAPIGENERAL.LOGINFO( GSSOURCE,
 2240                            LSMETHOD,
 2241                            'Body of FUNCTION',
 2242                            IAPICONSTANT.INFOLEVEL_3 );
 2243       
 2244       LSSQL :=
 2245             'SELECT DISTINCT '
 2246          || LSSELECT
 2247          || ' FROM '
 2248          || LSFROM
 2249          || ' WHERE bi.part_no = :partno '
 2250          || '   AND bi.revision = :revision '
 2251          || '   AND bi.component_part = :bomitem '
 2252          || '   AND bi.plant = p.plant ';
 2253 
 2254       IF NOT( ASPLANTNOLIKE IS NULL )
 2255       THEN
 2256          LSSQL :=    LSSQL
 2257                   || ' AND p.plant LIKE :plantnolike ';
 2258       END IF;
 2259 
 2260       LSSQL :=    LSSQL
 2261                || ' ORDER BY '
 2262                || IAPICONSTANTCOLUMN.PLANTNOCOL;
 2263       LSSQL :=    'SELECT a.*, RowNum '
 2264                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2265                || ' FROM ('
 2266                || LSSQL
 2267                || ') a';
 2268       IAPIGENERAL.LOGINFO( GSSOURCE,
 2269                            LSMETHOD,
 2270                            LSSQL,
 2271                            IAPICONSTANT.INFOLEVEL_3 );
 2272 
 2273       
 2274       IF ( AQUSEDPLANTINBOM%ISOPEN )
 2275       THEN
 2276          CLOSE AQUSEDPLANTINBOM;
 2277       END IF;
 2278 
 2279       
 2280       IF NOT( ASPLANTNOLIKE IS NULL )
 2281       THEN
 2282          OPEN AQUSEDPLANTINBOM FOR LSSQL USING ASPARTNO,
 2283          ANREVISION,
 2284          ASBOMITEM,
 2285             '%'
 2286          || ASPLANTNOLIKE
 2287          || '%';
 2288       ELSE
 2289          OPEN AQUSEDPLANTINBOM FOR LSSQL USING ASPARTNO,
 2290          ANREVISION,
 2291          ASBOMITEM;
 2292       END IF;
 2293 
 2294       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2295    EXCEPTION
 2296       WHEN OTHERS
 2297       THEN
 2298          IAPIGENERAL.LOGERROR( GSSOURCE,
 2299                                LSMETHOD,
 2300                                SQLERRM );
 2301          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2302    END GETUSEDPLANTINBOM;
 2303 
 2304    
 2305    FUNCTION GETUSEDPLANTINBOMMOP(
 2306       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
 2307       ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
 2308       AQUSEDPLANTINBOMMOP        OUT      IAPITYPE.REF_TYPE )
 2309       RETURN IAPITYPE.ERRORNUM_TYPE
 2310    IS
 2311       
 2312       
 2313       
 2314       
 2315       
 2316       
 2317       
 2318       
 2319       
 2320       
 2321       
 2322       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedPlantInBom';
 2323       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2324       LSSQL                         VARCHAR2( 8192 ) := NULL;
 2325       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 2326       LSSELECT                      VARCHAR2( 4096 )
 2327          :=    'bi.part_no '
 2328             || IAPICONSTANTCOLUMN.PARTNOCOL
 2329             || ', bi.revision '
 2330             || IAPICONSTANTCOLUMN.REVISIONCOL
 2331             || ', bi.plant '
 2332             || IAPICONSTANTCOLUMN.PLANTNOCOL;
 2333       LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bi ';
 2334    BEGIN
 2335       
 2336       
 2337       
 2338       
 2339       
 2340       IF ( AQUSEDPLANTINBOMMOP%ISOPEN )
 2341       THEN
 2342          CLOSE AQUSEDPLANTINBOMMOP;
 2343       END IF;
 2344 
 2345       LSSQLNULL :=    'SELECT DISTINCT '
 2346                    || LSSELECT
 2347                    || ' FROM '
 2348                    || LSFROM
 2349                    || ' WHERE bi.part_no = NULL';
 2350       LSSQLNULL :=    'SELECT a.*, RowNum '
 2351                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2352                    || ' FROM ('
 2353                    || LSSQLNULL
 2354                    || ') a';
 2355       IAPIGENERAL.LOGINFO( GSSOURCE,
 2356                            LSMETHOD,
 2357                            LSSQLNULL,
 2358                            IAPICONSTANT.INFOLEVEL_3 );
 2359 
 2360       OPEN AQUSEDPLANTINBOMMOP FOR LSSQLNULL;
 2361 
 2362       
 2363       
 2364       
 2365       IAPIGENERAL.LOGINFO( GSSOURCE,
 2366                            LSMETHOD,
 2367                            'Body of FUNCTION',
 2368                            IAPICONSTANT.INFOLEVEL_3 );
 2369       
 2370       LSSQL :=
 2371             'SELECT DISTINCT '
 2372          || LSSELECT
 2373          || ' FROM '
 2374          || LSFROM
 2375          || ' WHERE (bi.part_no, bi.revision) IN (SELECT DISTINCT i.part_no, i.revision FROM itshq i WHERE i.user_id = :userid) '
 2376          || '   AND bi.component_part = :bomitem ';
 2377       LSSQL :=
 2378                  LSSQL
 2379               || ' ORDER BY '
 2380               || IAPICONSTANTCOLUMN.PARTNOCOL
 2381               || ', '
 2382               || IAPICONSTANTCOLUMN.REVISIONCOL
 2383               || ', '
 2384               || IAPICONSTANTCOLUMN.PLANTNOCOL;
 2385       LSSQL :=    'SELECT a.*, RowNum '
 2386                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2387                || ' FROM ('
 2388                || LSSQL
 2389                || ') a';
 2390       IAPIGENERAL.LOGINFO( GSSOURCE,
 2391                            LSMETHOD,
 2392                            LSSQL,
 2393                            IAPICONSTANT.INFOLEVEL_3 );
 2394 
 2395       
 2396       IF ( AQUSEDPLANTINBOMMOP%ISOPEN )
 2397       THEN
 2398          CLOSE AQUSEDPLANTINBOMMOP;
 2399       END IF;
 2400 
 2401       
 2402       OPEN AQUSEDPLANTINBOMMOP FOR LSSQL USING ASUSERID,
 2403       ASBOMITEM;
 2404 
 2405       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2406    EXCEPTION
 2407       WHEN OTHERS
 2408       THEN
 2409          IAPIGENERAL.LOGERROR( GSSOURCE,
 2410                                LSMETHOD,
 2411                                SQLERRM );
 2412          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2413    END GETUSEDPLANTINBOMMOP;
 2414 
 2415    
 2416    FUNCTION STOPJOB
 2417       RETURN IAPITYPE.ERRORNUM_TYPE
 2418    IS
 2419       
 2420       
 2421       
 2422       
 2423       
 2424       
 2425       
 2426       
 2427       
 2428       
 2429       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StopJob';
 2430       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2431       LIJOB                         BINARY_INTEGER;
 2432       LBJOBSTOPPED                  BOOLEAN;
 2433 
 2434       CURSOR LQJOB(
 2435          ASJOBNAME                  IN       VARCHAR2 )
 2436       IS
 2437          SELECT JOB
 2438            FROM DBA_JOBS
 2439           WHERE UPPER( WHAT ) LIKE UPPER( ASJOBNAME );
 2440 
 2441       PRAGMA AUTONOMOUS_TRANSACTION;
 2442    BEGIN
 2443       
 2444       
 2445       
 2446       IAPIGENERAL.LOGINFO( GSSOURCE,
 2447                            LSMETHOD,
 2448                            'Body of FUNCTION',
 2449                            IAPICONSTANT.INFOLEVEL_3 );
 2450 
 2451       OPEN LQJOB(    '%'
 2452                   || PSMOPJOB
 2453                   || '%' );
 2454 
 2455       LBJOBSTOPPED := FALSE;
 2456 
 2457       LOOP
 2458          FETCH LQJOB
 2459           INTO LIJOB;
 2460 
 2461          EXIT WHEN LQJOB%NOTFOUND;
 2462          DBMS_ALERT.SIGNAL( PSMOPJOBNAME,
 2463                             'Q_STOP' );
 2464          IAPIGENERAL.LOGINFO( GSSOURCE,
 2465                               LSMETHOD,
 2466                               'Signal to stop processing is send',
 2467                               IAPICONSTANT.INFOLEVEL_3 );
 2468          LBJOBSTOPPED := TRUE;
 2469       END LOOP;
 2470 
 2471       CLOSE LQJOB;
 2472 
 2473       IF ( LBJOBSTOPPED = FALSE )
 2474       THEN
 2475          RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
 2476                                                      LSMETHOD,
 2477                                                      IAPICONSTANTDBERROR.DBERR_JOBNOTFOUND ) );
 2478       END IF;
 2479 
 2480       COMMIT;
 2481       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2482    EXCEPTION
 2483       WHEN OTHERS
 2484       THEN
 2485          IF ( LQJOB%ISOPEN )
 2486          THEN
 2487             CLOSE LQJOB;
 2488          END IF;
 2489 
 2490          IAPIGENERAL.LOGERROR( GSSOURCE,
 2491                                LSMETHOD,
 2492                                SQLERRM );
 2493          ROLLBACK;
 2494          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2495    END STOPJOB;
 2496 
 2497    
 2498    FUNCTION STARTJOB
 2499       RETURN IAPITYPE.ERRORNUM_TYPE
 2500    IS
 2501       
 2502       
 2503       
 2504       
 2505       
 2506       
 2507       
 2508       
 2509       
 2510       
 2511       
 2512       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StartJob';
 2513       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2514       LIJOB                         BINARY_INTEGER;
 2515       LNISMOPRUNNING                IAPITYPE.BOOLEAN_TYPE;
 2516       PRAGMA AUTONOMOUS_TRANSACTION;
 2517    BEGIN
 2518       
 2519       
 2520       
 2521       IAPIGENERAL.LOGINFO( GSSOURCE,
 2522                            LSMETHOD,
 2523                            'Body of FUNCTION',
 2524                            IAPICONSTANT.INFOLEVEL_3 );
 2525       
 2526       LNRETVAL := ISMOPRUNNING( LNISMOPRUNNING );
 2527 
 2528       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2529       THEN
 2530          IAPIGENERAL.LOGINFO( GSSOURCE,
 2531                               LSMETHOD,
 2532                               IAPIGENERAL.GETLASTERRORTEXT( ) );
 2533          RETURN( LNRETVAL );
 2534       END IF;
 2535 
 2536       IF ( LNISMOPRUNNING = 1 )
 2537       THEN
 2538          IAPIGENERAL.LOGINFO( GSSOURCE,
 2539                               LSMETHOD,
 2540                               'Mop job already started' );
 2541       ELSE
 2542          DBMS_JOB.SUBMIT( LIJOB,
 2543                              PSMOPJOB
 2544                           || ';',
 2545                           SYSDATE,
 2546                           '' );
 2547          IAPIGENERAL.LOGINFO( GSSOURCE,
 2548                               LSMETHOD,
 2549                                  'Job <'
 2550                               || LIJOB
 2551                               || '> started',
 2552                               IAPICONSTANT.INFOLEVEL_3 );
 2553       END IF;
 2554 
 2555       COMMIT;
 2556       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2557    EXCEPTION
 2558       WHEN OTHERS
 2559       THEN
 2560          IAPIGENERAL.LOGERROR( GSSOURCE,
 2561                                LSMETHOD,
 2562                                SQLERRM );
 2563          ROLLBACK;
 2564          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2565    END STARTJOB;
 2566 
 2567    
 2568    FUNCTION ISMOPRUNNING(
 2569       ANISRUNNING                OUT      IAPITYPE.BOOLEAN_TYPE )
 2570       RETURN IAPITYPE.ERRORNUM_TYPE
 2571    IS
 2572       
 2573       
 2574       
 2575       
 2576       
 2577       
 2578       
 2579       
 2580       
 2581       
 2582       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsMopRunning';
 2583       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2584       LNJOBS                        NUMBER;
 2585    BEGIN
 2586       
 2587       
 2588       
 2589       IAPIGENERAL.LOGINFO( GSSOURCE,
 2590                            LSMETHOD,
 2591                            'Body of FUNCTION',
 2592                            IAPICONSTANT.INFOLEVEL_3 );
 2593 
 2594       SELECT COUNT( JOB )
 2595         INTO LNJOBS
 2596         FROM DBA_JOBS
 2597        WHERE UPPER( WHAT ) LIKE UPPER(    '%'
 2598                                        || PSMOPJOB
 2599                                        || '%' );
 2600 
 2601       IF LNJOBS > 0
 2602       THEN
 2603          ANISRUNNING := 1;
 2604       ELSE
 2605          ANISRUNNING := 0;
 2606       END IF;
 2607 
 2608       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2609    EXCEPTION
 2610       WHEN OTHERS
 2611       THEN
 2612          IAPIGENERAL.LOGERROR( GSSOURCE,
 2613                                LSMETHOD,
 2614                                SQLERRM );
 2615          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2616    END ISMOPRUNNING;
 2617 
 2618    
 2619    FUNCTION GETPARTSWITHBOM(
 2620       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
 2621       AQLIST                     OUT      IAPITYPE.REF_TYPE )
 2622       RETURN IAPITYPE.ERRORNUM_TYPE
 2623    IS
 2624       
 2625       
 2626       
 2627       
 2628       
 2629       
 2630       
 2631       
 2632       
 2633       
 2634       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPartsWithBom';
 2635       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2636       LSSQL                         VARCHAR2( 8192 ) := NULL;
 2637       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 2638       LSSELECT                      VARCHAR2( 4096 )
 2639          :=    'i.user_id '
 2640             || IAPICONSTANTCOLUMN.USERIDCOL
 2641             || ', i.part_no '
 2642             || IAPICONSTANTCOLUMN.PARTNOCOL
 2643             || ', i.revision '
 2644             || IAPICONSTANTCOLUMN.REVISIONCOL
 2645             || ', i.user_intl '
 2646             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 2647             || ', i.text '
 2648             || IAPICONSTANTCOLUMN.TEXTCOL
 2649             || ', f_sh_descr(1, i.part_no, i.revision) '
 2650             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
 2651             || ', s.status '
 2652             || IAPICONSTANTCOLUMN.STATUSIDCOL
 2653             || ', f_ss_descr(s.status) '
 2654             || IAPICONSTANTCOLUMN.STATUSCOL
 2655             || ', f_get_access(i.part_no, i.revision, i.user_id, i.user_intl) '
 2656             || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
 2657             || ', i.plant '
 2658             || IAPICONSTANTCOLUMN.PLANTNOCOL
 2659             || ', i.new_value_num '
 2660             || IAPICONSTANTCOLUMN.NEWVALUENUMCOL;
 2661       LSFROM                        IAPITYPE.STRING_TYPE := 'bom_header bh, specification_header s, itshq i ';
 2662    BEGIN
 2663       
 2664       
 2665       
 2666       
 2667       
 2668       IF ( AQLIST%ISOPEN )
 2669       THEN
 2670          CLOSE AQLIST;
 2671       END IF;
 2672 
 2673       LSSQLNULL :=    'SELECT '
 2674                    || LSSELECT
 2675                    || ' FROM '
 2676                    || LSFROM
 2677                    || ' WHERE user_id = NULL';
 2678       LSSQLNULL :=    'SELECT a.*, RowNum '
 2679                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2680                    || ' FROM ('
 2681                    || LSSQLNULL
 2682                    || ') a';
 2683       IAPIGENERAL.LOGINFO( GSSOURCE,
 2684                            LSMETHOD,
 2685                            LSSQLNULL,
 2686                            IAPICONSTANT.INFOLEVEL_3 );
 2687 
 2688       OPEN AQLIST FOR LSSQLNULL;
 2689 
 2690       
 2691       
 2692       
 2693       IAPIGENERAL.LOGINFO( GSSOURCE,
 2694                            LSMETHOD,
 2695                            'PreConditions',
 2696                            IAPICONSTANT.INFOLEVEL_3 );
 2697       
 2698       
 2699 
 2700       
 2701       
 2702       
 2703       IAPIGENERAL.LOGINFO( GSSOURCE,
 2704                            LSMETHOD,
 2705                            'Body of FUNCTION',
 2706                            IAPICONSTANT.INFOLEVEL_3 );
 2707       
 2708       LSSQL :=
 2709             'SELECT DISTINCT '
 2710          || LSSELECT
 2711          || ' FROM '
 2712          || LSFROM
 2713          || ' WHERE i.user_id=:id '
 2714          || '   AND i.part_no = bh.part_no AND i.revision = bh.revision '
 2715          || '   AND i.part_no = s.part_no AND i.revision = s.revision ';
 2716       LSSQL :=    LSSQL
 2717                || ' ORDER BY '
 2718                || IAPICONSTANTCOLUMN.PARTNOCOL
 2719                || ','
 2720                || IAPICONSTANTCOLUMN.REVISIONCOL;
 2721       LSSQL :=    'SELECT a.*, RowNum '
 2722                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2723                || ' FROM ('
 2724                || LSSQL
 2725                || ') a';
 2726       IAPIGENERAL.LOGINFO( GSSOURCE,
 2727                            LSMETHOD,
 2728                            LSSQL,
 2729                            IAPICONSTANT.INFOLEVEL_3 );
 2730 
 2731       
 2732       IF ( AQLIST%ISOPEN )
 2733       THEN
 2734          CLOSE AQLIST;
 2735       END IF;
 2736 
 2737       
 2738       OPEN AQLIST FOR LSSQL USING ASUSERID;
 2739 
 2740       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2741    EXCEPTION
 2742       WHEN OTHERS
 2743       THEN
 2744          IAPIGENERAL.LOGERROR( GSSOURCE,
 2745                                LSMETHOD,
 2746                                SQLERRM );
 2747          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2748    END GETPARTSWITHBOM;
 2749 
 2750    
 2751    FUNCTION GETAVAILABLEPLANTINBOM(
 2752       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
 2753       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 2754       ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
 2755       ASPLANTNOLIKE              IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 2756       AQAVAILABLEPLANTINBOM      OUT      IAPITYPE.REF_TYPE )
 2757       RETURN IAPITYPE.ERRORNUM_TYPE
 2758    IS
 2759       
 2760       
 2761       
 2762       
 2763       
 2764       
 2765       
 2766       
 2767       
 2768       
 2769       
 2770       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAvailablePlantInBom';
 2771       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2772       LSSQL                         VARCHAR2( 8192 ) := NULL;
 2773       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 2774       LSSELECT                      VARCHAR2( 4096 )
 2775                                                   :=    'p.plant '
 2776                                                      || IAPICONSTANTCOLUMN.PLANTNOCOL
 2777                                                      || ', p.description '
 2778                                                      || IAPICONSTANTCOLUMN.PLANTCOL;
 2779       LSFROM                        IAPITYPE.STRING_TYPE := 'bom_header bh, plant p, part_plant pp ';
 2780    BEGIN
 2781       
 2782       
 2783       
 2784       
 2785       
 2786       IF ( AQAVAILABLEPLANTINBOM%ISOPEN )
 2787       THEN
 2788          CLOSE AQAVAILABLEPLANTINBOM;
 2789       END IF;
 2790 
 2791       LSSQLNULL :=    'SELECT DISTINCT '
 2792                    || LSSELECT
 2793                    || ' FROM '
 2794                    || LSFROM
 2795                    || ' WHERE bh.plant = p.plant AND p.plant = pp.plant AND pp.plant = NULL';
 2796       LSSQLNULL :=    'SELECT a.*, RowNum '
 2797                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2798                    || ' FROM ('
 2799                    || LSSQLNULL
 2800                    || ') a';
 2801       IAPIGENERAL.LOGINFO( GSSOURCE,
 2802                            LSMETHOD,
 2803                            LSSQLNULL,
 2804                            IAPICONSTANT.INFOLEVEL_3 );
 2805 
 2806       OPEN AQAVAILABLEPLANTINBOM FOR LSSQLNULL;
 2807 
 2808       
 2809       
 2810       
 2811       IAPIGENERAL.LOGINFO( GSSOURCE,
 2812                            LSMETHOD,
 2813                            'PreConditions',
 2814                            IAPICONSTANT.INFOLEVEL_3 );
 2815        
 2816       
 2817       LNRETVAL := IAPIPART.EXISTID( ASBOMITEM );
 2818 
 2819       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2820       THEN
 2821          IAPIGENERAL.LOGINFO( GSSOURCE,
 2822                               LSMETHOD,
 2823                               IAPIGENERAL.GETLASTERRORTEXT( ) );
 2824          RETURN( LNRETVAL );
 2825       END IF;
 2826 
 2827       
 2828       
 2829       
 2830       IAPIGENERAL.LOGINFO( GSSOURCE,
 2831                            LSMETHOD,
 2832                            'Body of FUNCTION',
 2833                            IAPICONSTANT.INFOLEVEL_3 );
 2834       
 2835       LSSQL :=
 2836             'SELECT DISTINCT '
 2837          || LSSELECT
 2838          || ' FROM '
 2839          || LSFROM
 2840          || ' WHERE bh.part_no = :partno '
 2841          || '   AND bh.revision = :revision '
 2842          || '   AND p.plant = bh.plant '
 2843          || '   AND pp.part_no = :bomitem '
 2844          || '   AND bh.plant = pp.plant '
 2845          || '   AND pp.obsolete = 0';
 2846 
 2847       IF NOT( ASPLANTNOLIKE IS NULL )
 2848       THEN
 2849          LSSQL :=    LSSQL
 2850                   || ' AND p.plant LIKE :plantnolike ';
 2851       END IF;
 2852 
 2853       LSSQL :=    LSSQL
 2854                || ' ORDER BY '
 2855                || IAPICONSTANTCOLUMN.PLANTNOCOL;
 2856       LSSQL :=    'SELECT a.*, RowNum '
 2857                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2858                || ' FROM ('
 2859                || LSSQL
 2860                || ') a';
 2861       IAPIGENERAL.LOGINFO( GSSOURCE,
 2862                            LSMETHOD,
 2863                            LSSQL,
 2864                            IAPICONSTANT.INFOLEVEL_3 );
 2865 
 2866       
 2867       IF ( AQAVAILABLEPLANTINBOM%ISOPEN )
 2868       THEN
 2869          CLOSE AQAVAILABLEPLANTINBOM;
 2870       END IF;
 2871 
 2872       
 2873       IF NOT( ASPLANTNOLIKE IS NULL )
 2874       THEN
 2875          OPEN AQAVAILABLEPLANTINBOM FOR LSSQL USING ASPARTNO,
 2876          ANREVISION,
 2877          ASBOMITEM,
 2878             '%'
 2879          || ASPLANTNOLIKE
 2880          || '%';
 2881       ELSE
 2882          OPEN AQAVAILABLEPLANTINBOM FOR LSSQL USING ASPARTNO,
 2883          ANREVISION,
 2884          ASBOMITEM;
 2885       END IF;
 2886 
 2887       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 2888    EXCEPTION
 2889       WHEN OTHERS
 2890       THEN
 2891          IAPIGENERAL.LOGERROR( GSSOURCE,
 2892                                LSMETHOD,
 2893                                SQLERRM );
 2894          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 2895    END GETAVAILABLEPLANTINBOM;
 2896 
 2897    
 2898    FUNCTION GETAVAILABLEPLANTINBOMMOP(
 2899       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
 2900       ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
 2901       AQAVAILABLEPLANTINBOMMOP   OUT      IAPITYPE.REF_TYPE )
 2902       RETURN IAPITYPE.ERRORNUM_TYPE
 2903    IS
 2904       
 2905       
 2906       
 2907       
 2908       
 2909       
 2910       
 2911       
 2912       
 2913       
 2914       
 2915       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAvailablePlantInBomMop';
 2916       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 2917       LSSQL                         VARCHAR2( 8192 ) := NULL;
 2918       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 2919       LSSELECT                      VARCHAR2( 4096 )
 2920          :=    'bh.part_no '
 2921             || IAPICONSTANTCOLUMN.PARTNOCOL
 2922             || ', bh.revision '
 2923             || IAPICONSTANTCOLUMN.REVISIONCOL
 2924             || ', bh.plant '
 2925             || IAPICONSTANTCOLUMN.PLANTNOCOL;
 2926       LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bh, part_plant pp ';
 2927    BEGIN
 2928       
 2929       
 2930       
 2931       
 2932       
 2933       IF ( AQAVAILABLEPLANTINBOMMOP%ISOPEN )
 2934       THEN
 2935          CLOSE AQAVAILABLEPLANTINBOMMOP;
 2936       END IF;
 2937 
 2938       LSSQLNULL :=    'SELECT DISTINCT '
 2939                    || LSSELECT
 2940                    || ' FROM '
 2941                    || LSFROM
 2942                    || ' WHERE bh.part_no = NULL AND bh.plant = pp.plant ';
 2943       LSSQLNULL :=    'SELECT a.*, RowNum '
 2944                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 2945                    || ' FROM ('
 2946                    || LSSQLNULL
 2947                    || ') a';
 2948       IAPIGENERAL.LOGINFO( GSSOURCE,
 2949                            LSMETHOD,
 2950                            LSSQLNULL,
 2951                            IAPICONSTANT.INFOLEVEL_3 );
 2952 
 2953       OPEN AQAVAILABLEPLANTINBOMMOP FOR LSSQLNULL;
 2954 
 2955       
 2956       
 2957       
 2958       IAPIGENERAL.LOGINFO( GSSOURCE,
 2959                            LSMETHOD,
 2960                            'PreConditions',
 2961                            IAPICONSTANT.INFOLEVEL_3 );
 2962        
 2963       
 2964       LNRETVAL := IAPIPART.EXISTID( ASBOMITEM );
 2965 
 2966       IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 2967       THEN
 2968          IAPIGENERAL.LOGINFO( GSSOURCE,
 2969                               LSMETHOD,
 2970                               IAPIGENERAL.GETLASTERRORTEXT( ) );
 2971          RETURN( LNRETVAL );
 2972       END IF;
 2973 
 2974       
 2975       
 2976       
 2977       IAPIGENERAL.LOGINFO( GSSOURCE,
 2978                            LSMETHOD,
 2979                            'Body of FUNCTION',
 2980                            IAPICONSTANT.INFOLEVEL_3 );
 2981       
 2982       LSSQL :=
 2983             'SELECT DISTINCT '
 2984          || LSSELECT
 2985          || ' FROM '
 2986          || LSFROM
 2987          || ' WHERE (bh.part_no, bh.revision) IN (SELECT DISTINCT i.part_no, i.revision FROM itshq i WHERE i.user_id = :userid) '
 2988          || '   AND pp.part_no = :bomitem '
 2989          || '   AND bh.plant = pp.plant ';
 2990       LSSQL :=
 2991                  LSSQL
 2992               || ' ORDER BY '
 2993               || IAPICONSTANTCOLUMN.PARTNOCOL
 2994               || ', '
 2995               || IAPICONSTANTCOLUMN.REVISIONCOL
 2996               || ', '
 2997               || IAPICONSTANTCOLUMN.PLANTNOCOL;
 2998       LSSQL :=    'SELECT a.*, RowNum '
 2999                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3000                || ' FROM ('
 3001                || LSSQL
 3002                || ') a';
 3003       IAPIGENERAL.LOGINFO( GSSOURCE,
 3004                            LSMETHOD,
 3005                            LSSQL,
 3006                            IAPICONSTANT.INFOLEVEL_3 );
 3007 
 3008       
 3009       IF ( AQAVAILABLEPLANTINBOMMOP%ISOPEN )
 3010       THEN
 3011          CLOSE AQAVAILABLEPLANTINBOMMOP;
 3012       END IF;
 3013 
 3014       
 3015       OPEN AQAVAILABLEPLANTINBOMMOP FOR LSSQL USING ASUSERID,
 3016       ASBOMITEM;
 3017 
 3018       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 3019    EXCEPTION
 3020       WHEN OTHERS
 3021       THEN
 3022          IAPIGENERAL.LOGERROR( GSSOURCE,
 3023                                LSMETHOD,
 3024                                SQLERRM );
 3025          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 3026    END GETAVAILABLEPLANTINBOMMOP;
 3027 
 3028    
 3029    FUNCTION GETPROCESSDATA(
 3030       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
 3031       ANFIELDTYPE                IN       IAPITYPE.NUMVAL_TYPE,
 3032       ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
 3033       ASLINE                     IN       IAPITYPE.LINE_TYPE,
 3034       ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
 3035       ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
 3036       ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
 3037       ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
 3038       ANHEADERID                 IN       IAPITYPE.ID_TYPE,
 3039       AQPROCESSDATA              OUT      IAPITYPE.REF_TYPE )
 3040       RETURN IAPITYPE.ERRORNUM_TYPE
 3041    IS
 3042       
 3043       
 3044       
 3045       
 3046       
 3047       
 3048       
 3049       
 3050       
 3051       
 3052       
 3053       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProcessData';
 3054       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3055       LSSQL                         VARCHAR2( 8192 ) := NULL;
 3056       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 3057       LSSELECTBASE                  VARCHAR2( 4096 )
 3058          :=    'i.user_id '
 3059             || IAPICONSTANTCOLUMN.USERIDCOL
 3060             || ', i.part_no '
 3061             || IAPICONSTANTCOLUMN.PARTNOCOL
 3062             || ', i.revision '
 3063             || IAPICONSTANTCOLUMN.REVISIONCOL
 3064             || ', i.text '
 3065             || IAPICONSTANTCOLUMN.TEXTCOL
 3066             || ', To_NUMBER(i.user_intl) '
 3067             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 3068             || ', ''X'' '
 3069             || IAPICONSTANTCOLUMN.FIELDTYPECOL
 3070             || ', i.new_value_char '
 3071             || IAPICONSTANTCOLUMN.OLDVALUECHARCOL
 3072             || ', i.new_value_char '
 3073             || IAPICONSTANTCOLUMN.NEWVALUECHARCOL
 3074             || ', i.new_value_num '
 3075             || IAPICONSTANTCOLUMN.OLDVALUENUMCOL
 3076             || ', i.new_value_num '
 3077             || IAPICONSTANTCOLUMN.NEWVALUENUMCOL
 3078             || ', i.new_value_date '
 3079             || IAPICONSTANTCOLUMN.OLDVALUEDATECOL
 3080             || ', i.new_value_date '
 3081             || IAPICONSTANTCOLUMN.NEWVALUEDATECOL
 3082             || ', i.new_value_num '
 3083             || IAPICONSTANTCOLUMN.OLDVALUETMIDCOL
 3084             || ', i.new_value_num '
 3085             || IAPICONSTANTCOLUMN.NEWVALUETMIDCOL
 3086             || ', null '
 3087             || IAPICONSTANTCOLUMN.OLDVALUETMCOL   
 3088             || ', i.new_value_num '
 3089             || IAPICONSTANTCOLUMN.OLDVALUEASSIDCOL
 3090             || ', i.new_value_num '
 3091             || IAPICONSTANTCOLUMN.NEWVALUEASSIDCOL
 3092             || ', null '
 3093             || IAPICONSTANTCOLUMN.OLDVALUEASSCOL;   
 3094       LSFROMBASE                    IAPITYPE.STRING_TYPE := 'itshq i ';
 3095       LRPROCESSDAT                  IAPITYPE.MOPRPVSECTIONDATAREC_TYPE;
 3096       LRPROCESSDATA                 MOPRPVSECTIONDATARECORD_TYPE
 3097          := MOPRPVSECTIONDATARECORD_TYPE( NULL,
 3098                                           NULL,
 3099                                           NULL,
 3100                                           NULL,
 3101                                           NULL,
 3102                                           NULL,
 3103                                           NULL,
 3104                                           NULL,
 3105                                           NULL,
 3106                                           NULL,
 3107                                           NULL,
 3108                                           NULL,
 3109                                           NULL,
 3110                                           NULL,
 3111                                           NULL,
 3112                                           NULL,
 3113                                           NULL,
 3114                                           NULL,
 3115                                           NULL );
 3116       LTPROCESSDATA                 MOPRPVSECTIONDATATABLE_TYPE := MOPRPVSECTIONDATATABLE_TYPE( );
 3117       LSTYPE                        VARCHAR2( 16 );
 3118       LSOLDDATA                     VARCHAR2( 4096 );
 3119       LQOLDDATA                     IAPITYPE.REF_TYPE;
 3120       LNCOUNT                       NUMBER;
 3121       LSPARTNO                      IAPITYPE.PARTNO_TYPE;
 3122       LNREVISION                    IAPITYPE.REVISION_TYPE;
 3123       LNCOUNTOLD                    NUMBER;
 3124 
 3125       TYPE OLDDATADEFAULTREC_TYPE IS RECORD(
 3126          PARTNO                        IAPITYPE.PARTNO_TYPE,
 3127          REVISION                      IAPITYPE.REVISION_TYPE,
 3128          VALUE                         IAPITYPE.FLOAT_TYPE,
 3129          VALUE_S                       IAPITYPE.STRING_TYPE,
 3130          VALUE_DT                      IAPITYPE.DATE_TYPE
 3131       );
 3132 
 3133       TYPE LTOLDDATADEFAULT_TYPE IS TABLE OF OLDDATADEFAULTREC_TYPE
 3134          INDEX BY BINARY_INTEGER;
 3135 
 3136       LTOLDDATADEFAULT              LTOLDDATADEFAULT_TYPE;
 3137 
 3138       TYPE OLDDATATESTMETHODREC_TYPE IS RECORD(
 3139          PARTNO                        IAPITYPE.PARTNO_TYPE,
 3140          REVISION                      IAPITYPE.REVISION_TYPE,
 3141          TESTMETHODID                  IAPITYPE.ID_TYPE,
 3142          TESTMETHOD                    IAPITYPE.DESCRIPTION_TYPE
 3143       );
 3144 
 3145       TYPE LTOLDDATATESTMETHOD_TYPE IS TABLE OF OLDDATATESTMETHODREC_TYPE
 3146          INDEX BY BINARY_INTEGER;
 3147 
 3148       LTOLDDATATESTMETHOD           LTOLDDATATESTMETHOD_TYPE;
 3149 
 3150       TYPE OLDDATAASSOCIATIONREC_TYPE IS RECORD(
 3151          PARTNO                        IAPITYPE.PARTNO_TYPE,
 3152          REVISION                      IAPITYPE.REVISION_TYPE,
 3153          CHARACTERISTIC1               IAPITYPE.ID_TYPE,
 3154          ASSOCIATION1                  IAPITYPE.ID_TYPE,
 3155          CHARACTERISTIC2               IAPITYPE.ID_TYPE,
 3156          ASSOCIATION2                  IAPITYPE.ID_TYPE,
 3157          CHARACTERISTIC3               IAPITYPE.ID_TYPE,
 3158          ASSOCIATION3                  IAPITYPE.ID_TYPE
 3159       );
 3160 
 3161       TYPE LTOLDDATAASSOCIATION_TYPE IS TABLE OF OLDDATAASSOCIATIONREC_TYPE
 3162          INDEX BY BINARY_INTEGER;
 3163 
 3164       LTOLDDATAASSOCIATION          LTOLDDATAASSOCIATION_TYPE;
 3165    BEGIN
 3166       
 3167       
 3168       
 3169       
 3170       
 3171       IF ( AQPROCESSDATA%ISOPEN )
 3172       THEN
 3173          CLOSE AQPROCESSDATA;
 3174       END IF;
 3175 
 3176       LSSQLNULL :=    'SELECT '
 3177                    || LSSELECTBASE
 3178                    || ' FROM '
 3179                    || LSFROMBASE
 3180                    || ' WHERE i.user_id = NULL';
 3181       LSSQLNULL :=    'SELECT a.*, RowNum '
 3182                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3183                    || ' FROM ('
 3184                    || LSSQLNULL
 3185                    || ') a';
 3186       IAPIGENERAL.LOGINFO( GSSOURCE,
 3187                            LSMETHOD,
 3188                            LSSQLNULL,
 3189                            IAPICONSTANT.INFOLEVEL_3 );
 3190 
 3191       OPEN AQPROCESSDATA FOR LSSQLNULL;
 3192 
 3193       
 3194       
 3195       
 3196       IAPIGENERAL.LOGINFO( GSSOURCE,
 3197                            LSMETHOD,
 3198                            'Body of FUNCTION',
 3199                            IAPICONSTANT.INFOLEVEL_3 );
 3200       
 3201       LSSQL :=    'SELECT '
 3202                || LSSELECTBASE
 3203                || ' FROM '
 3204                || LSFROMBASE
 3205                || ' WHERE i.user_id = :userid ';
 3206       LSSQL :=    'SELECT a.*, RowNum '
 3207                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3208                || ' FROM ('
 3209                || LSSQL
 3210                || ') a';
 3211       IAPIGENERAL.LOGINFO( GSSOURCE,
 3212                            LSMETHOD,
 3213                            LSSQL,
 3214                            IAPICONSTANT.INFOLEVEL_3 );
 3215 
 3216       
 3217       IF ( AQPROCESSDATA%ISOPEN )
 3218       THEN
 3219          CLOSE AQPROCESSDATA;
 3220       END IF;
 3221 
 3222       
 3223       OPEN AQPROCESSDATA FOR LSSQL USING ASUSERID;
 3224 
 3225       IAPIGENERAL.LOGINFO( GSSOURCE,
 3226                            LSMETHOD,
 3227                            'About to fetch data',
 3228                            IAPICONSTANT.INFOLEVEL_3 );
 3229       
 3230       LTPROCESSDATA.DELETE;
 3231 
 3232       LOOP
 3233          LRPROCESSDAT := NULL;
 3234 
 3235          FETCH AQPROCESSDATA
 3236           INTO LRPROCESSDAT;
 3237 
 3238          EXIT WHEN AQPROCESSDATA%NOTFOUND;
 3239          LRPROCESSDATA.ROWINDEX := LRPROCESSDAT.ROWINDEX;
 3240          LRPROCESSDATA.USERID := LRPROCESSDAT.USERID;
 3241          LRPROCESSDATA.PARTNO := LRPROCESSDAT.PARTNO;
 3242          LRPROCESSDATA.REVISION := LRPROCESSDAT.REVISION;
 3243          LRPROCESSDATA.TEXT := LRPROCESSDAT.TEXT;
 3244          LRPROCESSDATA.INTERNATIONAL := LRPROCESSDAT.INTERNATIONAL;
 3245          LRPROCESSDATA.FIELDTYPE := LRPROCESSDAT.FIELDTYPE;
 3246          LRPROCESSDATA.OLDVALUECHAR := LRPROCESSDAT.OLDVALUECHAR;
 3247          LRPROCESSDATA.NEWVALUECHAR := LRPROCESSDAT.NEWVALUECHAR;
 3248          LRPROCESSDATA.OLDVALUENUM := LRPROCESSDAT.OLDVALUENUM;
 3249          LRPROCESSDATA.NEWVALUENUM := LRPROCESSDAT.NEWVALUENUM;
 3250          LRPROCESSDATA.OLDVALUEDATE := LRPROCESSDAT.OLDVALUEDATE;
 3251          LRPROCESSDATA.NEWVALUEDATE := LRPROCESSDAT.NEWVALUEDATE;
 3252          LRPROCESSDATA.OLDVALUETMID := LRPROCESSDAT.OLDVALUETMID;
 3253          LRPROCESSDATA.NEWVALUETMID := LRPROCESSDAT.NEWVALUETMID;
 3254          LRPROCESSDATA.OLDVALUETM := LRPROCESSDAT.OLDVALUETM;
 3255          LRPROCESSDATA.OLDVALUEASSID := LRPROCESSDAT.OLDVALUEASSID;
 3256          LRPROCESSDATA.NEWVALUEASSID := LRPROCESSDAT.NEWVALUEASSID;
 3257          LRPROCESSDATA.OLDVALUEASS := LRPROCESSDAT.OLDVALUEASS;
 3258          LTPROCESSDATA.EXTEND;
 3259          LTPROCESSDATA( LTPROCESSDATA.COUNT ) := LRPROCESSDATA;
 3260       END LOOP;
 3261 
 3262       IAPIGENERAL.LOGINFO( GSSOURCE,
 3263                            LSMETHOD,
 3264                               'Number of items fetched: <'
 3265                            || LTPROCESSDATA.COUNT
 3266                            || '>',
 3267                            IAPICONSTANT.INFOLEVEL_3 );
 3268 
 3269       
 3270       CASE ANFIELDTYPE
 3271          WHEN 1   
 3272          THEN
 3273             LSTYPE := 'DEFAULT';
 3274          WHEN 4   
 3275          THEN
 3276             LSTYPE := 'DEFAULT';
 3277          WHEN 5   
 3278          THEN
 3279             LSTYPE := 'ASSOCIATION';
 3280          WHEN 6   
 3281          THEN
 3282             LSTYPE := 'TESTMETHOD';
 3283          WHEN 7   
 3284          THEN
 3285             LSTYPE := 'ASSOCIATION';
 3286          WHEN 8   
 3287          THEN
 3288             LSTYPE := 'ASSOCIATION';
 3289          ELSE   
 3290             LSTYPE := 'DEFAULT';
 3291       END CASE;
 3292 
 3293       
 3294       IF ( LQOLDDATA%ISOPEN )
 3295       THEN
 3296          CLOSE LQOLDDATA;
 3297       END IF;
 3298 
 3299       
 3300       CASE LSTYPE
 3301          WHEN 'ASSOCIATION'
 3302          THEN
 3303             LSOLDDATA := 'SELECT slp.part_no, slp.revision, slp.characteristic, slp.association ';
 3304             LSOLDDATA :=    LSOLDDATA
 3305                          || ' FROM specification_line_prop slp, itshq i ';
 3306             LSOLDDATA :=    LSOLDDATA
 3307                          || ' WHERE slp.part_no = i.part_no ';
 3308             LSOLDDATA :=    LSOLDDATA
 3309                          || ' AND slp.revision = i.revision ';
 3310             LSOLDDATA :=    LSOLDDATA
 3311                          || ' AND i.user_id = :userid ';
 3312             LSOLDDATA :=    LSOLDDATA
 3313                          || ' AND slp.plant = :plantno ';
 3314             LSOLDDATA :=    LSOLDDATA
 3315                          || ' AND slp.line = :line ';
 3316             LSOLDDATA :=    LSOLDDATA
 3317                          || ' AND slp.configuration = :configuration ';
 3318             LSOLDDATA :=    LSOLDDATA
 3319                          || ' AND slp.stage = :stageid ';
 3320             LSOLDDATA :=    LSOLDDATA
 3321                          || ' AND slp.property = :propertyid ';
 3322             LSOLDDATA :=    LSOLDDATA
 3323                          || ' AND slp.attribute = :attributeid ';
 3324             IAPIGENERAL.LOGINFO( GSSOURCE,
 3325                                  LSMETHOD,
 3326                                  LSOLDDATA,
 3327                                  IAPICONSTANT.INFOLEVEL_3 );
 3328             IAPIGENERAL.LOGINFO( GSSOURCE,
 3329                                  LSMETHOD,
 3330                                     ASUSERID
 3331                                  || '/'
 3332                                  || ASPLANTNO
 3333                                  || '/'
 3334                                  || ASLINE
 3335                                  || '/'
 3336                                  || ANCONFIGURATION
 3337                                  || '/'
 3338                                  || ANSTAGEID
 3339                                  || '/'
 3340                                  || ANPROPERTYID
 3341                                  || '/'
 3342                                  || ANATTRIBUTEID,
 3343                                  IAPICONSTANT.INFOLEVEL_3 );
 3344 
 3345             OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
 3346             ASPLANTNO,
 3347             ASLINE,
 3348             ANCONFIGURATION,
 3349             ANSTAGEID,
 3350             ANPROPERTYID,
 3351             ANATTRIBUTEID;
 3352 
 3353             FETCH LQOLDDATA
 3354             BULK COLLECT INTO LTOLDDATAASSOCIATION;
 3355 
 3356             CLOSE LQOLDDATA;
 3357          WHEN 'TESTMETHOD'
 3358          THEN
 3359             LSOLDDATA := 'SELECT sp.part_no, sp.revision, sp.test_method, f_tmh_descr(1, sp.test_method, sp.test_method_rev ) ';
 3360             LSOLDDATA :=    LSOLDDATA
 3361                          || ' FROM specdata_process s, itshq i ';
 3362             LSOLDDATA :=    LSOLDDATA
 3363                          || ' WHERE sp.part_no = i.part_no ';
 3364             LSOLDDATA :=    LSOLDDATA
 3365                          || ' AND sp.revision = i.revision ';
 3366             LSOLDDATA :=    LSOLDDATA
 3367                          || ' AND i.user_id = :userid ';
 3368             LSOLDDATA :=    LSOLDDATA
 3369                          || ' AND sp.plant = :plantno ';
 3370             LSOLDDATA :=    LSOLDDATA
 3371                          || ' AND sp.line = :line ';
 3372             LSOLDDATA :=    LSOLDDATA
 3373                          || ' AND sp.configuration = :configuration ';
 3374             LSOLDDATA :=    LSOLDDATA
 3375                          || ' AND sp.stage = :stageid ';
 3376             LSOLDDATA :=    LSOLDDATA
 3377                          || ' AND sp.property = :propertyid ';
 3378             LSOLDDATA :=    LSOLDDATA
 3379                          || ' AND sp.attribute = :attributeid ';
 3380             LSOLDDATA :=    LSOLDDATA
 3381                          || ' AND sp.test_method <> -1 ';
 3382             IAPIGENERAL.LOGINFO( GSSOURCE,
 3383                                  LSMETHOD,
 3384                                  LSOLDDATA,
 3385                                  IAPICONSTANT.INFOLEVEL_3 );
 3386             IAPIGENERAL.LOGINFO( GSSOURCE,
 3387                                  LSMETHOD,
 3388                                     ASUSERID
 3389                                  || '/'
 3390                                  || ASPLANTNO
 3391                                  || '/'
 3392                                  || ASLINE
 3393                                  || '/'
 3394                                  || ANCONFIGURATION
 3395                                  || '/'
 3396                                  || ANSTAGEID
 3397                                  || '/'
 3398                                  || ANPROPERTYID
 3399                                  || '/'
 3400                                  || ANATTRIBUTEID,
 3401                                  IAPICONSTANT.INFOLEVEL_3 );
 3402 
 3403             OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
 3404             ASPLANTNO,
 3405             ASLINE,
 3406             ANCONFIGURATION,
 3407             ANSTAGEID,
 3408             ANPROPERTYID,
 3409             ANATTRIBUTEID;
 3410 
 3411             FETCH LQOLDDATA
 3412             BULK COLLECT INTO LTOLDDATATESTMETHOD;
 3413 
 3414             CLOSE LQOLDDATA;
 3415          ELSE   
 3416             LSOLDDATA := 'SELECT sp.part_no, sp.revision, sp.value, sp.value_s, sp.value_dt ';
 3417             LSOLDDATA :=    LSOLDDATA
 3418                          || ' FROM specdata_process sp, itshq i ';
 3419             LSOLDDATA :=    LSOLDDATA
 3420                          || ' WHERE sp.part_no = i.part_no ';
 3421             LSOLDDATA :=    LSOLDDATA
 3422                          || ' AND sp.revision = i.revision ';
 3423             LSOLDDATA :=    LSOLDDATA
 3424                          || ' AND i.user_id = :userid ';
 3425             LSOLDDATA :=    LSOLDDATA
 3426                          || ' AND sp.plant = :plantno ';
 3427             LSOLDDATA :=    LSOLDDATA
 3428                          || ' AND sp.line = :line ';
 3429             LSOLDDATA :=    LSOLDDATA
 3430                          || ' AND sp.configuration = :configuration ';
 3431             LSOLDDATA :=    LSOLDDATA
 3432                          || ' AND sp.stage = :stageid ';
 3433             LSOLDDATA :=    LSOLDDATA
 3434                          || ' AND sp.property = :propertyid ';
 3435             LSOLDDATA :=    LSOLDDATA
 3436                          || ' AND sp.attribute = :attributeid ';
 3437             LSOLDDATA :=    LSOLDDATA
 3438                          || ' AND sp.header_id = :headerid ';
 3439             IAPIGENERAL.LOGINFO( GSSOURCE,
 3440                                  LSMETHOD,
 3441                                  LSOLDDATA,
 3442                                  IAPICONSTANT.INFOLEVEL_3 );
 3443             IAPIGENERAL.LOGINFO( GSSOURCE,
 3444                                  LSMETHOD,
 3445                                     ASUSERID
 3446                                  || '/'
 3447                                  || ASPLANTNO
 3448                                  || '/'
 3449                                  || ASLINE
 3450                                  || '/'
 3451                                  || ANCONFIGURATION
 3452                                  || '/'
 3453                                  || ANSTAGEID
 3454                                  || '/'
 3455                                  || ANPROPERTYID
 3456                                  || '/'
 3457                                  || ANATTRIBUTEID,
 3458                                  IAPICONSTANT.INFOLEVEL_3 );
 3459 
 3460             OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
 3461             ASPLANTNO,
 3462             ASLINE,
 3463             ANCONFIGURATION,
 3464             ANSTAGEID,
 3465             ANPROPERTYID,
 3466             ANATTRIBUTEID,
 3467             ANHEADERID;
 3468 
 3469             FETCH LQOLDDATA
 3470             BULK COLLECT INTO LTOLDDATADEFAULT;
 3471 
 3472             CLOSE LQOLDDATA;
 3473       END CASE;
 3474 
 3475       
 3476       
 3477       IF ( LTPROCESSDATA.COUNT > 0 )
 3478       THEN
 3479          FOR LNCOUNT IN LTPROCESSDATA.FIRST .. LTPROCESSDATA.LAST
 3480          LOOP
 3481             
 3482             LSPARTNO := LTPROCESSDATA( LNCOUNT ).PARTNO;
 3483             LNREVISION := LTPROCESSDATA( LNCOUNT ).REVISION;
 3484 
 3485             CASE LSTYPE
 3486                WHEN 'ASSOCIATION'
 3487                THEN
 3488                   
 3489                   IF ( LTOLDDATAASSOCIATION.COUNT > 0 )
 3490                   THEN
 3491                      FOR LNCOUNTOLD IN LTOLDDATAASSOCIATION.FIRST .. LTOLDDATAASSOCIATION.LAST
 3492                      LOOP
 3493                         IF (      ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).PARTNO = LSPARTNO )
 3494                              AND ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).REVISION = LNREVISION ) )
 3495                         THEN
 3496                            IAPIGENERAL.LOGINFO( GSSOURCE,
 3497                                                 LSMETHOD,
 3498                                                    'Part/revision <'
 3499                                                 || LSPARTNO
 3500                                                 || ' / '
 3501                                                 || LNREVISION
 3502                                                 || '> found',
 3503                                                 IAPICONSTANT.INFOLEVEL_3 );
 3504                            LTPROCESSDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION1;
 3505                            LTPROCESSDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION2;
 3506                            LTPROCESSDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION3;
 3507                         END IF;
 3508                      END LOOP;
 3509                   END IF;
 3510                WHEN 'TESTMETHOD'
 3511                THEN
 3512                   
 3513                   IF ( LTOLDDATATESTMETHOD.COUNT > 0 )
 3514                   THEN
 3515                      FOR LNCOUNTOLD IN LTOLDDATATESTMETHOD.FIRST .. LTOLDDATATESTMETHOD.LAST
 3516                      LOOP
 3517                         IF (      ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).PARTNO = LSPARTNO )
 3518                              AND ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).REVISION = LNREVISION ) )
 3519                         THEN
 3520                            IAPIGENERAL.LOGINFO( GSSOURCE,
 3521                                                 LSMETHOD,
 3522                                                    'Part/revision <'
 3523                                                 || LSPARTNO
 3524                                                 || ' / '
 3525                                                 || LNREVISION
 3526                                                 || '> found, tm = '
 3527                                                 || LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD,
 3528                                                 IAPICONSTANT.INFOLEVEL_3 );
 3529                            LTPROCESSDATA( LNCOUNT ).OLDVALUETMID := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHODID;
 3530                            LTPROCESSDATA( LNCOUNT ).OLDVALUETM := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD;
 3531                         END IF;
 3532                      END LOOP;
 3533                   END IF;
 3534                ELSE
 3535                   
 3536                   IF ( LTOLDDATADEFAULT.COUNT > 0 )
 3537                   THEN
 3538                      FOR LNCOUNTOLD IN LTOLDDATADEFAULT.FIRST .. LTOLDDATADEFAULT.LAST
 3539                      LOOP
 3540                         IF (      ( LTOLDDATADEFAULT( LNCOUNTOLD ).PARTNO = LSPARTNO )
 3541                              AND ( LTOLDDATADEFAULT( LNCOUNTOLD ).REVISION = LNREVISION ) )
 3542                         THEN
 3543                            IAPIGENERAL.LOGINFO( GSSOURCE,
 3544                                                 LSMETHOD,
 3545                                                    'Part/revision <'
 3546                                                 || LSPARTNO
 3547                                                 || ' / '
 3548                                                 || LNREVISION
 3549                                                 || '> found',
 3550                                                 IAPICONSTANT.INFOLEVEL_3 );
 3551                            LTPROCESSDATA( LNCOUNT ).OLDVALUENUM := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE;
 3552                            LTPROCESSDATA( LNCOUNT ).OLDVALUECHAR := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_S;
 3553                            LTPROCESSDATA( LNCOUNT ).OLDVALUEDATE := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_DT;
 3554                         END IF;
 3555                      END LOOP;
 3556                   END IF;
 3557             END CASE;
 3558          END LOOP;
 3559       END IF;
 3560 
 3561       
 3562       IF ( AQPROCESSDATA%ISOPEN )
 3563       THEN
 3564          CLOSE AQPROCESSDATA;
 3565       END IF;
 3566 
 3567       OPEN AQPROCESSDATA FOR
 3568          SELECT *
 3569            FROM TABLE( CAST( LTPROCESSDATA AS MOPRPVSECTIONDATATABLE_TYPE ) );
 3570 
 3571       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 3572    EXCEPTION
 3573       WHEN OTHERS
 3574       THEN
 3575          IAPIGENERAL.LOGERROR( GSSOURCE,
 3576                                LSMETHOD,
 3577                                SQLERRM );
 3578          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 3579    END GETPROCESSDATA;
 3580 
 3581    
 3582    FUNCTION GETPLANTLINECONFIGURATIONS(
 3583       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 3584       AQPLANTLINECONFIGURATIONS  OUT      IAPITYPE.REF_TYPE )
 3585       RETURN IAPITYPE.ERRORNUM_TYPE
 3586    IS
 3587       
 3588       
 3589       
 3590       
 3591       
 3592       
 3593       
 3594       
 3595       
 3596       
 3597       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlantLineConfigurations';
 3598       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3599       LSSQL                         VARCHAR2( 8192 ) := NULL;
 3600       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 3601       LSSELECT                      VARCHAR2( 4096 )
 3602          :=    'pl.plant '
 3603             || IAPICONSTANTCOLUMN.PLANTNOCOL
 3604             || ', pl.line '
 3605             || IAPICONSTANTCOLUMN.LINECOL
 3606             || ', pl.configuration '
 3607             || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
 3608             || ', pl.description '
 3609             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 3610       LSFROM                        IAPITYPE.STRING_TYPE := 'process_line pl, plant p ';
 3611    BEGIN
 3612       
 3613       
 3614       
 3615       
 3616       
 3617       IF ( AQPLANTLINECONFIGURATIONS%ISOPEN )
 3618       THEN
 3619          CLOSE AQPLANTLINECONFIGURATIONS;
 3620       END IF;
 3621 
 3622       LSSQLNULL :=    'SELECT '
 3623                    || LSSELECT
 3624                    || ' FROM '
 3625                    || LSFROM
 3626                    || ' WHERE pl.plant = NULL';
 3627       LSSQLNULL :=    'SELECT a.*, RowNum '
 3628                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3629                    || ' FROM ('
 3630                    || LSSQLNULL
 3631                    || ') a';
 3632       IAPIGENERAL.LOGINFO( GSSOURCE,
 3633                            LSMETHOD,
 3634                            LSSQLNULL,
 3635                            IAPICONSTANT.INFOLEVEL_3 );
 3636 
 3637       OPEN AQPLANTLINECONFIGURATIONS FOR LSSQLNULL;
 3638 
 3639       
 3640       
 3641       
 3642       IAPIGENERAL.LOGINFO( GSSOURCE,
 3643                            LSMETHOD,
 3644                            'Body of FUNCTION',
 3645                            IAPICONSTANT.INFOLEVEL_3 );
 3646       
 3647       LSSQL :=    'SELECT DISTINCT '
 3648                || LSSELECT
 3649                || ' FROM '
 3650                || LSFROM;
 3651       LSSQL :=
 3652                 LSSQL
 3653              || ' ORDER BY '
 3654              || IAPICONSTANTCOLUMN.PLANTNOCOL
 3655              || ','
 3656              || IAPICONSTANTCOLUMN.LINECOL
 3657              || ','
 3658              || IAPICONSTANTCOLUMN.CONFIGURATIONCOL;
 3659       LSSQL :=    'SELECT a.*, RowNum '
 3660                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3661                || ' FROM ('
 3662                || LSSQL
 3663                || ') a';
 3664       IAPIGENERAL.LOGINFO( GSSOURCE,
 3665                            LSMETHOD,
 3666                            LSSQL,
 3667                            IAPICONSTANT.INFOLEVEL_3 );
 3668 
 3669       
 3670       IF ( AQPLANTLINECONFIGURATIONS%ISOPEN )
 3671       THEN
 3672          CLOSE AQPLANTLINECONFIGURATIONS;
 3673       END IF;
 3674 
 3675       
 3676       OPEN AQPLANTLINECONFIGURATIONS FOR LSSQL;
 3677 
 3678       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 3679    EXCEPTION
 3680       WHEN OTHERS
 3681       THEN
 3682          IAPIGENERAL.LOGERROR( GSSOURCE,
 3683                                LSMETHOD,
 3684                                SQLERRM );
 3685          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 3686    END GETPLANTLINECONFIGURATIONS;
 3687 
 3688    
 3689    FUNCTION GETSTAGEPROPERTIES(
 3690       ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
 3691       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 3692       AQPROPERTIES               OUT      IAPITYPE.REF_TYPE )
 3693       RETURN IAPITYPE.ERRORNUM_TYPE
 3694    IS
 3695       
 3696       
 3697       
 3698       
 3699       
 3700       
 3701       
 3702       
 3703       
 3704       
 3705       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStageProperties';
 3706       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3707       LSSQL                         VARCHAR2( 8192 ) := NULL;
 3708       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 3709       LSSELECT                      VARCHAR2( 4096 )
 3710          :=    'sl.property '
 3711             || IAPICONSTANTCOLUMN.PROPERTYIDCOL
 3712             || ', sl.intl '
 3713             || IAPICONSTANTCOLUMN.INTERNATIONALCOL
 3714             || ', f_sph_descr(1, sl.property, 0) '
 3715             || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 3716       LSFROM                        IAPITYPE.STRING_TYPE := 'stage_list sl ';
 3717    BEGIN
 3718       
 3719       
 3720       
 3721       
 3722       
 3723       IF ( AQPROPERTIES%ISOPEN )
 3724       THEN
 3725          CLOSE AQPROPERTIES;
 3726       END IF;
 3727 
 3728       LSSQLNULL :=    'SELECT '
 3729                    || LSSELECT
 3730                    || ' FROM '
 3731                    || LSFROM
 3732                    || ' WHERE sl.stage = NULL';
 3733       LSSQLNULL :=    'SELECT a.*, RowNum '
 3734                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3735                    || ' FROM ('
 3736                    || LSSQLNULL
 3737                    || ') a';
 3738       IAPIGENERAL.LOGINFO( GSSOURCE,
 3739                            LSMETHOD,
 3740                            LSSQLNULL,
 3741                            IAPICONSTANT.INFOLEVEL_3 );
 3742 
 3743       OPEN AQPROPERTIES FOR LSSQLNULL;
 3744 
 3745       
 3746       
 3747       
 3748       IAPIGENERAL.LOGINFO( GSSOURCE,
 3749                            LSMETHOD,
 3750                            'Body of FUNCTION',
 3751                            IAPICONSTANT.INFOLEVEL_3 );
 3752       
 3753       LSSQL :=    'SELECT DISTINCT '
 3754                || LSSELECT
 3755                || ' FROM '
 3756                || LSFROM
 3757                || ' WHERE sl.stage = :stageid ';
 3758 
 3759       IF NOT( ASDESCRIPTIONLIKE IS NULL )
 3760       THEN
 3761          LSSQL :=    LSSQL
 3762                   || ' AND f_sph_descr(1, sl.property, 0) LIKE ''%'
 3763                   || ASDESCRIPTIONLIKE
 3764                   || '%''';
 3765       END IF;
 3766 
 3767       LSSQL :=    LSSQL
 3768                || ' ORDER BY '
 3769                || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
 3770       LSSQL :=    'SELECT a.*, RowNum '
 3771                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3772                || ' FROM ('
 3773                || LSSQL
 3774                || ') a';
 3775       IAPIGENERAL.LOGINFO( GSSOURCE,
 3776                            LSMETHOD,
 3777                            LSSQL,
 3778                            IAPICONSTANT.INFOLEVEL_3 );
 3779 
 3780       
 3781       IF ( AQPROPERTIES%ISOPEN )
 3782       THEN
 3783          CLOSE AQPROPERTIES;
 3784       END IF;
 3785 
 3786       
 3787       OPEN AQPROPERTIES FOR LSSQL USING ANSTAGEID;
 3788 
 3789       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 3790    EXCEPTION
 3791       WHEN OTHERS
 3792       THEN
 3793          IAPIGENERAL.LOGERROR( GSSOURCE,
 3794                                LSMETHOD,
 3795                                SQLERRM );
 3796          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 3797    END GETSTAGEPROPERTIES;
 3798 
 3799    
 3800    FUNCTION GETSTAGES(
 3801       ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
 3802       ASLINE                     IN       IAPITYPE.LINE_TYPE,
 3803       ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
 3804       ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
 3805       AQSTAGES                   OUT      IAPITYPE.REF_TYPE )
 3806       RETURN IAPITYPE.ERRORNUM_TYPE
 3807    IS
 3808       
 3809       
 3810       
 3811       
 3812       
 3813       
 3814       
 3815       
 3816       
 3817       
 3818       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStages';
 3819       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3820       LSSQL                         VARCHAR2( 8192 ) := NULL;
 3821       LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
 3822       LSSELECT                      VARCHAR2( 4096 )
 3823          :=    'pls.stage '
 3824             || IAPICONSTANTCOLUMN.STAGEIDCOL
 3825             || ', f_sth_descr(pls.stage) '
 3826             || IAPICONSTANTCOLUMN.STAGECOL
 3827             || ', pls.intl '
 3828             || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
 3829       LSFROM                        IAPITYPE.STRING_TYPE := 'process_line_stage pls ';
 3830    BEGIN
 3831       
 3832       
 3833       
 3834       
 3835       
 3836       IF ( AQSTAGES%ISOPEN )
 3837       THEN
 3838          CLOSE AQSTAGES;
 3839       END IF;
 3840 
 3841       LSSQLNULL :=    'SELECT '
 3842                    || LSSELECT
 3843                    || ' FROM '
 3844                    || LSFROM
 3845                    || ' WHERE pls.plant = NULL';
 3846       LSSQLNULL :=    'SELECT a.*, RowNum '
 3847                    || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3848                    || ' FROM ('
 3849                    || LSSQLNULL
 3850                    || ') a';
 3851       IAPIGENERAL.LOGINFO( GSSOURCE,
 3852                            LSMETHOD,
 3853                            LSSQLNULL,
 3854                            IAPICONSTANT.INFOLEVEL_3 );
 3855 
 3856       OPEN AQSTAGES FOR LSSQLNULL;
 3857 
 3858       
 3859       
 3860       
 3861       IAPIGENERAL.LOGINFO( GSSOURCE,
 3862                            LSMETHOD,
 3863                            'Body of FUNCTION',
 3864                            IAPICONSTANT.INFOLEVEL_3 );
 3865       
 3866       LSSQL :=
 3867             'SELECT DISTINCT '
 3868          || LSSELECT
 3869          || ' FROM '
 3870          || LSFROM
 3871          || ' WHERE pls.plant = :plantno '
 3872          || '   AND pls.line = :line '
 3873          || '   AND pls.configuration = :configuration ';
 3874 
 3875       IF NOT( ASDESCRIPTIONLIKE IS NULL )
 3876       THEN
 3877          LSSQL :=    LSSQL
 3878                   || ' AND f_sth_descr(pls.stage) LIKE ''%'
 3879                   || ASDESCRIPTIONLIKE
 3880                   || '%''';
 3881       END IF;
 3882 
 3883       LSSQL :=    LSSQL
 3884                || ' ORDER BY '
 3885                || IAPICONSTANTCOLUMN.STAGECOL;
 3886       LSSQL :=    'SELECT a.*, RowNum '
 3887                || IAPICONSTANTCOLUMN.ROWINDEXCOL
 3888                || ' FROM ('
 3889                || LSSQL
 3890                || ') a';
 3891       IAPIGENERAL.LOGINFO( GSSOURCE,
 3892                            LSMETHOD,
 3893                            LSSQL,
 3894                            IAPICONSTANT.INFOLEVEL_3 );
 3895 
 3896       
 3897       IF ( AQSTAGES%ISOPEN )
 3898       THEN
 3899          CLOSE AQSTAGES;
 3900       END IF;
 3901 
 3902       
 3903       OPEN AQSTAGES FOR LSSQL USING ASPLANTNO,
 3904       ASLINE,
 3905       ANCONFIGURATION;
 3906 
 3907       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 3908    EXCEPTION
 3909       WHEN OTHERS
 3910       THEN
 3911          IAPIGENERAL.LOGERROR( GSSOURCE,
 3912                                LSMETHOD,
 3913                                SQLERRM );
 3914          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 3915    END GETSTAGES;
 3916 
 3917    
 3918    FUNCTION UPDATEPROGRESS(
 3919       ASUSERID                   IN       IAPITYPE.USERID_TYPE,
 3920       ANPROGRESS                 IN       IAPITYPE.MOPPROGRESS_TYPE,
 3921       ASSTATUS                   IN       IAPITYPE.MOPSTATUS_TYPE DEFAULT NULL )
 3922       RETURN IAPITYPE.ERRORNUM_TYPE
 3923    IS
 3924       
 3925       
 3926       
 3927       
 3928       
 3929       
 3930       
 3931       
 3932       
 3933       
 3934       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateProgress';
 3935       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 3936    
 3937    BEGIN
 3938       
 3939       
 3940       
 3941       IAPIGENERAL.LOGINFO( GSSOURCE,
 3942                            LSMETHOD,
 3943                            'PreConditions',
 3944                            IAPICONSTANT.INFOLEVEL_3 );
 3945       
 3946       
 3947 
 3948       
 3949       
 3950       
 3951       IAPIGENERAL.LOGINFO( GSSOURCE,
 3952                            LSMETHOD,
 3953                            'Body of FUNCTION',
 3954                            IAPICONSTANT.INFOLEVEL_3 );
 3955       IAPIGENERAL.LOGINFO( GSSOURCE,
 3956                            LSMETHOD,
 3957                               'Status <'
 3958                            || ASSTATUS
 3959                            || '> ; Progress <'
 3960                            || ANPROGRESS
 3961                            || '>',
 3962                            IAPICONSTANT.INFOLEVEL_3 );
 3963 
 3964       IF ( ASSTATUS = 'FINISHED_TEXT' )
 3965       THEN
 3966          UPDATE ITQ
 3967             SET PROGRESS = ANPROGRESS,
 3968                 END_DATE = SYSDATE,
 3969                 STATUS = ASSTATUS
 3970           WHERE USER_ID = ASUSERID;
 3971       ELSE
 3972          UPDATE ITQ
 3973             SET PROGRESS = ANPROGRESS
 3974           WHERE USER_ID = ASUSERID;
 3975       END IF;
 3976 
 3977       
 3978       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 3979    EXCEPTION
 3980       WHEN OTHERS
 3981       THEN
 3982          
 3983          IAPIGENERAL.LOGERROR( GSSOURCE,
 3984                                LSMETHOD,
 3985                                SQLERRM );
 3986          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
 3987    END UPDATEPROGRESS;
 3988 END IAPIMOP;
 