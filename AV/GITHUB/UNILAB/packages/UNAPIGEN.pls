create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapigen AS

--package constant that can be modified to enable or disable the translation of group key drop-down values
P_TRANSLATE_GK        CONSTANT VARCHAR2(3) := 'NO';  -- NO: disable translations, YES: enable translations
--Enabling translations can have impact on performance of tasks (when drop-downs are very large)

TYPE CHAR1_TABLE_TYPE IS TABLE OF CHAR(1)            INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE CHAR2_TABLE_TYPE IS TABLE OF CHAR(2)            INDEX BY BINARY_INTEGER;
TYPE VC1_TABLE_TYPE   IS TABLE OF VARCHAR2(1)        INDEX BY BINARY_INTEGER;
TYPE VC2_TABLE_TYPE   IS TABLE OF VARCHAR2(2)        INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE VC3_TABLE_TYPE   IS TABLE OF VARCHAR2(3)        INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE VC4_TABLE_TYPE   IS TABLE OF VARCHAR2(4)        INDEX BY BINARY_INTEGER;
TYPE VC8_TABLE_TYPE   IS TABLE OF VARCHAR2(8)        INDEX BY BINARY_INTEGER;
TYPE VC20_TABLE_TYPE  IS TABLE OF VARCHAR2(20)       INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE VC30_TABLE_TYPE  IS TABLE OF VARCHAR2(30)       INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE VC40_TABLE_TYPE  IS TABLE OF VARCHAR2(40)       INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE VC60_TABLE_TYPE  IS TABLE OF VARCHAR2(60)       INDEX BY BINARY_INTEGER;
TYPE VC80_TABLE_TYPE  IS TABLE OF VARCHAR2(80)       INDEX BY BINARY_INTEGER;
TYPE VC255_TABLE_TYPE IS TABLE OF VARCHAR2(255)      INDEX BY BINARY_INTEGER;
TYPE VC511_TABLE_TYPE IS TABLE OF VARCHAR2(511)      INDEX BY BINARY_INTEGER;
TYPE VC512_TABLE_TYPE IS TABLE OF VARCHAR2(512)      INDEX BY BINARY_INTEGER;
TYPE VC1000_TABLE_TYPE IS TABLE OF VARCHAR2(1000)    INDEX BY BINARY_INTEGER;
TYPE VC2000_TABLE_TYPE IS TABLE OF VARCHAR2(2000)    INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE VC4000_TABLE_TYPE IS TABLE OF VARCHAR2(4000)    INDEX BY BINARY_INTEGER;
TYPE RAW8_TABLE_TYPE  IS TABLE OF RAW(8)             INDEX BY BINARY_INTEGER;
TYPE NUM_TABLE_TYPE   IS TABLE OF NUMBER             INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE FLOAT_TABLE_TYPE IS TABLE OF NUMBER             INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE DATE_TABLE_TYPE  IS TABLE OF VARCHAR2(30)       INDEX BY BINARY_INTEGER; /* used by proCX */
TYPE LONG_TABLE_TYPE  IS TABLE OF NUMBER(9)          INDEX BY BINARY_INTEGER; /* used by proCX */

--Weak REF CURSOR TYPE for Business Objects stored procedures
TYPE CURSOR_REF_TYPE IS REF CURSOR;

P_TXN_SEQ               NUMBER;
P_TXN_ERROR             NUMBER;
P_TXN_LEVEL             NUMBER;
P_TXN_ERROR_TEXT        VARCHAR2(255);
P_REMOTE                INTEGER;

PA_OBJECT_ID                UNAPIGEN.VC255_TABLE_TYPE;
PA_OBJECT_VERSION           UNAPIGEN.VC20_TABLE_TYPE;
PA_OBJECT_PRIV              UNAPIGEN.NUM_TABLE_TYPE;
PA_OBJECT_TP                UNAPIGEN.CHAR2_TABLE_TYPE;
PA_OBJECT_LC                UNAPIGEN.VC2_TABLE_TYPE;
PA_OBJECT_LC_VERSION        UNAPIGEN.VC20_TABLE_TYPE;
PA_OBJECT_SS                UNAPIGEN.VC2_TABLE_TYPE;
PA_OBJECT_ALLOW_MODIFY      UNAPIGEN.CHAR1_TABLE_TYPE;
PA_OBJECT_ACTIVE            UNAPIGEN.CHAR1_TABLE_TYPE;
PA_OBJECT_LOG_HS            UNAPIGEN.CHAR1_TABLE_TYPE;
PA_OBJECT_LOG_HS_DETAILS    UNAPIGEN.CHAR1_TABLE_TYPE;
PA_OBJECT_PARENT1_NR        UNAPIGEN.NUM_TABLE_TYPE;
PA_OBJECT_PARENT2_NR        UNAPIGEN.NUM_TABLE_TYPE;
PA_OBJECT_NR                NUMBER;

P_CURRENT_UP           NUMBER(5);
P_DD                   VARCHAR2(3);
P_TK                   VARCHAR2(20);
P_CLIENT_ID            VARCHAR2(20);
P_APPLIC_NAME          VARCHAR2(8);
P_PP                   VARCHAR2(20);
P_PP_VERSION           VARCHAR2(20);
P_INHERIT_FROM         VARCHAR2(20);
P_DBA_NAME             VARCHAR2(40);
P_USER                 VARCHAR2(20);
P_USER_DESCRIPTION     VARCHAR2(40);
P_INSTANCENR           NUMBER(4);

P_LOG_EV               BOOLEAN;
P_LOG_LC_ACTIONS       BOOLEAN;
P_DEFAULT_CHUNK_SIZE   NUMBER DEFAULT 100;
P_MAX_CHUNK_SIZE       NUMBER DEFAULT 5000;
P_TR_SEQ               NUMBER;
P_CURRENT_EVMGR_NAME   VARCHAR2(20);
P_CURRENT_EVMGR_TR_SEQ NUMBER;
P_EVMGR_NAME           VARCHAR2(20);
P_VERSION              VARCHAR2(255);
P_DATEFORMAT           VARCHAR2(255);
P_TIMEFORMAT           VARCHAR2(255);
P_DEFAULT_FORMAT       VARCHAR2(255);
P_UC_TIMEOUT           NUMBER;
P_JOBS_DATE_FORMAT     VARCHAR2(40);
P_JOBS_TSLTZ_FORMAT    VARCHAR2(40);
P_JOBS_TSTZ_FORMAT     VARCHAR2(40);
P_DATADOMAINS          NUMBER;
P_PP_KEY4PRODUCT       INTEGER;
P_PP_KEY4CUSTOMER      INTEGER;
P_PP_KEY4SUPPLIER      INTEGER;
P_PP_KEY_NR_OF_ROWS    INTEGER;
P_PP_KEY_TP_TAB        UNAPIGEN.VC20_TABLE_TYPE;
P_PP_KEY_NAME_TAB      UNAPIGEN.VC40_TABLE_TYPE;
P_LAB                  VARCHAR2(20);

/* package variables used to handle deadlocks raised in the event manager */
P_DEADLOCK_RAISED      BOOLEAN;
P_DEADLOCK_COUNT       INTEGER;
P_MAX_DEADLOCK_COUNT   CONSTANT INTEGER := 3;  /* maximum number of retries on one event when a deadlock is detected */
P_SLEEP_AFTER_DEADLOCK CONSTANT INTEGER := 10; /* sleep in seconds when a deadlock is detected */
   /* statement used  when the event manager job is started in order to reduce the size */
   /* of the dumpfile generated by Oracle when a deadlock is raised                     */
   /* Multiple attempts have been tested with SET events '60 trace name errorstack off' */
   /* But the dump files were still generated                                           */
   /* The option of reducing the size of these dumpfiles has been preferred             */
   /* That statement is only used in the event manager job                              */
   /* For support purposes, it might be necessary to increase that value to be able to  */
   /* analyze deadlocks                                                                 */
P_NODUMP_ON_DEADLOCK   CONSTANT VARCHAR2(255) := 'ALTER SESSION SET max_dump_file_size=100';

/* turn DBS_OUTPUT tracing on in NewVersionMgr */
P_NEWVERSIONMGR_OUTPUT  BOOLEAN DEFAULT FALSE;

/* variables to keep track of last saved sequence and transaction in SaveLongText */
P_LAST_LINE             NUMBER ;
P_SAVELONGTEXT_CALLS    NUMBER ;
P_SAVELONG_TEXT_TR_SEQ  NUMBER ;
P_LT_CURSOR             INTEGER;
/* Transaction control */
P_NO_TXN               CONSTANT INTEGER := 0;
P_SINGLE_API_TXN       CONSTANT INTEGER := 1;
P_MULTI_API_TXN        CONSTANT INTEGER := 2;
P_RNDSUITESESSION      CHAR(1) DEFAULT '0';

/* TO BE REMOVED: Hard-coded initialisation of array, containing all objects with version-control */
l_object_types             UNAPIGEN.VC20_TABLE_TYPE;
l_nr_of_types              NUMBER;

