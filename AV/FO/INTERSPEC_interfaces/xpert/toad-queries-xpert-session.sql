/* Formatted on 24/04/2023 08:53:32 (QP5 v5.391) */
BEGIN
    :RetVal := AAPISPECTRAC.SETAPPLIC ('Xpert_PCR_2.13.9');
END;

/* Formatted on 24/04/2023 08:54:15 (QP5 v5.391) */
BEGIN
    :RetVal := aapiSpectrac.LOGON ('Xpert_PCR_2.13.9');
END;

/* Formatted on 24/04/2023 08:54:25 (QP5 v5.391) */
BEGIN
    :RetVal := aapiSpectrac.LOGON ( :ASAPPLIC, :ANMODE);
END;

/* Formatted on 24/04/2023 08:54:36 (QP5 v5.391) */
DELETE SPEC_ACCESS
 WHERE USER_ID = :B1
 
/* Formatted on 24/04/2023 08:54:44 (QP5 v5.391) */
INSERT INTO AT_SESSIONS
     VALUES ( :B1,
             :B2,
             :B3,
             :B4,
             :B5,
             :B6,
             :B7,
             :B8,
             :B9,
             :B10)

/* Formatted on 24/04/2023 08:54:54 (QP5 v5.391) */
INSERT INTO SPEC_ACCESS (USER_ID,
                         ACCESS_GROUP,
                         MRP_UPDATE,
                         PLAN_ACCESS,
                         PROD_ACCESS,
                         PHASE_ACCESS)
      SELECT DISTINCT :B1,
                      AG.ACCESS_GROUP,
                      MAX (UAG.MRP_UPDATE),
                      MAX (NVL (AU.PLAN_ACCESS, 'N')),
                      MAX (NVL (AU.PROD_ACCESS, 'N')),
                      MAX (NVL (AU.PHASE_ACCESS, 'N'))
        FROM ACCESS_GROUP     AG,
             USER_GROUP_LIST  UGL,
             USER_ACCESS_GROUP UAG,
             USER_GROUP       UG,
             APPLICATION_USER AU
       WHERE     (AG.ACCESS_GROUP = UAG.ACCESS_GROUP)
             AND (UG.USER_GROUP_ID = UAG.USER_GROUP_ID)
             AND (UGL.USER_GROUP_ID = UG.USER_GROUP_ID)
             AND (UGL.USER_ID = AU.USER_ID)
             AND (UGL.USER_ID = :B1)
    GROUP BY :B1, AG.ACCESS_GROUP

/* Formatted on 24/04/2023 08:55:04 (QP5 v5.391) */
SELECT *
  FROM V$SESSION SES
 WHERE SES.SID = (SELECT DISTINCT SID
                    FROM V$MYSTAT)


/* Formatted on 24/04/2023 08:55:12 (QP5 v5.391) */
SELECT 1
  FROM DBA_ROLE_PRIVS
 WHERE GRANTEE = USER AND GRANTED_ROLE IN ('DBA', 'INTERSPCDBA')

/* Formatted on 24/04/2023 08:55:34 (QP5 v5.391) */
SELECT COUNT (*)
  FROM APPLICATION_USER
 WHERE USER_ID = :B1

/* Formatted on 24/04/2023 08:55:41 (QP5 v5.391) */
SELECT COUNT (*)
  FROM ITUSPREF
 WHERE USER_ID = UPPER ( :B3) AND SECTION_NAME = :B2 AND PREF = :B1

 /* Formatted on 24/04/2023 08:55:49 (QP5 v5.391) */
SELECT COUNT (*)
  FROM SPECIFICATION_HEADER H, SPEC_ACCESS A
 WHERE     H.ACCESS_GROUP = A.ACCESS_GROUP
       AND A.USER_ID = :B3
       AND H.PART_NO = :B2
       AND H.REVISION = :B1
	   
/* Formatted on 24/04/2023 08:55:56 (QP5 v5.391) */
SELECT COUNT (0) + 1 FROM CTLICUSERCNT

/* Formatted on 24/04/2023 08:56:03 (QP5 v5.391) */
SELECT DB_TYPE,
       ALLOW_GLOSSARY,
       ALLOW_FRAME_CHANGES,
       ALLOW_FRAME_EXPORT
  FROM ITDBPROFILE
 WHERE OWNER = :B1

 /* Formatted on 24/04/2023 08:56:16 (QP5 v5.391) */
