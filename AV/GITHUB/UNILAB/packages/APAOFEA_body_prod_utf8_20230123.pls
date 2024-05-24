create or replace PACKAGE BODY          "APAOFEA" AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOFEA
-- ABSTRACT :
--   WRITER : Jan Roubos
--     DATE : 11/06/2015
--   TARGET : -
--  VERSION : -
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 11/06/2015 | JR        | Created
-- 20/08/2015 | JR        | importid as third parameter to the CEM record
-- 06/11/2015 | JR        | a little reengeneering, Meshing, ExecuteMeshing 2 variants
--                          if DBERR_OBJECTNOTFOUD, still attach the file
-- 28/01/2016 | JR        | Conditional logging LogInfo
-- 30/06/2016 | JR        | Removed some logging
-- 23/08/2016 | JP        | Added object ID quoting in SaveMECell
-- 08/06/2017 | JR        | Modified Meshing, make use of psexec.exe to execute Hypermesh script
-- 29/08/2017 | JR        | Altered Meshing and added function getFEASetting
-- 16/11/2017 | JR        | Added process_SX100A
-- 23/11/2017 | JR        | Altered ExecuteMeshing removed a specific sample restriction AND error handling
-- 21/12/2017 | JR        | Altered process_SX100A (FileInfo, 30, remove quotation marks
-- 05-10-2021 | PS        | ExecuteMeshing (WITHOUT parameters) extended with a mail-function in cases
--                        | where a "SX000%" method longer than 30 minutes in status=IE stands.
-- 06-12-2022 | PS        | Process_SX100A extended with a record for cell=ModelPortfolio.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name          CONSTANT VARCHAR2(20) := 'APAOFEA';
DBERR_OBJECTNOTFOUND     CONSTANT INTEGER := 337;    -- DBERR_OBJECTNOTFOUND (337, found in IAPICONSTANTDBERROR)

FUNCTION getFQfileName (avsFileName IN VARCHAR2, avsAbs IN BOOLEAN)
return varchar2 IS
  lcs_function_name     CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'getFQfileName';
  lvsFqFileName         VARCHAR2(255);
  lvsDirName            VARCHAR2(255);
  lvs_sqlerrm           APAOGEN.ERROR_MSG_TYPE;
BEGIN
  -- If absolute path needed, then we need to determine the Oracle directory_path of the Oracle directory
  IF (avsAbs) THEN
    SELECT directory_path
        INTO lvsDirName
      FROM all_directories
      WHERE DIRECTORY_NAME = 'FEA_DIR';
    lvsFqFileName := lvsDirName || '\' || avsFileName;
	--'
  ELSE
    lvsFqFileName := '\\ORACLEPROD\fea\' || avsFileName;
	--'
  END IF;

  RETURN lvsFqFileName;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN '<ERROR>';
end getFQfileName;

--------------------------------------------------------------------------------
-- Get MECell values, update the value_s attribute
-- Save MECell
--------------------------------------------------------------------------------
FUNCTION SaveMECell  (avs_sc IN VARCHAR2, avs_me IN VARCHAR2, avs_cell IN VARCHAR2, avs_value IN VARCHAR2, avs_completed INTEGER)
RETURN INTEGER IS
  lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SaveMECell';
  lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;

  -- General local  variables
  l_ret_code       INTEGER;

  -- Specific local  variables
  l_nr_of_rows     NUMBER;
  l_where_clause   VARCHAR2(255);
  l_next_rows      NUMBER;
  l_sc_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_pg_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_pgnode_tab     UNAPIGEN.LONG_TABLE_TYPE;
  l_pa_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_panode_tab     UNAPIGEN.LONG_TABLE_TYPE;
  l_me_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_menode_tab     UNAPIGEN.LONG_TABLE_TYPE;
  l_reanalysis_tab UNAPIGEN.NUM_TABLE_TYPE;
  l_cell_tab       UNAPIGEN.VC20_TABLE_TYPE;
  l_cellnode_tab   UNAPIGEN.LONG_TABLE_TYPE;
  l_dsp_title_tab  UNAPIGEN.VC40_TABLE_TYPE;
  l_value_f_tab    UNAPIGEN.FLOAT_TABLE_TYPE;
  l_value_s_tab    UNAPIGEN.VC40_TABLE_TYPE;
  l_cell_tp_tab    UNAPIGEN.CHAR1_TABLE_TYPE;
  l_pos_x_tab      UNAPIGEN.NUM_TABLE_TYPE;
  l_pos_y_tab      UNAPIGEN.NUM_TABLE_TYPE;
  l_align_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_winsize_x_tab  UNAPIGEN.NUM_TABLE_TYPE;
  l_winsize_y_tab  UNAPIGEN.NUM_TABLE_TYPE;
  l_is_protected_tab  UNAPIGEN.CHAR1_TABLE_TYPE;
  l_mandatory_tab  UNAPIGEN.CHAR1_TABLE_TYPE;
  l_hidden_tab     UNAPIGEN.CHAR1_TABLE_TYPE;
  l_unit_tab       UNAPIGEN.VC20_TABLE_TYPE;
  l_format_tab     UNAPIGEN.VC40_TABLE_TYPE;
  l_eq_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_eq_version_tab UNAPIGEN.VC20_TABLE_TYPE;
  l_component_tab  UNAPIGEN.VC20_TABLE_TYPE;
  l_calc_tp_tab    UNAPIGEN.CHAR1_TABLE_TYPE;
  l_calc_formula_tab  UNAPIGEN.VC2000_TABLE_TYPE;
  l_valid_cf_tab   UNAPIGEN.VC20_TABLE_TYPE;
  l_max_x_tab      UNAPIGEN.NUM_TABLE_TYPE;
  l_max_y_tab      UNAPIGEN.NUM_TABLE_TYPE;
  l_multi_select_tab  UNAPIGEN.CHAR1_TABLE_TYPE;
  l_reanalysedresult_tab  UNAPIGEN.CHAR1_TABLE_TYPE;
  l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;

BEGIN
  -- IN and IN  OUT arguments
  l_where_clause    := 'WHERE sc = ''' || avs_sc || ''' AND me = '''|| REPLACE (avs_me, '''', '''''') || ''' AND cell = '''|| avs_cell || '''';
  l_next_rows      :=  0; -- just 1 call
  l_nr_of_rows     := NULL;

  l_ret_code       :=  UNAPIME.GETSCMECELL
                   (l_sc_tab,
                    l_pg_tab,
                    l_pgnode_tab,
                    l_pa_tab,
                    l_panode_tab,
                    l_me_tab,
                    l_menode_tab,
                    l_reanalysis_tab,
                    l_cell_tab,
                    l_cellnode_tab,
                    l_dsp_title_tab,
                    l_value_f_tab,
                    l_value_s_tab,
                    l_cell_tp_tab,
                    l_pos_x_tab,
                    l_pos_y_tab,
                    l_align_tab,
                    l_winsize_x_tab,
                    l_winsize_y_tab,
                    l_is_protected_tab,
                    l_mandatory_tab,
                    l_hidden_tab,
                    l_unit_tab,
                    l_format_tab,
                    l_eq_tab,
                    l_eq_version_tab,
                    l_component_tab,
                    l_calc_tp_tab,
                    l_calc_formula_tab,
                    l_valid_cf_tab,
                    l_max_x_tab,
                    l_max_y_tab,
                    l_multi_select_tab,
                    l_reanalysedresult_tab,
                    l_nr_of_rows,
                    l_where_clause,
                    l_next_rows);
  IF l_ret_code  <> UNAPIGEN.DBERR_SUCCESS THEN
    lvs_sqlerrm := 'GETSCMECELL failed for ' || avs_sc || ',' || avs_me || ', ' || avs_cell || ', Error code <' || l_ret_code || '>';
     UNAPIGEN.LOGERROR (lcs_function_name,lvs_sqlerrm );
     RETURN UNAPIGEN.DBERR_GENFAIL;
  END IF;

     FOR  l_row IN 1..l_nr_of_rows LOOP
         l_value_s_tab(l_row) := avs_value;
         l_modify_flag_tab(l_row) := UNAPIGEN.MOD_FLAG_UPDATE;
         l_next_rows      :=  -1; -- just 1 call
     END  LOOP;
     l_ret_code       := UNAPIME.SAVESCMECELL
                   (avs_completed,
                    l_sc_tab,
                    l_pg_tab,
                    l_pgnode_tab,
                    l_pa_tab,
                    l_panode_tab,
                    l_me_tab,
                    l_menode_tab,
                    l_reanalysis_tab,
                    l_cell_tab,
                    l_cellnode_tab,
                    l_dsp_title_tab,
                    l_value_f_tab,
                    l_value_s_tab,
                    l_cell_tp_tab,
                    l_pos_x_tab,
                    l_pos_y_tab,
                    l_align_tab,
                    l_winsize_x_tab,
                    l_winsize_y_tab,
                    l_is_protected_tab,
                    l_mandatory_tab,
                    l_hidden_tab,
                    l_unit_tab,
                    l_format_tab,
                    l_eq_tab,
                    l_eq_version_tab,
                    l_component_tab,
                    l_calc_tp_tab,
                    l_calc_formula_tab,
                    l_valid_cf_tab,
                    l_max_x_tab,
                    l_max_y_tab,
                    l_multi_select_tab,
                    l_modify_flag_tab,
                    l_nr_of_rows,
                    l_next_rows);

  RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END SaveMECell;

FUNCTION SaveLongText(avsFileName IN VARCHAR2, avs_id OUT VARCHAR2)
RETURN INTEGER IS
  lvi_ret_code         iapiType.ErrorNum_Type;
  lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SaveLongText';
  lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;

   -- Specific local  variables
  l_uc                 VARCHAR2(20);
  l_st                 VARCHAR2(20);
  l_st_version         VARCHAR2(20);
  l_rt                 VARCHAR2(20);
  l_rt_version         VARCHAR2(20);
  l_rq                 VARCHAR2(20);
  l_ref_date           TIMESTAMP WITH TIME ZONE;
  l_next_val           VARCHAR2(255);
  l_edit_allowed       CHAR(1);
  l_valid_cf           VARCHAR2(20);

  -- savelongtext
 l_obj_id              UNAPIGEN.VC20_TABLE_TYPE;
 l_obj_tp              UNAPIGEN.VC20_TABLE_TYPE;
 l_doc_id              UNAPIGEN.VC40_TABLE_TYPE;
 l_doc_tp              UNAPIGEN.VC20_TABLE_TYPE;
 l_doc_name            UNAPIGEN.VC40_TABLE_TYPE;
 l_text_line           UNAPIGEN.VC2000_TABLE_TYPE;
 l_nr_of_rows          NUMBER;
 avsFqFileName         VARCHAR2(255);
begin

  -- Generate Unique Code Mask
  -- IN and IN  OUT arguments
  l_uc             := 'doc_link';
  l_st             := '';
  l_st_version     := UNVERSION.P_NO_VERSION;
  l_rt             := '';
  l_rt_version     := UNVERSION.P_NO_VERSION;
  l_rq             := null;
  l_ref_date       := sysdate;

  lvi_ret_code       :=  UNAPIUC.CREATENEXTUNIQUECODEVALUE
                   (l_uc,
                    l_st,
                    l_st_version,
                    l_rt,
                    l_rt_version,
                    l_rq,
                    l_ref_date,
                    l_next_val,
                    l_edit_allowed,
                    l_valid_cf);

  IF lvi_ret_code  <> UNAPIGEN.DBERR_SUCCESS THEN
    lvs_sqlerrm := 'CREATENEXTUNIQUECODEVALU failed for ' || l_uc || ', Error code <' || lvi_ret_code || '>';
     UNAPIGEN.LOGERROR (lcs_function_name,lvs_sqlerrm );
     RETURN UNAPIGEN.DBERR_GENFAIL;
  END IF;
  avs_id := SUBSTR(TRIM(l_next_val),1,20);

 -- array IN and IN OUT arguments
  l_nr_of_rows     := 1;
  avsFqFileName := getFQfileName(avsFileName, FALSE);
  FOR l_row IN 1..l_nr_of_rows LOOP
     l_obj_id(l_row) := '<cell>';
     l_obj_tp(l_row) := 'mece';
     l_doc_id(l_row) := avs_id;
     l_doc_tp(l_row) := '' ;
     l_doc_name(l_row) := avs_id;
     l_text_line(l_row) := 'file:' || avsFqFileName;
  END LOOP;

  lvi_ret_code := unapigen.savelongtext (
                                     a_obj_id => l_obj_id
                                    ,a_obj_tp => l_obj_tp
                                    ,a_doc_id => l_doc_id
                                    ,a_doc_tp => l_doc_tp
                                    ,a_doc_name => l_doc_name
                                    ,a_text_line => l_text_line
                                    ,a_nr_of_rows => l_nr_of_rows
                                    ,a_next_rows => -1
                                );
  IF lvi_ret_code  <> UNAPIGEN.DBERR_SUCCESS THEN
     lvs_sqlerrm := 'savelongtext failed for ' || avs_id || ', ' ||avsFqFileName || ' , Error code <' || lvi_ret_code || '>';
     UNAPIGEN.LOGERROR (lcs_function_name,lvs_sqlerrm );
     RETURN UNAPIGEN.DBERR_GENFAIL;
  END IF;

RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END SaveLongText;

FUNCTION SaveBlob (avsFileName IN VARCHAR2, l_raw IN aapiblob.t_raw@interspec, avs_id OUT VARCHAR2)
RETURN INTEGER IS
  l_index pls_integer;
  l_blob blob;
  lvi_ret_code            iapiType.ErrorNum_Type;
  lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SaveBlob';
  lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
   -- Specific local  variables
  l_uc                        VARCHAR2(20);
  l_st                        VARCHAR2(20);
  l_st_version                VARCHAR2(20);
  l_rt                        VARCHAR2(20);
  l_rt_version                VARCHAR2(20);
  l_rq                        VARCHAR2(20);
  l_ref_date                  TIMESTAMP WITH TIME ZONE;
  l_next_val                  VARCHAR2(255);
  l_edit_allowed              CHAR(1);
  l_valid_cf                  VARCHAR2(20);
  avsFqFileName              VARCHAR2(255);
begin
  --
  -- Generate from raw table a BLOB
  dbms_lob.createtemporary(l_blob, true);
  dbms_lob.open(l_blob, dbms_lob.lob_readwrite);
  --
  l_index := l_raw.first;
  while l_index is not null
  loop
    dbms_lob.writeappend(l_blob, utl_raw.length(l_raw(l_index)), l_raw(l_index));
    l_index := l_raw.next(l_index);
  end loop;
  --
  dbms_lob.close(l_blob);

  -- Generate Unique Code Mask
  -- IN and IN  OUT arguments
  l_uc             := 'doc_blob';
  l_st             := '';
  l_st_version     := UNVERSION.P_NO_VERSION;
  l_rt             := '';
  l_rt_version     := UNVERSION.P_NO_VERSION;
  l_rq             := null;
  l_ref_date       := sysdate;

  lvi_ret_code       :=  UNAPIUC.CREATENEXTUNIQUECODEVALUE
                   (l_uc,
                    l_st,
                    l_st_version,
                    l_rt,
                    l_rt_version,
                    l_rq,
                    l_ref_date,
                    l_next_val,
                    l_edit_allowed,
                    l_valid_cf);

  IF lvi_ret_code  <> UNAPIGEN.DBERR_SUCCESS THEN
    lvs_sqlerrm := 'CREATENEXTUNIQUECODEVALU failed for ' || l_uc || ', Error code <' || lvi_ret_code || '>';
     UNAPIGEN.LOGERROR (lcs_function_name,lvs_sqlerrm );
     RETURN UNAPIGEN.DBERR_GENFAIL;
  END IF;
    avsFqFileName := getFQfileName(avsFileName, FALSE);
    avs_id := l_next_val;
    lvi_ret_code := unapifi.saveblob
                             (a_id => avs_id
                             ,a_description => avsFileName
                             ,a_object_link => null
                             ,a_key_1 => null
                             ,a_key_2 => null
                             ,a_key_3 => null
                             ,a_key_4 => null
                             ,a_key_5 => null
                             ,a_url => avsFqFileName
                             ,a_data => l_blob
                             ,a_modify_reason => 'APAOFEA.SaveBlob');
  IF lvi_ret_code  <> UNAPIGEN.DBERR_SUCCESS THEN
     lvs_sqlerrm := 'saveblob failed for ' || avs_id || ', ' ||avsFqFileName || ' , Error code <' || lvi_ret_code || '>';
     UNAPIGEN.LOGERROR (lcs_function_name,lvs_sqlerrm );
     RETURN UNAPIGEN.DBERR_GENFAIL;
  END IF;
RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END SaveBlob;


FUNCTION writeMeshDefinitionFile (avs_me IN VARCHAR2, avsFileName IN VARCHAR2, avsFqFileName OUT VARCHAR2 )
RETURN INTEGER IS
  l_blob blob;
  lvi_ret_code      iapiType.ErrorNum_Type;
  lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'writeMeshDefinitionFile';
  lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
  lvs_id            VARCHAR2(255);
  lvs_fileName      VARCHAR2(40);
  lvsDirName        VARCHAR2(255);
  a_key_1           VARCHAR2(20);
  a_key_2           VARCHAR2(20);
  a_key_3           VARCHAR2(20);
  a_key_4           VARCHAR2(20);
  a_key_5           VARCHAR2(20);
  a_url             VARCHAR2(255);
  a_object_link     VARCHAR2(255);

  --http://www.idevelopment.info/data/Oracle/DBA_tips/LOBs/LOBS_10.shtml
  v_buffer       RAW(32767);
  v_buffer_size  BINARY_INTEGER;
  v_amount       BINARY_INTEGER;
  v_offset       NUMBER(38) := 1;
  v_chunksize    INTEGER;
  v_out_file     UTL_FILE.FILE_TYPE;
BEGIN
        lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
     -- Get MeshDefinition file which is an attribute of the SX000A methode. The attribute is a BLOB
     -- Write the BLOB to file AND append 1 additional line to it
     BEGIN
        SELECT MTAU.value
          INTO lvs_id
          FROM utmt MT, utmtau MTAU
--          WHERE MT.mt        = 'SX000A'
          WHERE MT.mt        = avs_me
            AND MT.version_is_current = '1'
            AND MTAU.version = MT.version
            AND MTAU.au      = 'avMeshDefinition';
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
                UNAPIGEN.LogError (lcs_function_name, 'No avMeshDefinition attribute found for me: ' || avs_me || ' for ' || avsFileName);
        RETURN UNAPIGEN.DBERR_GENFAIL;
     END;

     --TODO
     --lvs_id := '2015-0416-0006#BLB'; -- TEN BEHOEVE VAN TEST om wel even verder te kunnen moet straks natuurlijk WEG !!!!
     lvi_ret_code := unapifi.GetBlob
                       (lvs_id
                       ,lvs_filename
                       ,a_object_link
                       ,a_key_1
                       ,a_key_2
                       ,a_key_3
                       ,a_key_4
                       ,a_key_5
                       ,a_url
                       ,l_blob);
        IF lvi_ret_code  <> UNAPIGEN.DBERR_SUCCESS THEN
        lvs_sqlerrm := 'GetBlob failed for '  || avs_me || ', ' || avsFileName || ', Error code <' || lvi_ret_code || '>';
         UNAPIGEN.LOGERROR (lcs_function_name,lvs_sqlerrm );
         RETURN UNAPIGEN.DBERR_GENFAIL;
      END IF;

    v_chunksize := DBMS_LOB.GETCHUNKSIZE(l_blob);
    IF (v_chunksize < 32767) THEN
          v_buffer_size := v_chunksize;
      ELSE
          v_buffer_size := 32767;
    END IF;
    v_amount := v_buffer_size;

    DBMS_LOB.OPEN(l_blob, DBMS_LOB.LOB_READONLY);
    v_out_file := UTL_FILE.FOPEN(
        location      => 'FEA_DIR',
        filename      =>  avsFileName,
        open_mode     => 'wb',
        max_linesize  => 32767);

    WHILE v_amount >= v_buffer_size  LOOP
          DBMS_LOB.READ(
              lob_loc    => l_blob,
              amount     => v_amount,
              offset     => v_offset,
              buffer     => v_buffer);
          v_offset := v_offset + v_amount;
          UTL_FILE.PUT_RAW (
              file      => v_out_file,
              buffer    => v_buffer,
              autoflush => true);
          UTL_FILE.FFLUSH(file => v_out_file);
    END LOOP;
    SELECT directory_path
        INTO lvsDirName
      FROM all_directories
      WHERE DIRECTORY_NAME = 'FEA_DIR';
    avsFqFileName := getFQfileName(REPLACE(avsFileName,'csv','inc'), FALSE);
    UNAPIGEN.LogError (lcs_function_name, '05-MeshFile: ' || avsFqFileName);
    /*
    UTL_FILE.NEW_LINE(file => v_out_file);
    v_buffer := utl_raw.cast_to_raw('EXPORT_FILENAME; ' || avsFqFileName);
    UTL_FILE.PUT_RAW (
          file      => v_out_file,
          buffer    => v_buffer,
          autoflush => true);
    UTL_FILE.FFLUSH(file => v_out_file);
    */
    UTL_FILE.FCLOSE(v_out_file);
    DBMS_LOB.CLOSE(l_blob);
    v_out_file := UTL_FILE.fopen ('FEA_DIR', avsFileName, 'a');
    UTL_FILE.NEW_LINE(file => v_out_file);
    utl_file.put_line(v_out_file, 'EXPORT_FILENAME; ' || avsFqFileName);
    UTL_FILE.FFLUSH(file => v_out_file);
    UTL_FILE.FCLOSE(v_out_file);
    avsFqFileName := getFQfileName(avsFileName, FALSE); -- return the CSV name
    RETURN lvi_ret_code;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END writeMeshDefinitionFile;

FUNCTION writeFile (avs_id IN VARCHAR2)
RETURN INTEGER IS
  l_blob blob;
  lvi_ret_code            iapiType.ErrorNum_Type;
  lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'writeFile';
  lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
  lvs_fileName       VARCHAR2(40);
  lvsDirName        VARCHAR2(255);
  a_key_1           VARCHAR2(20);
  a_key_2           VARCHAR2(20);
  a_key_3           VARCHAR2(20);
  a_key_4           VARCHAR2(20);
  a_key_5           VARCHAR2(20);
  a_url             VARCHAR2(255);
  a_object_link     VARCHAR2(255);

  v_buffer       RAW(32767);
  v_buffer_size  BINARY_INTEGER;
  v_amount       BINARY_INTEGER;
  v_offset       NUMBER(38) := 1;
  v_chunksize    INTEGER;
  v_out_file     UTL_FILE.FILE_TYPE;
BEGIN
     lvi_ret_code := unapifi.GetBlob
                       (avs_id
                       ,lvs_filename
                       ,a_object_link
                       ,a_key_1
                       ,a_key_2
                       ,a_key_3
                       ,a_key_4
                       ,a_key_5
                       ,a_url
                       ,l_blob);
        IF lvi_ret_code  <> UNAPIGEN.DBERR_SUCCESS THEN
        lvs_sqlerrm := 'GetBlob failed for '  || avs_id || ', ' || lvs_fileName || ', Error code <' || lvi_ret_code || '>';
         UNAPIGEN.LOGERROR (lcs_function_name,lvs_sqlerrm );
         RETURN UNAPIGEN.DBERR_GENFAIL;
      END IF;

    v_chunksize := DBMS_LOB.GETCHUNKSIZE(l_blob);
    IF (v_chunksize < 32767) THEN
          v_buffer_size := v_chunksize;
      ELSE
          v_buffer_size := 32767;
    END IF;
    v_amount := v_buffer_size;

    DBMS_LOB.OPEN(l_blob, DBMS_LOB.LOB_READONLY);
    v_out_file := UTL_FILE.FOPEN(
        location      => 'FEA_DIR',
        filename      =>  lvs_fileName,
        open_mode     => 'wb',
        max_linesize  => 32767);

    WHILE v_amount >= v_buffer_size  LOOP
          DBMS_LOB.READ(
              lob_loc    => l_blob,
              amount     => v_amount,
              offset     => v_offset,
              buffer     => v_buffer);
          v_offset := v_offset + v_amount;
          UTL_FILE.PUT_RAW (
              file      => v_out_file,
              buffer    => v_buffer,
              autoflush => true);
          UTL_FILE.FFLUSH(file => v_out_file);
    END LOOP;
    SELECT directory_path
        INTO lvsDirName
      FROM all_directories
      WHERE DIRECTORY_NAME = 'FEA_DIR';

    UTL_FILE.FCLOSE(v_out_file);
    DBMS_LOB.CLOSE(l_blob);

    RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END writeFile;

FUNCTION GetISfiles (avsSc      IN VARCHAR2,
                    avsPg        IN VARCHAR2,
                    avnPgnode    IN NUMBER,
                    avsPa        IN VARCHAR2,
                    avnPanode   IN NUMBER,
                    avsMe       IN VARCHAR2,
                    avnMenode    IN NUMBER,
                    avsImportid IN VARCHAR2,
                    avsPartNo   IN VARCHAR,
                    avnRevision IN VARCHAR2,
                    avsCatPart  OUT VARCHAR2,
                    avsError    OUT VARCHAR2)
RETURN INTEGER IS
lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GetISfiles';
lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code            iapiType.ErrorNum_Type;
lvi_ret_code2           NUMBER; -- internal error code
lvs_fileName            VARCHAR2(40);
lvs_id                  VARCHAR2(20);
l_raw aapiblob.t_raw@interspec;

BEGIN
    lvi_ret_code  := UNAPIGEN.DBERR_SUCCESS;
    lvi_ret_code2 := UNAPIGEN.DBERR_SUCCESS;
    avsError := '';

    ------------------------------------------------------------------------------------
    -- 1) call INTERSPEC function aapiFea.GetHyperMaterialfile
    ------------------------------------------------------------------------------------
    /* 2015-11-06, when a 337 is returned, one of the selects in INTERSPEC failed, but there can still be an output file generated.
       So this file must be attached/written, etc
    */
    lvi_ret_code := aapiFea.GetHyperMaterialfile@INTERSPEC(avsPartNo, avnRevision, l_raw);
    IF (lvi_ret_code != UNAPIGEN.DBERR_SUCCESS) AND (lvi_ret_code != DBERR_OBJECTNOTFOUND) THEN
         lvs_sqlerrm := 'aapiFea.GetHyperMaterialfile failed for "' || avsPartNo || ' [' || avnRevision || ']". Error code <' || lvi_ret_code || '>';
         UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
         lvi_ret_code2 := lvi_ret_code;
         avsError := avsError || 'aapiFea.GetHyperMaterialfile failed';
    ELSE
        lvs_fileName := avsSc || '_' || avsImportid || '_material.inc';
        lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, '1) GetHyperMaterialfile generated: ' || lvs_fileName);
        --UNAPIGEN.LogError (lcs_function_name, '01-HyperElastic: ' || lvs_fileName);
        IF (lvi_ret_code = DBERR_OBJECTNOTFOUND) THEN
            lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, '1) GetHyperMaterialfile returned object not found');
        END IF;
        lvi_ret_code := SaveBlob(lvs_fileName, l_raw, lvs_id);
        lvi_ret_code := SaveMECell(avsSc, avsMe, 'hyper_file_blb', lvs_id, 0);

        lvi_ret_code := writeFile(lvs_id);
        lvi_ret_code := SaveLongText(lvs_fileName, lvs_id);
        lvi_ret_code := SaveMECell(avsSc, avsMe, 'hyper_file_lnk', lvs_id, 0);
    END IF;

    ------------------------------------------------------------------------------------
    -- 2) call INTERSPEC function aapiFea.GetRRMaterialfile
    ------------------------------------------------------------------------------------
    lvi_ret_code := aapiFea.GetRRMaterialfile@INTERSPEC(avsPartNo, avnRevision, l_raw);
    IF (lvi_ret_code != UNAPIGEN.DBERR_SUCCESS) AND (lvi_ret_code != DBERR_OBJECTNOTFOUND) THEN
         lvs_sqlerrm := 'aapiFea.GetRRMaterialfile failed for "' || avsPartNo || ' [' || avnRevision || ']". Error code <' || lvi_ret_code || '>';
         UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
         IF lvi_ret_code2 = UNAPIGEN.DBERR_SUCCESS THEN
            -- no previous error so 'overwrite' the error
            lvi_ret_code2 := lvi_ret_code;
         END IF;
         avsError := avsError || '; aapiFea.GetRRMaterialfile failed';
    ELSE
        lvs_fileName := avsSc || '_' || avsImportid || '_material.tan';
        lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, '2) GetRRMaterialfile generated: ' || lvs_fileName);
        --UNAPIGEN.LogError (lcs_function_name, '02-TanDelta: ' || lvs_fileName);
        IF (lvi_ret_code = DBERR_OBJECTNOTFOUND) THEN
            lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, '2) GetRRMaterialfile returned object not found');
        END IF;
        lvi_ret_code := SaveBlob(lvs_fileName, l_raw, lvs_id);
        lvi_ret_code := SaveMECell(avsSc, avsMe, 'Tandelta_file_blb', lvs_id, 0);

        lvi_ret_code := writeFile(lvs_id);
        lvi_ret_code := SaveLongText(lvs_fileName, lvs_id);
        lvi_ret_code := SaveMECell(avsSc, avsMe, 'Tandelta_file_lnk', lvs_id, 0);
    END IF;

    ------------------------------------------------------------------------------------
    -- 3) call INTERSPEC function aapiFea.GetCatPart
    ------------------------------------------------------------------------------------
    avsCatPart :=  NULL;
    lvi_ret_code := aapiFea.GetCatPart@INTERSPEC(avsPartNo, avnRevision, l_raw);
    IF (lvi_ret_code != UNAPIGEN.DBERR_SUCCESS) AND (lvi_ret_code != DBERR_OBJECTNOTFOUND) THEN
         lvs_sqlerrm := 'aapiFea.GetCatPart failed for "' || avsPartNo || ' [' || avnRevision || ']". Error code <' || lvi_ret_code || '>';
         UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
         IF lvi_ret_code2 = UNAPIGEN.DBERR_SUCCESS THEN
            -- no previous error so 'overwrite' the error
            lvi_ret_code2 := 2001;
         END IF;
         avsError := avsError || '; aapiFea.GetCatPart failed';
    ELSE
        lvs_fileName := avsSc || '_' || avsImportid || '.catpart';
        lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, '3) GetCatPart generated: ' || lvs_fileName);
        --UNAPIGEN.LogError (lcs_function_name, '03-Cavity catpart: ' || lvs_fileName);
        IF (lvi_ret_code = DBERR_OBJECTNOTFOUND) THEN
            lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, '3) GetCatPart returned object not found');
        END IF;
        avsCatPart := lvs_fileName;
        lvi_ret_code := SaveBlob(lvs_fileName, l_raw, lvs_id);
        lvi_ret_code := SaveMECell(avsSc, avsMe, 'cavity_file_blb', lvs_id, 0);
        lvi_ret_code := writeFile(lvs_id);
    END IF;

    RETURN lvi_ret_code2;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END GetISfiles;

