 1 PACKAGE BODY iapiCheckProcessing
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
   24       RETURN(    IAPIGENERAL.GETVERSION
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
   43    PROCEDURE CHECKEMAILMESSAGES(
   44       ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
   45    IS
   46 
   47 
   48 
   49 
   50 
   51 
   52       LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
   53       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   54       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckEmailMessages';
   55    BEGIN
   56       SELECT COUNT( * )
   57         INTO LNCOUNTER
   58         FROM ITEMAIL;
   59 
   60       IF LNCOUNTER > ANMAXIMUM
   61       THEN
   62          LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_EMAILSNOTPROCESSED,
   63                                                TO_CHAR( LNCOUNTER ) );
   64          IAPIGENERAL.LOGERROR( GSSOURCE,
   65                                LSMETHOD,
   66                                IAPIGENERAL.GETLASTERRORTEXT( ) );
   67       END IF;
   68    EXCEPTION
   69       WHEN OTHERS
   70       THEN
   71          IAPIGENERAL.LOGERROR( GSSOURCE,
   72                                LSMETHOD,
   73                                SQLERRM );
   74          RAISE_APPLICATION_ERROR( '-20001',
   75                                   SQLERRM );
   76    END CHECKEMAILMESSAGES;
   77 
   78 
   79    PROCEDURE CHECKEMAILADDRESS
   80    IS
   81 
   82 
   83 
   84 
   85 
   86 
   87       CURSOR C_ADDRESS
   88       IS
   89          SELECT USER_ID,
   90                    EMAIL_ADDRESS
   91                 || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
   92                                         '@' ) ),
   93                            0, PARAMETER_DATA ) ADDRESS
   94            FROM APPLICATION_USER,
   95                 INTERSPC_CFG
   96           WHERE PARAMETER(+) = 'def_email_ext';
   97 
   98       LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
   99       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  100       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckEmailAddress';
  101    BEGIN
  102       FOR L_ROW IN C_ADDRESS
  103       LOOP
  104          
  105          IF LENGTH( RTRIM( LTRIM( LOWER( LTRIM( RTRIM( L_ROW.ADDRESS ) ) ),
  106                                   'abcdefghijklmnopqrstuvwxyz-_.1234567890''' ),
  107                            'abcdefghijklmnopqrstuvwxyz-_.1234567890''' ) ) <> 1
  108          THEN
  109             LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDEMAILADDRESS,
  110                                                   L_ROW.USER_ID );
  111             IAPIGENERAL.LOGERROR( GSSOURCE,
  112                                   LSMETHOD,
  113                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
  114          END IF;
  115 
  116          COMMIT;
  117       END LOOP;
  118    EXCEPTION
  119       WHEN OTHERS
  120       THEN
  121          IAPIGENERAL.LOGERROR( GSSOURCE,
  122                                LSMETHOD,
  123                                SQLERRM );
  124          RAISE_APPLICATION_ERROR( '-20001',
  125                                   SQLERRM );
  126    END CHECKEMAILADDRESS;
  127 
  128 
  129    PROCEDURE CHECKFRAMES(
  130       ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
  131    IS
  132 
  133 
  134 
  135 
  136 
  137 
  138       LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
  139       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  140       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckFrames';
  141    BEGIN
  142       SELECT COUNT( * )
  143         INTO LNCOUNTER
  144         FROM FRAMEDATA_SERVER
  145        WHERE DATE_PROCESSED IS NULL;
  146 
  147       IF LNCOUNTER > ANMAXIMUM
  148       THEN
  149          LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_FRAMESNOTPROCESSED,
  150                                                TO_CHAR( LNCOUNTER ) );
  151          IAPIGENERAL.LOGERROR( GSSOURCE,
  152                                LSMETHOD,
  153                                IAPIGENERAL.GETLASTERRORTEXT( ) );
  154       END IF;
  155    EXCEPTION
  156       WHEN OTHERS
  157       THEN
  158          IAPIGENERAL.LOGERROR( GSSOURCE,
  159                                LSMETHOD,
  160                                SQLERRM );
  161          RAISE_APPLICATION_ERROR( '-20001',
  162                                   SQLERRM );
  163    END CHECKFRAMES;
  164 
  165    PROCEDURE CHECKSPECIFICATIONS(
  166       ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
  167    IS
  168 
  169 
  170 
  171 
  172 
  173 
  174       LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
  175       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  176       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckSpecifications';
  177    BEGIN
  178       SELECT COUNT( * )
  179         INTO LNCOUNTER
  180         FROM SPECDATA_SERVER
  181        WHERE DATE_PROCESSED IS NULL;
  182 
  183       IF LNCOUNTER > ANMAXIMUM
  184       THEN
  185          LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECSNOTPROCESSED,
  186                                                TO_CHAR( LNCOUNTER ) );
  187          IAPIGENERAL.LOGERROR( GSSOURCE,
  188                                LSMETHOD,
  189                                IAPIGENERAL.GETLASTERRORTEXT( ) );
  190       END IF;
  191    EXCEPTION
  192       WHEN OTHERS
  193       THEN
  194          IAPIGENERAL.LOGERROR( GSSOURCE,
  195                                LSMETHOD,
  196                                SQLERRM );
  197          RAISE_APPLICATION_ERROR( '-20001',
  198                                   SQLERRM );
  199    END CHECKSPECIFICATIONS;
  200 
  201    
  202    
  203    
  204    PROCEDURE CHECKPROCESSING(
  205       ANMAXIMUM                           IAPITYPE.NUMVAL_TYPE )
  206    IS
  207 
  208 
  209 
  210 
  211 
  212 
  213       LNEMAILINSTALLED              IAPITYPE.NUMVAL_TYPE;
  214       LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckProcessing';
  215       LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
  216    BEGIN
  217       IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
  218       THEN
  219          LNRETVAL := IAPIGENERAL.SETCONNECTION( USER,
  220                                                 'CHECK PROCESSING JOB' );
  221 
  222          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
  223          THEN
  224             RAISE_APPLICATION_ERROR( -20000,
  225                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
  226          END IF;
  227       END IF;
  228 
  229       BEGIN
  230          SELECT PARAMETER_DATA
  231            INTO LNEMAILINSTALLED
  232            FROM INTERSPC_CFG
  233           WHERE PARAMETER = 'email'
  234             AND SECTION = 'interspec';
  235       EXCEPTION
  236          WHEN NO_DATA_FOUND
  237          THEN
  238             LNEMAILINSTALLED := 0;
  239       END;
  240 
  241       IF LNEMAILINSTALLED = 1
  242       THEN
  243          IAPIGENERAL.LOGINFO( GSSOURCE,
  244                               LSMETHOD,
  245                               'CHECKING E-MAIL',
  246                               IAPICONSTANT.INFOLEVEL_3 );
  247          CHECKEMAILMESSAGES( ANMAXIMUM );
  248          CHECKEMAILADDRESS;
  249       ELSE
  250          IAPIGENERAL.LOGINFO( GSSOURCE,
  251                               LSMETHOD,
  252                               'E-MAIL NOT ACTIVATED',
  253                               IAPICONSTANT.INFOLEVEL_3 );
  254       END IF;
  255 
  256       IAPIGENERAL.LOGINFO( GSSOURCE,
  257                            LSMETHOD,
  258                            'CHECKING FRAMES',
  259                            IAPICONSTANT.INFOLEVEL_3 );
  260       CHECKFRAMES( ANMAXIMUM );
  261       IAPIGENERAL.LOGINFO( GSSOURCE,
  262                            LSMETHOD,
  263                            'CHECKING SPECFICATIONS',
  264                            IAPICONSTANT.INFOLEVEL_3 );
  265       CHECKSPECIFICATIONS( ANMAXIMUM );
  266    EXCEPTION
  267       WHEN OTHERS
  268       THEN
  269          IAPIGENERAL.LOGERROR( GSSOURCE,
  270                                LSMETHOD,
  271                                SQLERRM );
  272          LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
  273          RAISE_APPLICATION_ERROR( -20000,
  274                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
  275    END CHECKPROCESSING;
  276 END IAPICHECKPROCESSING;
  