SELECT FORENAME,
       LAST_NAME,
       USER_INITIALS,
       TELEPHONE_NO,
       EMAIL_ADDRESS,
       DECODE (CURRENT_ONLY, 'Y', 1, 0),
       INITIAL_PROFILE,
       USER_PROFILE,
       DECODE (USER_DROPPED, 'Y', 1, 0),
       DECODE (PROD_ACCESS, 'Y', 1, 0),
       DECODE (PLAN_ACCESS, 'Y', 1, 0),
       DECODE (PHASE_ACCESS, 'Y', 1, 0),
       DECODE (INTL, 'Y', 1, 0),
       DECODE (REFERENCE_TEXT, 'Y', 1, 0),
       DECODE (APPROVED_ONLY, 'Y', 1, 0),
       LOC_ID,
       CAT_ID,
       DECODE (OVERRIDE_PART_VAL, 'Y', 1, 0),
       DECODE (WEB_ALLOWED, 'Y', 1, 0),
       DECODE (LIMITED_CONFIGURATOR, 'Y', 1, 0),
       DECODE (PLANT_ACCESS, 'Y', 1, 0),
       DECODE (VIEW_BOM, 'Y', 1, 0),
       VIEW_PRICE,
       OPTIONAL_DATA,
       DECODE (HISTORIC_ONLY, 'Y', 1, 0)
  FROM APPLICATION_USER
 WHERE USER_ID = :B1
 
/* Formatted on 24/04/2023 08:56:26 (QP5 v5.391) */
SELECT IT_SESSION_SEQ.NEXTVAL FROM DUAL

/* Formatted on 24/04/2023 08:56:33 (QP5 v5.391) */
SELECT OWNER
  FROM DBA_OBJECTS
 WHERE OBJECT_NAME = 'IAPIDATABASE' AND OBJECT_TYPE = 'PACKAGE'

 /* Formatted on 24/04/2023 08:56:40 (QP5 v5.391) */
SELECT PARAMETER, VALUE
  FROM NLS_INSTANCE_PARAMETERS
 WHERE VALUE IS NOT NULL
 
 /* Formatted on 24/04/2023 08:56:47 (QP5 v5.391) */
SELECT PARAMETER, VALUE
  FROM SYS.NLS_DATABASE_PARAMETERS
 WHERE PARAMETER IN ('NLS_CHARACTERSET', 'NLS_NCHAR_CHARACTERSET')
 
 /* Formatted on 24/04/2023 08:56:53 (QP5 v5.391) */
SELECT PARAMETER_DATA
  FROM INTERSPC_CFG
 WHERE SECTION = :B2 AND PARAMETER = :B1
 
 
/* Formatted on 24/04/2023 08:56:59 (QP5 v5.391) */
SELECT PROGRAM
  FROM V$SESSION
 WHERE AUDSID = USERENV ('sessionid')

/* Formatted on 24/04/2023 08:57:11 (QP5 v5.391) */
SELECT TO_NUMBER (VALUE)
  FROM ITUSPREF
 WHERE USER_ID = :B1 AND SECTION_NAME = 'General' AND PREF = 'Trace'
 
/* Formatted on 24/04/2023 08:57:22 (QP5 v5.391) */
SELECT USER_PROFILE
  FROM APPLICATION_USER
 WHERE USER_ID = USER

 /* Formatted on 24/04/2023 08:58:30 (QP5 v5.391) */
SELECT VALUE
  FROM ITUSPREF
 WHERE USER_ID = UPPER ( :B3) AND SECTION_NAME = :B2 AND PREF = :B1
 
/* Formatted on 24/04/2023 08:58:36 (QP5 v5.391) */
UPDATE AT_SESSIONS SES1
   SET SES1.SES_LOGOFF_DATE = SYSDATE
 WHERE     SES1.SES_LOGOFF_DATE IS NULL
       AND NOT EXISTS
               (SELECT 1
                  FROM V$SESSION SES2
                 WHERE     SES2.SID = SES1.SES_SID
                       AND SES2.LOGON_TIME = SES1.SES_LOGON_DATE)

/* Formatted on 24/04/2023 08:58:43 (QP5 v5.391) */
DECLARE
    r_oss   v$session%ROWTYPE;