FUNCTION getFeaSetting (avsCD IN VARCHAR2, avsEQ IN VARCHAR2, avsSetting IN VARCHAR2, avsSc IN VARCHAR2)
RETURN VARCHAR2 IS
  lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'getFeaSetting';
  lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
  lvs_value               VARCHAR2(255);
BEGIN

	BEGIN
		 SELECT setting_value
			INTO lvs_value
            FROM uteqcd
		  WHERE eq = avsEQ
			AND LOWER(setting_name) = avsSetting
			AND cd = avsCD;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			UNAPIGEN.LogError (lcs_function_name, 'No uteqcd value found for : ' || avsSetting || ' for equipment ' || avsEQ || '; for sample: ' || avsSc);
			lvs_value := NULL;
	END;

	RETURN lvs_value;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END getFeaSetting;


--    Meshing, actually Unilab meshing process
--
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 08/06/2017 | JR        | Modified Meshing, make use of psexec.exe to execute Hypermesh script
-- 29/08/2017 | JR        | Now getting psexec variables from equipment
--
FUNCTION Meshing (avsSc           IN VARCHAR2,
                    avsPg          IN VARCHAR2,
                    avnPgnode      IN NUMBER,
                    avsPa          IN VARCHAR2,
                    avnPanode     IN NUMBER,
                    avsMe         IN VARCHAR2,
                    avnMenode      IN NUMBER,
                    avsSs         IN VARCHAR2,
                    avsLc         IN VARCHAR2,
                    avsLcVersion  IN VARCHAR2,
                    avnReanalysis IN NUMBER,
                    avsPartNo     IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
    lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'Meshing';
    lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
    lvi_ret_code            iapiType.ErrorNum_Type;
    lvs_modify_reason   VARCHAR2(255);
    lvs_importid        VARCHAR2(40);
    lvs_fileName        VARCHAR2(40);
    lvsFqFileName       VARCHAR2(255);
    lvsCatPart          VARCHAR2(255);
    lvsError            VARCHAR2(255);
    lvs_id              VARCHAR2(255);
	lvs_cmd             VARCHAR2(255);
    lvn_total           NUMBER;
    lvs_eq              uteq.eq%TYPE;
    lvs_machine         UTEQCD.SETTING_VALUE%TYPE;
    lvs_user            UTEQCD.SETTING_VALUE%TYPE;
    lvs_password        UTEQCD.SETTING_VALUE%TYPE;
    lvs_step            VARCHAR2(3);
BEGIN
    lvs_step := '1';
    lvs_modify_reason := 'Changed by ' || lcs_function_name;
    BEGIN
       SELECT importid
         INTO lvs_importid
         FROM utscmegkimportid
         WHERE sc = avsSc
           AND pg = avsPg AND pgnode = avnPgnode
           AND pa = avsPa AND panode = avnPanode
           AND me = avsMe AND menode = avnMenode;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
           UNAPIGEN.LogError (lcs_function_name, 'No importid found for sc: ' || avsSc || ', me: ' || avsMe);
           RETURN UNAPIGEN.DBERR_GENFAIL;
   END;

   --UNAPIGEN.LogError (lcs_function_name, 'Before : ' || avsSc || ',' || avsPg ||',' || avnPgnode || ',' || avsPa || ',' || avnPanode || ',' || avsMe || ','|| avnMenode || ' from AV to IE');
   lvs_step := '2';
   lvi_ret_code := UNAPIMEP.CHANGESCMESTATUS(avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, avnReanalysis, 'AV', 'IE', avsLc, avsLcVersion, lvs_modify_reason);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'CHANGESCMESTATUS failed, for <' || avsSc || ',' || avsPg || ',' || avsPa || ',' || avsMe || '> from AV to IE';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   -------------------------------------------------
   -- GetIsFiles, which execute 3 INTERSPEC functions
   -------------------------------------------------
   lvs_step := '3';
   lvi_ret_code := GetISfiles(avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, lvs_importid, avsPartNo, NULL, lvsCatPart, lvsError);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
       lvi_ret_code := UNAPIMEP.CHANGESCMESTATUS(avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, avnReanalysis, 'IE', 'ER', avsLc, avsLcVersion, lvs_modify_reason);
       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
            lvs_sqlerrm := 'CHANGESCMESTATUS failed, for <' || avsSc || ',' || avsPg || ',' || avsPa || ',' || avsMe || '> from IE to ER';
            UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
        END IF;
       lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, lvsError);
   END IF;

   lvs_step := '4';
   lvsCatPart := getFQfileName(lvsCatPart, FALSE);
   lvs_fileName := avsSc || '_' || lvs_importid || '_mesh.csv';
   lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (avsSc, avsPg, avnPgnode, avsPa, avnPanode, avsMe, avnMenode, '4) MeshDefinitionFile: ' || lvs_fileName);
   --UNAPIGEN.LogError (lcs_function_name, '04-MeshDefinitionFile : ' || lvs_fileName);
   lvi_ret_code := writeMeshDefinitionFile(avsMe, lvs_fileName, lvsFqFileName);

   lvs_step := '5';
   lvi_ret_code := SaveLongText(REPLACE(lvs_fileName, '.csv', '.inc'), lvs_id);
   lvi_ret_code := SaveMECell(avsSc, avsMe, 'mesh_file_lnk', lvs_id, 0);     --  1 method is completed, 0 method is NOT completed
   -- 2015-08-20 discussed with HvB, for the time being the ME goes not to completed, if the meshing goes well, the complete will be returned via UNILINK

    IF LENGTH(lvsCatPart) > 0 AND LENGTH(lvsFqFileName) > 0 THEN
        lvs_step := '6';
        -------------------------------------------------
        -- Determine the equipment, for the correct Lab
        -------------------------------------------------
        lvs_eq := NULL;
        BEGIN
            SELECT eq.eq
              INTO lvs_eq
              FROM utscme   me
                 , utmt     mt
                 , uteqtype tp
                 , uteq     eq
             WHERE me.sc = avsSc
               AND me.pg = avsPg AND me.pgnode = avnPgnode
               AND me.pa = avsPa AND me.panode = avnPanode
               AND me.me = avsMe AND me.menode = avnMenode
               AND mt.mt = me.me
               AND mt.version_is_current = '1'
               AND tp.eq_tp = mt.eq_tp
               AND eq.eq = tp.eq
               AND eq.lab = me.lab;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                UNAPIGEN.LogError (lcs_function_name, 'No equipment found for sample : ' || avsSc);
            WHEN OTHERS THEN
                UNAPIGEN.LogError (lcs_function_name, SUBSTR('Error getting equipment for sample : ' || avsSc || '; '  || SQLERRM,0,255));
        END;

        lvs_step := '7';
        IF lvs_eq IS NOT NULL THEN
            -------------------------------------------------------------------------------
            --  Get server details on which the psexec/Hypermesh statement must be executed
            -------------------------------------------------------------------------------
            lvs_step := '7a';
            lvs_machine := '\\' || getFeaSetting('FEA', lvs_eq, 'machine', avsSc);
            lvs_user 	:= getFeaSetting('FEA', lvs_eq, 'user', avsSc);
            lvs_password:= getFeaSetting('FEA', lvs_eq, 'password', avsSc);
        END IF;

        lvs_step := '8';
        IF lvs_machine IS NOT NULL AND LENGTH(lvs_machine) > 0 THEN
            -------------------------------------------------
            -- Construct the command line command
            -------------------------------------------------
            --lvs_cmd := 'c:\HyperMesh\psexec.exe -d \\Hypermesh c:\HyperMesh\start_batch.bat ';
            lvs_step := '8a';
            lvs_cmd := 'c:\HyperMesh\psexec.exe -d ' || lvs_machine;
            IF lvs_user IS NOT NULL AND LENGTH(lvs_user) > 0 THEN
                lvs_cmd := lvs_cmd || ' -u ' || lvs_user;
            END IF;
            lvs_step := '8b';
            IF lvs_password IS NOT NULL AND LENGTH(lvs_password) > 0 THEN
                lvs_cmd := lvs_cmd || ' -p ' || lvs_password;
            END IF;
            lvs_step := '8c';
            lvs_cmd := lvs_cmd || ' c:\HyperMesh\start_batch.bat ' || lvsCatPart || ' ' || lvsFqFileName || ' ' || lvs_importid;
            IF LENGTH(lvs_cmd) > 255 THEN
                UNAPIGEN.LogError (lcs_function_name, 'Hypermesh/FEA ERROR, the constructed command is too long and cannot be processed!');
            ELSE
                lvs_step := '8d';
                -------------------------------------------------
                -- insert record for Client Event Manager (CEM))
                -------------------------------------------------
                INSERT INTO utclientalerts (alert_seq, alert_name, alert_data)
                    VALUES (SEQ_ALERT_NR.NEXTVAL, 'ExecuteCmdOnClient', lvs_cmd);

                --UNAPIGEN.LogError (lcs_function_name, 'Record inserted in utclientalerts -1 : ' || lvs_cmd || lvsCatPart );
                --UNAPIGEN.LogError (lcs_function_name, 'Record inserted in utclientalerts -2 : ' || lvsFqFileName || ' ' || lvs_importid );
                UNAPIGEN.LogError (lcs_function_name, lvs_cmd);
            END IF;
        ELSE
            UNAPIGEN.LogError (lcs_function_name, 'No machine specified for equipment : ' || lvs_eq || ' so no processing possible');
        END IF;
    END IF;
    RETURN lvi_ret_code;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, SUBSTR('Step: ' || lvs_step || ';SQL: ' || sqlerrm,0,255));
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END Meshing;

