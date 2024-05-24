create or replace PACKAGE BODY
-- Unilab 4.0 Package
-- $Revision: 2 $
-- $Date: 4/11/99 21:48 $
       unilink AS

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_timed_event_tp  utevtimed.ev_tp%TYPE;
l_ret_code        NUMBER;
l_result          NUMBER;
l_return          INTEGER;
l_fetched_rows    NUMBER;
StpError          EXCEPTION;

FUNCTION U4PARSING           /* INTERNAL */
RETURN NUMBER IS

l_file_name      VARCHAR2(255);
l_read_on        UNAPIGEN.DATE_TABLE_TYPE;
l_line_nbr       UNAPIGEN.NUM_TABLE_TYPE;
l_text_line      UNAPIGEN.VC2000_TABLE_TYPE;
l_nr_of_rows_in  NUMBER;
l_nr_of_rows_out NUMBER;
l_next_rows      NUMBER;
l_row            NUMBER;
l_leave_loop     BOOLEAN;
l_return         NUMBER;

BEGIN

   /*------------------------------------------------------------*/
   /* This function is a test function for all Unilink Auxiliary */
   /* functions                                                  */
   /* All lines read from the file are read and transferred to   */
   /* out directory                                              */
   /* All lines are the deleted from the utulin table            */
   /* All the steps are logged in filename.log                   */
   /*------------------------------------------------------------*/
   l_file_name := UNAPIUL.P_FILE_NAME;
   l_nr_of_rows_in := 2; /* Fetch 2 rows at a time */
   l_nr_of_rows_out := l_nr_of_rows_in;
   l_next_rows := 0;
   l_leave_loop := FALSE;

   l_ret_code := UNAPIUL.OpenOutputFile(UNAPIUL.P_FILE_NAME);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIUL.Trace ('Opening output file('||UNAPIUL.P_FILE_NAME||') Failed:'|| l_ret_code,
                     UNAPIUL.UL_TRACE_HIGH);
      RETURN(l_ret_code);
   END IF;
   l_return := UNAPIUL.WriteToLog('U4PARSING','Opened output file');
   l_return := UNAPIUL.WriteToLog('U4PARSING','Getting all lines and copy to out');

   WHILE NOT l_leave_loop LOOP
      l_ret_code := UNAPIUL.GetULTextList
              (l_file_name, l_read_on, l_line_nbr, l_text_line,
               l_nr_of_rows_out,l_next_rows);
      IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
         FOR l_row IN 1..l_nr_of_rows_out LOOP
            l_return := UNAPIUL.WriteToLog('U4PARSING','line('|| l_row ||')='||l_text_line(l_row));

            l_ret_code := UNAPIUL.WriteToOutputFile('Row'||l_row||'='||l_text_line(l_row));
            IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
               l_return := UNAPIUL.WriteToLog('U4PARSING','Writing to output file('||UNAPIUL.P_FILE_NAME||') Failed:'|| l_ret_code);
               RETURN(l_ret_code);
            END IF;
         END LOOP;
         IF l_nr_of_rows_out < l_nr_of_rows_in THEN
            l_leave_loop := TRUE;
         ELSE
            l_next_rows := 1;
         END IF;
      ELSIF l_ret_code = UNAPIGEN.DBERR_NORECORDS THEN
         l_leave_loop := TRUE;
      ELSE
         l_return := UNAPIUL.WriteToLog('U4PARSING','GetULTextList failed='||l_ret_code);
         l_leave_loop := TRUE;
      END IF;
   END LOOP;

   l_ret_code := UNAPIUL.WriteToLog('U4PARSING','Deleting rows');
   l_ret_code := UNAPIUL.DeleteULText(l_file_name);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_return := UNAPIUL.WriteToLog('U4PARSING','Deleting Text('||l_file_name||') Failed:'|| l_ret_code);
      RETURN(l_ret_code);
   END IF;
   l_return := UNAPIUL.WriteToLog('U4PARSING','Deleting Text('||l_file_name||') OK:');

   l_return := UNAPIUL.WriteToLog('U4PARSING','Closing output file');
   l_ret_code := UNAPIUL.CloseOutputFile;
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_return := UNAPIUL.WriteToLog('U4PARSING','Closing output file('||UNAPIUL.P_FILE_NAME||') Failed:'|| l_ret_code);
      RETURN(l_ret_code);
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END U4PARSING;

FUNCTION DONOTHING
RETURN NUMBER IS
BEGIN
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END DONOTHING;

FUNCTION U4PARSINGFAILED
RETURN NUMBER IS
BEGIN
   RETURN(UNAPIGEN.DBERR_NOOBJECT);
END U4PARSINGFAILED;

FUNCTION Parser
RETURN NUMBER IS
BEGIN
   RETURN(UNICONNECT.Parser);
END Parser;

END unilink; 