/* Labels for spec sets are initialised by SetConnection */
P_SPEC_SETA_LABEL          VARCHAR2(40);
P_SPEC_SETB_LABEL          VARCHAR2(40);
P_SPEC_SETC_LABEL          VARCHAR2(40);

/* package variable to turn off history logging in Save[1]XxGroupKey */
P_LOG_GK_HS CONSTANT CHAR(1) := '1';

/* Return codes */
/* Generic errors 1-69 */
DBERR_SUCCESS                  CONSTANT INTEGER := 0; /* used by proCX */
DBERR_GENFAIL                  CONSTANT INTEGER := 1;
DBERR_NOOBJECT                 CONSTANT INTEGER := 2;
DBERR_NOACCESS                 CONSTANT INTEGER := 3;
DBERR_READONLY                 CONSTANT INTEGER := 4;
DBERR_NOTMODIFIABLE            CONSTANT INTEGER := 5;
DBERR_NOTACTIVE                CONSTANT INTEGER := 6;
DBERR_INUSE                    CONSTANT INTEGER := 7;
DBERR_INTXN                    CONSTANT INTEGER := 8;
DBERR_NOOBJTP                  CONSTANT INTEGER := 9;
DBERR_NOOBJID                  CONSTANT INTEGER := 10;
DBERR_NORECORDS                CONSTANT INTEGER := 11;
DBERR_NROFROWS                 CONSTANT INTEGER := 12;
DBERR_NOCURSOR                 CONSTANT INTEGER := 13;
DBERR_TRANSITION               CONSTANT INTEGER := 14;
DBERR_WHERECLAUSE              CONSTANT INTEGER := 15;
DBERR_OBJECTLCMATCH            CONSTANT INTEGER := 16;
DBERR_OBJECTSSMATCH            CONSTANT INTEGER := 17;
DBERR_NOTAUTHORISED            CONSTANT INTEGER := 18;
DBERR_NOLC                     CONSTANT INTEGER := 19;
DBERR_BTXNON                   CONSTANT INTEGER := 20;
DBERR_TXNNOTBEGUN              CONSTANT INTEGER := 21;
DBERR_NOUSEDOBJECT             CONSTANT INTEGER := 22;
DBERR_NOTFOUND                 CONSTANT INTEGER := 23;
DBERR_UP                       CONSTANT INTEGER := 24;
DBERR_SYSDEFAULTS              CONSTANT INTEGER := 25;
DBERR_NEXTROWS                 CONSTANT INTEGER := 26;
DBERR_OBJTP                    CONSTANT INTEGER := 27;
DBERR_PARTIALSAVE              CONSTANT INTEGER := 28;
DBERR_ALLOWANYPP               CONSTANT INTEGER := 29;
DBERR_MOD_UPDATE               CONSTANT INTEGER := 30;
DBERR_MOD_INSERT               CONSTANT INTEGER := 31;
DBERR_MOD_DELETE               CONSTANT INTEGER := 32;
DBERR_NOMAINOBJ                CONSTANT INTEGER := 33;
DBERR_FLOATTOSTRING            CONSTANT INTEGER := 34;
DBERR_INVALMODFLAG             CONSTANT INTEGER := 35;
DBERR_NOTIMPLEMENTED           CONSTANT INTEGER := 36;
DBERR_ALLOWANYPR               CONSTANT INTEGER := 37;
DBERR_OUTOFCALENDAR            CONSTANT INTEGER := 38;
DBERR_NOSS                     CONSTANT INTEGER := 39;
DBERR_RESERVEDID               CONSTANT INTEGER := 40;
DBERR_EVMGRSTARTNOTAUTHORISED  CONSTANT INTEGER := 41;
DBERR_EVMGRNOTSTARTED          CONSTANT INTEGER := 42;
DBERR_INVALIDDATE              CONSTANT INTEGER := 43;
DBERR_DATEMULTIPLMATCH         CONSTANT INTEGER := 44;
DBERR_INVALIDDATEFORMAT        CONSTANT INTEGER := 45;
DBERR_OPACTIVE                 CONSTANT INTEGER := 50;
DBERR_NEWNODENOTZERO           CONSTANT INTEGER := 51;
DBERR_NODELIMITOVERF           CONSTANT INTEGER := 52;
DBERR_ALLOWANYMT               CONSTANT INTEGER := 53;
DBERR_NOTINTRANSACTION         CONSTANT INTEGER := 54;
DBERR_DD                       CONSTANT INTEGER := 55;
DBERR_UPONE                    CONSTANT INTEGER := 56;
DBERR_UPINUSE                  CONSTANT INTEGER := 57;
DBERR_INVALIDKEY               CONSTANT INTEGER := 58;
DBERR_TOOMANYUSERS             CONSTANT INTEGER := 59;
DBERR_LICEXPIRED               CONSTANT INTEGER := 60;
DBERR_RECURSIVEDATA            CONSTANT INTEGER := 61;
DBERR_ALREADYEXISTS            CONSTANT INTEGER := 62;
DBERR_TRSEQ                    CONSTANT INTEGER := 63;
DBERR_OBJECTLCVERSIONMATCH     CONSTANT INTEGER := 64;
DBERR_SETCONNECTION            CONSTANT INTEGER := 65;
DBERR_DEADLOCKDETECTED         CONSTANT INTEGER := 66;
--67: connect canceled is a client only error and should not be used
DBERR_ALREADYCHECKEDOUT        CONSTANT INTEGER := 68;
DBERR_NOTCHECKEDOUT            CONSTANT INTEGER := 69;

/* Application generic errors  70-99 */
DBERR_VALUELISTTP              CONSTANT INTEGER := 70;
DBERR_DEFVALUETP               CONSTANT INTEGER := 71;
DBERR_AULEVEL                  CONSTANT INTEGER := 72;
DBERR_INHERITAU                CONSTANT INTEGER := 73;
DBERR_LOGHS                    CONSTANT INTEGER := 74;
DBERR_TEMPLATE                 CONSTANT INTEGER := 75;
DBERR_PROTECTED                CONSTANT INTEGER := 76;
DBERR_HIDDEN                   CONSTANT INTEGER := 77;
DBERR_ALLOWMODIFY              CONSTANT INTEGER := 78;
DBERR_ACTIVE                   CONSTANT INTEGER := 79;
DBERR_AR                       CONSTANT INTEGER := 80;
DBERR_INHERITGK                CONSTANT INTEGER := 81;
DBERR_NOCHANGE                 CONSTANT INTEGER := 82;
DBERR_NODEFVALUE               CONSTANT INTEGER := 83;
DBERR_UPPREF                   CONSTANT INTEGER := 84;
DBERR_SELCOLSINVALID           CONSTANT INTEGER := 85;
DBERR_NOWRITEACCESS            CONSTANT INTEGER := 86;
DBERR_USERNOTACTIVE            CONSTANT INTEGER := 87;
DBERR_UPNOTACTIVE              CONSTANT INTEGER := 88;
DBERR_SELECTED                 CONSTANT INTEGER := 89;
DBERR_MISSINGPRMT              CONSTANT INTEGER := 90;
DBERR_MULTISELECT              CONSTANT INTEGER := 91;
DBERR_INVALIDNAME              CONSTANT INTEGER := 92;
DBERR_AUTOREFRESH              CONSTANT INTEGER := 93;
DBERR_LOGHSDETAILS             CONSTANT INTEGER := 94;
DBERR_EMPTYSAVE                CONSTANT INTEGER := 95;

/* Lookup errors  100-109 */
DBERR_UQSHORTCUTKEY            CONSTANT INTEGER := 100;

/* Attribute errors  110-119 */
DBERR_NOAUNAME                 CONSTANT INTEGER := 110;
DBERR_SINGLEVALUED             CONSTANT INTEGER := 111;
DBERR_NEWVALALLOWED            CONSTANT INTEGER := 112;
DBERR_STOREDB                  CONSTANT INTEGER := 113;
DBERR_RUNMODE                  CONSTANT INTEGER := 114;

/* Unique code mask errors  120-129 */
DBERR_UC                       CONSTANT INTEGER := 120;
DBERR_EDITALLOWED              CONSTANT INTEGER := 121;
DBERR_FIXEDLENGTH              CONSTANT INTEGER := 122;
DBERR_UCSTRUCTURE              CONSTANT INTEGER := 123;
DBERR_SEQMAXMINVALUE           CONSTANT INTEGER := 124;
DBERR_SEQINCR                  CONSTANT INTEGER := 125;
DBERR_HIGHCNTNOTNULL           CONSTANT INTEGER := 126;
DBERR_UQDEFMASKFOR             CONSTANT INTEGER := 127;

/* Info field errors  130-149 */
DBERR_DSPTP                    CONSTANT INTEGER := 130;
DBERR_LU                       CONSTANT INTEGER := 131;
DBERR_DATATP                   CONSTANT INTEGER := 132;
DBERR_MANDATORY                CONSTANT INTEGER := 133;
DBERR_UQLU                     CONSTANT INTEGER := 134;
DBERR_UQSS                     CONSTANT INTEGER := 135;

