PACKAGE BODY iapiSpecDataServer
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
   16    FUNCTION GETPACKAGEVERSION
   17       RETURN IAPITYPE.STRING_TYPE
   18    IS
   19       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   20    BEGIN
   21       
   22       
   23       
   24        RETURN(    IAPIGENERAL.GETVERSION
   25               || ' ($Revision: 6.7.0.0 (06.07.00.00-01.00) $)' );
   26 
   27    EXCEPTION
   28       WHEN OTHERS
   29       THEN
   30          IAPIGENERAL.LOGERROR( GSSOURCE,
   31                                LSMETHOD,
   32                                SQLERRM );
   33          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   34    END GETPACKAGEVERSION;
   35 
   36    
   37    
   38    
   39    
   40    
   41    
   42    
   43  
   44    PROCEDURE RELEASELOCK  
   45    (ASLOCKNAME       IN        VARCHAR2,
   46     ASLOCKHANDLE     IN        VARCHAR2)
   47    IS   
   48    LNRETURNCODE                   INTEGER;
   49    BEGIN    
   50       
   51       LNRETURNCODE := DBMS_LOCK.RELEASE(ASLOCKHANDLE);
   52       IF LNRETURNCODE = 4 THEN
   53          RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||ASLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
   54       ELSIF LNRETURNCODE <> 0 THEN
   55          RAISE_APPLICATION_ERROR(-20000, 'Release Lock for '||ASLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.RELEASE doc for details)');
   56       END IF; 
   57    END RELEASELOCK;
   58    
   59    
   60    
   61    
   62    FUNCTION INSERTSPECDATACHECK
   63       RETURN IAPITYPE.ERRORNUM_TYPE
   64    IS
   65       CURSOR CUR_SH
   66       IS
   67          SELECT SC.PART_NO,
   68                 SC.REVISION,
   69                 SC.SECTION_ID,
   70                 SC.SUB_SECTION_ID,
   71                 SC.DISPLAY_FORMAT,
   72                 SC.DISPLAY_FORMAT_REV,
   73                 SP.PROPERTY_GROUP,
   74                 SP.PROPERTY,
   75                 SP.ATTRIBUTE,
   76                 LY.HEADER_ID,
   77                 LY.FIELD_ID,
   78                 SP.NUM_1,
   79                 SP.NUM_2,
   80                 SP.NUM_3,
   81                 SP.NUM_4,
   82                 SP.NUM_5,
   83                 SP.NUM_6,
   84                 SP.NUM_7,
   85                 SP.NUM_8,
   86                 SP.NUM_9,
   87                 SP.NUM_10,
   88                 SP.CHAR_1,
   89                 SP.CHAR_2,
   90                 SP.CHAR_3,
   91                 SP.CHAR_4,
   92                 SP.CHAR_5,
   93                 SP.CHAR_6,
   94                 SP.BOOLEAN_1,
   95                 SP.BOOLEAN_2,
   96                 SP.BOOLEAN_3,
   97                 SP.BOOLEAN_4,
   98                 SP.DATE_1,
   99                 SP.DATE_2,
  100                 SP.UOM_ID,
  101                 SP.CHARACTERISTIC,
  102                 SP.ASSOCIATION,
  103                 SP.CH_2,
  104                 SP.CH_3,
  105                 SP.AS_2,
  106                 SP.AS_3
  107            FROM PROPERTY_LAYOUT LY,
  108                 SPECIFICATION_SECTION SC,
  109                 SPECIFICATION_PROP SP
  110           WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
  111             AND LY.REVISION = SC.DISPLAY_FORMAT_REV
  112             AND SC.PART_NO = SP.PART_NO
  113             AND SC.REVISION = SP.REVISION
  114             AND SC.REF_ID = SP.PROPERTY_GROUP
  115             AND SC.SECTION_ID = SP.SECTION_ID
  116             AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
  117             AND SC.TYPE = 1
  118             AND SP.PROPERTY_GROUP <> 0
  119             AND LY.FIELD_ID NOT IN( 23, 24, 25, 27, 32, 33, 34, 35, 40, 41 );
  120 
  121       CURSOR CUR_SH_LANG(
  122          P_PART_NO                           SPECIFICATION_HEADER.PART_NO%TYPE,
  123          P_REVISION                          SPECIFICATION_HEADER.REVISION%TYPE,
  124          P_SECTION                           SPECIFICATION_SECTION.SECTION_ID%TYPE,
  125          P_SUB_SECTION                       SPECIFICATION_SECTION.SUB_SECTION_ID%TYPE,
  126          P_PROPERTY_GROUP                    SPECIFICATION_PROP.PROPERTY_GROUP%TYPE,
  127          P_PROPERTY                          SPECIFICATION_PROP.PROPERTY%TYPE,
  128          P_ATTRIBUTE                         SPECIFICATION_PROP.ATTRIBUTE%TYPE,
  129          P_HEADER_ID                         PROPERTY_LAYOUT.HEADER_ID%TYPE,
  130          P_FIELD_ID                          PROPERTY_LAYOUT.FIELD_ID%TYPE )
  131       IS
  132          SELECT   SP.PART_NO,
  133                   SP.REVISION,
  134                   SP.SECTION_ID,
  135                   SP.SUB_SECTION_ID,
  136                   SP.PROPERTY_GROUP,
  137                   SP.PROPERTY,
  138                   SP.ATTRIBUTE,
  139                   SP.LANG_ID,
  140                   LY.FIELD_ID,
  141                   LY.HEADER_ID,
  142                   SP.CHAR_1,
  143                   SP.CHAR_2,
  144                   SP.CHAR_3,
  145                   SP.CHAR_4,
  146                   SP.CHAR_5,
  147                   SP.CHAR_6
  148              FROM PROPERTY_LAYOUT LY,
  149                   SPECIFICATION_SECTION SC,
  150                   SPECIFICATION_PROP_LANG SP
  151             WHERE SP.PART_NO = P_PART_NO
  152               AND SP.REVISION = P_REVISION
  153               AND SP.SECTION_ID = P_SECTION
  154               AND SP.SUB_SECTION_ID = P_SUB_SECTION
  155               AND SP.PROPERTY_GROUP = P_PROPERTY_GROUP
  156               AND SP.PROPERTY = P_PROPERTY
  157               AND SP.ATTRIBUTE = P_ATTRIBUTE
  158               AND LY.LAYOUT_ID = SC.DISPLAY_FORMAT
  159               AND LY.REVISION = SC.DISPLAY_FORMAT_REV
  160               AND SC.PART_NO = SP.PART_NO
  161               AND SC.REVISION = SP.REVISION
  162               AND SC.REF_ID = SP.PROPERTY_GROUP
  163               AND SC.SECTION_ID = SP.SECTION_ID
  164               AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
  165               AND LY.HEADER_ID = P_HEADER_ID
  166               AND LY.FIELD_ID = P_FIELD_ID
  167          ORDER BY SP.SEQUENCE_NO;
  168 
  169       CURSOR CUR_SH_SP_LANG(
  170          P_PART_NO                           SPECIFICATION_HEADER.PART_NO%TYPE,
  171          P_REVISION                          SPECIFICATION_HEADER.REVISION%TYPE,
  172          P_SECTION                           SPECIFICATION_SECTION.SECTION_ID%TYPE,
  173          P_SUB_SECTION                       SPECIFICATION_SECTION.SUB_SECTION_ID%TYPE,
  174          P_PROPERTY_GROUP                    SPECIFICATION_PROP.PROPERTY_GROUP%TYPE,
  175          P_PROPERTY                          SPECIFICATION_PROP.PROPERTY%TYPE,
  176          P_ATTRIBUTE                         SPECIFICATION_PROP.ATTRIBUTE%TYPE,
  177          P_HEADER_ID                         PROPERTY_LAYOUT.HEADER_ID%TYPE,
  178          P_FIELD_ID                          PROPERTY_LAYOUT.FIELD_ID%TYPE )
  179       IS
  180          SELECT   SP.PART_NO,
  181                   SP.REVISION,
  182                   SP.SECTION_ID,
  183                   SP.SUB_SECTION_ID,
  184                   SP.PROPERTY_GROUP,
  185                   SP.PROPERTY,
  186                   SP.ATTRIBUTE,
  187                   SP.LANG_ID,
  188                   LY.FIELD_ID,
  189                   LY.HEADER_ID,
  190                   SP.CHAR_1,
  191                   SP.CHAR_2,
  192                   SP.CHAR_3,
  193                   SP.CHAR_4,
  194                   SP.CHAR_5,
  195                   SP.CHAR_6
  196              FROM PROPERTY_LAYOUT LY,
  197                   SPECIFICATION_SECTION SC,
  198                   SPECIFICATION_PROP_LANG SP
  199             WHERE SP.PART_NO = P_PART_NO
  200               AND SP.REVISION = P_REVISION
  201               AND SP.SECTION_ID = P_SECTION
  202               AND SP.SUB_SECTION_ID = P_SUB_SECTION
  203               AND SP.PROPERTY_GROUP = P_PROPERTY_GROUP
  204               AND SP.PROPERTY = P_PROPERTY
  205               AND SP.ATTRIBUTE = P_ATTRIBUTE
  206               AND LY.LAYOUT_ID = SC.DISPLAY_FORMAT
  207               AND LY.REVISION = SC.DISPLAY_FORMAT_REV
  208               AND SC.PART_NO = SP.PART_NO
  209               AND SC.REVISION = SP.REVISION
  210               AND SC.REF_ID = SP.PROPERTY
  211               AND SC.SECTION_ID = SP.SECTION_ID
  212               AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
  213               AND LY.HEADER_ID = P_HEADER_ID
  214               AND LY.FIELD_ID = P_FIELD_ID
  215          ORDER BY SP.SEQUENCE_NO;
  216 
  217       
  218       CURSOR CUR_SH_SP
  219       IS
  220          SELECT SC.PART_NO,
  221                 SC.REVISION,
  222                 SC.SECTION_ID,
  223                 SC.SUB_SECTION_ID,
  224                 SP.PROPERTY_GROUP,
  225                 SP.PROPERTY,
  226                 SP.ATTRIBUTE,
  227                 LY.HEADER_ID,
  228                 LY.FIELD_ID,
  229                 SP.NUM_1,
  230                 SP.NUM_2,
  231                 SP.NUM_3,
  232                 SP.NUM_4,
  233                 SP.NUM_5,
  234                 SP.NUM_6,
  235                 SP.NUM_7,
  236                 SP.NUM_8,
  237                 SP.NUM_9,
  238                 SP.NUM_10,
  239                 SP.CHAR_1,
  240                 SP.CHAR_2,
  241                 SP.CHAR_3,
  242                 SP.CHAR_4,
  243                 SP.CHAR_5,
  244                 SP.CHAR_6,
  245                 SP.BOOLEAN_1,
  246                 SP.BOOLEAN_2,
  247                 SP.BOOLEAN_3,
  248                 SP.BOOLEAN_4,
  249                 SP.DATE_1,
  250                 SP.DATE_2,
  251                 SP.UOM_ID,
  252                 SP.CHARACTERISTIC,
  253                 SP.ASSOCIATION,
  254                 SP.CH_2,
  255                 SP.CH_3,
  256                 SP.AS_2,
  257                 SP.AS_3
  258            FROM PROPERTY_LAYOUT LY,
  259                 SPECIFICATION_SECTION SC,
  260                 SPECIFICATION_PROP SP
  261           WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
  262             AND LY.REVISION = SC.DISPLAY_FORMAT_REV
  263             AND SC.PART_NO = SP.PART_NO
  264             AND SC.REVISION = SP.REVISION
  265             AND SC.REF_ID = SP.PROPERTY
  266             AND SC.SECTION_ID = SP.SECTION_ID
  267             AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
  268             AND SC.TYPE = 4
  269             AND SP.PROPERTY_GROUP = 0
  270             AND LY.FIELD_ID NOT IN( 23, 24, 25, 27, 32, 33, 34, 35, 40, 41 );
  271 
  272       CURSOR LQCOUNT(
  273          ASPARTNO                   IN       SPECDATA.PART_NO%TYPE,
  274          ANREVISION                 IN       SPECDATA.REVISION%TYPE,
  275          ANSECTIONID                IN       SPECDATA.SECTION_ID%TYPE,
  276          ANSUBSECTIONID             IN       SPECDATA.SUB_SECTION_ID%TYPE,
  277          ANPROPERTYGROUP            IN       SPECDATA.PROPERTY_GROUP%TYPE,
  278          ANPROPERTY                 IN       SPECDATA.PROPERTY%TYPE,
  279          ANATTRIBUTEID              IN       SPECDATA.ATTRIBUTE%TYPE,
  280          ANHEADERID                 IN       SPECDATA.HEADER_ID%TYPE,
  281          ANLANGID                   IN       SPECDATA.LANG_ID%TYPE )
  282       IS
  283          SELECT VALUE,
  284                 VALUE_S,
  285                 CHARACTERISTIC,
  286                 ASSOCIATION
  287            FROM SPECDATA
  288           WHERE PART_NO = ASPARTNO
  289             AND REVISION = ANREVISION
  290             AND SECTION_ID = ANSECTIONID
  291             AND SUB_SECTION_ID = ANSUBSECTIONID
  292             AND PROPERTY_GROUP = ANPROPERTYGROUP
  293             AND PROPERTY = ANPROPERTY
  294             AND ATTRIBUTE = ANATTRIBUTEID
  295             AND HEADER_ID = ANHEADERID
  296             AND LANG_ID = ANLANGID;
  297 
  298       CURSOR LQCOUNTLANG(
  299          ASPARTNO                   IN       SPECDATA.PART_NO%TYPE,
  300          ANREVISION                 IN       SPECDATA.REVISION%TYPE,
  301          ANSECTIONID                IN       SPECDATA.SECTION_ID%TYPE,
  302          ANSUBSECTIONID             IN       SPECDATA.SUB_SECTION_ID%TYPE,
  303          ANPROPERTYGROUP            IN       SPECDATA.PROPERTY_GROUP%TYPE,
  304          ANPROPERTY                 IN       SPECDATA.PROPERTY%TYPE,
  305          ANATTRIBUTEID              IN       SPECDATA.ATTRIBUTE%TYPE,
  306          ANLANGID                   IN       SPECDATA.LANG_ID%TYPE )
  307       IS
  308          SELECT VALUE,
  309                 VALUE_S,
  310                 CHARACTERISTIC,
  311                 ASSOCIATION
  312            FROM SPECDATA
  313           WHERE PART_NO = ASPARTNO
  314             AND REVISION = ANREVISION
  315             AND SECTION_ID = ANSECTIONID
  316             AND SUB_SECTION_ID = ANSUBSECTIONID
  317             AND PROPERTY_GROUP = ANPROPERTYGROUP
  318             AND PROPERTY = ANPROPERTY
  319             AND LANG_ID = ANLANGID;
  320 
  321       CURSOR LQSPECDATA
  322       IS
  323          SELECT PART_NO,
  324                 REVISION,
  325                 SECTION_ID,
  326                 SUB_SECTION_ID,
  327                 PROPERTY_GROUP,
  328                 PROPERTY,
  329                 ATTRIBUTE,
  330                 HEADER_ID,
  331                 HEADER_REV,
  332                 PROPERTY_REV,
  333                 ATTRIBUTE_REV,
  334                 PROPERTY_GROUP_REV,
  335                 TYPE,
  336                 LANG_ID
  337            FROM SPECDATA
  338           WHERE TYPE IN( 1, 4 )
  339             AND HEADER_ID IS NOT NULL
  340             AND PROPERTY IS NOT NULL
  341             AND ATTRIBUTE IS NOT NULL;
  342 
  343       V_CNT                         NUMBER;
  344       L_COLUMN                      VARCHAR2( 255 );
  345       L_F_COLUMN                    NUMBER;
  346       L_DT_COLUMN                   DATE;
  347       L_CHARACTERISTIC              NUMBER;
  348       L_ASSOCIATION                 NUMBER;
  349       LNCHARSPECDATA                NUMBER;
  350       LNASSSPECDATA                 NUMBER;
  351       LFCOLUMN                      SPECDATA.VALUE%TYPE;
  352       LSCOLUMN                      SPECDATA.VALUE_S%TYPE;
  353       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'InsertSpecDataCheck';
  354    BEGIN
  355       
  356       
  357       
  358       IAPIGENERAL.LOGINFO( GSSOURCE,
  359                            LSMETHOD,
  360                            'Body of FUNCTION',
  361                            IAPICONSTANT.INFOLEVEL_3 );
  362 
  363       
  364       INSERT INTO SPECDATA_CHECK
  365                   ( PART_NO,
  366                     REVISION,
  367                     REASON )
  368            VALUES ( 'Started',
  369                     0,
  370                        'Procedure started on '
  371                     || SYSDATE );
  372 
  373       FOR REC_SH IN CUR_SH
  374       LOOP
  375          OPEN LQCOUNT( REC_SH.PART_NO,
  376                        REC_SH.REVISION,
  377                        REC_SH.SECTION_ID,
  378                        REC_SH.SUB_SECTION_ID,
  379                        REC_SH.PROPERTY_GROUP,
  380                        REC_SH.PROPERTY,
  381                        REC_SH.ATTRIBUTE,
  382                        REC_SH.HEADER_ID,
  383                        1 );
  384 
  385          FETCH LQCOUNT
  386           INTO LFCOLUMN,
  387                LSCOLUMN,
  388                LNCHARSPECDATA,
  389                LNASSSPECDATA;
  390 
  391          IF LQCOUNT%NOTFOUND
  392          THEN
  393             CLOSE LQCOUNT;
  394 
  395             BEGIN
  396                INSERT INTO SPECDATA_CHECK
  397                            ( PART_NO,
  398                              REVISION,
  399                              SECTION_ID,
  400                              SUB_SECTION_ID,
  401                              PROPERTY_GROUP,
  402                              PROPERTY,
  403                              ATTRIBUTE,
  404                              HEADER_ID,
  405                              REASON )
  406                     VALUES ( REC_SH.PART_NO,
  407                              REC_SH.REVISION,
  408                              REC_SH.SECTION_ID,
  409                              REC_SH.SUB_SECTION_ID,
  410                              REC_SH.PROPERTY_GROUP,
  411                              REC_SH.PROPERTY,
  412                              REC_SH.ATTRIBUTE,
  413                              REC_SH.HEADER_ID,
  414                              'Item available in specification but missing in specdata' );
  415             EXCEPTION
  416                WHEN OTHERS
  417                THEN
  418                   DBMS_OUTPUT.PUT_LINE( SQLERRM );
  419             END;
  420 
  421             COMMIT;
  422          ELSIF LQCOUNT%FOUND
  423          THEN
  424             CLOSE LQCOUNT;
  425 
  426             L_COLUMN := NULL;
  427             L_DT_COLUMN := NULL;
  428 
  429             IF REC_SH.FIELD_ID = 1
  430             THEN
  431                L_F_COLUMN := REC_SH.NUM_1;
  432                L_COLUMN := TO_CHAR( L_F_COLUMN );
  433             ELSIF REC_SH.FIELD_ID = 2
  434             THEN
  435                L_F_COLUMN := REC_SH.NUM_2;
  436                L_COLUMN := TO_CHAR( L_F_COLUMN );
  437             ELSIF REC_SH.FIELD_ID = 3
  438             THEN
  439                L_F_COLUMN := REC_SH.NUM_3;
  440                L_COLUMN := TO_CHAR( L_F_COLUMN );
  441             ELSIF REC_SH.FIELD_ID = 4
  442             THEN
  443                L_F_COLUMN := REC_SH.NUM_4;
  444                L_COLUMN := TO_CHAR( L_F_COLUMN );
  445             ELSIF REC_SH.FIELD_ID = 5
  446             THEN
  447                L_F_COLUMN := REC_SH.NUM_5;
  448                L_COLUMN := TO_CHAR( L_F_COLUMN );
  449             ELSIF REC_SH.FIELD_ID = 6
  450             THEN
  451                L_F_COLUMN := REC_SH.NUM_6;
  452                L_COLUMN := TO_CHAR( L_F_COLUMN );
  453             ELSIF REC_SH.FIELD_ID = 7
  454             THEN
  455                L_F_COLUMN := REC_SH.NUM_7;
  456                L_COLUMN := TO_CHAR( L_F_COLUMN );
  457             ELSIF REC_SH.FIELD_ID = 8
  458             THEN
  459                L_F_COLUMN := REC_SH.NUM_8;
  460                L_COLUMN := TO_CHAR( L_F_COLUMN );
  461             ELSIF REC_SH.FIELD_ID = 9
  462             THEN
  463                L_F_COLUMN := REC_SH.NUM_9;
  464                L_COLUMN := TO_CHAR( L_F_COLUMN );
  465             ELSIF REC_SH.FIELD_ID = 10
  466             THEN
  467                L_F_COLUMN := REC_SH.NUM_10;
  468                L_COLUMN := TO_CHAR( L_F_COLUMN );
  469             ELSIF REC_SH.FIELD_ID = 11
  470             THEN
  471                L_F_COLUMN := 0;
  472                L_COLUMN := REC_SH.CHAR_1;
  473             ELSIF REC_SH.FIELD_ID = 12
  474             THEN
  475                L_F_COLUMN := 0;
  476                L_COLUMN := REC_SH.CHAR_2;
  477             ELSIF REC_SH.FIELD_ID = 13
  478             THEN
  479                L_F_COLUMN := 0;
  480                L_COLUMN := REC_SH.CHAR_3;
  481             ELSIF REC_SH.FIELD_ID = 14
  482             THEN
  483                L_F_COLUMN := 0;
  484                L_COLUMN := REC_SH.CHAR_4;
  485             ELSIF REC_SH.FIELD_ID = 15
  486             THEN
  487                L_F_COLUMN := 0;
  488                L_COLUMN := REC_SH.CHAR_5;
  489             ELSIF REC_SH.FIELD_ID = 16
  490             THEN
  491                L_F_COLUMN := 0;
  492                L_COLUMN := REC_SH.CHAR_6;
  493             ELSIF REC_SH.FIELD_ID = 17
  494             THEN
  495                L_F_COLUMN := 0;
  496                L_COLUMN := REC_SH.BOOLEAN_1;
  497 
  498                IF L_COLUMN IS NULL
  499                THEN
  500                   L_COLUMN := 'N';
  501                END IF;
  502             ELSIF REC_SH.FIELD_ID = 18
  503             THEN
  504                L_F_COLUMN := 0;
  505                L_COLUMN := REC_SH.BOOLEAN_2;
  506 
  507                IF L_COLUMN IS NULL
  508                THEN
  509                   L_COLUMN := 'N';
  510                END IF;
  511             ELSIF REC_SH.FIELD_ID = 19
  512             THEN
  513                L_F_COLUMN := 0;
  514                L_COLUMN := REC_SH.BOOLEAN_3;
  515 
  516                IF L_COLUMN IS NULL
  517                THEN
  518                   L_COLUMN := 'N';
  519                END IF;
  520             ELSIF REC_SH.FIELD_ID = 20
  521             THEN
  522                L_F_COLUMN := 0;
  523                L_COLUMN := REC_SH.BOOLEAN_4;
  524 
  525                IF L_COLUMN IS NULL
  526                THEN
  527                   L_COLUMN := 'N';
  528                END IF;
  529             ELSIF REC_SH.FIELD_ID = 21
  530             THEN
  531                L_F_COLUMN := 0;
  532                L_COLUMN := TO_CHAR( REC_SH.DATE_1,
  533                                     'dd-mm-yyyy hh24:mi:ss' );
  534             ELSIF REC_SH.FIELD_ID = 22
  535             THEN
  536                L_F_COLUMN := 0;
  537                L_COLUMN := TO_CHAR( REC_SH.DATE_2,
  538                                     'dd-mm-yyyy hh24:mi:ss' );
  539             ELSIF REC_SH.FIELD_ID = 26
  540             THEN
  541                L_F_COLUMN := REC_SH.CHARACTERISTIC;
  542                L_COLUMN := F_CHH_DESCR( 1,
  543                                         REC_SH.CHARACTERISTIC,
  544                                         0 );
  545             ELSIF REC_SH.FIELD_ID = 30
  546             THEN
  547                L_F_COLUMN := REC_SH.CH_2;
  548                L_COLUMN := F_CHH_DESCR( 1,
  549                                         REC_SH.CH_2,
  550                                         0 );
  551             ELSIF REC_SH.FIELD_ID = 31
  552             THEN
  553                L_F_COLUMN := REC_SH.CH_3;
  554                L_COLUMN := F_CHH_DESCR( 1,
  555                                         REC_SH.CH_3,
  556                                         0 );
  557             END IF;
  558 
  559             
  560             IF NVL( L_COLUMN,
  561                     '@@' ) <> NVL( LSCOLUMN,
  562                                    '@@' )
  563             THEN
  564                BEGIN
  565                   INSERT INTO SPECDATA_CHECK
  566                               ( PART_NO,
  567                                 REVISION,
  568                                 SECTION_ID,
  569                                 SUB_SECTION_ID,
  570                                 PROPERTY_GROUP,
  571                                 PROPERTY,
  572                                 ATTRIBUTE,
  573                                 HEADER_ID,
  574                                 REASON )
  575                        VALUES ( REC_SH.PART_NO,
  576                                 REC_SH.REVISION,
  577                                 REC_SH.SECTION_ID,
  578                                 REC_SH.SUB_SECTION_ID,
  579                                 REC_SH.PROPERTY_GROUP,
  580                                 REC_SH.PROPERTY,
  581                                 REC_SH.ATTRIBUTE,
  582                                 REC_SH.HEADER_ID,
  583                                    'Value <'
  584                                 || L_COLUMN
  585                                 || '> in specification differs from value <'
  586                                 || LSCOLUMN
  587                                 || '> in specdata' );
  588                EXCEPTION
  589                   WHEN OTHERS
  590                   THEN
  591                      DBMS_OUTPUT.PUT_LINE( SQLERRM );
  592                END;
  593 
  594                COMMIT;
  595             END IF;
  596 
  597             
  598             IF REC_SH.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
  599             THEN
  600                FOR REC_SH_LANG IN CUR_SH_LANG( REC_SH.PART_NO,
  601                                                REC_SH.REVISION,
  602                                                REC_SH.SECTION_ID,
  603                                                REC_SH.SUB_SECTION_ID,
  604                                                REC_SH.PROPERTY_GROUP,
  605                                                REC_SH.PROPERTY,
  606                                                REC_SH.ATTRIBUTE,
  607                                                REC_SH.HEADER_ID,
  608                                                REC_SH.FIELD_ID )
  609                LOOP
  610                   OPEN LQCOUNT( REC_SH_LANG.PART_NO,
  611                                 REC_SH_LANG.REVISION,
  612                                 REC_SH_LANG.SECTION_ID,
  613                                 REC_SH_LANG.SUB_SECTION_ID,
  614                                 REC_SH_LANG.PROPERTY_GROUP,
  615                                 REC_SH_LANG.PROPERTY,
  616                                 REC_SH_LANG.ATTRIBUTE,
  617                                 REC_SH.HEADER_ID,
  618                                 REC_SH_LANG.LANG_ID );
  619 
  620                   FETCH LQCOUNT
  621                    INTO LFCOLUMN,
  622                         LSCOLUMN,
  623                         LNCHARSPECDATA,
  624                         LNASSSPECDATA;
  625 
  626                   IF LQCOUNT%NOTFOUND
  627                   THEN
  628                      CLOSE LQCOUNT;
  629 
  630                      BEGIN
  631                         INSERT INTO SPECDATA_CHECK
  632                                     ( PART_NO,
  633                                       REVISION,
  634                                       SECTION_ID,
  635                                       SUB_SECTION_ID,
  636                                       PROPERTY_GROUP,
  637                                       PROPERTY,
  638                                       ATTRIBUTE,
  639                                       HEADER_ID,
  640                                       REASON )
  641                              VALUES ( REC_SH_LANG.PART_NO,
  642                                       REC_SH_LANG.REVISION,
  643                                       REC_SH_LANG.SECTION_ID,
  644                                       REC_SH_LANG.SUB_SECTION_ID,
  645                                       REC_SH_LANG.PROPERTY_GROUP,
  646                                       REC_SH_LANG.PROPERTY,
  647                                       REC_SH_LANG.ATTRIBUTE,
  648                                       REC_SH.HEADER_ID,
  649                                       'Item available in specification but missing in specdata' );
  650                      EXCEPTION
  651                         WHEN OTHERS
  652                         THEN
  653                            DBMS_OUTPUT.PUT_LINE( SQLERRM );
  654                      END;
  655 
  656                      COMMIT;
  657                   ELSIF LQCOUNT%FOUND
  658                   THEN
  659                      CLOSE LQCOUNT;
  660 
  661                      L_COLUMN := NULL;
  662                      L_DT_COLUMN := NULL;
  663 
  664                      IF REC_SH.FIELD_ID = 11
  665                      THEN
  666                         L_F_COLUMN := 0;
  667                         L_COLUMN := REC_SH_LANG.CHAR_1;
  668                      ELSIF REC_SH.FIELD_ID = 12
  669                      THEN
  670                         L_F_COLUMN := 0;
  671                         L_COLUMN := REC_SH_LANG.CHAR_2;
  672                      ELSIF REC_SH.FIELD_ID = 13
  673                      THEN
  674                         L_F_COLUMN := 0;
  675                         L_COLUMN := REC_SH_LANG.CHAR_3;
  676                      ELSIF REC_SH.FIELD_ID = 14
  677                      THEN
  678                         L_F_COLUMN := 0;
  679                         L_COLUMN := REC_SH_LANG.CHAR_4;
  680                      ELSIF REC_SH.FIELD_ID = 15
  681                      THEN
  682                         L_F_COLUMN := 0;
  683                         L_COLUMN := REC_SH_LANG.CHAR_5;
  684                      ELSIF REC_SH.FIELD_ID = 16
  685                      THEN
  686                         L_F_COLUMN := 0;
  687                         L_COLUMN := REC_SH_LANG.CHAR_6;
  688                      END IF;
  689 
  690                      
  691                      IF NVL( L_COLUMN,
  692                              '@@' ) <> NVL( LSCOLUMN,
  693                                             '@@' )
  694                      THEN
  695                         BEGIN
  696                            INSERT INTO SPECDATA_CHECK
  697                                        ( PART_NO,
  698                                          REVISION,
  699                                          SECTION_ID,
  700                                          SUB_SECTION_ID,
  701                                          PROPERTY_GROUP,
  702                                          PROPERTY,
  703                                          ATTRIBUTE,
  704                                          HEADER_ID,
  705                                          REASON )
  706                                 VALUES ( REC_SH_LANG.PART_NO,
  707                                          REC_SH_LANG.REVISION,
  708                                          REC_SH_LANG.SECTION_ID,
  709                                          REC_SH_LANG.SUB_SECTION_ID,
  710                                          REC_SH_LANG.PROPERTY_GROUP,
  711                                          REC_SH_LANG.PROPERTY,
  712                                          REC_SH_LANG.ATTRIBUTE,
  713                                          REC_SH.HEADER_ID,
  714                                             'Value <'
  715                                          || L_COLUMN
  716                                          || '> in specification differs from value <'
  717                                          || LSCOLUMN
  718                                          || '> in specdata' );
  719                         EXCEPTION
  720                            WHEN OTHERS
  721                            THEN
  722                               DBMS_OUTPUT.PUT_LINE( SQLERRM );
  723                         END;
  724 
  725                         COMMIT;
  726                      END IF;
  727                   END IF;
  728                END LOOP;
  729             END IF;
  730          END IF;
  731       END LOOP;
  732 
  733       
  734       FOR REC_SH_SP IN CUR_SH_SP
  735       LOOP
  736          OPEN LQCOUNT( REC_SH_SP.PART_NO,
  737                        REC_SH_SP.REVISION,
  738                        REC_SH_SP.SECTION_ID,
  739                        REC_SH_SP.SUB_SECTION_ID,
  740                        REC_SH_SP.PROPERTY_GROUP,
  741                        REC_SH_SP.PROPERTY,
  742                        REC_SH_SP.ATTRIBUTE,
  743                        REC_SH_SP.HEADER_ID,
  744                        1 );
  745 
  746          FETCH LQCOUNT
  747           INTO LFCOLUMN,
  748                LSCOLUMN,
  749                LNCHARSPECDATA,
  750                LNASSSPECDATA;
  751 
  752          IF LQCOUNT%NOTFOUND
  753          THEN
  754             CLOSE LQCOUNT;
  755 
  756             BEGIN
  757                INSERT INTO SPECDATA_CHECK
  758                            ( PART_NO,
  759                              REVISION,
  760                              SECTION_ID,
  761                              SUB_SECTION_ID,
  762                              PROPERTY_GROUP,
  763                              PROPERTY,
  764                              ATTRIBUTE,
  765                              HEADER_ID,
  766                              REASON )
  767                     VALUES ( REC_SH_SP.PART_NO,
  768                              REC_SH_SP.REVISION,
  769                              REC_SH_SP.SECTION_ID,
  770                              REC_SH_SP.SUB_SECTION_ID,
  771                              REC_SH_SP.PROPERTY_GROUP,
  772                              REC_SH_SP.PROPERTY,
  773                              REC_SH_SP.ATTRIBUTE,
  774                              REC_SH_SP.HEADER_ID,
  775                              'Item available in specification but missing in specdata' );
  776             EXCEPTION
  777                WHEN OTHERS
  778                THEN
  779                   DBMS_OUTPUT.PUT_LINE( SQLERRM );
  780             END;
  781 
  782             COMMIT;
  783          ELSIF LQCOUNT%FOUND
  784          THEN
  785             CLOSE LQCOUNT;
  786 
  787             
  788             L_COLUMN := NULL;
  789             L_DT_COLUMN := NULL;
  790 
  791             IF REC_SH_SP.FIELD_ID = 1
  792             THEN
  793                L_F_COLUMN := REC_SH_SP.NUM_1;
  794                L_COLUMN := TO_CHAR( L_F_COLUMN );
  795             ELSIF REC_SH_SP.FIELD_ID = 2
  796             THEN
  797                L_F_COLUMN := REC_SH_SP.NUM_2;
  798                L_COLUMN := TO_CHAR( L_F_COLUMN );
  799             ELSIF REC_SH_SP.FIELD_ID = 3
  800             THEN
  801                L_F_COLUMN := REC_SH_SP.NUM_3;
  802                L_COLUMN := TO_CHAR( L_F_COLUMN );
  803             ELSIF REC_SH_SP.FIELD_ID = 4
  804             THEN
  805                L_F_COLUMN := REC_SH_SP.NUM_4;
  806                L_COLUMN := TO_CHAR( L_F_COLUMN );
  807             ELSIF REC_SH_SP.FIELD_ID = 5
  808             THEN
  809                L_F_COLUMN := REC_SH_SP.NUM_5;
  810                L_COLUMN := TO_CHAR( L_F_COLUMN );
  811             ELSIF REC_SH_SP.FIELD_ID = 6
  812             THEN
  813                L_F_COLUMN := REC_SH_SP.NUM_6;
  814                L_COLUMN := TO_CHAR( L_F_COLUMN );
  815             ELSIF REC_SH_SP.FIELD_ID = 7
  816             THEN
  817                L_F_COLUMN := REC_SH_SP.NUM_7;
  818                L_COLUMN := TO_CHAR( L_F_COLUMN );
  819             ELSIF REC_SH_SP.FIELD_ID = 8
  820             THEN
  821                L_F_COLUMN := REC_SH_SP.NUM_8;
  822                L_COLUMN := TO_CHAR( L_F_COLUMN );
  823             ELSIF REC_SH_SP.FIELD_ID = 9
  824             THEN
  825                L_F_COLUMN := REC_SH_SP.NUM_9;
  826                L_COLUMN := TO_CHAR( L_F_COLUMN );
  827             ELSIF REC_SH_SP.FIELD_ID = 10
  828             THEN
  829                L_F_COLUMN := REC_SH_SP.NUM_10;
  830                L_COLUMN := TO_CHAR( L_F_COLUMN );
  831             ELSIF REC_SH_SP.FIELD_ID = 11
  832             THEN
  833                L_F_COLUMN := 0;
  834                L_COLUMN := REC_SH_SP.CHAR_1;
  835             ELSIF REC_SH_SP.FIELD_ID = 12
  836             THEN
  837                L_F_COLUMN := 0;
  838                L_COLUMN := REC_SH_SP.CHAR_2;
  839             ELSIF REC_SH_SP.FIELD_ID = 13
  840             THEN
  841                L_F_COLUMN := 0;
  842                L_COLUMN := REC_SH_SP.CHAR_3;
  843             ELSIF REC_SH_SP.FIELD_ID = 14
  844             THEN
  845                L_F_COLUMN := 0;
  846                L_COLUMN := REC_SH_SP.CHAR_4;
  847             ELSIF REC_SH_SP.FIELD_ID = 15
  848             THEN
  849                L_F_COLUMN := 0;
  850                L_COLUMN := REC_SH_SP.CHAR_5;
  851             ELSIF REC_SH_SP.FIELD_ID = 16
  852             THEN
  853                L_F_COLUMN := 0;
  854                L_COLUMN := REC_SH_SP.CHAR_6;
  855             ELSIF REC_SH_SP.FIELD_ID = 17
  856             THEN
  857                L_F_COLUMN := 0;
  858                L_COLUMN := REC_SH_SP.BOOLEAN_1;
  859 
  860                IF L_COLUMN IS NULL
  861                THEN
  862                   L_COLUMN := 'N';
  863                END IF;
  864             ELSIF REC_SH_SP.FIELD_ID = 18
  865             THEN
  866                L_F_COLUMN := 0;
  867                L_COLUMN := REC_SH_SP.BOOLEAN_2;
  868 
  869                IF L_COLUMN IS NULL
  870                THEN
  871                   L_COLUMN := 'N';
  872                END IF;
  873             ELSIF REC_SH_SP.FIELD_ID = 19
  874             THEN
  875                L_F_COLUMN := 0;
  876                L_COLUMN := REC_SH_SP.BOOLEAN_3;
  877 
  878                IF L_COLUMN IS NULL
  879                THEN
  880                   L_COLUMN := 'N';
  881                END IF;
  882             ELSIF REC_SH_SP.FIELD_ID = 20
  883             THEN
  884                L_F_COLUMN := 0;
  885                L_COLUMN := REC_SH_SP.BOOLEAN_4;
  886 
  887                IF L_COLUMN IS NULL
  888                THEN
  889                   L_COLUMN := 'N';
  890                END IF;
  891             ELSIF REC_SH_SP.FIELD_ID = 21
  892             THEN
  893                L_F_COLUMN := 0;
  894                L_COLUMN := TO_CHAR( REC_SH_SP.DATE_1,
  895                                     'dd-mm-yyyy hh24:mi:ss' );
  896             ELSIF REC_SH_SP.FIELD_ID = 22
  897             THEN
  898                L_F_COLUMN := 0;
  899                L_COLUMN := TO_CHAR( REC_SH_SP.DATE_2,
  900                                     'dd-mm-yyyy hh24:mi:ss' );
  901             ELSIF REC_SH_SP.FIELD_ID = 26
  902             THEN
  903                L_F_COLUMN := REC_SH_SP.CHARACTERISTIC;
  904                L_COLUMN := F_CHH_DESCR( 1,
  905                                         REC_SH_SP.CHARACTERISTIC,
  906                                         0 );
  907             ELSIF REC_SH_SP.FIELD_ID = 30
  908             THEN
  909                L_F_COLUMN := REC_SH_SP.CH_2;
  910                L_COLUMN := F_CHH_DESCR( 1,
  911                                         REC_SH_SP.CH_2,
  912                                         0 );
  913             ELSIF REC_SH_SP.FIELD_ID = 31
  914             THEN
  915                L_F_COLUMN := REC_SH_SP.CH_3;
  916                L_COLUMN := F_CHH_DESCR( 1,
  917                                         REC_SH_SP.CH_3,
  918                                         0 );
  919             END IF;
  920 
  921             
  922             IF NVL( L_COLUMN,
  923                     '@@' ) <> NVL( LSCOLUMN,
  924                                    '@@' )
  925             THEN
  926                BEGIN
  927                   INSERT INTO SPECDATA_CHECK
  928                               ( PART_NO,
  929                                 REVISION,
  930                                 SECTION_ID,
  931                                 SUB_SECTION_ID,
  932                                 PROPERTY_GROUP,
  933                                 PROPERTY,
  934                                 ATTRIBUTE,
  935                                 HEADER_ID,
  936                                 REASON )
  937                        VALUES ( REC_SH_SP.PART_NO,
  938                                 REC_SH_SP.REVISION,
  939                                 REC_SH_SP.SECTION_ID,
  940                                 REC_SH_SP.SUB_SECTION_ID,
  941                                 REC_SH_SP.PROPERTY_GROUP,
  942                                 REC_SH_SP.PROPERTY,
  943                                 REC_SH_SP.ATTRIBUTE,
  944                                 REC_SH_SP.HEADER_ID,
  945                                    'Value <'
  946                                 || L_COLUMN
  947                                 || '> in specification differs from value <'
  948                                 || LSCOLUMN
  949                                 || '> in specdata' );
  950                EXCEPTION
  951                   WHEN OTHERS
  952                   THEN
  953                      DBMS_OUTPUT.PUT_LINE( SQLERRM );
  954                END;
  955 
  956                COMMIT;
  957             END IF;
  958 
  959             
  960             IF REC_SH_SP.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
  961             THEN
  962                FOR REC_SH_SP_LANG IN CUR_SH_SP_LANG( REC_SH_SP.PART_NO,
  963                                                      REC_SH_SP.REVISION,
  964                                                      REC_SH_SP.SECTION_ID,
  965                                                      REC_SH_SP.SUB_SECTION_ID,
  966                                                      REC_SH_SP.PROPERTY_GROUP,
  967                                                      REC_SH_SP.PROPERTY,
  968                                                      REC_SH_SP.ATTRIBUTE,
  969                                                      REC_SH_SP.HEADER_ID,
  970                                                      REC_SH_SP.FIELD_ID )
  971                LOOP
  972                   OPEN LQCOUNT( REC_SH_SP_LANG.PART_NO,
  973                                 REC_SH_SP_LANG.REVISION,
  974                                 REC_SH_SP_LANG.SECTION_ID,
  975                                 REC_SH_SP_LANG.SUB_SECTION_ID,
  976                                 REC_SH_SP_LANG.PROPERTY_GROUP,
  977                                 REC_SH_SP_LANG.PROPERTY,
  978                                 REC_SH_SP_LANG.ATTRIBUTE,
  979                                 REC_SH_SP.HEADER_ID,
  980                                 REC_SH_SP_LANG.LANG_ID );
  981 
  982                   FETCH LQCOUNT
  983                    INTO LFCOLUMN,
  984                         LSCOLUMN,
  985                         LNCHARSPECDATA,
  986                         LNASSSPECDATA;
  987 
  988                   IF LQCOUNT%NOTFOUND
  989                   THEN
  990                      CLOSE LQCOUNT;
  991 
  992                      BEGIN
  993                         INSERT INTO SPECDATA_CHECK
  994                                     ( PART_NO,
  995                                       REVISION,
  996                                       SECTION_ID,
  997                                       SUB_SECTION_ID,
  998                                       PROPERTY_GROUP,
  999                                       PROPERTY,
 1000                                       ATTRIBUTE,
 1001                                       HEADER_ID,
 1002                                       REASON )
 1003                              VALUES ( REC_SH_SP_LANG.PART_NO,
 1004                                       REC_SH_SP_LANG.REVISION,
 1005                                       REC_SH_SP_LANG.SECTION_ID,
 1006                                       REC_SH_SP_LANG.SUB_SECTION_ID,
 1007                                       REC_SH_SP_LANG.PROPERTY_GROUP,
 1008                                       REC_SH_SP_LANG.PROPERTY,
 1009                                       REC_SH_SP_LANG.ATTRIBUTE,
 1010                                       REC_SH_SP.HEADER_ID,
 1011                                       'Item available in specification but missing in specdata' );
 1012                      EXCEPTION
 1013                         WHEN OTHERS
 1014                         THEN
 1015                            DBMS_OUTPUT.PUT_LINE( SQLERRM );
 1016                      END;
 1017 
 1018                      COMMIT;
 1019                   ELSIF LQCOUNT%FOUND
 1020                   THEN
 1021                      CLOSE LQCOUNT;
 1022 
 1023                      L_COLUMN := NULL;
 1024                      
 1025                      L_DT_COLUMN := NULL;
 1026 
 1027                      IF REC_SH_SP.FIELD_ID = 11
 1028                      THEN
 1029                         L_F_COLUMN := 0;
 1030                         L_COLUMN := REC_SH_SP_LANG.CHAR_1;
 1031                      ELSIF REC_SH_SP.FIELD_ID = 12
 1032                      THEN
 1033                         L_F_COLUMN := 0;
 1034                         L_COLUMN := REC_SH_SP_LANG.CHAR_2;
 1035                      ELSIF REC_SH_SP.FIELD_ID = 13
 1036                      THEN
 1037                         L_F_COLUMN := 0;
 1038                         L_COLUMN := REC_SH_SP_LANG.CHAR_3;
 1039                      ELSIF REC_SH_SP.FIELD_ID = 14
 1040                      THEN
 1041                         L_F_COLUMN := 0;
 1042                         L_COLUMN := REC_SH_SP_LANG.CHAR_4;
 1043                      ELSIF REC_SH_SP.FIELD_ID = 15
 1044                      THEN
 1045                         L_F_COLUMN := 0;
 1046                         L_COLUMN := REC_SH_SP_LANG.CHAR_5;
 1047                      ELSIF REC_SH_SP.FIELD_ID = 16
 1048                      THEN
 1049                         L_F_COLUMN := 0;
 1050                         L_COLUMN := REC_SH_SP_LANG.CHAR_6;
 1051                      END IF;
 1052 
 1053                      
 1054                      IF NVL( L_COLUMN,
 1055                              '@@' ) <> NVL( LSCOLUMN,
 1056                                             '@@' )
 1057                      THEN
 1058                         BEGIN
 1059                            INSERT INTO SPECDATA_CHECK
 1060                                        ( PART_NO,
 1061                                          REVISION,
 1062                                          SECTION_ID,
 1063                                          SUB_SECTION_ID,
 1064                                          PROPERTY_GROUP,
 1065                                          PROPERTY,
 1066                                          ATTRIBUTE,
 1067                                          HEADER_ID,
 1068                                          REASON )
 1069                                 VALUES ( REC_SH_SP_LANG.PART_NO,
 1070                                          REC_SH_SP_LANG.REVISION,
 1071                                          REC_SH_SP_LANG.SECTION_ID,
 1072                                          REC_SH_SP_LANG.SUB_SECTION_ID,
 1073                                          REC_SH_SP_LANG.PROPERTY_GROUP,
 1074                                          REC_SH_SP_LANG.PROPERTY,
 1075                                          REC_SH_SP_LANG.ATTRIBUTE,
 1076                                          REC_SH_SP.HEADER_ID,
 1077                                             'Value <'
 1078                                          || L_COLUMN
 1079                                          || '> in specification differs from value <'
 1080                                          || LSCOLUMN
 1081                                          || '> in specdata' );
 1082                         EXCEPTION
 1083                            WHEN OTHERS
 1084                            THEN
 1085                               DBMS_OUTPUT.PUT_LINE( SQLERRM );
 1086                         END;
 1087 
 1088                         COMMIT;
 1089                      END IF;
 1090                   END IF;
 1091                END LOOP;
 1092             END IF;
 1093          END IF;
 1094       END LOOP;
 1095 
 1096       
 1097       FOR LRSPECDATA IN LQSPECDATA
 1098       LOOP
 1099          IF LRSPECDATA.TYPE = 1
 1100          THEN
 1101             IF LRSPECDATA.LANG_ID = 1
 1102             THEN
 1103                SELECT COUNT( * )
 1104                  INTO V_CNT
 1105                  FROM PROPERTY_LAYOUT LY,
 1106                       SPECIFICATION_SECTION SC,
 1107                       SPECIFICATION_PROP SP
 1108                 WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
 1109                   AND LY.REVISION = SC.DISPLAY_FORMAT_REV
 1110                   AND SC.PART_NO = SP.PART_NO
 1111                   AND SC.REVISION = SP.REVISION
 1112                   AND SC.REF_ID = SP.PROPERTY_GROUP
 1113                   AND SC.SECTION_ID = SP.SECTION_ID
 1114                   AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
 1115                   AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
 1116                   AND SC.PART_NO = LRSPECDATA.PART_NO
 1117                   AND SC.REVISION = LRSPECDATA.REVISION
 1118                   AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
 1119                   AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
 1120                   AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
 1121                   AND SP.PROPERTY_GROUP_REV = LRSPECDATA.PROPERTY_GROUP_REV
 1122                   AND SP.PROPERTY = LRSPECDATA.PROPERTY
 1123                   AND SP.PROPERTY_REV = LRSPECDATA.PROPERTY_REV
 1124                   AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE
 1125                   AND SP.ATTRIBUTE_REV = LRSPECDATA.ATTRIBUTE_REV;
 1126             ELSE
 1127                SELECT COUNT( * )
 1128                  INTO V_CNT
 1129                  FROM PROPERTY_LAYOUT LY,
 1130                       SPECIFICATION_SECTION SC,
 1131                       SPECIFICATION_PROP_LANG SP
 1132                 WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
 1133                   AND LY.REVISION = SC.DISPLAY_FORMAT_REV
 1134                   AND SC.PART_NO = SP.PART_NO
 1135                   AND SC.REVISION = SP.REVISION
 1136                   AND SC.REF_ID = SP.PROPERTY_GROUP
 1137                   AND SC.SECTION_ID = SP.SECTION_ID
 1138                   AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
 1139                   AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
 1140                   AND SC.PART_NO = LRSPECDATA.PART_NO
 1141                   AND SC.REVISION = LRSPECDATA.REVISION
 1142                   AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
 1143                   AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
 1144                   AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
 1145                   AND SP.PROPERTY = LRSPECDATA.PROPERTY
 1146                   AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE;
 1147             END IF;
 1148          ELSIF LRSPECDATA.TYPE = 4
 1149          THEN
 1150             IF LRSPECDATA.LANG_ID = 1
 1151             THEN
 1152                SELECT COUNT( * )
 1153                  INTO V_CNT
 1154                  FROM PROPERTY_LAYOUT LY,
 1155                       SPECIFICATION_SECTION SC,
 1156                       SPECIFICATION_PROP SP
 1157                 WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
 1158                   AND LY.REVISION = SC.DISPLAY_FORMAT_REV
 1159                   AND SC.PART_NO = SP.PART_NO
 1160                   AND SC.REVISION = SP.REVISION
 1161                   AND SC.REF_ID = SP.PROPERTY
 1162                   AND SC.SECTION_ID = SP.SECTION_ID
 1163                   AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
 1164                   AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
 1165                   AND SC.PART_NO = LRSPECDATA.PART_NO
 1166                   AND SC.REVISION = LRSPECDATA.REVISION
 1167                   AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
 1168                   AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
 1169                   AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
 1170                   AND SP.PROPERTY_GROUP_REV = LRSPECDATA.PROPERTY_GROUP_REV
 1171                   AND SP.PROPERTY = LRSPECDATA.PROPERTY
 1172                   AND SP.PROPERTY_REV = LRSPECDATA.PROPERTY_REV
 1173                   AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE
 1174                   AND SP.ATTRIBUTE_REV = LRSPECDATA.ATTRIBUTE_REV;
 1175             ELSE
 1176                SELECT COUNT( * )
 1177                  INTO V_CNT
 1178                  FROM PROPERTY_LAYOUT LY,
 1179                       SPECIFICATION_SECTION SC,
 1180                       SPECIFICATION_PROP_LANG SP
 1181                 WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
 1182                   AND LY.REVISION = SC.DISPLAY_FORMAT_REV
 1183                   AND SC.PART_NO = SP.PART_NO
 1184                   AND SC.REVISION = SP.REVISION
 1185                   AND SC.REF_ID = SP.PROPERTY
 1186                   AND SC.SECTION_ID = SP.SECTION_ID
 1187                   AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
 1188                   AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
 1189                   AND SC.PART_NO = LRSPECDATA.PART_NO
 1190                   AND SC.REVISION = LRSPECDATA.REVISION
 1191                   AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
 1192                   AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
 1193                   AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
 1194                   AND SP.PROPERTY = LRSPECDATA.PROPERTY
 1195                   AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE;
 1196             END IF;
 1197          END IF;
 1198 
 1199          IF V_CNT = 0
 1200          THEN
 1201             BEGIN
 1202                INSERT INTO SPECDATA_CHECK
 1203                            ( PART_NO,
 1204                              REVISION,
 1205                              SECTION_ID,
 1206                              SUB_SECTION_ID,
 1207                              PROPERTY_GROUP,
 1208                              PROPERTY,
 1209                              ATTRIBUTE,
 1210                              HEADER_ID,
 1211                              REASON )
 1212                     VALUES ( LRSPECDATA.PART_NO,
 1213                              LRSPECDATA.REVISION,
 1214                              LRSPECDATA.SECTION_ID,
 1215                              LRSPECDATA.SUB_SECTION_ID,
 1216                              LRSPECDATA.PROPERTY_GROUP,
 1217                              LRSPECDATA.PROPERTY,
 1218                              LRSPECDATA.ATTRIBUTE,
 1219                              LRSPECDATA.HEADER_ID,
 1220                              'Item available in specdata but missing in specification' );
 1221             EXCEPTION
 1222                WHEN OTHERS
 1223                THEN
 1224                   DBMS_OUTPUT.PUT_LINE( SQLERRM );
 1225             END;
 1226 
 1227             COMMIT;
 1228          END IF;
 1229       END LOOP;
 1230 
 1231       
 1232       INSERT INTO SPECDATA_CHECK
 1233                   ( PART_NO,
 1234                     REVISION,
 1235                     REASON )
 1236            VALUES ( 'Finished',
 1237                     0,
 1238                        'Procedure finished on '
 1239                     || SYSDATE );
 1240 
 1241       COMMIT;
 1242       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 1243    EXCEPTION
 1244       WHEN OTHERS
 1245       THEN
 1246          DBMS_OUTPUT.PUT_LINE( SQLERRM );
 1247    END INSERTSPECDATACHECK;
 1248 
 1249    
 1250    PROCEDURE CONVERTSPECIFICATION(
 1251       ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
 1252       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 1253       ANSECTIONID                IN       IAPITYPE.ID_TYPE,
 1254       ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
 1255    IS
 1256       
 1257       
 1258       
 1259       
 1260       
 1261       
 1262       
 1263       
 1264       
 1265       
 1266       LSCOLUMN                      VARCHAR2( 256 );
 1267       LNFLOATCOLUMN                 NUMBER;
 1268       LDDATECOLUMN                  DATE;
 1269       LNCHARACTERISTICID            IAPITYPE.ID_TYPE;
 1270       LNASSOCIATIONID               IAPITYPE.ID_TYPE;
 1271       LNRESULT                      INTEGER;
 1272       LNVALUETYPE                   SPECDATA.VALUE_TYPE%TYPE;
 1273       LNCOUNTER                     NUMBER;
 1274       LNCOUNTSTAGES                 NUMBER;
 1275       LBDATA                        BOOLEAN;
 1276       LNUOMTYPE                     SPECIFICATION_HEADER.UOM_TYPE%TYPE;
 1277       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ConvertSpecification';
 1278 
 1279       CURSOR CUR_SECTION(
 1280          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1281          P_REVISION                          IAPITYPE.REVISION_TYPE,
 1282          P_SC                                IAPITYPE.ID_TYPE,
 1283          P_SB                                IAPITYPE.ID_TYPE )
 1284       IS
 1285          SELECT   *
 1286              FROM SPECIFICATION_SECTION
 1287             WHERE PART_NO = P_PART_NO
 1288               AND REVISION = P_REVISION
 1289               AND SECTION_ID = DECODE( P_SC,
 1290                                        NULL, SECTION_ID,
 1291                                        P_SC )
 1292               AND SUB_SECTION_ID = DECODE( P_SB,
 1293                                            NULL, SUB_SECTION_ID,
 1294                                            P_SB )
 1295          ORDER BY SECTION_SEQUENCE_NO;
 1296 
 1297 
 1298       CURSOR CUR_LAYOUT(
 1299          P_LAYOUT_ID                         IAPITYPE.ID_TYPE,
 1300          P_LAYOUT_REV                        IAPITYPE.REVISION_TYPE )
 1301       IS
 1302          SELECT *
 1303            FROM PROPERTY_LAYOUT
 1304           WHERE LAYOUT_ID = P_LAYOUT_ID
 1305             AND REVISION = P_LAYOUT_REV;
 1306 
 1307       CURSOR CUR_LAYOUT_PROCESS(
 1308          P_LAYOUT_ID                         IAPITYPE.ID_TYPE )
 1309       IS
 1310          SELECT *
 1311            FROM PROPERTY_LAYOUT B
 1312           WHERE B.LAYOUT_ID = P_LAYOUT_ID
 1313             AND B.REVISION = ( SELECT MAX( A.REVISION )
 1314                                 FROM PROPERTY_LAYOUT A
 1315                                WHERE A.LAYOUT_ID = B.LAYOUT_ID );
 1316 
 1317 
 1318       CURSOR CUR_PG(
 1319          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1320          P_REVISION                          IAPITYPE.ID_TYPE,
 1321          P_SECTION                           IAPITYPE.REVISION_TYPE,
 1322          P_SUB_SECTION                       IAPITYPE.ID_TYPE,
 1323          P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE )
 1324       IS
 1325          SELECT   *
 1326              FROM SPECIFICATION_PROP
 1327             WHERE PART_NO = P_PART_NO
 1328               AND REVISION = P_REVISION
 1329               AND SECTION_ID = P_SECTION
 1330               AND SUB_SECTION_ID = P_SUB_SECTION
 1331               AND PROPERTY_GROUP = P_PROPERTY_GROUP
 1332          ORDER BY SEQUENCE_NO;
 1333 
 1334 
 1335       CURSOR CUR_SP(
 1336          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1337          P_REVISION                          IAPITYPE.REVISION_TYPE,
 1338          P_SECTION                           IAPITYPE.ID_TYPE,
 1339          P_SUB_SECTION                       IAPITYPE.ID_TYPE,
 1340          P_PROPERTY                          IAPITYPE.ID_TYPE )
 1341       IS
 1342          SELECT   *
 1343              FROM SPECIFICATION_PROP
 1344             WHERE PART_NO = P_PART_NO
 1345               AND REVISION = P_REVISION
 1346               AND SECTION_ID = P_SECTION
 1347               AND SUB_SECTION_ID = P_SUB_SECTION
 1348               AND PROPERTY_GROUP = 0
 1349               AND PROPERTY = P_PROPERTY
 1350          ORDER BY SEQUENCE_NO;
 1351 
 1352 
 1353       CURSOR CUR_PG_LANG(
 1354          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1355          P_REVISION                          IAPITYPE.REVISION_TYPE,
 1356          P_SECTION                           IAPITYPE.ID_TYPE,
 1357          P_SUB_SECTION                       IAPITYPE.ID_TYPE,
 1358          P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE,
 1359          P_PROPERTY                          IAPITYPE.ID_TYPE,
 1360          P_ATTRIBUTE                         IAPITYPE.ID_TYPE )
 1361       IS
 1362          SELECT   *
 1363              FROM SPECIFICATION_PROP_LANG
 1364             WHERE PART_NO = P_PART_NO
 1365               AND REVISION = P_REVISION
 1366               AND SECTION_ID = P_SECTION
 1367               AND SUB_SECTION_ID = P_SUB_SECTION
 1368               AND PROPERTY_GROUP = P_PROPERTY_GROUP
 1369               AND PROPERTY = P_PROPERTY
 1370               AND ATTRIBUTE = P_ATTRIBUTE
 1371          ORDER BY SEQUENCE_NO;
 1372 
 1373 
 1374       CURSOR CUR_SP_LANG(
 1375          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1376          P_REVISION                          IAPITYPE.REVISION_TYPE,
 1377          P_SECTION                           IAPITYPE.ID_TYPE,
 1378          P_SUB_SECTION                       IAPITYPE.ID_TYPE,
 1379          P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE,
 1380          P_PROPERTY                          IAPITYPE.ID_TYPE,
 1381          P_ATTRIBUTE                         IAPITYPE.ID_TYPE )
 1382       IS
 1383          SELECT   *
 1384              FROM SPECIFICATION_PROP_LANG
 1385             WHERE PART_NO = P_PART_NO
 1386               AND REVISION = P_REVISION
 1387               AND SECTION_ID = P_SECTION
 1388               AND SUB_SECTION_ID = P_SUB_SECTION
 1389               AND PROPERTY_GROUP = 0
 1390               AND PROPERTY = P_PROPERTY
 1391               AND ATTRIBUTE = P_ATTRIBUTE
 1392          ORDER BY SEQUENCE_NO;
 1393 
 1394 
 1395 
 1396       CURSOR CUR_PROCESS(
 1397          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1398          P_REVISION                          IAPITYPE.REVISION_TYPE )
 1399       IS
 1400          SELECT *
 1401            FROM SPECIFICATION_LINE
 1402           WHERE PART_NO = P_PART_NO
 1403             AND REVISION = P_REVISION;
 1404 
 1405       CURSOR CUR_STAGE(
 1406          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1407          P_REVISION                          IAPITYPE.REVISION_TYPE,
 1408          P_PLANT                             IAPITYPE.PLANTNO_TYPE,
 1409          P_LINE                              IAPITYPE.LINE_TYPE,
 1410          P_CONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE,
 1411          P_PROCESS_LINE_REV                  IAPITYPE.REVISION_TYPE )
 1412       IS
 1413          SELECT   *
 1414              FROM SPECIFICATION_STAGE
 1415             WHERE PART_NO = P_PART_NO
 1416               AND REVISION = P_REVISION
 1417               AND PLANT = P_PLANT
 1418               AND LINE = P_LINE
 1419               AND CONFIGURATION = P_CONFIGURATION
 1420               AND PROCESS_LINE_REV IN( 0, 1 )
 1421          ORDER BY SEQUENCE_NO;
 1422 
 1423       CURSOR CUR_STAGE_PROP(
 1424          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1425          P_REVISION                          IAPITYPE.REVISION_TYPE,
 1426          P_PLANT                             IAPITYPE.PLANTNO_TYPE,
 1427          P_LINE                              IAPITYPE.LINE_TYPE,
 1428          P_CONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE,
 1429          P_PROCESS_LINE_REV                  IAPITYPE.REVISION_TYPE,
 1430          P_SECTION                           IAPITYPE.ID_TYPE,
 1431          P_SUB_SECTION                       IAPITYPE.ID_TYPE,
 1432          P_STAGE                             IAPITYPE.ID_TYPE )
 1433       IS
 1434          SELECT   *
 1435              FROM SPECIFICATION_LINE_PROP
 1436             WHERE PART_NO = P_PART_NO
 1437               AND REVISION = P_REVISION
 1438               AND PLANT = P_PLANT
 1439               AND LINE = P_LINE
 1440               AND CONFIGURATION = P_CONFIGURATION
 1441               AND PROCESS_LINE_REV = P_PROCESS_LINE_REV
 1442               AND STAGE = P_STAGE
 1443          ORDER BY SEQUENCE_NO;
 1444 
 1445 
 1446       CURSOR CUR_STAGE_PROP_LANG(
 1447          P_PART_NO                           IAPITYPE.PARTNO_TYPE,
 1448          P_REVISION                          IAPITYPE.REVISION_TYPE,
 1449          P_PLANT                             IAPITYPE.PLANTNO_TYPE,
 1450          P_LINE                              IAPITYPE.LINE_TYPE,
 1451          P_CONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE,
 1452          P_STAGE                             IAPITYPE.ID_TYPE,
 1453          P_PROPERTY                          IAPITYPE.ID_TYPE,
 1454          P_ATTRIBUTE                         IAPITYPE.ID_TYPE,
 1455          P_SEQUENCE                          IAPITYPE.SEQUENCE_TYPE )
 1456       IS
 1457          SELECT   *
 1458              FROM ITSHLNPROPLANG
 1459             WHERE PART_NO = P_PART_NO
 1460               AND REVISION = P_REVISION
 1461               AND PLANT = P_PLANT
 1462               AND LINE = P_LINE
 1463               AND CONFIGURATION = P_CONFIGURATION
 1464               AND PROPERTY = P_PROPERTY
 1465               AND ATTRIBUTE = P_ATTRIBUTE
 1466               AND SEQUENCE_NO = P_SEQUENCE
 1467          ORDER BY SEQUENCE_NO;
 1468 
 1469 
 1470       CURSOR CUR_BOOLEAN
 1471       IS
 1472          SELECT *
 1473            FROM SPECIFICATION_SECTION
 1474           WHERE PART_NO = ASPARTNO
 1475             AND REVISION = ANREVISION
 1476             AND TYPE IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY );
 1477    BEGIN
 1478       
 1479       
 1480       
 1481       IAPIGENERAL.LOGINFO( GSSOURCE,
 1482                            LSMETHOD,
 1483                            'Body of FUNCTION',
 1484                            IAPICONSTANT.INFOLEVEL_3 );
 1485 
 1486 
 1487       BEGIN
 1488          SELECT UOM_TYPE
 1489            INTO LNUOMTYPE
 1490            FROM SPECIFICATION_HEADER
 1491           WHERE PART_NO = ASPARTNO
 1492             AND REVISION = ANREVISION;
 1493       EXCEPTION
 1494          WHEN OTHERS
 1495          THEN
 1496             LNUOMTYPE := 0;
 1497       END;
 1498 
 1499       LNCOUNTER := 1;
 1500 
 1501       BEGIN
 1502          IF ANSECTIONID IS NULL
 1503          THEN
 1504 
 1505             DELETE FROM SPECDATA
 1506                   WHERE PART_NO = ASPARTNO
 1507                     AND REVISION = ANREVISION;
 1508 
 1509             DELETE FROM SPECDATA_PROCESS
 1510                   WHERE PART_NO = ASPARTNO
 1511                     AND REVISION = ANREVISION;
 1512          ELSE
 1513 
 1514             DELETE FROM SPECDATA
 1515                   WHERE PART_NO = ASPARTNO
 1516                     AND REVISION = ANREVISION
 1517                     AND SECTION_ID = ANSECTIONID
 1518                     AND SUB_SECTION_ID = ANSUBSECTIONID;
 1519 
 1520             DELETE FROM SPECDATA_PROCESS
 1521                   WHERE PART_NO = ASPARTNO
 1522                     AND REVISION = ANREVISION
 1523                     AND SECTION_ID = ANSECTIONID
 1524                     AND SUB_SECTION_ID = ANSUBSECTIONID;
 1525          END IF;
 1526       EXCEPTION
 1527          WHEN OTHERS
 1528          THEN
 1529             IAPIGENERAL.LOGERROR( GSSOURCE,
 1530                                   LSMETHOD,
 1531                                   SQLERRM );
 1532             RAISE_APPLICATION_ERROR( -20000,
 1533                                      SQLERRM );
 1534       END;
 1535 
 1536 
 1537       FOR REC_SECTION IN CUR_SECTION( ASPARTNO,
 1538                                       ANREVISION,
 1539                                       ANSECTIONID,
 1540                                       ANSUBSECTIONID )
 1541       LOOP
 1542          LBDATA := FALSE;
 1543 
 1544 
 1545          IF REC_SECTION.TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
 1546          THEN   
 1547             FOR REC_PG IN CUR_PG( ASPARTNO,
 1548                                   ANREVISION,
 1549                                   REC_SECTION.SECTION_ID,
 1550                                   REC_SECTION.SUB_SECTION_ID,
 1551                                   REC_SECTION.REF_ID )
 1552             LOOP
 1553                LBDATA := TRUE;
 1554 
 1555                FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
 1556                                              REC_SECTION.DISPLAY_FORMAT_REV )
 1557                LOOP
 1558 
 1559                   LSCOLUMN := '';
 1560                   LDDATECOLUMN := NULL;
 1561 
 1562                   IF REC_LAYOUT.FIELD_ID = 1
 1563                   THEN
 1564                      LNFLOATCOLUMN := REC_PG.NUM_1;
 1565                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1566                      LNVALUETYPE := 0;
 1567                   ELSIF REC_LAYOUT.FIELD_ID = 2
 1568                   THEN
 1569                      LNFLOATCOLUMN := REC_PG.NUM_2;
 1570                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1571                      LNVALUETYPE := 0;
 1572                   ELSIF REC_LAYOUT.FIELD_ID = 3
 1573                   THEN
 1574                      LNFLOATCOLUMN := REC_PG.NUM_3;
 1575                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1576                      LNVALUETYPE := 0;
 1577                   ELSIF REC_LAYOUT.FIELD_ID = 4
 1578                   THEN
 1579                      LNFLOATCOLUMN := REC_PG.NUM_4;
 1580                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1581                      LNVALUETYPE := 0;
 1582                   ELSIF REC_LAYOUT.FIELD_ID = 5
 1583                   THEN
 1584                      LNFLOATCOLUMN := REC_PG.NUM_5;
 1585                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1586                      LNVALUETYPE := 0;
 1587                   ELSIF REC_LAYOUT.FIELD_ID = 6
 1588                   THEN
 1589                      LNFLOATCOLUMN := REC_PG.NUM_6;
 1590                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1591                      LNVALUETYPE := 0;
 1592                   ELSIF REC_LAYOUT.FIELD_ID = 7
 1593                   THEN
 1594                      LNFLOATCOLUMN := REC_PG.NUM_7;
 1595                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1596                      LNVALUETYPE := 0;
 1597                   ELSIF REC_LAYOUT.FIELD_ID = 8
 1598                   THEN
 1599                      LNFLOATCOLUMN := REC_PG.NUM_8;
 1600                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1601                      LNVALUETYPE := 0;
 1602                   ELSIF REC_LAYOUT.FIELD_ID = 9
 1603                   THEN
 1604                      LNFLOATCOLUMN := REC_PG.NUM_9;
 1605                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1606                      LNVALUETYPE := 0;
 1607                   ELSIF REC_LAYOUT.FIELD_ID = 10
 1608                   THEN
 1609                      LNFLOATCOLUMN := REC_PG.NUM_10;
 1610                      LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
 1611                      LNVALUETYPE := 0;
 1612                   ELSIF REC_LAYOUT.FIELD_ID = 11
 1613                   THEN
 1614                      LNFLOATCOLUMN := 0;
 1615                      LSCOLUMN := REC_PG.CHAR_1;
 1616                      LNVALUETYPE := 1;
 1617                   ELSIF REC_LAYOUT.FIELD_ID = 12
 1618                   THEN
 1619                      LNFLOATCOLUMN := 0;
 1620                      LSCOLUMN := REC_PG.CHAR_2;
 1621                      LNVALUETYPE := 1;
 1622                   ELSIF REC_LAYOUT.FIELD_ID = 13
 1623                   THEN
 1624                      LNFLOATCOLUMN := 0;
 1625                      LSCOLUMN := REC_PG.CHAR_3;
 1626                      LNVALUETYPE := 1;
 1627                   ELSIF REC_LAYOUT.FIELD_ID = 14
 1628                   THEN
 1629                      LNFLOATCOLUMN := 0;
 1630                      LSCOLUMN := REC_PG.CHAR_4;
 1631                      LNVALUETYPE := 1;
 1632                   ELSIF REC_LAYOUT.FIELD_ID = 15
 1633                   THEN
 1634                      LNFLOATCOLUMN := 0;
 1635                      LSCOLUMN := REC_PG.CHAR_5;
 1636                      LNVALUETYPE := 1;
 1637                   ELSIF REC_LAYOUT.FIELD_ID = 16
 1638                   THEN
 1639                      LNFLOATCOLUMN := 0;
 1640                      LSCOLUMN := REC_PG.CHAR_6;
 1641                      LNVALUETYPE := 1;
 1642                   ELSIF REC_LAYOUT.FIELD_ID = 17
 1643                   THEN
 1644                      LNFLOATCOLUMN := 0;
 1645                      LSCOLUMN := REC_PG.BOOLEAN_1;
 1646 
 1647                      IF LSCOLUMN IS NULL
 1648                      THEN
 1649                         LSCOLUMN := 'N';
 1650                      END IF;
 1651 
 1652                      LNVALUETYPE := 1;
 1653                   ELSIF REC_LAYOUT.FIELD_ID = 18
 1654                   THEN
 1655                      LNFLOATCOLUMN := 0;
 1656                      LSCOLUMN := REC_PG.BOOLEAN_2;
 1657 
 1658                      IF LSCOLUMN IS NULL
 1659                      THEN
 1660                         LSCOLUMN := 'N';
 1661                      END IF;
 1662 
 1663                      LNVALUETYPE := 1;
 1664                   ELSIF REC_LAYOUT.FIELD_ID = 19
 1665                   THEN
 1666                      LNFLOATCOLUMN := 0;
 1667                      LSCOLUMN := REC_PG.BOOLEAN_3;
 1668 
 1669                      IF LSCOLUMN IS NULL
 1670                      THEN
 1671                         LSCOLUMN := 'N';
 1672                      END IF;
 1673 
 1674                      LNVALUETYPE := 1;
 1675                   ELSIF REC_LAYOUT.FIELD_ID = 20
 1676                   THEN
 1677                      LNFLOATCOLUMN := 0;
 1678                      LSCOLUMN := REC_PG.BOOLEAN_4;
 1679 
 1680                      IF LSCOLUMN IS NULL
 1681                      THEN
 1682                         LSCOLUMN := 'N';
 1683                      END IF;
 1684 
 1685                      LNVALUETYPE := 1;
 1686                   ELSIF REC_LAYOUT.FIELD_ID = 21
 1687                   THEN
 1688                      LNFLOATCOLUMN := 0;
 1689                      LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
 1690                                           'dd-mm-yyyy hh24:mi:ss' );
 1691                      LDDATECOLUMN := REC_PG.DATE_1;
 1692 
 1693                      IF LDDATECOLUMN IS NULL
 1694                      THEN
 1695                         LNVALUETYPE := 1;
 1696                      ELSE
 1697                         LNVALUETYPE := 2;
 1698                      END IF;
 1699                   ELSIF REC_LAYOUT.FIELD_ID = 22
 1700                   THEN
 1701                      LNFLOATCOLUMN := 0;
 1702                      LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
 1703                                           'dd-mm-yyyy hh24:mi:ss' );
 1704                      LDDATECOLUMN := REC_PG.DATE_2;
 1705 
 1706                      IF LDDATECOLUMN IS NULL
 1707                      THEN
 1708                         LNVALUETYPE := 1;
 1709                      ELSE
 1710                         LNVALUETYPE := 2;
 1711                      END IF;
 1712                   ELSIF REC_LAYOUT.FIELD_ID = 26
 1713                   THEN
 1714                      LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
 1715                      LSCOLUMN := F_CHH_DESCR( 1,
 1716                                               REC_PG.CHARACTERISTIC,
 1717                                               0 );
 1718                      LNVALUETYPE := 0;
 1719                      LNCHARACTERISTICID := REC_PG.CHARACTERISTIC;
 1720                      LNASSOCIATIONID := REC_PG.ASSOCIATION;
 1721 
 1722                   ELSIF REC_LAYOUT.FIELD_ID = 30
 1723                   THEN
 1724                      LNFLOATCOLUMN := REC_PG.CH_2;
 1725                      LSCOLUMN := F_CHH_DESCR( 1,
 1726                                               REC_PG.CH_2,
 1727                                               0 );
 1728                      LNVALUETYPE := 0;
 1729                      LNCHARACTERISTICID := REC_PG.CH_2;
 1730                      LNASSOCIATIONID := REC_PG.AS_2;
 1731 
 1732                   ELSIF REC_LAYOUT.FIELD_ID = 31
 1733                   THEN
 1734                      LNFLOATCOLUMN := REC_PG.CH_3;
 1735                      LSCOLUMN := F_CHH_DESCR( 1,
 1736                                               REC_PG.CH_3,
 1737                                               0 );
 1738                      LNVALUETYPE := 0;
 1739                      LNCHARACTERISTICID := REC_PG.CH_3;
 1740                      LNASSOCIATIONID := REC_PG.AS_3;
 1741 
 1742                   END IF;
 1743 
 1744 
 1745                   IF    REC_LAYOUT.FIELD_ID < 23
 1746                      OR REC_LAYOUT.FIELD_ID = 24
 1747                      OR REC_LAYOUT.FIELD_ID = 26
 1748                      OR REC_LAYOUT.FIELD_ID = 30
 1749                      OR REC_LAYOUT.FIELD_ID = 31
 1750                   THEN
 1751                      BEGIN
 1752                         LNCOUNTER :=   LNCOUNTER
 1753                                      + 1;
 1754 
 1755                         IF LNVALUETYPE = 2
 1756                         THEN
 1757 
 1758                            INSERT INTO SPECDATA
 1759                                        ( REVISION,
 1760                                          PART_NO,
 1761                                          SECTION_ID,
 1762                                          SUB_SECTION_ID,
 1763                                          SECTION_REV,
 1764                                          SUB_SECTION_REV,
 1765                                          SEQUENCE_NO,
 1766                                          TYPE,
 1767                                          REF_ID,
 1768                                          REF_VER,
 1769                                          PROPERTY_GROUP,
 1770                                          PROPERTY,
 1771                                          ATTRIBUTE,
 1772                                          PROPERTY_GROUP_REV,
 1773                                          PROPERTY_REV,
 1774                                          ATTRIBUTE_REV,
 1775                                          HEADER_ID,
 1776                                          HEADER_REV,
 1777                                          VALUE,
 1778                                          VALUE_S,
 1779                                          VALUE_DT,
 1780                                          VALUE_TYPE,
 1781                                          UOM_ID,
 1782                                          TEST_METHOD,
 1783                                          CHARACTERISTIC,
 1784                                          ASSOCIATION,
 1785                                          UOM_REV,
 1786                                          TEST_METHOD_REV,
 1787                                          CHARACTERISTIC_REV,
 1788                                          ASSOCIATION_REV,
 1789                                          REF_INFO,
 1790                                          INTL )
 1791                                 VALUES ( ANREVISION,
 1792                                          ASPARTNO,
 1793                                          REC_SECTION.SECTION_ID,
 1794                                          REC_SECTION.SUB_SECTION_ID,
 1795                                          REC_SECTION.SECTION_REV,
 1796                                          REC_SECTION.SUB_SECTION_REV,
 1797                                          NVL( LNCOUNTER,
 1798                                               0 ),
 1799                                          REC_SECTION.TYPE,
 1800                                          NVL( REC_SECTION.REF_ID,
 1801                                               -1 ),
 1802                                          NVL( REC_SECTION.REF_VER,
 1803                                               -1 ),
 1804                                          NVL( REC_PG.PROPERTY_GROUP,
 1805                                               -1 ),
 1806                                          NVL( REC_PG.PROPERTY,
 1807                                               -1 ),
 1808                                          NVL( REC_PG.ATTRIBUTE,
 1809                                               -1 ),
 1810                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 1811                                               -1 ),
 1812                                          NVL( REC_PG.PROPERTY_REV,
 1813                                               -1 ),
 1814                                          NVL( REC_PG.ATTRIBUTE_REV,
 1815                                               -1 ),
 1816                                          NVL( REC_LAYOUT.HEADER_ID,
 1817                                               -1 ),
 1818                                          NVL( REC_LAYOUT.HEADER_REV,
 1819                                               -1 ),
 1820                                          NVL( LNFLOATCOLUMN,
 1821                                               0 ),
 1822                                          LSCOLUMN,
 1823                                          TO_DATE( LSCOLUMN,
 1824                                                   'dd-mm-yyyy hh24:mi:ss' ),
 1825                                          NVL( LNVALUETYPE,
 1826                                               0 ),
 1827                                          NVL( REC_PG.UOM_ID,
 1828                                               -1 ),
 1829                                          DECODE( REC_PG.TEST_METHOD,
 1830                                                  0, -1,
 1831                                                  NVL( REC_PG.TEST_METHOD,
 1832                                                       -1 ) ),
 1833                                          NVL( LNCHARACTERISTICID,
 1834                                               -1 ),
 1835                                          NVL( LNASSOCIATIONID,
 1836                                               -1 ),
 1837                                          NVL( REC_PG.UOM_REV,
 1838                                               -1 ),
 1839                                          NVL( REC_PG.TEST_METHOD_REV,
 1840                                               -1 ),
 1841                                          NVL( REC_PG.CHARACTERISTIC_REV,
 1842                                               -1 ),
 1843                                          NVL( REC_PG.ASSOCIATION_REV,
 1844                                               -1 ),
 1845                                          NVL( REC_SECTION.REF_INFO,
 1846                                               -1 ),
 1847                                          NVL( REC_SECTION.INTL,
 1848                                               -1 ) );
 1849 
 1850                         ELSE
 1851 
 1852                            INSERT INTO SPECDATA
 1853                                        ( REVISION,
 1854                                          PART_NO,
 1855                                          SECTION_ID,
 1856                                          SUB_SECTION_ID,
 1857                                          SECTION_REV,
 1858                                          SUB_SECTION_REV,
 1859                                          SEQUENCE_NO,
 1860                                          TYPE,
 1861                                          REF_ID,
 1862                                          REF_VER,
 1863                                          PROPERTY_GROUP,
 1864                                          PROPERTY,
 1865                                          ATTRIBUTE,
 1866                                          PROPERTY_GROUP_REV,
 1867                                          PROPERTY_REV,
 1868                                          ATTRIBUTE_REV,
 1869                                          HEADER_ID,
 1870                                          HEADER_REV,
 1871                                          VALUE,
 1872                                          VALUE_S,
 1873                                          VALUE_TYPE,
 1874                                          UOM_ID,
 1875                                          TEST_METHOD,
 1876                                          CHARACTERISTIC,
 1877                                          ASSOCIATION,
 1878                                          UOM_REV,
 1879                                          TEST_METHOD_REV,
 1880                                          CHARACTERISTIC_REV,
 1881                                          ASSOCIATION_REV,
 1882                                          REF_INFO,
 1883                                          INTL )
 1884                                 VALUES ( ANREVISION,
 1885                                          ASPARTNO,
 1886                                          REC_SECTION.SECTION_ID,
 1887                                          REC_SECTION.SUB_SECTION_ID,
 1888                                          REC_SECTION.SECTION_REV,
 1889                                          REC_SECTION.SUB_SECTION_REV,
 1890                                          NVL( LNCOUNTER,
 1891                                               0 ),
 1892                                          REC_SECTION.TYPE,
 1893                                          NVL( REC_SECTION.REF_ID,
 1894                                               -1 ),
 1895                                          NVL( REC_SECTION.REF_VER,
 1896                                               -1 ),
 1897                                          NVL( REC_PG.PROPERTY_GROUP,
 1898                                               -1 ),
 1899                                          NVL( REC_PG.PROPERTY,
 1900                                               -1 ),
 1901                                          NVL( REC_PG.ATTRIBUTE,
 1902                                               -1 ),
 1903                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 1904                                               -1 ),
 1905                                          NVL( REC_PG.PROPERTY_REV,
 1906                                               -1 ),
 1907                                          NVL( REC_PG.ATTRIBUTE_REV,
 1908                                               -1 ),
 1909                                          NVL( REC_LAYOUT.HEADER_ID,
 1910                                               -1 ),
 1911                                          NVL( REC_LAYOUT.HEADER_REV,
 1912                                               -1 ),
 1913                                          LNFLOATCOLUMN,
 1914                                          LSCOLUMN,
 1915                                          NVL( LNVALUETYPE,
 1916                                               0 ),
 1917                                          NVL( DECODE( LNUOMTYPE,
 1918                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 1919                                                                  NULL, REC_PG.UOM_ID,
 1920                                                                  REC_PG.UOM_ALT_ID ),
 1921                                                       REC_PG.UOM_ID ),
 1922                                               -1 ),
 1923                                          DECODE( REC_PG.TEST_METHOD,
 1924                                                  0, -1,
 1925                                                  NVL( REC_PG.TEST_METHOD,
 1926                                                       -1 ) ),
 1927                                          NVL( LNCHARACTERISTICID,
 1928                                               -1 ),
 1929                                          NVL( LNASSOCIATIONID,
 1930                                               -1 ),
 1931                                          NVL( DECODE( LNUOMTYPE,
 1932                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 1933                                                                  NULL, REC_PG.UOM_REV,
 1934                                                                  REC_PG.UOM_ALT_REV ),
 1935                                                       REC_PG.UOM_REV ),
 1936                                               -1 ),
 1937                                          NVL( REC_PG.TEST_METHOD_REV,
 1938                                               -1 ),
 1939                                          NVL( REC_PG.CHARACTERISTIC_REV,
 1940                                               -1 ),
 1941                                          NVL( REC_PG.ASSOCIATION_REV,
 1942                                               -1 ),
 1943                                          NVL( REC_SECTION.REF_INFO,
 1944                                               -1 ),
 1945                                          NVL( REC_SECTION.INTL,
 1946                                               -1 ) );
 1947 
 1948                         END IF;
 1949                      EXCEPTION
 1950                         WHEN OTHERS
 1951                         THEN
 1952                            IAPIGENERAL.LOGERROR( GSSOURCE,
 1953                                                  LSMETHOD,
 1954                                                  SQLERRM );
 1955                            DBMS_OUTPUT.PUT_LINE(    'PG '
 1956                                                  || SUBSTR( SQLERRM,
 1957                                                             1,
 1958                                                             255 ) );
 1959                            DBMS_OUTPUT.PUT_LINE(    'PG info  '
 1960                                                  || LSCOLUMN
 1961                                                  || '    '
 1962                                                  || REC_LAYOUT.FIELD_ID );
 1963                            RAISE_APPLICATION_ERROR( -20000,
 1964                                                     SQLERRM );
 1965                      END;
 1966                   END IF;
 1967                END LOOP;
 1968 
 1969 
 1970                FOR REC_PG_LANG IN CUR_PG_LANG( ASPARTNO,
 1971                                                ANREVISION,
 1972                                                REC_PG.SECTION_ID,
 1973                                                REC_PG.SUB_SECTION_ID,
 1974                                                REC_PG.PROPERTY_GROUP,
 1975                                                REC_PG.PROPERTY,
 1976                                                REC_PG.ATTRIBUTE )
 1977                LOOP
 1978                   LBDATA := TRUE;
 1979 
 1980                   FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
 1981                                                 REC_SECTION.DISPLAY_FORMAT_REV )
 1982                   LOOP
 1983 
 1984                      LSCOLUMN := '';
 1985                      LDDATECOLUMN := NULL;
 1986 
 1987                      IF REC_LAYOUT.FIELD_ID = 11
 1988                      THEN
 1989                         LNFLOATCOLUMN := 0;
 1990                         LSCOLUMN := REC_PG_LANG.CHAR_1;
 1991                      ELSIF REC_LAYOUT.FIELD_ID = 12
 1992                      THEN
 1993                         LNFLOATCOLUMN := 0;
 1994                         LSCOLUMN := REC_PG_LANG.CHAR_2;
 1995                      ELSIF REC_LAYOUT.FIELD_ID = 13
 1996                      THEN
 1997                         LNFLOATCOLUMN := 0;
 1998                         LSCOLUMN := REC_PG_LANG.CHAR_3;
 1999                      ELSIF REC_LAYOUT.FIELD_ID = 14
 2000                      THEN
 2001                         LNFLOATCOLUMN := 0;
 2002                         LSCOLUMN := REC_PG_LANG.CHAR_4;
 2003                      ELSIF REC_LAYOUT.FIELD_ID = 15
 2004                      THEN
 2005                         LNFLOATCOLUMN := 0;
 2006                         LSCOLUMN := REC_PG_LANG.CHAR_5;
 2007                      ELSIF REC_LAYOUT.FIELD_ID = 16
 2008                      THEN
 2009                         LNFLOATCOLUMN := 0;
 2010                         LSCOLUMN := REC_PG_LANG.CHAR_6;
 2011                      END IF;
 2012 
 2013 
 2014                      IF REC_LAYOUT.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
 2015                      THEN
 2016                         BEGIN
 2017                            LNCOUNTER :=   LNCOUNTER
 2018                                         + 1;
 2019 
 2020 
 2021                            INSERT INTO SPECDATA
 2022                                        ( REVISION,
 2023                                          PART_NO,
 2024                                          LANG_ID,
 2025                                          SECTION_ID,
 2026                                          SUB_SECTION_ID,
 2027                                          SECTION_REV,
 2028                                          SUB_SECTION_REV,
 2029                                          SEQUENCE_NO,
 2030                                          TYPE,
 2031                                          REF_ID,
 2032                                          REF_VER,
 2033                                          PROPERTY_GROUP,
 2034                                          PROPERTY,
 2035                                          ATTRIBUTE,
 2036                                          PROPERTY_GROUP_REV,
 2037                                          PROPERTY_REV,
 2038                                          ATTRIBUTE_REV,
 2039                                          HEADER_ID,
 2040                                          HEADER_REV,
 2041                                          VALUE,
 2042                                          VALUE_S,
 2043                                          VALUE_TYPE,
 2044                                          UOM_ID,
 2045                                          TEST_METHOD,
 2046                                          CHARACTERISTIC,
 2047                                          ASSOCIATION,
 2048                                          UOM_REV,
 2049                                          TEST_METHOD_REV,
 2050                                          CHARACTERISTIC_REV,
 2051                                          ASSOCIATION_REV,
 2052                                          REF_INFO,
 2053                                          INTL )
 2054                                 VALUES ( ANREVISION,
 2055                                          ASPARTNO,
 2056                                          REC_PG_LANG.LANG_ID,
 2057                                          REC_SECTION.SECTION_ID,
 2058                                          REC_SECTION.SUB_SECTION_ID,
 2059                                          REC_SECTION.SECTION_REV,
 2060                                          REC_SECTION.SUB_SECTION_REV,
 2061                                          NVL( LNCOUNTER,
 2062                                               0 ),
 2063                                          REC_SECTION.TYPE,
 2064                                          NVL( REC_SECTION.REF_ID,
 2065                                               -1 ),
 2066                                          NVL( REC_SECTION.REF_VER,
 2067                                               -1 ),
 2068                                          NVL( REC_PG_LANG.PROPERTY_GROUP,
 2069                                               -1 ),
 2070                                          NVL( REC_PG_LANG.PROPERTY,
 2071                                               -1 ),
 2072                                          NVL( REC_PG_LANG.ATTRIBUTE,
 2073                                               -1 ),
 2074                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 2075                                               -1 ),
 2076                                          NVL( REC_PG.PROPERTY_REV,
 2077                                               -1 ),
 2078                                          NVL( REC_PG.ATTRIBUTE_REV,
 2079                                               -1 ),
 2080                                          NVL( REC_LAYOUT.HEADER_ID,
 2081                                               -1 ),
 2082                                          NVL( REC_LAYOUT.HEADER_REV,
 2083                                               -1 ),
 2084                                          LNFLOATCOLUMN,
 2085                                          LSCOLUMN,
 2086                                          NVL( LNVALUETYPE,
 2087                                               0 ),
 2088                                          NVL( DECODE( LNUOMTYPE,
 2089                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 2090                                                                  NULL, REC_PG.UOM_ID,
 2091                                                                  REC_PG.UOM_ALT_ID ),
 2092                                                       REC_PG.UOM_ID ),
 2093                                               -1 ),
 2094                                          DECODE( REC_PG.TEST_METHOD,
 2095                                                  0, -1,
 2096                                                  NVL( REC_PG.TEST_METHOD,
 2097                                                       -1 ) ),
 2098                                          NVL( REC_PG.CHARACTERISTIC,
 2099                                               -1 ),
 2100                                          NVL( REC_PG.ASSOCIATION,
 2101                                               -1 ),
 2102                                          NVL( DECODE( LNUOMTYPE,
 2103                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 2104                                                                  NULL, REC_PG.UOM_REV,
 2105                                                                  REC_PG.UOM_ALT_REV ),
 2106                                                       REC_PG.UOM_REV ),
 2107                                               -1 ),
 2108                                          NVL( REC_PG.TEST_METHOD_REV,
 2109                                               -1 ),
 2110                                          NVL( REC_PG.CHARACTERISTIC_REV,
 2111                                               -1 ),
 2112                                          NVL( REC_PG.ASSOCIATION_REV,
 2113                                               -1 ),
 2114                                          NVL( REC_SECTION.REF_INFO,
 2115                                               -1 ),
 2116                                          NVL( REC_SECTION.INTL,
 2117                                               -1 ) );
 2118                         EXCEPTION
 2119                            WHEN OTHERS
 2120                            THEN
 2121                               IAPIGENERAL.LOGERROR( GSSOURCE,
 2122                                                     LSMETHOD,
 2123                                                     SQLERRM );
 2124                               RAISE_APPLICATION_ERROR( -20000,
 2125                                                        SQLERRM );
 2126                         END;
 2127                      END IF;
 2128                   END LOOP;
 2129                END LOOP;
 2130             END LOOP;
 2131 
 2132             IF NOT( LBDATA )
 2133             THEN
 2134                BEGIN
 2135                  
 2136                  
 2137                  LSCOLUMN := '';
 2138  
 2139                   LNCOUNTER :=   LNCOUNTER
 2140                                + 1;
 2141 
 2142                   INSERT INTO SPECDATA
 2143                               ( REVISION,
 2144                                 PART_NO,
 2145                                 SECTION_ID,
 2146                                 SUB_SECTION_ID,
 2147                                 SECTION_REV,
 2148                                 SUB_SECTION_REV,
 2149                                 SEQUENCE_NO,
 2150                                 TYPE,
 2151                                 REF_ID,
 2152                                 REF_VER,
 2153                                 REF_OWNER,
 2154                                 PROPERTY_GROUP,
 2155                                 VALUE_S,
 2156                                 REF_INFO,
 2157                                 INTL )
 2158                        VALUES ( ANREVISION,
 2159                                 ASPARTNO,
 2160                                 REC_SECTION.SECTION_ID,
 2161                                 REC_SECTION.SUB_SECTION_ID,
 2162                                 REC_SECTION.SECTION_REV,
 2163                                 REC_SECTION.SUB_SECTION_REV,
 2164                                 NVL( LNCOUNTER,
 2165                                      0 ),
 2166                                 REC_SECTION.TYPE,
 2167                                 NVL( REC_SECTION.REF_ID,
 2168                                      -1 ),
 2169                                 NVL( REC_SECTION.REF_VER,
 2170                                      -1 ),
 2171                                 NVL( REC_SECTION.REF_OWNER,
 2172                                      -1 ),
 2173                                 NVL( REC_SECTION.REF_ID,
 2174                                      -1 ),
 2175                                 LSCOLUMN,
 2176                                 NVL( REC_SECTION.REF_INFO,
 2177                                      -1 ),
 2178                                 NVL( REC_SECTION.INTL,
 2179                                      0 ) );
 2180                EXCEPTION
 2181                   WHEN OTHERS
 2182                   THEN
 2183                      IAPIGENERAL.LOGERROR( GSSOURCE,
 2184                                            LSMETHOD,
 2185                                            SQLERRM );
 2186                      RAISE_APPLICATION_ERROR( -20000,
 2187                                               SQLERRM );
 2188                END;
 2189             END IF;
 2190 
 2191 
 2192             UPDATE SPECIFICATION_PROP
 2193                SET TM_SET_NO = NULL
 2194              WHERE PART_NO = ASPARTNO
 2195                AND REVISION = ANREVISION
 2196                AND TEST_METHOD IS NULL
 2197                AND TM_SET_NO IS NOT NULL;
 2198          ELSIF REC_SECTION.TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
 2199          THEN
 2200 
 2201             FOR REC_PG IN CUR_SP( ASPARTNO,
 2202                                   ANREVISION,
 2203                                   REC_SECTION.SECTION_ID,
 2204                                   REC_SECTION.SUB_SECTION_ID,
 2205                                   REC_SECTION.REF_ID )
 2206             LOOP
 2207                FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
 2208                                              REC_SECTION.DISPLAY_FORMAT_REV )
 2209                LOOP
 2210                   LSCOLUMN := '';
 2211                   LDDATECOLUMN := NULL;
 2212 
 2213                   IF REC_LAYOUT.FIELD_ID = 1
 2214                   THEN
 2215                      LNFLOATCOLUMN := REC_PG.NUM_1;
 2216                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
 2217                      LNVALUETYPE := 0;
 2218                   ELSIF REC_LAYOUT.FIELD_ID = 2
 2219                   THEN
 2220                      LNFLOATCOLUMN := REC_PG.NUM_2;
 2221                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
 2222                      LNVALUETYPE := 0;
 2223                   ELSIF REC_LAYOUT.FIELD_ID = 3
 2224                   THEN
 2225                      LNFLOATCOLUMN := REC_PG.NUM_3;
 2226                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
 2227                      LNVALUETYPE := 0;
 2228                   ELSIF REC_LAYOUT.FIELD_ID = 4
 2229                   THEN
 2230                      LNFLOATCOLUMN := REC_PG.NUM_4;
 2231                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
 2232                      LNVALUETYPE := 0;
 2233                   ELSIF REC_LAYOUT.FIELD_ID = 5
 2234                   THEN
 2235                      LNFLOATCOLUMN := REC_PG.NUM_5;
 2236                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
 2237                      LNVALUETYPE := 0;
 2238                   ELSIF REC_LAYOUT.FIELD_ID = 6
 2239                   THEN
 2240                      LNFLOATCOLUMN := REC_PG.NUM_6;
 2241                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
 2242                      LNVALUETYPE := 0;
 2243                   ELSIF REC_LAYOUT.FIELD_ID = 7
 2244                   THEN
 2245                      LNFLOATCOLUMN := REC_PG.NUM_7;
 2246                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
 2247                      LNVALUETYPE := 0;
 2248                   ELSIF REC_LAYOUT.FIELD_ID = 8
 2249                   THEN
 2250                      LNFLOATCOLUMN := REC_PG.NUM_8;
 2251                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
 2252                      LNVALUETYPE := 0;
 2253                   ELSIF REC_LAYOUT.FIELD_ID = 9
 2254                   THEN
 2255                      LNFLOATCOLUMN := REC_PG.NUM_9;
 2256                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
 2257                      LNVALUETYPE := 0;
 2258                   ELSIF REC_LAYOUT.FIELD_ID = 10
 2259                   THEN
 2260                      LNFLOATCOLUMN := REC_PG.NUM_10;
 2261                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
 2262                      LNVALUETYPE := 0;
 2263                   ELSIF REC_LAYOUT.FIELD_ID = 11
 2264                   THEN
 2265                      LNFLOATCOLUMN := 0;
 2266                      LSCOLUMN := REC_PG.CHAR_1;
 2267                      LNVALUETYPE := 1;
 2268                   ELSIF REC_LAYOUT.FIELD_ID = 12
 2269                   THEN
 2270                      LNFLOATCOLUMN := 0;
 2271                      LSCOLUMN := REC_PG.CHAR_2;
 2272                      LNVALUETYPE := 1;
 2273                   ELSIF REC_LAYOUT.FIELD_ID = 13
 2274                   THEN
 2275                      LNFLOATCOLUMN := 0;
 2276                      LSCOLUMN := REC_PG.CHAR_3;
 2277                      LNVALUETYPE := 1;
 2278                   ELSIF REC_LAYOUT.FIELD_ID = 14
 2279                   THEN
 2280                      LNFLOATCOLUMN := 0;
 2281                      LSCOLUMN := REC_PG.CHAR_4;
 2282                      LNVALUETYPE := 1;
 2283                   ELSIF REC_LAYOUT.FIELD_ID = 15
 2284                   THEN
 2285                      LNFLOATCOLUMN := 0;
 2286                      LSCOLUMN := REC_PG.CHAR_5;
 2287                      LNVALUETYPE := 1;
 2288                   ELSIF REC_LAYOUT.FIELD_ID = 16
 2289                   THEN
 2290                      LNFLOATCOLUMN := 0;
 2291                      LSCOLUMN := REC_PG.CHAR_6;
 2292                      LNVALUETYPE := 1;
 2293                   ELSIF REC_LAYOUT.FIELD_ID = 17
 2294                   THEN
 2295                      LNFLOATCOLUMN := 0;
 2296                      LSCOLUMN := REC_PG.BOOLEAN_1;
 2297 
 2298                      IF LSCOLUMN IS NULL
 2299                      THEN
 2300                         LSCOLUMN := 'N';
 2301                      END IF;
 2302 
 2303                      LNVALUETYPE := 1;
 2304                   ELSIF REC_LAYOUT.FIELD_ID = 18
 2305                   THEN
 2306                      LNFLOATCOLUMN := 0;
 2307                      LSCOLUMN := REC_PG.BOOLEAN_2;
 2308 
 2309                      IF LSCOLUMN IS NULL
 2310                      THEN
 2311                         LSCOLUMN := 'N';
 2312                      END IF;
 2313 
 2314                      LNVALUETYPE := 1;
 2315                   ELSIF REC_LAYOUT.FIELD_ID = 19
 2316                   THEN
 2317                      LNFLOATCOLUMN := 0;
 2318                      LSCOLUMN := REC_PG.BOOLEAN_3;
 2319 
 2320                      IF LSCOLUMN IS NULL
 2321                      THEN
 2322                         LSCOLUMN := 'N';
 2323                      END IF;
 2324 
 2325                      LNVALUETYPE := 1;
 2326                   ELSIF REC_LAYOUT.FIELD_ID = 20
 2327                   THEN
 2328                      LNFLOATCOLUMN := 0;
 2329                      LSCOLUMN := REC_PG.BOOLEAN_4;
 2330 
 2331                      IF LSCOLUMN IS NULL
 2332                      THEN
 2333                         LSCOLUMN := 'N';
 2334                      END IF;
 2335 
 2336                      LNVALUETYPE := 1;
 2337                   ELSIF REC_LAYOUT.FIELD_ID = 21
 2338                   THEN
 2339                      LNFLOATCOLUMN := 0;
 2340                      LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
 2341                                           'dd-mm-yyyy hh24:mi:ss' );
 2342                      LDDATECOLUMN := REC_PG.DATE_1;
 2343 
 2344                      IF LDDATECOLUMN IS NULL
 2345                      THEN
 2346                         LNVALUETYPE := 1;
 2347                      ELSE
 2348                         LNVALUETYPE := 2;
 2349                      END IF;
 2350                   ELSIF REC_LAYOUT.FIELD_ID = 22
 2351                   THEN
 2352                      LNFLOATCOLUMN := 0;
 2353                      LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
 2354                                           'dd-mm-yyyy hh24:mi:ss' );
 2355                      LDDATECOLUMN := REC_PG.DATE_2;
 2356 
 2357                      IF LDDATECOLUMN IS NULL
 2358                      THEN
 2359                         LNVALUETYPE := 1;
 2360                      ELSE
 2361                         LNVALUETYPE := 2;
 2362                      END IF;
 2363                   ELSIF REC_LAYOUT.FIELD_ID = 26
 2364                   THEN
 2365 
 2366                      LNFLOATCOLUMN := 0;
 2367                      LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
 2368                      LSCOLUMN := F_CHH_DESCR( 1,
 2369                                               REC_PG.CHARACTERISTIC,
 2370                                               0 );
 2371                      LNVALUETYPE := 0;
 2372                      LNCHARACTERISTICID := REC_PG.CHARACTERISTIC;
 2373                      LNASSOCIATIONID := REC_PG.ASSOCIATION;
 2374                   ELSIF REC_LAYOUT.FIELD_ID = 30
 2375                   THEN
 2376                      LNFLOATCOLUMN := REC_PG.CH_2;
 2377                      LSCOLUMN := F_CHH_DESCR( 1,
 2378                                               REC_PG.CH_2,
 2379                                               0 );
 2380                      LNVALUETYPE := 0;
 2381                      LNCHARACTERISTICID := REC_PG.CH_2;
 2382                      LNASSOCIATIONID := REC_PG.AS_2;
 2383 
 2384                   ELSIF REC_LAYOUT.FIELD_ID = 31
 2385                   THEN
 2386                      LNFLOATCOLUMN := REC_PG.CH_3;
 2387                      LSCOLUMN := F_CHH_DESCR( 1,
 2388                                               REC_PG.CH_3,
 2389                                               0 );
 2390                      LNVALUETYPE := 0;
 2391                      LNCHARACTERISTICID := REC_PG.CH_3;
 2392                      LNASSOCIATIONID := REC_PG.AS_3;
 2393 
 2394                   END IF;
 2395 
 2396                   IF    REC_LAYOUT.FIELD_ID < 23
 2397                      OR REC_LAYOUT.FIELD_ID = 26
 2398                      OR REC_LAYOUT.FIELD_ID = 30
 2399                      OR REC_LAYOUT.FIELD_ID = 31
 2400                   THEN
 2401                      BEGIN
 2402                         LNCOUNTER :=   LNCOUNTER
 2403                                      + 1;
 2404 
 2405                         IF LNVALUETYPE = 2
 2406                         THEN   
 2407                            INSERT INTO SPECDATA
 2408                                        ( REVISION,
 2409                                          PART_NO,
 2410                                          SECTION_ID,
 2411                                          SUB_SECTION_ID,
 2412                                          SECTION_REV,
 2413                                          SUB_SECTION_REV,
 2414                                          SEQUENCE_NO,
 2415                                          TYPE,
 2416                                          REF_ID,
 2417                                          REF_VER,
 2418                                          PROPERTY_GROUP,
 2419                                          PROPERTY,
 2420                                          ATTRIBUTE,
 2421                                          PROPERTY_GROUP_REV,
 2422                                          PROPERTY_REV,
 2423                                          ATTRIBUTE_REV,
 2424                                          HEADER_ID,
 2425                                          HEADER_REV,
 2426                                          VALUE,
 2427                                          VALUE_S,
 2428                                          VALUE_DT,
 2429                                          VALUE_TYPE,
 2430                                          UOM_ID,
 2431                                          TEST_METHOD,
 2432                                          CHARACTERISTIC,
 2433                                          ASSOCIATION,
 2434                                          UOM_REV,
 2435                                          TEST_METHOD_REV,
 2436                                          CHARACTERISTIC_REV,
 2437                                          ASSOCIATION_REV,
 2438                                          REF_INFO,
 2439                                          INTL )
 2440                                 VALUES ( ANREVISION,
 2441                                          ASPARTNO,
 2442                                          REC_SECTION.SECTION_ID,
 2443                                          REC_SECTION.SUB_SECTION_ID,
 2444                                          REC_SECTION.SECTION_REV,
 2445                                          REC_SECTION.SUB_SECTION_REV,
 2446                                          NVL( LNCOUNTER,
 2447                                               0 ),
 2448                                          REC_SECTION.TYPE,
 2449                                          NVL( REC_SECTION.REF_ID,
 2450                                               -1 ),
 2451                                          NVL( REC_SECTION.REF_VER,
 2452                                               -1 ),
 2453                                          NVL( REC_PG.PROPERTY_GROUP,
 2454                                               -1 ),
 2455                                          NVL( REC_PG.PROPERTY,
 2456                                               -1 ),
 2457                                          NVL( REC_PG.ATTRIBUTE,
 2458                                               -1 ),
 2459                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 2460                                               -1 ),
 2461                                          NVL( REC_PG.PROPERTY_REV,
 2462                                               -1 ),
 2463                                          NVL( REC_PG.ATTRIBUTE_REV,
 2464                                               -1 ),
 2465                                          NVL( REC_LAYOUT.HEADER_ID,
 2466                                               -1 ),
 2467                                          NVL( REC_LAYOUT.HEADER_REV,
 2468                                               -1 ),
 2469                                          NVL( LNFLOATCOLUMN,
 2470                                               0 ),
 2471                                          LSCOLUMN,
 2472                                          TO_DATE( LSCOLUMN,
 2473                                                   'dd-mm-yyyy hh24:mi:ss' ),
 2474                                          NVL( LNVALUETYPE,
 2475                                               0 ),
 2476                                          NVL( REC_PG.UOM_ID,
 2477                                               -1 ),
 2478                                          DECODE( REC_PG.TEST_METHOD,
 2479                                                  0, -1,
 2480                                                  NVL( REC_PG.TEST_METHOD,
 2481                                                       -1 ) ),
 2482                                          NVL( LNCHARACTERISTICID,
 2483                                               -1 ),
 2484                                          NVL( LNASSOCIATIONID,
 2485                                               -1 ),
 2486                                          NVL( REC_PG.UOM_REV,
 2487                                               -1 ),
 2488                                          NVL( REC_PG.TEST_METHOD_REV,
 2489                                               -1 ),
 2490                                          NVL( REC_PG.CHARACTERISTIC_REV,
 2491                                               -1 ),
 2492                                          NVL( REC_PG.ASSOCIATION_REV,
 2493                                               -1 ),
 2494                                          NVL( REC_SECTION.REF_INFO,
 2495                                               -1 ),
 2496                                          NVL( REC_SECTION.INTL,
 2497                                               -1 ) );
 2498                         ELSE
 2499                            INSERT INTO SPECDATA
 2500                                        ( REVISION,
 2501                                          PART_NO,
 2502                                          SECTION_ID,
 2503                                          SUB_SECTION_ID,
 2504                                          SECTION_REV,
 2505                                          SUB_SECTION_REV,
 2506                                          SEQUENCE_NO,
 2507                                          TYPE,
 2508                                          REF_ID,
 2509                                          REF_VER,
 2510                                          PROPERTY_GROUP,
 2511                                          PROPERTY,
 2512                                          ATTRIBUTE,
 2513                                          PROPERTY_GROUP_REV,
 2514                                          PROPERTY_REV,
 2515                                          ATTRIBUTE_REV,
 2516                                          HEADER_ID,
 2517                                          HEADER_REV,
 2518                                          VALUE,
 2519                                          VALUE_S,
 2520                                          VALUE_TYPE,
 2521                                          UOM_ID,
 2522                                          TEST_METHOD,
 2523                                          CHARACTERISTIC,
 2524                                          ASSOCIATION,
 2525                                          UOM_REV,
 2526                                          TEST_METHOD_REV,
 2527                                          CHARACTERISTIC_REV,
 2528                                          ASSOCIATION_REV,
 2529                                          REF_INFO,
 2530                                          INTL )
 2531                                 VALUES ( ANREVISION,
 2532                                          ASPARTNO,
 2533                                          REC_SECTION.SECTION_ID,
 2534                                          REC_SECTION.SUB_SECTION_ID,
 2535                                          REC_SECTION.SECTION_REV,
 2536                                          REC_SECTION.SUB_SECTION_REV,
 2537                                          NVL( LNCOUNTER,
 2538                                               0 ),
 2539                                          REC_SECTION.TYPE,
 2540                                          NVL( REC_SECTION.REF_ID,
 2541                                               -1 ),
 2542                                          NVL( REC_SECTION.REF_VER,
 2543                                               -1 ),
 2544                                          NVL( REC_PG.PROPERTY_GROUP,
 2545                                               -1 ),
 2546                                          NVL( REC_PG.PROPERTY,
 2547                                               -1 ),
 2548                                          NVL( REC_PG.ATTRIBUTE,
 2549                                               -1 ),
 2550                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 2551                                               -1 ),
 2552                                          NVL( REC_PG.PROPERTY_REV,
 2553                                               -1 ),
 2554                                          NVL( REC_PG.ATTRIBUTE_REV,
 2555                                               -1 ),
 2556                                          NVL( REC_LAYOUT.HEADER_ID,
 2557                                               -1 ),
 2558                                          NVL( REC_LAYOUT.HEADER_REV,
 2559                                               -1 ),
 2560                                          LNFLOATCOLUMN,
 2561                                          LSCOLUMN,
 2562                                          NVL( LNVALUETYPE,
 2563                                               0 ),
 2564                                          NVL( DECODE( LNUOMTYPE,
 2565                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 2566                                                                  NULL, REC_PG.UOM_ID,
 2567                                                                  REC_PG.UOM_ALT_ID ),
 2568                                                       REC_PG.UOM_ID ),
 2569                                               -1 ),
 2570                                          DECODE( REC_PG.TEST_METHOD,
 2571                                                  0, -1,
 2572                                                  NVL( REC_PG.TEST_METHOD,
 2573                                                       -1 ) ),
 2574                                          NVL( LNCHARACTERISTICID,
 2575                                               -1 ),
 2576                                          NVL( LNASSOCIATIONID,
 2577                                               -1 ),
 2578                                          NVL( DECODE( LNUOMTYPE,
 2579                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 2580                                                                  NULL, REC_PG.UOM_REV,
 2581                                                                  REC_PG.UOM_ALT_REV ),
 2582                                                       REC_PG.UOM_REV ),
 2583                                               -1 ),
 2584                                          NVL( REC_PG.TEST_METHOD_REV,
 2585                                               -1 ),
 2586                                          NVL( REC_PG.CHARACTERISTIC_REV,
 2587                                               -1 ),
 2588                                          NVL( REC_PG.ASSOCIATION_REV,
 2589                                               -1 ),
 2590                                          NVL( REC_SECTION.REF_INFO,
 2591                                               -1 ),
 2592                                          NVL( REC_SECTION.INTL,
 2593                                               0 ) );
 2594                         END IF;
 2595                      EXCEPTION
 2596                         WHEN OTHERS
 2597                         THEN
 2598                            IAPIGENERAL.LOGERROR( GSSOURCE,
 2599                                                  LSMETHOD,
 2600                                                  SQLERRM );
 2601                            RAISE_APPLICATION_ERROR( -20000,
 2602                                                     SQLERRM );
 2603                      END;
 2604                   END IF;
 2605                END LOOP;
 2606 
 2607 
 2608                FOR REC_PG_LANG IN CUR_SP_LANG( ASPARTNO,
 2609                                                ANREVISION,
 2610                                                REC_PG.SECTION_ID,
 2611                                                REC_PG.SUB_SECTION_ID,
 2612                                                REC_PG.PROPERTY_GROUP,
 2613                                                REC_PG.PROPERTY,
 2614                                                REC_PG.ATTRIBUTE )
 2615                LOOP
 2616                   LBDATA := TRUE;
 2617 
 2618                   FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
 2619                                                 REC_SECTION.DISPLAY_FORMAT_REV )
 2620                   LOOP
 2621                      LSCOLUMN := '';
 2622                      LDDATECOLUMN := NULL;
 2623 
 2624                      IF REC_LAYOUT.FIELD_ID = 11
 2625                      THEN
 2626                         LNFLOATCOLUMN := 0;
 2627                         LSCOLUMN := REC_PG_LANG.CHAR_1;
 2628                      ELSIF REC_LAYOUT.FIELD_ID = 12
 2629                      THEN
 2630                         LNFLOATCOLUMN := 0;
 2631                         LSCOLUMN := REC_PG_LANG.CHAR_2;
 2632                      ELSIF REC_LAYOUT.FIELD_ID = 13
 2633                      THEN
 2634                         LNFLOATCOLUMN := 0;
 2635                         LSCOLUMN := REC_PG_LANG.CHAR_3;
 2636                      ELSIF REC_LAYOUT.FIELD_ID = 14
 2637                      THEN
 2638                         LNFLOATCOLUMN := 0;
 2639                         LSCOLUMN := REC_PG_LANG.CHAR_4;
 2640                      ELSIF REC_LAYOUT.FIELD_ID = 15
 2641                      THEN
 2642                         LNFLOATCOLUMN := 0;
 2643                         LSCOLUMN := REC_PG_LANG.CHAR_5;
 2644                      ELSIF REC_LAYOUT.FIELD_ID = 16
 2645                      THEN
 2646                         LNFLOATCOLUMN := 0;
 2647                         LSCOLUMN := REC_PG_LANG.CHAR_6;
 2648                      END IF;
 2649 
 2650                      IF REC_LAYOUT.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
 2651                      THEN
 2652                         BEGIN
 2653                            LNCOUNTER :=   LNCOUNTER
 2654                                         + 1;
 2655 
 2656 
 2657                            INSERT INTO SPECDATA
 2658                                        ( REVISION,
 2659                                          PART_NO,
 2660                                          LANG_ID,
 2661                                          SECTION_ID,
 2662                                          SUB_SECTION_ID,
 2663                                          SECTION_REV,
 2664                                          SUB_SECTION_REV,
 2665                                          SEQUENCE_NO,
 2666                                          TYPE,
 2667                                          REF_ID,
 2668                                          REF_VER,
 2669                                          PROPERTY_GROUP,
 2670                                          PROPERTY,
 2671                                          ATTRIBUTE,
 2672                                          PROPERTY_GROUP_REV,
 2673                                          PROPERTY_REV,
 2674                                          ATTRIBUTE_REV,
 2675                                          HEADER_ID,
 2676                                          HEADER_REV,
 2677                                          VALUE,
 2678                                          VALUE_S,
 2679                                          VALUE_TYPE,
 2680                                          UOM_ID,
 2681                                          TEST_METHOD,
 2682                                          CHARACTERISTIC,
 2683                                          ASSOCIATION,
 2684                                          UOM_REV,
 2685                                          TEST_METHOD_REV,
 2686                                          CHARACTERISTIC_REV,
 2687                                          ASSOCIATION_REV,
 2688                                          REF_INFO,
 2689                                          INTL )
 2690                                 VALUES ( ANREVISION,
 2691                                          ASPARTNO,
 2692                                          REC_PG_LANG.LANG_ID,
 2693                                          REC_SECTION.SECTION_ID,
 2694                                          REC_SECTION.SUB_SECTION_ID,
 2695                                          REC_SECTION.SECTION_REV,
 2696                                          REC_SECTION.SUB_SECTION_REV,
 2697                                          NVL( LNCOUNTER,
 2698                                               0 ),
 2699                                          REC_SECTION.TYPE,
 2700                                          NVL( REC_SECTION.REF_ID,
 2701                                               -1 ),
 2702                                          NVL( REC_SECTION.REF_VER,
 2703                                               -1 ),
 2704                                          NVL( REC_PG_LANG.PROPERTY_GROUP,
 2705                                               -1 ),
 2706                                          NVL( REC_PG_LANG.PROPERTY,
 2707                                               -1 ),
 2708                                          NVL( REC_PG_LANG.ATTRIBUTE,
 2709                                               -1 ),
 2710                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 2711                                               -1 ),
 2712                                          NVL( REC_PG.PROPERTY_REV,
 2713                                               -1 ),
 2714                                          NVL( REC_PG.ATTRIBUTE_REV,
 2715                                               -1 ),
 2716                                          NVL( REC_LAYOUT.HEADER_ID,
 2717                                               -1 ),
 2718                                          NVL( REC_LAYOUT.HEADER_REV,
 2719                                               -1 ),
 2720                                          LNFLOATCOLUMN,
 2721                                          LSCOLUMN,
 2722                                          NVL( LNVALUETYPE,
 2723                                               0 ),
 2724                                          NVL( DECODE( LNUOMTYPE,
 2725                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 2726                                                                  NULL, REC_PG.UOM_REV,
 2727                                                                  REC_PG.UOM_ALT_REV ),
 2728                                                       REC_PG.UOM_REV ),
 2729                                               -1 ),
 2730                                          DECODE( REC_PG.TEST_METHOD,
 2731                                                  0, -1,
 2732                                                  NVL( REC_PG.TEST_METHOD,
 2733                                                       -1 ) ),
 2734                                          NVL( REC_PG.CHARACTERISTIC,
 2735                                               -1 ),
 2736                                          NVL( REC_PG.ASSOCIATION,
 2737                                               -1 ),
 2738                                          NVL( DECODE( LNUOMTYPE,
 2739                                                       1, DECODE( REC_PG.UOM_ALT_ID,
 2740                                                                  NULL, REC_PG.UOM_REV,
 2741                                                                  REC_PG.UOM_ALT_REV ),
 2742                                                       REC_PG.UOM_REV ),
 2743                                               -1 ),
 2744                                          NVL( REC_PG.TEST_METHOD_REV,
 2745                                               -1 ),
 2746                                          NVL( REC_PG.CHARACTERISTIC_REV,
 2747                                               -1 ),
 2748                                          NVL( REC_PG.ASSOCIATION_REV,
 2749                                               -1 ),
 2750                                          NVL( REC_SECTION.REF_INFO,
 2751                                               -1 ),
 2752                                          NVL( REC_SECTION.INTL,
 2753                                               -1 ) );
 2754 
 2755                         EXCEPTION
 2756                            WHEN OTHERS
 2757                            THEN
 2758                               IAPIGENERAL.LOGERROR( GSSOURCE,
 2759                                                     LSMETHOD,
 2760                                                     SQLERRM );
 2761                               RAISE_APPLICATION_ERROR( -20000,
 2762                                                        SQLERRM );
 2763                         END;
 2764                      END IF;
 2765                   END LOOP;
 2766                END LOOP;
 2767             END LOOP;
 2768 
 2769 
 2770             UPDATE SPECIFICATION_PROP
 2771                SET TM_SET_NO = NULL
 2772              WHERE PART_NO = ASPARTNO
 2773                AND REVISION = ANREVISION
 2774                AND TEST_METHOD IS NULL
 2775                AND TM_SET_NO IS NOT NULL;
 2776          ELSIF REC_SECTION.TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
 2777          THEN   
 2778             FOR REC_PROCESS IN CUR_PROCESS( ASPARTNO,
 2779                                             ANREVISION )
 2780             LOOP
 2781                FOR REC_STAGE IN CUR_STAGE( ASPARTNO,
 2782                                            ANREVISION,
 2783                                            REC_PROCESS.PLANT,
 2784                                            REC_PROCESS.LINE,
 2785                                            REC_PROCESS.CONFIGURATION,
 2786                                            REC_PROCESS.PROCESS_LINE_REV )
 2787                LOOP
 2788                   LNCOUNTSTAGES := 0;
 2789 
 2790                   FOR REC_PG IN CUR_STAGE_PROP( ASPARTNO,
 2791                                                 ANREVISION,
 2792                                                 REC_PROCESS.PLANT,
 2793                                                 REC_PROCESS.LINE,
 2794                                                 REC_PROCESS.CONFIGURATION,
 2795                                                 REC_PROCESS.PROCESS_LINE_REV,
 2796                                                 REC_SECTION.SECTION_ID,
 2797                                                 REC_SECTION.SUB_SECTION_ID,
 2798                                                 REC_STAGE.STAGE )
 2799                   LOOP
 2800                      
 2801                      IF    REC_PG.VALUE_TYPE IS NULL
 2802                         OR REC_PG.VALUE_TYPE = 0
 2803                      THEN
 2804                         FOR REC_LAYOUT IN CUR_LAYOUT_PROCESS( REC_STAGE.DISPLAY_FORMAT )
 2805                         LOOP
 2806                            LSCOLUMN := '';
 2807                            LDDATECOLUMN := NULL;
 2808 
 2809                            IF REC_LAYOUT.FIELD_ID = 1
 2810                            THEN
 2811                               LNFLOATCOLUMN := REC_PG.NUM_1;
 2812                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
 2813                               LNVALUETYPE := 0;
 2814                            ELSIF REC_LAYOUT.FIELD_ID = 2
 2815                            THEN
 2816                               LNFLOATCOLUMN := REC_PG.NUM_2;
 2817                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
 2818                               LNVALUETYPE := 0;
 2819                            ELSIF REC_LAYOUT.FIELD_ID = 3
 2820                            THEN
 2821                               LNFLOATCOLUMN := REC_PG.NUM_3;
 2822                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
 2823                               LNVALUETYPE := 0;
 2824                            ELSIF REC_LAYOUT.FIELD_ID = 4
 2825                            THEN
 2826                               LNFLOATCOLUMN := REC_PG.NUM_4;
 2827                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
 2828                               LNVALUETYPE := 0;
 2829                            ELSIF REC_LAYOUT.FIELD_ID = 5
 2830                            THEN
 2831                               LNFLOATCOLUMN := REC_PG.NUM_5;
 2832                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
 2833                               LNVALUETYPE := 0;
 2834                            ELSIF REC_LAYOUT.FIELD_ID = 6
 2835                            THEN
 2836                               LNFLOATCOLUMN := REC_PG.NUM_6;
 2837                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
 2838                               LNVALUETYPE := 0;
 2839                            ELSIF REC_LAYOUT.FIELD_ID = 7
 2840                            THEN
 2841                               LNFLOATCOLUMN := REC_PG.NUM_7;
 2842                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
 2843                               LNVALUETYPE := 0;
 2844                            ELSIF REC_LAYOUT.FIELD_ID = 8
 2845                            THEN
 2846                               LNFLOATCOLUMN := REC_PG.NUM_8;
 2847                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
 2848                               LNVALUETYPE := 0;
 2849                            ELSIF REC_LAYOUT.FIELD_ID = 9
 2850                            THEN
 2851                               LNFLOATCOLUMN := REC_PG.NUM_9;
 2852                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
 2853                               LNVALUETYPE := 0;
 2854                            ELSIF REC_LAYOUT.FIELD_ID = 10
 2855                            THEN
 2856                               LNFLOATCOLUMN := REC_PG.NUM_10;
 2857                               LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
 2858                               LNVALUETYPE := 0;
 2859                            ELSIF REC_LAYOUT.FIELD_ID = 11
 2860                            THEN
 2861                               LNFLOATCOLUMN := 0;
 2862                               LSCOLUMN := REC_PG.CHAR_1;
 2863                               LNVALUETYPE := 1;
 2864                            ELSIF REC_LAYOUT.FIELD_ID = 12
 2865                            THEN
 2866                               LNFLOATCOLUMN := 0;
 2867                               LSCOLUMN := REC_PG.CHAR_2;
 2868                               LNVALUETYPE := 1;
 2869                            ELSIF REC_LAYOUT.FIELD_ID = 13
 2870                            THEN
 2871                               LNFLOATCOLUMN := 0;
 2872                               LSCOLUMN := REC_PG.CHAR_3;
 2873                               LNVALUETYPE := 1;
 2874                            ELSIF REC_LAYOUT.FIELD_ID = 14
 2875                            THEN
 2876                               LNFLOATCOLUMN := 0;
 2877                               LSCOLUMN := REC_PG.CHAR_4;
 2878                               LNVALUETYPE := 1;
 2879                            ELSIF REC_LAYOUT.FIELD_ID = 15
 2880                            THEN
 2881                               LNFLOATCOLUMN := 0;
 2882                               LSCOLUMN := REC_PG.CHAR_5;
 2883                               LNVALUETYPE := 1;
 2884                            ELSIF REC_LAYOUT.FIELD_ID = 16
 2885                            THEN
 2886                               LNFLOATCOLUMN := 0;
 2887                               LSCOLUMN := REC_PG.CHAR_6;
 2888                               LNVALUETYPE := 1;
 2889                            ELSIF REC_LAYOUT.FIELD_ID = 17
 2890                            THEN
 2891                               LNFLOATCOLUMN := 0;
 2892                               LSCOLUMN := REC_PG.BOOLEAN_1;
 2893 
 2894                               IF LSCOLUMN IS NULL
 2895                               THEN
 2896                                  LSCOLUMN := 'N';
 2897                               END IF;
 2898 
 2899                               LNVALUETYPE := 1;
 2900                            ELSIF REC_LAYOUT.FIELD_ID = 18
 2901                            THEN
 2902                               LNFLOATCOLUMN := 0;
 2903                               LSCOLUMN := REC_PG.BOOLEAN_2;
 2904 
 2905                               IF LSCOLUMN IS NULL
 2906                               THEN
 2907                                  LSCOLUMN := 'N';
 2908                               END IF;
 2909 
 2910                               LNVALUETYPE := 1;
 2911                            ELSIF REC_LAYOUT.FIELD_ID = 19
 2912                            THEN
 2913                               LNFLOATCOLUMN := 0;
 2914                               LSCOLUMN := REC_PG.BOOLEAN_3;
 2915 
 2916                               IF LSCOLUMN IS NULL
 2917                               THEN
 2918                                  LSCOLUMN := 'N';
 2919                               END IF;
 2920 
 2921                               LNVALUETYPE := 1;
 2922                            ELSIF REC_LAYOUT.FIELD_ID = 20
 2923                            THEN
 2924                               LNFLOATCOLUMN := 0;
 2925                               LSCOLUMN := REC_PG.BOOLEAN_4;
 2926 
 2927                               IF LSCOLUMN IS NULL
 2928                               THEN
 2929                                  LSCOLUMN := 'N';
 2930                               END IF;
 2931 
 2932                               LNVALUETYPE := 1;
 2933                            ELSIF REC_LAYOUT.FIELD_ID = 21
 2934                            THEN
 2935                               LNFLOATCOLUMN := 0;
 2936                               LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
 2937                                                    'dd-mm-yyyy hh24:mi:ss' );
 2938                               LDDATECOLUMN := REC_PG.DATE_1;
 2939 
 2940                               IF LDDATECOLUMN IS NULL
 2941                               THEN
 2942                                  LNVALUETYPE := 1;
 2943                               ELSE
 2944                                  LNVALUETYPE := 2;
 2945                               END IF;
 2946                            ELSIF REC_LAYOUT.FIELD_ID = 22
 2947                            THEN
 2948                               LNFLOATCOLUMN := 0;
 2949                               LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
 2950                                                    'dd-mm-yyyy hh24:mi:ss' );
 2951                               LDDATECOLUMN := REC_PG.DATE_2;
 2952 
 2953                               IF LDDATECOLUMN IS NULL
 2954                               THEN
 2955                                  LNVALUETYPE := 1;
 2956                               ELSE
 2957                                  LNVALUETYPE := 2;
 2958                               END IF;
 2959                            ELSIF REC_LAYOUT.FIELD_ID = 26
 2960                            THEN
 2961                               LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
 2962                               LSCOLUMN := F_CHH_DESCR( 1,
 2963                                                        REC_PG.CHARACTERISTIC,
 2964                                                        0 );
 2965                               LNVALUETYPE := 0;
 2966                            END IF;
 2967 
 2968                            IF    REC_LAYOUT.FIELD_ID < 23
 2969                               OR REC_LAYOUT.FIELD_ID = 26
 2970                            THEN
 2971                               BEGIN
 2972                                  LNCOUNTSTAGES :=   LNCOUNTSTAGES
 2973                                                   + 1;
 2974 
 2975                                  IF LNVALUETYPE = 2   
 2976                                  THEN
 2977                                     INSERT INTO SPECDATA_PROCESS
 2978                                                 ( REVISION,
 2979                                                   PART_NO,
 2980                                                   SECTION_ID,
 2981                                                   SUB_SECTION_ID,
 2982                                                   SECTION_REV,
 2983                                                   SUB_SECTION_REV,
 2984                                                   SEQUENCE_NO,
 2985                                                   TYPE,
 2986                                                   PLANT,
 2987                                                   LINE,
 2988                                                   CONFIGURATION,
 2989                                                   PROCESS_LINE_REV,
 2990                                                   STAGE,
 2991                                                   PROPERTY,
 2992                                                   ATTRIBUTE,
 2993                                                   STAGE_REV,
 2994                                                   PROPERTY_REV,
 2995                                                   ATTRIBUTE_REV,
 2996                                                   HEADER_ID,
 2997                                                   HEADER_REV,
 2998                                                   VALUE,
 2999                                                   VALUE_S,
 3000                                                   VALUE_DT,
 3001                                                   VALUE_TYPE,
 3002                                                   UOM_ID,
 3003                                                   TEST_METHOD,
 3004                                                   CHARACTERISTIC,
 3005                                                   ASSOCIATION,
 3006                                                   UOM_REV,
 3007                                                   TEST_METHOD_REV,
 3008                                                   CHARACTERISTIC_REV,
 3009                                                   ASSOCIATION_REV,
 3010                                                   REF_INFO,
 3011                                                   INTL )
 3012                                          VALUES ( ANREVISION,
 3013                                                   ASPARTNO,
 3014                                                   REC_SECTION.SECTION_ID,
 3015                                                   REC_SECTION.SUB_SECTION_ID,
 3016                                                   REC_SECTION.SECTION_REV,
 3017                                                   REC_SECTION.SUB_SECTION_REV,
 3018                                                   NVL( LNCOUNTSTAGES,
 3019                                                        0 ),
 3020                                                   REC_SECTION.TYPE,
 3021                                                   REC_PG.PLANT,
 3022                                                   REC_PG.LINE,
 3023                                                   NVL( REC_PG.CONFIGURATION,
 3024                                                        -1 ),
 3025                                                   NVL( REC_PG.PROCESS_LINE_REV,
 3026                                                        -1 ),
 3027                                                   NVL( REC_PG.STAGE,
 3028                                                        -1 ),
 3029                                                   NVL( REC_PG.PROPERTY,
 3030                                                        -1 ),
 3031                                                   NVL( REC_PG.ATTRIBUTE,
 3032                                                        -1 ),
 3033                                                   NVL( REC_PG.STAGE_REV,
 3034                                                        -1 ),
 3035                                                   NVL( REC_PG.PROPERTY_REV,
 3036                                                        -1 ),
 3037                                                   NVL( REC_PG.ATTRIBUTE_REV,
 3038                                                        -1 ),
 3039                                                   NVL( REC_LAYOUT.HEADER_ID,
 3040                                                        -1 ),
 3041                                                   NVL( REC_LAYOUT.HEADER_REV,
 3042                                                        -1 ),
 3043                                                   LNFLOATCOLUMN,
 3044                                                   LSCOLUMN,
 3045                                                   TO_DATE( LSCOLUMN,
 3046                                                            'dd-mm-yyyy hh24:mi:ss' ),
 3047                                                   NVL( LNVALUETYPE,
 3048                                                        0 ),
 3049                                                   NVL( REC_PG.UOM_ID,
 3050                                                        -1 ),
 3051                                                   DECODE( REC_PG.TEST_METHOD,
 3052                                                           0, -1,
 3053                                                           NVL( REC_PG.TEST_METHOD,
 3054                                                                -1 ) ),
 3055                                                   NVL( REC_PG.CHARACTERISTIC,
 3056                                                        -1 ),
 3057                                                   NVL( REC_PG.ASSOCIATION,
 3058                                                        -1 ),
 3059                                                   NVL( REC_PG.UOM_REV,
 3060                                                        -1 ),
 3061                                                   NVL( REC_PG.TEST_METHOD_REV,
 3062                                                        -1 ),
 3063                                                   NVL( REC_PG.CHARACTERISTIC_REV,
 3064                                                        -1 ),
 3065                                                   NVL( REC_PG.ASSOCIATION_REV,
 3066                                                        -1 ),
 3067                                                   NVL( REC_SECTION.REF_INFO,
 3068                                                        -1 ),
 3069                                                   NVL( REC_SECTION.INTL,
 3070                                                        -1 ) );
 3071                                  ELSE
 3072                                     INSERT INTO SPECDATA_PROCESS
 3073                                                 ( REVISION,
 3074                                                   PART_NO,
 3075                                                   SECTION_ID,
 3076                                                   SUB_SECTION_ID,
 3077                                                   SECTION_REV,
 3078                                                   SUB_SECTION_REV,
 3079                                                   SEQUENCE_NO,
 3080                                                   TYPE,
 3081                                                   PLANT,
 3082                                                   LINE,
 3083                                                   CONFIGURATION,
 3084                                                   PROCESS_LINE_REV,
 3085                                                   STAGE,
 3086                                                   PROPERTY,
 3087                                                   ATTRIBUTE,
 3088                                                   STAGE_REV,
 3089                                                   PROPERTY_REV,
 3090                                                   ATTRIBUTE_REV,
 3091                                                   HEADER_ID,
 3092                                                   HEADER_REV,
 3093                                                   VALUE,
 3094                                                   VALUE_S,
 3095                                                   VALUE_TYPE,
 3096                                                   UOM_ID,
 3097                                                   TEST_METHOD,
 3098                                                   CHARACTERISTIC,
 3099                                                   ASSOCIATION,
 3100                                                   UOM_REV,
 3101                                                   TEST_METHOD_REV,
 3102                                                   CHARACTERISTIC_REV,
 3103                                                   ASSOCIATION_REV,
 3104                                                   REF_INFO,
 3105                                                   INTL )
 3106                                          VALUES ( ANREVISION,
 3107                                                   ASPARTNO,
 3108                                                   REC_SECTION.SECTION_ID,
 3109                                                   REC_SECTION.SUB_SECTION_ID,
 3110                                                   REC_SECTION.SECTION_REV,
 3111                                                   REC_SECTION.SUB_SECTION_REV,
 3112                                                   NVL( LNCOUNTSTAGES,
 3113                                                        0 ),
 3114                                                   REC_SECTION.TYPE,
 3115                                                   REC_PG.PLANT,
 3116                                                   REC_PG.LINE,
 3117                                                   NVL( REC_PG.CONFIGURATION,
 3118                                                        -1 ),
 3119                                                   NVL( REC_PG.PROCESS_LINE_REV,
 3120                                                        -1 ),
 3121                                                   NVL( REC_PG.STAGE,
 3122                                                        -1 ),
 3123                                                   NVL( REC_PG.PROPERTY,
 3124                                                        -1 ),
 3125                                                   NVL( REC_PG.ATTRIBUTE,
 3126                                                        -1 ),
 3127                                                   NVL( REC_PG.STAGE_REV,
 3128                                                        -1 ),
 3129                                                   NVL( REC_PG.PROPERTY_REV,
 3130                                                        -1 ),
 3131                                                   NVL( REC_PG.ATTRIBUTE_REV,
 3132                                                        -1 ),
 3133                                                   NVL( REC_LAYOUT.HEADER_ID,
 3134                                                        -1 ),
 3135                                                   NVL( REC_LAYOUT.HEADER_REV,
 3136                                                        -1 ),
 3137                                                   LNFLOATCOLUMN,
 3138                                                   LSCOLUMN,
 3139                                                   NVL( LNVALUETYPE,
 3140                                                        0 ),
 3141                                                   NVL( REC_PG.UOM_ID,
 3142                                                        -1 ),
 3143                                                   DECODE( REC_PG.TEST_METHOD,
 3144                                                           0, -1,
 3145                                                           NVL( REC_PG.TEST_METHOD,
 3146                                                                -1 ) ),
 3147                                                   NVL( REC_PG.CHARACTERISTIC,
 3148                                                        -1 ),
 3149                                                   NVL( REC_PG.ASSOCIATION,
 3150                                                        -1 ),
 3151                                                   NVL( REC_PG.UOM_REV,
 3152                                                        -1 ),
 3153                                                   NVL( REC_PG.TEST_METHOD_REV,
 3154                                                        -1 ),
 3155                                                   NVL( REC_PG.CHARACTERISTIC_REV,
 3156                                                        -1 ),
 3157                                                   NVL( REC_PG.ASSOCIATION_REV,
 3158                                                        -1 ),
 3159                                                   NVL( REC_SECTION.REF_INFO,
 3160                                                        -1 ),
 3161                                                   NVL( REC_SECTION.INTL,
 3162                                                        -1 ) );
 3163 
 3164                                     
 3165                                     FOR REC_PG_LANG IN CUR_STAGE_PROP_LANG( ASPARTNO,
 3166                                                                             ANREVISION,
 3167                                                                             REC_PROCESS.PLANT,
 3168                                                                             REC_PROCESS.LINE,
 3169                                                                             REC_PROCESS.CONFIGURATION,
 3170                                                                             REC_STAGE.STAGE,
 3171                                                                             REC_PG.PROPERTY,
 3172                                                                             REC_PG.ATTRIBUTE,
 3173                                                                             REC_PG.SEQUENCE_NO )
 3174                                     LOOP
 3175                                        INSERT INTO SPECDATA_PROCESS
 3176                                                    ( REVISION,
 3177                                                      PART_NO,
 3178                                                      SECTION_ID,
 3179                                                      SUB_SECTION_ID,
 3180                                                      SECTION_REV,
 3181                                                      SUB_SECTION_REV,
 3182                                                      SEQUENCE_NO,
 3183                                                      TYPE,
 3184                                                      PLANT,
 3185                                                      LINE,
 3186                                                      CONFIGURATION,
 3187                                                      PROCESS_LINE_REV,
 3188                                                      STAGE,
 3189                                                      PROPERTY,
 3190                                                      ATTRIBUTE,
 3191                                                      STAGE_REV,
 3192                                                      PROPERTY_REV,
 3193                                                      ATTRIBUTE_REV,
 3194                                                      VALUE_S,
 3195                                                      VALUE_TYPE,
 3196                                                      REF_INFO,
 3197                                                      INTL,
 3198                                                      LANG_ID )
 3199                                             VALUES ( ANREVISION,
 3200                                                      ASPARTNO,
 3201                                                      REC_SECTION.SECTION_ID,
 3202                                                      REC_SECTION.SUB_SECTION_ID,
 3203                                                      REC_SECTION.SECTION_REV,
 3204                                                      REC_SECTION.SUB_SECTION_REV,
 3205                                                      NVL( LNCOUNTSTAGES,
 3206                                                           0 ),
 3207                                                      REC_SECTION.TYPE,
 3208                                                      REC_PG.PLANT,
 3209                                                      REC_PG.LINE,
 3210                                                      NVL( REC_PG.CONFIGURATION,
 3211                                                           -1 ),
 3212                                                      NVL( REC_PG.PROCESS_LINE_REV,
 3213                                                           -1 ),
 3214                                                      NVL( REC_PG.STAGE,
 3215                                                           -1 ),
 3216                                                      NVL( REC_PG.PROPERTY,
 3217                                                           -1 ),
 3218                                                      NVL( REC_PG.ATTRIBUTE,
 3219                                                           -1 ),
 3220                                                      NVL( REC_PG.STAGE_REV,
 3221                                                           -1 ),
 3222                                                      NVL( REC_PG.PROPERTY_REV,
 3223                                                           -1 ),
 3224                                                      NVL( REC_PG.ATTRIBUTE_REV,
 3225                                                           -1 ),
 3226                                                      LSCOLUMN,
 3227                                                      NVL( LNVALUETYPE,
 3228                                                           0 ),
 3229                                                      NVL( REC_SECTION.REF_INFO,
 3230                                                           -1 ),
 3231                                                      NVL( REC_SECTION.INTL,
 3232                                                           -1 ),
 3233                                                      REC_PG_LANG.LANG_ID );
 3234                                     END LOOP;
 3235                                  END IF;
 3236                               EXCEPTION
 3237                                  WHEN OTHERS
 3238                                  THEN
 3239                                     IAPIGENERAL.LOGERROR( GSSOURCE,
 3240                                                           LSMETHOD,
 3241                                                           SQLERRM );
 3242                                     DBMS_OUTPUT.PUT_LINE(    'stage info  '
 3243                                                           || LSCOLUMN
 3244                                                           || '    '
 3245                                                           || REC_LAYOUT.FIELD_ID );
 3246                                     RAISE_APPLICATION_ERROR( -20000,
 3247                                                              SQLERRM );
 3248                               END;
 3249                            END IF;
 3250                         END LOOP;   
 3251                      ELSIF REC_PG.VALUE_TYPE = 1   
 3252                      THEN
 3253                         BEGIN
 3254                            LNCOUNTSTAGES :=   LNCOUNTSTAGES
 3255                                             + 1;
 3256 
 3257                            INSERT INTO SPECDATA_PROCESS
 3258                                        ( REVISION,
 3259                                          PART_NO,
 3260                                          SECTION_ID,
 3261                                          SUB_SECTION_ID,
 3262                                          SECTION_REV,
 3263                                          SUB_SECTION_REV,
 3264                                          SEQUENCE_NO,
 3265                                          TYPE,
 3266                                          PLANT,
 3267                                          LINE,
 3268                                          CONFIGURATION,
 3269                                          PROCESS_LINE_REV,
 3270                                          STAGE,
 3271                                          PROPERTY,
 3272                                          ATTRIBUTE,
 3273                                          STAGE_REV,
 3274                                          PROPERTY_REV,
 3275                                          ATTRIBUTE_REV,
 3276                                          VALUE_S,
 3277                                          VALUE_TYPE,
 3278                                          REF_INFO,
 3279                                          INTL )
 3280                                 VALUES ( ANREVISION,
 3281                                          ASPARTNO,
 3282                                          REC_SECTION.SECTION_ID,
 3283                                          REC_SECTION.SUB_SECTION_ID,
 3284                                          REC_SECTION.SECTION_REV,
 3285                                          REC_SECTION.SUB_SECTION_REV,
 3286                                          NVL( LNCOUNTSTAGES,
 3287                                               0 ),
 3288                                          REC_SECTION.TYPE,
 3289                                          REC_PG.PLANT,
 3290                                          REC_PG.LINE,
 3291                                          NVL( REC_PG.CONFIGURATION,
 3292                                               -1 ),
 3293                                          NVL( REC_PG.PROCESS_LINE_REV,
 3294                                               -1 ),
 3295                                          NVL( REC_PG.STAGE,
 3296                                               -1 ),
 3297                                          NVL( REC_PG.PROPERTY,
 3298                                               -1 ),
 3299                                          NVL( REC_PG.ATTRIBUTE,
 3300                                               -1 ),
 3301                                          NVL( REC_PG.STAGE_REV,
 3302                                               -1 ),
 3303                                          NVL( REC_PG.PROPERTY_REV,
 3304                                               -1 ),
 3305                                          NVL( REC_PG.ATTRIBUTE_REV,
 3306                                               -1 ),
 3307                                          REC_PG.TEXT,
 3308                                          4,
 3309                                          NVL( REC_SECTION.REF_INFO,
 3310                                               -1 ),
 3311                                          NVL( REC_SECTION.INTL,
 3312                                               -1 ) );
 3313 
 3314                            
 3315                            FOR REC_PG_LANG IN CUR_STAGE_PROP_LANG( ASPARTNO,
 3316                                                                    ANREVISION,
 3317                                                                    REC_PROCESS.PLANT,
 3318                                                                    REC_PROCESS.LINE,
 3319                                                                    REC_PROCESS.CONFIGURATION,
 3320                                                                    REC_STAGE.STAGE,
 3321                                                                    REC_PG.PROPERTY,
 3322                                                                    REC_PG.ATTRIBUTE,
 3323                                                                    REC_PG.SEQUENCE_NO )
 3324                            LOOP
 3325                               INSERT INTO SPECDATA_PROCESS
 3326                                           ( REVISION,
 3327                                             PART_NO,
 3328                                             SECTION_ID,
 3329                                             SUB_SECTION_ID,
 3330                                             SECTION_REV,
 3331                                             SUB_SECTION_REV,
 3332                                             SEQUENCE_NO,
 3333                                             TYPE,
 3334                                             PLANT,
 3335                                             LINE,
 3336                                             CONFIGURATION,
 3337                                             PROCESS_LINE_REV,
 3338                                             STAGE,
 3339                                             PROPERTY,
 3340                                             ATTRIBUTE,
 3341                                             STAGE_REV,
 3342                                             PROPERTY_REV,
 3343                                             ATTRIBUTE_REV,
 3344                                             VALUE_S,
 3345                                             VALUE_TYPE,
 3346                                             REF_INFO,
 3347                                             INTL,
 3348                                             LANG_ID )
 3349                                    VALUES ( ANREVISION,
 3350                                             ASPARTNO,
 3351                                             REC_SECTION.SECTION_ID,
 3352                                             REC_SECTION.SUB_SECTION_ID,
 3353                                             REC_SECTION.SECTION_REV,
 3354                                             REC_SECTION.SUB_SECTION_REV,
 3355                                             NVL( LNCOUNTSTAGES,
 3356                                                  0 ),
 3357                                             REC_SECTION.TYPE,
 3358                                             REC_PG.PLANT,
 3359                                             REC_PG.LINE,
 3360                                             NVL( REC_PG.CONFIGURATION,
 3361                                                  -1 ),
 3362                                             NVL( REC_PG.PROCESS_LINE_REV,
 3363                                                  -1 ),
 3364                                             NVL( REC_PG.STAGE,
 3365                                                  -1 ),
 3366                                             NVL( REC_PG.PROPERTY,
 3367                                                  -1 ),
 3368                                             NVL( REC_PG.ATTRIBUTE,
 3369                                                  -1 ),
 3370                                             NVL( REC_PG.STAGE_REV,
 3371                                                  -1 ),
 3372                                             NVL( REC_PG.PROPERTY_REV,
 3373                                                  -1 ),
 3374                                             NVL( REC_PG.ATTRIBUTE_REV,
 3375                                                  -1 ),
 3376                                             REC_PG_LANG.TEXT,
 3377                                             4,
 3378                                             NVL( REC_SECTION.REF_INFO,
 3379                                                  -1 ),
 3380                                             NVL( REC_SECTION.INTL,
 3381                                                  -1 ),
 3382                                             REC_PG_LANG.LANG_ID );
 3383                            END LOOP;
 3384                         EXCEPTION
 3385                            WHEN OTHERS
 3386                            THEN
 3387                               IAPIGENERAL.LOGERROR( GSSOURCE,
 3388                                                     LSMETHOD,
 3389                                                     SQLERRM );
 3390                               RAISE_APPLICATION_ERROR( -20000,
 3391                                                        SQLERRM );
 3392                         END;
 3393                      ELSIF REC_PG.VALUE_TYPE = 2   
 3394                      THEN
 3395                         BEGIN
 3396                            LNCOUNTSTAGES :=   LNCOUNTSTAGES
 3397                                             + 1;
 3398 
 3399                            INSERT INTO SPECDATA_PROCESS
 3400                                        ( REVISION,
 3401                                          PART_NO,
 3402                                          SECTION_ID,
 3403                                          SUB_SECTION_ID,
 3404                                          SECTION_REV,
 3405                                          SUB_SECTION_REV,
 3406                                          SEQUENCE_NO,
 3407                                          TYPE,
 3408                                          PLANT,
 3409                                          LINE,
 3410                                          CONFIGURATION,
 3411                                          PROCESS_LINE_REV,
 3412                                          STAGE,
 3413                                          PROPERTY,
 3414                                          ATTRIBUTE,
 3415                                          STAGE_REV,
 3416                                          PROPERTY_REV,
 3417                                          ATTRIBUTE_REV,
 3418                                          VALUE_TYPE,
 3419                                          COMPONENT_PART,
 3420                                          QUANTITY,
 3421                                          REF_INFO,
 3422                                          INTL,
 3423                                          UOM )
 3424                                 VALUES ( ANREVISION,
 3425                                          ASPARTNO,
 3426                                          REC_SECTION.SECTION_ID,
 3427                                          REC_SECTION.SUB_SECTION_ID,
 3428                                          REC_SECTION.SECTION_REV,
 3429                                          REC_SECTION.SUB_SECTION_REV,
 3430                                          NVL( LNCOUNTSTAGES,
 3431                                               0 ),
 3432                                          REC_SECTION.TYPE,
 3433                                          REC_PG.PLANT,
 3434                                          REC_PG.LINE,
 3435                                          NVL( REC_PG.CONFIGURATION,
 3436                                               -1 ),
 3437                                          NVL( REC_PG.PROCESS_LINE_REV,
 3438                                               -1 ),
 3439                                          NVL( REC_PG.STAGE,
 3440                                               -1 ),
 3441                                          NVL( REC_PG.PROPERTY,
 3442                                               -1 ),
 3443                                          NVL( REC_PG.ATTRIBUTE,
 3444                                               -1 ),
 3445                                          NVL( REC_PG.STAGE_REV,
 3446                                               -1 ),
 3447                                          NVL( REC_PG.PROPERTY_REV,
 3448                                               -1 ),
 3449                                          NVL( REC_PG.ATTRIBUTE_REV,
 3450                                               -1 ),
 3451                                          NVL( REC_PG.VALUE_TYPE,
 3452                                               0 ),
 3453                                          REC_PG.COMPONENT_PART,
 3454                                          NVL( REC_PG.QUANTITY,
 3455                                               0 ),
 3456                                          NVL( REC_SECTION.REF_INFO,
 3457                                               -1 ),
 3458                                          NVL( REC_SECTION.INTL,
 3459                                               -1 ),
 3460                                          REC_PG.UOM );
 3461                         EXCEPTION
 3462                            WHEN OTHERS
 3463                            THEN
 3464                               IAPIGENERAL.LOGERROR( GSSOURCE,
 3465                                                     LSMETHOD,
 3466                                                     SQLERRM );
 3467                               RAISE_APPLICATION_ERROR( -20000,
 3468                                                        SQLERRM );
 3469                         END;
 3470                      END IF;
 3471                   END LOOP;   
 3472                END LOOP;   
 3473             END LOOP;   
 3474 
 3475             LSCOLUMN := 'Process Data';
 3476 
 3477             BEGIN
 3478                LNCOUNTER :=   LNCOUNTER
 3479                             + 1;
 3480 
 3481                INSERT INTO SPECDATA
 3482                            ( REVISION,
 3483                              PART_NO,
 3484                              SECTION_ID,
 3485                              SUB_SECTION_ID,
 3486                              SECTION_REV,
 3487                              SUB_SECTION_REV,
 3488                              SEQUENCE_NO,
 3489                              TYPE,
 3490                              REF_ID,
 3491                              REF_VER,
 3492                              VALUE,
 3493                              VALUE_S,
 3494                              REF_INFO,
 3495                              INTL )
 3496                     VALUES ( ANREVISION,
 3497                              ASPARTNO,
 3498                              REC_SECTION.SECTION_ID,
 3499                              REC_SECTION.SUB_SECTION_ID,
 3500                              REC_SECTION.SECTION_REV,
 3501                              REC_SECTION.SUB_SECTION_REV,
 3502                              NVL( LNCOUNTER,
 3503                                   0 ),
 3504                              REC_SECTION.TYPE,
 3505                              NVL( REC_SECTION.REF_ID,
 3506                                   -1 ),
 3507                              NVL( REC_SECTION.REF_VER,
 3508                                   -1 ),
 3509                              NVL( REC_SECTION.REF_ID,
 3510                                   -1 ),
 3511                              LSCOLUMN,
 3512                              NVL( REC_SECTION.REF_INFO,
 3513                                   -1 ),
 3514                              NVL( REC_SECTION.INTL,
 3515                                   -1 ) );
 3516             EXCEPTION
 3517                WHEN OTHERS
 3518                THEN
 3519                   IAPIGENERAL.LOGERROR( GSSOURCE,
 3520                                         LSMETHOD,
 3521                                         SQLERRM );
 3522                   RAISE_APPLICATION_ERROR( -20000,
 3523                                            SQLERRM );
 3524             END;
 3525          END IF;
 3526       END LOOP;
 3527    END CONVERTSPECIFICATION;
 3528 
 3529    PROCEDURE CONVERTFRAME(
 3530       ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
 3531       ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
 3532       ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
 3533    IS
 3534 
 3535 
 3536 
 3537 
 3538 
 3539 
 3540 
 3541 
 3542 
 3543       LSCOLUMN                      VARCHAR2( 256 );
 3544       LNFLOATCOLUMN                 NUMBER;
 3545       LDDATECOLUMN                  DATE;
 3546       LNRESULT                      INTEGER;
 3547       LNVALUETYPE                   FRAMEDATA.VALUE_TYPE%TYPE;
 3548       LNCOUNTER                     NUMBER;
 3549       LBDATA                        BOOLEAN;
 3550       LNLAYOUTREVISION              IAPITYPE.REVISION_TYPE;
 3551       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ConvertFrame';
 3552 
 3553       CURSOR CUR_SECTION(
 3554          P_FRAME_NO                          IAPITYPE.FRAMENO_TYPE,
 3555          P_REVISION                          IAPITYPE.REVISION_TYPE,
 3556          P_OWNER                             IAPITYPE.OWNER_TYPE )
 3557       IS
 3558          SELECT   *
 3559              FROM FRAME_SECTION
 3560             WHERE FRAME_NO = P_FRAME_NO
 3561               AND REVISION = P_REVISION
 3562               AND OWNER = P_OWNER
 3563          ORDER BY SECTION_SEQUENCE_NO;
 3564 
 3565 
 3566 
 3567 
 3568 
 3569       CURSOR CUR_LAYOUT(
 3570          P_LAYOUT_ID                         IAPITYPE.ID_TYPE,
 3571          P_LAYOUT_REV                        IAPITYPE.REVISION_TYPE )
 3572       IS
 3573          SELECT *
 3574            FROM PROPERTY_LAYOUT
 3575           WHERE LAYOUT_ID = P_LAYOUT_ID
 3576             AND REVISION = P_LAYOUT_REV;
 3577 
 3578 
 3579 
 3580 
 3581       CURSOR CUR_PROPERTY_GROUP(
 3582          P_FRAME_NO                          IAPITYPE.FRAMENO_TYPE,
 3583          P_REVISION                          IAPITYPE.REVISION_TYPE,
 3584          P_OWNER                             IAPITYPE.OWNER_TYPE,
 3585          P_SECTION                           IAPITYPE.ID_TYPE,
 3586          P_SUB_SECTION                       IAPITYPE.ID_TYPE,
 3587          P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE )
 3588       IS
 3589          SELECT   *
 3590              FROM FRAME_PROP
 3591             WHERE FRAME_NO = P_FRAME_NO
 3592               AND REVISION = P_REVISION
 3593               AND OWNER = P_OWNER
 3594               AND SECTION_ID = P_SECTION
 3595               AND SUB_SECTION_ID = P_SUB_SECTION
 3596               AND PROPERTY_GROUP = P_PROPERTY_GROUP
 3597          ORDER BY SEQUENCE_NO;
 3598 
 3599 
 3600 
 3601 
 3602       CURSOR CUR_PROPERTY(
 3603          P_FRAME_NO                          IAPITYPE.FRAMENO_TYPE,
 3604          P_REVISION                          IAPITYPE.REVISION_TYPE,
 3605          P_OWNER                             IAPITYPE.OWNER_TYPE,
 3606          P_SECTION                           IAPITYPE.ID_TYPE,
 3607          P_SUB_SECTION                       IAPITYPE.ID_TYPE,
 3608          P_PROPERTY                          IAPITYPE.ID_TYPE )
 3609       IS
 3610          SELECT   *
 3611              FROM FRAME_PROP
 3612             WHERE FRAME_NO = P_FRAME_NO
 3613               AND REVISION = P_REVISION
 3614               AND OWNER = P_OWNER
 3615               AND SECTION_ID = P_SECTION
 3616               AND SUB_SECTION_ID = P_SUB_SECTION
 3617               AND PROPERTY_GROUP = 0
 3618               AND PROPERTY = P_PROPERTY
 3619          ORDER BY SEQUENCE_NO;
 3620 
 3621 
 3622 
 3623 
 3624       CURSOR CUR_BOOLEAN
 3625       IS
 3626          SELECT *
 3627            FROM FRAME_SECTION
 3628           WHERE FRAME_NO = ASFRAMENO
 3629             AND REVISION = ANREVISION
 3630             AND OWNER = ANOWNER
 3631             AND TYPE IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY );
 3632    BEGIN
 3633       
 3634       
 3635       
 3636       IAPIGENERAL.LOGINFO( GSSOURCE,
 3637                            LSMETHOD,
 3638                            'Body of FUNCTION',
 3639                            IAPICONSTANT.INFOLEVEL_3 );
 3640       LNCOUNTER := 1;
 3641 
 3642 
 3643 
 3644 
 3645 
 3646       BEGIN
 3647 
 3648          DELETE FROM FRAMEDATA
 3649                WHERE FRAME_NO = ASFRAMENO
 3650                  AND REVISION = ANREVISION
 3651                  AND OWNER = ANOWNER;
 3652       EXCEPTION
 3653          WHEN OTHERS
 3654          THEN
 3655             IAPIGENERAL.LOGERROR( GSSOURCE,
 3656                                   LSMETHOD,
 3657                                   SQLERRM );
 3658             RAISE_APPLICATION_ERROR( -20000,
 3659                                      SQLERRM );
 3660       END;
 3661 
 3662 
 3663 
 3664 
 3665 
 3666       FOR REC_SECTION IN CUR_SECTION( ASFRAMENO,
 3667                                       ANREVISION,
 3668                                       ANOWNER )
 3669       LOOP
 3670          LBDATA := FALSE;
 3671 
 3672 
 3673 
 3674 
 3675          IF REC_SECTION.TYPE = 1
 3676          THEN   
 3677             FOR REC_PG IN CUR_PROPERTY_GROUP( ASFRAMENO,
 3678                                               ANREVISION,
 3679                                               ANOWNER,
 3680                                               REC_SECTION.SECTION_ID,
 3681                                               REC_SECTION.SUB_SECTION_ID,
 3682                                               REC_SECTION.REF_ID )
 3683             LOOP
 3684                LBDATA := TRUE;
 3685 
 3686                IF REC_SECTION.DISPLAY_FORMAT_REV = 0
 3687                THEN
 3688                   SELECT MAX( REVISION )
 3689                     INTO LNLAYOUTREVISION
 3690                     FROM LAYOUT
 3691                    WHERE LAYOUT_ID = REC_SECTION.DISPLAY_FORMAT
 3692                      AND STATUS = 2;
 3693                ELSE
 3694                   LNLAYOUTREVISION := REC_SECTION.DISPLAY_FORMAT_REV;
 3695                END IF;
 3696 
 3697                FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
 3698                                              LNLAYOUTREVISION )
 3699                LOOP
 3700                   LSCOLUMN := '';
 3701                   LDDATECOLUMN := NULL;
 3702 
 3703                   IF REC_LAYOUT.FIELD_ID = 1
 3704                   THEN
 3705                      LNFLOATCOLUMN := REC_PG.NUM_1;
 3706                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
 3707                      LNVALUETYPE := 0;
 3708                   ELSIF REC_LAYOUT.FIELD_ID = 2
 3709                   THEN
 3710                      LNFLOATCOLUMN := REC_PG.NUM_2;
 3711                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
 3712                      LNVALUETYPE := 0;
 3713                   ELSIF REC_LAYOUT.FIELD_ID = 3
 3714                   THEN
 3715                      LNFLOATCOLUMN := REC_PG.NUM_3;
 3716                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
 3717                      LNVALUETYPE := 0;
 3718                   ELSIF REC_LAYOUT.FIELD_ID = 4
 3719                   THEN
 3720                      LNFLOATCOLUMN := REC_PG.NUM_4;
 3721                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
 3722                      LNVALUETYPE := 0;
 3723                   ELSIF REC_LAYOUT.FIELD_ID = 5
 3724                   THEN
 3725                      LNFLOATCOLUMN := REC_PG.NUM_5;
 3726                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
 3727                      LNVALUETYPE := 0;
 3728                   ELSIF REC_LAYOUT.FIELD_ID = 6
 3729                   THEN
 3730                      LNFLOATCOLUMN := REC_PG.NUM_6;
 3731                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
 3732                      LNVALUETYPE := 0;
 3733                   ELSIF REC_LAYOUT.FIELD_ID = 7
 3734                   THEN
 3735                      LNFLOATCOLUMN := REC_PG.NUM_7;
 3736                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
 3737                      LNVALUETYPE := 0;
 3738                   ELSIF REC_LAYOUT.FIELD_ID = 8
 3739                   THEN
 3740                      LNFLOATCOLUMN := REC_PG.NUM_8;
 3741                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
 3742                      LNVALUETYPE := 0;
 3743                   ELSIF REC_LAYOUT.FIELD_ID = 9
 3744                   THEN
 3745                      LNFLOATCOLUMN := REC_PG.NUM_9;
 3746                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
 3747                      LNVALUETYPE := 0;
 3748                   ELSIF REC_LAYOUT.FIELD_ID = 10
 3749                   THEN
 3750                      LNFLOATCOLUMN := REC_PG.NUM_10;
 3751                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
 3752                      LNVALUETYPE := 0;
 3753                   ELSIF REC_LAYOUT.FIELD_ID = 11
 3754                   THEN
 3755                      LNFLOATCOLUMN := 0;
 3756                      LSCOLUMN := REC_PG.CHAR_1;
 3757                      LNVALUETYPE := 1;
 3758                   ELSIF REC_LAYOUT.FIELD_ID = 12
 3759                   THEN
 3760                      LNFLOATCOLUMN := 0;
 3761                      LSCOLUMN := REC_PG.CHAR_2;
 3762                      LNVALUETYPE := 1;
 3763                   ELSIF REC_LAYOUT.FIELD_ID = 13
 3764                   THEN
 3765                      LNFLOATCOLUMN := 0;
 3766                      LSCOLUMN := REC_PG.CHAR_3;
 3767                      LNVALUETYPE := 1;
 3768                   ELSIF REC_LAYOUT.FIELD_ID = 14
 3769                   THEN
 3770                      LNFLOATCOLUMN := 0;
 3771                      LSCOLUMN := REC_PG.CHAR_4;
 3772                      LNVALUETYPE := 1;
 3773                   ELSIF REC_LAYOUT.FIELD_ID = 15
 3774                   THEN
 3775                      LNFLOATCOLUMN := 0;
 3776                      LSCOLUMN := REC_PG.CHAR_5;
 3777                      LNVALUETYPE := 1;
 3778                   ELSIF REC_LAYOUT.FIELD_ID = 16
 3779                   THEN
 3780                      LNFLOATCOLUMN := 0;
 3781                      LSCOLUMN := REC_PG.CHAR_6;
 3782                      LNVALUETYPE := 1;
 3783                   ELSIF REC_LAYOUT.FIELD_ID = 17
 3784                   THEN
 3785                      LNFLOATCOLUMN := 0;
 3786                      LSCOLUMN := REC_PG.BOOLEAN_1;
 3787 
 3788                      IF LSCOLUMN IS NULL
 3789                      THEN
 3790                         LSCOLUMN := 'N';
 3791                      END IF;
 3792 
 3793                      LNVALUETYPE := 1;
 3794                   ELSIF REC_LAYOUT.FIELD_ID = 18
 3795                   THEN
 3796                      LNFLOATCOLUMN := 0;
 3797                      LSCOLUMN := REC_PG.BOOLEAN_2;
 3798 
 3799                      IF LSCOLUMN IS NULL
 3800                      THEN
 3801                         LSCOLUMN := 'N';
 3802                      END IF;
 3803 
 3804                      LNVALUETYPE := 1;
 3805                   ELSIF REC_LAYOUT.FIELD_ID = 19
 3806                   THEN
 3807                      LNFLOATCOLUMN := 0;
 3808                      LSCOLUMN := REC_PG.BOOLEAN_3;
 3809 
 3810                      IF LSCOLUMN IS NULL
 3811                      THEN
 3812                         LSCOLUMN := 'N';
 3813                      END IF;
 3814 
 3815                      LNVALUETYPE := 1;
 3816                   ELSIF REC_LAYOUT.FIELD_ID = 20
 3817                   THEN
 3818                      LNFLOATCOLUMN := 0;
 3819                      LSCOLUMN := REC_PG.BOOLEAN_4;
 3820 
 3821                      IF LSCOLUMN IS NULL
 3822                      THEN
 3823                         LSCOLUMN := 'N';
 3824                      END IF;
 3825 
 3826                      LNVALUETYPE := 1;
 3827                   ELSIF REC_LAYOUT.FIELD_ID = 21
 3828                   THEN
 3829                      LNFLOATCOLUMN := 0;
 3830                      LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
 3831                                           'dd-mm-yyyy hh24:mi:ss' );
 3832                      LDDATECOLUMN := REC_PG.DATE_1;
 3833 
 3834                      IF LDDATECOLUMN IS NULL
 3835                      THEN
 3836                         LNVALUETYPE := 1;
 3837                      ELSE
 3838                         LNVALUETYPE := 2;
 3839                      END IF;
 3840                   ELSIF REC_LAYOUT.FIELD_ID = 22
 3841                   THEN
 3842                      LNFLOATCOLUMN := 0;
 3843                      LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
 3844                                           'dd-mm-yyyy hh24:mi:ss' );
 3845                      LDDATECOLUMN := REC_PG.DATE_2;
 3846 
 3847                      IF LDDATECOLUMN IS NULL
 3848                      THEN
 3849                         LNVALUETYPE := 1;
 3850                      ELSE
 3851                         LNVALUETYPE := 2;
 3852                      END IF;
 3853                   ELSIF REC_LAYOUT.FIELD_ID = 26
 3854                   THEN
 3855                      LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
 3856                      LSCOLUMN := F_CHH_DESCR( 1,
 3857                                               REC_PG.CHARACTERISTIC,
 3858                                               0 );
 3859                      LNVALUETYPE := 0;
 3860 
 3861                   ELSIF REC_LAYOUT.FIELD_ID = 30
 3862                   THEN
 3863                      LNFLOATCOLUMN := REC_PG.CH_2;
 3864                      LSCOLUMN := F_CHH_DESCR( 1,
 3865                                               REC_PG.CH_2,
 3866                                               0 );
 3867                      LNVALUETYPE := 0;
 3868 
 3869                   ELSIF REC_LAYOUT.FIELD_ID = 31
 3870                   THEN
 3871                      LNFLOATCOLUMN := REC_PG.CH_3;
 3872                      LSCOLUMN := F_CHH_DESCR( 1,
 3873                                               REC_PG.CH_3,
 3874                                               0 );
 3875                      LNVALUETYPE := 0;
 3876 
 3877                   END IF;
 3878 
 3879                   IF    REC_LAYOUT.FIELD_ID < 23
 3880                      OR REC_LAYOUT.FIELD_ID = 26
 3881                      OR REC_LAYOUT.FIELD_ID = 30
 3882                      OR REC_LAYOUT.FIELD_ID = 31
 3883                   THEN
 3884                      BEGIN
 3885                         LNCOUNTER :=   LNCOUNTER
 3886                                      + 1;
 3887 
 3888                         IF LNVALUETYPE = 2
 3889                         THEN
 3890                            INSERT INTO FRAMEDATA
 3891                                        ( REVISION,
 3892                                          FRAME_NO,
 3893                                          OWNER,
 3894                                          SECTION_ID,
 3895                                          SUB_SECTION_ID,
 3896                                          SECTION_REV,
 3897                                          SUB_SECTION_REV,
 3898                                          SEQUENCE_NO,
 3899                                          TYPE,
 3900                                          REF_ID,
 3901                                          REF_VER,
 3902                                          PROPERTY_GROUP,
 3903                                          PROPERTY,
 3904                                          ATTRIBUTE,
 3905                                          PROPERTY_GROUP_REV,
 3906                                          PROPERTY_REV,
 3907                                          ATTRIBUTE_REV,
 3908                                          HEADER_ID,
 3909                                          HEADER_REV,
 3910                                          VALUE,
 3911                                          VALUE_S,
 3912                                          VALUE_DT,
 3913                                          VALUE_TYPE,
 3914                                          UOM_ID,
 3915                                          TEST_METHOD,
 3916                                          CHARACTERISTIC,
 3917                                          ASSOCIATION,
 3918                                          UOM_REV,
 3919                                          TEST_METHOD_REV,
 3920                                          CHARACTERISTIC_REV,
 3921                                          ASSOCIATION_REV,
 3922                                          REF_INFO,
 3923                                          INTL )
 3924                                 VALUES ( ANREVISION,
 3925                                          ASFRAMENO,
 3926                                          ANOWNER,
 3927                                          REC_SECTION.SECTION_ID,
 3928                                          REC_SECTION.SUB_SECTION_ID,
 3929                                          REC_SECTION.SECTION_REV,
 3930                                          REC_SECTION.SUB_SECTION_REV,
 3931                                          NVL( LNCOUNTER,
 3932                                               0 ),
 3933                                          REC_SECTION.TYPE,
 3934                                          NVL( REC_SECTION.REF_ID,
 3935                                               -1 ),
 3936                                          NVL( REC_SECTION.REF_VER,
 3937                                               -1 ),
 3938                                          NVL( REC_PG.PROPERTY_GROUP,
 3939                                               -1 ),
 3940                                          NVL( REC_PG.PROPERTY,
 3941                                               -1 ),
 3942                                          NVL( REC_PG.ATTRIBUTE,
 3943                                               -1 ),
 3944                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 3945                                               -1 ),
 3946                                          NVL( REC_PG.PROPERTY_REV,
 3947                                               -1 ),
 3948                                          NVL( REC_PG.ATTRIBUTE_REV,
 3949                                               -1 ),
 3950                                          NVL( REC_LAYOUT.HEADER_ID,
 3951                                               -1 ),
 3952                                          NVL( REC_LAYOUT.HEADER_REV,
 3953                                               -1 ),
 3954                                          NVL( LNFLOATCOLUMN,
 3955                                               0 ),
 3956                                          LSCOLUMN,
 3957                                          TO_DATE( LSCOLUMN,
 3958                                                   'dd-mm-yyyy hh24:mi:ss' ),
 3959                                          NVL( LNVALUETYPE,
 3960                                               0 ),
 3961                                          NVL( REC_PG.UOM_ID,
 3962                                               -1 ),
 3963                                          DECODE( REC_PG.TEST_METHOD,
 3964                                                  0, -1,
 3965                                                  NVL( REC_PG.TEST_METHOD,
 3966                                                       -1 ) ),
 3967                                          NVL( REC_PG.CHARACTERISTIC,
 3968                                               -1 ),
 3969                                          NVL( REC_PG.ASSOCIATION,
 3970                                               -1 ),
 3971                                          NVL( REC_PG.UOM_REV,
 3972                                               -1 ),
 3973                                          NVL( REC_PG.TEST_METHOD_REV,
 3974                                               -1 ),
 3975                                          NVL( REC_PG.CHARACTERISTIC_REV,
 3976                                               -1 ),
 3977                                          NVL( REC_PG.ASSOCIATION_REV,
 3978                                               -1 ),
 3979                                          NVL( REC_SECTION.REF_INFO,
 3980                                               -1 ),
 3981                                          NVL( REC_SECTION.INTL,
 3982                                               -1 ) );
 3983                         ELSE
 3984                            INSERT INTO FRAMEDATA
 3985                                        ( REVISION,
 3986                                          FRAME_NO,
 3987                                          OWNER,
 3988                                          SECTION_ID,
 3989                                          SUB_SECTION_ID,
 3990                                          SECTION_REV,
 3991                                          SUB_SECTION_REV,
 3992                                          SEQUENCE_NO,
 3993                                          TYPE,
 3994                                          REF_ID,
 3995                                          REF_VER,
 3996                                          PROPERTY_GROUP,
 3997                                          PROPERTY,
 3998                                          ATTRIBUTE,
 3999                                          PROPERTY_GROUP_REV,
 4000                                          PROPERTY_REV,
 4001                                          ATTRIBUTE_REV,
 4002                                          HEADER_ID,
 4003                                          HEADER_REV,
 4004                                          VALUE,
 4005                                          VALUE_S,
 4006                                          VALUE_TYPE,
 4007                                          UOM_ID,
 4008                                          TEST_METHOD,
 4009                                          CHARACTERISTIC,
 4010                                          ASSOCIATION,
 4011                                          UOM_REV,
 4012                                          TEST_METHOD_REV,
 4013                                          CHARACTERISTIC_REV,
 4014                                          ASSOCIATION_REV,
 4015                                          REF_INFO,
 4016                                          INTL )
 4017                                 VALUES ( ANREVISION,
 4018                                          ASFRAMENO,
 4019                                          ANOWNER,
 4020                                          REC_SECTION.SECTION_ID,
 4021                                          REC_SECTION.SUB_SECTION_ID,
 4022                                          REC_SECTION.SECTION_REV,
 4023                                          REC_SECTION.SUB_SECTION_REV,
 4024                                          NVL( LNCOUNTER,
 4025                                               0 ),
 4026                                          REC_SECTION.TYPE,
 4027                                          NVL( REC_SECTION.REF_ID,
 4028                                               -1 ),
 4029                                          NVL( REC_SECTION.REF_VER,
 4030                                               -1 ),
 4031                                          NVL( REC_PG.PROPERTY_GROUP,
 4032                                               -1 ),
 4033                                          NVL( REC_PG.PROPERTY,
 4034                                               -1 ),
 4035                                          NVL( REC_PG.ATTRIBUTE,
 4036                                               -1 ),
 4037                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 4038                                               -1 ),
 4039                                          NVL( REC_PG.PROPERTY_REV,
 4040                                               -1 ),
 4041                                          NVL( REC_PG.ATTRIBUTE_REV,
 4042                                               -1 ),
 4043                                          NVL( REC_LAYOUT.HEADER_ID,
 4044                                               -1 ),
 4045                                          NVL( REC_LAYOUT.HEADER_REV,
 4046                                               -1 ),
 4047                                          LNFLOATCOLUMN,
 4048                                          LSCOLUMN,
 4049                                          NVL( LNVALUETYPE,
 4050                                               0 ),
 4051                                          NVL( REC_PG.UOM_ID,
 4052                                               -1 ),
 4053                                          NVL( REC_PG.TEST_METHOD,
 4054                                               -1 ),
 4055                                          NVL( REC_PG.CHARACTERISTIC,
 4056                                               -1 ),
 4057                                          NVL( REC_PG.ASSOCIATION,
 4058                                               -1 ),
 4059                                          NVL( REC_PG.UOM_REV,
 4060                                               -1 ),
 4061                                          NVL( REC_PG.TEST_METHOD_REV,
 4062                                               -1 ),
 4063                                          NVL( REC_PG.CHARACTERISTIC_REV,
 4064                                               -1 ),
 4065                                          NVL( REC_PG.ASSOCIATION_REV,
 4066                                               -1 ),
 4067                                          NVL( REC_SECTION.REF_INFO,
 4068                                               -1 ),
 4069                                          NVL( REC_SECTION.INTL,
 4070                                               -1 ) );
 4071                         END IF;
 4072                      EXCEPTION
 4073                         WHEN OTHERS
 4074                         THEN
 4075                            IAPIGENERAL.LOGERROR( GSSOURCE,
 4076                                                  LSMETHOD,
 4077                                                  SQLERRM );
 4078                            DBMS_OUTPUT.PUT_LINE(    'PG info  '
 4079                                                  || LSCOLUMN
 4080                                                  || '    '
 4081                                                  || REC_LAYOUT.FIELD_ID );
 4082                            RAISE_APPLICATION_ERROR( -20000,
 4083                                                     SQLERRM );
 4084                      END;
 4085                   END IF;
 4086                END LOOP;
 4087             END LOOP;
 4088 
 4089             IF NOT( LBDATA )
 4090             THEN
 4091 
 4092 	     
 4093              
 4094              LSCOLUMN := '';
 4095 
 4096                BEGIN
 4097                   LNCOUNTER :=   LNCOUNTER
 4098                                + 1;
 4099 
 4100                   INSERT INTO FRAMEDATA
 4101                               ( REVISION,
 4102                                 FRAME_NO,
 4103                                 OWNER,
 4104                                 SECTION_ID,
 4105                                 SUB_SECTION_ID,
 4106                                 SECTION_REV,
 4107                                 SUB_SECTION_REV,
 4108                                 SEQUENCE_NO,
 4109                                 TYPE,
 4110                                 REF_ID,
 4111                                 REF_VER,
 4112                                 REF_OWNER,
 4113                                 PROPERTY_GROUP,
 4114                                 VALUE_S,
 4115                                 REF_INFO,
 4116                                 INTL )
 4117                        VALUES ( ANREVISION,
 4118                                 ASFRAMENO,
 4119                                 ANOWNER,
 4120                                 REC_SECTION.SECTION_ID,
 4121                                 REC_SECTION.SUB_SECTION_ID,
 4122                                 REC_SECTION.SECTION_REV,
 4123                                 REC_SECTION.SUB_SECTION_REV,
 4124                                 NVL( LNCOUNTER,
 4125                                      0 ),
 4126                                 REC_SECTION.TYPE,
 4127                                 NVL( REC_SECTION.REF_ID,
 4128                                      -1 ),
 4129                                 NVL( REC_SECTION.REF_VER,
 4130                                      -1 ),
 4131                                 NVL( REC_SECTION.REF_OWNER,
 4132                                      -1 ),
 4133                                 NVL( REC_SECTION.REF_ID,
 4134                                      -1 ),
 4135                                 LSCOLUMN,
 4136                                 NVL( REC_SECTION.REF_INFO,
 4137                                      -1 ),
 4138                                 NVL( REC_SECTION.INTL,
 4139                                      -1 ) );
 4140                EXCEPTION
 4141                   WHEN OTHERS
 4142                   THEN
 4143                      DBMS_OUTPUT.PUT_LINE(    ' 2'
 4144                                            || SQLERRM );
 4145                      RAISE_APPLICATION_ERROR( -20000,
 4146                                               SQLERRM );
 4147                END;
 4148             END IF;
 4149          ELSIF REC_SECTION.TYPE = 4
 4150          THEN
 4151 
 4152             FOR REC_PG IN CUR_PROPERTY( ASFRAMENO,
 4153                                         ANREVISION,
 4154                                         ANOWNER,
 4155                                         REC_SECTION.SECTION_ID,
 4156                                         REC_SECTION.SUB_SECTION_ID,
 4157                                         REC_SECTION.REF_ID )
 4158             LOOP
 4159                IF REC_SECTION.DISPLAY_FORMAT_REV = 0
 4160                THEN
 4161                   SELECT MAX( REVISION )
 4162                     INTO LNLAYOUTREVISION
 4163                     FROM LAYOUT
 4164                    WHERE LAYOUT_ID = REC_SECTION.DISPLAY_FORMAT
 4165                      AND STATUS = 2;
 4166                ELSE
 4167                   LNLAYOUTREVISION := REC_SECTION.DISPLAY_FORMAT_REV;
 4168                END IF;
 4169 
 4170                FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
 4171                                              LNLAYOUTREVISION )
 4172                LOOP
 4173                   LSCOLUMN := '';
 4174                   LDDATECOLUMN := NULL;
 4175 
 4176                   IF REC_LAYOUT.FIELD_ID = 1
 4177                   THEN
 4178                      LNFLOATCOLUMN := REC_PG.NUM_1;
 4179                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
 4180                      LNVALUETYPE := 0;
 4181                   ELSIF REC_LAYOUT.FIELD_ID = 2
 4182                   THEN
 4183                      LNFLOATCOLUMN := REC_PG.NUM_2;
 4184                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
 4185                      LNVALUETYPE := 0;
 4186                   ELSIF REC_LAYOUT.FIELD_ID = 3
 4187                   THEN
 4188                      LNFLOATCOLUMN := REC_PG.NUM_3;
 4189                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
 4190                      LNVALUETYPE := 0;
 4191                   ELSIF REC_LAYOUT.FIELD_ID = 4
 4192                   THEN
 4193                      LNFLOATCOLUMN := REC_PG.NUM_4;
 4194                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
 4195                      LNVALUETYPE := 0;
 4196                   ELSIF REC_LAYOUT.FIELD_ID = 5
 4197                   THEN
 4198                      LNFLOATCOLUMN := REC_PG.NUM_5;
 4199                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
 4200                      LNVALUETYPE := 0;
 4201                   ELSIF REC_LAYOUT.FIELD_ID = 6
 4202                   THEN
 4203                      LNFLOATCOLUMN := REC_PG.NUM_6;
 4204                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
 4205                      LNVALUETYPE := 0;
 4206                   ELSIF REC_LAYOUT.FIELD_ID = 7
 4207                   THEN
 4208                      LNFLOATCOLUMN := REC_PG.NUM_7;
 4209                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
 4210                      LNVALUETYPE := 0;
 4211                   ELSIF REC_LAYOUT.FIELD_ID = 8
 4212                   THEN
 4213                      LNFLOATCOLUMN := REC_PG.NUM_8;
 4214                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
 4215                      LNVALUETYPE := 0;
 4216                   ELSIF REC_LAYOUT.FIELD_ID = 9
 4217                   THEN
 4218                      LNFLOATCOLUMN := REC_PG.NUM_9;
 4219                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
 4220                      LNVALUETYPE := 0;
 4221                   ELSIF REC_LAYOUT.FIELD_ID = 10
 4222                   THEN
 4223                      LNFLOATCOLUMN := REC_PG.NUM_10;
 4224                      LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
 4225                      LNVALUETYPE := 0;
 4226                   ELSIF REC_LAYOUT.FIELD_ID = 11
 4227                   THEN
 4228                      LNFLOATCOLUMN := 0;
 4229                      LSCOLUMN := REC_PG.CHAR_1;
 4230                      LNVALUETYPE := 1;
 4231                   ELSIF REC_LAYOUT.FIELD_ID = 12
 4232                   THEN
 4233                      LNFLOATCOLUMN := 0;
 4234                      LSCOLUMN := REC_PG.CHAR_2;
 4235                      LNVALUETYPE := 1;
 4236                   ELSIF REC_LAYOUT.FIELD_ID = 13
 4237                   THEN
 4238                      LNFLOATCOLUMN := 0;
 4239                      LSCOLUMN := REC_PG.CHAR_3;
 4240                      LNVALUETYPE := 1;
 4241                   ELSIF REC_LAYOUT.FIELD_ID = 14
 4242                   THEN
 4243                      LNFLOATCOLUMN := 0;
 4244                      LSCOLUMN := REC_PG.CHAR_4;
 4245                      LNVALUETYPE := 1;
 4246                   ELSIF REC_LAYOUT.FIELD_ID = 15
 4247                   THEN
 4248                      LNFLOATCOLUMN := 0;
 4249                      LSCOLUMN := REC_PG.CHAR_5;
 4250                      LNVALUETYPE := 1;
 4251                   ELSIF REC_LAYOUT.FIELD_ID = 16
 4252                   THEN
 4253                      LNFLOATCOLUMN := 0;
 4254                      LSCOLUMN := REC_PG.CHAR_6;
 4255                      LNVALUETYPE := 1;
 4256                   ELSIF REC_LAYOUT.FIELD_ID = 17
 4257                   THEN
 4258                      LNFLOATCOLUMN := 0;
 4259                      LSCOLUMN := REC_PG.BOOLEAN_1;
 4260 
 4261                      IF LSCOLUMN IS NULL
 4262                      THEN
 4263                         LSCOLUMN := 'N';
 4264                      END IF;
 4265 
 4266                      LNVALUETYPE := 1;
 4267                   ELSIF REC_LAYOUT.FIELD_ID = 18
 4268                   THEN
 4269                      LNFLOATCOLUMN := 0;
 4270                      LSCOLUMN := REC_PG.BOOLEAN_2;
 4271 
 4272                      IF LSCOLUMN IS NULL
 4273                      THEN
 4274                         LSCOLUMN := 'N';
 4275                      END IF;
 4276 
 4277                      LNVALUETYPE := 1;
 4278                   ELSIF REC_LAYOUT.FIELD_ID = 19
 4279                   THEN
 4280                      LNFLOATCOLUMN := 0;
 4281                      LSCOLUMN := REC_PG.BOOLEAN_3;
 4282 
 4283                      IF LSCOLUMN IS NULL
 4284                      THEN
 4285                         LSCOLUMN := 'N';
 4286                      END IF;
 4287 
 4288                      LNVALUETYPE := 1;
 4289                   ELSIF REC_LAYOUT.FIELD_ID = 20
 4290                   THEN
 4291                      LNFLOATCOLUMN := 0;
 4292                      LSCOLUMN := REC_PG.BOOLEAN_4;
 4293 
 4294                      IF LSCOLUMN IS NULL
 4295                      THEN
 4296                         LSCOLUMN := 'N';
 4297                      END IF;
 4298 
 4299                      LNVALUETYPE := 1;
 4300                   ELSIF REC_LAYOUT.FIELD_ID = 21
 4301                   THEN
 4302                      LNFLOATCOLUMN := 0;
 4303                      LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
 4304                                           'dd-mm-yyyy hh24:mi:ss' );
 4305                      LDDATECOLUMN := REC_PG.DATE_1;
 4306 
 4307                      IF LDDATECOLUMN IS NULL
 4308                      THEN
 4309                         LNVALUETYPE := 1;
 4310                      ELSE
 4311                         LNVALUETYPE := 2;
 4312                      END IF;
 4313                   ELSIF REC_LAYOUT.FIELD_ID = 22
 4314                   THEN
 4315                      LNFLOATCOLUMN := 0;
 4316                      LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
 4317                                           'dd-mm-yyyy hh24:mi:ss' );
 4318                      LDDATECOLUMN := REC_PG.DATE_2;
 4319 
 4320                      IF LDDATECOLUMN IS NULL
 4321                      THEN
 4322                         LNVALUETYPE := 1;
 4323                      ELSE
 4324                         LNVALUETYPE := 2;
 4325                      END IF;
 4326                   ELSIF REC_LAYOUT.FIELD_ID = 26
 4327                   THEN
 4328 
 4329                      LNFLOATCOLUMN := 0;
 4330                      LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
 4331                      LSCOLUMN := F_CHH_DESCR( 1,
 4332                                               REC_PG.CHARACTERISTIC,
 4333                                               0 );
 4334                      LNVALUETYPE := 1;
 4335                   ELSIF REC_LAYOUT.FIELD_ID = 30
 4336                   THEN
 4337 
 4338                      LNFLOATCOLUMN := 0;
 4339                      LNFLOATCOLUMN := REC_PG.CH_2;
 4340                      LSCOLUMN := F_CHH_DESCR( 1,
 4341                                               REC_PG.CH_2,
 4342                                               0 );
 4343                      LNVALUETYPE := 1;
 4344                   ELSIF REC_LAYOUT.FIELD_ID = 31
 4345                   THEN
 4346 
 4347                      LNFLOATCOLUMN := 0;
 4348                      LNFLOATCOLUMN := REC_PG.CH_3;
 4349                      LSCOLUMN := F_CHH_DESCR( 1,
 4350                                               REC_PG.CH_3,
 4351                                               0 );
 4352                      LNVALUETYPE := 1;
 4353                   END IF;
 4354 
 4355                   IF    REC_LAYOUT.FIELD_ID < 23
 4356                      OR REC_LAYOUT.FIELD_ID = 26
 4357                      OR REC_LAYOUT.FIELD_ID = 30
 4358                      OR REC_LAYOUT.FIELD_ID = 31
 4359                   THEN
 4360                      BEGIN
 4361                         LNCOUNTER :=   LNCOUNTER
 4362                                      + 1;
 4363 
 4364                         IF LNVALUETYPE = 2
 4365                         THEN
 4366                            INSERT INTO FRAMEDATA
 4367                                        ( REVISION,
 4368                                          FRAME_NO,
 4369                                          OWNER,
 4370                                          SECTION_ID,
 4371                                          SUB_SECTION_ID,
 4372                                          SECTION_REV,
 4373                                          SUB_SECTION_REV,
 4374                                          SEQUENCE_NO,
 4375                                          TYPE,
 4376                                          REF_ID,
 4377                                          REF_VER,
 4378                                          PROPERTY_GROUP,
 4379                                          PROPERTY,
 4380                                          ATTRIBUTE,
 4381                                          PROPERTY_GROUP_REV,
 4382                                          PROPERTY_REV,
 4383                                          ATTRIBUTE_REV,
 4384                                          HEADER_ID,
 4385                                          HEADER_REV,
 4386                                          VALUE,
 4387                                          VALUE_S,
 4388                                          VALUE_DT,
 4389                                          VALUE_TYPE,
 4390                                          UOM_ID,
 4391                                          TEST_METHOD,
 4392                                          CHARACTERISTIC,
 4393                                          ASSOCIATION,
 4394                                          UOM_REV,
 4395                                          TEST_METHOD_REV,
 4396                                          CHARACTERISTIC_REV,
 4397                                          ASSOCIATION_REV,
 4398                                          REF_INFO,
 4399                                          INTL )
 4400                                 VALUES ( ANREVISION,
 4401                                          ASFRAMENO,
 4402                                          ANOWNER,
 4403                                          REC_SECTION.SECTION_ID,
 4404                                          REC_SECTION.SUB_SECTION_ID,
 4405                                          REC_SECTION.SECTION_REV,
 4406                                          REC_SECTION.SUB_SECTION_REV,
 4407                                          NVL( LNCOUNTER,
 4408                                               0 ),
 4409                                          REC_SECTION.TYPE,
 4410                                          NVL( REC_SECTION.REF_ID,
 4411                                               -1 ),
 4412                                          NVL( REC_SECTION.REF_VER,
 4413                                               -1 ),
 4414                                          NVL( REC_PG.PROPERTY_GROUP,
 4415                                               -1 ),
 4416                                          NVL( REC_PG.PROPERTY,
 4417                                               -1 ),
 4418                                          NVL( REC_PG.ATTRIBUTE,
 4419                                               -1 ),
 4420                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 4421                                               -1 ),
 4422                                          NVL( REC_PG.PROPERTY_REV,
 4423                                               -1 ),
 4424                                          NVL( REC_PG.ATTRIBUTE_REV,
 4425                                               -1 ),
 4426                                          NVL( REC_LAYOUT.HEADER_ID,
 4427                                               -1 ),
 4428                                          NVL( REC_LAYOUT.HEADER_REV,
 4429                                               -1 ),
 4430                                          LNFLOATCOLUMN,
 4431                                          LSCOLUMN,
 4432                                          TO_DATE( LSCOLUMN,
 4433                                                   'dd-mm-yyyy hh24:mi:ss' ),
 4434                                          NVL( LNVALUETYPE,
 4435                                               0 ),
 4436                                          NVL( REC_PG.UOM_ID,
 4437                                               -1 ),
 4438                                          NVL( REC_PG.TEST_METHOD,
 4439                                               -1 ),
 4440                                          NVL( REC_PG.CHARACTERISTIC,
 4441                                               -1 ),
 4442                                          NVL( REC_PG.ASSOCIATION,
 4443                                               -1 ),
 4444                                          NVL( REC_PG.UOM_REV,
 4445                                               -1 ),
 4446                                          NVL( REC_PG.TEST_METHOD_REV,
 4447                                               -1 ),
 4448                                          NVL( REC_PG.CHARACTERISTIC_REV,
 4449                                               -1 ),
 4450                                          NVL( REC_PG.ASSOCIATION_REV,
 4451                                               -1 ),
 4452                                          NVL( REC_SECTION.REF_INFO,
 4453                                               -1 ),
 4454                                          NVL( REC_SECTION.INTL,
 4455                                               -1 ) );
 4456                         ELSE
 4457                            INSERT INTO FRAMEDATA
 4458                                        ( REVISION,
 4459                                          FRAME_NO,
 4460                                          OWNER,
 4461                                          SECTION_ID,
 4462                                          SUB_SECTION_ID,
 4463                                          SECTION_REV,
 4464                                          SUB_SECTION_REV,
 4465                                          SEQUENCE_NO,
 4466                                          TYPE,
 4467                                          REF_ID,
 4468                                          REF_VER,
 4469                                          PROPERTY_GROUP,
 4470                                          PROPERTY,
 4471                                          ATTRIBUTE,
 4472                                          PROPERTY_GROUP_REV,
 4473                                          PROPERTY_REV,
 4474                                          ATTRIBUTE_REV,
 4475                                          HEADER_ID,
 4476                                          HEADER_REV,
 4477                                          VALUE,
 4478                                          VALUE_S,
 4479                                          VALUE_TYPE,
 4480                                          UOM_ID,
 4481                                          TEST_METHOD,
 4482                                          CHARACTERISTIC,
 4483                                          ASSOCIATION,
 4484                                          UOM_REV,
 4485                                          TEST_METHOD_REV,
 4486                                          CHARACTERISTIC_REV,
 4487                                          ASSOCIATION_REV,
 4488                                          REF_INFO,
 4489                                          INTL )
 4490                                 VALUES ( ANREVISION,
 4491                                          ASFRAMENO,
 4492                                          ANOWNER,
 4493                                          REC_SECTION.SECTION_ID,
 4494                                          REC_SECTION.SUB_SECTION_ID,
 4495                                          REC_SECTION.SECTION_REV,
 4496                                          REC_SECTION.SUB_SECTION_REV,
 4497                                          NVL( LNCOUNTER,
 4498                                               0 ),
 4499                                          REC_SECTION.TYPE,
 4500                                          NVL( REC_SECTION.REF_ID,
 4501                                               -1 ),
 4502                                          NVL( REC_SECTION.REF_VER,
 4503                                               -1 ),
 4504                                          NVL( REC_PG.PROPERTY_GROUP,
 4505                                               -1 ),
 4506                                          NVL( REC_PG.PROPERTY,
 4507                                               -1 ),
 4508                                          NVL( REC_PG.ATTRIBUTE,
 4509                                               -1 ),
 4510                                          NVL( REC_PG.PROPERTY_GROUP_REV,
 4511                                               -1 ),
 4512                                          NVL( REC_PG.PROPERTY_REV,
 4513                                               -1 ),
 4514                                          NVL( REC_PG.ATTRIBUTE_REV,
 4515                                               -1 ),
 4516                                          NVL( REC_LAYOUT.HEADER_ID,
 4517                                               -1 ),
 4518                                          NVL( REC_LAYOUT.HEADER_REV,
 4519                                               -1 ),
 4520                                          NVL( LNFLOATCOLUMN,
 4521                                               0 ),
 4522                                          LSCOLUMN,
 4523                                          NVL( LNVALUETYPE,
 4524                                               0 ),
 4525                                          NVL( REC_PG.UOM_ID,
 4526                                               -1 ),
 4527                                          NVL( REC_PG.TEST_METHOD,
 4528                                               -1 ),
 4529                                          NVL( REC_PG.CHARACTERISTIC,
 4530                                               -1 ),
 4531                                          NVL( REC_PG.ASSOCIATION,
 4532                                               -1 ),
 4533                                          NVL( REC_PG.UOM_REV,
 4534                                               -1 ),
 4535                                          NVL( REC_PG.TEST_METHOD_REV,
 4536                                               -1 ),
 4537                                          NVL( REC_PG.CHARACTERISTIC_REV,
 4538                                               -1 ),
 4539                                          NVL( REC_PG.ASSOCIATION_REV,
 4540                                               -1 ),
 4541                                          NVL( REC_SECTION.REF_INFO,
 4542                                               -1 ),
 4543                                          NVL( REC_SECTION.INTL,
 4544                                               -1 ) );
 4545                         END IF;
 4546                      EXCEPTION
 4547                         WHEN OTHERS
 4548                         THEN
 4549                            IAPIGENERAL.LOGERROR( GSSOURCE,
 4550                                                  LSMETHOD,
 4551                                                  SQLERRM );
 4552                            RAISE_APPLICATION_ERROR( -20000,
 4553                                                     SQLERRM );
 4554                      END;
 4555                   END IF;
 4556                END LOOP;
 4557             END LOOP;
 4558          END IF;
 4559       END LOOP;
 4560    END CONVERTFRAME;
 4561 
 4562    
 4563    PROCEDURE RUNSPECSERVER(
 4564       ASJOBNAME                  IN       IAPITYPE.STRING_TYPE )
 4565    IS
 4566       
 4567       
 4568       
 4569       
 4570       
 4571       
 4572       
 4573       
 4574       
 4575       
 4576       
 4577       
 4578       
 4579       LSALERTMESSAGE                VARCHAR2( 200 );
 4580       LNSTATUS                      INTEGER;      
 4581       
 4582       
 4583       
 4584       
 4585       
 4586       
 4587       LSERRORMESSAGE                VARCHAR2( 255 );
 4588       LNCOUNT                       NUMBER;
 4589       
 4590       L_PREV_PART_NO                IAPITYPE.PARTNO_TYPE;
 4591       L_PREV_PART_REVISION          IAPITYPE.REVISION_TYPE;
 4592       L_PREV_SECTION_ID             IAPITYPE.ID_TYPE;
 4593       L_PREV_SUB_SECTION_ID         IAPITYPE.ID_TYPE;
 4594       L_PREV_FRAME_NO               IAPITYPE.FRAMENO_TYPE;
 4595       L_PREV_FRAME_REVISION         IAPITYPE.REVISION_TYPE;
 4596       L_PREV_FRAME_OWNER            IAPITYPE.OWNER_TYPE;
 4597       LSLOCKNAME                    VARCHAR2(30);
 4598       LSLOCKHANDLE                  VARCHAR2(200);
 4599       LBLOCKED                      BOOLEAN;            
 4600       LNRETURNCODE                    INTEGER;
 4601       
 4602       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RunSpecServer';
 4603 
 4604       TYPE TABLE_ROWID IS TABLE OF ROWID
 4605          INDEX BY BINARY_INTEGER;
 4606 
 4607       LTB_ROWID                     TABLE_ROWID;
 4608 
 4609       CURSOR C_SPECDATA_SERVER
 4610       IS
 4611          SELECT PART_NO,
 4612                 REVISION,
 4613                 SECTION_ID,
 4614                 SUB_SECTION_ID,
 4615                 ROWID
 4616            FROM SPECDATA_SERVER
 4617          
 4618           
 4619           WHERE DATE_PROCESSED IS NULL
 4620           ORDER BY PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID;
 4621          
 4622       
 4623       
 4624       TYPE SPECDATASERVERRECTYPETAB IS TABLE OF C_SPECDATA_SERVER%ROWTYPE;
 4625       L_SPECDATA_REC_TAB SPECDATASERVERRECTYPETAB;  
 4626       
 4627 
 4628       CURSOR C_FRAMEDATA_SERVER
 4629       IS
 4630          SELECT FRAME_NO,
 4631                 REVISION,
 4632                 OWNER,
 4633                 ROWID
 4634            FROM FRAMEDATA_SERVER
 4635           
 4636           
 4637           WHERE DATE_PROCESSED IS NULL
 4638           ORDER BY FRAME_NO, REVISION, OWNER;
 4639           
 4640 
 4641       
 4642       TYPE FRAMEDATASERVERRECTYPETAB IS TABLE OF C_FRAMEDATA_SERVER%ROWTYPE;
 4643       L_FRAMEDATA_REC_TAB FRAMEDATASERVERRECTYPETAB;  
 4644       
 4645       
 4646    BEGIN
 4647       
 4648       
 4649       
 4650       IAPIGENERAL.LOGINFO( GSSOURCE,
 4651                            LSMETHOD,
 4652                            'Body of FUNCTION',
 4653                            IAPICONSTANT.INFOLEVEL_3 );
 4654 
 4655       
 4656       
 4657 
 4658 
 4659 
 4660 
 4661 
 4662 
 4663 
 4664 
 4665 
 4666 
 4667 
 4668 
 4669 
 4670 
 4671 
 4672 
 4673 
 4674 
 4675 
 4676 
 4677 
 4678 
 4679 
 4680 
 4681 
 4682 
 4683 
 4684 
 4685 
 4686 
 4687 
 4688 
 4689 
 4690 
 4691 
 4692 
 4693 
 4694 
 4695 
 4696 
 4697 
 4698 
 4699 
 4700 
 4701 
 4702 
 4703 
 4704 
 4705 
 4706 
 4707 
 4708 
 4709 
 4710 
 4711 
 4712 
 4713 
 4714 
 4715 
 4716 
 4717 
 4718 
 4719 
 4720 
 4721 
 4722 
 4723 
 4724 
 4725 
 4726 
 4727 
 4728 
 4729 
 4730 
 4731 
 4732 
 4733 
 4734 
 4735 
 4736 
 4737 
 4738 
 4739 
 4740 
 4741       
 4742       LBLOCKED := FALSE;
 4743       
 4744       
 4745       
 4746       
 4747       
 4748       
 4749       
 4750       
 4751       
 4752       LSLOCKNAME := 'ISPEC_SPECSERVERJOB_RUN';
 4753       DBMS_LOCK.ALLOCATE_UNIQUE(LOCKNAME => LSLOCKNAME,
 4754                                 LOCKHANDLE => LSLOCKHANDLE,
 4755                                 EXPIRATION_SECS => 2144448000); 
 4756       
 4757             
 4758       
 4759       
 4760       LNRETURNCODE := DBMS_LOCK.REQUEST(LOCKHANDLE => LSLOCKHANDLE,
 4761                                       LOCKMODE => DBMS_LOCK.X_MODE,
 4762                                       TIMEOUT => 0.01,
 4763                                       RELEASE_ON_COMMIT => FALSE);  
 4764       IF LNRETURNCODE = 1 THEN  
 4765          NULL;
 4766       ELSIF LNRETURNCODE = 4 THEN
 4767          RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||LSLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
 4768       ELSIF LNRETURNCODE <> 0 THEN
 4769          RAISE_APPLICATION_ERROR(-20000, 'Request Lock for '||LSLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.REQUEST doc for details)');
 4770       ELSE
 4771          LBLOCKED := TRUE;
 4772          DBMS_APPLICATION_INFO.SET_ACTION( 'SPECSERVER IS PROCESSING SPECIFICATION CONVERSIONS...' );
 4773          
 4774                   
 4775          
 4776          
 4777          
 4778          L_PREV_PART_NO := NULL;
 4779          L_PREV_PART_REVISION := NULL;
 4780          L_PREV_SECTION_ID := NULL;
 4781          L_PREV_SUB_SECTION_ID := NULL;
 4782 
 4783          OPEN C_SPECDATA_SERVER;
 4784          FETCH C_SPECDATA_SERVER BULK COLLECT INTO L_SPECDATA_REC_TAB; 
 4785          
 4786          FOR L_X IN 1..L_SPECDATA_REC_TAB.COUNT()
 4787          LOOP
 4788             
 4789             IF NVL(L_PREV_PART_NO, '*') = NVL(L_SPECDATA_REC_TAB(L_X).PART_NO, '*') AND
 4790                NVL(L_PREV_PART_REVISION, -1) = NVL(L_SPECDATA_REC_TAB(L_X).REVISION, -1) AND
 4791                
 4792                
 4793                NVL(L_PREV_SECTION_ID, -1) = NVL(L_SPECDATA_REC_TAB(L_X).SECTION_ID, -1) AND
 4794                NVL(L_PREV_SUB_SECTION_ID, -1) = NVL(L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID, -1) THEN
 4795 
 4796                IAPIGENERAL.LOGINFO( GSSOURCE,
 4797                         LSMETHOD,
 4798                         'Skipping duplicate record part_no='||NVL(L_SPECDATA_REC_TAB(L_X).PART_NO, '*')||
 4799                         '#revision='||NVL(L_SPECDATA_REC_TAB(L_X).REVISION, -1)||
 4800 
 4801 
 4802                         '#section_id='||NVL(L_SPECDATA_REC_TAB(L_X).SECTION_ID, -1)||
 4803                         '#sub_section_id='||NVL(L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID, -1),
 4804                         IAPICONSTANT.INFOLEVEL_3 );
 4805             ELSE
 4806             
 4807                SELECT COUNT( * )
 4808                  INTO LNCOUNT
 4809                  FROM SPECIFICATION_HEADER
 4810                 WHERE PART_NO = L_SPECDATA_REC_TAB(L_X).PART_NO
 4811                   AND REVISION = L_SPECDATA_REC_TAB(L_X).REVISION;
 4812 
 4813                IF LNCOUNT > 0
 4814                THEN
 4815                   IAPISPECDATASERVER.CONVERTSPECIFICATION( L_SPECDATA_REC_TAB(L_X).PART_NO,
 4816                                                            L_SPECDATA_REC_TAB(L_X).REVISION,
 4817                                                            L_SPECDATA_REC_TAB(L_X).SECTION_ID,
 4818                                                            L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID );
 4819                   COMMIT;
 4820                END IF;
 4821                L_PREV_PART_NO := L_SPECDATA_REC_TAB(L_X).PART_NO;
 4822                L_PREV_PART_REVISION := L_SPECDATA_REC_TAB(L_X).REVISION;
 4823                L_PREV_SECTION_ID := L_SPECDATA_REC_TAB(L_X).SECTION_ID;
 4824                L_PREV_SUB_SECTION_ID := L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID;
 4825             END IF;
 4826             
 4827             
 4828             
 4829             
 4830             
 4831             
 4832             UPDATE SPECDATA_SERVER 
 4833             SET DATE_PROCESSED = SYSDATE
 4834             WHERE ROWID = L_SPECDATA_REC_TAB(L_X).ROWID;
 4835             
 4836             COMMIT;
 4837             
 4838             
 4839          END LOOP;
 4840          CLOSE C_SPECDATA_SERVER;
 4841 
 4842          
 4843          
 4844          
 4845          
 4846          
 4847          
 4848          
 4849          
 4850          
 4851          
 4852          
 4853          
 4854          
 4855          DBMS_APPLICATION_INFO.SET_ACTION( 'SPECSERVER IS PROCESSING FRAME CONVERSIONS...' );
 4856 
 4857          
 4858          
 4859 
 4860          L_PREV_FRAME_NO := NULL;
 4861          L_PREV_FRAME_REVISION := NULL;
 4862          L_PREV_FRAME_OWNER := NULL;
 4863 
 4864          OPEN C_FRAMEDATA_SERVER;
 4865          FETCH C_FRAMEDATA_SERVER BULK COLLECT INTO L_FRAMEDATA_REC_TAB; 
 4866          
 4867          FOR L_X IN 1..L_FRAMEDATA_REC_TAB.COUNT()
 4868          LOOP
 4869             
 4870             IF NVL(L_PREV_FRAME_NO, '*') = NVL(L_FRAMEDATA_REC_TAB(L_X).FRAME_NO, '*') AND
 4871                NVL(L_PREV_FRAME_REVISION, -1) = NVL(L_FRAMEDATA_REC_TAB(L_X).REVISION, -1) AND
 4872 
 4873                NVL(L_PREV_FRAME_OWNER, -1) = NVL(L_FRAMEDATA_REC_TAB(L_X).OWNER, -1) THEN
 4874                IAPIGENERAL.LOGINFO( GSSOURCE,
 4875                        LSMETHOD,
 4876                        'Skipping duplicate record frame_no='||NVL(L_FRAMEDATA_REC_TAB(L_X).FRAME_NO, '*')||
 4877                        '#revision='||NVL(L_FRAMEDATA_REC_TAB(L_X).REVISION, -1)||
 4878 
 4879                        '#owner='||NVL(L_FRAMEDATA_REC_TAB(L_X).OWNER, -1),
 4880                        IAPICONSTANT.INFOLEVEL_3 );
 4881             ELSE             
 4882                IAPISPECDATASERVER.CONVERTFRAME(L_FRAMEDATA_REC_TAB(L_X).FRAME_NO,
 4883                                                L_FRAMEDATA_REC_TAB(L_X).REVISION,
 4884                                                L_FRAMEDATA_REC_TAB(L_X).OWNER );
 4885                COMMIT;
 4886                L_PREV_FRAME_NO := L_FRAMEDATA_REC_TAB(L_X).FRAME_NO;
 4887                L_PREV_FRAME_REVISION := L_FRAMEDATA_REC_TAB(L_X).REVISION;
 4888                L_PREV_FRAME_OWNER := L_FRAMEDATA_REC_TAB(L_X).OWNER;
 4889             END IF;
 4890             
 4891             
 4892             
 4893             
 4894             
 4895             
 4896             UPDATE FRAMEDATA_SERVER 
 4897             SET DATE_PROCESSED = SYSDATE
 4898             WHERE ROWID = L_FRAMEDATA_REC_TAB(L_X).ROWID;
 4899             
 4900             COMMIT;            
 4901             
 4902             
 4903          END LOOP;
 4904          CLOSE C_FRAMEDATA_SERVER;
 4905                   
 4906          
 4907          
 4908          
 4909          
 4910          
 4911          
 4912          
 4913          
 4914          
 4915          
 4916          
 4917        END IF;
 4918        
 4919        IF LBLOCKED THEN
 4920           RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
 4921           LBLOCKED := FALSE;
 4922        END IF;
 4923        DBMS_APPLICATION_INFO.SET_ACTION( 'SPECSERVER JOB GOING TO SLEEP' );
 4924       
 4925    EXCEPTION
 4926       WHEN OTHERS
 4927       THEN
 4928          
 4929          IF LBLOCKED THEN
 4930             BEGIN
 4931                RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
 4932                LBLOCKED := FALSE;
 4933             EXCEPTION
 4934             WHEN OTHERS THEN
 4935                IAPIGENERAL.LOGERROR( GSSOURCE,
 4936                                      LSMETHOD,
 4937                                      SQLERRM );
 4938             END;
 4939          END IF;  
 4940         
 4941 
 4942          IAPIGENERAL.LOGERROR( GSSOURCE,
 4943                                LSMETHOD,
 4944                                SQLERRM );
 4945 
 4946          IF C_SPECDATA_SERVER%ISOPEN
 4947          THEN
 4948             CLOSE C_SPECDATA_SERVER;
 4949          END IF;
 4950 
 4951          IF C_FRAMEDATA_SERVER%ISOPEN
 4952          THEN
 4953             CLOSE C_FRAMEDATA_SERVER;
 4954          END IF;
 4955          ROLLBACK;
 4956    END RUNSPECSERVER;
 4957 
 4958    
 4959    FUNCTION STARTSPECSERVER(
 4960       ASUPDATESTATUS             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT '1' )
 4961       RETURN IAPITYPE.ERRORNUM_TYPE
 4962    IS
 4963       
 4964       
 4965       
 4966       
 4967       
 4968       LSSPECSERVERNAME              VARCHAR2( 20 ) := 'SPEC_SERVER';
 4969       LSQUEUENAME                   VARCHAR2( 20 ) := 'DB_Q';
 4970       LNRETURNCODE                  NUMBER;
 4971       LNJOBS                        NUMBER;
 4972       LNCOUNT                       NUMBER;
 4973       LNEMAILINSTALLED              NUMBER;
 4974       LIJOB                         BINARY_INTEGER;
 4975       
 4976       LSLOCKNAME                    VARCHAR2(30);
 4977       LSLOCKHANDLE                  VARCHAR2(200);
 4978       LBLOCKED                      BOOLEAN;            
 4979       LSSPECSERVERJOBINTERVAL       VARCHAR2(200);
 4980       
 4981       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StartSpecServer';
 4982       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
 4983       PRAGMA AUTONOMOUS_TRANSACTION;
 4984    BEGIN
 4985       
 4986       
 4987       
 4988       IAPIGENERAL.LOGINFO( GSSOURCE,
 4989                            LSMETHOD,
 4990                            'Body of FUNCTION',
 4991                            IAPICONSTANT.INFOLEVEL_3 );	
 4992       
 4993       
 4994       
 4995       LBLOCKED := FALSE;
 4996       
 4997       LSLOCKNAME := 'ISPEC_SPECSERVERJOB_STARTSTOP';
 4998       DBMS_LOCK.ALLOCATE_UNIQUE(LOCKNAME => LSLOCKNAME,
 4999                                 LOCKHANDLE => LSLOCKHANDLE,
 5000                                 EXPIRATION_SECS => 2144448000); 
 5001       
 5002       
 5003       
 5004       
 5005       LNRETURNCODE := DBMS_LOCK.REQUEST(LOCKHANDLE => LSLOCKHANDLE,
 5006                                       LOCKMODE => DBMS_LOCK.X_MODE,
 5007                                       TIMEOUT => 0.01,
 5008                                       RELEASE_ON_COMMIT => FALSE);  
 5009       IF LNRETURNCODE = 1 THEN  
 5010          RAISE_APPLICATION_ERROR(-20000, 'Another session trying to stop or to start the jobs. Your attempt to stop or start has been aborted.');
 5011       ELSIF LNRETURNCODE = 4 THEN
 5012          RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||LSLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
 5013       ELSIF LNRETURNCODE <> 0 THEN
 5014          RAISE_APPLICATION_ERROR(-20000, 'Request Lock for '||LSLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.REQUEST doc for details)');
 5015       ELSE
 5016          
 5017          LBLOCKED := TRUE;		
 5018       
 5019          
 5020          
 5021          
 5022          IAPIGENERAL.LOGINFO( GSSOURCE,
 5023                               LSMETHOD,
 5024                               'Trying to start E-mail job' );
 5025          LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'email',
 5026                                                           ASPARAMETERDATA => LNEMAILINSTALLED );
 5027 
 5028          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 5029          THEN
 5030             LNEMAILINSTALLED := 0;
 5031             IAPIGENERAL.LOGERROR( GSSOURCE,
 5032                                   LSMETHOD,
 5033                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
 5034          END IF;
 5035 
 5036          IAPIGENERAL.LOGINFO( GSSOURCE,
 5037                               LSMETHOD,
 5038                                  'E-mail installed <'
 5039                               || LNEMAILINSTALLED
 5040                               || '>' );
 5041 
 5042          IF LNEMAILINSTALLED = 1
 5043          THEN
 5044             LNRETVAL := IAPIEMAIL.STARTJOB( );
 5045 
 5046             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 5047             THEN
 5048                IAPIGENERAL.LOGERROR( GSSOURCE,
 5049                                      LSMETHOD,
 5050                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
 5051             END IF;
 5052 
 5053             LNRETURNCODE := 0;
 5054          END IF;
 5055 
 5056          COMMIT;
 5057          
 5058          
 5059          
 5060          IAPIGENERAL.LOGINFO( GSSOURCE,
 5061                               LSMETHOD,
 5062                               'Trying to start SpecServer job' );
 5063 
 5064          
 5065          SELECT COUNT( JOB )
 5066            INTO LNJOBS
 5067            FROM DBA_JOBS
 5068           WHERE UPPER( WHAT ) LIKE    '%'
 5069                                    || UPPER( GSSOURCE )
 5070                                    || '%';
 5071 
 5072          IF LNJOBS > 0
 5073          THEN
 5074             
 5075             IAPIGENERAL.LOGINFO( GSSOURCE,
 5076                                  LSMETHOD,
 5077                                  'SpecServer job already started' );
 5078             LNRETURNCODE := -1;
 5079          ELSE
 5080             
 5081             IAPIGENERAL.LOGINFO( GSSOURCE,
 5082                                  LSMETHOD,
 5083                                     'Reading setting in interspc_cfg section <Specserver> Parameter <JOBINTERVAL>'
 5084                                   );         
 5085             LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'JOBINTERVAL', 'Specserver', 
 5086                                                              ASPARAMETERDATA => LSSPECSERVERJOBINTERVAL );
 5087 
 5088             IAPIGENERAL.LOGINFO( GSSOURCE,
 5089                                  LSMETHOD,
 5090                                     'Return='||LNRETVAL||' for GetConfigurationSetting for  section <Specserver> Parameter <JOBINTERVAL>'
 5091                                   );         
 5092             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
 5093             THEN
 5094                LSSPECSERVERJOBINTERVAL := 'SYSDATE + (1/100)'; 
 5095                IAPIGENERAL.LOGERROR( GSSOURCE,
 5096                                      LSMETHOD,
 5097                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
 5098             END IF;
 5099 
 5100             IAPIGENERAL.LOGINFO( GSSOURCE,
 5101                                  LSMETHOD,
 5102                                     'Interval used for SpecServer job <'
 5103                                  || LSSPECSERVERJOBINTERVAL
 5104                                  || '>' );  
 5105             
 5106             DBMS_JOB.SUBMIT( LIJOB,
 5107                                 GSSOURCE
 5108                              || '.RunSpecServer('''
 5109                              || LSSPECSERVERNAME
 5110                              || ''' ) ;',
 5111                              SYSDATE,	
 5112        
 5113 				 			 
 5114                              LSSPECSERVERJOBINTERVAL );
 5115        
 5116             IAPIGENERAL.LOGINFO( GSSOURCE,
 5117                                  LSMETHOD,
 5118                                  'SpecServer job started' );
 5119             LNRETURNCODE := 0;
 5120          END IF;
 5121          
 5122          
 5123 
 5124 
 5125          
 5126 		 
 5127          COMMIT;
 5128          
 5129          
 5130          
 5131          IAPIGENERAL.LOGINFO( GSSOURCE,
 5132                               LSMETHOD,
 5133                               'Trying to start Queue Server job' );
 5134 
 5135          
 5136          SELECT COUNT( JOB )
 5137            INTO LNJOBS
 5138            FROM DBA_JOBS
 5139           WHERE UPPER( WHAT ) LIKE UPPER( '%iapiQueue.ExecuteQueue%' );
 5140 
 5141          IF LNJOBS > 0
 5142          THEN
 5143             
 5144             IAPIGENERAL.LOGINFO( GSSOURCE,
 5145                                  LSMETHOD,
 5146                                  ' Queue Server job already started' );
 5147             LNRETURNCODE := -1;
 5148          ELSE
 5149             DBMS_JOB.SUBMIT( LIJOB,
 5150                              'iapiQueue.ExecuteQueue;',
 5151                              SYSDATE,
 5152                              '' );
 5153             IAPIGENERAL.LOGINFO( GSSOURCE,
 5154                                  LSMETHOD,
 5155                                  ' Queue Server job started' );
 5156             LNRETURNCODE := 0;
 5157          END IF;
 5158 
 5159          IF ASUPDATESTATUS = '1'
 5160          THEN
 5161             UPDATE INTERSPC_CFG
 5162                SET PARAMETER_DATA = 'ENABLED'
 5163              WHERE SECTION = 'Specserver'
 5164                AND PARAMETER = 'STATUS';
 5165          END IF;
 5166 
 5167          COMMIT;  
 5168 	  
 5169       END IF;
 5170       IF LBLOCKED THEN
 5171          RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
 5172          LBLOCKED := FALSE;
 5173       END IF;			
 5174      
 5175       
 5176       RETURN LNRETURNCODE;
 5177    EXCEPTION
 5178       WHEN OTHERS
 5179       THEN	
 5180          
 5181          IF LBLOCKED THEN
 5182             BEGIN
 5183                RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
 5184                LBLOCKED := FALSE;
 5185             EXCEPTION
 5186             WHEN OTHERS THEN
 5187                IAPIGENERAL.LOGERROR( GSSOURCE,
 5188                                      LSMETHOD,
 5189                                      SQLERRM );
 5190             END;
 5191          END IF;
 5192          
 5193          IAPIGENERAL.LOGERROR( GSSOURCE,
 5194                                LSMETHOD,
 5195                                SQLERRM );
 5196          ROLLBACK;
 5197          RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
 5198    END STARTSPECSERVER;
 5199 
 5200    
 5201    FUNCTION STOPSPECSERVER(
 5202       ASUPDATESTATUS             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT '1' )
 5203       RETURN IAPITYPE.ERRORNUM_TYPE
 5204    IS
 5205       
 5206       
 5207       
 5208       
 5209       
 5210       LNEMAILINSTALLED              NUMBER;	 
 5211       
 5212       LSLOCKNAME                    VARCHAR2(30);
 5213       LSLOCKHANDLE                  VARCHAR2(200);
 5214       LBLOCKED                      BOOLEAN;            
 5215       LNRETURNCODE                  INTEGER;
 5216       LIJOBSPECSERVER               BINARY_INTEGER;
 5217       
 5218       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StopSpecServer';
 5219       PRAGMA AUTONOMOUS_TRANSACTION;
 5220    BEGIN
 5221       
 5222       
 5223       
 5224       IAPIGENERAL.LOGINFO( GSSOURCE,
 5225                            LSMETHOD,
 5226                            'Body of FUNCTION',
 5227                            IAPICONSTANT.INFOLEVEL_3 );	
 5228       
 5229       
 5230       
 5231       LBLOCKED := FALSE;
 5232       
 5233       LSLOCKNAME := 'ISPEC_SPECSERVERJOB_STARTSTOP';
 5234       DBMS_LOCK.ALLOCATE_UNIQUE(LOCKNAME => LSLOCKNAME,
 5235                                 LOCKHANDLE => LSLOCKHANDLE,
 5236                                 EXPIRATION_SECS => 2144448000); 
 5237       
 5238       
 5239       
 5240       
 5241       LNRETURNCODE := DBMS_LOCK.REQUEST(LOCKHANDLE => LSLOCKHANDLE,
 5242                                       LOCKMODE => DBMS_LOCK.X_MODE,
 5243                                       TIMEOUT => 0.01,
 5244                                       RELEASE_ON_COMMIT => FALSE);  
 5245       IF LNRETURNCODE = 1 THEN  
 5246          RAISE_APPLICATION_ERROR(-20000, 'Another session trying to stop or to start the jobs. Your attempt to stop or start has been aborted.');
 5247       ELSIF LNRETURNCODE = 4 THEN
 5248          RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||LSLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
 5249       ELSIF LNRETURNCODE <> 0 THEN
 5250          RAISE_APPLICATION_ERROR(-20000, 'Request Lock for '||LSLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.REQUEST doc for details)');
 5251       ELSE
 5252          
 5253          LBLOCKED := TRUE; 
 5254       
 5255          
 5256          
 5257          
 5258          IAPIGENERAL.LOGINFO( GSSOURCE,
 5259                               LSMETHOD,
 5260                               'Trying to stop E-mail job' );
 5261          DBMS_ALERT.SIGNAL( 'MAIL',
 5262                             '2' );
 5263          
 5264          
 5265          
 5266          IAPIGENERAL.LOGINFO( GSSOURCE,
 5267                               LSMETHOD,
 5268                               'Trying to stop SpecServer job' );
 5269          
 5270          
 5271 
 5272 
 5273          
 5274          
 5275          LIJOBSPECSERVER := NULL;
 5276          BEGIN
 5277             SELECT JOB
 5278               INTO LIJOBSPECSERVER
 5279               FROM DBA_JOBS
 5280              WHERE UPPER( WHAT ) LIKE    '%'
 5281                                           || UPPER( GSSOURCE || '.RunSpecServer' )
 5282                                 || '%';
 5283          EXCEPTION
 5284          WHEN NO_DATA_FOUND THEN
 5285          IAPIGENERAL.LOGINFO( GSSOURCE,
 5286                               LSMETHOD,
 5287                               'No SpecServer job found to stop it' );
 5288          WHEN TOO_MANY_ROWS THEN
 5289             IAPIGENERAL.LOGERROR( GSSOURCE,
 5290                                   LSMETHOD,
 5291                                   'More than one specserver job has been found and stopped. This is not supported. Contact the dba to investigate how this happened.' );         
 5292             FOR L_JOB_REC IN (SELECT JOB
 5293                               FROM DBA_JOBS
 5294                               WHERE UPPER( WHAT ) LIKE    '%'
 5295                                                                         || UPPER( GSSOURCE || '.RunSpecServer' )
 5296                                 || '%')
 5297             LOOP
 5298                DBMS_JOB.REMOVE(L_JOB_REC.JOB);
 5299             END LOOP;
 5300 
 5301          END;
 5302          IF LIJOBSPECSERVER IS NOT NULL THEN
 5303             DBMS_JOB.REMOVE(LIJOBSPECSERVER);
 5304          END IF;
 5305         
 5306          
 5307          
 5308          
 5309          IAPIGENERAL.LOGINFO( GSSOURCE,
 5310                               LSMETHOD,
 5311                               'Trying to stop Queue Server job' );
 5312          DBMS_ALERT.SIGNAL( 'DB_Q',
 5313                             'Q_STOP' );
 5314 
 5315          IF ASUPDATESTATUS = '1'
 5316          THEN
 5317             UPDATE INTERSPC_CFG
 5318                SET PARAMETER_DATA = 'DISABLED'
 5319              WHERE SECTION = 'Specserver'
 5320                AND PARAMETER = 'STATUS';
 5321          END IF;
 5322 
 5323          COMMIT;		 
 5324       
 5325       END IF;
 5326       IF LBLOCKED THEN
 5327          RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
 5328          LBLOCKED := FALSE;
 5329       END IF;
 5330       
 5331       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 5332    EXCEPTION
 5333       WHEN OTHERS
 5334       THEN		   
 5335          
 5336          IF LBLOCKED THEN
 5337             BEGIN
 5338                RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
 5339                LBLOCKED := FALSE;
 5340                
 5341             EXCEPTION
 5342             WHEN OTHERS THEN
 5343                IAPIGENERAL.LOGERROR( GSSOURCE,
 5344                                      LSMETHOD,
 5345                                      SQLERRM );
 5346             END;
 5347          END IF;   
 5348          
 5349          IAPIGENERAL.LOGERROR( GSSOURCE,
 5350                                LSMETHOD,
 5351                                SQLERRM );
 5352          ROLLBACK;
 5353          RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
 5354    END STOPSPECSERVER;
 5355 
 5356    
 5357    FUNCTION ISSPECSERVERRUNNING
 5358       RETURN IAPITYPE.ERRORNUM_TYPE
 5359    IS
 5360       LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
 5361       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsSpecserverRunning';
 5362    
 5363    
 5364    
 5365    
 5366    
 5367    
 5368    
 5369    BEGIN
 5370       
 5371       
 5372       
 5373       IAPIGENERAL.LOGINFO( GSSOURCE,
 5374                            LSMETHOD,
 5375                            'Body of FUNCTION',
 5376                            IAPICONSTANT.INFOLEVEL_3 );
 5377 
 5378       SELECT COUNT( * )
 5379         INTO LNCOUNT
 5380         FROM DBA_JOBS
 5381        WHERE UPPER( WHAT ) LIKE    '%'
 5382                                 || UPPER( GSSOURCE )
 5383                                 || '%';
 5384 
 5385       IF LNCOUNT > 0
 5386       THEN
 5387          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
 5388       ELSE
 5389          RETURN( IAPICONSTANTDBERROR.DBERR_SPECSERVERNOTRUNNING );
 5390       END IF;
 5391    EXCEPTION
 5392       WHEN OTHERS
 5393       THEN
 5394          IAPIGENERAL.LOGERROR( GSSOURCE,
 5395                                LSMETHOD,
 5396                                SQLERRM );
 5397          RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
 5398    END ISSPECSERVERRUNNING;
 5399 END IAPISPECDATASERVER;