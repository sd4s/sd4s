--------------------------------------------------------
--  DDL for Package Body PA_LIMSDBLINK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "INTERSPC"."PA_LIMSDBLINK" IS

FUNCTION f_CreateDatabaseLink(
   a_link_name              IN     VARCHAR2,
   a_connection_string      IN     VARCHAR2,
   a_username               OUT    VARCHAR2,
   a_create_dblink_string   OUT    VARCHAR2
)
   RETURN BOOLEAN
IS

-- Constant variables for the tracing
l_classname   CONSTANT VARCHAR2(12)                      := 'LimsDBLink';
l_method      CONSTANT VARCHAR2(32)                      := 'f_CreateDatabaseLink';

l_dblink_user          VARCHAR2(30);
l_dblink_password      VARCHAR2(30);
l_sql_string           VARCHAR2(255);

BEGIN
   -- ******************************************************************************************
   -- This function will make it possible to the developper that want to support alternative ways
   -- for creating database links with very elaborated authentication techniques
   -- This function has been developped to be as generic as possible
   -- but some customisation might be necessary to support more complicated
   -- authentication methods
   --
   -- we are testing our software with fixed user links and connected user links
   -- (current_user links have not been tested explicitely but are expected to work)
   -- ******************************************************************************************
   -- Tracing
   PA_LIMS.p_Trace(l_classname, l_method, a_link_name, a_connection_string, NULL, PA_LIMS.c_Msg_Started);

   /*
   --
   --username and password can be specified in reference connection string
   -- get the user/pw of the dblink with as name the Unilab database. They will be used to create
   -- the database link LNK_LIMS and to set the connection with lims
   BEGIN
      SELECT MAX(userid), MAX(password)
      INTO l_dblink_user, l_dblink_password
      FROM sys.link$
      WHERE LOWER(host) LIKE LOWER(a_connection_string)||'%';
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      BEGIN
         --I don't like it but a some customer put a fix domain in theit connection string
         --instead of their sqlnet.ora, they have probaby good reasons to do it.
         --Modify domain name in function of your case when necessary
         SELECT MAX(userid), MAX(password)
         INTO l_dblink_user, l_dblink_password
         FROM sys.link$
         WHERE LOWER(host) LIKE LOWER(a_connection_string)||'%.world';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to get the user id and password of database link '||a_connection_string||'.');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END;
   END;
   */

   --Workaround on Oracle 10.2: hardcoded user/pass
   l_dblink_user := 'LIMS';
   l_dblink_password := 'l1ms';

   l_sql_string := 'CREATE DATABASE LINK '||a_link_name||' ';
   IF l_dblink_user IS NOT NULL THEN
      l_sql_string := l_sql_string || ' CONNECT TO "'||REPLACE(l_dblink_user,'''', '''''')||'" '; --Note: double quotes are important for case sensitive usernames in Oracle.
                                                                                                  --single quotes in userames is a bad practice but we try to do our best to support it.
   END IF;
   IF l_dblink_password IS NOT NULL THEN
      l_sql_string := l_sql_string || ' IDENTIFIED BY "'||REPLACE(l_dblink_password,'''', '''''')||'" '; --Note: double quotes here to be consistent with username ut password are not case sensitive in Oracle authentication maybe well in other authentication methods.
                                                                                                  --single quotes in userames is a bad practice but we try to do our best to support it.
   END IF;

   --add connection string
   l_sql_string := l_sql_string || ' USING '''||REPLACE(a_connection_string,'''', '''''')||''' '; --Note: single quotes in dblinks is a bad practice but we do our best to avoid problems.

   --return the connection string and the user to pass to do the SetConnection in Unilab (USER will be used when left empty)
   a_create_dblink_string := l_sql_string;
   a_username := NVL(l_dblink_user, USER);

   --we don't execute the create statement itslef, left to the calling function (don't do it)

   -- Tracing
   PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
   RETURN(TRUE);

END f_CreateDatabaseLink;


END PA_LIMSDBLink;

/