/* Info profile errors  150-169 */

/* Parameter errors  170-189 */
DBERR_TDDELAY                  CONSTANT INTEGER := 170;
DBERR_CONFIRMUSERID            CONSTANT INTEGER := 171;
DBERR_CALCMETHOD               CONSTANT INTEGER := 172;
DBERR_DELAYUNIT                CONSTANT INTEGER := 173;
DBERR_LOGEXCEPTIONS            CONSTANT INTEGER := 174;
DBERR_ALLOWADD                 CONSTANT INTEGER := 175;
DBERR_IGNOREOTHER              CONSTANT INTEGER := 176;
DBERR_FREQTP                   CONSTANT INTEGER := 177;
DBERR_INVERTFREQ               CONSTANT INTEGER := 178;
DBERR_STFREQ                   CONSTANT INTEGER := 179;

/* Parameter profile errors  190-209 */
DBERR_CONFIRMASSIGN            CONSTANT INTEGER := 190;
DBERR_ADDMISSINGPR             CONSTANT INTEGER := 191;
DBERR_REMOVEEXTRACPR           CONSTANT INTEGER := 192;
DBERR_SPECSET                  CONSTANT INTEGER := 193;
DBERR_FREQVAL                  CONSTANT INTEGER := 194;
DBERR_LASTCNT                  CONSTANT INTEGER := 195;
DBERR_FREQUNIT                 CONSTANT INTEGER := 196;
DBERR_ISPP                     CONSTANT INTEGER := 197;
DBERR_NEVERCREATEMETHODS       CONSTANT INTEGER := 198;
DBERR_NOPPKEYID                CONSTANT INTEGER := 199;
DBERR_STPPNOTAUTHORISED        CONSTANT INTEGER := 200;

/* Method errors  210-229 */
DBERR_AUTORECALC               CONSTANT INTEGER := 210;
DBERR_CALIBRATION              CONSTANT INTEGER := 211;
DBERR_CELLTP                   CONSTANT INTEGER := 212;
DBERR_INPUTTP                  CONSTANT INTEGER := 213;
DBERR_ALIGN                    CONSTANT INTEGER := 214;
DBERR_CREATENEW                CONSTANT INTEGER := 215;
DBERR_SAVETP                   CONSTANT INTEGER := 216;
DBERR_CIRCULAR                 CONSTANT INTEGER := 217;
DBERR_CONFIRMCOMPLETE          CONSTANT INTEGER := 218;
DBERR_NOTCURRENTMETHOD         CONSTANT INTEGER := 219;
DBERR_AUTOCREATECELLS          CONSTANT INTEGER := 220;
DBERR_MERESULTEDITABLE         CONSTANT INTEGER := 221;

/* User profile errors  230-249 */
DBERR_CHGPWD                   CONSTANT INTEGER := 230;
DBERR_DEFINEMENU               CONSTANT INTEGER := 231;
DBERR_CONFIRMCHGSS             CONSTANT INTEGER := 232;
DBERR_SKIPMANDATORY            CONSTANT INTEGER := 233;
DBERR_US                       CONSTANT INTEGER := 234;
DBERR_FA                       CONSTANT INTEGER := 235;
DBERR_RULETP                   CONSTANT INTEGER := 236;
DBERR_RULEVAL                  CONSTANT INTEGER := 237;
DBERR_RULEOK                   CONSTANT INTEGER := 238;
DBERR_RULENOK                  CONSTANT INTEGER := 239;
DBERR_TK                       CONSTANT INTEGER := 240;
DBERR_INVALIDUSER              CONSTANT INTEGER := 241;
DBERR_INVALIDUP                CONSTANT INTEGER := 242;
DBERR_INHERITFLAG              CONSTANT INTEGER := 243;
DBERR_ISENABLED                CONSTANT INTEGER := 244;
DBERR_DBAUSER                  CONSTANT INTEGER := 245;
DBERR_INVALIDDD                CONSTANT INTEGER := 246;
DBERR_INVALIDPASSWORD          CONSTANT INTEGER := 247;

/* Groupkey errors  250-269 */
DBERR_UNIQUEGK                 CONSTANT INTEGER := 250;
DBERR_QCHECKAU                 CONSTANT INTEGER := 251;
DBERR_GKSTRUCTEXIST            CONSTANT INTEGER := 252;
DBERR_PASSWORD                 CONSTANT INTEGER := 253;

/* Lifecycle errors  270-289 */
DBERR_ENTRYACTION              CONSTANT INTEGER := 270;
DBERR_ENTRYTP                  CONSTANT INTEGER := 271;

/* Eventmanager errors  290-309 */
DBERR_EVENTTP                  CONSTANT INTEGER := 290;
DBERR_EVMGRTP                  CONSTANT INTEGER := 291;
DBERR_EVMGRPUBLIC              CONSTANT INTEGER := 292;

/* Address errors  310-329 */
DBERR_USEREXIST                CONSTANT INTEGER := 310;
DBERR_ISUSER                   CONSTANT INTEGER := 311;
DBERR_NOVIEWS                  CONSTANT INTEGER := 312;
DBERR_NOPACKAGES               CONSTANT INTEGER := 313;
DBERR_STRUCTCREATED            CONSTANT INTEGER := 315;
DBERR_NOTADBAUSER              CONSTANT INTEGER := 316;
DBERR_COLTP                    CONSTANT INTEGER := 321;
DBERR_COLASC                   CONSTANT INTEGER := 322;
DBERR_USCONNECTED              CONSTANT INTEGER := 323;
DBERR_USINUPCONNECTED          CONSTANT INTEGER := 324;

/* Custom function errors  330-349 */

/* Worksheet errors  350-399 */
DBERR_INVALWSMODFLAG           CONSTANT INTEGER := 350;
DBERR_MAXROWSOVERFLOW          CONSTANT INTEGER := 351;
DBERR_SC_COUNTER               CONSTANT INTEGER := 352;
DBERR_MIN_ROWS                 CONSTANT INTEGER := 353;
DBERR_MAX_ROWS                 CONSTANT INTEGER := 354;
DBERR_COMPLETE                 CONSTANT INTEGER := 355;
DBERR_WSLY                     CONSTANT INTEGER := 356;
DBERR_INVALIDROWNR             CONSTANT INTEGER := 357;
DBERR_SC_CREATE                CONSTANT INTEGER := 358;
DBERR_WSALREADYEXIST           CONSTANT INTEGER := 359;
DBERR_NODFLTMASKFORWS          CONSTANT INTEGER := 360;
DBERR_MULTDEFMASKFORWS         CONSTANT INTEGER := 361;

/* Infocard errors  400-449 */
DBERR_ICALREADYEXIST           CONSTANT INTEGER := 400;
DBERR_IIALREADYEXIST           CONSTANT INTEGER := 401;
DBERR_MANUALLYADDED            CONSTANT INTEGER := 440;
DBERR_MANUALLY_ENTERED         CONSTANT INTEGER := 441;

/* Method sheet errors  450-499 */
DBERR_ADDMETHODSNOTALLOWED     CONSTANT INTEGER := 450;

/* Sample errors  500-599 */
DBERR_NODFLTMASKFORSC          CONSTANT INTEGER := 500;
DBERR_MULTDEFMASKFORSC         CONSTANT INTEGER := 501;
DBERR_SCALREADYEXIST           CONSTANT INTEGER := 502;
DBERR_RQDOESNOTEXIST           CONSTANT INTEGER := 503;

/* Parameter group errors  600-649 */
DBERR_SELECTEQ                 CONSTANT INTEGER := 600;
DBERR_DETAILSEXIST             CONSTANT INTEGER := 601;
DBERR_PLAUSIBILITY             CONSTANT INTEGER := 602;
DBERR_COMPLETED                CONSTANT INTEGER := 603;
DBERR_MEALREADYEXIST           CONSTANT INTEGER := 604;
DBERR_RELLOWDEV                CONSTANT INTEGER := 630;
DBERR_RELHIGHDEV               CONSTANT INTEGER := 631;
DBERR_NORESULT                 CONSTANT INTEGER := 632;
DBERR_ALLOWANYME               CONSTANT INTEGER := 633;
DBERR_PGCONFIRMASSIGN          CONSTANT INTEGER := 634;
DBERR_PGALREADYEXIST           CONSTANT INTEGER := 635;

/* Parameter errors  650-699 */
DBERR_PAALREADYEXIST           CONSTANT INTEGER := 670;

/* Request types errors  700-729 */
DBERR_ALLOWANYST               CONSTANT INTEGER := 700;
DBERR_ALLOWNEWSC               CONSTANT INTEGER := 701;
DBERR_ADDSTPP                  CONSTANT INTEGER := 702;

