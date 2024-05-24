--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure MINILINK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."MINILINK" IS

-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $

-- -------------------------------------------------------
-- IMPORTANT REMARK ABOUT TRANSACTION CONTROL IN THIS PROCEDURE
--
-- when transaction control is performed inside the data files
-- the transaction control statement must be driven by the file content api_name = BEGINTRANSACTIO?
-- when no transaction control inside the data files
-- One API call is one transaction
-- But for many technical reasons, a SynchrEndTransaction must be used instead of EndTransaction
--
-- the place were where this is implemented are marked by /* ALT-TRANSACTION-CONTROL */
-- ------------------------------------------------------------------------------------

l_sqlerrm                      VARCHAR2(255);
l_ret_code                     NUMBER;
l_line_found                   BOOLEAN;
l_transac_ctrl_infile          BOOLEAN;

/* Global arguments */
setcon_client_id               VARCHAR2(20);
setcon_us                      VARCHAR2(20);
setcon_password                VARCHAR2(20);
setcon_applic                  VARCHAR2(8);
setcon_numeric_characters      VARCHAR2(2);
setcon_date_format             VARCHAR2(255);
setcon_up                      NUMBER(5);
setcon_up_description          VARCHAR2(40);
setcon_language                VARCHAR2(20);
setcon_task                    VARCHAR2(20);

CURSOR c_system (a_setting_name VARCHAR2) IS
   SELECT setting_value
   FROM utsystem
   WHERE setting_name = a_setting_name;

CURSOR l_utlkin_cursor IS
   SELECT *
   FROM utlkin
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

l_start_seq           utlkin.seq%TYPE;
l_last_seq            utlkin.seq%TYPE;
l_debug               VARCHAR2(200);
l_dba_name            VARCHAR2(40);
l_dateformat          VARCHAR2(255);
l_enter_loop          BOOLEAN;

BEGIN

OPEN c_system ('DBA_NAME');
FETCH c_system INTO l_dba_name;
IF c_system%NOTFOUND THEN
   CLOSE c_system;
   DBMS_OUTPUT.PUT_LINE('NO DBA_NAME system default !');
END IF;
CLOSE c_system;

IF UNAPIGEN.P_DATEFORMAT IS NULL THEN

   --perform a SetConnection where
   l_dateformat := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
   OPEN c_system ('JOBS_DATE_FORMAT');
   FETCH c_system INTO l_dateformat;
   CLOSE c_system;

   setcon_client_id   := 'MiniLink';
   setcon_us          := l_dba_name;
   setcon_password    := 'unilab40';
   setcon_applic      := 'MiniLink';
   setcon_numeric_characters := 'DB';
   setcon_date_format := l_dateformat;
   l_ret_code := UNAPIGEN.SetConnection(setcon_client_id, setcon_us, setcon_password,
                                        setcon_applic, setcon_numeric_characters, setcon_date_format,
                                        setcon_up, setcon_up_description, setcon_language,
                                        setcon_task);
   DBMS_OUTPUT.PUT_LINE('SetConnection result: ' || TO_CHAR(l_ret_code));
END IF;

l_transac_ctrl_infile := FALSE;

