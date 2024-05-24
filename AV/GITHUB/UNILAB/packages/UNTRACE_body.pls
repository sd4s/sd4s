create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.4.0 (V06.04.00.00_24.01) $
-- $Date: 2009-04-20T16:24:00 $
untrace AS

l_string          VARCHAR2(2000);
l_ret_code        NUMBER;
l_seq             NUMBER;
l_ev_seq_nr       NUMBER;
l_result          NUMBER;
StpError          EXCEPTION;

CURSOR c_system (a_setting_name VARCHAR2) IS
   SELECT setting_value
   FROM utsystem
   WHERE setting_name = a_setting_name;

l_file_handle     UTL_FILE.FILE_TYPE;
l_eof_found       BOOLEAN := FALSE;
l_buff            VARCHAR2(1022);


FUNCTION TraceOn             /* INTERNAL */
(a_trace_mode IN VARCHAR2)
RETURN NUMBER IS

BEGIN
   l_seq := 0;
   l_ret_code := TraceOff;
   IF l_ret_code <> 0  THEN
      RETURN(l_ret_code);
   END IF;

   IF a_trace_mode = 'FILE' THEN
      P_TRACE_MODE := 'FILE';
      BEGIN
         l_file_handle := UTL_FILE.FOPEN (P_TRACE_DIR, P_TRACE_FILE||USERENV('sessionid')||'.log', 'w');
      EXCEPTION
      WHEN UTL_FILE.INVALID_PATH THEN
         DBMS_OUTPUT.PUT_LINE('Invalid path'||P_TRACE_FILE||USERENV('sessionid')||'.log');

      WHEN UTL_FILE.INVALID_MODE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid mode');

       WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid filehandle');

      WHEN UTL_FILE.INVALID_OPERATION THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Invalid operation');

      WHEN UTL_FILE.READ_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Read error');

      WHEN UTL_FILE.WRITE_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Write error');

      WHEN UTL_FILE.INTERNAL_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Internal error');

      WHEN OTHERS THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE(SQLCODE);
      END;
      RETURN(0);
   ELSIF a_trace_mode = 'PIPE2TABLE' THEN
      P_TRACE_MODE := 'PIPE2TABLE';
      DBMS_PIPE.PURGE(P_TRACE_PIPE);
      RETURN(0);
   ELSIF a_trace_mode = 'NONE' THEN
      RETURN(0);
   ELSE
      RETURN(-10);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   l_ret_code := -SQLCODE;
   RETURN(l_ret_code);
END TraceOn;

FUNCTION TraceOff            /* INTERNAL */
RETURN NUMBER IS

BEGIN
   IF P_TRACE_MODE = 'FILE' THEN
      BEGIN
         IF UTL_FILE.IS_OPEN(l_file_handle) THEN
            UTL_FILE.FCLOSE (l_file_handle);
         END IF;
      EXCEPTION
      WHEN UTL_FILE.INVALID_PATH THEN
         DBMS_OUTPUT.PUT_LINE('Invalid path');

      WHEN UTL_FILE.INVALID_MODE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid mode');

       WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid filehandle');

      WHEN UTL_FILE.INVALID_OPERATION THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Invalid operation');

      WHEN UTL_FILE.READ_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Read error');

      WHEN UTL_FILE.WRITE_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Write error');

      WHEN UTL_FILE.INTERNAL_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Internal error');

      WHEN OTHERS THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE(SQLCODE);
      END;
      NULL;

   ELSIF P_TRACE_MODE = 'PIPE2TABLE' THEN
      DBMS_PIPE.PACK_MESSAGE('U4EVMGR_TRACE_OFF');
      l_ret_code := DBMS_PIPE.SEND_MESSAGE(P_TRACE_PIPE,15);
      IF l_ret_code <> 0 THEN
         DBMS_PIPE.PACK_MESSAGE('PIPE ERROR :'||TO_CHAR(l_ret_code));
         l_ret_code := DBMS_PIPE.SEND_MESSAGE(P_TRACE_PIPE,15);
      END IF;
   END IF;
   RETURN(0);
EXCEPTION
WHEN OTHERS THEN
   l_ret_code := -SQLCODE;
   RETURN(l_ret_code);
END TraceOff;

PROCEDURE Log   /* INTERNAL */
(a_message IN VARCHAR2)
IS