--  Process_SX100A
--
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 02/11/2017 | JR        | Created
-- 07/12/2017 | JR        | Query changed
-- 21/12/2017 | JR        | Altered process_SX100A (FileInfo, 30, remove quotation marks
FUNCTION Process_SX100A (avsSc IN VARCHAR2, avsFileName IN VARCHAR2, avsDir IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
    lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'Process_SX100A';
    lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
    lvi_ret_code            iapiType.ErrorNum_Type;
	v_out_file     UTL_FILE.FILE_TYPE;
 l_cell varchar2(32767) := ',D_rim,p_infl,w_rim,D_drum,F_z,alpha_REV,gamma,mu_tyre_road,mu_tyre_road_REV,';

    CURSOR lvq_SX100A IS
	SELECT rq
			 , sc
			 , infotype
			 , pa
			 , pgnode||panode panode
			 , celldescription
			 , fileid
			 , testmethod
			 , simulationstep
			 , simulationtype
			 , cellname
			 , cellvalue_s
			 , mt_desc
			 , me
			 , description
			 , importid
			 , blobid
		   FROM (
SELECT 10,rq.rq
			  , me.sc
			  , 'FileInfo'                        AS INFOTYPE
			  , me.pa
     , me.panode
     , me.pgnode
			  , cell.dsp_title                    AS CELLDESCRIPTION
--			  , NVL(blob.url,cell.value_s)        AS FILEID
			  , NVL(lnk.text_line,cell.value_s)        AS FILEID
			  , ''                                AS TESTMETHOD
			  , ''                                AS SIMULATIONSTEP
			  , ''                                AS SIMULATIONTYPE
			  , REPLACE(cell.cell, '_blb','_lnk') AS CELLNAME
			  , ''                                AS CELLVALUE_S
			  , ''                                AS MT_DESC
			  , ''                                AS ME
			  , ''                                AS Description
			  , ''                                AS importid
			  , case cell.cell_tp
					when 'D' then ''
					else  cell.value_s
				end                               AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utrqsc     rq
			  , utblob     blob
			  , utlongtext lnk
		   WHERE me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
			 AND cell.cell = 'ModelSymmetry'
			 AND cell.value_s = blob.id (+)
			 AND cell.value_s = lnk.doc_id (+)
			 AND rq.sc = me.sc
UNION
SELECT 10,rq.rq
			  , me.sc
			  , 'FileInfo'                        AS INFOTYPE
			  , me.pa
     , me.panode
     , me.pgnode
			  , cell.dsp_title                    AS CELLDESCRIPTION
--			  , NVL(blob.url,cell.value_s)        AS FILEID
			  , NVL(lnk.text_line,cell.value_s)        AS FILEID
			  , ''                                AS TESTMETHOD
			  , ''                                AS SIMULATIONSTEP
			  , ''                                AS SIMULATIONTYPE
			  , REPLACE(cell.cell, '_blb','_lnk') AS CELLNAME
			  , ''                                AS CELLVALUE_S
			  , ''                                AS MT_DESC
			  , ''                                AS ME
			  , ''                                AS Description
			  , ''                                AS importid
			  , case cell.cell_tp
					when 'D' then ''
					else  cell.value_s
				end                               AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utrqsc     rq
			  , utblob     blob
			  , utlongtext lnk
		   WHERE me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
			 AND cell.cell = 'ModelPortfolio'
			 AND cell.value_s = blob.id (+)
			 AND cell.value_s = lnk.doc_id (+)
			 AND rq.sc = me.sc			 
UNION
			 SELECT 20,rq.rq
			  , me.sc
			  , 'FileInfo'                        AS INFOTYPE
			  , me.pa
			  , me.panode
     , me.pgnode
			  , cell.dsp_title                    AS CELLDESCRIPTION
			  , NVL(blob.url,cell.value_s)        AS FILEID
			  , ''                                AS TESTMETHOD
			  , ''                                AS SIMULATIONSTEP
			  , ''                                AS SIMULATIONTYPE
			  , cell.cell AS CELLNAME
			  , ''                                AS CELLVALUE_S
			  , ''                                AS MT_DESC
			  , ''                                AS ME
			  , ''                                AS Description
			  , ''                                AS importid
			  , case cell.cell_tp
					when 'D' then ''
					else  cell.value_s
				end                               AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utrqsc     rq
			  , utblob     blob
		   WHERE me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
			 AND cell.cell = 'cavity_file_blb'
			 AND cell.value_s = blob.id
			 AND rq.sc = me.sc
UNION
			 SELECT 20,rq.rq
			  , me.sc
			  , 'FileInfo'                        AS INFOTYPE
			  , me.pa
			  , me.panode
     , me.pgnode
			  , cell.dsp_title                    AS CELLDESCRIPTION
			  , NVL(blob.url,cell.value_s)        AS FILEID
			  , ''                                AS TESTMETHOD
			  , ''                                AS SIMULATIONSTEP
			  , ''                                AS SIMULATIONTYPE
			  , cell.cell AS CELLNAME
			  , ''                                AS CELLVALUE_S
			  , ''                                AS MT_DESC
			  , ''                                AS ME
			  , ''                                AS Description
			  , ''                                AS importid
			  , case cell.cell_tp
					when 'D' then ''
					else  cell.value_s
				end                               AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utrqsc     rq
			  , utblob     blob
		   WHERE me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
			 AND cell.cell = 'cavity_file_blb'
			 AND cell.value_s = blob.id
			 AND rq.sc = me.sc
UNION
			 SELECT 30,rq.rq
			  , me.sc
			  , 'FileInfo'                        AS INFOTYPE
			  , me.pa
			  , me.panode
     , me.pgnode
			  , cell.dsp_title                    AS CELLDESCRIPTION
			  , REPLACE(NVL(lnk.text_line,cell.value_s),'"','')   AS FILEID
			  , ''                                AS TESTMETHOD
			  , ''                                AS SIMULATIONSTEP
			  , ''                                AS SIMULATIONTYPE
			  , celllnk.cell AS CELLNAME
			  , ''                                AS CELLVALUE_S
			  , ''                                AS MT_DESC
			  , ''                                AS ME
			  , ''                                AS Description
			  , ''                                AS importid
			  , case cell.cell_tp
					when 'D' then ''
					else  cell.value_s
				end                               AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utscmecell celllnk
			  , utrqsc     rq
			  , utblob     blob
			  , utlongtext lnk
		   WHERE me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
			 AND cell.cell = 'mesh_file_blb'
			 AND cell.value_s = blob.id (+)
             AND me.sc = celllnk.sc
			 AND me.pg = celllnk.pg AND me.pgnode = celllnk.pgnode
			 AND me.pa = celllnk.pa AND me.panode = celllnk.panode
			 AND me.me = celllnk.me AND me.menode = celllnk.menode
			 AND celllnk.cell = 'mesh_file_lnk'
			 AND celllnk.value_s = lnk.doc_id (+)
			 AND rq.sc = me.sc
UNION
			 SELECT 40,rq.rq
			  , me.sc
			  , 'FileInfo'                        AS INFOTYPE
			  , me.pa
			  , me.panode
     , me.pgnode
			  , cell.dsp_title                    AS CELLDESCRIPTION
			  , NVL(lnk.text_line,cell.value_s)        AS FILEID
			  , ''                                AS TESTMETHOD
			  , ''                                AS SIMULATIONSTEP
			  , ''                                AS SIMULATIONTYPE
			  , celllnk.cell AS CELLNAME
			  , ''                                AS CELLVALUE_S
			  , ''                                AS MT_DESC
			  , ''                                AS ME
			  , ''                                AS Description
			  , ''                                AS importid
			  , case cell.cell_tp
					when 'D' then ''
					else  cell.value_s
				end                               AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utscmecell celllnk
			  , utrqsc     rq
			  , utblob     blob
			  , utlongtext lnk
		   WHERE me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
			 AND cell.cell = 'hyper_file_blb'
			 AND cell.value_s = blob.id (+)
             AND me.sc = celllnk.sc
			 AND me.pg = celllnk.pg AND me.pgnode = celllnk.pgnode
			 AND me.pa = celllnk.pa AND me.panode = celllnk.panode
			 AND me.me = celllnk.me AND me.menode = celllnk.menode
			 AND celllnk.cell = 'hyper_file_lnk'
			 AND celllnk.value_s = lnk.doc_id (+)
			 AND rq.sc = me.sc
UNION
			 SELECT 50,rq.rq
			  , me.sc
			  , 'FileInfo'                        AS INFOTYPE
			  , me.pa
			  , me.panode
     , me.pgnode
			  , cell.dsp_title                    AS CELLDESCRIPTION
			  , NVL(lnk.text_line,cell.value_s)        AS FILEID
			  , ''                                AS TESTMETHOD
			  , ''                                AS SIMULATIONSTEP
			  , ''                                AS SIMULATIONTYPE
			  , celllnk.cell AS CELLNAME
			  , ''                                AS CELLVALUE_S
			  , ''                                AS MT_DESC
			  , ''                                AS ME
			  , ''                                AS Description
			  , ''                                AS importid
			  , case cell.cell_tp
					when 'D' then ''
					else  cell.value_s
				end                               AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utscmecell celllnk
			  , utrqsc     rq
			  , utblob     blob
			  , utlongtext lnk
		   WHERE me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
			 AND cell.cell = 'Tandelta_file_blb'
			 AND cell.value_s = blob.id (+)
             AND me.sc = celllnk.sc
			 AND me.pg = celllnk.pg AND me.pgnode = celllnk.pgnode
			 AND me.pa = celllnk.pa AND me.panode = celllnk.panode
			 AND me.me = celllnk.me AND me.menode = celllnk.menode
			 AND celllnk.cell = 'Tandelta_file_lnk'
			 AND celllnk.value_s = lnk.doc_id (+)
			 AND rq.sc = me.sc
		UNION
		 SELECT 200, rq.rq
			  , me.sc
			  , 'SimulationStep'                            AS INFOTYPE
			  , me.pa
			  , me.panode
     , me.pgnode
			  , ''                                          AS CELLDESCRIPTION
			  , ''                                          AS FILEID
			  , megk1.value || ' (' || megk2.value || ')'   AS TESTMETHOD
			  , SUBSTR(meau.value,1,1)                      AS SIMULATIONSTEP
			  , SUBSTR(meau.value,4)                        AS SIMULATIONTYPE
			  , cell.cell                                   AS CELLNAME
			  , cell.value_s                                AS CELLVALUE_S
			  , ''                                          AS MT_DESC
			  , ''                                          AS ME
			  , ''                                          AS Description
			  , ''                                          AS importid
			  , ''                                          AS blobid
		   FROM utscme     me
			  , utscmecell cell
			  , utscmegk   megk1
			  , utscmegk   megk2
			  , utscmeau   meau
			  , utrqsc     rq
     WHERE exists (select 1
                   from utscme meexs
                   where me.sc = meexs.sc
                   and me.pg = meexs.pg and me.pgnode = meexs.pgnode
                   and me.pa = meexs.pa and me.panode = meexs.panode
                   and meexs.ss = 'AV')
		   AND me.sc = avsSc
			 AND me.ss = 'CM'
			 AND me.sc = cell.sc
    and cell.mandatory = 2
			 AND me.pg = cell.pg AND me.pgnode = cell.pgnode
			 AND me.pa = cell.pa AND me.panode = cell.panode
			 AND me.me = cell.me AND me.menode = cell.menode
    AND instr(l_cell, ','||cell.cell||',') > 0
			 --AND cell.cell IN ('D_rim', 'p_infl', 'w_rim', 'D_drum', 'F_z', 'alpha_REV', 'gamma', 'mu_tyre_road', 'mu_tyre_road_REV' )
			 AND me.sc = megk1.sc
			 AND me.pg = megk1.pg AND me.pgnode = megk1.pgnode
			 AND me.pa = megk1.pa AND me.panode = megk1.panode
			 AND me.me = megk1.me AND me.menode = megk1.menode
			 and megk1.gk = 'avTestMethod'
			 AND me.sc = megk2.sc
			 AND me.pg = megk2.pg AND me.pgnode = megk2.pgnode
			 AND me.pa = megk2.pa AND me.panode = megk2.panode
			 AND me.me = megk2.me AND me.menode = megk2.menode
			 and megk2.gk = 'avTestMethodDesc'
			 AND me.sc = meau.sc
			 AND me.pg = meau.pg AND me.pgnode = meau.pgnode
			 AND me.pa = meau.pa AND me.panode = meau.panode
			 AND me.me = meau.me AND me.menode = meau.menode
			 AND meau.au = 'avFeaSimType'
			 AND rq.sc = me.sc
		UNION
		SELECT 300, rq.rq
			  , me.sc
			  , 'ImportInfo'                               AS INFOTYPE
			  , me.pa
			  , me.panode
     , me.pgnode
			  , ''                                         AS CELLDESCRIPTION
			  , ''                                         AS FILEID
			  , ''                                         AS TESTMETHOD
			  , ''                                         AS SIMULATIONSTEP
			  , ''                                         AS SIMULATIONTYPE
			  , ''                                         AS CELLNAME
			  , ''                                         AS CELLVALUE_S
			  , megk1.value || ' (' || megk2.value || ')'  AS MT_DESC
			  , me.me                                      AS ME
			  , me.DESCRIPTION                             AS Description
			  , megk3.value                                AS importid
			  , ''                                         AS blobid
		   FROM utscme     me
			  , utscmegk   megk1
			  , utscmegk   megk2
			  , utscmegk   megk3
			  , utrqsc     rq
		   WHERE me.sc = avsSc
			 AND me.ss = 'AV'
			 AND me.me <> 'SX100A'
			 AND me.sc = megk1.sc
			 AND me.pg = megk1.pg AND me.pgnode = megk1.pgnode
			 AND me.pa = megk1.pa AND me.panode = megk1.panode
			 AND me.me = megk1.me AND me.menode = megk1.menode
			 and megk1.gk = 'avTestMethod'
			 AND me.sc = megk2.sc
			 AND me.pg = megk2.pg AND me.pgnode = megk2.pgnode
			 AND me.pa = megk2.pa AND me.panode = megk2.panode
			 AND me.me = megk2.me AND me.menode = megk2.menode
			 and megk2.gk = 'avTestMethodDesc'
			 AND me.sc = megk3.sc
			 AND me.pg = megk3.pg AND me.pgnode = megk3.pgnode
			 AND me.pa = megk3.pa AND me.panode = megk3.panode
			 AND me.me = megk3.me AND me.menode = megk3.menode
			 and megk3.gk = 'ImportId'
			 AND rq.sc = me.sc
ORDER BY 1
);

	v_line 		VARCHAR2(300);
	v_sep		VARCHAR2(1)  := CHR(9); -- TAB as seperator
BEGIN
  v_out_file := UTL_FILE.FOPEN(
        location      => avsDir,
        filename      =>  avsFileName,
        open_mode     => 'w',
        max_linesize  => 32767);
  v_line := 'RQ        SC        INFOTYPE        PA        PANODE        CELLDESCRIPTION        FILEID        TESTMETHOD        SIMULATIONSTEP        SIMULATIONTYPE        CELLNAME        CELLVALUE_S        MT_DESC        ME        DESCRIPTION        IMPORTID        BLOBID';
  UTL_FILE.PUT_LINE(v_out_file, v_line);
  --
  l_cell := ',';
  --
  for r_cll in (select
                distinct cll.cell
                from     utscmecell cll
                ,        utscmeau sma
                where    cll.sc = avsSc
                and      cll.mandatory = 2
                and      sma.au = 'avFeaSimType'
                and      cll.sc = sma.sc
                and      cll.pg = sma.pg and cll.pgnode = sma.pgnode
                and      cll.pa = sma.pa and cll.panode = sma.panode
                and      cll.me = sma.me and cll.menode = sma.menode)
  loop
    l_cell := l_cell||r_cll.cell||',';
  end loop;
  --
  FOR lvr IN lvq_SX100A LOOP
    v_line := lvr.rq 				|| v_sep ||
			  lvr.sc 				|| v_sep ||
			  lvr.infotype 			|| v_sep ||
			  lvr.pa 				|| v_sep ||
			  lvr.panode 			|| v_sep ||
			  lvr.celldescription 	|| v_sep ||
			  lvr.fileid 			|| v_sep ||
			  lvr.testmethod 		|| v_sep ||
			  lvr.simulationstep 	|| v_sep ||
			  lvr.simulationtype 	|| v_sep ||
			  lvr.cellname 			|| v_sep ||
			  lvr.cellvalue_s 		|| v_sep ||
			  lvr.mt_desc 			|| v_sep ||
			  lvr.me 				|| v_sep ||
			  lvr.description 		|| v_sep ||
			  lvr.importid 			|| v_sep ||
			  lvr.blobid;

    UTL_FILE.PUT_LINE(v_out_file, v_line);
    UTL_FILE.FFLUSH(file => v_out_file);
  END LOOP;
  UTL_FILE.FCLOSE(v_out_file);
  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END Process_SX100A;

/*
    ExecuteMeshing-2 variant, can be called with 1 sample
*/
FUNCTION ExecuteMeshing (avsSc IN VARCHAR2, avsMe IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
    lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ExecuteMeshing-2';
    lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
    lvi_ret_code            iapiType.ErrorNum_Type;
    CURSOR lvq_me (avsSc IN VARCHAR2) IS
      SELECT ME.sc, ME.pg, ME.pgnode, ME.pa, ME.panode, ME.me, ME.menode, ME.ss, ME.lc, ME.lc_version, ME.reanalysis , SCGK.part_no
          FROM utscme ME, utscgkpart_no SCGK
         WHERE ME.sc = avsSc
--           AND ME.me = 'SX000A'
           AND ME.me = avsMe
           AND ME.ss = 'AV'
           AND ME.sc = SCGK.sc;
    lvsError            VARCHAR2(255);
    lvn_total           NUMBER;
BEGIN
    lvi_ret_code := UNILAB.APAOACTION.SETCONNECTION;

    IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
        FOR lvr_me IN lvq_me(avsSc) LOOP
            lvi_ret_code := Meshing(lvr_me.sc,
                    lvr_me.pg,
                    lvr_me.pgnode,
                    lvr_me.pa,
                    lvr_me.panode,
                    lvr_me.me,
                    lvr_me.menode,
                    lvr_me.ss,
                    lvr_me.lc,
                    lvr_me.lc_version,
                    lvr_me.reanalysis,
                    lvr_me.part_no);
        END LOOP;
  END IF;
  RETURN lvi_ret_code;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END ExecuteMeshing;

-- ExecuteMeshing-1 variant, can be called from scheduling/procedure and processes 1 sample if available
--
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 16/11/2017 | JR        | Enhanced with SX100A processing
-- 23/11/2017 | JR        | Error handling
FUNCTION ExecuteMeshing  RETURN APAOGEN.RETURN_TYPE
IS
lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ExecuteMeshing-1';
lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code            iapiType.ErrorNum_Type;
-- For the time being we process one SC/ME per run
CURSOR lvq_me
IS
SELECT ME.sc
, ME.pg
, ME.pgnode
, ME.pa
, ME.panode
, ME.me
, ME.menode
, ME.ss
, ME.lc
, ME.lc_version
, ME.reanalysis
, SCGK.part_no
FROM utscme ME, utscgkpart_no SCGK
--         WHERE ME.me = 'SX000A'
WHERE ME.me like 'SX000_'
AND ME.ss = 'AV'
AND ME.sc = SCGK.sc
AND rownum < 2
;
CURSOR lvq_me_SX100A
IS
SELECT me.*
,      imp.importid
FROM utscme           me
,    utscmegkimportid imp
WHERE me.me = 'SX100A'
AND me.ss = 'AV'
--AND me.sc LIKE 'HVB1739068T%'
AND me.sc = imp.sc
AND me.pg = imp.pg AND me.pgnode = imp.pgnode
AND me.pa = imp.pa AND me.panode = imp.panode
AND me.me = imp.me AND me.menode = imp.menode
AND rownum < 2
;
--mail-too-long-lasting method
l_mail_sc           utscme.sc%type;
l_mail_pg           utscme.pg%type;
l_mail_pa           utscme.pa%type;
l_mail_me           utscme.me%type;
l_max_logdate       utscmehs.logdate%type;
l_logdate           date;            --logdate in date-format, to calculate duration between logdate and sysdate
l_duur              number;
l_send_email_from   number  := 30;   --time-schedule-from-time to send an email to Mihar
l_send_email_till   number  := 31;   --time-schedule-till-time to send an email to Mihar
--
lvn_total           NUMBER;
lvsFileName         VARCHAR2(255);
lvsDirName          VARCHAR2(255);
lvs_dir             VARCHAR2(255);
lvs_eq              uteq.eq%TYPE;
lvs_error           VARCHAR2(255) := NULL;
--MAIL-SETTINGS
l_recipients        VARCHAR2(2000 CHAR) := 'mihar.ved@Apollotyres.com;t.muthusivasankar@apollotyres.com';    --recipients-list
l_subject           VARCHAR2(255 CHAR)  ;
l_buffer            unapigen.vc255_table_type;
l_index             NUMBER;
--
BEGIN
    lvi_ret_code := UNILAB.APAOACTION.SETCONNECTION;
    IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'SetConnection failed, code: ' || lvi_ret_code;
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
    END IF;

    IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS
    THEN
      -- 2015-08-20 discussed with HvB, as long as SX000A method In Execution, do not start a new processing
      SELECT COUNT(*)
      INTO lvn_total
      FROM utscme
      -- WHERE me = 'SX000A'
      WHERE me like 'SX000_'
      AND ss = 'IE'
      ;
      IF lvn_total > 0
      THEN
        --see if this methode has more than 30 minutes the status=IE.
        for i in (SELECT me.sc, me.pg, me.pgnode, me.pa, me.panode, me.me, me.menode, me.ss
                  FROM utscme me
                  WHERE me.me like 'SX000_'
                  AND   me.ss = 'IE'
                 )
        loop
          --haal max-logdate op
          begin
            select max(mhs.logdate)
            into l_max_logdate
            from utscmehs mhs
            where mhs.sc = i.sc
            AND   mhs.pg = i.pg and mhs.pgnode = i.pgnode
            AND   mhs.pa = i.pa and mhs.panode = i.panode
            AND   mhs.me = i.me and mhs.menode = i.menode
            AND   (   mhs.why like 'AV => IE%'
                  or  mhs.what_description like 'status of method %SX000%changed%[AV]%[IE]%' )
            ;
            --logdate langer dan 30 minuten geleden?
            l_logdate := to_date(to_char(l_max_logdate,'dd-mm-yyyy hh24:mi:ss'),'dd-mm-yyyy hh24:mi:ss') ;
            select trunc ( ( sysdate - l_logdate ) * 1440 ) into l_duur from dual;
            --
            APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                         ,avs_message=> 'FEA-CHECK TIME PERIOD for-method-SX0000-IE-error logdate='||l_logdate||' (duur = '||L_DUUR||' minutes) for SC <'||i.SC||'['||i.ME||']' );

            if  l_max_logdate is not null
			      and l_duur between l_send_email_from and l_send_email_till
            then
              --verstuur nu de mail naar MIHAR:
              --l_recipients := 'mihar.ved@Apollotyres.com;t.muthusivasankar@apollotyres.com';
			        --VUL eerste regel van email: chr(13=CarriageRetrun.
              l_index := 1;
              l_buffer(l_index) := 'AV => IE '||chr(13);
              l_subject := 'FEA-TIMED-EXCP: FEA-METHOD TOO LONG IN UNILAB WITH STATUS=IE for SC: '||i.sc||'-'||i.pg||'-'||i.pa||'-'||i.me;
              --send email
              lvi_ret_code := unapiGen.SendMail(a_recipient  => l_recipients
                                               ,a_subject    => l_subject
                                               ,a_text_tab   => l_buffer
                                               ,a_nr_of_rows => l_index  );
              --
              IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS
              THEN
                APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                              ,avs_message=> 'FEA-SendMail NOT SUCCESS to inform TIMED-method-SX000-IE-error for SC <'||i.SC||'['||i.ME||']>  to recipients <'||l_recipients||'>. Error: '||lvi_ret_code
                              );
              ELSE
                APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                             ,avs_message=> 'FEA-SendMail SUCCESS to inform TIMED-method-SX0000-IE-error for SC <'||i.SC||'['||i.ME||']>  to recipients <'||l_recipients||'>');
              END IF; --ret-code
            else
              --DURATION OF METHOD WITH STATUS=IE IS NOT BETWEEN 30-32 MINUTES...
              NULL;
              --APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
              --               ,avs_message=> 'FEA-SendMail NOT SUCCESS TIME PERIOD for-method-SX0000-IE-error is not lying between 30-32 minutes ('||L_DUUR||' minutes) for SC <'||i.SC||'['||i.ME||']' );
            end if; --logdate not null and between 30 and 32 minutes
          exception
            when others
            then
              null;
              UNAPIGEN.LogError (lcs_function_name, 'FEA-EXCP: During check if there exists methods of SX000_ '||sqlerrm);
          end;
          --
        end loop; --i:utscme
        --IF NO METHOD IS FOUND, DON'T LOG AN ERROR. IT IS NOT NECESSARY, ONLY FOR DEBUGGING !
        --UNAPIGEN.LogError (lcs_function_name, 'FEA-notification: There are ' || lvn_total || ', methods of SX000_ In Execution, so we do not start ExecuteMeshing');
      ELSE
        --UNAPIGEN.LogError (lcs_function_name, 'Start ExecuteMeshing-1');
        --UNAPIGEN.LogError (lcs_function_name, 'FEA-notification: There are ' || lvn_total || ', methods of SX000_ In Execution, so we do START ExecuteMeshing');
        --
        FOR lvr_me IN lvq_me
        LOOP
          lvi_ret_code := Meshing(lvr_me.sc,
                        lvr_me.pg,
                        lvr_me.pgnode,
                        lvr_me.pa,
                        lvr_me.panode,
                        lvr_me.me,
                        lvr_me.menode,
                        lvr_me.ss,
                        lvr_me.lc,
                        lvr_me.lc_version,
                        lvr_me.reanalysis,
                        lvr_me.part_no);
          IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS
          THEN
            lvs_sqlerrm := 'Meshing failed for , code: ' || lvi_ret_code;
            UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
          END IF;
        END LOOP;
      END IF;
      ------------------------------------------------------------------------
      -- Processing of SX100A
      ------------------------------------------------------------------------
      SELECT COUNT(*)
      INTO lvn_total
      FROM utsystem
      WHERE setting_name = 'FEA_SX100A_ENABLED'
      AND TRIM(setting_value) = '1'
      ;
      IF lvn_total > 0
      THEN
        FOR lvr_me IN lvq_me_SX100A
        LOOP
          -------------------------------------------------
          -- Determine the equipment, for the correct Lab
          -------------------------------------------------
          lvs_eq := NULL;
          BEGIN
                    SELECT eq.eq
                      INTO lvs_eq
                      FROM utscme   me
                         , utmt     mt
                         , uteqtype tp
                         , uteq     eq
                     WHERE me.sc = lvr_me.sc
                       AND me.pg = lvr_me.pg AND me.pgnode = lvr_me.pgnode
                       AND me.pa = lvr_me.pa AND me.panode = lvr_me.panode
                       AND me.me = lvr_me.me AND me.menode = lvr_me.menode
                       AND mt.mt = me.me
                       AND mt.version_is_current = '1'
                       AND tp.eq_tp = mt.eq_tp
                       AND eq.eq = tp.eq
                       AND eq.lab = me.lab;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        lvs_error := 'No equipment found for sample : ' || lvr_me.sc;
                        UNAPIGEN.LogError (lcs_function_name, lvs_error);
                    WHEN OTHERS THEN
                        lvs_error := SUBSTR('Error getting equipment for sample : ' || lvr_me.sc || '; '  || SQLERRM,0,255);
                        UNAPIGEN.LogError (lcs_function_name, lvs_error);
          END;
          --
          IF lvs_eq IS NOT NULL
          THEN
            lvs_dir := getFeaSetting('File2Machine', lvs_eq, 'oracle_dir', lvr_me.sc);
            IF lvs_dir IS NOT NULL
            THEN
              BEGIN
                SELECT directory_path
                INTO lvsDirName
                FROM all_directories
                WHERE DIRECTORY_NAME = TRIM(lvs_dir)
				;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                                lvs_error := 'No Oracle directory found for:' || lvs_dir;
                                UNAPIGEN.LogError (lcs_function_name, lvs_error);
                WHEN OTHERS THEN
                                lvs_error := SUBSTR('Error getting Oracle directory for: ' || lvs_dir ||'; '  || SQLERRM,0,255);
                                UNAPIGEN.LogError (lcs_function_name, lvs_error );
              END;
              --
              IF lvs_error IS NOT NULL
              THEN
                lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (lvr_me.sc, lvr_me.pg, lvr_me.pgnode, lvr_me.pa, lvr_me.panode, lvr_me.me, lvr_me.menode, lvs_error);
                lvi_ret_code := UNAPIMEP.CHANGESCMESTATUS(lvr_me.sc, lvr_me.pg, lvr_me.pgnode, lvr_me.pa, lvr_me.panode, lvr_me.me, lvr_me.menode, lvr_me.reanalysis
                                                          , 'AV', 'ER', lvr_me.lc, lvr_me.lc_version, 'Changed by ' || lcs_function_name);
                IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS
                THEN
                  lvs_sqlerrm := 'CHANGESCMESTATUS failed, for <' || lvr_me.sc || ',' || lvr_me.pg || ',' || lvr_me.pa || ',' || lvr_me.me || '> from IE to ER, Result:' || lvi_ret_code;
                  UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
                END IF;
              ELSE
                lvi_ret_code := UNAPIMEP.CHANGESCMESTATUS(lvr_me.sc, lvr_me.pg, lvr_me.pgnode, lvr_me.pa, lvr_me.panode, lvr_me.me, lvr_me.menode, lvr_me.reanalysis
                                                          , 'AV', 'IE', lvr_me.lc, lvr_me.lc_version, 'Changed by ' || lcs_function_name);
                IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS
                THEN
                  lvs_sqlerrm := 'CHANGESCMESTATUS failed, for <' || lvr_me.sc || ',' || lvr_me.pg || ',' || lvr_me.pa || ',' || lvr_me.me || '> from AV to IE';
                  UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
                ELSE
                  lvsFileName := lvr_me.importid || '.TXT';
                  UNAPIGEN.LogError (lcs_function_name, 'Writing FEA file '  || lvsDirName || '\' || lvsFileName);
                                lvi_ret_code := UNAPIMEP.ADDSCMECOMMENT (lvr_me.sc, lvr_me.pg, lvr_me.pgnode, lvr_me.pa, lvr_me.panode, lvr_me.me, lvr_me.menode
                                    , 'FEA file generated: ' || lvsDirName || '\' || lvsFileName);
                  lvi_ret_code := Process_SX100A(lvr_me.sc, lvsFileName, TRIM(lvs_dir));
                END IF;
              END IF; --lvs-error is not null
            END IF; --lvs-dir is not null
          END IF; --lvs-eq is not null
        END LOOP; --cursor lvq-me-sx100a
      END IF;  --lvn-total > 0
    END IF;  --lvi-ret-code=success
    --
    RETURN lvi_ret_code;
    --
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END ExecuteMeshing;

END APAOFEA;
