create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $
unldap AS

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_ev_details      VARCHAR2(255);
l_ret_code        NUMBER;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_ev_seq_nr       NUMBER;
StpError          EXCEPTION;

--internal function for tracing/logging in autonomous transaction
PROCEDURE TraceError
(a_api_name     IN        VARCHAR2,    /* VC40_TYPE */
 a_error_msg    IN        VARCHAR2)    /* VC255_TYPE */
IS
PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
   --autonomous transaction used here
   --UNAPIGEN.LogError is also an autonomous transaction but may rollback the current transaction
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES (UNAPIGEN.P_CLIENT_ID, SUBSTR(UNAPIGEN.P_APPLIC_NAME,1,8), NVL(UNAPIGEN.P_USER,USER), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           SUBSTR(a_api_name,1,40), SUBSTR(a_error_msg,1,255));
   COMMIT;
END TraceError;

--PUBLIC functions

FUNCTION GetUserList                                          /* INTERNAL */
(a_dn            OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_display_name  OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_connect_id    OUT     UNAPIGEN.VC20_TABLE_TYPE,            /* VC20_TABLE_TYPE */
 a_email         OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                              /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                            /* VC511_TYPE */
RETURN NUMBER IS

l_retval         INTEGER;
l_ladp_session   DBMS_LDAP.session;
l_ladp_attrs     DBMS_LDAP.string_collection;
l_ladp_message   DBMS_LDAP.message;
l_ladp_entry     DBMS_LDAP.message;
l_entry_index    INTEGER;
l_ladp_dn        VARCHAR2(256);
l_ladp_attr_name VARCHAR2(256);
l_ladp_ber_elmt  DBMS_LDAP.ber_element;
attr_index       INTEGER;
i                INTEGER;
l_ladp_vals      DBMS_LDAP.STRING_COLLECTION ;
l_ldap_host      VARCHAR2(256);
l_ldap_port      VARCHAR2(256);
l_ldap_user      VARCHAR2(256);
l_ldap_passwd    VARCHAR2(256);
l_ldap_base      VARCHAR2(256);
l_bound          BOOLEAN;

BEGIN

   l_bound := FALSE;
   --a_where_clause is left for future extension (will be necessary)
   IF NVL(a_nr_of_rows, 0) = 0 THEN
      a_nr_of_rows := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF a_nr_of_rows < 0 OR a_nr_of_rows > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   --defaults and initialisations
   l_retval         := -1;
   l_ldap_host  := 'scd2ldap.siemens.net' ;
   l_ldap_port  := '389';
   --l_ldap_user  := 'cn=orcladmin';
   --l_ldap_passwd:= 'welcome';
   l_ldap_base  := 'c=BE';

   DBMS_OUTPUT.PUT('DBMS_LDAP Search to directory ' || l_ldap_host || ' LDAP Port : ' || l_ldap_port);

   -- Choosing exceptions to be raised by DBMS_LDAP library.
   DBMS_LDAP.USE_EXCEPTION := TRUE;

   --OPEN the session and bind to the directory
   l_ladp_session := DBMS_LDAP.init(l_ldap_host,l_ldap_port);
   --DBMS_OUTPUT.PUT_LINE(UNAPIGEN.Cx_RPAD('Ldap session ',25,' ')  || ': ' || RAWTOHEX(SUBSTR(l_ladp_session,1,8)) || '(returned from init)');
   l_retval := DBMS_LDAP.simple_bind_s(l_ladp_session, l_ldap_user, l_ldap_passwd);
   l_bound := TRUE;

   --when SSL port has to be used: use this open function instead
   --l_retval := DBMS_LDAP.open_ssl(l_ladp_session, null, null, 1);

   -- DBMS_OUTPUT.PUT_LINE(UNAPIGEN.Cx_RPAD('open_ssl Returns ',25,' ') || ': ' || TO_CHAR(l_retval));

   -- issue the search
   --list of attributes to be retrieved
   l_ladp_attrs(1) := 'scdId';         --used as a_connect_id
   l_ladp_attrs(2) := 'displayName';   --Used as a_display_name
   l_ladp_attrs(3) := 'mail';          --Used as a_email

   l_retval := DBMS_LDAP.search_s(l_ladp_session, l_ldap_base,
                                  DBMS_LDAP.SCOPE_SUBTREE,
                                  'department=A&DAS*',
                                  l_ladp_attrs,
                                  0,
                                  l_ladp_message);

   --DBMS_OUTPUT.PUT_LINE(UNAPIGEN.Cx_RPAD('search_s Returns ',25,' ') || ': ' || TO_CHAR(l_retval));
   --DBMS_OUTPUT.PUT_LINE (UNAPIGEN.Cx_RPAD('LDAP message  ',25,' ')  || ': ' || RAWTOHEX(SUBSTR(l_ladp_message,1,8)) || '(returned from search_s)');

   -- count the number of entries returned
   l_retval := DBMS_LDAP.count_entries(l_ladp_session, l_ladp_message);
   -- DBMS_OUTPUT.PUT_LINE(UNAPIGEN.Cx_RPAD('Number of Entries ',25,' ') || ': ' || TO_CHAR(l_retval));
   -- DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');


   -- get the first entry
   l_ladp_entry := DBMS_LDAP.first_entry(l_ladp_session, l_ladp_message);
   l_entry_index := 0;

   -- Loop through each of the entries one by one
   WHILE l_ladp_entry IS NOT NULL AND
         l_entry_index <= a_nr_of_rows LOOP

      l_entry_index := l_entry_index+1;
      -- get the dn
      a_dn(l_entry_index) := DBMS_LDAP.get_dn(l_ladp_session, l_ladp_entry);
      --initialise all other elements (attribute might be not present)
      a_connect_id(l_entry_index) := NULL;
      a_display_name(l_entry_index) := NULL;
      a_email(l_entry_index) := NULL;

      -- DBMS_OUTPUT.PUT_LINE ('        entry #' || TO_CHAR(l_entry_index) ||
      -- ' entry ptr: ' || RAWTOHEX(SUBSTR(l_ladp_entry,1,8)));
      --DBMS_OUTPUT.PUT_LINE ('        dn: ' || a_dn(l_entry_index));
      l_ladp_attr_name := DBMS_LDAP.first_attribute(l_ladp_session,l_ladp_entry, l_ladp_ber_elmt);
      attr_index := 1;
      WHILE l_ladp_attr_name IS NOT NULL LOOP
         l_ladp_vals := DBMS_LDAP.get_values (l_ladp_session, l_ladp_entry, l_ladp_attr_name);
         IF l_ladp_vals.COUNT > 0 THEN
            FOR i in l_ladp_vals.FIRST..l_ladp_vals.LAST loop
               --DBMS_OUTPUT.PUT_LINE('           ' || l_ladp_attr_name || ' : '||SUBSTR(l_ladp_vals(i),1,200));
               IF l_ladp_attr_name = 'scdId' THEN
                  --DBMS_OUTPUT.PUT_LINE('           ConnectId : '||'BE'||SUBSTR(l_ladp_vals(i),-6));
                  --
                  a_connect_id(l_entry_index) := 'BE'||SUBSTR(l_ladp_vals(i),-6);
               ELSIF l_ladp_attr_name = 'displayName' THEN
                  a_display_name(l_entry_index) := SUBSTR(l_ladp_vals(i),1,255);
               ELSIF l_ladp_attr_name = 'mail' THEN
                  a_email(l_entry_index) := SUBSTR(l_ladp_vals(i),1,255);
               END IF;
            END LOOP;
         END IF;
         l_ladp_attr_name := DBMS_LDAP.next_attribute(l_ladp_session,l_ladp_entry, l_ladp_ber_elmt);
         attr_index := attr_index+1;
      END LOOP;
      l_ladp_entry := DBMS_LDAP.next_entry(l_ladp_session, l_ladp_entry);
      --DBMS_OUTPUT.PUT_LINE('===================================================');

   END LOOP;

   -- unbind from the directory
   l_retval := DBMS_LDAP.unbind_s(l_ladp_session);
   --DBMS_OUTPUT.PUT_LINE(UNAPIGEN.Cx_RPAD('unbind_res Returns ',25,' ') ||  ': ' || TO_CHAR(l_retval));
   --DBMS_OUTPUT.PUT_LINE('Directory operation Successful .. exiting');
   a_nr_of_rows := l_entry_index;
   IF a_nr_of_rows>0 THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_NORECORDS);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF l_bound THEN
      BEGIN
         l_retval := DBMS_LDAP.unbind_s(l_ladp_session);
      EXCEPTION
      WHEN OTHERS THEN
         TraceError('UNLDAP.GetUserList', 'Unbind from ldap server failed');
      END;
   END IF;
   -- Handle Exceptions

   -- DBMS_OUTPUT.PUT_LINE(' Error code    : ' || TO_CHAR(SQLCODE));
   -- DBMS_OUTPUT .PUT_LINE(' Error Message : ' || SQLERRM);
   -- DBMS_OUTPUT.PUT_LINE(' Exception encountered .. exiting');
   TraceError('UNLDAP.GetUserList', SUBSTR(SQLERRM,1,200));
   RETURN(UNAPIGEN.DBERR_GENFAIL);

END GetUserList;

END unldap;