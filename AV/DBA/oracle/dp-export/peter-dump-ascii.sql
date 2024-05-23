SET DEFINE OFF;
CREATE OR REPLACE DIRECTORY MST_DIR AS '/nfsshares/import';
--CREATE OR REPLACE DIRECTORY ETL_UNLOAD_DIR AS '/u01/etl/report';
--GRANT READ, WRITE ON DIRECTORY ETL_UNLOAD_DIR TO ETL;
 
CREATE OR REPLACE FUNCTION Dump_Delimited
   ( P_query                IN VARCHAR2
   , P_filename             IN VARCHAR2
   , P_column_delimiter     IN VARCHAR2    := ']['
   , P_row_delimiter        IN VARCHAR2    := ']'
   , P_comment              IN VARCHAR2    := NULL
   , P_write_rec_layout     IN PLS_INTEGER := 1
   , P_dir                  IN VARCHAR2    := 'MST_DIR'
   , P_nr_is_pos_integer    IN PLS_INTEGER := 0 )
RETURN PLS_INTEGER
 IS
    filehandle             UTL_FILE.FILE_TYPE;
    filehandle_rc          UTL_FILE.FILE_TYPE;
 
    v_user_name            VARCHAR2(100);
    v_file_name_full       VARCHAR2(200);
    v_dir                  VARCHAR2(200);
    v_total_length         PLS_INTEGER := 0;
    v_startpos             PLS_INTEGER := 0;
    v_datatype             VARCHAR2(30);
    v_delimiter            VARCHAR2(10):= P_column_delimiter;
    v_rowdelimiter         VARCHAR2(10):= P_row_delimiter;
 
    v_cursorid             PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
    v_columnvalue          VARCHAR2(4000);
    v_ignore               PLS_INTEGER;
    v_colcount             PLS_INTEGER := 0;
    v_newline              VARCHAR2(32676);
    v_desc_cols_table      DBMS_SQL.DESC_TAB;
    v_dateformat           NLS_SESSION_PARAMETERS.VALUE%TYPE;
    v_stat                 VARCHAR2(1000);
    counter                PLS_INTEGER := 0;
BEGIN
    SELECT directory_path
      INTO v_dir 
    FROM DBA_DIRECTORIES
    WHERE directory_name = P_dir;
    v_file_name_full  := v_dir||'/'||P_filename;
    --
    SELECT VALUE
      INTO v_dateformat
    FROM NLS_SESSION_PARAMETERS
    WHERE parameter = 'NLS_DATE_FORMAT';
    /* Use a date format that includes the time. */
    v_stat := 'alter session set nls_date_format=''dd-mm-yyyy hh24:mi:ss'' ';
    EXECUTE IMMEDIATE v_stat;
    filehandle := UTL_FILE.FOPEN( P_dir, P_filename, 'w', 32000 );
    /* Parse the input query so we can describe it. */
    DBMS_SQL.PARSE(  v_cursorid,  P_query, dbms_sql.native );
    /* Now, describe the outputs of the query. */
    DBMS_SQL.DESCRIBE_COLUMNS( v_cursorid, v_colcount, v_desc_cols_table );
    /* For each column, we need to define it, to tell the database
     * what we will fetch into. In this case, all data is going
     * to be fetched into a single varchar2(4000) variable.
     *
     * We will also adjust the max width of each column. 
     */
