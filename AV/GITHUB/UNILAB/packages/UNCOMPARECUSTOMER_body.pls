create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $
uncomparecustomer AS

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(10000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_timed_event_tp  utevtimed.ev_tp%TYPE;
l_ret_code        NUMBER;
l_retcode         NUMBER;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_ev_seq_nr       NUMBER;
l_ev_details      VARCHAR2(255);
l_errm            VARCHAR2(255);
StpError          EXCEPTION;

FUNCTION GetCustomerList
(a_sc               IN VARCHAR2,/* VC20_TYPE */
 a_st               IN VARCHAR2,/* VC20_TYPE */
 a_st_version       IN VARCHAR2,/* VC20_TYPE */
 a_customer         OUT UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER                    /* NUM_TYPE */
)
RETURN NUMBER IS


l_fetched_rows NUMBER;
l_customer VARCHAR2(20);
l_pp_key4customer NUMBER;
l_cust_list_cursor INTEGER;
BEGIN
    l_pp_key4customer := UNAPIGEN.P_PP_KEY4CUSTOMER;
    IF l_pp_key4customer  = 0 THEN
       RETURN (UNAPIGEN.DBERR_SUCCESS);
    END IF;
    l_cust_list_cursor := DBMS_SQL.OPEN_CURSOR;

    l_sql_string := 'SELECT DISTINCT customer ' ||
                   ' FROM UTCOMPARECUSTOMER WHERE sc =  '''||REPLACE(a_sc, '''', '''''')  ||''' AND ' ||
               ' (pp, pp_key1, pp_key2 , pp_key3, pp_key4, pp_key5) IN ' ||
               ' (select  pp, pp_key1, pp_key2 , pp_key3, pp_key4, pp_key5 ' ||
                   ' FROM dd' || UNAPIGEN.P_DD ||
                   '.uvstpp  WHERE st = '''||REPLACE(a_st, '''', '''''')  || ''' AND version = '''|| a_st_version || ''')';

   DBMS_SQL.PARSE(l_cust_list_cursor, l_sql_string, DBMS_SQL.V7); -- NO single quote handling required
   DBMS_SQL.DEFINE_COLUMN(l_cust_list_cursor,  1,   l_customer ,  20);
   l_result := DBMS_SQL.EXECUTE_AND_FETCH(l_cust_list_cursor);
   l_fetched_rows := 0;
   LOOP
      EXIT WHEN (l_result = 0) OR (l_fetched_rows >= a_nr_of_rows);
      DBMS_SQL.COLUMN_VALUE(l_cust_list_cursor, 1   , l_customer        );
     IF (l_customer != ' ') THEN
         l_fetched_rows := l_fetched_rows + 1;
         a_customer       (l_fetched_rows) := l_customer         ;
     END IF;
      IF l_fetched_rows < a_nr_of_rows THEN
         l_result := DBMS_SQL.FETCH_ROWS(l_cust_list_cursor);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(l_cust_list_cursor);

   IF l_fetched_rows = 0 THEN
        a_nr_of_rows := 0;
      l_ret_code := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      a_nr_of_rows := l_fetched_rows;
      l_ret_code := UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN(l_ret_code);
EXCEPTION
   WHEN OTHERS THEN
      l_sqlerrm := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'GetCustomerList', l_sqlerrm);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(l_cust_list_cursor) THEN
         DBMS_SQL.CLOSE_CURSOR(l_cust_list_cursor);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GetCustomerList;

END uncomparecustomer;