BEGIN
    SELECT *
      INTO r_oss
      FROM v$session ses
     WHERE ses.sid = (SELECT DISTINCT sid
                        FROM v$mystat);

    --
    IF UPPER (r_oss.program) IN ('INTERCFG.EXE',
                                 'INTERFRM.EXE',
                                 'INTERSPC.EXE',
                                 'EXCEL.EXE')
    THEN
        interspc.aapisession.LOGON (p_sid          => r_oss.sid,
                                    p_osuser       => r_oss.osuser,
                                    p_machine      => r_oss.machine,
                                    p_terminal     => r_oss.terminal,
                                    p_program      => r_oss.program,
                                    p_logon_date   => r_oss.logon_time);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;

/* Formatted on 24/04/2023 08:58:52 (QP5 v5.391) */
DECLARE
    lnRetVal    NUMBER;
    lsProgram   VARCHAR2 (256);
BEGIN
    IF USERENV ('sessionid') <> 0
    THEN
        SELECT PROGRAM
          INTO lsProgram
          FROM V$SESSION
         WHERE AUDSID = USERENV ('sessionid');

        IF LOWER (lsProgram) IN ('busobj.exe',
                                 'fcproc.exe',
                                 'jobserverchild.exe',
                                 'wireportserver.exe')
        THEN
            iapigeneral.enablelogging ();
            iapigeneral.loginfo ('RmApi_ReportManager',
                                 'RGI_OnLogon',
                                 'SETCONNECTION(' || USER || ')',
                                 iapiConstant.INFOLEVEL_3);
            iapigeneral.disablelogging ();
            lnRetVal := IAPIGENERAL.SETCONNECTION (USER, 'Report Manager');
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;

/* Formatted on 24/04/2023 08:59:02 (QP5 v5.391) */
    SELECT /*+ connect_by_filtering */
           privilege#, LEVEL
      FROM sysauth$
CONNECT BY grantee# = PRIOR privilege# AND privilege# > 0
START WITH grantee# = :1 AND privilege# > 0

/* Formatted on 24/04/2023 08:59:10 (QP5 v5.391) */
SELECT SYS_CONTEXT ('USERENV', 'SERVER_HOST'),
       SYS_CONTEXT ('USERENV', 'DB_UNIQUE_NAME'),
       SYS_CONTEXT ('USERENV', 'INSTANCE_NAME'),
       SYS_CONTEXT ('USERENV', 'SERVICE_NAME'),
       INSTANCE_NUMBER,
       STARTUP_TIME,
       SYS_CONTEXT ('USERENV', 'DB_DOMAIN')
  FROM v$instance
 WHERE INSTANCE_NAME = SYS_CONTEXT ('USERENV', 'INSTANCE_NAME')

 /* Formatted on 24/04/2023 08:59:18 (QP5 v5.391) */
SELECT DECODE (failover_method,
               NULL, 0,
               'BASIC', 1,
               'PRECONNECT', 2,
               'PREPARSE', 4,
               0),
       DECODE (failover_type,
               NULL, 1,
               'NONE', 1,
               'SESSION', 2,
               'SELECT', 4,
               1),
       failover_retries,
       failover_delay,
       flags
  FROM service$
 WHERE name = :1
 
 /* Formatted on 24/04/2023 08:59:25 (QP5 v5.391) */
SELECT role#
  FROM defrole$ d, user$ u
 WHERE d.user# = :1 AND u.user# = d.user# AND u.defrole = 2
UNION
SELECT privilege#
  FROM sysauth$ s, user$ u
 WHERE     (grantee# = :1 OR grantee# = 1)
       AND privilege# > 0
       AND NOT EXISTS
               (SELECT NULL
                  FROM defrole$
                 WHERE user# = :1 AND role# = s.privilege#)
       AND u.user# = :1
       AND u.defrole = 3
	   
/* Formatted on 24/04/2023 08:59:38 (QP5 v5.391) */
UPDATE seq$
   SET increment$ = :2,
       minvalue = :3,
       maxvalue = :4,
       cycle# = :5,
       order$ = :6,
       cache = :7,
       highwater = :8,
       audit$ = :9,
       flags = :10
 WHERE obj# = :1

\ 
 
 
 
 