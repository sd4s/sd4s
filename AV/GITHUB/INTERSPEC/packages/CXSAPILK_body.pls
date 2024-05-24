CREATE OR REPLACE PACKAGE BODY cxsapilk
AS






















 



 L_RET_CODE NUMBER;
 P_ENCRYPTION_KEY RAW( 24 );
 P_DYNAMIC_ENCRYPTION_KEY RAW( 24 );
 P_ENCRYPTION_KEY_NORMAL RAW( 24 );
 P_ENCRYPTION_KEY_RECOVERED RAW( 24 );
 P_UNIVERSAL_ENCRYPTION_KEY RAW( 24 );
 P_LICENSES_RECOVERED CHAR( 1 ) DEFAULT '0';
 P_NOLICENSES_INSTALLED CHAR( 1 ) DEFAULT '0';
 P_SID_NAME VARCHAR2( 9 );
 P_GETLICENSE_CURSOR INTEGER;
 P_GETLICENSEUSAGE_CURSOR INTEGER;
 P_LICENSE_USAGE INTEGER;
 P_LAST_STRING4APP VARCHAR2( 60 );
 P_LAST_STRING4LICENSE VARCHAR2( 60 );

 RECO_SERIAL_ID CONSTANT RAW( 1 ) := HEXTORAW( 'FF' );
 RECO_SHORTNAME CONSTANT RAW( 1 ) := HEXTORAW( 'FF' );
 L_AUDSID_FOR_CURRENT_SESSION NUMBER;

 MOD_FLAG_UPDATE CONSTANT INTEGER := -1;
 MOD_FLAG_INSERT CONSTANT INTEGER := -2; 
 MOD_FLAG_DELETE CONSTANT INTEGER := -3;

 CURSOR L_CTLICUSERCNT_CURSOR(
 A_USER_SID_ENCRYPTED IN RAW,
 A_APP_ID_ENCRYPTED IN RAW,
 A_LOGON_STATION_ENCRYPTED IN RAW,
 A_AUDSID_ENCRYPTED IN RAW )
 IS
 SELECT A.USER_SID,
 A.USER_NAME,
 A.APP_ID,
 A.APP_VERSION,
 A.APP_CUSTOM_PARAM,
 A.LIC_CHECK_APPLIES,
 A.LOGON_DATE,
 A.LAST_HEARTBEAT,
 A.LOGOFF_DATE,
 A.LOGON_STATION,
 A.AUDSID,
 A.ROWID
 FROM CTLICUSERCNT A
 WHERE USER_SID = A_USER_SID_ENCRYPTED
 AND APP_ID = A_APP_ID_ENCRYPTED
 AND LOGON_STATION = A_LOGON_STATION_ENCRYPTED
 AND AUDSID = A_AUDSID_ENCRYPTED;





 TYPE CTLICUSERCNT_TABLE_REC IS RECORD(
 USER_SID RAW( 80 ),
 USER_NAME RAW( 160 ),
 APP_ID RAW( 32 ),
 APP_VERSION RAW( 32 ),
 APP_CUSTOM_PARAM RAW( 32 ),
 LIC_CHECK_APPLIES RAW( 8 ),
 LOGON_DATE RAW( 24 ),
 LAST_HEARTBEAT RAW( 24 ),
 LOGOFF_DATE RAW( 24 ),
 LOGON_STATION RAW( 160 ),
 AUDSID RAW( 40 ),
 INTERNAL_ROWID ROWID
 );

 TYPE CTLICUSERCNT_TABLE_TYPE IS TABLE OF CTLICUSERCNT_TABLE_REC; 

 L_CTLICUSERCNT_NEWREC CTLICUSERCNT_TABLE_REC;
 L_CTLICUSERCNT_OLDREC_TAB CTLICUSERCNT_TABLE_TYPE := CTLICUSERCNT_TABLE_TYPE( );


 FUNCTION INITENCRYPTIONKEY
 RETURN NUMBER
 IS
 CURSOR L_VDATABASE_CURSOR
 IS
 SELECT *
 FROM SYS.V_$DATABASE
 WHERE ROWNUM = 1;

 L_VDATABASE_REC L_VDATABASE_CURSOR%ROWTYPE;

 CURSOR L_VINSTANCE_CURSOR
 IS
 SELECT *
 FROM SYS.V_$INSTANCE
 WHERE ROWNUM = 1;

 L_VINSTANCE_REC L_VINSTANCE_CURSOR%ROWTYPE;

 CURSOR L_VDATAFILE_CURSOR
 IS
 SELECT *
 FROM SYS.V_$DATAFILE
 ORDER BY FILE# ASC;

 L_VDATAFILE_REC L_VDATAFILE_CURSOR%ROWTYPE;
 L_LENGTH_FILENAME INTEGER;
 L_ACTUAL_LENGTH INTEGER;
 L_ENCRYPTION_KEY VARCHAR2( 24 );
 L_UNIVERSAL_KEY_STRING VARCHAR2( 128 );
 BEGIN
 
 
 
 L_UNIVERSAL_KEY_STRING :=
 CHR( 50 )
 || CHR( 51 )
 || CHR( 53 )
 || CHR( 65 )
 || CHR( 52 )
 || CHR( 55 )
 || CHR( 56 )
 || CHR( 51 )
 || CHR( 57 )
 || CHR( 66 )
 || CHR( 55 )
 || CHR( 68 )
 || CHR( 54 )
 || CHR( 49 )
 || CHR( 69 )
 || CHR( 55 )
 || CHR( 55 )
 || CHR( 50 )
 || CHR( 55 )
 || CHR( 65 )
 || CHR( 68 )
 || CHR( 53 )
 || CHR( 65 )
 || CHR( 49 )
 || CHR( 57 )
 || CHR( 52 )
 || CHR( 55 )
 || CHR( 49 )
 || CHR( 68 )
 || CHR( 70 )
 || CHR( 51 )
 || CHR( 54 )
 || CHR( 69 )
 || CHR( 53 )
 || CHR( 55 )
 || CHR( 49 )
 || CHR( 51 )
 || CHR( 50 )
 || CHR( 68 )
 || CHR( 66 )
 || CHR( 57 )
 || CHR( 54 )
 || CHR( 53 )
 || CHR( 56 )
 || CHR( 66 )
 || CHR( 68 )
 || CHR( 53 )
 || CHR( 69 );
 
 
 
 P_UNIVERSAL_ENCRYPTION_KEY := UTL_RAW.SUBSTR( UTL_RAW.CAST_TO_RAW( L_UNIVERSAL_KEY_STRING ),
 1,
 24 );

 
 
 
 IF P_ENCRYPTION_KEY_NORMAL IS NULL
 THEN
 
 OPEN L_VDATABASE_CURSOR;

 FETCH L_VDATABASE_CURSOR
 INTO L_VDATABASE_REC;

 CLOSE L_VDATABASE_CURSOR;

 L_ENCRYPTION_KEY := L_VDATABASE_REC.NAME
 || TO_CHAR( L_VDATABASE_REC.CREATED,
 'DDMMYYYYHH24MISS' );
 P_SID_NAME := L_VDATABASE_REC.NAME;
 L_ACTUAL_LENGTH := LENGTHB( L_ENCRYPTION_KEY );

 IF L_ACTUAL_LENGTH < 24
 THEN
 FOR L_VDATAFILE_REC IN L_VDATAFILE_CURSOR
 LOOP
 L_LENGTH_FILENAME := LENGTHB( L_VDATAFILE_REC.NAME );

 IF L_LENGTH_FILENAME
 + L_ACTUAL_LENGTH > 24
 THEN
 L_ENCRYPTION_KEY := L_ENCRYPTION_KEY
 || SUBSTRB( L_VDATAFILE_REC.NAME,
 1,
 24
 - L_ACTUAL_LENGTH );
 ELSE
 L_ENCRYPTION_KEY := L_ENCRYPTION_KEY
 || L_VDATAFILE_REC.NAME;
 END IF;

 L_ACTUAL_LENGTH := LENGTHB( L_ENCRYPTION_KEY );
 EXIT WHEN L_ACTUAL_LENGTH >= 24;
 END LOOP;
 END IF;

 IF L_ACTUAL_LENGTH <> 24
 THEN
 RAISE_APPLICATION_ERROR( -20000,
 'Problem encountered during license check -error step 1' );
 END IF;

 P_ENCRYPTION_KEY_NORMAL := UTL_RAW.SUBSTR( UTL_RAW.CAST_TO_RAW( L_ENCRYPTION_KEY ),
 1,
 24 );

 IF UTL_RAW.LENGTH( P_ENCRYPTION_KEY_NORMAL ) <> 24
 THEN
 RAISE_APPLICATION_ERROR( -20000,
 'Problem encountered during license check -error step 2' );
 END IF;
 END IF;

 IF P_DYNAMIC_ENCRYPTION_KEY IS NULL
 THEN
 
 OPEN L_VINSTANCE_CURSOR;

 FETCH L_VINSTANCE_CURSOR
 INTO L_VINSTANCE_REC;

 CLOSE L_VINSTANCE_CURSOR;

 P_DYNAMIC_ENCRYPTION_KEY :=
 UTL_RAW.SUBSTR( UTL_RAW.CAST_TO_RAW( TO_CHAR( L_VINSTANCE_REC.STARTUP_TIME,
 'FXDDMMYYYYHH24MISSSSMIHH24MMDD' ) ),
 1,
 24 );
 END IF;




 RETURN( CXSAPILK.DBERR_SUCCESS );
 END INITENCRYPTIONKEY;

 FUNCTION DECRYPT 
 (
 A_INPUT_RAW IN RAW,
 A_DECRYPTED_DATA OUT VARCHAR2,
 A_DEBUG IN BOOLEAN DEFAULT FALSE )
 RETURN NUMBER
 IS
 L_DECRYPTED_RAW RAW( 1020 );
 BEGIN

 IF A_INPUT_RAW IS NULL
 THEN
 A_DECRYPTED_DATA := NULL;
 RETURN( CXSAPILK.DBERR_SUCCESS );
 END IF;

 SYS.DBMS_OBFUSCATION_TOOLKIT.DES3DECRYPT( INPUT => A_INPUT_RAW,
 KEY => P_ENCRYPTION_KEY,
 DECRYPTED_DATA => L_DECRYPTED_RAW,
 WHICH => '1' );

 
 IF A_DEBUG
 THEN
 IF P_ENCRYPTION_KEY = P_ENCRYPTION_KEY_NORMAL
 THEN
 DBMS_OUTPUT.PUT_LINE( SUBSTR( 'Decrypt input:#'
 || A_INPUT_RAW
 || '#(1)',
 1,
 200 ) );
 DBMS_OUTPUT.PUT_LINE( SUBSTR( 'Decrypt ouput:#'
 || RTRIM( UTL_RAW.CAST_TO_VARCHAR2( L_DECRYPTED_RAW ),
 CHR( 0 ) )
 || '#(1)',
 1,
 200 ) );
 ELSE
 DBMS_OUTPUT.PUT_LINE( SUBSTR( 'Decrypt input:#'
 || A_INPUT_RAW
 || '#(2)',
 1,
 200 ) );
 DBMS_OUTPUT.PUT_LINE( SUBSTR( 'Decrypt ouput:#'
 || RTRIM( UTL_RAW.CAST_TO_VARCHAR2( L_DECRYPTED_RAW ),
 CHR( 0 ) )
 || '#(2)',
 1,
 200 ) );
 END IF;
 END IF;

 A_DECRYPTED_DATA := RTRIM( UTL_RAW.CAST_TO_VARCHAR2( L_DECRYPTED_RAW ),
 CHR( 0 ) );

 RETURN( CXSAPILK.DBERR_SUCCESS );
 
 END DECRYPT;

 FUNCTION UNIVERSALDECRYPT 
 (
 A_INPUT_RAW IN RAW,
 A_DECRYPTED_DATA OUT RAW )
 RETURN NUMBER
 IS
 BEGIN

 IF A_INPUT_RAW IS NULL
 THEN
 A_DECRYPTED_DATA := NULL;
 RETURN( CXSAPILK.DBERR_SUCCESS );
 END IF;

 SYS.DBMS_OBFUSCATION_TOOLKIT.DES3DECRYPT( INPUT => A_INPUT_RAW,
 KEY => P_UNIVERSAL_ENCRYPTION_KEY,
 DECRYPTED_DATA => A_DECRYPTED_DATA,
 WHICH => '1' );




 
 RETURN( CXSAPILK.DBERR_SUCCESS );
 
 END UNIVERSALDECRYPT;














 FUNCTION ENCRYPT 
 (
 A_INPUT_STRING IN VARCHAR2,
 A_ENCRYPTED_DATA OUT RAW,
 A_DEBUG IN BOOLEAN DEFAULT FALSE )
 RETURN NUMBER
   IS
      L_NEW_LENGTH                  INTEGER;
      L_VC2000                      VARCHAR2( 2000 );
   BEGIN
      
      IF A_INPUT_STRING IS NULL
      THEN
         A_ENCRYPTED_DATA := NULL;
         RETURN( CXSAPILK.DBERR_SUCCESS );
      END IF;

      L_NEW_LENGTH :=   (   TRUNC(   LENGTHB( A_INPUT_STRING )
                                   / 8 )
                          + 1 )
                      * 8;
      SYS.DBMS_OBFUSCATION_TOOLKIT.DES3ENCRYPT
                                              
                                              
                                              
                                              
                                              
                                              
                                              
                                              
                                              
                                              
      (                                         INPUT => UTL_RAW.CAST_TO_RAW( SUBSTRB( RPAD( A_INPUT_STRING,
                                                                                             L_NEW_LENGTH,
                                                                                             CHR( 0 ) ),
                                                                                       1,
                                                                                       L_NEW_LENGTH ) ),
                                                KEY => P_ENCRYPTION_KEY,
                                                ENCRYPTED_DATA => A_ENCRYPTED_DATA,
                                                WHICH => '1' );




      








      RETURN( CXSAPILK.DBERR_SUCCESS );
   
   END ENCRYPT;

   FUNCTION UNIVERSALENCRYPT   
                            (
      A_INPUT_RAW                IN       RAW,
      A_ENCRYPTED_DATA           OUT      RAW )
      RETURN NUMBER
   IS
      L_RAW                         RAW( 1024 );
   BEGIN
      
      IF A_INPUT_RAW IS NULL
      THEN
         A_ENCRYPTED_DATA := NULL;
         RETURN( CXSAPILK.DBERR_SUCCESS );
      END IF;

      SYS.DBMS_OBFUSCATION_TOOLKIT.DES3ENCRYPT
                                              
      (                                         INPUT => A_INPUT_RAW,
                                                KEY => P_UNIVERSAL_ENCRYPTION_KEY,
                                                ENCRYPTED_DATA => A_ENCRYPTED_DATA,
                                                WHICH => '1' );










      RETURN( CXSAPILK.DBERR_SUCCESS );
   
   END UNIVERSALENCRYPT;


   PROCEDURE OLDSHUFFLE   
                       (
      A_INPUT                    IN OUT   CXSAPILK.NUM_TABLE_TYPE,
      A_SIZE                     IN       NUMBER )
   IS
      L_HULP1                       CXSAPILK.NUM_TABLE_TYPE;
      L_HULP2                       CXSAPILK.NUM_TABLE_TYPE;
      L_MAXINDEX                    NUMBER;
      L_NB_LOOPS                    NUMBER;
      L_IND                         NUMBER;
      L_IND2                        NUMBER;
   BEGIN
      L_MAXINDEX := 1;

      BEGIN
         LOOP
            L_HULP1( L_MAXINDEX ) := A_INPUT( L_MAXINDEX );
            L_MAXINDEX :=   L_MAXINDEX
                          + 1;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;

      L_MAXINDEX :=   L_MAXINDEX
                    - 1;
      L_NB_LOOPS := FLOOR(   L_MAXINDEX
                           / (   A_SIZE
                               * 4 ) );
      L_IND := 1;

      FOR I IN 1 .. L_NB_LOOPS
      LOOP
         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J
                                         + A_SIZE );
            L_IND :=   L_IND
                     + 1;
         END LOOP;

         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J
                                         +   3
                                           * A_SIZE );
            L_IND :=   L_IND
                     + 1;
         END LOOP;

         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J
                                         +   2
                                           * A_SIZE );
            L_IND :=   L_IND
                     + 1;
         END LOOP;

         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J );
            L_IND :=   L_IND
                     + 1;
         END LOOP;
      END LOOP;

      FOR J IN L_IND .. L_MAXINDEX
      LOOP
         L_HULP2( J ) := L_HULP1( J );
      END LOOP;

      A_INPUT := L_HULP2;
   
   END OLDSHUFFLE;



   FUNCTION OLDCREATEKEY   
                        (
      A_INPUTINFO                IN       CHAR,
      A_KEY                      OUT      CHAR )
      RETURN BOOLEAN
   IS
      L_KEYLONG                     CXSAPILK.NUM_TABLE_TYPE;
      L_KEYSHORT                    CXSAPILK.NUM_TABLE_TYPE;
      L_SOM                         NUMBER;
      L_SOM1                        NUMBER;
      L_SOM2                        NUMBER;
      L_SOM3                        NUMBER;
      L_SCRAMBLE                    CHAR( 20 );
      L_LETTER                      CHAR( 1 );
      L_TEMP                        VARCHAR( 20 );
      L_MULTIPLIER                  NUMBER;
   BEGIN



      FOR I IN 1 .. 200
      LOOP
         L_LETTER := SUBSTR( A_INPUTINFO,
                             I,
                             1 );

         IF ASCIISTR( L_LETTER ) = L_LETTER
         THEN
            L_KEYLONG( I ) := ASCII( SUBSTR( A_INPUTINFO,
                                             I,
                                             1 ) );
         ELSE
            
            L_KEYLONG( I ) := TO_NUMBER( SUBSTR( ASCIISTR( L_LETTER ),
                                                 2 ),
                                         'XXXX' );
         END IF;
      END LOOP;

      OLDSHUFFLE( L_KEYLONG,
                  25 );
      OLDSHUFFLE( L_KEYLONG,
                  10 );
      OLDSHUFFLE( L_KEYLONG,
                  50 );

      FOR I IN 1 .. 10
      LOOP
         L_SOM := 0;

         FOR J IN 1 .. 27
         LOOP
            L_SOM :=   L_SOM
                     + L_KEYLONG(   MOD(  (     20
                                              * I
                                            + J ),
                                         200 )
                                  + 1 );
         END LOOP;

         L_KEYSHORT( I ) := MOD(   L_SOM
                                 + 14,
                                   62
                                 - MOD( I,
                                        3 ) );
      END LOOP;

      FOR I IN 0 .. 4
      LOOP
         L_SOM := 0;

         FOR J IN 3 .. 61
         LOOP
            L_SOM :=   L_SOM
                     + L_KEYLONG(   MOD(  (     48
                                              * I
                                            + J ),
                                         200 )
                                  + 1 );
         END LOOP;

         L_KEYSHORT(   11
                     + I ) := MOD( L_SOM,
                                     62
                                   - MOD( I,
                                          2 ) );
      END LOOP;

      L_SOM1 := 0;

      FOR J IN 1 .. 200
      LOOP
         L_SOM1 :=   L_SOM1
                   + MOD(   J
                          * L_KEYLONG( J ),
                          62 )
                   - 31;
      END LOOP;

      L_KEYSHORT( 16 ) := MOD( ABS( L_SOM1 ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 1 .. 7
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM2 := 0;

      FOR J IN 13 .. 16
      LOOP
         L_SOM2 :=   L_SOM2
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM3 := 0;

      FOR J IN 1 .. 16
      LOOP
         L_SOM3 :=   L_SOM3
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 17 ) := MOD(  (   MOD(   L_SOM1
                                         + 2,
                                         7 )
                                  + MOD( L_SOM2,
                                         11 )
                                  + MOD(   L_SOM3
                                         + 1,
                                         58 ) ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 2 .. 11
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM2 := 0;

      FOR J IN 7 .. 15
      LOOP
         L_SOM2 :=   L_SOM2
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM3 := 0;

      FOR J IN 1 .. 17
      LOOP
         L_SOM3 :=   L_SOM3
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 18 ) := MOD(  (   MOD(   L_SOM1
                                         + 3,
                                         11 )
                                  + MOD(   L_SOM2
                                         + 4,
                                         5 )
                                  + MOD(   L_SOM3
                                         + 32,
                                         71 ) ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 1 .. 13
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM2 := 0;

      FOR J IN 7 .. 18
      LOOP
         L_SOM2 :=   L_SOM2
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM3 := 0;

      FOR J IN 1 .. 18
      LOOP
         L_SOM3 :=   L_SOM3
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 19 ) := MOD(  (   MOD(   L_SOM1
                                         + 5,
                                         10 )
                                  + MOD(   L_SOM2
                                         + 2,
                                         6 )
                                  + MOD(   L_SOM3
                                         + 44,
                                         63 ) ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 1 .. 19
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 20 ) := MOD( L_SOM1,
                               62 );

      IF MOD( L_KEYSHORT( 20 ),
              5 ) = 0
      THEN
         L_MULTIPLIER := 43;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 1
      THEN
         L_MULTIPLIER := 41;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 2
      THEN
         L_MULTIPLIER := 47;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 3
      THEN
         L_MULTIPLIER := 37;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 4
      THEN
         L_MULTIPLIER := 29;
      END IF;

      OLDSHUFFLE( L_KEYSHORT,
                  5 );
      OLDSHUFFLE( L_KEYSHORT,
                  1 );
      L_SCRAMBLE :=
            CHR( 97 )
         || CHR( 84 )
         || CHR( 56 )
         || CHR( 85 )
         || CHR( 49 )
         || CHR( 83 )
         || CHR( 111 )
         || CHR( 119 )
         || CHR( 106 )
         || CHR( 110 )
         || CHR( 78 )
         || CHR( 119 )
         || CHR( 50 )
         || CHR( 102 )
         || CHR( 57 )
         || CHR( 56 )
         || CHR( 107 )
         || CHR( 105 )
         || CHR( 101 )
         || CHR( 76 );   
      L_KEYSHORT( 1 ) := MOD(  (     L_KEYSHORT( 1 )
                                   * L_MULTIPLIER
                                 + ASCII( SUBSTR( L_SCRAMBLE,
                                                  1,
                                                  1 ) ) ),
                              62 );

      IF ( L_KEYSHORT( 1 ) < 26 )
      THEN
         L_TEMP := CHR(   65
                        + L_KEYSHORT( 1 ) );
      ELSIF( L_KEYSHORT( 1 ) < 36 )
      THEN
         L_TEMP := CHR(   48
                        + L_KEYSHORT( 1 )
                        - 26 );
      ELSE
         L_TEMP := CHR(   97
                        + L_KEYSHORT( 1 )
                        - 36 );
      END IF;

      FOR J IN 2 .. 19
      LOOP
         L_KEYSHORT( J ) := MOD(  (     L_KEYSHORT( J )
                                      * L_MULTIPLIER
                                    + ASCII( SUBSTR( L_SCRAMBLE,
                                                     J,
                                                     1 ) ) ),
                                 62 );

         IF ( L_KEYSHORT( J ) < 26 )
         THEN
            L_LETTER := CHR(   65
                             + L_KEYSHORT( J ) );
         ELSIF( L_KEYSHORT( J ) < 36 )
         THEN
            L_LETTER := CHR(   48
                             + L_KEYSHORT( J )
                             - 26 );
         ELSE
            L_LETTER := CHR(   97
                             + L_KEYSHORT( J )
                             - 36 );
         END IF;

         L_TEMP :=    RTRIM( L_TEMP )
                   || L_LETTER;
      END LOOP;

      L_SOM1 := 0;

      FOR J IN 1 .. 19
      LOOP
         L_SOM1 :=   L_SOM1
                   + ASCII( SUBSTR( L_TEMP,
                                    J,
                                    1 ) );
      END LOOP;

      L_LETTER := CHR(   65
                       + MOD( L_SOM1,
                              26 ) );
      L_TEMP :=    L_TEMP
                || L_LETTER;
      
      A_KEY := L_TEMP;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         
         RAISE_APPLICATION_ERROR( -20000,
                                     'Problem encountered during license check.OracleErrorCode'
                                  || SQLCODE );
   END OLDCREATEKEY;



   FUNCTION LOCAL_RPAD(
      A_INPUTSTRING              IN       VARCHAR2,
      A_SIZE                     IN       NUMBER,
      A_PADDINGSTRING            IN       VARCHAR2 )
      RETURN VARCHAR2
   IS
      L_TEMP                        VARCHAR2( 255 );
   BEGIN
      IF ( LENGTH( A_PADDINGSTRING ) < 1 )
      THEN
         RETURN( A_INPUTSTRING );   
      END IF;

      L_TEMP := A_INPUTSTRING;

      WHILE( LENGTH( L_TEMP ) < A_SIZE )
      LOOP
         L_TEMP :=    L_TEMP
                   || A_PADDINGSTRING;
      END LOOP;

      RETURN( SUBSTR( L_TEMP,
                      1,
                      A_SIZE ) );
   
   END LOCAL_RPAD;



   FUNCTION GENERATEHASHCODELIKECLIENT   
                                      (
      A_INPUT_STRING             IN       VARCHAR2,
      A_HASHING_RESULT           OUT      VARCHAR2 )
      RETURN NUMBER
   IS
      L_MY_KEY                      RAW( 24 );
      L_SUCCESS                     BOOLEAN;
      L_STRING_TO_HASH              VARCHAR2( 200 );
      L_RETURN_KEY                  VARCHAR2( 20 );
   BEGIN
      
      IF A_INPUT_STRING IS NULL
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'The string passed for hashing is empty !' );
      END IF;


      L_STRING_TO_HASH := LOCAL_RPAD( RTRIM( A_INPUT_STRING ),
                                      200,
                                      '&' );


      L_SUCCESS := OLDCREATEKEY( L_STRING_TO_HASH,
                                 L_RETURN_KEY );



      IF NOT L_SUCCESS
      THEN
         RETURN( CXSAPILK.DBERR_GENFAIL );
      END IF;


      A_HASHING_RESULT := L_RETURN_KEY;


      RETURN( CXSAPILK.DBERR_SUCCESS );
   END GENERATEHASHCODELIKECLIENT;

   PROCEDURE LOCALSORT(
      A_SRC_SETTING_SEQ          IN       CXSAPILK.NUM_TABLE_TYPE,   
      A_SRC_SETTING_NAME         IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_SRC_SETTING_VALUE        IN       CXSAPILK.VC255_TABLE_TYPE,   
      A_TRG_SETTING_NAME         OUT NOCOPY CXSAPILK.VC40_TABLE_TYPE,   
      A_TRG_SETTING_VALUE        OUT NOCOPY CXSAPILK.VC255_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER )   
   IS
      L_ROW                         INTEGER;
      L_SRC_SETTINGLS               COSETTINGLIST := COSETTINGLIST( );
   BEGIN
      A_TRG_SETTING_NAME.DELETE( );
      A_TRG_SETTING_VALUE.DELETE( );

      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         L_SRC_SETTINGLS.EXTEND;
         L_SRC_SETTINGLS( L_SRC_SETTINGLS.COUNT ) :=
                                                   COSETTING( A_SRC_SETTING_SEQ( L_ROW ),
                                                              A_SRC_SETTING_NAME( L_ROW ),
                                                              A_SRC_SETTING_VALUE( L_ROW ) );
      END LOOP;

      L_ROW := 0;

      FOR L_REC IN ( SELECT  SETTING_NAME,
                             SETTING_VALUE
                        FROM TABLE( CAST( L_SRC_SETTINGLS AS COSETTINGLIST ) )
                    ORDER BY SETTING_SEQ ASC )
      LOOP
         L_ROW :=   L_ROW
                  + 1;
         A_TRG_SETTING_NAME( L_ROW ) := L_REC.SETTING_NAME;
         A_TRG_SETTING_VALUE( L_ROW ) := L_REC.SETTING_VALUE;
      END LOOP;

      IF NVL( L_ROW,
              -1 ) <> NVL( A_NR_OF_ROWS,
                           -2 )
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                     'Assertion failure in LocalSort number of rows out:'
                                  || L_ROW
                                  || ' different from number of rows in:'
                                  || A_NR_OF_ROWS );
      END IF;
   END LOCALSORT;




   FUNCTION ISLICENSENOTCORRUPTED(
      A_SERIAL_ID                IN       RAW,
      A_SHORTNAME                IN       RAW )
      RETURN NUMBER
   IS
      L_OLD_VERSION_SNAME_ENCRYPTED RAW( 160 );
      L_COUNT_OLD_LICENSES          INTEGER;
      L_SERIAL_ID_ENCRYPTED         RAW( 160 );
      L_SHORTNAME_ENCRYPTED         RAW( 160 );
      L_HASH_CODE_CLIENT            VARCHAR2( 255 );
      L_HASH_CODE_CLIENT_ENCRYPTED  RAW( 1020 );
      L_HASH_CODE_SERVER            VARCHAR2( 255 );
      L_HASH_CODE_SERVER_CHECK      VARCHAR2( 255 );
      L_HASH_CODE_SERVER_ENCRYPTED  RAW( 1020 );
      L_LIC_USERS                   INTEGER;
      L_EXPIRATION_DATE             DATE;
      L_STRING_TO_HASH              VARCHAR2( 200 );
      L_SETTING_SEQ_ENCRYPTED       CXSAPILK.RAW16_TABLE_TYPE;
      L_SETTING_NAME_ENCRYPTED      CXSAPILK.RAW160_TABLE_TYPE;
      L_SETTING_VALUE_ENCRYPTED     CXSAPILK.RAW1020_TABLE_TYPE;
      L_SETTING_SEQ                 CXSAPILK.NUM_TABLE_TYPE;
      L_SETTING_NAME                CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE               CXSAPILK.VC255_TABLE_TYPE;
      L_SETTING_NAME_SORTED         CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE_SORTED        CXSAPILK.VC255_TABLE_TYPE;
      L_ROWID                       ROWID;
      L_RETURNED                    INTEGER;
      L_SUCCESS                     INTEGER;
      L_RETURNKEY                   VARCHAR2( 255 );
      L_REF_DATE_ENCRYPTED          RAW( 64 );
      L_EXPIRATION_DATE_ENCRYPTED   RAW( 64 );
      L_TIMEUNIT                    INTEGER;
      L_ACTVALIDITY                 INTEGER;
      L_REF_DATE_VC2                VARCHAR2( 16 );
      L_EXPIRATION_DATE_VC2         VARCHAR2( 16 );
      L_VERSION                     VARCHAR2( 4 );
      L_CUSTOM_PARAM                VARCHAR2( 2 );
      L_APP_ID                      VARCHAR2( 4 );
      L_SHORTNAME                   VARCHAR2( 40 );
      L_COUNT_SETTINGS              INTEGER;
      L_UNDECRYPTABLE               BOOLEAN;
   BEGIN
      L_RETURNED := CXSAPILK.DBERR_SUCCESS;
      L_RET_CODE := ENCRYPT( 'old_version',
                             L_OLD_VERSION_SNAME_ENCRYPTED );

      
      SELECT COUNT( DISTINCT SERIAL_ID )
        INTO L_COUNT_OLD_LICENSES
        FROM CTLICSECID
       WHERE SETTING_NAME IN( L_OLD_VERSION_SNAME_ENCRYPTED );

      
      
      SELECT SERIAL_ID,
             SHORTNAME,
             HASH_CODE_CLIENT,
             HASH_CODE_SERVER,
             REF_DATE,
             EXPIRATION_DATE,
             ROWID
        INTO L_SERIAL_ID_ENCRYPTED,
             L_SHORTNAME_ENCRYPTED,
             L_HASH_CODE_CLIENT_ENCRYPTED,
             L_HASH_CODE_SERVER_ENCRYPTED,
             L_REF_DATE_ENCRYPTED,
             L_EXPIRATION_DATE_ENCRYPTED,
             L_ROWID
        FROM CTLICSECIDAUXILIARY
       WHERE SERIAL_ID = A_SERIAL_ID
         AND SHORTNAME = A_SHORTNAME;

      
      SELECT SETTING_SEQ,
             SETTING_NAME,
             SETTING_VALUE
      BULK COLLECT INTO L_SETTING_SEQ_ENCRYPTED,
              L_SETTING_NAME_ENCRYPTED,
              L_SETTING_VALUE_ENCRYPTED
        FROM CTLICSECID
       WHERE SERIAL_ID = A_SERIAL_ID
         AND SHORTNAME = A_SHORTNAME;

      
      
      L_COUNT_SETTINGS := 0;
      L_UNDECRYPTABLE := FALSE;

      FOR L_ROW IN 1 .. L_SETTING_NAME_ENCRYPTED.COUNT( )
      LOOP
         
         BEGIN

            L_RET_CODE := DECRYPT( L_SETTING_SEQ_ENCRYPTED( L_ROW ),
                                   L_SETTING_SEQ( L_ROW ) );   

            L_RET_CODE := DECRYPT( L_SETTING_NAME_ENCRYPTED( L_ROW ),
                                   L_SETTING_NAME( L_ROW ) );

            L_RET_CODE := DECRYPT( L_SETTING_VALUE_ENCRYPTED( L_ROW ),
                                   L_SETTING_VALUE( L_ROW ) );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               L_UNDECRYPTABLE := TRUE;
               EXIT;
         END;

         IF L_COUNT_OLD_LICENSES > 0
         THEN
            IF L_SETTING_NAME( L_ROW ) IN( 'customer', 'site', 'users', 'modules', 'expire_date', 'version', 'old_version' )
            THEN
               L_COUNT_SETTINGS :=   L_COUNT_SETTINGS
                                   + 1;
            END IF;
         ELSE
            IF L_SETTING_NAME( L_ROW ) IN( 'timeunit', 'actvalidity', 'shortname' )
            THEN
               L_COUNT_SETTINGS :=   L_COUNT_SETTINGS
                                   + 1;
            END IF;
         END IF;
      END LOOP;

      IF L_UNDECRYPTABLE
      THEN
         L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;
      ELSIF L_COUNT_OLD_LICENSES > 0
      THEN
         IF L_COUNT_SETTINGS <> 7
         THEN
            
            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;
         END IF;
      ELSE
         IF L_COUNT_SETTINGS <> 3
         THEN
            
            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;
         END IF;
      END IF;

      
      IF L_RETURNED = CXSAPILK.DBERR_SUCCESS
      THEN
         
         L_STRING_TO_HASH := '';
         LOCALSORT( L_SETTING_SEQ,
                    L_SETTING_NAME,
                    L_SETTING_VALUE,
                    L_SETTING_NAME_SORTED,
                    L_SETTING_VALUE_SORTED,
                    L_SETTING_NAME.COUNT( ) );

         FOR L_ROW IN 1 .. L_SETTING_NAME_SORTED.COUNT( )
         LOOP
            L_STRING_TO_HASH := SUBSTR(    L_STRING_TO_HASH
                                        || '#'
                                        || L_SETTING_NAME_SORTED( L_ROW )
                                        || '#'
                                        || L_SETTING_VALUE_SORTED( L_ROW ),
                                        1,
                                        200 );
         END LOOP;

         
         L_SUCCESS := GENERATEHASHCODELIKECLIENT( L_STRING_TO_HASH,
                                                  L_RETURNKEY );

         IF L_SUCCESS <> CXSAPILK.DBERR_SUCCESS
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during license check'
                                     || SQLCODE );
         END IF;

         L_RET_CODE := DECRYPT( L_HASH_CODE_CLIENT_ENCRYPTED,
                                L_HASH_CODE_CLIENT );

         IF ( L_RETURNKEY != L_HASH_CODE_CLIENT )
         THEN

            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;
         
         END IF;

         L_RET_CODE := DECRYPT( L_HASH_CODE_SERVER_ENCRYPTED,
                                L_HASH_CODE_SERVER );
         L_RET_CODE := DECRYPT( L_REF_DATE_ENCRYPTED,
                                L_REF_DATE_VC2 );
         L_RET_CODE := DECRYPT( L_EXPIRATION_DATE_ENCRYPTED,
                                L_EXPIRATION_DATE_VC2 );
         L_HASH_CODE_SERVER_CHECK :=    L_ROWID
                                     || P_SID_NAME
                                     || L_REF_DATE_VC2
                                     || L_EXPIRATION_DATE_VC2;

         FOR L_REC IN ( SELECT  A.*,
                                A.ROWID
                           FROM CTLICSECID A
                          WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
                            AND SHORTNAME = L_SHORTNAME_ENCRYPTED
                       ORDER BY SETTING_SEQ )
         LOOP
            L_HASH_CODE_SERVER_CHECK := SUBSTR(    L_HASH_CODE_SERVER_CHECK
                                                || L_REC.ROWID,
                                                1,
                                                255 );
         END LOOP;

         
         IF     L_HASH_CODE_SERVER <> L_HASH_CODE_SERVER_CHECK
            AND P_LICENSES_RECOVERED = '0'
         THEN
            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;

         END IF;
      END IF;

      RETURN( L_RETURNED );
   END ISLICENSENOTCORRUPTED;

   FUNCTION INITMODE
      RETURN NUMBER
   IS
      L_SOME_LICENSES_VALID         BOOLEAN;
      L_SOME_LICENSES_INVALID       BOOLEAN;
      L_SOME_ALT_LICENSES_VALID     BOOLEAN;
      L_SOME_ALT_LICENSES_INVALID   BOOLEAN;
      L_TEMP_RET_CODE               INTEGER;
      L_COUNT_LICENSES              INTEGER;

      CURSOR L_VRECOVERY_CURSOR
      IS
         SELECT HASH_CODE_SERVER
           FROM CTLICSECIDAUXILIARY
          WHERE SERIAL_ID = RECO_SERIAL_ID
            AND SHORTNAME = RECO_SHORTNAME;

      L_VDATABASE_REC               L_VRECOVERY_CURSOR%ROWTYPE;
   BEGIN
      
      
      P_LICENSES_RECOVERED := '0';
      P_ENCRYPTION_KEY_RECOVERED := NULL;
      P_ENCRYPTION_KEY := P_ENCRYPTION_KEY_NORMAL;

      
      OPEN L_VRECOVERY_CURSOR;

      FETCH L_VRECOVERY_CURSOR
       INTO L_VDATABASE_REC;

      IF L_VRECOVERY_CURSOR%FOUND
      THEN
         
         L_TEMP_RET_CODE := UNIVERSALDECRYPT( L_VDATABASE_REC.HASH_CODE_SERVER,
                                              P_ENCRYPTION_KEY_RECOVERED );
      END IF;

      CLOSE L_VRECOVERY_CURSOR;


      IF P_ENCRYPTION_KEY_RECOVERED IS NULL
      THEN
         
         P_LICENSES_RECOVERED := '0';
         DBMS_OUTPUT.PUT_LINE( 'license recovery record not found - please create. you won''t be able to recover your licenses in case of problems.' );
      ELSE
         
         
         
         
         
         
         P_ENCRYPTION_KEY := P_ENCRYPTION_KEY_NORMAL;
         L_SOME_LICENSES_VALID := FALSE;
         L_SOME_LICENSES_INVALID := FALSE;

         FOR L_REC IN ( SELECT DISTINCT SERIAL_ID,
                                        SHORTNAME
                                  FROM CTLICSECIDAUXILIARY
                                 WHERE SERIAL_ID <> RECO_SERIAL_ID
                                   AND SHORTNAME <> RECO_SHORTNAME )
         LOOP
            L_RET_CODE := ISLICENSENOTCORRUPTED( L_REC.SERIAL_ID,
                                                 L_REC.SHORTNAME );

            IF L_RET_CODE = CXSAPILK.DBERR_SUCCESS
            THEN
               L_SOME_LICENSES_VALID := TRUE;

            ELSE
               L_SOME_LICENSES_INVALID := TRUE;

            END IF;

            IF     L_SOME_LICENSES_VALID
               AND L_SOME_LICENSES_INVALID
            THEN
               DBMS_OUTPUT.PUT_LINE( 'Very strange(1): some licenses are valid, other are invalid' );
            END IF;
         END LOOP;

         
         
         
         IF L_SOME_LICENSES_INVALID
         THEN
            
            P_ENCRYPTION_KEY := P_ENCRYPTION_KEY_RECOVERED;
            P_LICENSES_RECOVERED := '1';
            L_SOME_ALT_LICENSES_VALID := FALSE;
            L_SOME_ALT_LICENSES_INVALID := FALSE;

            FOR L_REC IN ( SELECT DISTINCT SERIAL_ID,
                                           SHORTNAME
                                     FROM CTLICSECIDAUXILIARY
                                    WHERE SERIAL_ID <> RECO_SERIAL_ID
                                      AND SHORTNAME <> RECO_SHORTNAME )
            LOOP
               L_RET_CODE := ISLICENSENOTCORRUPTED( L_REC.SERIAL_ID,
                                                    L_REC.SHORTNAME );

               IF L_RET_CODE = CXSAPILK.DBERR_SUCCESS
               THEN
                  L_SOME_ALT_LICENSES_VALID := TRUE;

               ELSE
                  L_SOME_ALT_LICENSES_INVALID := TRUE;

               END IF;

               IF     L_SOME_ALT_LICENSES_VALID
                  AND L_SOME_ALT_LICENSES_INVALID
               THEN
                  DBMS_OUTPUT.PUT_LINE( 'Very strange(2): some licenses are valid, other are invalid' );
               END IF;
            END LOOP;

            IF L_SOME_ALT_LICENSES_INVALID
            THEN
               DBMS_OUTPUT.PUT_LINE( 'System is seriously corrupted, licenses in db are not usable' );
               P_ENCRYPTION_KEY := P_ENCRYPTION_KEY_NORMAL;
               P_LICENSES_RECOVERED := '0';
            ELSE
               DBMS_OUTPUT.PUT_LINE( 'System will use recovery license' );
            END IF;
         END IF;
      END IF;

      SELECT COUNT( DISTINCT SERIAL_ID )
        INTO L_COUNT_LICENSES
        FROM CTLICSECID;

      IF L_COUNT_LICENSES > 0
      THEN
         P_NOLICENSES_INSTALLED := '0';
      ELSE
         P_NOLICENSES_INSTALLED := '1';
      END IF;

      RETURN( CXSAPILK.DBERR_SUCCESS );
   END INITMODE;


   FUNCTION OLDCHECKLICENSEKEY(
      A_MAX_USERS                OUT      NUMBER,   
      A_CURRENT_USERS            OUT      NUMBER,   
      A_US                       IN       VARCHAR2 )   
      RETURN BOOLEAN
   IS

      L_KEY                         CHAR( 20 );
      L_RETURNKEY                   CHAR( 20 );
      L_INPUTSTRING                 CHAR( 255 );
      L_IND                         NUMBER;
      L_SUCCESS                     BOOLEAN;
   BEGIN






      L_SUCCESS := OLDCREATEKEY( L_INPUTSTRING,
                                 L_RETURNKEY );

      IF NOT L_SUCCESS
      THEN
         RETURN FALSE;
      END IF;

      IF ( L_RETURNKEY != L_KEY )
      THEN
         RETURN FALSE;
      END IF;














      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN FALSE;
   END OLDCHECKLICENSEKEY;

   PROCEDURE INSERTRECOVERYRECORD
   IS
      L_COUNT_RECOVERY_REC          INTEGER;
      L_TEMP_RET_CODE               INTEGER;
      L_ENCRYPTED_KEY               RAW( 1024 );
   BEGIN
      SELECT COUNT( 'X' )
        INTO L_COUNT_RECOVERY_REC
        FROM CTLICSECIDAUXILIARY
       WHERE SERIAL_ID = RECO_SERIAL_ID
         AND SHORTNAME = RECO_SHORTNAME;

      IF L_COUNT_RECOVERY_REC > 0
      THEN
         
         
         NULL;
      ELSE
         L_TEMP_RET_CODE := UNIVERSALENCRYPT( P_ENCRYPTION_KEY_NORMAL,
                                              L_ENCRYPTED_KEY );

         INSERT INTO CTLICSECIDAUXILIARY
                     ( SERIAL_ID,
                       SHORTNAME,
                       HASH_CODE_SERVER )
              VALUES ( RECO_SERIAL_ID,
                       RECO_SHORTNAME,
                       L_ENCRYPTED_KEY );
      END IF;
   END INSERTRECOVERYRECORD;

   PROCEDURE DELETERECOVERYRECORDWHENEMPTY
   IS
      L_COUNT_OTHER_REC             INTEGER;
   BEGIN
      SELECT COUNT( 'X' )
        INTO L_COUNT_OTHER_REC
        FROM CTLICSECIDAUXILIARY
       WHERE ( SERIAL_ID, SHORTNAME ) NOT IN(  ( RECO_SERIAL_ID, RECO_SHORTNAME ) );

      IF L_COUNT_OTHER_REC = 0
      THEN
         DELETE FROM CTLICSECIDAUXILIARY;
      END IF;
   END DELETERECOVERYRECORDWHENEMPTY;


   FUNCTION SAVEDELETEORCONVERTLICENSE(
      A_SERIAL_ID                IN       VARCHAR2,   
      A_SHORTNAME                IN       VARCHAR2,   
      A_SETTING_NAME             IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_SETTING_VALUE            IN       CXSAPILK.VC255_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_HASH_CODE_CLIENT         IN       VARCHAR2,   
      A_ACTION                   IN       VARCHAR2,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_SERIAL_ID_ENCRYPTED         RAW( 160 );
      L_SHORTNAME_ENCRYPTED         RAW( 160 );
      L_SETTING_SEQ_ENCRYPTED       RAW( 16 );
      L_SETTING_NAME_ENCRYPTED      RAW( 160 );
      L_SETTING_VALUE_ENCRYPTED     RAW( 1020 );
      L_HASH_CODE_CLIENT_ENCRYPTED  RAW( 1020 );
      L_HASH_CODE_SERVER            VARCHAR2( 255 );
      L_HASH_CODE_SERVER_ENCRYPTED  RAW( 1020 );
      L_STRING_TO_HASH              VARCHAR2( 200 );
      L_SUCCESS                     INTEGER;
      L_RETURNKEY                   VARCHAR2( 20 );
      L_ROWID                       ROWID;


      L_ACTVALIDITY                 INTEGER;
      L_TIMEUNIT                    INTEGER;
      L_EXPIRATION_DATE             DATE;
      L_REF_DATE                    DATE;
      L_REF_DATE_ENCRYPTED          RAW( 64 );
      L_EXPIRATION_DATE_ENCRYPTED   RAW( 64 );
      L_OLD_VERSION_SNAME_ENCRYPTED RAW( 160 );
      L_COUNT_OLD_LICENSES          INTEGER;
      L_OLD_LICENSE                 BOOLEAN;
      L_ACTVALIDITY_IN_SETTINGS     BOOLEAN;
      L_TIMEUNIT_IN_SETTINGS        BOOLEAN;
      L_TIMEUNIT_SNAME_ENCRYPTED    RAW( 160 );
      L_TIMEUNIT_ENCRYPTED          RAW( 160 );
      L_COUNT_LICENSES              INTEGER;


   BEGIN
      
      
      

      
   

      IF A_SERIAL_ID IS NULL
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'SaveLicense may not be called with an empty serial_id' );
      END IF;

      IF A_SHORTNAME IS NULL
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'SaveLicense may not be called with an empty shortname' );
      END IF;

      IF     A_ACTION IN( 'save', 'conversion' )
         AND NVL( A_NR_OF_ROWS,
                  0 ) < 5
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'SaveLicense may not be called with less than 5 settings' );
      END IF;

      L_STRING_TO_HASH := '';
      L_OLD_LICENSE := FALSE;
      L_ACTVALIDITY_IN_SETTINGS := FALSE;
      L_TIMEUNIT_IN_SETTINGS := FALSE;

      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         IF A_SETTING_NAME( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'SaveLicense may not be called with an empty setting_name' );
         END IF;

         

         
         IF     A_SETTING_NAME( L_ROW ) = 'old_version'
            AND A_SETTING_VALUE( L_ROW ) = 'YES'
         THEN
            L_OLD_LICENSE := TRUE;
         ELSIF A_SETTING_NAME( L_ROW ) = 'actvalidity'
         THEN
            L_ACTVALIDITY_IN_SETTINGS := TRUE;
         ELSIF A_SETTING_NAME( L_ROW ) = 'timeunit'
         THEN
            L_TIMEUNIT_IN_SETTINGS := TRUE;
         END IF;
      END LOOP;

      IF     NOT L_OLD_LICENSE
         AND A_ACTION = 'save'
      THEN
         IF    ( L_ACTVALIDITY_IN_SETTINGS = FALSE )
            OR ( L_TIMEUNIT_IN_SETTINGS = FALSE )
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'No validity and/or timeunit provided !' );
         END IF;
      END IF;

      
      
      
      IF A_ACTION = 'delete'
      THEN
         L_RET_CODE := ENCRYPT( 'timeunit',
                                L_TIMEUNIT_SNAME_ENCRYPTED );
         L_RET_CODE := ENCRYPT( A_SERIAL_ID,
                                L_SERIAL_ID_ENCRYPTED );
         L_RET_CODE := ENCRYPT( A_SHORTNAME,
                                L_SHORTNAME_ENCRYPTED );
         L_TIMEUNIT := -10;

         SELECT COUNT( 'X' )
           INTO L_COUNT_LICENSES
           FROM CTLICSECIDAUXILIARY
          WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
            AND SHORTNAME = L_SHORTNAME_ENCRYPTED;

         IF L_COUNT_LICENSES = 0
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'License to be deleted doesn''t exist' );
         END IF;

         BEGIN
            SELECT SETTING_VALUE
              INTO L_TIMEUNIT_ENCRYPTED
              FROM CTLICSECID
             WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
               AND SHORTNAME = L_SHORTNAME_ENCRYPTED
               AND SETTING_NAME = L_TIMEUNIT_SNAME_ENCRYPTED;

            L_RET_CODE := DECRYPT( L_TIMEUNIT_ENCRYPTED,
                                   L_TIMEUNIT );

         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RAISE_APPLICATION_ERROR( -20000,
                                        'Abnormal license no timeunit' );
         END;

         IF L_TIMEUNIT NOT IN( -1, 3, -10 )
         THEN
            
            
            
            
            
            IF SYSDATE > TO_DATE( '20/01/2030',
            
            
                                  'DD/MM/YYYY' )
            THEN
               RAISE_APPLICATION_ERROR( -20000,
                                        'This type of license may not be transferred back to ALM' );
            END IF;
         END IF;
      END IF;

      
      
      
      IF A_ACTION IN( 'save', 'conversion' )
      THEN
         L_RET_CODE := ENCRYPT( 'old_version',
                                L_OLD_VERSION_SNAME_ENCRYPTED );

         SELECT COUNT( DISTINCT SERIAL_ID )
           INTO L_COUNT_OLD_LICENSES
           FROM CTLICSECID
          WHERE SETTING_NAME IN( L_OLD_VERSION_SNAME_ENCRYPTED );

         IF    L_COUNT_OLD_LICENSES = 1
            OR P_LICENSES_RECOVERED = '1'
         THEN
            INSERT INTO CTLICSECIDOLD
                        ( LOCAL_TRAN_ID,
                          LOGDATE,
                          SERIAL_ID,
                          SHORTNAME,
                          SETTING_SEQ,
                          SETTING_NAME,
                          SETTING_VALUE )
               SELECT DBMS_TRANSACTION.LOCAL_TRANSACTION_ID( ),
                      SYSDATE,
                      SERIAL_ID,
                      SHORTNAME,
                      SETTING_SEQ,
                      SETTING_NAME,
                      SETTING_VALUE
                 FROM CTLICSECID;

            INSERT INTO CTLICSECIDAUXILIARYOLD
                        ( LOCAL_TRAN_ID,
                          LOGDATE,
                          SERIAL_ID,
                          SHORTNAME,
                          HASH_CODE_CLIENT,
                          HASH_CODE_SERVER,
                          TEMPLATE,
                          REF_DATE,
                          EXPIRATION_DATE )
               SELECT DBMS_TRANSACTION.LOCAL_TRANSACTION_ID( ),
                      SYSDATE,
                      SERIAL_ID,
                      SHORTNAME,
                      HASH_CODE_CLIENT,
                      HASH_CODE_SERVER,
                      TEMPLATE,
                      REF_DATE,
                      EXPIRATION_DATE
                 FROM CTLICSECIDAUXILIARY;

            DELETE FROM CTLICSECID;

            DELETE FROM CTLICSECIDAUXILIARY;
         END IF;

         
         IF P_LICENSES_RECOVERED = '1'
         THEN
            P_LICENSES_RECOVERED := '0';
            P_ENCRYPTION_KEY := P_ENCRYPTION_KEY_NORMAL;
         END IF;
      END IF;

   
   


      
      IF A_ACTION IN( 'save', 'conversion' )
      THEN
         FOR L_ROW IN 1 .. A_NR_OF_ROWS
         LOOP

            L_STRING_TO_HASH := SUBSTR(    L_STRING_TO_HASH
                                        || '#'
                                        || A_SETTING_NAME( L_ROW )
                                        || '#'
                                        || A_SETTING_VALUE( L_ROW ),
                                        1,
                                        200 );
         END LOOP;


         L_SUCCESS := GENERATEHASHCODELIKECLIENT( L_STRING_TO_HASH,
                                                  L_RETURNKEY );

         
         IF L_SUCCESS <> CXSAPILK.DBERR_SUCCESS
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during license check'
                                     || SQLCODE );
         END IF;
      END IF;

      
      IF A_ACTION = 'save'
      THEN
         IF ( L_RETURNKEY != A_HASH_CODE_CLIENT )
         THEN












            RAISE_APPLICATION_ERROR( -20000,
                                     'License is invalid' );
         END IF;
      END IF;

      
      L_RET_CODE := ENCRYPT( A_SERIAL_ID,
                             L_SERIAL_ID_ENCRYPTED );
      L_RET_CODE := ENCRYPT( A_SHORTNAME,
                             L_SHORTNAME_ENCRYPTED );

      IF A_ACTION = 'delete'
      THEN
         
         
         
         
         DELETE FROM CTLICSECID
               WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
                 AND SHORTNAME = L_SHORTNAME_ENCRYPTED;

         DELETE FROM CTLICSECIDAUXILIARY
               WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
                 AND SHORTNAME = L_SHORTNAME_ENCRYPTED;

         DELETERECOVERYRECORDWHENEMPTY;
      END IF;

      IF A_ACTION <> 'delete'
      THEN
         
         
         IF    P_ENCRYPTION_KEY <> P_ENCRYPTION_KEY_NORMAL
            OR P_LICENSES_RECOVERED = '1'
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'Assertion failure: The session is still in license recovered mode' );
         END IF;

         L_TIMEUNIT := -10;
         L_ACTVALIDITY := -10;
         L_REF_DATE := NULL;
         L_EXPIRATION_DATE := NULL;

         FOR L_ROW IN 1 .. A_NR_OF_ROWS
         LOOP
            L_RET_CODE := ENCRYPT( A_SETTING_NAME( L_ROW ),
                                   L_SETTING_NAME_ENCRYPTED );
            L_RET_CODE := ENCRYPT( A_SETTING_VALUE( L_ROW ),
                                   L_SETTING_VALUE_ENCRYPTED );
            L_RET_CODE := ENCRYPT( L_ROW,
                                   L_SETTING_SEQ_ENCRYPTED );   

            IF A_SETTING_NAME( L_ROW ) = 'actvalidity'
            THEN
               L_ACTVALIDITY := A_SETTING_VALUE( L_ROW );
            END IF;

            IF A_SETTING_NAME( L_ROW ) = 'timeunit'
            THEN
               L_TIMEUNIT := A_SETTING_VALUE( L_ROW );
            END IF;

            INSERT INTO CTLICSECID
                        ( SERIAL_ID,
                          SHORTNAME,
                          SETTING_SEQ,
                          SETTING_NAME,
                          SETTING_VALUE )
                 VALUES ( L_SERIAL_ID_ENCRYPTED,
                          L_SHORTNAME_ENCRYPTED,
                          L_SETTING_SEQ_ENCRYPTED,
                          L_SETTING_NAME_ENCRYPTED,
                          L_SETTING_VALUE_ENCRYPTED );
         END LOOP;

         INSERT INTO CTLICSECIDAUXILIARY
                     ( SERIAL_ID,
                       SHORTNAME )
              VALUES ( L_SERIAL_ID_ENCRYPTED,
                       L_SHORTNAME_ENCRYPTED )
           RETURNING ROWID
                INTO L_ROWID;

         IF L_TIMEUNIT = '0'
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'This type of license is not supported by the CXSAPILK package' );
         END IF;

         IF L_TIMEUNIT IN( 1, 2, 4 )
         THEN
            
            
            L_REF_DATE := SYSDATE;

            IF L_TIMEUNIT = 1
            THEN   
               L_EXPIRATION_DATE :=   L_REF_DATE
                                    + ( L_ACTVALIDITY );
            ELSIF L_TIMEUNIT = 2
            THEN   
               L_EXPIRATION_DATE :=   L_REF_DATE
                                    + (   L_ACTVALIDITY
                                        / 24 );
            ELSIF L_TIMEUNIT = 4
            THEN   
               L_EXPIRATION_DATE :=   L_REF_DATE
                                    + (   L_ACTVALIDITY
                                        / (   24
                                            * 60 ) );
            END IF;
         END IF;

         IF L_TIMEUNIT IN( -1, 3, -10 )
         THEN
            
            L_REF_DATE := SYSDATE;
            L_EXPIRATION_DATE :=   L_REF_DATE
                                 + (   50
                                     * 365 );
         END IF;

         IF    L_REF_DATE IS NULL
            OR L_EXPIRATION_DATE IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'This type of license is not supported by the CXSAPILK package' );
         END IF;

         L_RET_CODE := ENCRYPT( TO_CHAR( L_REF_DATE,
                                         'DDMMYYYYHH24MISS' ),
                                L_REF_DATE_ENCRYPTED );
         L_RET_CODE := ENCRYPT( TO_CHAR( L_EXPIRATION_DATE,
                                         'DDMMYYYYHH24MISS' ),
                                L_EXPIRATION_DATE_ENCRYPTED );

         
         IF A_ACTION = 'conversion'
         THEN
            L_RET_CODE := ENCRYPT( L_RETURNKEY,
                                   L_HASH_CODE_CLIENT_ENCRYPTED );




            L_RET_CODE := DECRYPT( L_HASH_CODE_CLIENT_ENCRYPTED,
                                   L_RETURNKEY );


         ELSE
            L_RET_CODE := ENCRYPT( A_HASH_CODE_CLIENT,
                                   L_HASH_CODE_CLIENT_ENCRYPTED );
         END IF;


         L_HASH_CODE_SERVER :=    L_ROWID
                               || P_SID_NAME
                               || TO_CHAR( L_REF_DATE,
                                           'DDMMYYYYHH24MISS' )
                               || TO_CHAR( L_EXPIRATION_DATE,
                                           'DDMMYYYYHH24MISS' );

         FOR L_REC IN ( SELECT  A.*,
                                A.ROWID
                           FROM CTLICSECID A
                          WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
                            AND SHORTNAME = L_SHORTNAME_ENCRYPTED
                       ORDER BY SETTING_SEQ )
         LOOP
            L_HASH_CODE_SERVER := SUBSTR(    L_HASH_CODE_SERVER
                                          || L_REC.ROWID,
                                          1,
                                          255 );
         END LOOP;

         L_RET_CODE := ENCRYPT( L_HASH_CODE_SERVER,
                                L_HASH_CODE_SERVER_ENCRYPTED );

         UPDATE CTLICSECIDAUXILIARY
            SET HASH_CODE_CLIENT = L_HASH_CODE_CLIENT_ENCRYPTED,
                HASH_CODE_SERVER = L_HASH_CODE_SERVER_ENCRYPTED,
                REF_DATE = L_REF_DATE_ENCRYPTED,
                EXPIRATION_DATE = L_EXPIRATION_DATE_ENCRYPTED
          WHERE ROWID = L_ROWID;

         INSERTRECOVERYRECORD;
      END IF;

      RETURN( CXSAPILK.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IF SQLCODE = -20000
         THEN
            RAISE;
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during SaveLicense.OracleErrorCode'
                                     || SQLCODE );
         END IF;
   END SAVEDELETEORCONVERTLICENSE;


   FUNCTION SAVELICENSE(
      A_SERIAL_ID                IN       VARCHAR2,   
      A_SHORTNAME                IN       VARCHAR2,   
      A_SETTING_NAME             IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_SETTING_VALUE            IN       CXSAPILK.VC255_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_HASH_CODE_CLIENT         IN       VARCHAR2,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
   BEGIN
      L_RET_CODE :=
         SAVEDELETEORCONVERTLICENSE( A_SERIAL_ID,
                                     A_SHORTNAME,
                                     A_SETTING_NAME,
                                     A_SETTING_VALUE,
                                     A_NR_OF_ROWS,
                                     A_HASH_CODE_CLIENT,
                                     'save',
                                     A_ERROR_MESSAGE );
      RETURN( L_RET_CODE );
   END SAVELICENSE;


   FUNCTION CONVERTLICENSE(
      A_SERIAL_ID                IN       VARCHAR2,   
      A_SHORTNAME                IN       VARCHAR2,   
      A_SETTING_NAME             IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_SETTING_VALUE            IN       CXSAPILK.VC255_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
   BEGIN
      L_RET_CODE :=
             SAVEDELETEORCONVERTLICENSE( A_SERIAL_ID,
                                         A_SHORTNAME,
                                         A_SETTING_NAME,
                                         A_SETTING_VALUE,
                                         A_NR_OF_ROWS,
                                         '',
                                         'conversion',
                                         A_ERROR_MESSAGE );
      RETURN( L_RET_CODE );
   END CONVERTLICENSE;


   FUNCTION DELETELICENSE(
      A_SERIAL_ID                IN       VARCHAR2,   
      A_SHORTNAME                IN       VARCHAR2,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_SETTING_NAME_TAB            CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE_TAB           CXSAPILK.VC255_TABLE_TYPE;
      L_NR_OF_ROWS                  NUMBER;
   BEGIN
      L_NR_OF_ROWS := 0;
      L_RET_CODE :=
         SAVEDELETEORCONVERTLICENSE( A_SERIAL_ID,
                                     A_SHORTNAME,
                                     L_SETTING_NAME_TAB,
                                     L_SETTING_VALUE_TAB,
                                     L_NR_OF_ROWS,
                                     '',
                                     'delete',
                                     A_ERROR_MESSAGE );
      RETURN( L_RET_CODE );
   END DELETELICENSE;


   FUNCTION INTERNALSAVELICENSETEMPLATE(
      A_SERIAL_ID                IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_SHORTNAME                IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_TEMPLATE                 IN       CXSAPILK.BLOB_TABLE_TYPE,   
      A_MODIFY_FLAG              IN       CXSAPILK.NUM_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_CALLING_FUNCTION         IN       VARCHAR2,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_SERIAL_ID_ENCRYPTED         RAW( 160 );
      L_SHORTNAME_ENCRYPTED         RAW( 160 );
   BEGIN
      
      
      

      

      
      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         IF A_SERIAL_ID( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        A_CALLING_FUNCTION
                                     || ' may not be called with an empty serial_id' );
         END IF;

         IF A_SHORTNAME( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        A_CALLING_FUNCTION
                                     || ' may not be called with an empty shortname' );
         END IF;
      
      
      END LOOP;

      
      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         IF A_MODIFY_FLAG( L_ROW ) = CXSAPILK.MOD_FLAG_UPDATE
         THEN
            IF DBMS_LOB.GETLENGTH( A_TEMPLATE( L_ROW ) ) = 0
            THEN
               RAISE_APPLICATION_ERROR( -20000,
                                           A_CALLING_FUNCTION
                                        || ' may not be called with an empty template' );
            END IF;

            L_RET_CODE := ENCRYPT( A_SERIAL_ID( L_ROW ),
                                   L_SERIAL_ID_ENCRYPTED );
            L_RET_CODE := ENCRYPT( A_SHORTNAME( L_ROW ),
                                   L_SHORTNAME_ENCRYPTED );

            UPDATE CTLICSECIDAUXILIARY
               SET TEMPLATE = A_TEMPLATE( L_ROW )
             WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
               AND SHORTNAME = L_SHORTNAME_ENCRYPTED;

            
            IF SQL%ROWCOUNT = 0
            THEN
               RAISE_APPLICATION_ERROR( -20000,
                                           A_CALLING_FUNCTION
                                        || ' did not find an existing license to save its template for serial_id'
                                        || A_SERIAL_ID( L_ROW ) );
            END IF;
         ELSIF A_MODIFY_FLAG( L_ROW ) = CXSAPILK.MOD_FLAG_DELETE
         THEN
            L_RET_CODE := ENCRYPT( A_SERIAL_ID( L_ROW ),
                                   L_SERIAL_ID_ENCRYPTED );

            UPDATE CTLICSECIDAUXILIARY
               SET TEMPLATE = EMPTY_BLOB( )
             WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
               AND SHORTNAME = L_SHORTNAME_ENCRYPTED;

            
            IF SQL%ROWCOUNT = 0
            THEN
               RAISE_APPLICATION_ERROR( -20000,
                                           A_CALLING_FUNCTION
                                        || ' did not find an existing license to save its template for serial_id'
                                        || A_SERIAL_ID( L_ROW ) );
            END IF;
         END IF;
      END LOOP;

      RETURN( CXSAPILK.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IF SQLCODE = -20000
         THEN
            RAISE;
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during '
                                     || A_CALLING_FUNCTION
                                     || '.OracleErrorCode'
                                     || SQLCODE );
         END IF;
   END INTERNALSAVELICENSETEMPLATE;

   FUNCTION SAVELICENSETEMPLATE(
      A_SERIAL_ID                IN       VARCHAR2,   
      A_SHORTNAME                IN       VARCHAR2,   
      A_TEMPLATE                 IN       BLOB,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_SERIAL_ID_TAB               CXSAPILK.VC40_TABLE_TYPE;
      L_SHORTNAME_TAB               CXSAPILK.VC40_TABLE_TYPE;
      L_TEMPLATE_TAB                CXSAPILK.BLOB_TABLE_TYPE;
   BEGIN
      L_SERIAL_ID_TAB( 1 ) := A_SERIAL_ID;
      L_SHORTNAME_TAB( 1 ) := A_SHORTNAME;
      L_TEMPLATE_TAB( 1 ) := A_TEMPLATE;
      RETURN( CXSAPILK.SAVELICENSETEMPLATE( L_SERIAL_ID_TAB,
                                            L_SHORTNAME_TAB,
                                            L_TEMPLATE_TAB,
                                            1,
                                            A_ERROR_MESSAGE ) );
   END SAVELICENSETEMPLATE;

   FUNCTION SAVELICENSETEMPLATE(
      A_SERIAL_ID                IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_SHORTNAME                IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_TEMPLATE                 IN       CXSAPILK.BLOB_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_MODIFY_FLAG                 CXSAPILK.NUM_TABLE_TYPE;
   BEGIN
      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         L_MODIFY_FLAG( L_ROW ) := CXSAPILK.MOD_FLAG_UPDATE;
      END LOOP;

      RETURN( INTERNALSAVELICENSETEMPLATE( A_SERIAL_ID,
                                           A_SHORTNAME,
                                           A_TEMPLATE,
                                           L_MODIFY_FLAG,
                                           A_NR_OF_ROWS,
                                           'SaveLicenseTemplate',
                                           A_ERROR_MESSAGE ) );
   END SAVELICENSETEMPLATE;

   FUNCTION DELETELICENSETEMPLATE(
      A_SERIAL_ID                IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_SHORTNAME                IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_MODIFY_FLAG                 CXSAPILK.NUM_TABLE_TYPE;
      L_DUMMY_BLOB                  CXSAPILK.BLOB_TABLE_TYPE;
   BEGIN
      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         L_MODIFY_FLAG( L_ROW ) := CXSAPILK.MOD_FLAG_DELETE;
      END LOOP;

      RETURN( INTERNALSAVELICENSETEMPLATE( A_SERIAL_ID,
                                           A_SHORTNAME,
                                           L_DUMMY_BLOB,
                                           L_MODIFY_FLAG,
                                           A_NR_OF_ROWS,
                                           'DeleteLicenseTemplate',
                                           A_ERROR_MESSAGE ) );
   END DELETELICENSETEMPLATE;



   FUNCTION GETLICENSE(
      A_SERIAL_ID                OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_SHORTNAME                OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_SETTING_NAME             OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_SETTING_VALUE            OUT      CXSAPILK.VC255_TABLE_TYPE,   
      A_NR_OF_ROWS               IN OUT   NUMBER,   
      A_SEARCH_CRITERIA1         IN       VARCHAR2,   
      A_SEARCH_ID1               IN       VARCHAR2,   
      A_SEARCH_CRITERIA2         IN       VARCHAR2,   
      A_SEARCH_ID2               IN       VARCHAR2,   
      A_NEXT_ROWS                IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_WHERE_CLAUSE                VARCHAR2( 255 );
      L_SERIAL_ID                   RAW( 160 );
      L_SHORTNAME                   RAW( 160 );
      L_SETTING_NAME                RAW( 160 );
      L_SETTING_VALUE               RAW( 1020 );
      L_RESULT                      INTEGER;
      L_SQL_STRING                  VARCHAR2( 255 );
      L_FETCHED_ROWS                INTEGER;
      L_SEARCH_ID1_ENCRYPTED        RAW( 160 );
      L_SEARCH_ID2_ENCRYPTED        RAW( 160 );
      L_BIND1_NECESSARY             BOOLEAN;
      L_BIND2_NECESSARY             BOOLEAN;
      L_SQLERRM                     VARCHAR2( 255 );
      L_OLD_VERSION_SNAME_ENCRYPTED RAW( 160 );
   BEGIN
      IF NVL( A_NR_OF_ROWS,
              0 ) = 0
      THEN
         A_NR_OF_ROWS := CXSAPILK.P_DEFAULT_CHUNK_SIZE;
      ELSIF    A_NR_OF_ROWS < 0
            OR A_NR_OF_ROWS > CXSAPILK.P_MAX_CHUNK_SIZE
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'GetLicense called with a_nr_of_rows too high or negative' );
      END IF;

      IF NVL( A_NEXT_ROWS,
              0 ) NOT IN( -1, 0, 1 )
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'GetLicense called with invalid value for a_next_rows' );
      END IF;

      
      IF A_NEXT_ROWS = -1
      THEN
         IF P_GETLICENSE_CURSOR IS NOT NULL
         THEN
            DBMS_SQL.CLOSE_CURSOR( P_GETLICENSE_CURSOR );
            P_GETLICENSE_CURSOR := NULL;
         END IF;

         A_NR_OF_ROWS := 0;
         RETURN( CXSAPILK.DBERR_SUCCESS );
      END IF;

      
      IF A_NEXT_ROWS = 1
      THEN
         IF P_GETLICENSE_CURSOR IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'GetLicense called with a_next_rows=1 but no cursor open' );
         END IF;
      END IF;

      
      IF NVL( A_NEXT_ROWS,
              0 ) = 0
      THEN
         L_BIND1_NECESSARY := FALSE;
         L_BIND2_NECESSARY := FALSE;
         L_RET_CODE := ENCRYPT( 'old_version',
                                L_OLD_VERSION_SNAME_ENCRYPTED );

         IF NVL( A_SEARCH_CRITERIA1,
                 ' ' ) = ' '
         THEN
            L_WHERE_CLAUSE :=
                  'WHERE serial_id NOT IN (SELECT DISTINCT serial_id FROM ctlicsecid WHERE setting_name = :l_old_version_sname_encrypted) '
               ||   
                  'ORDER BY serial_id, shortname, setting_name';   
         ELSIF     A_SEARCH_CRITERIA1 = 'serial_id'
               AND A_SEARCH_CRITERIA2 IS NULL
         THEN
            L_RET_CODE := ENCRYPT( A_SEARCH_ID1,
                                   L_SEARCH_ID1_ENCRYPTED );
            L_WHERE_CLAUSE :=
                  'WHERE serial_id NOT IN (SELECT DISTINCT serial_id FROM ctlicsecid WHERE setting_name = :l_old_version_sname_encrypted) '
               ||   
                  'AND serial_id = :a_search_id '
               ||   
                  'ORDER BY serial_id, shortname, setting_name';   
            L_BIND1_NECESSARY := TRUE;
         ELSIF     A_SEARCH_CRITERIA1 = 'serial_id'
               AND A_SEARCH_CRITERIA2 = 'shortname'
         THEN
            L_RET_CODE := ENCRYPT( A_SEARCH_ID1,
                                   L_SEARCH_ID1_ENCRYPTED );
            L_RET_CODE := ENCRYPT( A_SEARCH_ID2,
                                   L_SEARCH_ID2_ENCRYPTED );
            L_WHERE_CLAUSE :=
                  'WHERE serial_id NOT IN (SELECT DISTINCT serial_id FROM ctlicsecid WHERE setting_name = :l_old_version_sname_encrypted) '
               ||   
                  'AND serial_id = :a_search_id1 '
               ||   
                  'AND shortname = :a_search_id2 '
               ||   
                  'ORDER BY serial_id, shortname, setting_name';   
            L_BIND1_NECESSARY := TRUE;
            L_BIND2_NECESSARY := TRUE;
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                     'GetLicense: Invalid value for search_criteria' );
         END IF;

         L_SQL_STRING :=    'SELECT a.serial_id, a.shortname, a.setting_name, a.setting_value '
                         || 'FROM ctlicsecid a '
                         || L_WHERE_CLAUSE;

         IF P_GETLICENSE_CURSOR IS NULL
         THEN
            P_GETLICENSE_CURSOR := DBMS_SQL.OPEN_CURSOR;
         END IF;

         DBMS_SQL.PARSE( P_GETLICENSE_CURSOR,
                         L_SQL_STRING,
                         DBMS_SQL.V7 );   
         DBMS_SQL.BIND_VARIABLE_RAW( P_GETLICENSE_CURSOR,
                                     ':l_old_version_sname_encrypted',
                                     L_OLD_VERSION_SNAME_ENCRYPTED );

         IF L_BIND1_NECESSARY
         THEN
            DBMS_SQL.BIND_VARIABLE_RAW( P_GETLICENSE_CURSOR,
                                        ':a_search_id1',
                                        L_SEARCH_ID1_ENCRYPTED );
         END IF;

         IF L_BIND2_NECESSARY
         THEN
            DBMS_SQL.BIND_VARIABLE_RAW( P_GETLICENSE_CURSOR,
                                        ':a_search_id2',
                                        L_SEARCH_ID2_ENCRYPTED );
         END IF;

         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSE_CURSOR,
                                     1,
                                     L_SERIAL_ID,
                                     160 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSE_CURSOR,
                                     2,
                                     L_SHORTNAME,
                                     160 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSE_CURSOR,
                                     3,
                                     L_SETTING_NAME,
                                     160 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSE_CURSOR,
                                     4,
                                     L_SETTING_VALUE,
                                     1020 );
         L_RESULT := DBMS_SQL.EXECUTE( P_GETLICENSE_CURSOR );
      END IF;

      L_RESULT := DBMS_SQL.FETCH_ROWS( P_GETLICENSE_CURSOR );
      L_FETCHED_ROWS := 0;

      LOOP
         EXIT WHEN L_RESULT = 0
               OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSE_CURSOR,
                                    1,
                                    L_SERIAL_ID );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSE_CURSOR,
                                    2,
                                    L_SHORTNAME );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSE_CURSOR,
                                    3,
                                    L_SETTING_NAME );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSE_CURSOR,
                                    4,
                                    L_SETTING_VALUE );
         L_FETCHED_ROWS :=   L_FETCHED_ROWS
                           + 1;
         L_RET_CODE := DECRYPT( L_SERIAL_ID,
                                A_SERIAL_ID( L_FETCHED_ROWS ) );
         L_RET_CODE := DECRYPT( L_SHORTNAME,
                                A_SHORTNAME( L_FETCHED_ROWS ) );
         L_RET_CODE := DECRYPT( L_SETTING_NAME,
                                A_SETTING_NAME( L_FETCHED_ROWS ) );
         L_RET_CODE := DECRYPT( L_SETTING_VALUE,
                                A_SETTING_VALUE( L_FETCHED_ROWS ) );

         IF L_FETCHED_ROWS < A_NR_OF_ROWS
         THEN
            L_RESULT := DBMS_SQL.FETCH_ROWS( P_GETLICENSE_CURSOR );
         END IF;
      END LOOP;

      
      IF ( L_FETCHED_ROWS = 0 )
      THEN
         DBMS_SQL.CLOSE_CURSOR( P_GETLICENSE_CURSOR );
         P_GETLICENSE_CURSOR := NULL;
         RETURN( CXSAPILK.DBERR_NORECORDS );
      ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS
      THEN
         DBMS_SQL.CLOSE_CURSOR( P_GETLICENSE_CURSOR );
         P_GETLICENSE_CURSOR := NULL;
         A_NR_OF_ROWS := L_FETCHED_ROWS;
      END IF;

      RETURN( CXSAPILK.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF DBMS_SQL.IS_OPEN( P_GETLICENSE_CURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( P_GETLICENSE_CURSOR );
         END IF;

         
         IF SQLCODE = -20000
         THEN
            RAISE;
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during GetLicense.OracleErrorCode'
                                     || SQLCODE );
         END IF;
   END GETLICENSE;

   FUNCTION GETLICENSETEMPLATE(
      A_SERIAL_ID                IN       VARCHAR2,   
      A_SHORTNAME                IN       VARCHAR2,   
      A_TEMPLATE                 OUT      BLOB,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_NR_OF_ROWS                  NUMBER;
      L_SEARCH_CRITERIA1            VARCHAR2( 20 );
      L_SEARCH_ID1                  VARCHAR2( 511 );
      L_SEARCH_CRITERIA2            VARCHAR2( 20 );
      L_SEARCH_ID2                  VARCHAR2( 511 );
      L_ERROR_MESSAGE               VARCHAR2( 255 );
      L_SERIAL_ID_TAB               CXSAPILK.VC40_TABLE_TYPE;
      L_SHORTNAME_TAB               CXSAPILK.VC40_TABLE_TYPE;
      L_TEMPLATE_TAB                CXSAPILK.BLOB_TABLE_TYPE;
   BEGIN
      L_SEARCH_CRITERIA1 := 'serial_id';
      L_SEARCH_ID1 := A_SERIAL_ID;
      L_SEARCH_CRITERIA2 := 'shortname';
      L_SEARCH_ID2 := A_SHORTNAME;
      L_NR_OF_ROWS := 100;
      L_RET_CODE :=
         CXSAPILK.GETLICENSETEMPLATE( L_SERIAL_ID_TAB,
                                      L_SHORTNAME_TAB,
                                      L_TEMPLATE_TAB,
                                      L_NR_OF_ROWS,
                                      L_SEARCH_CRITERIA1,
                                      L_SEARCH_ID1,
                                      L_SEARCH_CRITERIA2,
                                      L_SEARCH_ID2,
                                      L_ERROR_MESSAGE );

      IF L_RET_CODE = CXSAPILK.DBERR_SUCCESS
      THEN
         A_TEMPLATE := L_TEMPLATE_TAB( 1 );
         RETURN( L_RET_CODE );
      END IF;

      RETURN( L_RET_CODE );
   END GETLICENSETEMPLATE;

   FUNCTION GETLICENSETEMPLATE(
      A_SERIAL_ID                OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_SHORTNAME                OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_TEMPLATE                 OUT      CXSAPILK.BLOB_TABLE_TYPE,   
      A_NR_OF_ROWS               IN OUT   NUMBER,   
      A_SEARCH_CRITERIA1         IN       VARCHAR2,   
      A_SEARCH_ID1               IN       VARCHAR2,   
      A_SEARCH_CRITERIA2         IN       VARCHAR2,   
      A_SEARCH_ID2               IN       VARCHAR2,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      TYPE LICENSETEMPLATECURTYPE IS REF CURSOR;

      L_LICENSE_TEMPLATE_CURSOR     LICENSETEMPLATECURTYPE;
      L_WHERE_CLAUSE                VARCHAR2( 255 );
      L_SERIAL_ID                   RAW( 160 );
      L_SHORTNAME                   RAW( 160 );
      L_TEMPLATE                    BLOB;
      L_RESULT                      INTEGER;
      L_SQL_STRING                  VARCHAR2( 255 );
      L_FETCHED_ROWS                INTEGER;
      L_SEARCH_ID1_ENCRYPTED        RAW( 160 );
      L_BIND1_NECESSARY             BOOLEAN;
      L_SEARCH_ID2_ENCRYPTED        RAW( 160 );
      L_BIND2_NECESSARY             BOOLEAN;
      L_SQLERRM                     VARCHAR2( 255 );




      L_TIMEUNIT_ENCRYPTED          RAW( 1024 );
      L_TIMEUNIT                    INTEGER;
      L_TIMEUNIT_SNAME_ENCRYPTED    RAW( 160 );
   BEGIN
      IF NVL( A_NR_OF_ROWS,
              0 ) = 0
      THEN
         A_NR_OF_ROWS := CXSAPILK.P_DEFAULT_CHUNK_SIZE;
      ELSIF    A_NR_OF_ROWS < 0
            OR A_NR_OF_ROWS > CXSAPILK.P_MAX_CHUNK_SIZE
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'GetLicenseTemplate called with a_nr_of_rows too high or negative' );
      END IF;

      
      L_BIND1_NECESSARY := FALSE;
      L_BIND2_NECESSARY := FALSE;

      
      IF NVL( A_SEARCH_CRITERIA1,
              ' ' ) = ' '
      THEN
         L_WHERE_CLAUSE := ' ORDER BY a.serial_id, a.shortname';   
      ELSIF     A_SEARCH_CRITERIA1 = 'serial_id'
            AND A_SEARCH_CRITERIA2 IS NULL
      THEN
         L_RET_CODE := ENCRYPT( A_SEARCH_ID1,
                                L_SEARCH_ID1_ENCRYPTED );
         L_WHERE_CLAUSE := 'WHERE a.serial_id = :a_search_id1 ORDER BY a.serial_id, a.shortname';
         L_BIND1_NECESSARY := TRUE;
      ELSIF     A_SEARCH_CRITERIA1 = 'serial_id'
            AND A_SEARCH_CRITERIA2 = 'shortname'
      THEN
         L_RET_CODE := ENCRYPT( A_SEARCH_ID1,
                                L_SEARCH_ID1_ENCRYPTED );
         L_RET_CODE := ENCRYPT( A_SEARCH_ID2,
                                L_SEARCH_ID2_ENCRYPTED );
         L_WHERE_CLAUSE :=    'WHERE a.serial_id = :a_search_id1 '
                           || 'AND a.shortname = :a_search_id2 '
                           || 'ORDER BY a.serial_id, a.shortname';
         L_BIND1_NECESSARY := TRUE;
         L_BIND2_NECESSARY := TRUE;
      ELSE
         RAISE_APPLICATION_ERROR( -20000,
                                  'GetLicenseTemplate: Invalid value for search_criteria' );
      END IF;



      L_SQL_STRING :=    'SELECT a.serial_id, a.shortname, a.template '
                      || 'FROM ctlicsecidauxiliary a '
                      || L_WHERE_CLAUSE;

      IF     L_BIND1_NECESSARY
         AND L_BIND2_NECESSARY
      THEN
         OPEN L_LICENSE_TEMPLATE_CURSOR FOR L_SQL_STRING USING L_SEARCH_ID1_ENCRYPTED,
         L_SEARCH_ID2_ENCRYPTED;
      ELSIF L_BIND1_NECESSARY
      THEN
         OPEN L_LICENSE_TEMPLATE_CURSOR FOR L_SQL_STRING USING L_SEARCH_ID1_ENCRYPTED;
      ELSE
         OPEN L_LICENSE_TEMPLATE_CURSOR FOR L_SQL_STRING;
      END IF;



      FETCH L_LICENSE_TEMPLATE_CURSOR
       INTO L_SERIAL_ID,
            L_SHORTNAME,
            L_TEMPLATE;

      L_FETCHED_ROWS := 0;

      LOOP
         EXIT WHEN L_LICENSE_TEMPLATE_CURSOR%NOTFOUND
               OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

         IF     L_SERIAL_ID = RECO_SERIAL_ID
            AND L_SHORTNAME = RECO_SHORTNAME
         THEN
            
            NULL;
         ELSIF P_LICENSES_RECOVERED = '1'
         THEN
            
            
            NULL;
         ELSE
            
            L_RET_CODE := ENCRYPT( 'timeunit',
                                   L_TIMEUNIT_SNAME_ENCRYPTED );

            BEGIN
               SELECT SETTING_VALUE
                 INTO L_TIMEUNIT_ENCRYPTED
                 FROM CTLICSECID
                WHERE SERIAL_ID = L_SERIAL_ID
                  AND SHORTNAME = L_SHORTNAME
                  AND SETTING_NAME = L_TIMEUNIT_SNAME_ENCRYPTED;

               L_RET_CODE := DECRYPT( L_TIMEUNIT_ENCRYPTED,
                                      L_TIMEUNIT );

               IF L_TIMEUNIT NOT IN( -1, 1, 2, 3, 4 )
               THEN
                  RAISE_APPLICATION_ERROR( -20000,
                                           'Abnormal license detected - timeunit setting has an illegal value' );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  RAISE_APPLICATION_ERROR( -20000,
                                           'Abnormal license detected - no timeunit in settings' );
            END;

            
            IF    L_TIMEUNIT NOT IN( 1, 2, 4 )
               
               
               
               
               OR SYSDATE < TO_DATE( '20/01/2030', 
               
               
                                     'DD/MM/YYYY' )
            THEN
               L_FETCHED_ROWS :=   L_FETCHED_ROWS
                                 + 1;
               L_RET_CODE := DECRYPT( L_SERIAL_ID,
                                      A_SERIAL_ID( L_FETCHED_ROWS ) );
               L_RET_CODE := DECRYPT( L_SHORTNAME,
                                      A_SHORTNAME( L_FETCHED_ROWS ) );
               A_TEMPLATE( L_FETCHED_ROWS ) := L_TEMPLATE;
            
            
            
            
            END IF;
         END IF;

         IF L_FETCHED_ROWS < A_NR_OF_ROWS
         THEN
            FETCH L_LICENSE_TEMPLATE_CURSOR
             INTO L_SERIAL_ID,
                  L_SHORTNAME,
                  L_TEMPLATE;
         END IF;
      END LOOP;

      CLOSE L_LICENSE_TEMPLATE_CURSOR;

      
      IF ( L_FETCHED_ROWS = 0 )
      THEN
         RETURN( CXSAPILK.DBERR_NORECORDS );
      ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS
      THEN
         A_NR_OF_ROWS := L_FETCHED_ROWS;
      END IF;

      RETURN( CXSAPILK.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF L_LICENSE_TEMPLATE_CURSOR%ISOPEN
         THEN
            CLOSE L_LICENSE_TEMPLATE_CURSOR;
         END IF;

         
         IF SQLCODE = -20000
         THEN
            RAISE;
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during GetLicenseTemplate.OracleErrorCode'
                                     || SQLCODE );
         END IF;
   END GETLICENSETEMPLATE;



   FUNCTION CHECKONENEWLICENSE(
      A_SERIAL_ID                IN       RAW,
      A_SHORTNAME                IN       RAW,
      A_APP_ID                   IN       VARCHAR2,
      A_APP_VERSION              IN       VARCHAR2,
      A_APP_CUSTOM_PARAM         IN       VARCHAR2,
      A_LIC_USERS                OUT      NUMBER )
      RETURN NUMBER
   IS
      L_SERIAL_ID_ENCRYPTED         RAW( 160 );
      L_SHORTNAME_ENCRYPTED         RAW( 160 );
      L_HASH_CODE_CLIENT            VARCHAR2( 255 );
      L_HASH_CODE_CLIENT_ENCRYPTED  RAW( 1020 );
      L_HASH_CODE_SERVER            VARCHAR2( 255 );
      L_HASH_CODE_SERVER_CHECK      VARCHAR2( 255 );
      L_HASH_CODE_SERVER_ENCRYPTED  RAW( 1020 );
      L_LIC_USERS                   INTEGER;
      L_EXPIRATION_DATE             DATE;
      L_STRING_TO_HASH              VARCHAR2( 200 );
      L_SETTING_SEQ_ENCRYPTED       CXSAPILK.RAW16_TABLE_TYPE;
      L_SETTING_NAME_ENCRYPTED      CXSAPILK.RAW160_TABLE_TYPE;
      L_SETTING_VALUE_ENCRYPTED     CXSAPILK.RAW1020_TABLE_TYPE;
      L_SETTING_SEQ                 CXSAPILK.NUM_TABLE_TYPE;
      L_SETTING_NAME                CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE               CXSAPILK.VC255_TABLE_TYPE;
      L_SETTING_NAME_SORTED         CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE_SORTED        CXSAPILK.VC255_TABLE_TYPE;
      L_ROWID                       ROWID;
      L_RETURNED                    INTEGER;
      L_SUCCESS                     INTEGER;
      L_RETURNKEY                   VARCHAR2( 255 );
      L_REF_DATE_ENCRYPTED          RAW( 64 );
      L_EXPIRATION_DATE_ENCRYPTED   RAW( 64 );
      L_TIMEUNIT                    INTEGER;
      L_ACTVALIDITY                 INTEGER;
      L_REF_DATE_VC2                VARCHAR2( 16 );
      L_EXPIRATION_DATE_VC2         VARCHAR2( 16 );
      L_VERSION                     VARCHAR2( 4 );
      L_CUSTOM_PARAM                VARCHAR2( 2 );
      L_APP_ID                      VARCHAR2( 4 );
      L_SHORTNAME                   VARCHAR2( 40 );
   BEGIN
      L_RETURNED := CXSAPILK.DBERR_SUCCESS;

      
      SELECT SERIAL_ID,
             SHORTNAME,
             HASH_CODE_CLIENT,
             HASH_CODE_SERVER,
             REF_DATE,
             EXPIRATION_DATE,
             ROWID
        INTO L_SERIAL_ID_ENCRYPTED,
             L_SHORTNAME_ENCRYPTED,
             L_HASH_CODE_CLIENT_ENCRYPTED,
             L_HASH_CODE_SERVER_ENCRYPTED,
             L_REF_DATE_ENCRYPTED,
             L_EXPIRATION_DATE_ENCRYPTED,
             L_ROWID
        FROM CTLICSECIDAUXILIARY
       WHERE SERIAL_ID = A_SERIAL_ID
         AND SHORTNAME = A_SHORTNAME;

      
      SELECT SETTING_SEQ,
             SETTING_NAME,
             SETTING_VALUE
      BULK COLLECT INTO L_SETTING_SEQ_ENCRYPTED,
              L_SETTING_NAME_ENCRYPTED,
              L_SETTING_VALUE_ENCRYPTED
        FROM CTLICSECID
       WHERE SERIAL_ID = A_SERIAL_ID
         AND SHORTNAME = A_SHORTNAME;

      
      
      L_TIMEUNIT := -10;
      L_ACTVALIDITY := -10;
      L_SHORTNAME := NULL;

      FOR L_ROW IN 1 .. L_SETTING_NAME_ENCRYPTED.COUNT( )
      LOOP
         L_RET_CODE := DECRYPT( L_SETTING_SEQ_ENCRYPTED( L_ROW ),
                                L_SETTING_SEQ( L_ROW ) );
         L_RET_CODE := DECRYPT( L_SETTING_NAME_ENCRYPTED( L_ROW ),
                                L_SETTING_NAME( L_ROW ) );
         L_RET_CODE := DECRYPT( L_SETTING_VALUE_ENCRYPTED( L_ROW ),
                                L_SETTING_VALUE( L_ROW ) );

         IF L_SETTING_NAME( L_ROW ) = 'timeunit'
         THEN
            L_TIMEUNIT := L_SETTING_VALUE( L_ROW );
         ELSIF L_SETTING_NAME( L_ROW ) = 'actvalidity'
         THEN
            L_ACTVALIDITY := L_SETTING_VALUE( L_ROW );
         ELSIF L_SETTING_NAME( L_ROW ) = 'shortname'
         THEN
            L_SHORTNAME := L_SETTING_VALUE( L_ROW );
            
            
            
            
            L_APP_ID := SUBSTR( L_SHORTNAME,
                                5,
                                4 );
            L_CUSTOM_PARAM := SUBSTR( L_SHORTNAME,
                                      9,
                                      2 );
            L_VERSION := SUBSTR( L_SHORTNAME,
                                 11,
                                 4 );
         

         ELSE
            NULL;

         END IF;
      END LOOP;

      IF    L_TIMEUNIT = -10
         OR L_ACTVALIDITY = -10
         OR L_SHORTNAME IS NULL
         OR L_VERSION IS NULL
         OR L_CUSTOM_PARAM IS NULL
         OR L_APP_ID IS NULL
         OR LENGTH( L_APP_ID ) <> 4
         OR LENGTH( L_CUSTOM_PARAM ) <> 2
         OR LENGTH( L_VERSION ) <> 4
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'The installed license does not contain the minimal settings !' );
      END IF;

      
      IF SUBSTR( L_APP_ID,
                 2 ) <> SUBSTR( A_APP_ID,
                                2 )
      THEN   
         
         L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
      ELSIF L_APP_ID = 'IULS'
      THEN   
             
         L_LIC_USERS := 1;

         IF L_VERSION <> A_APP_VERSION
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         ELSE
            IF A_APP_CUSTOM_PARAM = 'U0'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'U0' ) NOT IN( 'U0', 'U3', 'U6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'A0'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'A0' ) NOT IN( 'A0', 'A3', 'A6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'U3'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'U0' ) NOT IN( 'U3', 'U6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'A3'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'A0' ) NOT IN( 'A3', 'A6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'T3'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'T3' ) NOT IN( 'T3', 'T6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'U6'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'U0' ) NOT IN( 'U6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'A6'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'A0' ) NOT IN( 'A6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'T6'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'T3' ) NOT IN( 'T6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            END IF;
         END IF;

         
         IF     A_APP_ID = 'IULS'
            AND P_LICENSES_RECOVERED = '1'
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         END IF;

         
         IF     A_APP_ID = 'RULS'
            AND P_LICENSES_RECOVERED = '0'
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         END IF;
      ELSIF L_APP_ID = 'IULC'
      THEN   
         IF L_VERSION <> A_APP_VERSION
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         ELSE
            IF L_CUSTOM_PARAM = 'U0'
            THEN
               
               L_LIC_USERS := 1;
            ELSIF L_CUSTOM_PARAM = 'U4'
            THEN
               L_LIC_USERS := 10;
            ELSIF L_CUSTOM_PARAM = 'U7'
            THEN
               L_LIC_USERS := 25;
            END IF;
         END IF;
      ELSIF L_APP_ID = 'IISS'
      THEN   
         L_LIC_USERS := 1;

         IF L_VERSION <> A_APP_VERSION
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         ELSE
            IF A_APP_CUSTOM_PARAM = 'I0'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,


                       'I0' ) NOT IN( 'I0', 'I3')

               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'T0'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'T0' ) NOT IN( 'T0', 'T3' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'I3'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'I0' ) NOT IN( 'I3' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'T3'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'T0' ) NOT IN( 'T3' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF A_APP_CUSTOM_PARAM = 'I6'
            THEN
               
               IF NVL( L_CUSTOM_PARAM,
                       'I0' ) NOT IN( 'I6' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            END IF;

            IF A_APP_CUSTOM_PARAM IN( 'I0', 'I6', 'T0' )
            THEN
               
               NULL;
            ELSIF A_APP_CUSTOM_PARAM IN( 'I3', 'T3' )
            THEN
               IF NVL( L_CUSTOM_PARAM,
                       'I0' ) NOT IN( 'I3', 'T3' )
               THEN
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            END IF;
         END IF;

         
         IF     A_APP_ID = 'IISS'
            AND P_LICENSES_RECOVERED = '1'
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         END IF;

         
         IF     A_APP_ID = 'RISS'
            AND P_LICENSES_RECOVERED = '0'
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         END IF;
      ELSIF L_APP_ID = 'IISC'
      THEN   
         IF L_VERSION <> A_APP_VERSION
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         ELSE
            
            
            IF    SUBSTR( A_APP_CUSTOM_PARAM,
                          1,
                          1 ) = 'I'
               OR A_APP_CUSTOM_PARAM IS NULL
            THEN
               IF L_CUSTOM_PARAM = 'I0'
               THEN
                  L_LIC_USERS := 1;
               ELSIF L_CUSTOM_PARAM = 'I4'
               THEN
                  L_LIC_USERS := 10;
               ELSIF L_CUSTOM_PARAM = 'I7'
               THEN
                  L_LIC_USERS := 25;
               ELSIF L_CUSTOM_PARAM = 'I5'
               THEN
                  L_LIC_USERS := 100;
               ELSIF L_CUSTOM_PARAM = 'I9'
               THEN
                  L_LIC_USERS := 500;
               ELSE
                  L_LIC_USERS := 0;
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSIF SUBSTR( A_APP_CUSTOM_PARAM,
                          1,
                          1 ) = 'R'
            THEN
               IF L_CUSTOM_PARAM = 'R0'
               THEN
                  L_LIC_USERS := 1;
               ELSIF L_CUSTOM_PARAM = 'R4'
               THEN
                  L_LIC_USERS := 10;
               ELSIF L_CUSTOM_PARAM = 'R7'
               THEN
                  L_LIC_USERS := 25;
               ELSIF L_CUSTOM_PARAM = 'R5'
               THEN
                  L_LIC_USERS := 100;
               ELSIF L_CUSTOM_PARAM = 'R9'
               THEN
                  L_LIC_USERS := 500;
               ELSE
                  L_LIC_USERS := 0;
                  L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
               END IF;
            ELSE
               L_LIC_USERS := 0;
               L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
            END IF;
         END IF;
      ELSE
         L_LIC_USERS := 1;

         
         IF L_VERSION <> A_APP_VERSION
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         END IF;

         
         IF L_CUSTOM_PARAM <> A_APP_CUSTOM_PARAM
         THEN
            L_RETURNED := CXSAPILK.DBERR_NOLICENSE4APP;
         END IF;
      END IF;

      
      IF L_RETURNED = CXSAPILK.DBERR_SUCCESS
      THEN
         
         L_STRING_TO_HASH := '';
         LOCALSORT( L_SETTING_SEQ,
                    L_SETTING_NAME,
                    L_SETTING_VALUE,
                    L_SETTING_NAME_SORTED,
                    L_SETTING_VALUE_SORTED,
                    L_SETTING_NAME.COUNT( ) );

         FOR L_ROW IN 1 .. L_SETTING_NAME_SORTED.COUNT( )
         LOOP
            L_STRING_TO_HASH := SUBSTR(    L_STRING_TO_HASH
                                        || '#'
                                        || L_SETTING_NAME_SORTED( L_ROW )
                                        || '#'
                                        || L_SETTING_VALUE_SORTED( L_ROW ),
                                        1,
                                        200 );
         END LOOP;

         
         L_SUCCESS := GENERATEHASHCODELIKECLIENT( L_STRING_TO_HASH,
                                                  L_RETURNKEY );

         IF L_SUCCESS <> CXSAPILK.DBERR_SUCCESS
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during license check'
                                     || SQLCODE );
         END IF;

         L_RET_CODE := DECRYPT( L_HASH_CODE_CLIENT_ENCRYPTED,
                                L_HASH_CODE_CLIENT );

         IF ( L_RETURNKEY != L_HASH_CODE_CLIENT )
         THEN

            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;
         
         END IF;

         L_RET_CODE := DECRYPT( L_HASH_CODE_SERVER_ENCRYPTED,
                                L_HASH_CODE_SERVER );
         L_RET_CODE := DECRYPT( L_REF_DATE_ENCRYPTED,
                                L_REF_DATE_VC2 );
         L_RET_CODE := DECRYPT( L_EXPIRATION_DATE_ENCRYPTED,
                                L_EXPIRATION_DATE_VC2 );
         L_HASH_CODE_SERVER_CHECK :=    L_ROWID
                                     || P_SID_NAME
                                     || L_REF_DATE_VC2
                                     || L_EXPIRATION_DATE_VC2;

         FOR L_REC IN ( SELECT  A.*,
                                A.ROWID
                           FROM CTLICSECID A
                          WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
                            AND SHORTNAME = L_SHORTNAME_ENCRYPTED
                       ORDER BY SETTING_SEQ )
         LOOP
            L_HASH_CODE_SERVER_CHECK := SUBSTR(    L_HASH_CODE_SERVER_CHECK
                                                || L_REC.ROWID,
                                                1,
                                                255 );
         END LOOP;

         
         IF     L_HASH_CODE_SERVER <> L_HASH_CODE_SERVER_CHECK
            AND P_LICENSES_RECOVERED = '0'
         THEN
            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;

         
         END IF;

         
         L_EXPIRATION_DATE := TO_DATE( L_EXPIRATION_DATE_VC2,
                                       'DDMMYYYYHH24MISS' );

      END IF;


   
      IF L_RETURNED = CXSAPILK.DBERR_SUCCESS
      THEN
         IF L_EXPIRATION_DATE < SYSDATE
         THEN

            L_RETURNED := CXSAPILK.DBERR_LICENSEEXPIRED;
         END IF;
      END IF;

      IF L_RETURNED = CXSAPILK.DBERR_SUCCESS
      THEN
         A_LIC_USERS := L_LIC_USERS;
      ELSE
         A_LIC_USERS := 0;
      END IF;


      RETURN( L_RETURNED );
   END CHECKONENEWLICENSE;






   FUNCTION CHECKONEALTERNATELICENSE(
      A_APP_ID                   IN       VARCHAR2,
      A_APP_VERSION              IN       VARCHAR2,
      A_APP_CUSTOM_PARAM         IN       VARCHAR2,
      A_LIC_USERS                OUT      NUMBER,
      A_CONSUMED_SERIAL_ID       OUT      VARCHAR2,
      A_CONSUMED_SHORTNAME       OUT      VARCHAR2 )
      RETURN NUMBER
   IS
      L_ALT_APP_ID                  CXSAPILK.VC20_TABLE_TYPE;
      L_ALT_APP_VERSION             CXSAPILK.VC20_TABLE_TYPE;
      L_ALT_APP_CUSTOM_PARAM        CXSAPILK.VC20_TABLE_TYPE;
      L_ALT_MAX_USERS               CXSAPILK.NUM_TABLE_TYPE;
      L_MAX_USERS                   INTEGER;
      L_VALID_LICENSE4APP_FOUND     BOOLEAN;
      L_TEMP_LIC_USERS              INTEGER;
   BEGIN
      
      IF A_APP_ID NOT IN( 'IULC', 'ISQM', 'IUUC', 'IUPP', 'IISC' )
      THEN
         RETURN( CXSAPILK.DBERR_NOLICENSE4APP );
      ELSIF A_APP_ID = 'IULC'
      THEN
         
         L_ALT_APP_ID( 1 ) := 'IULS';
         L_ALT_APP_VERSION( 1 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 1 ) := 'T3';
         L_ALT_MAX_USERS( 1 ) := 5;
         
         L_ALT_APP_ID( 2 ) := 'RULS';
         L_ALT_APP_VERSION( 2 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 2 ) := 'T3';
         L_ALT_MAX_USERS( 2 ) := 5;
         
         L_ALT_APP_ID( 3 ) := 'IULS';
         L_ALT_APP_VERSION( 3 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 3 ) := 'A0';
         L_ALT_MAX_USERS( 3 ) := 1;
         
         L_ALT_APP_ID( 4 ) := 'RULS';
         L_ALT_APP_VERSION( 4 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 4 ) := 'A0';
         L_ALT_MAX_USERS( 4 ) := 1;
      ELSIF A_APP_ID IN( 'ISQM', 'IUUC', 'IUPP' )
      THEN
         
         L_ALT_APP_ID( 1 ) := 'IULS';
         L_ALT_APP_VERSION( 1 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 1 ) := 'T3';
         L_ALT_MAX_USERS( 1 ) := 5;
         
         L_ALT_APP_ID( 2 ) := 'RULS';
         L_ALT_APP_VERSION( 2 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 2 ) := 'T3';
         L_ALT_MAX_USERS( 2 ) := 5;
         
         L_ALT_APP_ID( 3 ) := 'IULS';
         L_ALT_APP_VERSION( 3 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 3 ) := 'A0';
         L_ALT_MAX_USERS( 3 ) := 1;
         
         L_ALT_APP_ID( 4 ) := 'RULS';
         L_ALT_APP_VERSION( 4 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 4 ) := 'A0';
         L_ALT_MAX_USERS( 4 ) := 1;
      ELSIF A_APP_ID = 'IISC'
      THEN
         
         L_ALT_APP_ID( 1 ) := 'IISS';
         L_ALT_APP_VERSION( 1 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 1 ) := 'T0';
         L_ALT_MAX_USERS( 1 ) := 5;
         
         L_ALT_APP_ID( 2 ) := 'RISS';
         L_ALT_APP_VERSION( 2 ) := A_APP_VERSION;
         L_ALT_APP_CUSTOM_PARAM( 2 ) := 'T0';
         L_ALT_MAX_USERS( 2 ) := 5;
      END IF;

      
      
      L_MAX_USERS := 0;
      L_VALID_LICENSE4APP_FOUND := FALSE;

      FOR L_ALT_ROW IN 1 .. L_ALT_APP_ID.COUNT( )
      LOOP
         FOR L_REC IN ( SELECT DISTINCT SERIAL_ID,
                                        SHORTNAME
                                  FROM CTLICSECIDAUXILIARY
                                 WHERE SERIAL_ID <> RECO_SERIAL_ID
                                   AND SHORTNAME <> RECO_SHORTNAME )
         LOOP
         
         
         

            L_RET_CODE :=
               CHECKONENEWLICENSE( L_REC.SERIAL_ID,
                                   L_REC.SHORTNAME,
                                   L_ALT_APP_ID( L_ALT_ROW ),
                                   L_ALT_APP_VERSION( L_ALT_ROW ),
                                   L_ALT_APP_CUSTOM_PARAM( L_ALT_ROW ),
                                   L_TEMP_LIC_USERS );



            
            
            IF L_RET_CODE = CXSAPILK.DBERR_SUCCESS
            THEN
               L_VALID_LICENSE4APP_FOUND := TRUE;
               A_LIC_USERS := L_ALT_MAX_USERS( L_ALT_ROW );
               L_RET_CODE := DECRYPT( L_REC.SERIAL_ID,
                                      A_CONSUMED_SERIAL_ID );
               L_RET_CODE := DECRYPT( L_REC.SHORTNAME,
                                      A_CONSUMED_SHORTNAME );
               EXIT;
            END IF;
         END LOOP;

         IF L_VALID_LICENSE4APP_FOUND = TRUE
         THEN
            EXIT;
         END IF;
      END LOOP;

      IF L_VALID_LICENSE4APP_FOUND = TRUE
      THEN
         RETURN( CXSAPILK.DBERR_SUCCESS );
      ELSE
         RETURN( CXSAPILK.DBERR_NOLICENSE4APP );
      END IF;
   END CHECKONEALTERNATELICENSE;









   FUNCTION INTERNALCHECKLICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_CUSTOM_PARAM         IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LIC_CHECK_OK_4_APP       OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_MAX_USERS_4_APP          OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_CONSUMER_COUNT           IN       NUMBER,   
      A_CONSUMED_SERIAL_ID       OUT      VARCHAR2,   
      A_CONSUMED_SHORTNAME       OUT      VARCHAR2,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_OLD_VERSION_SNAME_ENCRYPTED RAW( 160 );
      L_COUNT_LICENSES              INTEGER;
      L_COUNT_OLD_LICENSES          INTEGER;
      L_LICENSE_TYPE                VARCHAR2( 3 );
      L_SETTING_SEQ_ENCRYPTED       CXSAPILK.RAW16_TABLE_TYPE;
      L_SETTING_NAME_ENCRYPTED      CXSAPILK.RAW160_TABLE_TYPE;
      L_SETTING_VALUE_ENCRYPTED     CXSAPILK.RAW1020_TABLE_TYPE;
      L_SETTING_SEQ                 CXSAPILK.NUM_TABLE_TYPE;
      L_SETTING_NAME                CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE               CXSAPILK.VC255_TABLE_TYPE;
      L_SETTING_NAME_SORTED         CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE_SORTED        CXSAPILK.VC255_TABLE_TYPE;
      L_STRING_TO_HASH              VARCHAR2( 200 );
      L_SERIAL_ID_ENCRYPTED         RAW( 160 );
      L_SHORTNAME_ENCRYPTED         RAW( 160 );
      L_SERIAL_ID                   VARCHAR2( 40 );
      L_SHORTNAME                   VARCHAR2( 40 );
      L_SUCCESS                     INTEGER;
      L_RETURNKEY                   VARCHAR2( 255 );
      L_HASH_CODE_CLIENT            VARCHAR2( 255 );
      L_HASH_CODE_CLIENT_ENCRYPTED  RAW( 1020 );
      L_HASH_CODE_SERVER            VARCHAR2( 255 );
      L_HASH_CODE_SERVER_CHECK      VARCHAR2( 255 );
      L_HASH_CODE_SERVER_ENCRYPTED  RAW( 1020 );
      L_ROWID                       ROWID;
      L_MAX_USERS                   INTEGER;
      L_LIC_USERS                   INTEGER;
      L_RETURNED                    INTEGER;
      L_EXPIRE_DATE                 DATE;
      L_VALID_LICENSE4APP_FOUND     BOOLEAN;
      L_LAST_UNSUCCESSFULL_RET_CODE INTEGER;
      L_ANY_VALID_LICENSE_FOUND     BOOLEAN;
      L_MODULES                     VARCHAR2( 255 );
      L_CUSTOM_PARAM                VARCHAR2( 20 );
      L_REF_DATE_ENCRYPTED          RAW( 64 );
      L_EXPIRATION_DATE_ENCRYPTED   RAW( 64 );
      L_REF_DATE_VC2                VARCHAR2( 16 );
      L_EXPIRATION_DATE_VC2         VARCHAR2( 16 );
      L_LEAST_UNSUCCESSFULL_RET_CODE INTEGER;
      L_ALT_RET_CODE                INTEGER;
   BEGIN
      L_RETURNED := CXSAPILK.DBERR_SUCCESS;

      
      IF NVL( A_NR_OF_ROWS,
              0 ) <= 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'CheckLicense may not be called with a_nr_of_rows<=0' );
      END IF;

      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         IF A_APP_ID( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'CheckLicense may not be called with an a_app_id that is NULL' );
         END IF;

         IF A_APP_VERSION( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'CheckLicense may not be called with an a_app_version that is NULL' );
         END IF;
      END LOOP;

      
      
      
      L_RET_CODE := ENCRYPT( 'old_version',
                             L_OLD_VERSION_SNAME_ENCRYPTED );

      SELECT COUNT( DISTINCT SERIAL_ID
                     || SHORTNAME )
        INTO L_COUNT_LICENSES
        FROM CTLICSECID;

      SELECT COUNT( DISTINCT SERIAL_ID )
        INTO L_COUNT_OLD_LICENSES
        FROM CTLICSECID
       WHERE SETTING_NAME IN( L_OLD_VERSION_SNAME_ENCRYPTED );

      IF ( L_COUNT_LICENSES = 0 )
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'CheckLicense: No license installed' );
      ELSIF(     L_COUNT_LICENSES = 1
             AND L_COUNT_OLD_LICENSES = 1 )
      THEN
         L_LICENSE_TYPE := 'OLD';
      ELSIF(     L_COUNT_LICENSES > 1
             AND L_COUNT_OLD_LICENSES >= 1 )
      THEN
         IF ( L_COUNT_LICENSES > L_COUNT_OLD_LICENSES )
         THEN
            
            L_LICENSE_TYPE := 'NEW';
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                     'CheckLicense: Multiple old licenses installed' );
         END IF;
      ELSE
         L_LICENSE_TYPE := 'NEW';
      END IF;

      IF L_LICENSE_TYPE = 'OLD'
      THEN

      
         SELECT SERIAL_ID,
                SHORTNAME,
                HASH_CODE_CLIENT,
                HASH_CODE_SERVER,
                REF_DATE,
                EXPIRATION_DATE,
                ROWID
           INTO L_SERIAL_ID_ENCRYPTED,
                L_SHORTNAME_ENCRYPTED,
                L_HASH_CODE_CLIENT_ENCRYPTED,
                L_HASH_CODE_SERVER_ENCRYPTED,
                L_REF_DATE_ENCRYPTED,
                L_EXPIRATION_DATE_ENCRYPTED,
                L_ROWID
           FROM CTLICSECIDAUXILIARY
          WHERE SERIAL_ID <> RECO_SERIAL_ID
            AND SHORTNAME <> RECO_SHORTNAME;

         
         SELECT SETTING_SEQ,
                SETTING_NAME,
                SETTING_VALUE
         BULK COLLECT INTO L_SETTING_SEQ_ENCRYPTED,
                 L_SETTING_NAME_ENCRYPTED,
                 L_SETTING_VALUE_ENCRYPTED
           FROM CTLICSECID;

         
         
         FOR L_ROW IN 1 .. L_SETTING_NAME_ENCRYPTED.COUNT( )
         LOOP
            L_RET_CODE := DECRYPT( L_SETTING_SEQ_ENCRYPTED( L_ROW ),
                                   L_SETTING_SEQ( L_ROW ) );
            L_RET_CODE := DECRYPT( L_SETTING_NAME_ENCRYPTED( L_ROW ),
                                   L_SETTING_NAME( L_ROW ) );
            L_RET_CODE := DECRYPT( L_SETTING_VALUE_ENCRYPTED( L_ROW ),
                                   L_SETTING_VALUE( L_ROW ) );

            IF L_SETTING_NAME( L_ROW ) = 'users'
            THEN
               L_MAX_USERS := L_SETTING_VALUE( L_ROW );
            ELSIF L_SETTING_NAME( L_ROW ) = 'expire_date'
            THEN
               L_EXPIRE_DATE := TO_DATE( L_SETTING_VALUE( L_ROW ),
                                         'DD-MON-YYYY',
                                         'NLS_DATE_LANGUAGE = American' );
            ELSIF L_SETTING_NAME( L_ROW ) = 'modules'
            THEN
               L_MODULES := L_SETTING_VALUE( L_ROW );

            ELSE
               NULL;

            END IF;
         END LOOP;

         
         L_RET_CODE := DECRYPT( L_SERIAL_ID_ENCRYPTED,
                                L_SERIAL_ID );
         L_RET_CODE := DECRYPT( L_SHORTNAME_ENCRYPTED,
                                L_SHORTNAME );
         L_STRING_TO_HASH := '';
         LOCALSORT( L_SETTING_SEQ,
                    L_SETTING_NAME,
                    L_SETTING_VALUE,
                    L_SETTING_NAME_SORTED,
                    L_SETTING_VALUE_SORTED,
                    L_SETTING_NAME.COUNT( ) );

         FOR L_ROW IN 1 .. L_SETTING_NAME_SORTED.COUNT( )
         LOOP
            L_STRING_TO_HASH := SUBSTR(    L_STRING_TO_HASH
                                        || '#'
                                        || L_SETTING_NAME_SORTED( L_ROW )
                                        || '#'
                                        || L_SETTING_VALUE_SORTED( L_ROW ),
                                        1,
                                        200 );
         END LOOP;

         
         L_SUCCESS := GENERATEHASHCODELIKECLIENT( L_STRING_TO_HASH,
                                                  L_RETURNKEY );

         IF L_SUCCESS <> CXSAPILK.DBERR_SUCCESS
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during license check'
                                     || SQLCODE );
         END IF;

         L_RET_CODE := DECRYPT( L_HASH_CODE_CLIENT_ENCRYPTED,
                                L_HASH_CODE_CLIENT );

         IF ( L_RETURNKEY != L_HASH_CODE_CLIENT )
         THEN
            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;
         END IF;

         L_RET_CODE := DECRYPT( L_HASH_CODE_SERVER_ENCRYPTED,
                                L_HASH_CODE_SERVER );
         L_RET_CODE := DECRYPT( L_REF_DATE_ENCRYPTED,
                                L_REF_DATE_VC2 );
         L_RET_CODE := DECRYPT( L_EXPIRATION_DATE_ENCRYPTED,
                                L_EXPIRATION_DATE_VC2 );
         L_HASH_CODE_SERVER_CHECK :=    L_ROWID
                                     || P_SID_NAME
                                     || L_REF_DATE_VC2
                                     || L_EXPIRATION_DATE_VC2;

         FOR L_REC IN ( SELECT  A.*,
                                A.ROWID
                           FROM CTLICSECID A
                          WHERE SERIAL_ID = L_SERIAL_ID_ENCRYPTED
                       ORDER BY SETTING_SEQ )
         LOOP
            L_HASH_CODE_SERVER_CHECK := SUBSTR(    L_HASH_CODE_SERVER_CHECK
                                                || L_REC.ROWID,
                                                1,
                                                255 );
         END LOOP;

         
         IF     L_HASH_CODE_SERVER <> L_HASH_CODE_SERVER_CHECK
            AND P_LICENSES_RECOVERED = '0'
         THEN
            L_RETURNED := CXSAPILK.DBERR_INVALIDLICENSE;
         END IF;


         
         IF L_RETURNED = CXSAPILK.DBERR_SUCCESS
         THEN             
                     
            IF L_EXPIRE_DATE < SYSDATE
            THEN
               L_RETURNED := CXSAPILK.DBERR_LICENSEEXPIRED;
            END IF;
            

         END IF;


      
         IF L_RETURNED = CXSAPILK.DBERR_SUCCESS
         THEN
            FOR L_ROW IN 1 .. A_NR_OF_ROWS
            LOOP
               IF A_APP_CUSTOM_PARAM( L_ROW ) IS NOT NULL
               THEN
                  
                  IF A_APP_ID( L_ROW ) = 'IULS'
                  THEN   
                     IF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                             'U0' ) NOT IN( 'U0', 'U3', 'U6', 'A0', 'A3', 'A6', 'T3', 'T6' )
                     THEN
                        RAISE_APPLICATION_ERROR( -20000,
                                                 'CheckLicense invalid custom parameter' );
                     END IF;

                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     IF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                             'U0' ) IN( 'U0', 'A0' )
                     THEN
                        A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                     ELSIF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                                'U0' ) IN( 'U3', 'A3', 'T3' )
                     THEN
                        IF INSTR( SUBSTR( L_MODULES,
                                          1,
                                          2 ),
                                  '1' ) > 0
                        THEN
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                        ELSE
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_NOLICENSE4APP;
                        END IF;
                     ELSIF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                                'U0' ) IN( 'U6', 'A6', 'T6' )
                     THEN
                        IF INSTR( SUBSTR( L_MODULES,
                                          3,
                                          2 ),
                                  '1' ) > 0
                        THEN
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                        ELSE
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_NOLICENSE4APP;
                        END IF;
                     END IF;
                  ELSIF A_APP_ID( L_ROW ) = 'IISS'
                  THEN   
                     IF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                             


                             'I0' ) NOT IN( 'I0', 'I3', 'T0', 'T3' )

                     THEN
                        RAISE_APPLICATION_ERROR( -20000,
                                                 'CheckLicense invalid custom parameter' );
                     END IF;

                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     IF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                             'I0' ) IN( 'I0', 'T0' )
                     THEN
                        A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                     ELSIF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                                'I0' ) IN( 'I3', 'T3' )
                     THEN
                        IF SUBSTR( L_MODULES,
                                   3,
                                   1 ) = '1'
                        THEN
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                        ELSE
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_NOLICENSE4APP;
                        END IF;
                     END IF;
                  
                  ELSIF A_APP_ID( L_ROW ) = 'RISS'
                  THEN   
                     IF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                             


                             'I0' ) NOT IN( 'I0', 'I3', 'T0', 'T3' )                                                          

                     THEN
                        RAISE_APPLICATION_ERROR( -20000,
                                                 'CheckLicense invalid custom parameter' );
                     END IF;

                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     IF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                             'I0' ) IN( 'I0', 'T0' )
                     THEN
                        A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                     ELSIF NVL( A_APP_CUSTOM_PARAM( L_ROW ),
                                'I0' ) IN( 'I3', 'T3' )
                     THEN
                        IF SUBSTR( L_MODULES,
                                   3,
                                   1 ) = '1'
                        THEN
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                        ELSE
                           A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_NOLICENSE4APP;
                        END IF;
                     END IF;
                     
                     
                  ELSE
                     A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                  END IF;
               ELSE
                  A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
               END IF;
            END LOOP;
         END IF;



         
         
         
         L_ANY_VALID_LICENSE_FOUND := FALSE;
         L_LAST_UNSUCCESSFULL_RET_CODE := L_RETURNED;

         
         FOR L_ROW IN 1 .. A_NR_OF_ROWS
         LOOP
            IF L_RETURNED NOT IN( CXSAPILK.DBERR_SUCCESS, CXSAPILK.DBERR_OK_NO_ALM )
            THEN
               A_LIC_CHECK_OK_4_APP( L_ROW ) := L_RETURNED;
               A_MAX_USERS_4_APP( L_ROW ) := 0;
            ELSIF    A_LIC_CHECK_OK_4_APP( L_ROW ) IS NULL
                  OR A_LIC_CHECK_OK_4_APP( L_ROW ) = CXSAPILK.DBERR_SUCCESS
            THEN
               A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
               A_MAX_USERS_4_APP( L_ROW ) := L_MAX_USERS;
               L_ANY_VALID_LICENSE_FOUND := TRUE;
            ELSE
               A_MAX_USERS_4_APP( L_ROW ) := 0;
               L_LAST_UNSUCCESSFULL_RET_CODE := A_LIC_CHECK_OK_4_APP( L_ROW );
            END IF;
         END LOOP;


         IF L_ANY_VALID_LICENSE_FOUND = TRUE
         THEN
            L_RETURNED := CXSAPILK.DBERR_OK_NO_ALM;
         ELSE
            L_RETURNED := L_LAST_UNSUCCESSFULL_RET_CODE;
         END IF;

         IF     A_CONSUMER_COUNT > 0
            AND L_ANY_VALID_LICENSE_FOUND
         THEN
            A_CONSUMED_SERIAL_ID := L_SERIAL_ID;
            A_CONSUMED_SHORTNAME := L_SHORTNAME;
         END IF;
      ELSE

         L_ANY_VALID_LICENSE_FOUND := FALSE;

         FOR L_ROW IN 1 .. A_NR_OF_ROWS
         LOOP

         
            L_MAX_USERS := 0;
            L_VALID_LICENSE4APP_FOUND := FALSE;
            L_LEAST_UNSUCCESSFULL_RET_CODE := CXSAPILK.DBERR_SUCCESS;

            FOR L_REC IN ( SELECT DISTINCT SERIAL_ID,
                                           SHORTNAME
                                     FROM CTLICSECIDAUXILIARY
                                    WHERE SERIAL_ID <> RECO_SERIAL_ID
                                      AND SHORTNAME <> RECO_SHORTNAME )
            LOOP
            
            
            

               L_RET_CODE :=
                  CHECKONENEWLICENSE( L_REC.SERIAL_ID,
                                      L_REC.SHORTNAME,
                                      A_APP_ID( L_ROW ),
                                      A_APP_VERSION( L_ROW ),
                                      A_APP_CUSTOM_PARAM( L_ROW ),
                                      L_LIC_USERS );



               
               
               IF L_RET_CODE = CXSAPILK.DBERR_SUCCESS
               THEN
                  L_VALID_LICENSE4APP_FOUND := TRUE;
                  L_MAX_USERS :=   L_MAX_USERS
                                 + L_LIC_USERS;

               
               
               
               



                  IF     A_CONSUMER_COUNT > 0
                     AND A_CONSUMED_SERIAL_ID IS NULL
                     AND L_MAX_USERS >= A_CONSUMER_COUNT
                  THEN
                     L_RET_CODE := DECRYPT( L_REC.SERIAL_ID,
                                            L_SERIAL_ID );
                     A_CONSUMED_SERIAL_ID := L_SERIAL_ID;
                     L_RET_CODE := DECRYPT( L_REC.SHORTNAME,
                                            L_SHORTNAME );
                     A_CONSUMED_SHORTNAME := L_SHORTNAME;
                  END IF;
               ELSE
                  
                  IF L_LEAST_UNSUCCESSFULL_RET_CODE = DBERR_TOOMANYUSERS4ALM
                  THEN
                     NULL;
                  ELSIF L_RET_CODE = DBERR_LICENSEEXPIRED
                  THEN
                     IF L_LEAST_UNSUCCESSFULL_RET_CODE <> DBERR_TOOMANYUSERS4ALM
                     THEN
                        L_LEAST_UNSUCCESSFULL_RET_CODE := L_RET_CODE;
                     END IF;
                  ELSE
                     IF L_LEAST_UNSUCCESSFULL_RET_CODE NOT IN( DBERR_TOOMANYUSERS4ALM, DBERR_LICENSEEXPIRED )
                     THEN
                        L_LEAST_UNSUCCESSFULL_RET_CODE := L_RET_CODE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;

            IF L_VALID_LICENSE4APP_FOUND
            THEN
               A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
               A_MAX_USERS_4_APP( L_ROW ) := L_MAX_USERS;
               L_ANY_VALID_LICENSE_FOUND := TRUE;
            ELSE
               IF L_LEAST_UNSUCCESSFULL_RET_CODE = CXSAPILK.DBERR_SUCCESS
               THEN
                  
                  L_LEAST_UNSUCCESSFULL_RET_CODE := CXSAPILK.DBERR_NOLICENSE4APP;
                  A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_NOLICENSE4APP;
                  A_MAX_USERS_4_APP( L_ROW ) := 0;
               ELSE
                  
                  A_LIC_CHECK_OK_4_APP( L_ROW ) := L_LEAST_UNSUCCESSFULL_RET_CODE;
                  A_MAX_USERS_4_APP( L_ROW ) := 0;
                  
                  L_ALT_RET_CODE :=
                     CHECKONEALTERNATELICENSE( A_APP_ID( L_ROW ),
                                               A_APP_VERSION( L_ROW ),
                                               A_APP_CUSTOM_PARAM( L_ROW ),
                                               L_LIC_USERS,
                                               L_SERIAL_ID,
                                               L_SHORTNAME );

                  IF L_ALT_RET_CODE = CXSAPILK.DBERR_SUCCESS
                  THEN
                     L_MAX_USERS :=   L_MAX_USERS
                                    + L_LIC_USERS;
                     A_LIC_CHECK_OK_4_APP( L_ROW ) := CXSAPILK.DBERR_SUCCESS;
                     A_MAX_USERS_4_APP( L_ROW ) := L_LIC_USERS;
                     L_ANY_VALID_LICENSE_FOUND := TRUE;
                     L_LEAST_UNSUCCESSFULL_RET_CODE := CXSAPILK.DBERR_SUCCESS;

                     IF     A_CONSUMER_COUNT > 0
                        AND A_CONSUMED_SERIAL_ID IS NULL
                        AND L_MAX_USERS >= A_CONSUMER_COUNT
                     THEN
                        A_CONSUMED_SERIAL_ID := L_SERIAL_ID;
                        A_CONSUMED_SHORTNAME := L_SHORTNAME;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END LOOP;

         IF L_ANY_VALID_LICENSE_FOUND = TRUE
         THEN
            L_RETURNED := CXSAPILK.DBERR_SUCCESS;
         ELSE
            L_RETURNED := L_LEAST_UNSUCCESSFULL_RET_CODE;
         END IF;
      END IF;

      RETURN( L_RETURNED );
   END INTERNALCHECKLICENSE;

   FUNCTION CHECKLICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LIC_CHECK_OK_4_APP       OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_MAX_USERS_4_APP          OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_APP_CUSTOM_PARAM            CXSAPILK.VC20_TABLE_TYPE;
      L_CONSUMER_COUNT              INTEGER;
      L_CONSUMED_SERIAL_ID          VARCHAR2( 40 );
      L_CONSUMED_SHORTNAME          VARCHAR2( 40 );
   BEGIN
      L_CONSUMER_COUNT := 0;

      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         L_APP_CUSTOM_PARAM( L_ROW ) := '';
      END LOOP;

      RETURN( INTERNALCHECKLICENSE( A_APP_ID,
                                    A_APP_VERSION,
                                    L_APP_CUSTOM_PARAM,
                                    A_LIC_CHECK_OK_4_APP,
                                    A_MAX_USERS_4_APP,
                                    L_CONSUMER_COUNT,
                                    L_CONSUMED_SERIAL_ID,
                                    L_CONSUMED_SHORTNAME,
                                    A_NR_OF_ROWS,
                                    A_ERROR_MESSAGE ) );
   END CHECKLICENSE;

   FUNCTION CHECKLICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_CUSTOM_PARAM         IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LIC_CHECK_OK_4_APP       OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_MAX_USERS_4_APP          OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_CONSUMER_COUNT              INTEGER;
      L_CONSUMED_SERIAL_ID          VARCHAR2( 40 );
      L_CONSUMED_SHORTNAME          VARCHAR2( 40 );
   BEGIN
      L_CONSUMER_COUNT := 0;
      RETURN( INTERNALCHECKLICENSE( A_APP_ID,
                                    A_APP_VERSION,
                                    A_APP_CUSTOM_PARAM,
                                    A_LIC_CHECK_OK_4_APP,
                                    A_MAX_USERS_4_APP,
                                    L_CONSUMER_COUNT,
                                    L_CONSUMED_SERIAL_ID,
                                    L_CONSUMED_SHORTNAME,
                                    A_NR_OF_ROWS,
                                    A_ERROR_MESSAGE ) );
   END CHECKLICENSE;



   FUNCTION DYNAMICENCRYPT   
                          (
      A_INPUT_STRING             IN       VARCHAR2,
      A_ENCRYPTED_DATA           OUT      RAW )
      RETURN NUMBER
   IS
      L_NEW_LENGTH                  INTEGER;
   BEGIN
      IF A_INPUT_STRING IS NULL
      THEN
         A_ENCRYPTED_DATA := NULL;
         RETURN( CXSAPILK.DBERR_SUCCESS );
      END IF;

      
      
      L_NEW_LENGTH :=   (   TRUNC(   LENGTHB( A_INPUT_STRING )
                                   / 8 )
                          + 1 )
                      * 8;
      SYS.DBMS_OBFUSCATION_TOOLKIT.DES3ENCRYPT
                                              
                                              
                                              
                                              
                                              
                                              
                                              
                                              
                                              
                                              
      (                                         INPUT => UTL_RAW.CAST_TO_RAW( SUBSTRB( RPAD( A_INPUT_STRING,
                                                                                             L_NEW_LENGTH,
                                                                                             CHR( 0 ) ),
                                                                                       1,
                                                                                       L_NEW_LENGTH ) ),
                                                KEY => P_DYNAMIC_ENCRYPTION_KEY,
                                                ENCRYPTED_DATA => A_ENCRYPTED_DATA,
                                                WHICH => '1' );



      RETURN( CXSAPILK.DBERR_SUCCESS );
   
   END DYNAMICENCRYPT;



   FUNCTION DYNAMICDECRYPT   
                          (
      A_INPUT_RAW                IN       RAW,
      A_DECRYPTED_DATA           OUT      VARCHAR2 )
      RETURN NUMBER
   IS
      L_DECRYPTED_RAW               RAW( 255 );
   BEGIN

      IF A_INPUT_RAW IS NULL
      THEN
         A_DECRYPTED_DATA := NULL;
         RETURN( CXSAPILK.DBERR_SUCCESS );
      END IF;

      SYS.DBMS_OBFUSCATION_TOOLKIT.DES3DECRYPT( INPUT => A_INPUT_RAW,
                                                KEY => P_DYNAMIC_ENCRYPTION_KEY,
                                                DECRYPTED_DATA => L_DECRYPTED_RAW,
                                                WHICH => '1' );


      
      A_DECRYPTED_DATA := RTRIM( UTL_RAW.CAST_TO_VARCHAR2( L_DECRYPTED_RAW ),
                                 CHR( 0 ) );

      RETURN( CXSAPILK.DBERR_SUCCESS );
   
   END DYNAMICDECRYPT;



   


   FUNCTION GRANTORFREELICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_CUSTOM_PARAM         IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_GRANT_OR_FREE_LICENSE    IN       VARCHAR2,   
      A_ERROR_CODE               OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_LIC_CHECK_OK_4_APP          CXSAPILK.NUM_TABLE_TYPE;
      L_MAX_USERS_4_APP             CXSAPILK.NUM_TABLE_TYPE;
      L_ERROR_MESSAGE               VARCHAR2( 255 );
      L_SQLERRM                     VARCHAR2( 255 );
      L_USER_SID_ENCRYPTED          RAW( 80 );
      L_USER_NAME_ENCRYPTED         RAW( 160 );
      L_APP_ID_ENCRYPTED            RAW( 32 );
      L_APP_VERSION_ENCRYPTED       RAW( 32 );
      L_APP_CUSTOM_PARAM_ENCRYPTED  RAW( 32 );
      L_LIC_CHECK_APPLIES_ENCRYPTED RAW( 8 );
      L_LOGON_DATE_ENCRYPTED        RAW( 24 );
      L_LAST_HEARTBEAT_ENCRYPTED    RAW( 24 );
      L_LOGOFF_DATE_ENCRYPTED       RAW( 24 );
      L_LOGON_STATION_ENCRYPTED     RAW( 160 );
      L_AUDSID_ENCRYPTED            RAW( 40 );
      L_USER_SID_RETURNED           RAW( 80 );
      L_USER_NAME_RETURNED          RAW( 160 );
      L_APP_ID_RETURNED             RAW( 32 );
      L_APP_VERSION_RETURNED        RAW( 32 );
      L_APP_CUSTOM_PARAM_RETURNED   RAW( 32 );
      L_LIC_CHECK_APPLIES_RETURNED  RAW( 8 );
      L_LOGON_DATE_RETURNED         RAW( 24 );
      L_LAST_HEARTBEAT_RETURNED     RAW( 24 );
      L_LOGOFF_DATE_RETURNED        RAW( 24 );
      L_LOGON_STATION_RETURNED      RAW( 160 );
      L_AUDSID_RETURNED             RAW( 40 );
      L_ROWID                       ROWID;
      L_RAW_1              CONSTANT RAW( 4 ) := UTL_RAW.CAST_TO_RAW( '1' );
      L_RAW_2              CONSTANT RAW( 4 ) := UTL_RAW.CAST_TO_RAW( '2' );
      L_RAW_3              CONSTANT RAW( 4 ) := UTL_RAW.CAST_TO_RAW( '3' );
      L_LAST_IDX                    INTEGER;
      L_COUNT_USERS4APP             INTEGER;
      L_CONTINUE_PROCESSING         BOOLEAN;
      L_FOUND_IDX                   INTEGER;
      L_AUDSID_TAB                  CORAWLIST := CORAWLIST( );
      L_RET_CODE_CHECK_LICENSE      INTEGER;
      L_FATAL_ERROR                 INTEGER;
      L_COUNT_USERSALREADYCONNECTED INTEGER;
   BEGIN

      L_FATAL_ERROR := CXSAPILK.DBERR_SUCCESS;

      
      IF NVL( A_NR_OF_ROWS,
              0 ) <= 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                     A_GRANT_OR_FREE_LICENSE
                                  || 'License may not be called with a_nr_of_rows<=0' );
      END IF;

      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         IF A_APP_ID( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        A_GRANT_OR_FREE_LICENSE
                                     || 'License may not be called with an a_app_id that is NULL' );
         END IF;

         IF A_APP_VERSION( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        A_GRANT_OR_FREE_LICENSE
                                     || 'License may not be called with an a_app_version that is NULL' );
         END IF;

         IF A_LOGON_STATION( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        A_GRANT_OR_FREE_LICENSE
                                     || 'License may not be called with an a_logon_station that is NULL' );
         END IF;

         IF A_USER_SID( L_ROW ) IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        A_GRANT_OR_FREE_LICENSE
                                     || 'License may not be called with an a_user_sid that is NULL' );
         END IF;

         IF NVL( A_GRANT_OR_FREE_LICENSE,
                 ' ' ) NOT IN( 'Grant', 'Free', 'Ping' )
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                        'Internal Function GrantOrFreeLicense called with an invalid value for a_grant_or_free_license:'
                                     || A_GRANT_OR_FREE_LICENSE );
         END IF;
      END LOOP;



      
      IF L_AUDSID_FOR_CURRENT_SESSION IS NULL
      THEN
         SELECT SYS.STANDARD.USERENV( 'SESSIONID' )
           INTO L_AUDSID_FOR_CURRENT_SESSION
           FROM DUAL;
      END IF;



      

      
      L_RET_CODE_CHECK_LICENSE :=
                  CXSAPILK.CHECKLICENSE( A_APP_ID,
                                         A_APP_VERSION,
                                         A_APP_CUSTOM_PARAM,
                                         A_ERROR_CODE,
                                         L_MAX_USERS_4_APP,
                                         A_NR_OF_ROWS,
                                         L_ERROR_MESSAGE );



      
      
      
      
      IF L_RET_CODE_CHECK_LICENSE IN( CXSAPILK.DBERR_SUCCESS, CXSAPILK.DBERR_OK_NO_ALM )
      THEN

      
         IF NVL( A_GRANT_OR_FREE_LICENSE,
                 ' ' ) IN( 'Grant', 'Free' )
         THEN
            
            FOR L_REC IN ( SELECT *
                            FROM V$SESSION
                           WHERE TYPE <> 'BACKGROUND' )
            LOOP
               L_RET_CODE := DYNAMICENCRYPT( L_REC.AUDSID,
                                             L_AUDSID_ENCRYPTED );
               L_AUDSID_TAB.EXTEND( );
               L_AUDSID_TAB( L_AUDSID_TAB.COUNT( ) ) := L_AUDSID_ENCRYPTED;
            END LOOP;

            DELETE FROM CTLICUSERCNT
                  WHERE AUDSID NOT IN( SELECT *
                                        FROM TABLE( CAST( L_AUDSID_TAB AS CORAWLIST ) ) );
         END IF;


         FOR L_ROW IN 1 .. A_NR_OF_ROWS
         LOOP
            IF A_ERROR_CODE( L_ROW ) IN( CXSAPILK.DBERR_SUCCESS, CXSAPILK.DBERR_OK_NO_ALM )
            THEN
               
               L_RET_CODE := DYNAMICENCRYPT( A_USER_SID( L_ROW ),
                                             L_USER_SID_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( A_USER_NAME( L_ROW ),
                                             L_USER_NAME_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( A_APP_ID( L_ROW ),
                                             L_APP_ID_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( A_APP_VERSION( L_ROW ),
                                             L_APP_VERSION_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( A_APP_CUSTOM_PARAM( L_ROW ),
                                             L_APP_CUSTOM_PARAM_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( '1',
                                             L_LIC_CHECK_APPLIES_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( TO_CHAR( SYSDATE,
                                                      'DD-MM-YY HH24:MI:SS' ),
                                             L_LOGON_DATE_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( TO_CHAR( SYSDATE,
                                                      'DD-MM-YY HH24:MI:SS' ),
                                             L_LAST_HEARTBEAT_ENCRYPTED );
               L_RET_CODE := NULL;   
               L_RET_CODE := DYNAMICENCRYPT( A_LOGON_STATION( L_ROW ),
                                             L_LOGON_STATION_ENCRYPTED );
               L_RET_CODE := DYNAMICENCRYPT( L_AUDSID_FOR_CURRENT_SESSION,
                                             L_AUDSID_ENCRYPTED );

               IF A_GRANT_OR_FREE_LICENSE = 'Free'
               THEN
                  L_CONTINUE_PROCESSING := TRUE;

                  
                  DELETE FROM CTLICUSERCNT
                        WHERE USER_SID = L_USER_SID_ENCRYPTED
                          AND APP_ID = L_APP_ID_ENCRYPTED
                          AND LOGON_STATION = L_LOGON_STATION_ENCRYPTED
                          AND AUDSID = L_AUDSID_ENCRYPTED
                    RETURNING USER_SID,
                              USER_NAME,
                              APP_ID,
                              APP_VERSION,
                              APP_CUSTOM_PARAM,
                              LIC_CHECK_APPLIES,
                              LOGON_DATE,
                              LAST_HEARTBEAT,
                              LOGOFF_DATE,
                              LOGON_STATION,
                              AUDSID,
                              ROWID
                         INTO L_USER_SID_RETURNED,
                              L_USER_NAME_RETURNED,
                              L_APP_ID_RETURNED,
                              L_APP_VERSION_RETURNED,
                              L_APP_CUSTOM_PARAM_RETURNED,
                              L_LIC_CHECK_APPLIES_RETURNED,
                              L_LOGON_DATE_RETURNED,
                              L_LAST_HEARTBEAT_RETURNED,
                              L_LOGOFF_DATE_RETURNED,
                              L_LOGON_STATION_RETURNED,
                              L_AUDSID_RETURNED,
                              L_ROWID;

                  IF SQL%ROWCOUNT = 0
                  THEN
                     
                     L_SQLERRM := 'Heartbeat record not found';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  END IF;

                  
                  L_FOUND_IDX := 0;

                  FOR L_CACHE_ROW IN 1 .. L_CTLICUSERCNT_OLDREC_TAB.LAST( )
                  LOOP
                     IF L_CTLICUSERCNT_OLDREC_TAB.EXISTS( L_CACHE_ROW )
                     THEN
                        IF     L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).USER_SID = L_USER_SID_ENCRYPTED
                           AND L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).APP_ID = L_APP_ID_ENCRYPTED
                           AND L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).LOGON_STATION = L_LOGON_STATION_ENCRYPTED
                           AND L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).AUDSID = L_AUDSID_ENCRYPTED
                        THEN
                           L_FOUND_IDX := L_CACHE_ROW;
                           EXIT;
                        END IF;
                     END IF;
                  END LOOP;

                  IF L_FOUND_IDX = 0
                  THEN
                     L_SQLERRM := 'FreeLicense called in a session where GrantLicense didn''t take place!';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  END IF;

                  
                  IF L_CONTINUE_PROCESSING
                  THEN
                     
                     IF NVL( L_USER_SID_ENCRYPTED,
                             L_RAW_1 ) <> NVL( L_USER_SID_RETURNED,
                                               L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.1)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_USER_NAME_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_USER_NAME_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.2)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_ID_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_ID_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.3)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_VERSION_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_VERSION_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.4)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_LIC_CHECK_APPLIES_ENCRYPTED,
                                L_RAW_2 ) <> NVL( L_LIC_CHECK_APPLIES_RETURNED,
                                                  L_RAW_3 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.5)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     ELSIF NVL( L_LOGON_STATION_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_LOGON_STATION_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.9)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_AUDSID_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_AUDSID_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.10)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_CUSTOM_PARAM_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_CUSTOM_PARAM_RETURNED,
                                                  L_RAW_1 )
                     THEN   
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (1.11)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     END IF;
                  END IF;

                  
                  L_CTLICUSERCNT_OLDREC_TAB.DELETE( L_FOUND_IDX );
               ELSIF A_GRANT_OR_FREE_LICENSE = 'Ping'
               THEN
                  L_CONTINUE_PROCESSING := TRUE;

                  OPEN L_CTLICUSERCNT_CURSOR( L_USER_SID_ENCRYPTED,
                                              L_APP_ID_ENCRYPTED,
                                              L_LOGON_STATION_ENCRYPTED,
                                              L_AUDSID_ENCRYPTED );

                  FETCH L_CTLICUSERCNT_CURSOR
                   INTO L_CTLICUSERCNT_NEWREC;

                  IF L_CTLICUSERCNT_CURSOR%NOTFOUND
                  THEN
                     
                     CLOSE L_CTLICUSERCNT_CURSOR;

                     L_SQLERRM := 'Heartbeat record not found';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  END IF;

                  CLOSE L_CTLICUSERCNT_CURSOR;

                  
                  L_FOUND_IDX := 0;



                  FOR L_CACHE_ROW IN 1 .. L_CTLICUSERCNT_OLDREC_TAB.LAST( )
                  LOOP
                     IF L_CTLICUSERCNT_OLDREC_TAB.EXISTS( L_CACHE_ROW )
                     THEN
                        IF     L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).USER_SID = L_USER_SID_ENCRYPTED
                           AND L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).APP_ID = L_APP_ID_ENCRYPTED
                           AND L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).LOGON_STATION = L_LOGON_STATION_ENCRYPTED
                           AND L_CTLICUSERCNT_OLDREC_TAB( L_CACHE_ROW ).AUDSID = L_AUDSID_ENCRYPTED
                        THEN
                           L_FOUND_IDX := L_CACHE_ROW;
                           EXIT;
                        END IF;
                     END IF;
                  END LOOP;


                  IF L_FOUND_IDX = 0
                  THEN
                     L_SQLERRM := 'PingLicense called in a session where GrantLicense didn''t take place!';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  END IF;

                  
                  IF NVL( L_USER_NAME_ENCRYPTED,
                          L_RAW_1 ) <> NVL( L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).USER_NAME,
                                            L_RAW_2 )
                  THEN
                     L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.20)';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  ELSIF NVL( L_APP_VERSION_ENCRYPTED,
                             L_RAW_1 ) <> NVL( L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).APP_VERSION,
                                               L_RAW_2 )
                  THEN
                     L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.21)';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  ELSIF NVL( L_APP_CUSTOM_PARAM_ENCRYPTED,
                             L_RAW_1 ) <> NVL( L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).APP_CUSTOM_PARAM,
                                               L_RAW_1 )
                  THEN   
                     L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.22b)';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  ELSIF NVL( L_LIC_CHECK_APPLIES_ENCRYPTED,
                             L_RAW_2 ) <> NVL( L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).LIC_CHECK_APPLIES,
                                               L_RAW_3 )
                  THEN
                     L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.22)';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  END IF;

                  UPDATE    CTLICUSERCNT
                        SET LAST_HEARTBEAT = L_LAST_HEARTBEAT_ENCRYPTED
                      WHERE USER_SID = L_USER_SID_ENCRYPTED
                        AND APP_ID = L_APP_ID_ENCRYPTED
                        AND LOGON_STATION = L_LOGON_STATION_ENCRYPTED
                        AND AUDSID = L_AUDSID_ENCRYPTED
                  RETURNING USER_SID,
                            USER_NAME,
                            APP_ID,
                            APP_VERSION,
                            APP_CUSTOM_PARAM,
                            LIC_CHECK_APPLIES,
                            LOGON_DATE,
                            LAST_HEARTBEAT,
                            LOGOFF_DATE,
                            LOGON_STATION,
                            AUDSID,
                            ROWID
                       INTO L_USER_SID_RETURNED,
                            L_USER_NAME_RETURNED,
                            L_APP_ID_RETURNED,
                            L_APP_VERSION_RETURNED,
                            L_APP_CUSTOM_PARAM_RETURNED,
                            L_LIC_CHECK_APPLIES_RETURNED,
                            L_LOGON_DATE_RETURNED,
                            L_LAST_HEARTBEAT_RETURNED,
                            L_LOGOFF_DATE_RETURNED,
                            L_LOGON_STATION_RETURNED,
                            L_AUDSID_RETURNED,
                            L_ROWID;

                  IF SQL%ROWCOUNT = 0
                  THEN
                     
                     L_SQLERRM := 'Heartbeat record not found';
                     RAISE_APPLICATION_ERROR( -20000,
                                              L_SQLERRM );
                  END IF;

                  
                  IF L_CONTINUE_PROCESSING
                  THEN
                     
                     IF NVL( L_USER_SID_ENCRYPTED,
                             L_RAW_1 ) <> NVL( L_USER_SID_RETURNED,
                                               L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.1)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_USER_NAME_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_USER_NAME_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.2)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_ID_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_ID_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.3)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_VERSION_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_VERSION_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.4)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_CUSTOM_PARAM_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_CUSTOM_PARAM_RETURNED,
                                                  L_RAW_1 )
                     THEN   
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.4b)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_LIC_CHECK_APPLIES_ENCRYPTED,
                                L_RAW_2 ) <> NVL( L_LIC_CHECK_APPLIES_RETURNED,
                                                  L_RAW_3 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.5)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     
                     
                     
                     ELSIF NVL( L_LAST_HEARTBEAT_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_LAST_HEARTBEAT_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.7)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     
                     
                     
                     ELSIF NVL( L_LOGON_STATION_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_LOGON_STATION_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.9)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_AUDSID_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_AUDSID_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (2.10)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     END IF;
                  END IF;

                  IF L_CONTINUE_PROCESSING
                  THEN
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).USER_SID := L_USER_SID_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).USER_NAME := L_USER_NAME_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).APP_ID := L_APP_ID_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).APP_VERSION := L_APP_VERSION_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).APP_CUSTOM_PARAM := L_APP_CUSTOM_PARAM_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).LIC_CHECK_APPLIES := L_LIC_CHECK_APPLIES_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).LOGON_DATE := L_LOGON_DATE_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).LAST_HEARTBEAT := L_LAST_HEARTBEAT_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).LOGOFF_DATE := L_LOGOFF_DATE_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).LOGON_STATION := L_LOGON_STATION_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).AUDSID := L_AUDSID_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_FOUND_IDX ).INTERNAL_ROWID := L_ROWID;
                  END IF;
               ELSIF A_GRANT_OR_FREE_LICENSE = 'Grant'
               THEN

                  L_CONTINUE_PROCESSING := TRUE;

                  
                  
                  
                  

                  
                  SELECT COUNT( * )
                    INTO L_COUNT_USERSALREADYCONNECTED
                    FROM CTLICUSERCNT
                   WHERE APP_ID = L_APP_ID_ENCRYPTED
                     AND APP_VERSION = L_APP_VERSION_ENCRYPTED
                     AND LOGON_STATION = L_LOGON_STATION_ENCRYPTED
                     AND USER_SID = L_USER_SID_ENCRYPTED;

                  IF L_COUNT_USERSALREADYCONNECTED = 0
                  THEN
                     SELECT COUNT( DISTINCT USER_SID
                                    || LOGON_STATION )
                       INTO L_COUNT_USERS4APP
                       FROM CTLICUSERCNT
                      WHERE APP_ID = L_APP_ID_ENCRYPTED
                        AND APP_VERSION = L_APP_VERSION_ENCRYPTED
                        AND NVL( APP_CUSTOM_PARAM,
                                 L_RAW_1 ) = NVL( L_APP_CUSTOM_PARAM_ENCRYPTED,
                                                  L_RAW_1 );

                     IF L_COUNT_USERS4APP >= NVL( L_MAX_USERS_4_APP( L_ROW ),
                                                  0 )
                     THEN
                        A_ERROR_CODE( L_ROW ) := CXSAPILK.DBERR_TOOMANYUSERS4ALM;
                        L_FATAL_ERROR := CXSAPILK.DBERR_TOOMANYUSERS4ALM;
                        L_CONTINUE_PROCESSING := FALSE;
                     END IF;
                  END IF;

                  IF L_CONTINUE_PROCESSING
                  THEN
                     
                        
                     INSERT INTO CTLICUSERCNT
                                 ( USER_SID,
                                   USER_NAME,
                                   APP_ID,
                                   APP_VERSION,
                                   APP_CUSTOM_PARAM,
                                   LIC_CHECK_APPLIES,
                                   LOGON_DATE,
                                   LAST_HEARTBEAT,
                                   LOGOFF_DATE,
                                   LOGON_STATION,
                                   AUDSID )
                          VALUES ( L_USER_SID_ENCRYPTED,
                                   L_USER_NAME_ENCRYPTED,
                                   L_APP_ID_ENCRYPTED,
                                   L_APP_VERSION_ENCRYPTED,
                                   L_APP_CUSTOM_PARAM_ENCRYPTED,
                                   L_LIC_CHECK_APPLIES_ENCRYPTED,
                                   L_LOGON_DATE_ENCRYPTED,
                                   L_LAST_HEARTBEAT_ENCRYPTED,
                                   L_LOGOFF_DATE_ENCRYPTED,
                                   L_LOGON_STATION_ENCRYPTED,
                                   L_AUDSID_ENCRYPTED )
                       RETURNING USER_SID,
                                 USER_NAME,
                                 APP_ID,
                                 APP_VERSION,
                                 APP_CUSTOM_PARAM,
                                 LIC_CHECK_APPLIES,
                                 LOGON_DATE,
                                 LAST_HEARTBEAT,
                                 LOGOFF_DATE,
                                 LOGON_STATION,
                                 AUDSID,
                                 ROWID
                            INTO L_USER_SID_RETURNED,
                                 L_USER_NAME_RETURNED,
                                 L_APP_ID_RETURNED,
                                 L_APP_VERSION_RETURNED,
                                 L_APP_CUSTOM_PARAM_RETURNED,
                                 L_LIC_CHECK_APPLIES_RETURNED,
                                 L_LOGON_DATE_RETURNED,
                                 L_LAST_HEARTBEAT_RETURNED,
                                 L_LOGOFF_DATE_RETURNED,
                                 L_LOGON_STATION_RETURNED,
                                 L_AUDSID_RETURNED,
                                 L_ROWID;
                  
                  
                  
                  
                  END IF;

                  IF L_CONTINUE_PROCESSING
                  THEN
                     
                     IF NVL( L_USER_SID_ENCRYPTED,
                             L_RAW_1 ) <> NVL( L_USER_SID_RETURNED,
                                               L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.1)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_USER_NAME_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_USER_NAME_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.2)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_ID_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_ID_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.3)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_VERSION_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_VERSION_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.4)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_APP_CUSTOM_PARAM_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_APP_CUSTOM_PARAM_RETURNED,
                                                  L_RAW_1 )
                     THEN   
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.4b)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_LIC_CHECK_APPLIES_ENCRYPTED,
                                L_RAW_2 ) <> NVL( L_LIC_CHECK_APPLIES_RETURNED,
                                                  L_RAW_3 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.5)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_LOGON_DATE_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_LOGON_DATE_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.6)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_LAST_HEARTBEAT_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_LAST_HEARTBEAT_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.7)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     
                     
                     
                     ELSIF NVL( L_LOGON_STATION_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_LOGON_STATION_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.9)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     ELSIF NVL( L_AUDSID_ENCRYPTED,
                                L_RAW_1 ) <> NVL( L_AUDSID_RETURNED,
                                                  L_RAW_2 )
                     THEN
                        L_SQLERRM := 'Data mutation detected on table CTLICUSERCNT! (3.10)';
                        RAISE_APPLICATION_ERROR( -20000,
                                                 L_SQLERRM );
                     END IF;
                  END IF;

                  IF L_CONTINUE_PROCESSING
                  THEN
                     L_CTLICUSERCNT_OLDREC_TAB.EXTEND( );
                     L_LAST_IDX := L_CTLICUSERCNT_OLDREC_TAB.LAST( );
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).USER_SID := L_USER_SID_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).USER_NAME := L_USER_NAME_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).APP_ID := L_APP_ID_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).APP_VERSION := L_APP_VERSION_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).APP_CUSTOM_PARAM := L_APP_CUSTOM_PARAM_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).LIC_CHECK_APPLIES := L_LIC_CHECK_APPLIES_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).LOGON_DATE := L_LOGON_DATE_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).LAST_HEARTBEAT := L_LAST_HEARTBEAT_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).LOGOFF_DATE := L_LOGOFF_DATE_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).LOGON_STATION := L_LOGON_STATION_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).AUDSID := L_AUDSID_ENCRYPTED;
                     L_CTLICUSERCNT_OLDREC_TAB( L_LAST_IDX ).INTERNAL_ROWID := L_ROWID;
                  END IF;

               END IF;
            END IF;
         END LOOP;
      END IF;

      IF L_FATAL_ERROR = CXSAPILK.DBERR_SUCCESS
      THEN
         RETURN( L_RET_CODE_CHECK_LICENSE );
      ELSE
         RETURN( L_FATAL_ERROR );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IF L_CTLICUSERCNT_CURSOR%ISOPEN
         THEN
            CLOSE L_CTLICUSERCNT_CURSOR;
         END IF;

         RAISE;
   END GRANTORFREELICENSE;

   FUNCTION GRANTLICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_CODE               OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_APP_CUSTOM_PARAM            CXSAPILK.VC20_TABLE_TYPE;
   BEGIN
      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         L_APP_CUSTOM_PARAM( L_ROW ) := NULL;
      END LOOP;

      RETURN( GRANTORFREELICENSE( A_APP_ID,
                                  A_APP_VERSION,
                                  L_APP_CUSTOM_PARAM,
                                  A_LOGON_STATION,
                                  A_USER_SID,
                                  A_USER_NAME,
                                  A_NR_OF_ROWS,
                                  'Grant',
                                  A_ERROR_CODE,
                                  A_ERROR_MESSAGE ) );
   END GRANTLICENSE;

   FUNCTION GRANTLICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_CUSTOM_PARAM         IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_CODE               OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
   BEGIN
      RETURN( GRANTORFREELICENSE( A_APP_ID,
                                  A_APP_VERSION,
                                  A_APP_CUSTOM_PARAM,
                                  A_LOGON_STATION,
                                  A_USER_SID,
                                  A_USER_NAME,
                                  A_NR_OF_ROWS,
                                  'Grant',
                                  A_ERROR_CODE,
                                  A_ERROR_MESSAGE ) );
   END GRANTLICENSE;

   FUNCTION PINGLICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_CODE               OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_APP_CUSTOM_PARAM            CXSAPILK.VC20_TABLE_TYPE;
   BEGIN
      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         L_APP_CUSTOM_PARAM( L_ROW ) := NULL;
      END LOOP;

      RETURN( GRANTORFREELICENSE( A_APP_ID,
                                  A_APP_VERSION,
                                  L_APP_CUSTOM_PARAM,
                                  A_LOGON_STATION,
                                  A_USER_SID,
                                  A_USER_NAME,
                                  A_NR_OF_ROWS,
                                  'Ping',
                                  A_ERROR_CODE,
                                  A_ERROR_MESSAGE ) );
   END PINGLICENSE;

   FUNCTION PINGLICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_CUSTOM_PARAM         IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_CODE               OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
   BEGIN
      RETURN( GRANTORFREELICENSE( A_APP_ID,
                                  A_APP_VERSION,
                                  A_APP_CUSTOM_PARAM,
                                  A_LOGON_STATION,
                                  A_USER_SID,
                                  A_USER_NAME,
                                  A_NR_OF_ROWS,
                                  'Ping',
                                  A_ERROR_CODE,
                                  A_ERROR_MESSAGE ) );
   END PINGLICENSE;

   FUNCTION FREELICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_CODE               OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_APP_CUSTOM_PARAM            CXSAPILK.VC20_TABLE_TYPE;
   BEGIN
      FOR L_ROW IN 1 .. A_NR_OF_ROWS
      LOOP
         L_APP_CUSTOM_PARAM( L_ROW ) := NULL;
      END LOOP;

      RETURN( GRANTORFREELICENSE( A_APP_ID,
                                  A_APP_VERSION,
                                  L_APP_CUSTOM_PARAM,
                                  A_LOGON_STATION,
                                  A_USER_SID,
                                  A_USER_NAME,
                                  A_NR_OF_ROWS,
                                  'Free',
                                  A_ERROR_CODE,
                                  A_ERROR_MESSAGE ) );
   END FREELICENSE;

   FUNCTION FREELICENSE(
      A_APP_ID                   IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_CUSTOM_PARAM         IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            IN       CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                IN       CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN       NUMBER,   
      A_ERROR_CODE               OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
   BEGIN
      RETURN( GRANTORFREELICENSE( A_APP_ID,
                                  A_APP_VERSION,
                                  A_APP_CUSTOM_PARAM,
                                  A_LOGON_STATION,
                                  A_USER_SID,
                                  A_USER_NAME,
                                  A_NR_OF_ROWS,
                                  'Free',
                                  A_ERROR_CODE,
                                  A_ERROR_MESSAGE ) );
   END FREELICENSE;

   FUNCTION GETACTUALLICENSEUSAGE(
      A_APP_ID                   OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_LOGON_DATE               OUT      CXSAPILK.DATE_TABLE_TYPE,   
      A_LAST_HEARTBEAT           OUT      CXSAPILK.DATE_TABLE_TYPE,   
      A_LIC_CONSUMED             OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_EXECUTABLE               OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_NR_OF_ROWS               IN OUT   NUMBER,   
      A_SEARCH_CRITERIA          IN       VARCHAR2,   
      A_SEARCH_ID                IN       VARCHAR2,   
      A_NEXT_ROWS                IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_LIC_CONSUMED_SERIAL_ID      CXSAPILK.VC40_TABLE_TYPE;
      L_LIC_CONSUMED_SHORTNAME      CXSAPILK.VC40_TABLE_TYPE;
      L_APP_CUSTOM_PARAM            CXSAPILK.VC20_TABLE_TYPE;
   BEGIN
      RETURN( GETACTUALLICENSEUSAGE( A_APP_ID,
                                     A_APP_VERSION,
                                     L_APP_CUSTOM_PARAM,
                                     A_LOGON_STATION,
                                     A_USER_SID,
                                     A_USER_NAME,
                                     A_LOGON_DATE,
                                     A_LAST_HEARTBEAT,
                                     A_LIC_CONSUMED,
                                     A_EXECUTABLE,
                                     L_LIC_CONSUMED_SERIAL_ID,
                                     L_LIC_CONSUMED_SHORTNAME,
                                     A_NR_OF_ROWS,
                                     A_SEARCH_CRITERIA,
                                     A_SEARCH_ID,
                                     A_NEXT_ROWS,
                                     A_ERROR_MESSAGE ) );
   END GETACTUALLICENSEUSAGE;

   FUNCTION GETACTUALLICENSEUSAGE(
      A_APP_ID                   OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_LOGON_DATE               OUT      CXSAPILK.DATE_TABLE_TYPE,   
      A_LAST_HEARTBEAT           OUT      CXSAPILK.DATE_TABLE_TYPE,   
      A_LIC_CONSUMED             OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_EXECUTABLE               OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_LIC_CONSUMED_SERIAL_ID   OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_LIC_CONSUMED_SHORTNAME   OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_NR_OF_ROWS               IN OUT   NUMBER,   
      A_SEARCH_CRITERIA          IN       VARCHAR2,   
      A_SEARCH_ID                IN       VARCHAR2,   
      A_NEXT_ROWS                IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_APP_CUSTOM_PARAM            CXSAPILK.VC20_TABLE_TYPE;
   BEGIN
      RETURN( GETACTUALLICENSEUSAGE( A_APP_ID,
                                     A_APP_VERSION,
                                     L_APP_CUSTOM_PARAM,
                                     A_LOGON_STATION,
                                     A_USER_SID,
                                     A_USER_NAME,
                                     A_LOGON_DATE,
                                     A_LAST_HEARTBEAT,
                                     A_LIC_CONSUMED,
                                     A_EXECUTABLE,
                                     A_LIC_CONSUMED_SERIAL_ID,
                                     A_LIC_CONSUMED_SHORTNAME,
                                     A_NR_OF_ROWS,
                                     A_SEARCH_CRITERIA,
                                     A_SEARCH_ID,
                                     A_NEXT_ROWS,
                                     A_ERROR_MESSAGE ) );
   END GETACTUALLICENSEUSAGE;

   FUNCTION GETACTUALLICENSEUSAGE(
      A_APP_ID                   OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_VERSION              OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_APP_CUSTOM_PARAM         OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_LOGON_STATION            OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_USER_SID                 OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_USER_NAME                OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_LOGON_DATE               OUT      CXSAPILK.DATE_TABLE_TYPE,   
      A_LAST_HEARTBEAT           OUT      CXSAPILK.DATE_TABLE_TYPE,   
      A_LIC_CONSUMED             OUT      CXSAPILK.NUM_TABLE_TYPE,   
      A_EXECUTABLE               OUT      CXSAPILK.VC20_TABLE_TYPE,   
      A_LIC_CONSUMED_SERIAL_ID   OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_LIC_CONSUMED_SHORTNAME   OUT      CXSAPILK.VC40_TABLE_TYPE,   
      A_NR_OF_ROWS               IN OUT   NUMBER,   
      A_SEARCH_CRITERIA          IN       VARCHAR2,   
      A_SEARCH_ID                IN       VARCHAR2,   
      A_NEXT_ROWS                IN       NUMBER,   
      A_ERROR_MESSAGE            OUT      VARCHAR2 )   
      RETURN NUMBER
   IS
      L_WHERE_CLAUSE                VARCHAR2( 255 );
      L_RESULT                      INTEGER;
      L_SQL_STRING                  VARCHAR2( 255 );
      L_FETCHED_ROWS                INTEGER;
      L_SEARCH_ID_ENCRYPTED         RAW( 160 );
      L_BIND_NECESSARY              BOOLEAN;
      L_SQLERRM                     VARCHAR2( 255 );

      L_APP_ID                      RAW( 32 );
      L_APP_VERSION                 RAW( 32 );
      L_APP_CUSTOM_PARAM            RAW( 32 );
      L_LOGON_STATION               RAW( 160 );
      L_USER_SID                    RAW( 80 );
      L_USER_NAME                   RAW( 160 );
      L_LOGON_DATE                  RAW( 24 );
      L_LAST_HEARTBEAT              RAW( 24 );
      L_AUDSID                      RAW( 40 );
      L_AUDSID_DECRYPTED            NUMBER;
      L_LOGON_DATE_DECRYPTED        VARCHAR2( 40 );
      L_LAST_HEARTBEAT_DECRYPTED    VARCHAR2( 40 );
      L_APP_ID_TAB                  CXSAPILK.VC20_TABLE_TYPE;
      L_APP_VERSION_TAB             CXSAPILK.VC20_TABLE_TYPE;
      L_APP_CUSTOM_PARAM_TAB        CXSAPILK.VC20_TABLE_TYPE;
      L_LIC_CHECK_OK_4_APP_TAB      CXSAPILK.NUM_TABLE_TYPE;
      L_MAX_USERS_4_APP_TAB         CXSAPILK.NUM_TABLE_TYPE;
      L_CONSUMER_COUNT_TAB          INTEGER;
      L_LIC_CHECK_NR_OF_ROWS        INTEGER;
      L_LIC_CHECK_ERROR_MESSAGE     VARCHAR2( 255 );
      L_LIC_CHECK_RET_CODE          INTEGER;
   BEGIN
      IF NVL( A_NR_OF_ROWS,
              0 ) = 0
      THEN
         A_NR_OF_ROWS := CXSAPILK.P_DEFAULT_CHUNK_SIZE;
      ELSIF    A_NR_OF_ROWS < 0
            OR A_NR_OF_ROWS > CXSAPILK.P_MAX_CHUNK_SIZE
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'GetActualLicenseUsage called with a_nr_of_rows too high or negative' );
      END IF;

      IF NVL( A_NEXT_ROWS,
              0 ) NOT IN( -1, 0, 1 )
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'GetActualLicenseUsage called with invalid value for a_next_rows' );
      END IF;

      
      IF A_NEXT_ROWS = -1
      THEN
         IF P_GETLICENSEUSAGE_CURSOR IS NOT NULL
         THEN
            DBMS_SQL.CLOSE_CURSOR( P_GETLICENSEUSAGE_CURSOR );
            P_GETLICENSEUSAGE_CURSOR := NULL;
         END IF;

         A_NR_OF_ROWS := 0;
         RETURN( CXSAPILK.DBERR_SUCCESS );
      END IF;

      
      IF A_NEXT_ROWS = 1
      THEN
         IF P_GETLICENSEUSAGE_CURSOR IS NULL
         THEN
            RAISE_APPLICATION_ERROR( -20000,
                                     'GetActualLicenseUsage called with a_next_rows=1 but no cusrsor open' );
         END IF;
      END IF;

      
      IF NVL( A_NEXT_ROWS,
              0 ) = 0
      THEN
         P_LAST_STRING4LICENSE := ' ';   
         P_LAST_STRING4APP := ' ';
         P_LICENSE_USAGE := 0;
         L_BIND_NECESSARY := FALSE;

         IF NVL( A_SEARCH_CRITERIA,
                 ' ' ) = ' '
         THEN
            L_WHERE_CLAUSE := 'ORDER BY a.app_id, a.app_version, a.app_custom_param, a.user_sid, a.logon_station';   
         ELSIF A_SEARCH_CRITERIA = 'logon_station'
         THEN
            L_RET_CODE := DYNAMICENCRYPT( A_SEARCH_ID,
                                          L_SEARCH_ID_ENCRYPTED );
            L_WHERE_CLAUSE :=
                  'WHERE logon_station = :a_search_id '
               ||   
                  'ORDER BY a.app_id, a.app_version, a.app_custom_param, a.user_sid, a.logon_station';   
            L_BIND_NECESSARY := TRUE;
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                     'GetActualLicenseUsage: Invalid value for search_criteria' );
         END IF;

         L_SQL_STRING :=
               'SELECT a.app_id, a.app_version, a.app_custom_param, a.logon_station, a.user_sid, a.user_name, '
            || 'a.logon_date, a.last_heartbeat, a.audsid '
            || 'FROM ctlicusercnt a '
            || L_WHERE_CLAUSE;

         IF P_GETLICENSEUSAGE_CURSOR IS NULL
         THEN
            P_GETLICENSEUSAGE_CURSOR := DBMS_SQL.OPEN_CURSOR;
         END IF;

         DBMS_SQL.PARSE( P_GETLICENSEUSAGE_CURSOR,
                         L_SQL_STRING,
                         DBMS_SQL.V7 );   

         IF L_BIND_NECESSARY
         THEN
            DBMS_SQL.BIND_VARIABLE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                        ':a_search_id',
                                        L_SEARCH_ID_ENCRYPTED );
         END IF;

         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     1,
                                     L_APP_ID,
                                     32 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     2,
                                     L_APP_VERSION,
                                     32 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     3,
                                     L_APP_CUSTOM_PARAM,
                                     32 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     4,
                                     L_LOGON_STATION,
                                     160 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     5,
                                     L_USER_SID,
                                     80 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     6,
                                     L_USER_NAME,
                                     160 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     7,
                                     L_LOGON_DATE,
                                     24 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     8,
                                     L_LAST_HEARTBEAT,
                                     24 );
         DBMS_SQL.DEFINE_COLUMN_RAW( P_GETLICENSEUSAGE_CURSOR,
                                     9,
                                     L_AUDSID,
                                     40 );
         L_RESULT := DBMS_SQL.EXECUTE( P_GETLICENSEUSAGE_CURSOR );
      END IF;

      L_RESULT := DBMS_SQL.FETCH_ROWS( P_GETLICENSEUSAGE_CURSOR );
      L_FETCHED_ROWS := 0;

      LOOP

         EXIT WHEN L_RESULT = 0
               OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    1,
                                    L_APP_ID );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    2,
                                    L_APP_VERSION );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    3,
                                    L_APP_CUSTOM_PARAM );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    4,
                                    L_LOGON_STATION );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    5,
                                    L_USER_SID );

         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    6,
                                    L_USER_NAME );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    7,
                                    L_LOGON_DATE );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    8,
                                    L_LAST_HEARTBEAT );
         DBMS_SQL.COLUMN_VALUE_RAW( P_GETLICENSEUSAGE_CURSOR,
                                    9,
                                    L_AUDSID );

         L_FETCHED_ROWS :=   L_FETCHED_ROWS
                           + 1;

         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_APP_ID,
                                          A_APP_ID( L_FETCHED_ROWS ) );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               A_APP_ID( L_FETCHED_ROWS ) := '';
         END;

         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_APP_VERSION,
                                          A_APP_VERSION( L_FETCHED_ROWS ) );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               A_APP_VERSION( L_FETCHED_ROWS ) := '';
         END;

         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_APP_CUSTOM_PARAM,
                                          A_APP_CUSTOM_PARAM( L_FETCHED_ROWS ) );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               A_APP_CUSTOM_PARAM( L_FETCHED_ROWS ) := '';
         END;

         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_LOGON_STATION,
                                          A_LOGON_STATION( L_FETCHED_ROWS ) );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               A_LOGON_STATION( L_FETCHED_ROWS ) := '';
         END;

         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_USER_SID,
                                          A_USER_SID( L_FETCHED_ROWS ) );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               A_USER_SID( L_FETCHED_ROWS ) := '';
         END;


         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_USER_NAME,
                                          A_USER_NAME( L_FETCHED_ROWS ) );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               A_USER_NAME( L_FETCHED_ROWS ) := '';
         END;


         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_LOGON_DATE,
                                          L_LOGON_DATE_DECRYPTED );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               L_LOGON_DATE_DECRYPTED := '';
         END;


         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_LAST_HEARTBEAT,
                                          L_LAST_HEARTBEAT_DECRYPTED );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               L_LAST_HEARTBEAT_DECRYPTED := '';
         END;


         BEGIN
            L_RET_CODE := DYNAMICDECRYPT( L_AUDSID,
                                          L_AUDSID_DECRYPTED );
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               
               
               L_AUDSID_DECRYPTED := 0;
         END;



         
         
         
         
         BEGIN
            A_LOGON_DATE( L_FETCHED_ROWS ) := TO_CHAR( TO_DATE( L_LOGON_DATE_DECRYPTED,
                                                                'DD-MM-YY HH24:MI:SS' ) );
         EXCEPTION
            WHEN OTHERS
            THEN
               
               
               A_LOGON_DATE( L_FETCHED_ROWS ) := '';
         END;

         BEGIN
            A_LAST_HEARTBEAT( L_FETCHED_ROWS ) := TO_CHAR( TO_DATE( L_LAST_HEARTBEAT_DECRYPTED,
                                                                    'DD-MM-YY HH24:MI:SS' ) );
         EXCEPTION
            WHEN OTHERS
            THEN
               
               
               A_LAST_HEARTBEAT( L_FETCHED_ROWS ) := '';
         END;



         
         
         IF P_LAST_STRING4APP <>    A_APP_ID( L_FETCHED_ROWS )
                                 || A_APP_VERSION( L_FETCHED_ROWS )
                                 || A_APP_CUSTOM_PARAM( L_FETCHED_ROWS )
         THEN
            P_LAST_STRING4APP :=    A_APP_ID( L_FETCHED_ROWS )
                                 || A_APP_VERSION( L_FETCHED_ROWS )
                                 || A_APP_CUSTOM_PARAM( L_FETCHED_ROWS );
            P_LAST_STRING4LICENSE := ' ';
            P_LICENSE_USAGE := 0;
         END IF;

         IF P_LAST_STRING4LICENSE <>    A_USER_SID( L_FETCHED_ROWS )
                                     || A_LOGON_STATION( L_FETCHED_ROWS )
         THEN
            P_LAST_STRING4LICENSE :=    A_USER_SID( L_FETCHED_ROWS )
                                     || A_LOGON_STATION( L_FETCHED_ROWS );
            P_LICENSE_USAGE :=   P_LICENSE_USAGE
                               + 1;
         END IF;

         A_LIC_CONSUMED( L_FETCHED_ROWS ) := P_LICENSE_USAGE;



         
         BEGIN
            SELECT MAX( PROGRAM )
              INTO A_EXECUTABLE( L_FETCHED_ROWS )
              FROM SYS.V_$SESSION
             WHERE AUDSID = L_AUDSID_DECRYPTED;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               A_EXECUTABLE( L_FETCHED_ROWS ) := NULL;
         END;



         
         L_APP_ID_TAB( 1 ) := A_APP_ID( L_FETCHED_ROWS );
         L_APP_VERSION_TAB( 1 ) := A_APP_VERSION( L_FETCHED_ROWS );
         L_APP_CUSTOM_PARAM_TAB( 1 ) := A_APP_CUSTOM_PARAM( L_FETCHED_ROWS );
         A_LIC_CONSUMED_SERIAL_ID( L_FETCHED_ROWS ) := NULL;
         A_LIC_CONSUMED_SHORTNAME( L_FETCHED_ROWS ) := NULL;
         L_LIC_CHECK_NR_OF_ROWS := 1;
         L_LIC_CHECK_RET_CODE :=
            INTERNALCHECKLICENSE( L_APP_ID_TAB,
                                  L_APP_VERSION_TAB,
                                  L_APP_CUSTOM_PARAM_TAB,
                                  L_LIC_CHECK_OK_4_APP_TAB,
                                  L_MAX_USERS_4_APP_TAB,
                                  P_LICENSE_USAGE,
                                  A_LIC_CONSUMED_SERIAL_ID( L_FETCHED_ROWS ),
                                  A_LIC_CONSUMED_SHORTNAME( L_FETCHED_ROWS ),
                                  L_LIC_CHECK_NR_OF_ROWS,
                                  L_LIC_CHECK_ERROR_MESSAGE );

         IF L_FETCHED_ROWS < A_NR_OF_ROWS
         THEN
            L_RESULT := DBMS_SQL.FETCH_ROWS( P_GETLICENSEUSAGE_CURSOR );
         END IF;

      END LOOP;

      
      IF ( L_FETCHED_ROWS = 0 )
      THEN
         DBMS_SQL.CLOSE_CURSOR( P_GETLICENSEUSAGE_CURSOR );
         P_GETLICENSEUSAGE_CURSOR := NULL;
         RETURN( CXSAPILK.DBERR_NORECORDS );
      ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS
      THEN
         DBMS_SQL.CLOSE_CURSOR( P_GETLICENSEUSAGE_CURSOR );
         P_GETLICENSEUSAGE_CURSOR := NULL;
         A_NR_OF_ROWS := L_FETCHED_ROWS;
      END IF;

      RETURN( CXSAPILK.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF DBMS_SQL.IS_OPEN( P_GETLICENSEUSAGE_CURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( P_GETLICENSEUSAGE_CURSOR );
         END IF;

         
         IF SQLCODE = -20000
         THEN
            RAISE;
         ELSE
            RAISE_APPLICATION_ERROR( -20000,
                                        'Problem encountered during GetActualLicenseUsage.OracleErrorCode'
                                     || SQLCODE );
         END IF;
   END GETACTUALLICENSEUSAGE;

   PROCEDURE CONVERTOLDINTERSPECLICENSE(
      A_ISPCDBA_SCHEMA           IN       VARCHAR2 )
   IS
      L_COUNT                       INTEGER;
      L_LIC_NUMBER                  CHAR( 8 );
      L_CUSTOMER                    CHAR( 40 );
      L_SITE                        CHAR( 40 );
      L_USERS                       NUMBER( 4 );
      L_MODULES                     CHAR( 60 );
      L_KEY                         CHAR( 20 );
      L_EXPIRE_DATE                 CHAR( 11 );

      L_SERIAL_ID                   VARCHAR2( 40 );
      L_NR_OF_ROWS                  NUMBER;
      L_ERROR_MESSAGE               VARCHAR2( 255 );
      L_SETTING_NAME_TAB            CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE_TAB           CXSAPILK.VC255_TABLE_TYPE;
   BEGIN
      DBMS_OUTPUT.PUT_LINE( '1. checking if no license is already installed in ctlicsecid' );

      
      SELECT COUNT( * )
        INTO L_COUNT
        FROM CTLICSECID;

      IF L_COUNT <> 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'The expected conversion can not be performed since some license is already installed in ctlic... tables' );
      END IF;

      DBMS_OUTPUT.PUT_LINE( '2. checking if no license is already installed in ctlicsecidauxiliary' );

      
      SELECT COUNT( * )
        INTO L_COUNT
        FROM CTLICSECIDAUXILIARY;

      IF L_COUNT <> 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'The expected conversion can not be performed since some license is already installed in ctlic... tables' );
      END IF;

      DBMS_OUTPUT.PUT_LINE( '3. checking if old license is a valid one' );
      DBMS_OUTPUT.PUT_LINE(    '3.1. calling '
                            || A_ISPCDBA_SCHEMA
                            || '.PA_LIC.CheckLicenseKey' );
      DBMS_OUTPUT.PUT_LINE(    'Be sure that the calling user has the right to execute the package '
                            || A_ISPCDBA_SCHEMA
                            || '.PA_LIC' );

      
      EXECUTE IMMEDIATE    'DECLARE l_ret_code INTEGER; BEGIN :l_ret_code := "'
                        || A_ISPCDBA_SCHEMA
                        || '".PA_LIC.CheckLicenseKey; END;'
                  USING IN OUT L_RET_CODE;

      DBMS_OUTPUT.PUT_LINE(    '3.2. checking return code of '
                            || A_ISPCDBA_SCHEMA
                            || '.PA_LIC.CheckLicenseKey' );

      IF L_RET_CODE < 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                     'The old license is apparently not a valid one. return code of '
                                  || A_ISPCDBA_SCHEMA
                                  || '.PA_LIC.CheckLicenseKey='
                                  || L_RET_CODE );
      END IF;

      DBMS_OUTPUT.PUT_LINE( '4. Start of the conversion process' );
      DBMS_OUTPUT.PUT_LINE(    '4.1 Fetching old license elements in table '
                            || A_ISPCDBA_SCHEMA
                            || '.itlic' );
      DBMS_OUTPUT.PUT_LINE(    'Be sure that the calling user has the right to SELECT FROM the table '
                            || A_ISPCDBA_SCHEMA
                            || '.itlic' );

      EXECUTE IMMEDIATE    'SELECT lic_number, customer, site, users, modules, key, expire_date FROM "'
                        || A_ISPCDBA_SCHEMA
                        || '".itlic'
                   INTO L_LIC_NUMBER,
                        L_CUSTOMER,
                        L_SITE,
                        L_USERS,
                        L_MODULES,
                        L_KEY,
                        L_EXPIRE_DATE;

      DBMS_OUTPUT.PUT_LINE( '4.2 Calling SaveLicense' );
      L_SERIAL_ID := L_LIC_NUMBER;
      
      L_NR_OF_ROWS := 7;
      L_SETTING_NAME_TAB( 1 ) := 'customer';
      L_SETTING_VALUE_TAB( 1 ) := L_CUSTOMER;
      L_SETTING_NAME_TAB( 2 ) := 'site';
      L_SETTING_VALUE_TAB( 2 ) := L_SITE;
      L_SETTING_NAME_TAB( 3 ) := 'users';
      L_SETTING_VALUE_TAB( 3 ) := L_USERS;
      L_SETTING_NAME_TAB( 4 ) := 'modules';
      L_SETTING_VALUE_TAB( 4 ) := L_MODULES;
      L_SETTING_NAME_TAB( 5 ) := 'expire_date';
      L_SETTING_VALUE_TAB( 5 ) := L_EXPIRE_DATE;
      L_SETTING_NAME_TAB( 6 ) := 'version';
      L_SETTING_VALUE_TAB( 6 ) := 'I0601';
      L_SETTING_NAME_TAB( 7 ) := 'old_version';
      L_SETTING_VALUE_TAB( 7 ) := 'YES';
      L_RET_CODE := CONVERTLICENSE( L_SERIAL_ID,
                                    L_SERIAL_ID,
                                    L_SETTING_NAME_TAB,
                                    L_SETTING_VALUE_TAB,
                                    L_NR_OF_ROWS,
                                    L_ERROR_MESSAGE );

      IF L_RET_CODE <> CXSAPILK.DBERR_SUCCESS
      THEN
         DBMS_OUTPUT.PUT_LINE(    'Failed:'
                               || L_RET_CODE );
      ELSE
         DBMS_OUTPUT.PUT_LINE( 'Successfully executed' );
         
         DBMS_OUTPUT.PUT_LINE(    'l_error_message='
                               || L_ERROR_MESSAGE );
      END IF;
   END CONVERTOLDINTERSPECLICENSE;

   PROCEDURE CONVERTOLDUNILABLICENSE(
      A_ULDBA_SCHEMA             IN       VARCHAR2 )
   IS
      L_COUNT                       INTEGER;
      L_LIC_NUMBER                  CHAR( 8 );
      L_CUSTOMER                    CHAR( 40 );
      L_SITE                        CHAR( 40 );
      L_USERS                       NUMBER( 4 );
      L_MODULES                     CHAR( 60 );
      L_KEY                         CHAR( 20 );
      L_EXPIRE_DATE                 CHAR( 11 );
      L_MAX_USERS                   INTEGER;
      L_CURRENT_USERS               INTEGER;

      L_SERIAL_ID                   VARCHAR2( 40 );
      L_NR_OF_ROWS                  NUMBER;
      L_ERROR_MESSAGE               VARCHAR2( 255 );
      L_SETTING_NAME_TAB            CXSAPILK.VC40_TABLE_TYPE;
      L_SETTING_VALUE_TAB           CXSAPILK.VC255_TABLE_TYPE;
   BEGIN
      DBMS_OUTPUT.PUT_LINE( '1. checking if no license is already installed in ctlicsecid' );

      
      SELECT COUNT( * )
        INTO L_COUNT
        FROM CTLICSECID;

      IF L_COUNT <> 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'The expected conversion can not be performed since some license is already installed in ctlic... tables' );
      END IF;

      DBMS_OUTPUT.PUT_LINE( '2. checking if no license is already installed in ctlicsecidauxiliary' );

      
      SELECT COUNT( * )
        INTO L_COUNT
        FROM CTLICSECIDAUXILIARY;

      IF L_COUNT <> 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'The expected conversion can not be performed since some license is already installed in ctlic... tables' );
      END IF;

      DBMS_OUTPUT.PUT_LINE( '3. checking if old license is a valid one' );
      DBMS_OUTPUT.PUT_LINE(    '3.1. calling '
                            || A_ULDBA_SCHEMA
                            || '.UNAPILK.CheckLicenseKey' );
      DBMS_OUTPUT.PUT_LINE(    'Be sure that the calling user has the right to execute the package '
                            || A_ULDBA_SCHEMA
                            || '.UNAPILK' );
      
      L_RET_CODE := 1;

      EXECUTE IMMEDIATE    'DECLARE l_ret BOOLEAN ; '
                        || 'BEGIN '
                        || '   l_ret := "'
                        || A_ULDBA_SCHEMA
                        || '".UNAPILK.CheckLicenseKey(:l_max_users, :l_current_users, :l_us); '
                        || '   IF l_ret THEN :l_ret_code := 0; ELSE :l_ret_code := 1; END IF; '
                        || 'END;'
                  USING OUT L_MAX_USERS,
                        OUT L_CURRENT_USERS,
                        IN A_ULDBA_SCHEMA,
                        OUT L_RET_CODE;

      DBMS_OUTPUT.PUT_LINE(    '3.2. checking return code of '
                            || A_ULDBA_SCHEMA
                            || '.UNAPILK.CheckLicenseKey' );

      IF L_RET_CODE <> 0
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                     'The old license is apparently not a valid one. return code of '
                                  || A_ULDBA_SCHEMA
                                  || '.UNAPILK.CheckLicenseKey=FALSE' );
      END IF;

      DBMS_OUTPUT.PUT_LINE( '4. Start of the conversion process' );
      DBMS_OUTPUT.PUT_LINE(    '4.1 Fetching old license elements in table '
                            || A_ULDBA_SCHEMA
                            || '.utlicsecid' );
      DBMS_OUTPUT.PUT_LINE(    'Be sure that the calling user has the right to SELECT FROM the table '
                            || A_ULDBA_SCHEMA
                            || '.utlicsecid' );

      EXECUTE IMMEDIATE    'SELECT lic_number, customer, site, users, modules, key, expire_date FROM "'
                        || A_ULDBA_SCHEMA
                        || '".utlicsecid'
                   INTO L_LIC_NUMBER,
                        L_CUSTOMER,
                        L_SITE,
                        L_USERS,
                        L_MODULES,
                        L_KEY,
                        L_EXPIRE_DATE;

      DBMS_OUTPUT.PUT_LINE( '4.2 Calling SaveLicense' );
      L_SERIAL_ID := L_LIC_NUMBER;
      
      L_NR_OF_ROWS := 7;
      L_SETTING_NAME_TAB( 1 ) := 'customer';
      L_SETTING_VALUE_TAB( 1 ) := L_CUSTOMER;
      L_SETTING_NAME_TAB( 2 ) := 'site';
      L_SETTING_VALUE_TAB( 2 ) := L_SITE;
      L_SETTING_NAME_TAB( 3 ) := 'users';
      L_SETTING_VALUE_TAB( 3 ) := L_USERS;
      L_SETTING_NAME_TAB( 4 ) := 'modules';
      L_SETTING_VALUE_TAB( 4 ) := L_MODULES;
      L_SETTING_NAME_TAB( 5 ) := 'expire_date';
      L_SETTING_VALUE_TAB( 5 ) := L_EXPIRE_DATE;
      L_SETTING_NAME_TAB( 6 ) := 'version';
      L_SETTING_VALUE_TAB( 6 ) := 'U0601';
      L_SETTING_NAME_TAB( 7 ) := 'old_version';
      L_SETTING_VALUE_TAB( 7 ) := 'YES';
      L_RET_CODE := CONVERTLICENSE( L_SERIAL_ID,
                                    L_SERIAL_ID,
                                    L_SETTING_NAME_TAB,
                                    L_SETTING_VALUE_TAB,
                                    L_NR_OF_ROWS,
                                    L_ERROR_MESSAGE );

      IF L_RET_CODE <> CXSAPILK.DBERR_SUCCESS
      THEN
         DBMS_OUTPUT.PUT_LINE(    'Failed:'
                               || L_RET_CODE );
      ELSE
         DBMS_OUTPUT.PUT_LINE( 'Successfully executed' );
         
         DBMS_OUTPUT.PUT_LINE(    'l_error_message='
                               || L_ERROR_MESSAGE );
      END IF;
   END CONVERTOLDUNILABLICENSE;

   FUNCTION ISDBAUSER
      RETURN NUMBER
   IS
      L_COUNT                       INTEGER;
   BEGIN
      IF USER = 'LimsAdministrator'
      THEN
         RETURN( CXSAPILK.DBERR_SUCCESS );
      END IF;

      SELECT COUNT( * )
        INTO L_COUNT
        FROM DBA_ROLE_PRIVS
       WHERE GRANTED_ROLE IN( 'UNILABDBA', 'INTERSPECDBA' )
         AND GRANTEE = USER;

      IF L_COUNT > 0
      THEN
         RETURN( CXSAPILK.DBERR_SUCCESS );
      ELSE
         RETURN( CXSAPILK.DBERR_NORECORDS );
      END IF;
   END ISDBAUSER;

   PROCEDURE TESTRAW
   IS
      L_STRING_TO_HASH              VARCHAR2( 1020 );
      L_RETURNKEY                   RAW( 1020 );
      L_HASH_CODE_CLIENT_RAW        RAW( 1020 );
      L_HASH_CODE_CLIENT            VARCHAR2( 1020 );
      L_RAW                         RAW( 2 );
      L_SUCCESS                     INTEGER;
      L_RETURNKEY_ENCRYPTED         RAW( 1020 );
   BEGIN
      L_RAW := HEXTORAW( '40' );
      DBMS_OUTPUT.PUT_LINE(    'raw1'
                            || L_RAW );


      DBMS_OUTPUT.PUT_LINE(    'raw2'
                            || L_RAW );
      DBMS_OUTPUT.PUT_LINE(    'raw3'
                            || L_RAW );
      L_RET_CODE := ENCRYPT( L_RAW,
                             L_HASH_CODE_CLIENT_RAW );
      L_RET_CODE := DECRYPT( L_HASH_CODE_CLIENT_RAW,
                             L_RAW );
      DBMS_OUTPUT.PUT_LINE(    'raw4'
                            || L_RAW );
      L_STRING_TO_HASH := RPAD( 'AA',
                                255,
                                '&' );
      
      L_RETURNKEY :=
         HEXTORAW
            ( 'B1CC92CD71358CF87E6CFF174B64CB5E1C97DA93E8C8A32FF7F1C980B4524471D8C6E57B1A3B37A804AE463AC3DEB117F1E391F87D934532733E426E4D61A544E7A7EC75647A1124282AFBA3458E1FDA1599EF9B3209EB540EDD97F937F1B2753251097DA58DFA011647E09C3253DF7437919A7681182D8C5510764D114E4AA1028E95B38B275D8334722DE15EA67F3C0A0BDFE3667800FA0F68418A6EB00E96504271541778C28DCB9903FF2B6D229006CE439A80EA8D3BB331E20F507BE4CE111942B8259784E0BC248E427F483F53945D7E07DB69955D6EB636CBCAD3D862EF90C928FF85A279999EEEAA2700194F2A0E570234F0C56176AA1C8367537BB8C47DB60898981366D6AC05017C700CB1B9647EAD44349B846179E76B3CB59574315645B28992991935DE274BCC3B995491DBAB457259653008D14D37080D1507B09A372EE5F392AAC64174F262D747DB4BAEE053320C7678F53D6CCA1A2C8C140386AC52ED7EF3CAC4F67CA052092375FE12FF170052A2961D94838E8F5C03524951724DAA6C895A4B8097DDC59C92977E548F6461D585FAC774C3BFF5B9FC9D95C24703C7A14580040BF5468D7D7BEE44CCF9CB17E4E56F7134C8B80B082FC3392A381DF8A2D77F456B19A3E16F087FD4E79FE854D63A59E41EC239CBA10C8464BA169E40DCABCDFE28F7B73084081C6E293BBA34B66B20526933048F90BEEB' );
      
      
      L_RET_CODE := DECRYPT( L_RETURNKEY,
                             L_HASH_CODE_CLIENT_RAW );
      DBMS_OUTPUT.PUT_LINE( 'Blanks replaced by *' );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'raw:'
                                     || SUBSTR( UTL_RAW.CAST_TO_VARCHAR2( L_HASH_CODE_CLIENT_RAW ),
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
      L_HASH_CODE_CLIENT := UTL_RAW.CAST_TO_VARCHAR2( L_HASH_CODE_CLIENT_RAW );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'string1:'
                                     || SUBSTR( L_HASH_CODE_CLIENT,
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
      DBMS_OUTPUT.PUT_LINE(    'length string2:'
                            || LENGTH( L_HASH_CODE_CLIENT ) );
      L_RET_CODE := DECRYPT( L_RETURNKEY,
                             L_HASH_CODE_CLIENT );
      
      
      DBMS_OUTPUT.PUT_LINE(    'length string2:'
                            || LENGTH( L_HASH_CODE_CLIENT ) );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'string2:'
                                     || SUBSTR( L_HASH_CODE_CLIENT,
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'string2:'
                                     || SUBSTR( UTL_RAW.CAST_TO_VARCHAR2( HEXTORAW( L_HASH_CODE_CLIENT ) ),
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
      
      DBMS_OUTPUT.PUT_LINE( '----------------------------------------------' );
      L_STRING_TO_HASH := RPAD( 'AA',
                                255,
                                '&' );
      L_SUCCESS := GENERATEHASHCODELIKECLIENT( L_STRING_TO_HASH,
                                               L_RETURNKEY );
      DBMS_OUTPUT.PUT_LINE(    'length of non encrypted raw'
                            || UTL_RAW.LENGTH( L_RETURNKEY ) );
      L_RET_CODE := ENCRYPT( L_RETURNKEY,
                             L_RETURNKEY_ENCRYPTED );
      DBMS_OUTPUT.PUT_LINE(    'length of encrypted raw'
                            || UTL_RAW.LENGTH( L_RETURNKEY_ENCRYPTED ) );
      L_RET_CODE := DECRYPT( L_RETURNKEY_ENCRYPTED,
                             L_HASH_CODE_CLIENT_RAW );
      DBMS_OUTPUT.PUT_LINE( 'Blanks replaced by *' );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'raw:'
                                     || SUBSTR( UTL_RAW.CAST_TO_VARCHAR2( L_HASH_CODE_CLIENT_RAW ),
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
      L_HASH_CODE_CLIENT := UTL_RAW.CAST_TO_VARCHAR2( L_HASH_CODE_CLIENT_RAW );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'string1:'
                                     || SUBSTR( L_HASH_CODE_CLIENT,
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
      DBMS_OUTPUT.PUT_LINE(    'length string2:'
                            || LENGTH( L_HASH_CODE_CLIENT ) );
      L_RET_CODE := DECRYPT( L_RETURNKEY_ENCRYPTED,
                             L_HASH_CODE_CLIENT );
      
      
      DBMS_OUTPUT.PUT_LINE(    'length string2:'
                            || LENGTH( L_HASH_CODE_CLIENT ) );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'string2:'
                                     || SUBSTR( L_HASH_CODE_CLIENT,
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
      DBMS_OUTPUT.PUT_LINE( REPLACE(    'string2:'
                                     || SUBSTR( UTL_RAW.CAST_TO_VARCHAR2( HEXTORAW( L_HASH_CODE_CLIENT ) ),
                                                1,
                                                50 ),
                                     ' ',
                                     '*' ) );
   END TESTRAW;























































   PROCEDURE SHUFFLE   
                    (
      A_INPUT                    IN OUT   CXSAPILK.NUM_TABLE_TYPE,
      A_SIZE                     IN       NUMBER )
   IS
      L_HULP1                       CXSAPILK.NUM_TABLE_TYPE;
      L_HULP2                       CXSAPILK.NUM_TABLE_TYPE;
      L_MAXINDEX                    NUMBER;
      L_NB_LOOPS                    NUMBER;
      L_IND                         NUMBER;
      L_IND2                        NUMBER;
   BEGIN
      L_MAXINDEX := 1;

      BEGIN
         LOOP
            L_HULP1( L_MAXINDEX ) := A_INPUT( L_MAXINDEX );
            L_MAXINDEX :=   L_MAXINDEX
                          + 1;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;

      L_MAXINDEX :=   L_MAXINDEX
                    - 1;
      L_NB_LOOPS := FLOOR(   L_MAXINDEX
                           / (   A_SIZE
                               * 4 ) );
      L_IND := 1;

      FOR I IN 1 .. L_NB_LOOPS
      LOOP
         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J
                                         + A_SIZE );
            L_IND :=   L_IND
                     + 1;
         END LOOP;

         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J
                                         +   3
                                           * A_SIZE );
            L_IND :=   L_IND
                     + 1;
         END LOOP;

         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J
                                         +   2
                                           * A_SIZE );
            L_IND :=   L_IND
                     + 1;
         END LOOP;

         FOR J IN 1 .. A_SIZE
         LOOP
            L_HULP2( L_IND ) := L_HULP1(      (   I
                                                - 1 )
                                           * A_SIZE
                                           * 4
                                         + J );
            L_IND :=   L_IND
                     + 1;
         END LOOP;
      END LOOP;

      FOR J IN L_IND .. L_MAXINDEX
      LOOP
         L_HULP2( J ) := L_HULP1( J );
      END LOOP;

      A_INPUT := L_HULP2;
   END SHUFFLE;

   FUNCTION CREATEKEY   
                     (
      A_INPUTINFO                IN       CHAR,
      A_KEY                      OUT      CHAR )
      RETURN BOOLEAN
   IS
      L_KEYLONG                     CXSAPILK.NUM_TABLE_TYPE;
      L_KEYSHORT                    CXSAPILK.NUM_TABLE_TYPE;
      L_SOM                         NUMBER;
      L_SOM1                        NUMBER;
      L_SOM2                        NUMBER;
      L_SOM3                        NUMBER;
      L_SCRAMBLE                    CHAR( 20 );
      L_LETTER                      CHAR( 1 );
      L_TEMP                        VARCHAR( 20 );
      L_MULTIPLIER                  NUMBER;
   BEGIN



      FOR I IN 1 .. 200
      LOOP
         L_LETTER := SUBSTR( A_INPUTINFO,
                             I,
                             1 );

         IF ASCIISTR( L_LETTER ) = L_LETTER
         THEN
            L_KEYLONG( I ) := ASCII( SUBSTR( A_INPUTINFO,
                                             I,
                                             1 ) );
         ELSE
            
            L_KEYLONG( I ) := TO_NUMBER( SUBSTR( ASCIISTR( L_LETTER ),
                                                 2 ),
                                         'XXXX' );
         END IF;
      END LOOP;

      SHUFFLE( L_KEYLONG,
               25 );
      SHUFFLE( L_KEYLONG,
               10 );
      SHUFFLE( L_KEYLONG,
               50 );

      FOR I IN 1 .. 10
      LOOP
         L_SOM := 0;

         FOR J IN 1 .. 27
         LOOP
            L_SOM :=   L_SOM
                     + L_KEYLONG(   MOD(  (     20
                                              * I
                                            + J ),
                                         200 )
                                  + 1 );
         END LOOP;

         L_KEYSHORT( I ) := MOD(   L_SOM
                                 + 14,
                                   62
                                 - MOD( I,
                                        3 ) );
      END LOOP;

      FOR I IN 0 .. 4
      LOOP
         L_SOM := 0;

         FOR J IN 3 .. 61
         LOOP
            L_SOM :=   L_SOM
                     + L_KEYLONG(   MOD(  (     48
                                              * I
                                            + J ),
                                         200 )
                                  + 1 );
         END LOOP;

         L_KEYSHORT(   11
                     + I ) := MOD( L_SOM,
                                     62
                                   - MOD( I,
                                          2 ) );
      END LOOP;

      L_SOM1 := 0;

      FOR J IN 1 .. 200
      LOOP
         L_SOM1 :=   L_SOM1
                   + MOD(   J
                          * L_KEYLONG( J ),
                          62 )
                   - 31;
      END LOOP;

      L_KEYSHORT( 16 ) := MOD( ABS( L_SOM1 ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 1 .. 7
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM2 := 0;

      FOR J IN 13 .. 16
      LOOP
         L_SOM2 :=   L_SOM2
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM3 := 0;

      FOR J IN 1 .. 16
      LOOP
         L_SOM3 :=   L_SOM3
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 17 ) := MOD(  (   MOD(   L_SOM1
                                         + 2,
                                         7 )
                                  + MOD( L_SOM2,
                                         11 )
                                  + MOD(   L_SOM3
                                         + 1,
                                         58 ) ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 2 .. 11
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM2 := 0;

      FOR J IN 7 .. 15
      LOOP
         L_SOM2 :=   L_SOM2
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM3 := 0;

      FOR J IN 1 .. 17
      LOOP
         L_SOM3 :=   L_SOM3
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 18 ) := MOD(  (   MOD(   L_SOM1
                                         + 3,
                                         11 )
                                  + MOD(   L_SOM2
                                         + 4,
                                         5 )
                                  + MOD(   L_SOM3
                                         + 32,
                                         71 ) ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 1 .. 13
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM2 := 0;

      FOR J IN 7 .. 18
      LOOP
         L_SOM2 :=   L_SOM2
                   + L_KEYSHORT( J );
      END LOOP;

      L_SOM3 := 0;

      FOR J IN 1 .. 18
      LOOP
         L_SOM3 :=   L_SOM3
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 19 ) := MOD(  (   MOD(   L_SOM1
                                         + 5,
                                         10 )
                                  + MOD(   L_SOM2
                                         + 2,
                                         6 )
                                  + MOD(   L_SOM3
                                         + 44,
                                         63 ) ),
                               62 );
      L_SOM1 := 0;

      FOR J IN 1 .. 19
      LOOP
         L_SOM1 :=   L_SOM1
                   + L_KEYSHORT( J );
      END LOOP;

      L_KEYSHORT( 20 ) := MOD( L_SOM1,
                               62 );

      IF MOD( L_KEYSHORT( 20 ),
              5 ) = 0
      THEN
         L_MULTIPLIER := 43;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 1
      THEN
         L_MULTIPLIER := 41;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 2
      THEN
         L_MULTIPLIER := 47;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 3
      THEN
         L_MULTIPLIER := 37;
      ELSIF MOD( L_KEYSHORT( 20 ),
                 5 ) = 4
      THEN
         L_MULTIPLIER := 29;
      END IF;

      SHUFFLE( L_KEYSHORT,
               5 );
      SHUFFLE( L_KEYSHORT,
               1 );
      L_SCRAMBLE := 'aT8U1SowjnNw2f98kieL';
      L_KEYSHORT( 1 ) := MOD(  (     L_KEYSHORT( 1 )
                                   * L_MULTIPLIER
                                 + ASCII( SUBSTR( L_SCRAMBLE,
                                                  1,
                                                  1 ) ) ),
                              62 );

      IF ( L_KEYSHORT( 1 ) < 26 )
      THEN
         L_TEMP := CHR(   65
                        + L_KEYSHORT( 1 ) );
      ELSIF( L_KEYSHORT( 1 ) < 36 )
      THEN
         L_TEMP := CHR(   48
                        + L_KEYSHORT( 1 )
                        - 26 );
      ELSE
         L_TEMP := CHR(   97
                        + L_KEYSHORT( 1 )
                        - 36 );
      END IF;

      FOR J IN 2 .. 19
      LOOP
         L_KEYSHORT( J ) := MOD(  (     L_KEYSHORT( J )
                                      * L_MULTIPLIER
                                    + ASCII( SUBSTR( L_SCRAMBLE,
                                                     J,
                                                     1 ) ) ),
                                 62 );

         IF ( L_KEYSHORT( J ) < 26 )
         THEN
            L_LETTER := CHR(   65
                             + L_KEYSHORT( J ) );
         ELSIF( L_KEYSHORT( J ) < 36 )
         THEN
            L_LETTER := CHR(   48
                             + L_KEYSHORT( J )
                             - 26 );
         ELSE
            L_LETTER := CHR(   97
                             + L_KEYSHORT( J )
                             - 36 );
         END IF;

         L_TEMP :=    RTRIM( L_TEMP )
                   || L_LETTER;
      END LOOP;

      L_SOM1 := 0;

      FOR J IN 1 .. 19
      LOOP
         L_SOM1 :=   L_SOM1
                   + ASCII( SUBSTR( L_TEMP,
                                    J,
                                    1 ) );
      END LOOP;

      L_LETTER := CHR(   65
                       + MOD( L_SOM1,
                              26 ) );
      L_TEMP :=    L_TEMP
                || L_LETTER;
      A_KEY := L_TEMP;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN FALSE;
   END CREATEKEY;

   PROCEDURE TESTHASHCODE(
      A_STRING_TO_HASH           IN       VARCHAR2 )
   IS
      L_RETURNED                    VARCHAR2( 20 );
      L_BOOL                        BOOLEAN;
   BEGIN
      L_BOOL := CREATEKEY( LOCAL_RPAD( RTRIM( A_STRING_TO_HASH ),
                                       200,
                                       '&' ),
                           L_RETURNED );
      DBMS_OUTPUT.PUT_LINE(    'result of hashing of '
                            || LOCAL_RPAD( RTRIM( A_STRING_TO_HASH ),
                                           200,
                                           '&' ) );
      DBMS_OUTPUT.PUT_LINE( SUBSTR( L_RETURNED,
                                    1,
                                    255 ) );
      DBMS_OUTPUT.PUT_LINE(    'Length result of hashing of '
                            || LENGTH( L_RETURNED ) );
      L_BOOL := OLDCREATEKEY( LOCAL_RPAD( RTRIM( A_STRING_TO_HASH ),
                                          200,
                                          '&' ),
                              L_RETURNED );
      DBMS_OUTPUT.PUT_LINE(    'result of hashing of '
                            || LOCAL_RPAD( RTRIM( A_STRING_TO_HASH ),
                                           200,
                                           '&' ) );
      DBMS_OUTPUT.PUT_LINE( SUBSTR( L_RETURNED,
                                    1,
                                    255 ) );
      DBMS_OUTPUT.PUT_LINE(    'Length result of hashing of '
                            || LENGTH( L_RETURNED ) );
   END;

   PROCEDURE DEBUGME(
      A_FLAG                     IN       CHAR )
   IS
   BEGIN
      IF A_FLAG = '0'
      THEN
         L_RET_CODE := INITENCRYPTIONKEY;
         P_ENCRYPTION_KEY_NORMAL := UTL_RAW.SUBSTR( UTL_RAW.CAST_TO_RAW( 'aaaaaaaabbbbbbbbcccccccc' ),
                                                    1,
                                                    24 );
         L_RET_CODE := INITMODE;
      ELSE
         P_ENCRYPTION_KEY_NORMAL := NULL;
         L_RET_CODE := INITENCRYPTIONKEY;
         L_RET_CODE := INITMODE;
      END IF;
   END DEBUGME;
BEGIN
   L_RET_CODE := INITENCRYPTIONKEY;
   L_RET_CODE := INITMODE;
END CXSAPILK;