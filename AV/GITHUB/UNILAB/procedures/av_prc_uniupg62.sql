--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure UNIUPG62
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."UNIUPG62" (
   a_tz_region        VARCHAR2,
   a_stop_timestamp   TIMESTAMP WITH TIME ZONE
)
IS
   TYPE tablecurtyp IS REF CURSOR;

   l_table_cur          tablecurtyp;
   l_select_cur         tablecurtyp;
   l_table_upg          VARCHAR2 (64);
   l_table_upg_hs       VARCHAR2 (64);
   l_row_limit          NUMBER;
   l_table_name         VARCHAR2 (64);
   l_col_name           VARCHAR2 (64);
   l_sql_stmt           VARCHAR2 (4000);
   l_where_clause       VARCHAR2 (1000);
   l_update_stmt        VARCHAR2 (4000);
   l_count              NUMBER;
   l_count_round        NUMBER;
   l_result             NUMBER;
   l_dyn_cursor         INTEGER;
   l_stop               BOOLEAN;
   l_table_stop         BOOLEAN;
   l_rowid              ROWID;
   l_session_timezone   VARCHAR2 (64);

   CURSOR c_tab_name (a_table_name VARCHAR2)
   IS
      SELECT COUNT (table_name)
        FROM user_tab_columns
       WHERE UPPER (table_name) = a_table_name;

   --utweeknr: the timestamps must remain in the dbtimezone in these 2 tables
   CURSOR c_tab_column (a_table_name VARCHAR2)
   IS
      SELECT column_name
        FROM user_tab_columns
       WHERE table_name = a_table_name
         AND table_name NOT IN ('UTWEEKNR', 'UTYEARNR')
         AND data_type LIKE 'TIMESTAMP%WITH LOCAL TIME ZONE'
         AND column_name NOT LIKE '%_TZ';

   PROCEDURE log_history (a_table_upg_hs VARCHAR2, a_hs VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE    'INSERT INTO '
                        || a_table_upg_hs
                        || ' VALUES (CURRENT_TIMESTAMP, :1)'
                  USING a_hs;
   END;
BEGIN
/******** CONSTANT ********/
   l_table_upg := 'UTUPGRADE62';                 -- name of the support table
   l_table_upg_hs := 'UTUPGRADE62HS';    -- name of the history support table
   l_row_limit := 1000;                     --number of row updated to commit

/******** INIT ********/
   SELECT SESSIONTIMEZONE
     INTO l_session_timezone
     FROM DUAL;

   EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';

/******** CHECK FOR UPGRADE TABLES ********/
/* check if the table UTUPGRADE62 exists */
/* if not, create it and initialise it with initial data */
   l_stop := FALSE;
   l_count := 0;

   OPEN c_tab_name (l_table_upg);                             -- support table

   LOOP
      FETCH c_tab_name
       INTO l_count;

      EXIT WHEN c_tab_name%NOTFOUND;
   END LOOP;

   CLOSE c_tab_name;

   IF (l_count = 0)
   THEN
      BEGIN
         l_sql_stmt :=
               'CREATE TABLE '
            || l_table_upg
            || ' (table_name VARCHAR2(64), upg_flag VARCHAR2(1), busy_flag VARCHAR2(1))';

         EXECUTE IMMEDIATE l_sql_stmt;

         l_dyn_cursor := DBMS_SQL.open_cursor;
         l_sql_stmt :=
               'INSERT INTO '
            || l_table_upg
            || ' SELECT DISTINCT (table_name), 0, 0 FROM user_tab_columns WHERE table_name LIKE ''UT%'' AND data_type LIKE ''TIMESTAMP%WITH LOCAL TIME ZONE'' AND table_name NOT IN (''UTWEEKNR'',''UTYEARNR'')';
         DBMS_SQL.parse (l_dyn_cursor, l_sql_stmt, DBMS_SQL.v7);
         l_result := DBMS_SQL.EXECUTE (l_dyn_cursor);
      EXCEPTION
         WHEN OTHERS
         THEN
            unapigen.logerror ('UniUpg62',
                               'Error creating support table ' || SQLERRM
                              );
            l_stop := TRUE;
      END;
   END IF;

   l_count := 0;

/* check if the table UTUPGRADE62HS exists */
/* if not, create it */
   OPEN c_tab_name (l_table_upg_hs);                   --history support table

   LOOP
      FETCH c_tab_name
       INTO l_count;

      EXIT WHEN c_tab_name%NOTFOUND;
   END LOOP;

   CLOSE c_tab_name;

   IF (l_count = 0)
   THEN
      BEGIN
         l_sql_stmt :=
               'CREATE TABLE '
            || l_table_upg_hs
            || ' (logdate TIMESTAMP WITH LOCAL TIME ZONE, descr VARCHAR2(4000))';

         EXECUTE IMMEDIATE l_sql_stmt;
      EXCEPTION
         WHEN OTHERS
         THEN
            unapigen.logerror ('UniUpg62',
                                  'Error creating history support table '
                               || SQLERRM
                              );
            l_stop := TRUE;
      END;
   END IF;

/* MAIN PART */
/******** START SCANNING ********/
   l_sql_stmt :=
         'SELECT table_name FROM '
      || l_table_upg
      || ' WHERE upg_flag = ''0'' ORDER BY busy_flag DESC';

   IF (CURRENT_TIMESTAMP > a_stop_timestamp)
   THEN                                            -- check if is time to exit
      l_stop := TRUE;
   END IF;

   OPEN l_table_cur FOR l_sql_stmt;

   LOOP
      FETCH l_table_cur
       INTO l_table_name;

      EXIT WHEN l_table_cur%NOTFOUND OR l_stop;
      --Set the we are working on that table
      l_sql_stmt :=
            'UPDATE '
         || l_table_upg
         || ' SET busy_flag = ''1'' WHERE table_name = :1';

      EXECUTE IMMEDIATE l_sql_stmt
                  USING l_table_name;

      COMMIT;
      --preparing the select for update statement
      l_count := 0;
      l_where_clause := ' WHERE ';
      l_update_stmt := 'UPDATE ' || l_table_name || ' SET ';

      FOR l_col_rec IN c_tab_column (l_table_name)
      LOOP
         l_col_name := l_col_rec.column_name;

         IF (l_count = 0)
         THEN
            l_count := l_count + 1;
            l_where_clause := l_where_clause || ' (';
         ELSE
            l_update_stmt := l_update_stmt || ', ';
            l_where_clause := l_where_clause || 'OR (';
         END IF;

         --build-up update statement
         l_update_stmt :=
               l_update_stmt
            || ' '
            || l_col_name
            || ' = DECODE ('
            || l_col_name
            || '_TZ, NULL, TO_TIMESTAMP_TZ(TO_CHAR('
            || l_col_name
            || ', ''DD/MM/YYYY HH24:MI:SS'')'
            || '||'' ' ||a_tz_region
            || ''',''DD/MM/YYYY HH24:MI:SS TZR''), '
            || l_col_name
            || '), '
            || l_col_name
            || '_TZ = DECODE ('
            || l_col_name
            || '_TZ, NULL, TO_TIMESTAMP_TZ(TO_CHAR('
            || l_col_name
            || ', ''DD/MM/YYYY HH24:MI:SS'')'
            || '||'' ' ||a_tz_region
            || ''',''DD/MM/YYYY HH24:MI:SS TZR''), '
            || l_col_name
            || '_TZ )';
         l_where_clause :=
               l_where_clause
            || l_col_name
            || ' IS NOT NULL AND '
            || l_col_name
            || '_TZ IS NULL ) ';
      END LOOP;

      l_sql_stmt :=
         'SELECT ROWID FROM ' || l_table_name || l_where_clause
         || ' FOR UPDATE';
      l_update_stmt := l_update_stmt || ' WHERE ROWID = :1';
      l_table_stop := FALSE;
      l_count_round := 0;
      l_count := 0;

      OPEN l_select_cur FOR l_sql_stmt;

      LOOP
         FETCH l_select_cur
          INTO l_rowid;

         EXIT WHEN l_select_cur%NOTFOUND OR l_table_stop;

         -- /******** UPDATATING THE TABLE ********/
         EXECUTE IMMEDIATE l_update_stmt
                     USING l_rowid;

         --log_history(l_table_upg_hs, l_update_stmt);
         l_count := l_count + 1;

         IF (l_count = l_row_limit)
         THEN                           -- every 'l_row_limit' rows we commit
            l_count := 0;
            l_count_round := l_count_round + 1;

            IF (CURRENT_TIMESTAMP > a_stop_timestamp)
            THEN                                  -- check if is time to exit
               l_table_stop := TRUE;
               l_stop := TRUE;
            END IF;

            log_history (l_table_upg_hs,
                            'TABLE '
                         || l_table_name
                         || ' UPDATED: '
                         || (l_count_round * l_row_limit)
                         || ' rows'
                        );
            COMMIT;
         END IF;
      END LOOP;

      IF NOT l_table_stop
      THEN
         log_history (l_table_upg_hs,
                         'TABLE '
                      || l_table_name
                      || ' UPDATED: '
                      || (((l_count_round) * l_row_limit) + l_count)
                      || ' rows'
                     );
         l_sql_stmt :=
               'UPDATE '
            || l_table_upg
            || ' SET busy_flag = ''0'', upg_flag = ''1'' WHERE table_name = :1';

         EXECUTE IMMEDIATE l_sql_stmt
                     USING l_table_name;

         COMMIT;
      END IF;
   END LOOP;

-- set the original session timezone
   EXECUTE IMMEDIATE    'ALTER SESSION SET time_zone = '''
                     || l_session_timezone
                     || '''';
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;

      -- set the original session timezone
      EXECUTE IMMEDIATE    'ALTER SESSION SET time_zone = '''
                        || l_session_timezone
                        || '''';

      unapigen.logerror ('UniUpg62', 'Error updating tables ' || SQLERRM);
      log_history (l_table_upg_hs, 'ERROR ' || SQLERRM);
      COMMIT;

      --CLOSE CURSOR
      IF c_tab_name%ISOPEN
      THEN
         CLOSE c_tab_name;
      END IF;

      IF c_tab_column%ISOPEN
      THEN
         CLOSE c_tab_column;
      END IF;

      IF l_table_cur%ISOPEN
      THEN
         CLOSE l_table_cur;
      END IF;

      IF l_select_cur%ISOPEN
      THEN
         CLOSE l_select_cur;
      END IF;
END;
 

/