/* Request errors  730-749 */
DBERR_RQALREADYEXIST           CONSTANT INTEGER := 730;
DBERR_NODFLTMASKFORRQ          CONSTANT INTEGER := 731;
DBERR_MULTDEFMASKFORRQ         CONSTANT INTEGER := 732;

/* Remote archiving errors  750-769 */
DBERR_COPYFLAG                 CONSTANT INTEGER := 750;
DBERR_DELETEFLAG               CONSTANT INTEGER := 751;
DBERR_NOEOF                    CONSTANT INTEGER := 752;

/* Unilink -standard format - unicom 4 - FGEN errors  770-799 */
DBERR_INVALIDSECTION           CONSTANT INTEGER := 770;
DBERR_NOPARENTOBJECT           CONSTANT INTEGER := 771;
DBERR_INVALIDROW               CONSTANT INTEGER := 772;
DBERR_INVALIDVARIABLE          CONSTANT INTEGER := 773;
DBERR_CREATESETTING            CONSTANT INTEGER := 774;
DBERR_INVALIDID                CONSTANT INTEGER := 775;

/* Equipment errors  800-850 */
DBERR_USEEQ                    CONSTANT INTEGER := 800;
DBERR_CALIBRATEEQ              CONSTANT INTEGER := 801;
DBERR_CAWARNLEVEL              CONSTANT INTEGER := 802;
DBERR_MTUSEDININTERVENTION     CONSTANT INTEGER := 803;
DBERR_CAINPROGRESS             CONSTANT INTEGER := 804;

/* CopySample / CopyRequest errors  851-880 */
DBERR_COPYIC                   CONSTANT INTEGER := 851;
DBERR_COPYPG                   CONSTANT INTEGER := 852;
DBERR_COPYSC                   CONSTANT INTEGER := 853;

/* Special condition/action return code  890-900 */
DBERR_STOPLCEVALUATION         CONSTANT INTEGER := 890;
DBERR_STOPEVMGR                CONSTANT INTEGER := 891;

/* Version control related errors */
DBERR_NOOBJVERSION             CONSTANT INTEGER := 901;
DBERR_NOCURRENTADVERSION       CONSTANT INTEGER := 902;
DBERR_NOCURRENTAUVERSION       CONSTANT INTEGER := 903;
DBERR_NOCURRENTEQVERSION       CONSTANT INTEGER := 904;
DBERR_NOCURRENTIEVERSION       CONSTANT INTEGER := 905;
DBERR_NOCURRENTIPVERSION       CONSTANT INTEGER := 906;
DBERR_NOCURRENTLCVERSION       CONSTANT INTEGER := 907;
DBERR_NOCURRENTMTVERSION       CONSTANT INTEGER := 908;
DBERR_NOCURRENTPPVERSION       CONSTANT INTEGER := 909;
DBERR_NOCURRENTPRVERSION       CONSTANT INTEGER := 910;
DBERR_NOCURRENTRTVERSION       CONSTANT INTEGER := 911;
DBERR_NOCURRENTSTVERSION       CONSTANT INTEGER := 912;
DBERR_NOCURRENTTKVERSION       CONSTANT INTEGER := 913;
DBERR_NOCURRENTUPVERSION       CONSTANT INTEGER := 914;
DBERR_NOCURRENTWTVERSION       CONSTANT INTEGER := 915;
DBERR_NOCURRENTPTVERSION       CONSTANT INTEGER := 916;
DBERR_NOCURRENTCYVERSION       CONSTANT INTEGER := 917;

DBERR_ADVERSION                CONSTANT INTEGER := 925;
DBERR_AUVERSION                CONSTANT INTEGER := 926;
DBERR_EQVERSION                CONSTANT INTEGER := 927;
DBERR_IEVERSION                CONSTANT INTEGER := 928;
DBERR_IPVERSION                CONSTANT INTEGER := 929;
DBERR_LCVERSION                CONSTANT INTEGER := 930;
DBERR_MTVERSION                CONSTANT INTEGER := 931;
DBERR_PPVERSION                CONSTANT INTEGER := 932;
DBERR_PRVERSION                CONSTANT INTEGER := 933;
DBERR_RTVERSION                CONSTANT INTEGER := 934;
DBERR_STVERSION                CONSTANT INTEGER := 935;
DBERR_TKVERSION                CONSTANT INTEGER := 936;
DBERR_UPVERSION                CONSTANT INTEGER := 937;
DBERR_WTVERSION                CONSTANT INTEGER := 938;

DBERR_NOTALLOWEDIN21CFR11      CONSTANT INTEGER := 939;

DBERR_PTVERSION                CONSTANT INTEGER := 940;
DBERR_CYVERSION                CONSTANT INTEGER := 941;

/* Charting errors  961-1000 */
DBERR_PARTIALCHARTSAVE         CONSTANT INTEGER := 961;
DBERR_CHARTNOTMODIFIABLE       CONSTANT INTEGER := 962;
DBERR_SQCRULEVIOLATED          CONSTANT INTEGER := 963; --temporary rteurn code - info return code - not an error

/* Stability errors  1001-1100 */
DBERR_NULLTIMEPOINT            CONSTANT INTEGER := 1001;
DBERR_TPUNIT                   CONSTANT INTEGER := 1002;
DBERR_SDALREADYEXIST           CONSTANT INTEGER := 1003;
DBERR_NODFLTMASKFORSD          CONSTANT INTEGER := 1004;
DBERR_MULTDEFMASKFORSD         CONSTANT INTEGER := 1005;
DBERR_INVALIDCSNODE            CONSTANT INTEGER := 1006;
DBERR_INVALIDTPNODE            CONSTANT INTEGER := 1007;
DBERR_NEWTPNODENOTZERO         CONSTANT INTEGER := 1008;
DBERR_NEWCSNODENOTZERO         CONSTANT INTEGER := 1009;

--error codes used by ALM: see package header of cxsapilk for details
--DBERR_OK_NO_ALM                CONSTANT INTEGER := 1100;
--DBERR_INVALIDLICENSE           CONSTANT INTEGER := 1101;
--DBERR_LICENSEEXPIRED           CONSTANT INTEGER := 1102;
--DBERR_NOLICENSE4APP            CONSTANT INTEGER := 1103;
--DBERR_TOOMANYUSERS4ALM         CONSTANT INTEGER := 1104;

/* Valid values for modify_flag */
MOD_FLAG_UPDATE                CONSTANT INTEGER := -1;
MOD_FLAG_INSERT                CONSTANT INTEGER := -2; /* used by proCX */
MOD_FLAG_DELETE                CONSTANT INTEGER := -3;
MOD_FLAG_CREATE                CONSTANT INTEGER := -4; /* used by proCX */
MOD_FLAG_INSERT_WITH_NODES     CONSTANT INTEGER := -5;
MOD_FLAG_INSERT_NODES_AND_CRAU CONSTANT INTEGER := -6;
MOD_FLAG_INSERT_AND_CRAU       CONSTANT INTEGER := -7;

/* Valid values for filter_freq flag */
NO_FREQ_FILTERING      CONSTANT CHAR := '0';
PERFORM_FREQ_FILTERING CONSTANT CHAR := '1';

/* Valid values for alarms_handled flag */
ALARMS_NOT_HANDLED       CONSTANT CHAR := '0';
ALARMS_PARTIALLY_HANDLED CONSTANT CHAR := '1';
ALARMS_ALREADY_HANDLED   CONSTANT CHAR := '2';

/* Valid values for eq and eqca ca_warn_level */
NORMAL_OPERATION                CONSTANT CHAR := '0';
IN_WARNING_PERIOD               CONSTANT CHAR := '1';
IN_GRACE_PERIOD                 CONSTANT CHAR := '2';
TO_CALIBRATE                    CONSTANT CHAR := '3';
OUT_OF_CALIBRATION              CONSTANT CHAR := '4';

/* Constants for SQC rules */
EXCEEDED_OUT_3S        CONSTANT INTEGER := 1;
EXCEEDED_OUT_2S        CONSTANT INTEGER := 2;
EXCEEDED_ABOVE_AVG     CONSTANT INTEGER := 3;
EXCEEDED_BELOW_AVG     CONSTANT INTEGER := 4;
EXCEEDED_RISING        CONSTANT INTEGER := 5;
EXCEEDED_FALLING       CONSTANT INTEGER := 6;

DEFAULT_NODE_INTERVAL CONSTANT INTEGER := 1000000;

--URL that will be used by SQLResultValue function to transform
--a longtext in a valid URL ~1~ and ~2~ will be replaced by the
--corresponding lines from the long text
P_DOC_LNK_URL     CONSTANT VARCHAR2(255) := '<a HREF="~1~">~2~</a>';
P_DOC_IMG_URL     CONSTANT VARCHAR2(255) := '<img SRC="~1~">';

-- Content type that will be used in the SendMail API's of packages unapigen and unaction.
P_SMTP_CONTENT_TYPE CONSTANT VARCHAR2(40) := 'text/plain; charset=utf-8';