BEGIN
   IF P_TRACE_MODE = 'FILE' THEN
      BEGIN
         UTL_FILE.PUT_LINE(l_file_handle,a_message);
      EXCEPTION
      WHEN UTL_FILE.INVALID_PATH THEN
         DBMS_OUTPUT.PUT_LINE('Invalid path');

      WHEN UTL_FILE.INVALID_MODE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid mode');

       WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid filehandle');

      WHEN UTL_FILE.INVALID_OPERATION THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Invalid operation');

      WHEN UTL_FILE.READ_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Read error');

      WHEN UTL_FILE.WRITE_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Write error');

      WHEN UTL_FILE.INTERNAL_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Internal error');

      WHEN OTHERS THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE(SQLCODE);
      END;
NULL;

   ELSIF P_TRACE_MODE = 'PIPE2TABLE' THEN
      DBMS_PIPE.PACK_MESSAGE(a_message);
      l_ret_code := DBMS_PIPE.SEND_MESSAGE(P_TRACE_PIPE,15);
      IF l_ret_code <> 0 THEN
         DBMS_PIPE.PACK_MESSAGE('PIPE ERROR :'||TO_CHAR(l_ret_code));
         l_ret_code := DBMS_PIPE.SEND_MESSAGE(P_TRACE_PIPE,15);
      END IF;
   ELSIF P_TRACE_MODE = 'DBMS_OUTPUT' THEN
      DBMS_OUTPUT.PUT_LINE(a_message);
   END IF;
END Log;

PROCEDURE ReceiveLog  /* INTERNAL */
IS

BEGIN
   DBMS_OUTPUT.PUT_LINE('Trace mode :'||P_TRACE_MODE);
   IF P_TRACE_MODE = 'FILE' THEN
      BEGIN
         l_file_handle := UTL_FILE.FOPEN (P_TRACE_DIR, P_TRACE_FILE||USERENV('sessionid')||'.log', 'w');

         --Read all lines in the file
         LOOP
            EXIT WHEN l_eof_found;
            BEGIN
               UTL_FILE.GET_LINE(l_file_handle, l_buff);
               DBMS_OUTPUT.PUT_LINE(l_buff);
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
              l_eof_found := TRUE;
            END;
         END LOOP;

         -- Close the file
         UTL_FILE.FCLOSE (l_file_handle);
      EXCEPTION
      WHEN UTL_FILE.INVALID_PATH THEN
         DBMS_OUTPUT.PUT_LINE('Invalid path');

      WHEN UTL_FILE.INVALID_MODE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid mode');

       WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         DBMS_OUTPUT.PUT_LINE('Invalid filehandle');

      WHEN UTL_FILE.INVALID_OPERATION THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Invalid operation');

      WHEN UTL_FILE.READ_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Read error');

      WHEN UTL_FILE.WRITE_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Write error');

      WHEN UTL_FILE.INTERNAL_ERROR THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE('Internal error');

      WHEN OTHERS THEN
         UTL_FILE.FCLOSE_ALL;
         DBMS_OUTPUT.PUT_LINE(SQLCODE);
      END;
   ELSIF P_TRACE_MODE = 'PIPE2TABLE' THEN
      LOOP
         l_ret_code := DBMS_PIPE.RECEIVE_MESSAGE(P_TRACE_PIPE,3600);
         IF l_ret_code  = 0 THEN
            DBMS_PIPE.UNPACK_MESSAGE(l_string);
            l_seq := l_seq + 1;
            INSERT INTO utevtrace
            (logdate, logdate_tz, seq, text )
            VALUES
            (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, l_seq,SUBSTR(l_string,1,255));
            UNAPIGEN.U4COMMIT;
            IF l_string = 'U4EVMGR_TRACE_OFF' THEN
               EXIT;
            END IF;
         ELSIF l_ret_code = 1 THEN
            DBMS_OUTPUT.PUT_LINE('ReceiveLog Timeout');
            EXIT;
         ELSIF l_ret_code = 2 THEN
            DBMS_OUTPUT.PUT_LINE('Record in pipe too large');
            EXIT;
         ELSIF l_ret_code = 3 THEN
            DBMS_OUTPUT.PUT_LINE('ReceiveLog Interrupted');
            EXIT;
         ELSE
            DBMS_OUTPUT.PUT_LINE('ReceiveLog Interrupted'||l_ret_code);
            EXIT;
         END IF;
      END LOOP;
      DBMS_PIPE.PURGE(P_TRACE_PIPE);
   END IF;
