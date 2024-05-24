CREATE OR REPLACE PACKAGE BODY iapiEmail
AS
   
   
   
   
   
   
   
   
   
   
   
   
   

   
   
   
   
   PSMAILHOST                    VARCHAR2( 64 ) DEFAULT 'localhost';
   PSMAILCONN                    UTL_SMTP.CONNECTION;
   PSERRORMSG                    VARCHAR2( 255 );
   PSRECIPIENT                   APPLICATION_USER.EMAIL_ADDRESS%TYPE;
   PSEMAILJOBNAME                VARCHAR2( 32 ) := 'iapiEmail.SendEmails';

   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
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

   
   
   

   
   
   

   
   
   
   
   FUNCTION STOPJOB
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StopJob';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIJOB                         BINARY_INTEGER;
      LBJOBSTOPPED                  BOOLEAN;

      CURSOR LQJOB(
         ASJOBNAME                  IN       VARCHAR2 )
      IS
         SELECT JOB
           FROM DBA_JOBS
          WHERE UPPER( WHAT ) LIKE UPPER( ASJOBNAME );

      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQJOB(    '%'
                  || PSEMAILJOBNAME
                  || '%' );

      LBJOBSTOPPED := FALSE;

      LOOP
         FETCH LQJOB
          INTO LIJOB;

         EXIT WHEN LQJOB%NOTFOUND;
         DBMS_ALERT.SIGNAL( 'MAIL',
                            '2' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Signal to stop processing is send',
                              IAPICONSTANT.INFOLEVEL_3 );
         LBJOBSTOPPED := TRUE;
      END LOOP;

      CLOSE LQJOB;

      IF ( LBJOBSTOPPED = FALSE )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_JOBNOTFOUND ) );
      END IF;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF ( LQJOB%ISOPEN )
         THEN
            CLOSE LQJOB;
         END IF;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STOPJOB;

   
   FUNCTION STARTJOB
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StartJob';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIJOB                         BINARY_INTEGER;
      LNJOBS                        NUMBER;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT COUNT( JOB )
        INTO LNJOBS
        FROM DBA_JOBS
       WHERE UPPER( WHAT ) LIKE UPPER(    '%'
                                       || PSEMAILJOBNAME
                                       || '%' );

      IF LNJOBS > 0
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'E-mail job already started' );
      ELSE
         DBMS_JOB.SUBMIT( LIJOB,
                             'DECLARE lnRetVal iapiType.ErrorNum_Type; BEGIN lnRetVal := '
                          || PSEMAILJOBNAME
                          || '; END;',
                          SYSDATE,
                          '',
                          FALSE );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Job <'
                              || LIJOB
                              || '> started',
                              IAPICONSTANT.INFOLEVEL_3 );
      END IF;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STARTJOB;

   
   FUNCTION REGISTEREMAIL(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ADPLANNEDEFFECTIVEDATE     IN       IAPITYPE.DATE_TYPE,
      ASEMAILTYPE                IN       IAPITYPE.EMAILTYPE_TYPE DEFAULT 'S',
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPASSWORD                 IN       IAPITYPE.PASSWORD_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RegisterEmail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := REGISTEREMAIL( ASPARTNO,
                                 ANREVISION,
                                 ANSTATUS,
                                 ADPLANNEDEFFECTIVEDATE,
                                 ASEMAILTYPE,
                                 ASUSERID,
                                 ASPASSWORD,
                                 NULL,
                                 NULL,
                                 AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REGISTEREMAIL;

   
   FUNCTION REGISTEREMAIL(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ADPLANNEDEFFECTIVEDATE     IN       IAPITYPE.DATE_TYPE,
      ASEMAILTYPE                IN       IAPITYPE.EMAILTYPE_TYPE DEFAULT 'S',
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPASSWORD                 IN       IAPITYPE.PASSWORD_TYPE,
      ANREASONID                 IN       IAPITYPE.ID_TYPE,
      ANEXEMPTIONNO              IN       IAPITYPE.NUMVAL_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQREVISION
      IS
         SELECT   REVISION,
                  A.STATUS
             FROM SPECIFICATION_HEADER,
                  STATUS A
            WHERE PART_NO = ASPARTNO
              AND SPECIFICATION_HEADER.STATUS = A.STATUS
              AND (    A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
                    OR A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED
                    OR A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                    OR A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_SUBMIT)
         ORDER BY REVISION;

      LNCOUNTER                     NUMBER;
      LNREVISION                    NUMBER := NULL;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RegisterEmail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE := NULL;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASEMAILTYPE <> 'P'
      THEN
         
         IF ( ASPARTNO IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'PartNo' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;

         IF ( GTERRORS.COUNT > 0 )
         THEN
            
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         END IF;

         
         LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Email type <'
                              || ASEMAILTYPE
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         IF    ASEMAILTYPE = 'E'
            OR ASEMAILTYPE = 'C'
         THEN
            LNCOUNTER := 0;

            
            FOR LNROW IN LQREVISION
            LOOP
               LNCOUNTER :=   LNCOUNTER
                            + 1;

               IF LNCOUNTER = 1
               THEN
                  LNREVISION := LNROW.REVISION;
                  LNSTATUS := LNROW.STATUS;
               END IF;
            END LOOP;
         ELSE
            LNREVISION := ANREVISION;
            LNSTATUS := ANSTATUS;
         END IF;
      END IF;

      INSERT INTO ITEMAIL
                  ( EMAIL_NO,
                    EMAIL_TYPE,
                    PART_NO,
                    REVISION,
                    PART_EXEMPTION,
                    STATUS,
                    PREV_EFFECTIVE_DATE,
                    STATUS_DATE_TIME,
                    REASON_ID,
                    USERID,
                    PASSWORD )
           VALUES ( EMAIL_NO_SEQ.NEXTVAL,
                    ASEMAILTYPE,
                    ASPARTNO,
                    NVL( LNREVISION,
                         0 ),
                    NVL( ANEXEMPTIONNO,
                         1 ),
                    LNSTATUS,
                    NVL( ADPLANNEDEFFECTIVEDATE,
                         SYSDATE ),
                    SYSDATE,
                    ANREASONID,
                    ASUSERID,
                    ASPASSWORD );

      
      DBMS_ALERT.SIGNAL( 'MAIL',
                         '1' );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REGISTEREMAIL;

   
   FUNCTION SENDEMAIL(
      ASSENDER                   IN       IAPITYPE.EMAILSENDER_TYPE,
      ATRECIPIENTS               IN       IAPITYPE.EMAILTOTAB_TYPE,
      ASSUBJECT                  IN       IAPITYPE.EMAILSUBJECT_TYPE,
      ASBODY                     IN       IAPITYPE.CLOB_TYPE,
      ANNUMBERRECIPIENTS         IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SendEmail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSENDER                      VARCHAR2( 64 ) DEFAULT USER;
      LSDBNAME                      VARCHAR2( 50 );
      LSTOUSERGROUP                 INTERSPC_CFG.PARAMETER_DATA%TYPE := 'InterSpec-Users';
      LRAWDATA                      RAW( 32767 );
      LSDBDESCRIPTION               ITDBPROFILE.DESCRIPTION%TYPE;
      LSBODY                        VARCHAR2( 4000 );
      
      
      LNNUM                         NUMBER;
      
      LNAMT                         NUMBER;
      LNDUMMY                       NUMBER := 1;
      LSDBTYPE                      VARCHAR2(200);
      LBISMULTIBYTE                 BOOLEAN;
      
      LSSUBJECT                     VARCHAR2( 4000 );

      LSTRANSFORMEDBODY             VARCHAR2( 4000 );


   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ASSENDER IS NULL
      THEN
         SELECT GLOBAL_NAME
           INTO LSDBNAME
           FROM GLOBAL_NAME;

         LSSENDER :=    USER
                     || '@'
                     || LSDBNAME;
      ELSE
         LSSENDER := ASSENDER;
      END IF;

      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'mailhost',
                                                       IAPICONSTANT.CFG_SECTION_STANDARD,
                                                       PSMAILHOST );

      SELECT VALUE  INTO LSDBTYPE
         FROM V$NLS_PARAMETERS
        WHERE PARAMETER = 'NLS_CHARACTERSET';

      
      LBISMULTIBYTE:= (LSDBTYPE IN  ('UTF8', 'UTFE', 'AL32UTF8' ));


      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'No mailhost defined in configuration table' );
         RAISE_APPLICATION_ERROR( -20001,
                                  'No mailhost defined IN configuration TABLE' );
      END IF;

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Open a connection to the SMTP server <'
                           || PSMAILHOST
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      PSMAILCONN := UTL_SMTP.OPEN_CONNECTION( PSMAILHOST,
                                              25 );
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Perform initial handshaking with SMTP server <'
                           || PSMAILHOST
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      UTL_SMTP.HELO( PSMAILCONN,
                     PSMAILHOST );
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Tell SMTP server <'
                           || PSMAILHOST
                           || '> who is the sender <'
                           || LSSENDER
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      UTL_SMTP.MAIL( PSMAILCONN,
                     LSSENDER );
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Tell SMTP server <'
                           || PSMAILHOST
                           || '> who are the recipients',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LNROW IN 1 .. ANNUMBERRECIPIENTS
      LOOP
         IF ATRECIPIENTS( LNROW ) IS NULL
         THEN
            
            
            NULL;
         ELSE
            PSRECIPIENT := ATRECIPIENTS( LNROW );
            
            
            BEGIN               
            
                UTL_SMTP.RCPT( PSMAILCONN,
                               PSRECIPIENT );
           
           EXCEPTION
              WHEN OTHERS
              THEN
                 LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDEMAILADDRESS3,
                                                       PSRECIPIENT);
                               
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                      LSMETHOD,
                                      IAPIGENERAL.GETLASTERRORTEXT( ) );                                       
          END;                             
          
                           
         END IF;
      END LOOP;

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Open the connection for sending data to the SMTP server <'
                           || PSMAILHOST
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      UTL_SMTP.OPEN_DATA( PSMAILCONN );
      
      
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'to_user_group',
                                                       ASPARAMETERDATA => LSTOUSERGROUP );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'No to_user_group defined in configuration table' );
         RAISE_APPLICATION_ERROR( -20002,
                                  'No to_user_group defined in configuration table' );
      END IF;

      
      LRAWDATA := UTL_RAW.CAST_TO_RAW(    'TO: '
                                       || LSTOUSERGROUP
                                       || UTL_TCP.CRLF );
      UTL_SMTP.WRITE_RAW_DATA( PSMAILCONN,
                               LRAWDATA );
                   
      
      
      
      
      
      
      
      
      
      
      
      
      
      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                           'Subject: ' );                                                     

      
      LNNUM := 1;
      
      
      BEGIN      
          LOOP
             LNAMT := 10;
             DBMS_LOB.READ( ASSUBJECT,
                            LNAMT,
                            LNNUM,
                            LSSUBJECT );
             LNNUM :=   LNNUM
                      + LNAMT;
                      
             LRAWDATA := UTL_RAW.CAST_TO_RAW( UTL_ENCODE.MIMEHEADER_ENCODE(LSSUBJECT) );
             
             UTL_SMTP.WRITE_RAW_DATA( PSMAILCONN,
                                      LRAWDATA );
                                      
             EXIT WHEN DBMS_LOB.GETLENGTH( LSSUBJECT ) < 10;
          END LOOP;
      
      
      
      EXCEPTION WHEN NO_DATA_FOUND THEN 
          NULL;
      END;
      

      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                           UTL_TCP.CRLF );            
      
                               
      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                              'MIME-version: 1.0'
                           || UTL_TCP.CRLF );

      IF LBISMULTIBYTE  THEN
          UTL_SMTP.WRITE_DATA( PSMAILCONN,
                                  'Content-Type: text/plain; charset=utf-8'
                               || UTL_TCP.CRLF );
      ELSE
          UTL_SMTP.WRITE_DATA( PSMAILCONN,
                                  'Content-Type: text/plain; charset=MIME'
                               || UTL_TCP.CRLF );
      END IF;


      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                              'Content-Transfer-Encoding: 8bit'
                           || UTL_TCP.CRLF );

      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                           UTL_TCP.CRLF );
      
      
      
      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                              '================================================================'
                           || UTL_TCP.CRLF );

      BEGIN
         SELECT I.DESCRIPTION
           INTO LSDBDESCRIPTION
           FROM ITDBPROFILE I,
                INTERSPC_CFG IC
          WHERE IC.PARAMETER = 'owner'
            AND IC.PARAMETER_DATA = I.OWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            LSDBDESCRIPTION := '';
            RAISE;
      END;

      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                              'NOTE: This message is generated by database <'
                           || LSDBDESCRIPTION
                           || '>'
                           || UTL_TCP.CRLF );
      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                              '================================================================'
                           || UTL_TCP.CRLF );


  SELECT LTRIM(LTRIM(LTRIM(ASBODY, CHR(10)), CHR(13)), CHR(9))  INTO LSTRANSFORMEDBODY FROM DUAL; 


     SELECT CASE SUBSTR (LSTRANSFORMEDBODY, -2, 2)
              WHEN CHR (10)||CHR(46)
              THEN
                 SUBSTR (LSTRANSFORMEDBODY, 1, LENGTH (LSTRANSFORMEDBODY) - 2)
              WHEN CHR (13)||CHR(46)
              THEN
                 SUBSTR (LSTRANSFORMEDBODY, 1, LENGTH (LSTRANSFORMEDBODY) - 2)
              WHEN CHR (9)||CHR(46)
              THEN
                 SUBSTR (LSTRANSFORMEDBODY, 1, LENGTH (LSTRANSFORMEDBODY) - 2)
              ELSE
                 LSTRANSFORMEDBODY
           END CASE
       INTO LSTRANSFORMEDBODY
       FROM DUAL; 


      
      
      
      LNNUM := 1;
      
      
      BEGIN
          LOOP
             LNAMT := 1000;
         DBMS_LOB.READ( LSTRANSFORMEDBODY, 
                            LNAMT,
                            LNNUM,
                            LSBODY );
             LNNUM :=   LNNUM
                      + LNAMT;
             LRAWDATA := UTL_RAW.CAST_TO_RAW( LSBODY );
             UTL_SMTP.WRITE_RAW_DATA( PSMAILCONN,
                                      LRAWDATA );
             EXIT WHEN DBMS_LOB.GETLENGTH( LSBODY ) < 1000;
          END LOOP;
      
      
      
      EXCEPTION WHEN NO_DATA_FOUND THEN 
        NULL;
      END;
      

      UTL_SMTP.WRITE_DATA( PSMAILCONN,
                           UTL_TCP.CRLF );
      
      
      
      UTL_SMTP.CLOSE_DATA( PSMAILCONN );
      
      
      
      UTL_SMTP.QUIT( PSMAILCONN );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION

    WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
      BEGIN
        UTL_SMTP.QUIT(PSMAILCONN);
      EXCEPTION
        WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
          NULL; 
                
                
           UTL_SMTP.QUIT( PSMAILCONN );
      END;

      WHEN OTHERS
      THEN
         PSERRORMSG :=    'Failed to send mail due to the following error: '
                       || SQLERRM;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               PSERRORMSG );
         UTL_SMTP.QUIT( PSMAILCONN );
         RAISE;
   END SENDEMAIL;

   
   FUNCTION GETPASSWORDMAIL(
      ANEMAILNO                  IN       IAPITYPE.EMAILNO_TYPE,
      ASSUBJECT                  IN OUT   IAPITYPE.EMAILSUBJECT_TYPE,
      ASBODY                     IN OUT   IAPITYPE.CLOB_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPASSWORD                 IN       IAPITYPE.PASSWORD_TYPE,
      ATRECIPIENTS               IN OUT   IAPITYPE.EMAILTOTAB_TYPE,
      ANNUMBERRECIPIENTS         OUT      IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQLISTMAIL4PASSWORDTO(
         ANUSERID                            IAPITYPE.USERID_TYPE )
      IS
         SELECT DISTINCT (    EMAIL_ADDRESS
                           || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
                                                   '@' ) ),
                                      0, PARAMETER_DATA ) ) C_MAIL_TO
                    FROM APPLICATION_USER,
                         INTERSPC_CFG
                   WHERE APPLICATION_USER.USER_ID = ANUSERID
                     AND INTERSPC_CFG.PARAMETER(+) = 'def_email_ext';

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPasswordMail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNBRMAILS                    NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ASSUBJECT := 'Password changing';
      ASBODY :=    'For user: '
                || ' ['
                || ASUSERID
                || '], '
                || ' the new password is = '
                || ' ['
                || ASPASSWORD
                || ']'
                || UTL_TCP.CRLF;
      LNNBRMAILS := 0;

      FOR LRLISTMAIL4PASSWORD IN LQLISTMAIL4PASSWORDTO( ASUSERID )
      LOOP
         IF LRLISTMAIL4PASSWORD.C_MAIL_TO IS NOT NULL
         THEN
            
            
            IF (ISVALIDEMAILADDRESS( RTRIM( LTRIM( LRLISTMAIL4PASSWORD.C_MAIL_TO ) ) ) = TRUE)
            THEN
            
                LNNBRMAILS :=   LNNBRMAILS
                          + 1;
            ATRECIPIENTS( LNNBRMAILS ) := RTRIM( LTRIM( LRLISTMAIL4PASSWORD.C_MAIL_TO ) );
            
            ELSE
                LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDEMAILADDRESS2,
                                                       LRLISTMAIL4PASSWORD.C_MAIL_TO);
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                      LSMETHOD,
                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         END IF;
      END LOOP;

      
      ANNUMBERRECIPIENTS := LNNBRMAILS;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPASSWORDMAIL;

   
   FUNCTION GETMAIL(
      ANEMAILNO                  IN       IAPITYPE.EMAILNO_TYPE,
      ASSUBJECT                  IN OUT   IAPITYPE.EMAILSUBJECT_TYPE,
      ASBODY                     IN OUT   IAPITYPE.CLOB_TYPE,
      ATRECIPIENTS               IN OUT   IAPITYPE.EMAILTOTAB_TYPE,
      ANNUMBERRECIPIENTS         OUT      IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQLISTUSERGROUPS(
         ANLOCALWORKFLOWGROUPID              NUMBER,
         ANLOCALSTATUS                       NUMBER )
      IS
         SELECT DISTINCT USER_GROUP_ID
                    FROM WORK_FLOW_LIST
                   WHERE WORK_FLOW_LIST.SEND_MAIL = 'Y'
                     AND WORK_FLOW_LIST.WORKFLOW_GROUP_ID = ANLOCALWORKFLOWGROUPID
                     AND WORK_FLOW_LIST.STATUS = ANLOCALSTATUS;


        






      CURSOR LQLIST_APPROVERSELECTED_MAILTO(
         ASPARTNO                       VARCHAR2,
         ANREVISION                     NUMBER,
         
         
         ANLOCALUSERGROUP               NUMBER,
         ANSTATUS                            NUMBER)
         
      IS
           SELECT  APPLICATION_USER.EMAIL_ADDRESS
                           || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
                                                   '@' ) ),
                                      0, PARAMETER_DATA )   C_MAIL_TO
            FROM USER_GROUP,
                 USER_GROUP_LIST,
                 WORK_FLOW_LIST,
                 STATUS,
                 SPECIFICATION_HEADER,
                 APPLICATION_USER,
                 INTERSPC_CFG
            WHERE USER_GROUP_LIST.USER_ID  = APPLICATION_USER.USER_ID
                AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID)
                AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID)
                AND  USER_GROUP_LIST.USER_GROUP_ID = ANLOCALUSERGROUP
                AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS)
                AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID)
                
                
                AND (WORK_FLOW_LIST.STATUS = ANSTATUS) )
                
                AND SPECIFICATION_HEADER.PART_NO  = ASPARTNO
                AND SPECIFICATION_HEADER.REVISION = ANREVISION
                AND STATUS.STATUS_TYPE =   'SUBMIT'
                AND WORK_FLOW_LIST.ALL_TO_APPROVE <> 'Z'
                AND INTERSPC_CFG.PARAMETER(+) = 'def_email_ext'
            MINUS
            SELECT  APPLICATION_USER.EMAIL_ADDRESS
                           || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
                                                   '@' ) ),
                                      0, PARAMETER_DATA )  C_MAIL_TO
             FROM USER_GROUP,
                  USER_GROUP_LIST,
                  WORK_FLOW_LIST,
                  STATUS,
                  SPECIFICATION_HEADER,
                  APPLICATION_USER,
                  INTERSPC_CFG
            WHERE USER_GROUP_LIST.USER_ID = APPLICATION_USER.USER_ID(+)
                AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID)
                AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID)
                AND  USER_GROUP_LIST.USER_GROUP_ID = ANLOCALUSERGROUP
                AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS)
                AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID)
                
                
                AND (WORK_FLOW_LIST.STATUS = ANSTATUS)   )
                
                AND SPECIFICATION_HEADER.PART_NO  = ASPARTNO
                AND SPECIFICATION_HEADER.REVISION = ANREVISION
                AND STATUS.STATUS_TYPE =   'SUBMIT'
                AND WORK_FLOW_LIST.ALL_TO_APPROVE <>   'Z'
                AND WORK_FLOW_LIST.EDITABLE =   'Y'
                AND INTERSPC_CFG.PARAMETER(+) = 'def_email_ext'
            UNION
            (
             SELECT  APPLICATION_USER.EMAIL_ADDRESS
                           || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
                                                   '@' ) ),
                                      0, PARAMETER_DATA )  C_MAIL_TO
            FROM USER_GROUP,
                 USER_GROUP_LIST,
                 WORK_FLOW_LIST,
                 STATUS,
                 SPECIFICATION_HEADER,
                 APPROVER_SELECTED,
                 APPLICATION_USER,
                 INTERSPC_CFG
            WHERE USER_GROUP_LIST.USER_ID = APPLICATION_USER.USER_ID(+)
                AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID)
                AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID)
                AND  USER_GROUP_LIST.USER_GROUP_ID = ANLOCALUSERGROUP
                AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS)
                AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID)
                
                
                AND (WORK_FLOW_LIST.STATUS = ANSTATUS))
                
                AND SPECIFICATION_HEADER.PART_NO  = ASPARTNO
                AND SPECIFICATION_HEADER.REVISION = ANREVISION
                AND STATUS.STATUS_TYPE =   'SUBMIT'
                AND WORK_FLOW_LIST.ALL_TO_APPROVE <>  'Z'
                AND WORK_FLOW_LIST.EDITABLE = 'Y'
                AND SPECIFICATION_HEADER.PART_NO  = APPROVER_SELECTED.PART_NO
                AND SPECIFICATION_HEADER.REVISION = APPROVER_SELECTED.REVISION
                
                
                AND APPROVER_SELECTED.STATUS = ANSTATUS
                
                AND USER_GROUP_LIST.USER_ID       = APPROVER_SELECTED.USER_ID
                AND WORK_FLOW_LIST.ALL_TO_APPROVE = APPROVER_SELECTED.ALL_TO_APPROVE
                AND WORK_FLOW_LIST.USER_GROUP_ID = APPROVER_SELECTED.USER_GROUP_ID
                AND INTERSPC_CFG.PARAMETER(+) = 'def_email_ext'
                AND EXISTS (SELECT EMAIL_NO
                              FROM ITEMAIL
                             WHERE PART_NO  = ASPARTNO
                               AND REVISION = ANREVISION
                               AND EMAIL_TYPE ='S' ))
            UNION
            (
            SELECT  APPLICATION_USER.EMAIL_ADDRESS
                           || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
                                                   '@' ) ),
                                      0, PARAMETER_DATA )  C_MAIL_TO
             FROM USER_GROUP,
                  USER_GROUP_LIST,
                  WORK_FLOW_LIST,
                  STATUS,
                  SPECIFICATION_HEADER,
                  APPLICATION_USER,
                  INTERSPC_CFG
            WHERE USER_GROUP_LIST.USER_ID = APPLICATION_USER.USER_ID(+)
                AND (USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID)
                AND (USER_GROUP_LIST.USER_GROUP_ID = WORK_FLOW_LIST.USER_GROUP_ID)
                AND  USER_GROUP_LIST.USER_GROUP_ID = ANLOCALUSERGROUP
                AND (WORK_FLOW_LIST.STATUS = STATUS.STATUS)
                AND (    (WORK_FLOW_LIST.WORKFLOW_GROUP_ID = SPECIFICATION_HEADER.WORKFLOW_GROUP_ID)
                
                
                AND (WORK_FLOW_LIST.STATUS = ANSTATUS)   )
                
                AND SPECIFICATION_HEADER.PART_NO  = ASPARTNO
                AND SPECIFICATION_HEADER.REVISION = ANREVISION
                
                
                



                
                
                AND (     (     STATUS.STATUS_TYPE = 'SUBMIT'
                         AND NVL( WORK_FLOW_LIST.ALL_TO_APPROVE,' ' ) = 'Z' )
                   OR (     STATUS.STATUS_TYPE <> 'SUBMIT'
                        AND NVL( WORK_FLOW_LIST.ALL_TO_APPROVE,' ' ) <> 'Z' AND WORK_FLOW_LIST.SEND_MAIL = 'Y' ) )
                
                AND INTERSPC_CFG.PARAMETER(+) = 'def_email_ext');



      CURSOR LQLISTMAILTO(
         ANLOCALUSERGROUP                    NUMBER )
      IS
         SELECT DISTINCT (    EMAIL_ADDRESS
                           || DECODE( SIGN( INSTR( EMAIL_ADDRESS,
                                                   '@' ) ),
                                      0, PARAMETER_DATA ) ) C_MAIL_TO
                    FROM APPLICATION_USER,
                         USER_GROUP_LIST,
                         INTERSPC_CFG
                   WHERE APPLICATION_USER.USER_ID = USER_GROUP_LIST.USER_ID
                     AND USER_GROUP_LIST.USER_GROUP_ID = ANLOCALUSERGROUP
                     AND INTERSPC_CFG.PARAMETER(+) = 'def_email_ext';


      CURSOR LQMSGTOSEND(
         ANEMAILNO                           NUMBER )
      IS
         SELECT EMAIL_TYPE,
                STATUS,
                PART_NO,
                REVISION,
                TO_CHAR( PREV_EFFECTIVE_DATE,
                         'dd/Mon/yyyy' ),
                NVL( PART_EXEMPTION,
                     0 ),
                NVL( REASON_ID,
                     0 ),
                USERID,
                PASSWORD
           FROM ITEMAIL
          WHERE EMAIL_NO = ANEMAILNO;

      CURSOR LQVALUESTOSEND(
         ASPARTNO                            VARCHAR2,
         ANREVISION                          NUMBER,
         ANREASONID                          NUMBER )
      IS
         SELECT H.DESCRIPTION,
                TO_CHAR( PLANNED_EFFECTIVE_DATE,
                         'dd/Mon/yyyy' ),
                NVL( W.DESCRIPTION,
                     ' ' ),
                W.WORKFLOW_GROUP_ID,
                NVL( TEXT,
                     ' ' ),
                DECODE( C.STATUS_TYPE,
                        IAPICONSTANT.STATUSTYPE_SUBMIT, I.USER_ID,
                        ' ' ),
                F_OWNER_DESCR( TO_NUMBER( OWNER ) )
           FROM SPECIFICATION_HEADER H,
                REASON B,
                STATUS C,
                WORKFLOW_GROUP W,
                STATUS_HISTORY I
          WHERE H.PART_NO = ASPARTNO
            AND H.REVISION = ANREVISION
            AND B.PART_NO(+) = H.PART_NO
            AND B.REVISION(+) = H.REVISION
            AND H.STATUS = C.STATUS
            AND B.ID(+) = RTRIM( ANREASONID )
            AND W.WORKFLOW_GROUP_ID = H.WORKFLOW_GROUP_ID
            AND I.PART_NO(+) = H.PART_NO
            AND I.REVISION(+) = H.REVISION
            AND I.STATUS(+) = H.STATUS;

      LCTYPE                        CHAR;
      LNSTATUS                      NUMBER;
      LSSTATUSDESC                  VARCHAR2( 60 );
      LSPARTNO                      VARCHAR2( 18 );
      LNREVISION                    NUMBER;
      LSPREVDATE                    VARCHAR2( 18 );
      LNEXEMNO                      NUMBER;
      LNREASONID                    NUMBER;
      LSSPECIFICATIONDESC           VARCHAR2( 60 );
      LSOWNERDESCR                  VARCHAR2( 255 );
      LSPLANNEDEFFECTIVEDATE        VARCHAR2( 40 );
      LSWORKFLOWGROUPDESC           VARCHAR2( 60 );
      LNWORKFLOWGROUPID             NUMBER;
      LSREASONFORISSUE              VARCHAR2( 2000 );
      LSSUBMITTER                   VARCHAR2( 40 );
      LSEXEMPTIONDESCR              VARCHAR2( 60 );
      LSEXEMPTIONTEXT               CLOB;
      LSEXEMPTIONFROM               VARCHAR2( 40 );
      LSEXEMPTIONTO                 VARCHAR2( 40 );
      LNLOCALUSERGROUP              NUMBER;      
      
      
      LDDATEINDEV                   DATE;
      
      LNNBRMAILS                    NUMBER := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSPASSWORD                    IAPITYPE.PASSWORD_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQMSGTOSEND( ANEMAILNO );

      FETCH LQMSGTOSEND
       INTO LCTYPE,
            LNSTATUS,
            LSPARTNO,
            LNREVISION,
            LSPREVDATE,
            LNEXEMNO,
            LNREASONID,
            LSUSERID,
            LSPASSWORD;

      CLOSE LQMSGTOSEND;

      
      IF    LCTYPE = 'D'
         OR LCTYPE = 'E'
      THEN
         LNSTATUS := -1;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Type <'
                           || LCTYPE
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF LCTYPE = 'P'
      THEN
         LNRETVAL := GETPASSWORDMAIL( ANEMAILNO,
                                      ASSUBJECT,
                                      ASBODY,
                                      LSUSERID,
                                      LSPASSWORD,
                                      ATRECIPIENTS,


                                      ANNUMBERRECIPIENTS );

         LNNBRMAILS := ANNUMBERRECIPIENTS;
         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
      ELSE
         OPEN LQVALUESTOSEND( LSPARTNO,
                              LNREVISION,
                              LNREASONID );

         FETCH LQVALUESTOSEND
          INTO LSSPECIFICATIONDESC,
               LSPLANNEDEFFECTIVEDATE,
               LSWORKFLOWGROUPDESC,
               LNWORKFLOWGROUPID,
               LSREASONFORISSUE,
               LSSUBMITTER,
               LSOWNERDESCR;

         CLOSE LQVALUESTOSEND;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'WorkflowGroupId <'
                              || LNWORKFLOWGROUPID
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         IF LNWORKFLOWGROUPID IS NULL
         THEN
            RETURN 0;
         END IF;

         IF LCTYPE = 'S'
         THEN
            ASBODY :=    'Part = '
                      || LSPARTNO
                      || ' ['
                      || LSSPECIFICATIONDESC
                      || ']'
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Revision = '
                      || LNREVISION
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Owner = '
                      || LSOWNERDESCR
                      || CHR( 10 )
                      || CHR( 13 );
            ASBODY :=    ASBODY
                      || 'Planned Effective = '
                      || LSPLANNEDEFFECTIVEDATE
                      || UTL_TCP.CRLF
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Reason = '
                      || LSREASONFORISSUE;
            ASBODY :=    ASBODY
                      || F_AO_GET_MAIL( LCTYPE,
                                        LSPARTNO,
                                        LNREVISION );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Status <'
                                 || LNSTATUS
                                 || '>',
                                 IAPICONSTANT.INFOLEVEL_3 );

            BEGIN
               SELECT EMAIL_TITLE
                 INTO ASSUBJECT
                 FROM STATUS
                WHERE STATUS = LNSTATUS;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ASSUBJECT :=    'Invalid status <'
                               || LNSTATUS
                               || '>';
            END;
         ELSIF LCTYPE = 'D'
         THEN
            ASBODY :=    'Part = '
                      || LSPARTNO
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Revision = '
                      || LNREVISION
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Description = '
                      || LSSPECIFICATIONDESC
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Owner = '
                      || LSOWNERDESCR
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Previous Planned Effective = '
                      || LSPREVDATE
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Planned Effective = '
                      || LSPLANNEDEFFECTIVEDATE
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Workflow Group = '
                      || LSWORKFLOWGROUPDESC
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Reason = '
                      || LSREASONFORISSUE;
            LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'plan_eff_email',
                                                             ASPARAMETERDATA => ASSUBJECT );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
         ELSIF    LCTYPE = 'E'
               OR LCTYPE = 'C'
         THEN
            SELECT DESCRIPTION,
                   TEXT,
                   TO_CHAR( FROM_DATE,
                            'dd/Mon/yyyy' ),
                   TO_CHAR( TO_DATE,
                            'dd/Mon/yyyy' )
              INTO LSEXEMPTIONDESCR,
                   LSEXEMPTIONTEXT,
                   LSEXEMPTIONFROM,
                   LSEXEMPTIONTO
              FROM EXEMPTION
             WHERE PART_NO = LSPARTNO
               AND PART_EXEMPTION_NO = LNEXEMNO;

            ASBODY :=    'Part = '
                      || LSPARTNO
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Owner = '
                      || LSOWNERDESCR
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Description = '
                      || LSSPECIFICATIONDESC
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Exemption Description = '
                      || LSEXEMPTIONTEXT
                      || UTL_TCP.CRLF;
            ASBODY :=    ASBODY
                      || 'Exemption '
                      || LSEXEMPTIONFROM
                      || ' To '
                      || LSEXEMPTIONTO;

            IF LCTYPE = 'C'
            THEN
               LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'exemp_changed_email',
                                                                ASPARAMETERDATA => ASSUBJECT );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
               END IF;
            ELSE
               LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'exemp_raised_email',
                                                                ASPARAMETERDATA => ASSUBJECT );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
               END IF;
            END IF;
         ELSE
            ASBODY :=    'Unsupported email-type, email-no: '
                      || ANEMAILNO;
         END IF;

         BEGIN
            SELECT DESCRIPTION
              INTO LSSTATUSDESC
              FROM STATUS
             WHERE STATUS = LNSTATUS;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LSSTATUSDESC :=    'Invalid status <'
                               || LNSTATUS
                               || '>';
         END;

         ASSUBJECT :=    LSPARTNO
                     
                      || '[' || LNREVISION || ']'
                      || ' '
                      || LSSPECIFICATIONDESC
                      || ' ('
                      || LSSTATUSDESC
                      || '): '
                      || ASSUBJECT;
         LNNBRMAILS := 0;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Subject <'
                              || ASSUBJECT
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Body <'
                              || SUBSTR( ASBODY,
                                         1,
                                         1000 )
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'lnStatus <'
                              || LNSTATUS
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         FOR LRLISTUSERGROUPS IN LQLISTUSERGROUPS( LNWORKFLOWGROUPID,
                                                   LNSTATUS )
         LOOP
            IF LRLISTUSERGROUPS.USER_GROUP_ID IS NULL
            THEN   
               ANNUMBERRECIPIENTS := 0;
               RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
            END IF;

            IF LRLISTUSERGROUPS.USER_GROUP_ID = -1
            THEN
               SELECT MAX( STATUS_DATE_TIME )                 
                 
                 
                 INTO LDDATEINDEV
                 
                 FROM STATUS_HISTORY A,
                      STATUS S
                WHERE PART_NO = LSPARTNO
                  AND REVISION = LNREVISION
                  AND A.STATUS = S.STATUS
                  AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT;

              
               
               
               
               
               
               
               SELECT MAX( RTRIM( LTRIM(   U.EMAIL_ADDRESS
                           || DECODE( SIGN( INSTR( U.EMAIL_ADDRESS,
                                                  '@' ) ),
                                      0, I.PARAMETER_DATA ) ) ))
               
                 INTO ATRECIPIENTS( 1 )
                 FROM STATUS_HISTORY A,
                      APPLICATION_USER U,
                      INTERSPC_CFG I,
                      STATUS S
                WHERE A.PART_NO = LSPARTNO
                  AND A.REVISION = LNREVISION
                  AND A.STATUS = S.STATUS
                  AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_SUBMIT
                  AND A.STATUS_DATE_TIME =
                         ( SELECT MIN( STATUS_DATE_TIME )
                            FROM STATUS_HISTORY B,
                                 STATUS S
                           WHERE B.PART_NO = A.PART_NO
                             AND B.REVISION = A.REVISION
                             AND B.STATUS = S.STATUS
                             AND S.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_SUBMIT                             
                             
                             
                             AND B.STATUS_DATE_TIME >= LDDATEINDEV )
                             
                  AND U.USER_ID = A.USER_ID
                  AND I.PARAMETER(+) = 'def_email_ext';

               IF ATRECIPIENTS( 1 ) IS NOT NULL
               THEN

                    
                    
                    IF (ISVALIDEMAILADDRESS( RTRIM( LTRIM( ATRECIPIENTS( 1 ) ) ) ) = TRUE)
                    THEN
                    
                        LNNBRMAILS := 1;
                    
                    ELSE
                        LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDEMAILADDRESS2,
                                                              ATRECIPIENTS( 1 ));
                        IAPIGENERAL.LOGERROR( GSSOURCE,
                                              LSMETHOD,
                                              IAPIGENERAL.GETLASTERRORTEXT( ) );
                    END IF;
                    
               ELSE
                  LNNBRMAILS := 0;
               END IF;
            ELSE

               IF LCTYPE = 'S'
               THEN
                  FOR LRLISTMAIL IN  LQLIST_APPROVERSELECTED_MAILTO( LSPARTNO,
                                                                     LNREVISION,
                                                                     
                                                                     
                                                                     LRLISTUSERGROUPS.USER_GROUP_ID,
                                                                     LNSTATUS)
                                                                     
                  LOOP
                     IF LRLISTMAIL.C_MAIL_TO IS NOT NULL
                      THEN




                        
                        
                        IF (ISVALIDEMAILADDRESS( RTRIM( LTRIM( LRLISTMAIL.C_MAIL_TO ) ) ) = TRUE)
                        THEN
                        
                            LNNBRMAILS :=   LNNBRMAILS
                                          + 1;
                            ATRECIPIENTS( LNNBRMAILS ) := RTRIM( LTRIM( LRLISTMAIL.C_MAIL_TO ) );
                        
                        ELSE
                            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDEMAILADDRESS2,
                                                                  LRLISTMAIL.C_MAIL_TO);
                            IAPIGENERAL.LOGERROR( GSSOURCE,
                                                  LSMETHOD,
                                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
                        END IF;
                        
                     END IF;
                  END LOOP;
               ELSE

                  FOR LRLISTMAIL IN LQLISTMAILTO( LRLISTUSERGROUPS.USER_GROUP_ID )
                  LOOP
                     IF LRLISTMAIL.C_MAIL_TO IS NOT NULL
                     THEN




                        
                        
                        IF (ISVALIDEMAILADDRESS( RTRIM( LTRIM( LRLISTMAIL.C_MAIL_TO ) ) ) = TRUE)
                        THEN
                        
                            LNNBRMAILS :=   LNNBRMAILS
                                          + 1;
                            ATRECIPIENTS( LNNBRMAILS ) := RTRIM( LTRIM( LRLISTMAIL.C_MAIL_TO ) );
                        
                        ELSE
                            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDEMAILADDRESS2,
                                                                  LRLISTMAIL.C_MAIL_TO);
                            IAPIGENERAL.LOGERROR( GSSOURCE,
                                                  LSMETHOD,
                                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
                        END IF;
                        
                     END IF;
                  END LOOP;
               END IF;
            END IF;
         END LOOP;
      END IF;

      
      ANNUMBERRECIPIENTS := LNNBRMAILS;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ANNUMBERRECIPIENTS := -1;
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMAIL;

   
   FUNCTION SENDEMAILS
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQMAIL
      IS
         SELECT EMAIL_NO
           FROM ITEMAIL;

      LSSUBJECT                     VARCHAR2( 255 );
      LSBODY                        CLOB;
      LTTO                          IAPITYPE.EMAILTOTAB_TYPE;
      LNRET                         NUMBER;
      LSALERTMESSAGE                VARCHAR2( 200 );
      LISTATUS                      INTEGER;
      LSEMAILSENDER                 INTERSPC_CFG.PARAMETER_DATA%TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SendEmails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSTO                          IAPITYPE.EMAILTOTAB_TYPE;
      LBFIRSTTIME                   BOOLEAN := TRUE;
       
       
      
      
      
      
      
      
      
      BEGIN
      
      
      
      DBMS_APPLICATION_INFO.SET_MODULE( 'MAIL JOB',
                                        NULL );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'email_sender',
                                                       ASPARAMETERDATA => LSEMAILSENDER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         
         LSEMAILSENDER := NULL;
      END IF;

      DBMS_ALERT.REGISTER( 'MAIL' );

      LOOP
         DBMS_APPLICATION_INFO.SET_ACTION( 'MAIL IS WAITING ...' );

         IF LBFIRSTTIME
         THEN
            LBFIRSTTIME := FALSE;
            LISTATUS := 0;
            LSALERTMESSAGE := '1';
         ELSE
            
            DBMS_ALERT.WAITONE( 'MAIL',
                                LSALERTMESSAGE,
                                LISTATUS,
                                120 );
         END IF;

         IF LISTATUS = 0
         THEN
            CASE LSALERTMESSAGE
               WHEN 'ENABLELOGGING'
               THEN
                  IAPIGENERAL.ENABLELOGGING;
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Logging enabled',
                                       IAPICONSTANT.INFOLEVEL_3 );
               WHEN 'DISABLELOGGING'
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Logging disabled',
                                       IAPICONSTANT.INFOLEVEL_3 );
                  IAPIGENERAL.DISABLELOGGING;
               WHEN '2'
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Stop processing e-mails' );
                  EXIT;
               WHEN '1'
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          'Start processing e-mails, sender <'
                                       || LSEMAILSENDER
                                       || '>' );

                  FOR LNROW IN LQMAIL
                  LOOP
                     LNRETVAL := IAPIEMAIL.GETMAIL( LNROW.EMAIL_NO,
                                                    LSSUBJECT,
                                                    LSBODY,
                                                    LTTO,
                                                    LNRET );
                     LNRETVAL := NULL;




                    
                    








                                

























                         
                         IF LNRET <> 0
                         THEN
                            LNRETVAL := IAPIEMAIL.SENDEMAIL( LSEMAILSENDER,
                                                             LTTO,
                                                             LSSUBJECT,
                                                             LSBODY,
                                                             LNRET );

                            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                            THEN
                               IAPIGENERAL.LOGERROR( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
                               RETURN( LNRETVAL );
                            END IF;
                         END IF;

                         DELETE FROM ITEMAIL
                               WHERE EMAIL_NO = LNROW.EMAIL_NO;

                         COMMIT;







                  END LOOP;
               ELSE
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          'Unknown alert <'
                                       || LSALERTMESSAGE
                                       || '> received',
                                       IAPICONSTANT.INFOLEVEL_3 );
            END CASE;
         END IF;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END SENDEMAILS;


   
   
   FUNCTION ISVALIDEMAILADDRESS(
      ASEMAILADDRESS IN IAPITYPE.EMAILTO_TYPE)
      RETURN BOOLEAN
   IS
        CSEMAILREGEXP CONSTANT IAPITYPE.STRING_TYPE := '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+([A-Z]{2}|arpa|biz|com|info|intww|name|net|org|pro|aero|asia|cat|coop|edu|gov|jobs|mil|mobi|museum|pro|tel|travel|post)$';
   BEGIN
         IF REGEXP_LIKE(ASEMAILADDRESS, CSEMAILREGEXP, 'i')
         THEN
             RETURN TRUE;
         
         
         END IF;

         RETURN FALSE;
   END ISVALIDEMAILADDRESS;
   

END IAPIEMAIL;