--ENTERPRISE USER CONSTANTS
--This prefix is used to create the globally shared schemas in order to support Enterprise users
--We do not document this contsnat, we have it ready for customers that have very strict naming conventions
--and want absolutely to use another prefix
P_ENTERPRISE_USER_PREFIX CONSTANT VARCHAR2(20):= 'UNILAB_UP';
--These 2 regular expression elements are used to extract the user name that
--should apperar in the audit trail/user management for Enterprise users
--when the database is an Oracle 10 db
--In Oracle 11, we rely on SYS_CONTEXT('USERENV', 'AUTHENTICATED_IDENTITY') to do this
--In Oracle 10, there is nothing similar, we use REGEXP_REPLACE(SYS_CONTEXT('USERENV', 'EXTERNAL_NAME'), P_ORA10_REXEXP_PATTERN, P_ORA10_REXEXP_REPLACE)
--that will extract the username from a directory dn like: cn=Nelson,cn=users,dc=myregion,dc=mycompany,dc=com
P_ORA10_REXEXP_PATTERN CONSTANT VARCHAR2(80) := '([cn]*\=)([a-zA-Z0-9]*)\,([a-zA-Z0-9\,\=]*)';
P_ORA10_REXEXP_REPLACE CONSTANT VARCHAR2(80) := '\2';

FUNCTION GetVersion
RETURN VARCHAR2;

/* used by proCX */
FUNCTION BeginTransaction
RETURN NUMBER;

FUNCTION BeginTxn                 /* INTERNAL */
(a_txn_type       IN NUMBER DEFAULT P_MULTI_API_TXN )
RETURN NUMBER;

FUNCTION SynchrEndTransaction
RETURN NUMBER;

/* used by proCX */
FUNCTION EndTransaction
RETURN NUMBER;

FUNCTION SkipEventsInTransaction /* PLEASE DO NOT DOCUMENT */
RETURN NUMBER;

FUNCTION GetTxnId
(a_txn_id      OUT   NUMBER)     /* LONG_TYPE + INDICATOR */
RETURN NUMBER;

FUNCTION EndTxn                  /* INTERNAL */
(a_txn_type       IN NUMBER DEFAULT P_SINGLE_API_TXN )
RETURN NUMBER;

FUNCTION AbortTxn                /* INTERNAL */
(a_err_code         IN NUMBER,
 a_api_name         IN VARCHAR2)
RETURN NUMBER;

FUNCTION SetCustomConnectionParameter
(a_CustomConnectionParameter         IN VARCHAR2)    /* VC2000_TYPE */
RETURN NUMBER;