END ReceiveLog;

FUNCTION EvTraceOn          /* INTERNAL */
(a_trace_mode IN VARCHAR2)
RETURN NUMBER IS

l_up                    NUMBER(5);
l_user_profile          VARCHAR2(40);
l_language              VARCHAR2(20);
l_tk                    VARCHAR2(20);
l_x                     INTEGER;
l_dba_name              VARCHAR2(40);
l_numeric_characters    VARCHAR2(2);
l_dateformat            VARCHAR2(255);

BEGIN

   OPEN c_system ('DBA_NAME');
   FETCH c_system INTO l_dba_name;
   IF c_system%NOTFOUND THEN
      CLOSE c_system;
      RAISE StpError;
   END IF;
   CLOSE c_system;

   l_dateformat := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
   OPEN c_system ('JOBS_DATE_FORMAT');
   FETCH c_system INTO l_dateformat;
   CLOSE c_system;
   l_numeric_characters := 'DB';

   IF UNAPIGEN.SetConnection('UNTRACE',
      l_dba_name, 'UNILAB40',
      'UNTRACE', l_numeric_characters, l_dateformat,
      l_up, l_user_profile, l_language, l_tk) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

   /*---------------------------------------------------------*/
   /* INSERT 100 TraceOn events to be sure to turn tracing on */
   /* in all runing event managers                            */
   /*---------------------------------------------------------*/
   FOR l_x IN 1..100 LOOP
      IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE StpError;
      END IF;

      l_ev_seq_nr := -1;
      l_result := UNAPIEV.InsertEvent('UNTRACE', UNAPIGEN.P_EVMGR_NAME,
                                      '', '', '', '', '', 'TraceOn', a_trace_mode,
                                      l_ev_seq_nr);

      IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE StpError;
      END IF;
   END LOOP;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('EvTraceOn', sqlerrm);
   END IF;
   l_ret_code := UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'EvTraceOn');
END EvTraceOn;

FUNCTION EvTraceOff          /* INTERNAL */
RETURN NUMBER IS

l_up                    NUMBER(5);
l_user_profile          VARCHAR2(40);
l_language              VARCHAR2(20);
l_tk                    VARCHAR2(20);
l_x                     INTEGER;
l_dba_name              VARCHAR2(40);
l_numeric_characters    VARCHAR2(2);
l_dateformat            VARCHAR2(255);

BEGIN

   OPEN c_system ('DBA_NAME');
   FETCH c_system INTO l_dba_name;
   IF c_system%NOTFOUND THEN
      CLOSE c_system;
      RAISE StpError;
   END IF;
   CLOSE c_system;

   l_dateformat := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
   OPEN c_system ('JOBS_DATE_FORMAT');
   FETCH c_system INTO l_dateformat;
   CLOSE c_system;
   l_numeric_characters := 'DB';

   IF UNAPIGEN.SetConnection('UNTRACE',
      l_dba_name, 'UNILAB40',
      'UNTRACE', l_numeric_characters, l_dateformat,
      l_up, l_user_profile, l_language, l_tk) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE StpError;
   END IF;

   /*---------------------------------------------------------*/
   /* INSERT 100 TraceOn events to be sure to turn tracing on */
   /* in all runing event managers                            */
   /*---------------------------------------------------------*/
   FOR l_x IN 1..100 LOOP
      IF UNAPIGEN.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE StpError;
      END IF;

      l_ev_seq_nr := -1;
      l_result := UNAPIEV.InsertEvent('UNTRACE', UNAPIGEN.P_EVMGR_NAME,
                                      '', '', '', '', '', 'TraceOff', '',
                                      l_ev_seq_nr);

      IF UNAPIGEN.EndTxn <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE StpError;
      END IF;
   END LOOP;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('EvTraceOff', sqlerrm);
   END IF;
   l_ret_code := UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'EvTraceOff');
END EvTraceOff;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


/* --------------------------------------------------------------------- */
/*                   the initialisation code                             */
/* --------------------------------------------------------------------- */
BEGIN
   P_TRACE_MODE:='NONE';
   P_TRACE_FILE:='u4evmgr';
   P_TRACE_PIPE:='U4EVMGRPIPE';
   P_TRACE_DIR:='e:\database\u50f\unilink\log';
   l_seq := 0;
END untrace;