LOOP

   l_debug := 'OPEN-CLOSE cursor';
   l_line_found := FALSE;
   OPEN l_utlkin_cursor;
   FETCH l_utlkin_cursor
   INTO l_curr_line;
   l_line_found := l_utlkin_cursor%FOUND;
   CLOSE l_utlkin_cursor;

   EXIT WHEN NOT l_line_found;

   /* ALT-TRANSACTION-CONTROL */
   /* a transaction is started only when not driven by file */
   IF UPPER(l_curr_line.api_name) = 'BEGINTRANSACTION' THEN
      l_transac_ctrl_infile := TRUE;
   END IF;

   IF UNAPIGEN.P_TXN_LEVEL <= 0 AND
      (NOT l_transac_ctrl_infile) THEN
         l_ret_code := UNAPIGEN.BeginTransaction;
   END IF;

   BEGIN

      l_debug := 'Before l_last_seq';
      l_last_seq := l_curr_line.seq;
      l_start_seq := l_last_seq;
      l_debug := 'After l_last_seq'||TO_CHAR(l_last_seq);

      IF UPPER(l_curr_line.api_name) = 'CREATESAMPLE' THEN
         l_ret_code := ULOP.HandleCreateSample(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESAMPLE' THEN
         l_ret_code := ULOP.HandleSaveSample(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESCGROUPKEY' THEN
         l_ret_code := ULOP.HandleSaveScGroupKey(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESCPARAMETERGROUP' THEN
         l_ret_code := ULOP.HandleSaveScParameterGroup(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESCPARAMETER' THEN
         l_ret_code := ULOP.HandleSaveScParameter(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESCPARESULT' THEN
         l_ret_code := ULOP.HandleSaveScPaResult(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESCMETHOD' THEN
        l_debug := 'Before HandleSaveScMethod'||TO_CHAR(l_last_seq);
        l_ret_code := ULOP.HandleSaveScMethod(l_curr_line, l_last_seq);
        l_debug := 'After HandleSaveScMethod'||TO_CHAR(l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESCINFOCARD' THEN
         l_ret_code := ULOP.HandleSaveScInfoCard(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESCINFOFIELD' THEN
         l_ret_code := ULOP.HandleSaveScInfoField(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESAMPLETYPE' THEN
         l_ret_code := ULCO.HandleSaveSampleType(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESTPARAMETERPROFILE' THEN
         l_ret_code := ULCO.HandleSaveStParameterProfile(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESTGROUPKEY' THEN
         l_ret_code := ULCO.HandleSaveStGroupkey(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEGROUPKEYST' THEN
         l_ret_code := ULCO.HandleSaveGroupkeySt(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEGROUPKEYSC' THEN
         l_ret_code := ULCO.HandleSaveGroupkeySc(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEGROUPKEYME' THEN
         l_ret_code := ULCO.HandleSaveGroupkeyMe(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEPARAMETERPROFILE' THEN
         l_ret_code := ULCO.HandleSaveParameterProfile(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEPPPARAMETER' THEN
         l_ret_code := ULCO.HandleSavePpParameter(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEPPPARAMETERSPECS' THEN
         l_ret_code := ULCO.HandleSavePpParameterSpecs(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEPARAMETER' THEN
         l_ret_code := ULCO.HandleSaveParameter(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEPRMETHOD' THEN
         l_ret_code := ULCO.HandleSavePrMethod(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEMETHOD' THEN
         l_ret_code := ULCO.HandleSaveMethod(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEREQUESTTYPE' THEN
         l_ret_code := ULCO.HandleSaveRequestType(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVERTSAMPLETYPE' THEN
         l_ret_code := ULCO.HandleSaveRtSampleType(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVERTPARAMETERPROFILE' THEN
         l_ret_code := ULCO.HandleSaveRtParameterProfile(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVERTINFOPROFILE' THEN
         l_ret_code := ULCO.HandleSaveRtInfoProfile(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'DELETEGROUPKEYSTSTRUCTURES' THEN
         l_ret_code := ULCO.HandleDeleteGKStStructures(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'CREATEGROUPKEYSTSTRUCTURES' THEN
         l_ret_code := ULCO.HandleCreateGKStStructures(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'DELETEGROUPKEYSCSTRUCTURES' THEN
         l_ret_code := ULCO.HandleDeleteGKScStructures(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'CREATEGROUPKEYSCSTRUCTURES' THEN
         l_ret_code := ULCO.HandleCreateGKScStructures(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'DELETEGROUPKEYMESTRUCTURES' THEN
         l_ret_code := ULCO.HandleDeleteGKMeStructures(l_curr_line, l_last_seq);
     ELSIF UPPER(l_curr_line.api_name) = 'CREATEGROUPKEYMESTRUCTURES' THEN
         l_ret_code := ULCO.HandleCreateGKMeStructures(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEUSERPROFILE' THEN
         l_ret_code := ULCO.HandleSaveUserProfile(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEADDRESS' THEN
         l_ret_code := ULCO.HandleSaveAddress(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEUPUSER' THEN
         l_ret_code := ULCO.HandleSaveUpUser(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'PLANSAMPLE' THEN
         l_ret_code := ULOP.HandlePlanSample(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVETASK' THEN
         l_ret_code := ULCO.HandleSaveTask(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEOBJECTATTRIBUTE' THEN
         l_ret_code := ULCO.HandleSaveObjectAttribute(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEUSEDOBJECTATTRIBUTE' THEN
         l_ret_code := ULCO.HandleSaveUsedObjectAttribute(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEPPATTRIBUTE' THEN
         l_ret_code := ULCO.HandleSavePpAttribute(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEPPPRATTRIBUTE' THEN
         l_ret_code := ULCO.HandleSavePpPrAttribute(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'CHANGEOBJECTSTATUS' THEN
         l_ret_code := ULCO.HandleChangeObjectStatus(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'CHANGEOBJECTLIFECYCLE' THEN
         l_ret_code := ULCO.HandleChangeObjectLifeCycle(l_curr_line, l_last_seq);
     ELSIF UPPER(l_curr_line.api_name) = 'SAVEOBJECTACCESS' THEN
         l_ret_code := ULCO.HandleSaveObjectAccess(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'CHANGEPPSTATUS' THEN
         l_ret_code := ULCO.HandleChangePpStatus(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'CHANGEPPLIFECYCLE' THEN
         l_ret_code := ULCO.HandleChangePpLifeCycle(l_curr_line, l_last_seq);
     ELSIF UPPER(l_curr_line.api_name) = 'SAVEPPACCESS' THEN
         l_ret_code := ULCO.HandleSavePpAccess(l_curr_line, l_last_seq);
     ELSIF UPPER(l_curr_line.api_name) = 'SAVEINFOPROFILE' THEN
        l_ret_code := ULCO.HandleSaveInfoProfile(l_curr_line, l_last_seq);
     ELSIF UPPER(l_curr_line.api_name) = 'SAVEIPINFOFIELD' THEN
        l_ret_code := ULCO.HandleSaveIpInfoField(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVESTINFOPROFILE' THEN
        l_ret_code := ULCO.HandleSaveStInfoProfile(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEATTRIBUTE' THEN
        l_ret_code := ULCO.HandleSaveAttribute(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEATTRIBUTESQL' THEN
        l_ret_code := ULCO.HandleSaveAttributeSql(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEATTRIBUTEVALUE' THEN
        l_ret_code := ULCO.HandleSaveAttributeValue(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEINFOFIELD' THEN
         l_ret_code := ULCO.HandleSaveInfoField(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEINFOFIELDSQL' THEN
         l_ret_code := ULCO.HandleSaveInfoFieldSql(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEINFOFIELDVALUE' THEN
         l_ret_code := ULCO.HandleSaveInfoFieldValue(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SAVEMTCELL' THEN
         l_ret_code := ULCO.HandleSaveMtCell(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'BEGINTRANSACTION' THEN
         l_ret_code := ULCO.HandleBeginTransaction(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'ENDTRANSACTION' THEN
         l_ret_code := ULCO.HandleEndTransaction(l_curr_line, l_last_seq);
      ELSIF UPPER(l_curr_line.api_name) = 'SYNCHRENDTRANSACTION' THEN
         l_ret_code := ULCO.HandleSynchrEndTransaction(l_curr_line, l_last_seq);
      ELSIF NVL(l_curr_line.api_name, 'api_name') <>  'api_name' THEN
         DBMS_OUTPUT.PUT_LINE('Line ' || TO_CHAR(l_curr_line.seq) ||
                              ' Unknown function: ' || l_curr_line.api_name);
      ELSE
         /* Do nothing if api name is empty */
         null;
      END IF;

      DBMS_OUTPUT.PUT_LINE('Processed lines ' || TO_CHAR(l_curr_line.seq) || ' - ' ||
                           TO_CHAR(l_last_seq) || ' Result: ' ||
                           TO_CHAR(l_ret_code));

      IF l_start_seq > NVL(l_last_seq,0) THEN
         l_sqlerrm := 'Start sequence '||TO_CHAR( l_start_seq) ||'> end seq '||
                       TO_CHAR(l_last_seq);
         RAISE NO_DATA_FOUND;
      END IF;
      l_debug := 'Before DELETE FROM utlkin';
      DELETE FROM utlkin
      WHERE seq <= l_last_seq;
      -- UNAPIGEN.U4COMMIT;
      l_debug := 'After DELETE FROM utlkin';


   EXCEPTION
   WHEN OTHERS THEN
      IF l_sqlerrm IS NULL THEN
         l_sqlerrm := SUBSTR(SQLERRM,1,255);
      END IF;
      DBMS_OUTPUT.PUT_LINE('Exception handler');
      -- l_ret_code := UNAPIGEN.SynchrEndTransaction;

      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'Seq: ' || TO_CHAR(l_last_seq)|| '/' || l_curr_line.api_name, 'Debug info :'||l_debug);
      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'Seq: ' || TO_CHAR(l_last_seq)|| '/' || l_curr_line.api_name, l_sqlerrm);
      IF l_utlkin_cursor%ISOPEN THEN
         CLOSE l_utlkin_cursor;
      END IF;

      /* Make sure the incorrect line gets removed */
      DELETE FROM utlkin
      WHERE seq <= l_last_seq;
      UNAPIGEN.U4COMMIT;
     DBMS_OUTPUT.PUT_LINE('commiting exception 1');

      /* dispaying content of uterror when possible */
      l_enter_loop := FALSE;
      FOR l_error_rec IN (SELECT SUBSTR(error_msg, 1, 255) error_msg
                          FROM uterror
                          WHERE applic = 'loaddata'
                          AND client_id = NVL(UNAPIGEN.P_CLIENT_ID, client_id)
                          AND logdate > (CURRENT_TIMESTAMP - ((1/24)/180)) -- last 20 seconds
                          ORDER BY logdate ASC) LOOP
          IF NOT l_enter_loop THEN
             l_enter_loop := TRUE;
             DBMS_OUTPUT.PUT_LINE('Last entries in uterror');
          END IF;
          DBMS_OUTPUT.PUT_LINE(l_error_rec.error_msg);
      END LOOP;
      l_enter_loop := FALSE;
   END;

   /* ALT-TRANSACTION-CONTROL */
   /* a transaction is ended only when not driven by file */
   IF UNAPIGEN.P_TXN_LEVEL > 0 AND
      (NOT l_transac_ctrl_infile) THEN
      l_ret_code := UNAPIGEN.SynchrEndTransaction;
      UNAPIGEN.U4COMMIT;
   END IF;
   IF UPPER(l_curr_line.api_name) IN ('ENDTRANSACTION', 'SYNCHRENDTRANSACTION') THEN
      l_transac_ctrl_infile := FALSE;
   END IF;

END LOOP;

--close the opened transaction when necessary
IF UNAPIGEN.P_TXN_LEVEL>0 THEN
   l_ret_code := UNAPIGEN.SynchrEndTransaction;
   UNAPIGEN.U4COMMIT;
END IF;

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM,1,255);
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'Seq: ' || TO_CHAR(l_last_seq), l_sqlerrm);
   IF l_utlkin_cursor%ISOPEN THEN
      CLOSE l_utlkin_cursor;
   END IF;
   --close the opened transaction when necessary
   IF UNAPIGEN.P_TXN_LEVEL>0 THEN
      l_ret_code := UNAPIGEN.SynchrEndTransaction;
      UNAPIGEN.U4COMMIT;
   END IF;
   DBMS_OUTPUT.PUT_LINE('commiting exception 2');
   UNAPIGEN.U4COMMIT;
END;

/