FUNCTION SetUsUserProfile
(a_up                 IN     NUMBER,   /* LONG_TYPE */
 a_us                 IN     VARCHAR2, /* VC20_TYPE */
 a_tk                 OUT    VARCHAR2, /* VC20_TYPE */
 a_language           OUT    VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetShortCutKey
(a_shortcut            OUT       RAW8_TABLE_TYPE,       /* RAW8_TABLE_TYPE */
 a_key_tp              OUT       VC2_TABLE_TYPE,        /* VC2_TABLE_TYPE */
 a_value_s             OUT       VC40_TABLE_TYPE,       /* VC40_TABLE_TYPE */
 a_value_f             OUT       NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE + INDICATOR */
 a_store_db            OUT       CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_run_mode            OUT       CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_service             OUT       VC255_TABLE_TYPE,      /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT    NUMBER)                /* NUM_TYPE */
RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2.
FUNCTION GetShortCutKey
(a_alt                 OUT       CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_ctrl                OUT       CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_shift               OUT       CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_key_name            OUT       VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_key_tp              OUT       VC2_TABLE_TYPE,        /* VC2_TABLE_TYPE */
 a_value_s             OUT       VC40_TABLE_TYPE,       /* VC40_TABLE_TYPE */
 a_value_f             OUT       NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE + INDICATOR */
 a_store_db            OUT       CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_run_mode            OUT       CHAR1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_service             OUT       VC255_TABLE_TYPE,      /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT    NUMBER)                /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetAllowedStatus
(a_object_lc          IN        VARCHAR2,         /* VC2_TYPE */
 a_cur_ss             IN        VARCHAR2,         /* VC2_TYPE */
 a_new_ss             OUT       VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_name            OUT       VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows         IN OUT    NUMBER)           /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetNextEventSeqNr                                 /* INTERNAL */
(a_seq_nr              IN OUT   NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AddObjectComment
(a_object_tp          IN       VARCHAR2, /* VC4_TYPE */
 a_object_id          IN       VARCHAR2, /* VC20_TYPE */
 a_object_version     IN       VARCHAR2, /* VC20_TYPE */
 a_comment            IN       VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetObjectComment
(a_object_tp        IN        VARCHAR2,             /* VC4_TYPE */
 a_object_id        OUT       VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_object_version   OUT       VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_last_comment     OUT       VC255_TABLE_TYPE,     /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN OUT    NUMBER,               /* NUM_TYPE */
 a_where_clause     IN        VARCHAR2,             /* VC511_TYPE */
 a_next_rows        IN        NUMBER)               /* NUM_TYPE */
RETURN NUMBER;

/* used by proCX */
FUNCTION SetConnection
(a_client_id          IN       VARCHAR2, /* VC20_TYPE */
 a_us                 IN       VARCHAR2, /* VC20_TYPE */
 a_password           IN       VARCHAR2, /* VC20_TYPE */
 a_applic             IN       VARCHAR2, /* VC8_TYPE */
 a_numeric_characters IN OUT   VARCHAR2, /* VC2_TYPE */
 a_date_format        IN OUT   VARCHAR2, /* VC255_TYPE */
 a_up                 OUT      NUMBER,   /* LONG_TYPE */
 a_user_profile       OUT      VARCHAR2, /* VC40_TYPE */
 a_language           OUT      VARCHAR2, /* VC20_TYPE */
 a_tk                 OUT      VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SetConnection
( a_client_id          IN     VARCHAR2, /* VC20_TYPE */
  a_us                 IN OUT VARCHAR2, /* VC20_TYPE */
  a_applic             IN     VARCHAR2, /* VC8_TYPE */
  a_numeric_characters IN OUT VARCHAR2, /* VC2_TYPE */
  a_date_format        IN OUT VARCHAR2, /* VC255_TYPE */
  a_up                 OUT    NUMBER,   /* LONG_TYPE */
  a_user_profile       OUT    VARCHAR2, /* VC40_TYPE */
  a_language           OUT    VARCHAR2, /* VC20_TYPE */
  a_tk                 OUT    VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SetConnection
( a_client_id          IN     VARCHAR2, /* VC20_TYPE */
  a_us                 IN OUT VARCHAR2, /* VC20_TYPE */
  a_password           IN     VARCHAR2, /* VC20_TYPE */
  a_applic             IN     VARCHAR2, /* VC8_TYPE */
  a_numeric_characters IN OUT VARCHAR2, /* VC2_TYPE */
  a_date_format        IN OUT VARCHAR2, /* VC255_TYPE */
  a_timezone           IN     VARCHAR2, /* VC255_TYPE */
  a_up                 OUT    NUMBER,   /* LONG_TYPE */
  a_user_profile       OUT    VARCHAR2, /* VC40_TYPE */
  a_language           OUT    VARCHAR2, /* VC20_TYPE */
  a_tk                 OUT    VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SetConnection4Install
( a_client_id          IN     VARCHAR2, /* VC20_TYPE */
  a_us                 IN OUT VARCHAR2, /* VC20_TYPE */
  a_applic             IN     VARCHAR2, /* VC8_TYPE */
  a_numeric_characters IN OUT VARCHAR2, /* VC2_TYPE */
  a_date_format        IN OUT VARCHAR2, /* VC255_TYPE */
  a_up                 OUT    NUMBER,   /* LONG_TYPE */
  a_user_profile       OUT    VARCHAR2, /* VC40_TYPE */
  a_language           OUT    VARCHAR2, /* VC20_TYPE */
  a_tk                 OUT    VARCHAR2, /* VC20_TYPE */
  a_install_busy       IN     CHAR)     /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION SetConnection4Install
( a_client_id          IN     VARCHAR2, /* VC20_TYPE */
  a_us                 IN OUT VARCHAR2, /* VC20_TYPE */
  a_applic             IN     VARCHAR2, /* VC8_TYPE */
  a_numeric_characters IN OUT VARCHAR2, /* VC2_TYPE */
  a_date_format        IN OUT VARCHAR2, /* VC255_TYPE */
  a_timezone           IN     VARCHAR2, /* VC255_TYPE */
  a_up                 OUT    NUMBER,   /* LONG_TYPE */
  a_user_profile       OUT    VARCHAR2, /* VC40_TYPE */
  a_language           OUT    VARCHAR2, /* VC20_TYPE */
  a_tk                 OUT    VARCHAR2, /* VC20_TYPE */
  a_install_busy       IN     CHAR)     /* CHAR1_TYPE */
RETURN NUMBER;


/* please only use for one specific far: use UNAPIUPP.GetUpUsFuncDetails for a list of far */
FUNCTION IsUserAuthorised
(a_up                 IN OUT   VARCHAR2, /* LONG_TYPE */
 a_us                 IN OUT   VARCHAR2, /* VC20_TYPE */
 a_applic             IN       VARCHAR2, /* VC20_TYPE */
 a_topic              IN       VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SwitchUser
( a_client_id          IN OUT VARCHAR2, /* VC20_TYPE */
  a_us                 IN     VARCHAR2, /* VC20_TYPE */
  a_password           IN     VARCHAR2, /* VC20_TYPE */
  a_applic             IN OUT VARCHAR2, /* VC8_TYPE */
  a_numeric_characters IN OUT VARCHAR2, /* VC2_TYPE */
  a_date_format        IN OUT VARCHAR2, /* VC255_TYPE */
  a_up                 IN OUT NUMBER,   /* LONG_TYPE + INDICATOR */
  a_user_profile       OUT    VARCHAR2, /* VC40_TYPE */
  a_language           OUT    VARCHAR2, /* VC20_TYPE */
  a_tk                 OUT    VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ResetConnection
RETURN NUMBER;

FUNCTION GetAttributeNames
(a_object_tp          IN        VARCHAR2,             /* VC4_TYPE */
 a_object_id          OUT       VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_au                 OUT       VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_description        OUT       VC40_TABLE_TYPE,      /* VC40_TABLE_TYPE */
 a_service            OUT       VC255_TABLE_TYPE,     /* VC255_TABLE_TYPE */
 a_nr_of_rows         IN OUT    NUMBER,               /* NUM_TYPE */
 a_where_clause       IN        VARCHAR2)             /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetUserProfilesForUser
(a_up           OUT    LONG_TABLE_TYPE,         /* LONG_TABLE_TYPE */
 a_description  OUT    VC40_TABLE_TYPE,         /* VC40_TABLE_TYPE */
 a_nr_of_rows   IN OUT NUMBER)                  /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetUserProfilesForUser
( a_up           OUT    LONG_TABLE_TYPE,          /* LONG_TABLE_TYPE */
  a_description  OUT    VC40_TABLE_TYPE,          /* VC40_TABLE_TYPE */
  a_dd       OUT    VC3_TABLE_TYPE,           /* VC3_TABLE_TYPE */
  a_where_clause IN     VARCHAR2,                 /* VC511_TYPE */
  a_nr_of_rows   IN OUT NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION UnExecDdl
(a_ddl_string   IN     VARCHAR2) /* VC3000_TYPE */
RETURN NUMBER;

FUNCTION UnExecDml1
(a_dml_string   IN     VARCHAR2,              /* VC3000_TYPE */
 a_dml1_value   OUT    VC255_TABLE_TYPE,      /* VC255_TABLE_TYPE */
 a_nr_of_rows   IN OUT NUMBER,                /* NUM_TYPE */
 a_next_rows    IN     NUMBER)                /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DateValid
(a_date_string  IN OUT VARCHAR2,              /* VC255_TYPE */
 a_error_msg    OUT    VARCHAR2)              /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DateValid                            /* INTERNAL */
(a_date_string  IN OUT VARCHAR2,              /* VC255_TYPE */
 a_date         OUT    DATE,                  /* DATE_TYPE  */
 a_error_msg    OUT    VARCHAR2)              /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SplitDate
(a_date_string  IN VARCHAR2,              /* VC255_TYPE */
 a_date_fmt     IN VARCHAR2 )             /* VC255_TYPE */
RETURN VARCHAR2;

FUNCTION ComposeDate
(a_date_string  IN VARCHAR2,              /* VC255_TYPE */
 a_date_fmt     IN VARCHAR2 )             /* VC255_TYPE */
RETURN VARCHAR2;

FUNCTION UnExecDml
(a_dml_string   IN     VARCHAR2,            /* VC3000_TYPE */
 a_dml_value    OUT    VC1000_TABLE_TYPE,   /* VC1000_TABLE_TYPE */
 a_nr_of_rows   IN OUT NUMBER,              /* NUM_TYPE */
 a_next_rows    IN     NUMBER)              /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetAuthorisation                               /* INTERNAL */
(a_object_tp           IN        VARCHAR2, /* VC4_TYPE */
 a_object_id           IN        VARCHAR2, /* VC20_TYPE */
 a_object_version      IN        VARCHAR2, /* VC20_TYPE */
 a_lc                  OUT       VARCHAR2, /* VC2_TYPE */
 a_lc_version          OUT       VARCHAR2, /* VC20_TYPE */
 a_ss                  OUT       VARCHAR2, /* VC2_TYPE */
 a_allow_modify        OUT       CHAR,     /* CHAR1_TYPE */
 a_active              OUT       CHAR,     /* CHAR1_TYPE */
 a_log_hs              OUT       CHAR)     /* CHAR1_TYPE */
RETURN NUMBER;

PROCEDURE LOGERRORNOREMOTEAPICALL      /* INTERNAL */
(A_API_NAME     IN        VARCHAR2,    /* VC40_TYPE */
 A_ERROR_MSG    IN        VARCHAR2);  /* VC255_TYPE */

PROCEDURE LogError                   /* INTERNAL */
(a_api_name     IN        VARCHAR2,  /* VC40_TYPE */
 a_error_msg    IN        VARCHAR2); /* VC255_TYPE */

FUNCTION GetDefaultLifeCycle
(a_object_tp    IN        VARCHAR2,  /* VC4_TYPE */
 a_def_lc       OUT       VARCHAR2,  /* VC2_TYPE */
 a_lc_name      OUT       VARCHAR2)  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SQLUnitConversionFactor               /* INTERNAL */
(a_src_unit             IN   VARCHAR2,         /* VC20_TYPE */
 a_dest_unit            IN   VARCHAR2)         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION TransformResult                      /* INTERNAL */
(a_src_value_s          IN      VARCHAR2,     /* VC40_TYPE */
 a_src_value_f          IN      NUMBER,       /* NUM_TYPE */
 a_src_unit             IN      VARCHAR2,     /* VC20_TYPE */
 a_src_format           IN      VARCHAR2,     /* VC40_TYPE */
 a_dest_value_s         OUT      VARCHAR2,     /* VC40_TYPE */
 a_dest_value_f         OUT      NUMBER,       /* NUM_TYPE */
 a_dest_unit            IN OUT  VARCHAR2,     /* VC20_TYPE */
 a_dest_format          IN OUT  VARCHAR2)     /* VC40_TYPE */
RETURN NUMBER;

FUNCTION FormatResult                      /* INTERNAL */
(a_value_f           IN OUT  NUMBER,       /* NUM_TYPE */
 a_format            IN      VARCHAR2,     /* VC40_TYPE */
 a_value_s           IN OUT  VARCHAR2)     /* VC40_TYPE */
RETURN NUMBER;

FUNCTION ReadOnlyFormatResult              /* INTERNAL */
(a_value_f           IN OUT  NUMBER,       /* NUM_TYPE */
 a_format            IN      VARCHAR2,     /* VC40_TYPE */
 a_value_s           IN OUT  VARCHAR2)     /* VC40_TYPE */
RETURN NUMBER;
PRAGMA RESTRICT_REFERENCES(ReadOnlyFormatResult, WNDS, WNPS);

FUNCTION SQLFormatResult                   /* INTERNAL */
(a_value_f           IN      NUMBER,       /* NUM_TYPE */
 a_format            IN      VARCHAR2)     /* VC40_TYPE */
RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(SQLFormatResult, WNDS, WNPS);

FUNCTION SQLFormatResult                   /* INTERNAL */
(a_value_s           IN      VARCHAR2,     /* VC40_TYPE */
 a_format            IN      VARCHAR2)     /* VC40_TYPE */
RETURN NUMBER;
PRAGMA RESTRICT_REFERENCES(SQLFormatResult, WNDS, WNPS);

FUNCTION SQLResultValue                    /* INTERNAL */
(a_value_s           IN      VARCHAR2,     /* VC40_TYPE */
 a_format            IN      VARCHAR2)     /* VC40_TYPE */
RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(SQLResultValue, WNDS, WNPS);

/* used by proCX */
FUNCTION GetApiVersion
(a_api_version      OUT       VARCHAR2)  /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetError
(a_client_id          OUT       VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_applic             OUT       VC8_TABLE_TYPE,       /* VC8_TABLE_TYPE */
 a_who                OUT       VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_logdate            OUT       DATE_TABLE_TYPE,      /* DATE_TABLE_TYPE */
 a_api_name           OUT       VC40_TABLE_TYPE,      /* VC40_TABLE_TYPE */
 a_error_msg          OUT       VC255_TABLE_TYPE,     /* VC255_TABLE_TYPE */
 a_nr_of_rows         IN OUT    NUMBER,               /* NUM_TYPE */
 a_where_clause       IN        VARCHAR2,             /* VC511_TYPE */
 a_next_rows          IN        NUMBER)               /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteError                    /* INTERNAL */
(a_where_clause      IN   VARCHAR2)     /* VC40_TYPE */
RETURN NUMBER;

--Auxiliary functions added above DBMS_LOCK
FUNCTION RequestLock                                            /* INTERNAL */
(a_lockname                   IN VARCHAR2,
 a_release_on_transaction_end IN CHAR,
 a_timeout                    IN NUMBER)
RETURN NUMBER;

FUNCTION ReleaseLock                                            /* INTERNAL */
(a_lockname                   IN VARCHAR2,
 a_timeout                    IN NUMBER)
RETURN NUMBER;

FUNCTION UniDecode
(a_type     IN    VARCHAR2,
 a_value    IN    NUMBER,
 a_unit     IN    VARCHAR2,
 a_invert   IN    NUMBER)
RETURN VARCHAR2;

PRAGMA RESTRICT_REFERENCES (UniDecode, WNDS, WNPS);

FUNCTION GetLongTextList
(a_obj_id              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_obj_tp              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_doc_id              OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_doc_tp              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_doc_name            OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_text_line           OUT     UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveLongText
(a_obj_id              IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_obj_tp              IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_doc_id              IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_doc_tp              IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_doc_name            IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_text_line           IN     UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_nr_of_rows          IN OUT NUMBER,                     /* NUM_TYPE */
 a_next_rows           IN     NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteLongText
(a_doc_name            IN     VARCHAR2)                   /* VC40_TYPE */
RETURN NUMBER;

FUNCTION IsExternalDBAUser    /* INTERNAL */
RETURN NUMBER;

FUNCTION StartNewVersionMgr                                /* INTERNAL */
RETURN NUMBER;

FUNCTION StopNewVersionMgr                                 /* INTERNAL */
RETURN NUMBER;

FUNCTION GetObjTpDescription      /* INTERNAL */
(a_obj_tp              IN       VARCHAR2)                  /* VC4_TABLE_TYPE */
RETURN VARCHAR2;

PROCEDURE NewVersionMgr;                                   /* INTERNAL */

FUNCTION UseVersion                           /* INTERNAL */
(a_object_tp              IN       VARCHAR2,  /* VC4_TYPE */
 a_object_id              IN       VARCHAR2,  /* VC20_TYPE */
 a_object_version         IN       VARCHAR2)  /* VC20_TYPE */
RETURN VARCHAR2 DETERMINISTIC;

FUNCTION UsePpVersion                         /* INTERNAL */
(a_pp                     IN       VARCHAR2,  /* VC20_TYPE */
 a_version                IN       VARCHAR2,  /* VC20_TYPE */
 a_pp_key1                IN       VARCHAR2,  /* VC20_TYPE */
 a_pp_key2                IN       VARCHAR2,  /* VC20_TYPE */
 a_pp_key3                IN       VARCHAR2,  /* VC20_TYPE */
 a_pp_key4                IN       VARCHAR2,  /* VC20_TYPE */
 a_pp_key5                IN       VARCHAR2)  /* VC20_TYPE */
RETURN VARCHAR2 DETERMINISTIC;

FUNCTION UseVersion4Tk                     /* INTERNAL */
(a_tk_tp               IN       VARCHAR2,  /* VC20_TYPE */
 a_tk                  IN       VARCHAR2,  /* VC20_TYPE */
 a_tk_version          IN       VARCHAR2)  /* VC20_TYPE */
RETURN VARCHAR2 DETERMINISTIC;

FUNCTION ValidateVersion                                  /* INTERNAL */
(a_object_tp              IN       VARCHAR2,              /* VC4_TYPE */
 a_object_id              IN       VARCHAR2,              /* VC20_TYPE */
 a_object_version         IN       VARCHAR2)              /* VC20_TYPE */
RETURN VARCHAR2 DETERMINISTIC;

--The argument a_alt_object_version will be filled in when this function is called
--in the where clause of a query.
--When the a_alt_object_version is filled in, that value is
--returned instead of raising an exception
--This is necessary since the order of joins was no more predictable
--with the introduction of the cost based optimiser support
--e.g
--SELECT a.*
--   FROM utppau a, utpp b, utstpp c
--   WHERE a.pp      = :c_pp
--     AND a.version = :c_pp_version
--     AND a.pp_key1 = :c_pp_key1 AND a.pp_key2 = :c_pp_key2  AND a.pp_key3 = :c_pp_key3    AND a.pp_key4 = :c_pp_key4     AND a.pp_key5 = :c_pp_key5
--     AND a.pp      = b.pp
--     AND a.version = b.version
--     AND a.pp_key1 = b.pp_key1   AND a.pp_key2 = b.pp_key2    AND a.pp_key3 = b.pp_key3     AND a.pp_key4 = b.pp_key4     AND a.pp_key5 = b.pp_key5
--     AND c.st = :c_st
--     AND c.version = :c_st_version
--     AND c.pp      = b.pp
--     AND c.pp_key1 = b.pp_key1   AND c.pp_key2 = b.pp_key2     AND c.pp_key3 = b.pp_key3     AND c.pp_key4 = b.pp_key4    AND c.pp_key5 = b.pp_key5
--     AND Unapigen.ValidatePpVersion(c.pp, c.pp_version, c.pp_key1, c.pp_key2, c.pp_key3, c.pp_key4, c.pp_key5) = b.version
--
-- For some strange reason, it is not using the pp_keys to scan utstpp
-- This is rasing annoying exceptions when some parameter profiles are ready for one context but not in another
-- Adding c.pp_key1 = :c_pp_key1 would solve the problem in our example which is
-- very strange since our index ukstpp (ST, VERSION, PP, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5)
-- has the right structure, the value of :c_pp is passed from a to b and b to c
-- but the same does not happen for pp_keyX columns
--
-- We experienced the problem with the rule-based optimizer
-- The exception "No current version" could be raised abnormaly while
-- performing a query where normally it should not have to go through records
-- with a different pp_key[] than the one specified
-- We solved it in the time of the rule-based optimizer by chaning the join order
-- but we are fearing similar phenomenon with the cost-based optimizer
-- since the way of joining might be completely different
--
-- The problem is only experienced by ValidatPpVersion
-- not in the classic ValidateVersion as far as I know
-- The queries using ValidatePpVersion have been adapted in the following way
--
--The new functions applied to the preceding example:
--
--SELECT a.*, Unapigen.ValidatePpVersion(c.pp, c.pp_version, c.pp_key1, c.pp_key2, c.pp_key3, c.pp_key4, c.pp_key5)
--   FROM utppau a, utpp b, utstpp c
--   WHERE a.pp      = :c_pp
--     AND a.version = :c_pp_version
--     AND a.pp_key1 = :c_pp_key1 AND a.pp_key2 = :c_pp_key2  AND a.pp_key3 = :c_pp_key3    AND a.pp_key4 = :c_pp_key4     AND a.pp_key5 = :c_pp_key5
--     AND a.pp      = b.pp
--     AND a.version = b.version
--     AND a.pp_key1 = b.pp_key1   AND a.pp_key2 = b.pp_key2    AND a.pp_key3 = b.pp_key3     AND a.pp_key4 = b.pp_key4     AND a.pp_key5 = b.pp_key5
--     AND c.st = :c_st
--     AND c.version = :c_st_version
--     AND c.pp      = b.pp
--     AND c.pp_key1 = b.pp_key1   AND c.pp_key2 = b.pp_key2     AND c.pp_key3 = b.pp_key3     AND c.pp_key4 = b.pp_key4    AND c.pp_key5 = b.pp_key5
--     AND Unapigen.ValidatePpVersion(c.pp, c.pp_version, c.pp_key1, c.pp_key2, c.pp_key3, c.pp_key4, c.pp_key5, b.version) = b.version
--
-- The ValidatePpVersion in the where clause will not raise an exception but return the records since b.version is matching b.version
-- The validation has been moved to the SELECT clause of the query that will raise an exception only the returned sets
-- which is what we are fexpecting from the system from a functional point of view

FUNCTION ValidatePpVersion                                   /* INTERNAL */
(a_pp                     IN       VARCHAR2,                 /* VC20_TYPE */
 a_version                IN       VARCHAR2,                 /* VC20_TYPE */
 a_pp_key1                IN       VARCHAR2,                 /* VC20_TYPE */
 a_pp_key2                IN       VARCHAR2,                 /* VC20_TYPE */
 a_pp_key3                IN       VARCHAR2,                 /* VC20_TYPE */
 a_pp_key4                IN       VARCHAR2,                 /* VC20_TYPE */
 a_pp_key5                IN       VARCHAR2,                 /* VC20_TYPE */
 a_alt_object_version     IN       VARCHAR2 DEFAULT NULL,    /* VC20_TYPE */
 a_return_error_instead   IN       VARCHAR2 DEFAULT 'FALSE') /* VC20_TYPE */
RETURN VARCHAR2 DETERMINISTIC;

FUNCTION SQLUserDescription                               /* INTERNAL */
(a_ad              IN       VARCHAR2)                     /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLSsName                               /* INTERNAL */
(a_ss              IN       VARCHAR2)            /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLLcName                               /* INTERNAL */
(a_lc              IN       VARCHAR2)            /* VC2_TYPE */
RETURN VARCHAR2;

FUNCTION SQLCurrentVersion                       /* INTERNAL */
(a_obj_tp          IN       VARCHAR2,            /* VC2_TYPE */
 a_obj_id          IN       VARCHAR2)            /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLCurrentPpVersion                     /* INTERNAL */
(a_pp                     IN       VARCHAR2,     /* VC20_TYPE */
 a_version                IN       VARCHAR2,     /* VC20_TYPE */
 a_pp_key1                IN       VARCHAR2,     /* VC20_TYPE */
 a_pp_key2                IN       VARCHAR2,     /* VC20_TYPE */
 a_pp_key3                IN       VARCHAR2,     /* VC20_TYPE */
 a_pp_key4                IN       VARCHAR2,     /* VC20_TYPE */
 a_pp_key5                IN       VARCHAR2)     /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION IsSystem21CFR11Compliant
RETURN NUMBER;

--These functions will only work on Oracle8.1
--where the Jserver option has been installed
FUNCTION SendMail                                      /* INTERNAL */
(a_recipient        IN   VARCHAR2,                     /* VC255_TYPE */
 a_subject          IN   VARCHAR2,                     /* VC255_TYPE */
 a_text_tab         IN   UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

PROCEDURE ActivateObject                     /* INTERNAL */
(a_object_tp            IN     VARCHAR2,     /* VC4_TYPE */
 a_object_id            IN     VARCHAR2,     /* VC20_TYPE */
 a_object_old_version   IN     VARCHAR2,     /* VC20_TYPE */
 a_object_new_version   IN     VARCHAR2,     /* VC20_TYPE */
 a_refdate              IN     DATE);        /* DATE_TYPE */

PROCEDURE DeActivateObject               /* INTERNAL */
(a_object_tp        IN     VARCHAR2,     /* VC4_TYPE */
 a_object_id        IN     VARCHAR2,     /* VC20_TYPE */
 a_object_version   IN     VARCHAR2,     /* VC20_TYPE */
 a_refdate          IN     DATE,         /* DATE_TYPE */
 a_sendemail        IN     CHAR);        /* CHAR1_TYPE */

PROCEDURE ActivatePp                         /* INTERNAL */
(a_pp                   IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_old_version       IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_new_version       IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key1              IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key2              IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key3              IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key4              IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key5              IN     VARCHAR2,     /* VC20_TYPE */
 a_refdate              IN     DATE);        /* DATE_TYPE */

PROCEDURE DeActivatePp                   /* INTERNAL */
(a_pp               IN     VARCHAR2,     /* VC20_TYPE */
 a_version          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key1          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key2          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key3          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key4          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key5          IN     VARCHAR2,     /* VC20_TYPE */
 a_refdate          IN     DATE,         /* DATE_TYPE */
 a_sendemail        IN     CHAR);        /* CHAR1_TYPE */

FUNCTION EvalVersion                     /* INTERNAL */
(a_object_tp        IN     VARCHAR2,     /* VC4_TYPE */
 a_object_id        IN     VARCHAR2,     /* VC20_TYPE */
 a_object_version   IN     VARCHAR2)     /* VC20_TYPE */
RETURN NUMBER;

FUNCTION EvalPpVersion                   /* INTERNAL */
(a_pp               IN     VARCHAR2,     /* VC20_TYPE */
 a_version          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key1          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key2          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key3          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key4          IN     VARCHAR2,     /* VC20_TYPE */
 a_pp_key5          IN     VARCHAR2)     /* VC20_TYPE */
RETURN NUMBER;

FUNCTION TildeSubstitution
(a_object_tp         IN    VARCHAR2,   /* VC4_TYPE */
 a_object_key        IN    VARCHAR2,   /* VC255_TYPE */
 a_asked_value       IN    VARCHAR2,   /* VC255_TYPE */
 a_value_s           OUT   VARCHAR2,   /* VC2000_TYPE */
 a_value_f           OUT   NUMBER,     /* NUM_TYPE */
 a_value_d           OUT   DATE)       /* DATE_TYPE */
RETURN NUMBER;

FUNCTION SubstituteAllTildesInText
(a_object_tp     IN     VARCHAR2,   /* VC4_TYPE */
 a_object_key    IN      VARCHAR2,  /* VC255_TYPE */
 a_text          IN OUT  VARCHAR2)  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetUnit
(a_unit                        OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_unit_tp                     OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_conv_factor                 OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_nr_of_rows                  IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause                IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION Cx_RPAD
(a_inputstring                 IN      VARCHAR2,
 a_size                        IN      NUMBER,
 a_paddingstring               IN      VARCHAR2)
RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(Cx_RPAD, WNDS, WNPS);

FUNCTION Cx_LPAD
(a_inputstring                 IN      VARCHAR2,
 a_size                        IN      NUMBER,
 a_paddingstring               IN      VARCHAR2)
RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(Cx_LPAD, WNDS, WNPS);

FUNCTION  IsSystemSupportingEqMngmt
RETURN NUMBER;

FUNCTION IsSystemSupportingRnDSuite
RETURN NUMBER;

FUNCTION SetSessionRnDSuiteModeOn
RETURN NUMBER;

FUNCTION SetSessionRnDSuiteModeOff
RETURN NUMBER;

FUNCTION SelectCountEventsToProcess
(a_txn_id      IN    NUMBER,     /* LONG_TYPE + INDICATOR */
 a_count_ev    OUT   NUMBER)     /* NUM_TYPE */
RETURN NUMBER;

PROCEDURE U4COMMIT;

PROCEDURE U4ROLLBACK;

PROCEDURE U4SAVEPOINT
(a_savepoint   IN VARCHAR2);

PROCEDURE U4ROLLBACK2SAVEPOINT
(a_savepoint   IN VARCHAR2);

--global cursor used to find the definition for used attributes
CURSOR l_audet_cursor(c_au VARCHAR2, c_au_version VARCHAR2) IS
  SELECT description, is_protected, single_valued,
         new_val_allowed, store_db, value_list_tp,
         run_mode, service, cf_value
  FROM utau
  WHERE au = c_au
  /* current or highest version returned */
  AND version = NVL(UNAPIGEN.UseVersion('au', c_au, c_au_version), UNAPIGEN.useVersion('au', c_au, '*'));

FUNCTION UserEnv
(a_environment_variable                IN      VARCHAR2)                   /* VC511_TYPE */
RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(UserEnv, WNDS, WNPS);

PROCEDURE SetPpKeysContext;

FUNCTION GetMaxSamples
(a_max_number_of_samples      OUT NUMBER)
RETURN NUMBER;

FUNCTION ChangeSessionTimeZone
(a_TimeZone        IN VARCHAR2)                /* VC255_TYPE */
RETURN NUMBER;


PROCEDURE WhereClauseStringBuilder
         ( a_base_table          IN VARCHAR2,
           a_index               IN INTEGER,
           a_col_tp              IN VARCHAR2,
           a_col_id              IN VARCHAR2,
           a_col_value           IN VARCHAR2,
           a_col_operator        IN VARCHAR2,
           a_col_andor           IN VARCHAR2,
           a_anyor_present       IN BOOLEAN,
           a_jointable_prefix    IN VARCHAR2,
           a_joincolumn1         IN VARCHAR2,
           a_joincolumn2         IN VARCHAR2,
           a_prev_col_tp         IN OUT VARCHAR2,
           a_prev_col_id         IN OUT VARCHAR2,
           a_prev_col_index      IN OUT VARCHAR2,
           a_nexttable_tojoin    IN OUT VARCHAR2,
           a_from_clause         IN OUT VARCHAR2,
           a_where_clause4join   IN OUT VARCHAR2,
           a_where_clause        IN OUT VARCHAR2,
           a_basetable4gk_alias  IN VARCHAR2 DEFAULT NULL,
           a_sql_val_tab         IN OUT VC40_NESTEDTABLE_TYPE);

PROCEDURE NotifyTaskGKToDBA
         (
           a_object_tp        IN     VARCHAR2,
           a_object_id        IN     VARCHAR2,
           a_object_version   IN     VARCHAR2,
           a_value_unique     IN     CHAR);


FUNCTION  GetProductComponentVersion
(
   a_product   OUT VARCHAR2,
   a_version   OUT VARCHAR2
) RETURN BOOLEAN;

FUNCTION  GetPackageVersion
(
   a_object_name   IN VARCHAR2
) RETURN VARCHAR;

TYPE IndexedByVarchar2Tab IS TABLE OF NUMBER INDEX BY VARCHAR2(30);
P_EQ_POINTER    IndexedByVarchar2Tab;
P_EV_POINTER    IndexedByVarchar2Tab;

END unapigen;
/