IF P_write_rec_layout = 1 
THEN
   filehandle_rc := UTL_FILE.FOPEN(P_dir, SUBSTR(P_filename,1, INSTR(P_filename,'.',-1)-1)||'_readme.txt', 'w');
   --Start Header
    v_newline := CHR(10)||CHR(10)||'  *********************************************************************  ';
      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
       v_newline := '  Record Layout of file '||v_file_name_full;
      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
    v_newline := '  *********************************************************************  '||CHR(10)||CHR(10);
      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
    v_newline := '  Column                          Sequence  MaxLength  Datatype  ';
      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
    v_newline := '  ------------------------------  --------  ---------  ----------  '||CHR(10);
      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
    --End Header
    --Start Body
    FOR i IN 1 .. v_colcount
    LOOP
       DBMS_SQL.DEFINE_COLUMN( v_cursorid, i, v_columnvalue, 4000 );
       SELECT DECODE( v_desc_cols_table(i).col_type,  2, DECODE(v_desc_cols_table(i).col_precision,0,v_desc_cols_table(i).col_max_len,v_desc_cols_table(i).col_precision)+DECODE(P_nr_is_pos_integer,1,0,2)
                                                   , 12, 20, v_desc_cols_table(i).col_max_len )
       INTO v_desc_cols_table(i).col_max_len
       FROM dual;
       --
       SELECT DECODE( TO_CHAR(v_desc_cols_table(i).col_type), '1'  , 'VARCHAR2'
                                                            , '2'  , 'NUMBER'
                                                            , '8'  , 'LONG'
                                                            , '11' , 'ROWID'
                                                            , '12' , 'DATE'
                                                            , '96' , 'CHAR'
                                                            , '108', 'USER_DEFINED_TYPE', TO_CHAR(v_desc_cols_table(i).col_type) )
       INTO v_datatype
       FROM DUAL;
       v_newline := RPAD('  '||v_desc_cols_table(i).col_name,34)||RPAD(i,10)||RPAD(v_desc_cols_table(i).col_max_len,11)||RPAD(v_datatype,25);
       UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
    END LOOP;
    --End Body
ELSE
     FOR i IN 1 .. v_colcount 
     LOOP
       DBMS_SQL.DEFINE_COLUMN( v_cursorid, i, v_columnvalue, 4000 );
       SELECT DECODE( v_desc_cols_table(i).col_type,  2, DECODE(v_desc_cols_table(i).col_precision,0,v_desc_cols_table(i).col_max_len,v_desc_cols_table(i).col_precision)+DECODE(P_nr_is_pos_integer,1,0,2)
                                                   , 12, 20, v_desc_cols_table(i).col_max_len )
       INTO v_desc_cols_table(i).col_max_len
       FROM dual;
     END LOOP;
END IF;
     --
     v_ignore := DBMS_SQL.EXECUTE(v_cursorid);
     WHILE ( DBMS_SQL.FETCH_ROWS(v_cursorid) > 0 )
     LOOP
        /* Build up a big output line. This is more efficient than
         * calling UTL_FILE.PUT inside the loop.
         */
        v_newline := NULL;
        FOR i IN 1 .. v_colcount 
        LOOP
            DBMS_SQL.COLUMN_VALUE( v_cursorid, i, v_columnvalue );
            if i = 1 then
              v_newline := v_newline||v_columnvalue;
            else
              v_newline := v_newline||v_delimiter||v_columnvalue;
            end if;              
        END LOOP;
        /* Now print out that line and increment a counter. */
        UTL_FILE.PUT_LINE( filehandle, v_newline||v_rowdelimiter );
        counter := counter+1;
    END LOOP;
    --
	IF P_write_rec_layout = 1 
	THEN
	  --Start Footer
           v_newline := CHR(10)||CHR(10)||'  ----------------------------------  ';
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	       v_newline := '  Generated:     '||SYSDATE;
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	       v_newline := '  Generated by:  '||USER;
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	       v_newline := '  Columns Count: '||v_colcount;
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	       v_newline := '  Records Count: '||counter;
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	       v_newline := '  Delimiter: '||v_delimiter;
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	       v_newline := '  Row Delimiter: '||v_rowdelimiter;
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	    v_newline := '  ----------------------------------  '||CHR(10)||CHR(10);
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
	  --End Footer
      --Start Commment
	    v_newline := '  '||P_comment;
	      UTL_FILE.PUT_LINE(filehandle_rc, v_newline);
      --End Commment
	  UTL_FILE.FCLOSE(filehandle_rc);
      -- 
	END IF;
 
    /* Free up resources. */
    DBMS_SQL.CLOSE_CURSOR(v_cursorid);
    UTL_FILE.FCLOSE( filehandle );
 
    /* Reset the date format ... and return. */
    v_stat := 'alter session set nls_date_format=''' || v_dateformat || ''' ';
    EXECUTE IMMEDIATE v_stat;
 
    RETURN counter;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_SQL.CLOSE_CURSOR( v_cursorid );
        EXECUTE IMMEDIATE 'alter session set nls_date_format=''' || v_dateformat || ''' ';
        RETURN counter;
 
END Dump_Delimited;
/
 
SHOW ERRORS;



/*
set timing on
select Dump_Delimited('select * from all_objects', 'all_objects.csv') nr_rows from dual;
*/

