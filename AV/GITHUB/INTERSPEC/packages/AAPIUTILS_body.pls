create or replace PACKAGE BODY          AAPIUTILS AS

    PROCEDURE StopAllDBJobs
    AS
    BEGIN
        SyncNLS();

        dbms_output.put_line('Stopping all jobs...');
        StopJobQueue();
        dbms_output.put_line('aapiJob: Success');
        dbms_output.put_line('iapiEmail: ' || NVL(NULLIF(TO_CHAR(iapiEmail.StopJob()), 0), 'Success'));
        dbms_output.put_line('pa_LimsInterface: ' || NVL(NULLIF(TO_CHAR(pa_LimsInterface.f_StopInterface()), 1), 'Success'));
        dbms_output.put_line('iapiMop: ' || NVL(NULLIF(TO_CHAR(iapiMop.StopJob()), 0), 'Success'));
        dbms_output.put_line('iapiSpecDataServer: ' || NVL(NULLIF(TO_CHAR(iapiSpecDataServer.StopSpecServer()), 0), 'Success'));
        COMMIT;
    END;

    PROCEDURE StartAllDBJobs
    AS
      lnJobID pls_integer;
    BEGIN
        SyncNLS();

        dbms_output.put_line('Starting all jobs...');
        dbms_output.put_line('iapiSpecDataServer: ' || NVL(NULLIF(TO_CHAR(iapiSpecDataServer.StartSpecServer()), 0), 'Success'));
        dbms_output.put_line('iapiMop: ' || NVL(NULLIF(TO_CHAR(iapiMop.StartJob()), 0), 'Success'));
        dbms_output.put_line('pa_LimsInterface: ' || NVL(NULLIF(TO_CHAR(pa_LimsInterface.f_StartInterface()), 1), 'Success'));
        dbms_output.put_line('iapiEmail: ' || NVL(NULLIF(TO_CHAR(iapiEmail.StartJob()), 0), 'Success'));
        aapiJob.StartJobQueue();
        dbms_output.put_line('aapiJob: Success');
        COMMIT;
        
        -- Alter Lims historic job
        SELECT job
        INTO lnJobID
        FROM dba_jobs
        WHERE LOWER(what) = 'pa_limsspc.f_transferallhistobs;';
        
        dbms_job.change(
          job=>lnJobID,
          what=>NULL,
          next_date=>NULL,
          interval=>'TRUNC(SYSDATE) + 1 + 4 / 24'
        );
        
        COMMIT;
        
        /*
iapiSpecificationStatus.AutoStatus;
2019-05-21 00:00:00
00:00:00
N
TRUNC(SYSDATE) + 1
0
        */
    END;

    PROCEDURE RestartAllDBJobs
    AS
    BEGIN
        StopAllDBJobs;
        StartAllDBJobs;
    END;
    
    PROCEDURE FixUserHistory(
        asUserId IN iapiType.UserId_Type
    ) AS
        lnTimestamp iapiType.Date_Type;
        lsForename  iapiType.ForeName_Type;
        lsLastName  iapiType.LastName_Type;
        lsTelephone iapiType.Telephone_Type;
    BEGIN
        SELECT MAX(timestamp)
        INTO lnTimestamp
        FROM itushs
        WHERE user_id_changed = asUserId
        AND what_id = 'AT_USER_INS';
        
        SELECT forename, last_name, telephone_no
        INTO lsForename, lsLastName, lsTelephone
        FROM application_user
        WHERE user_id = asUserId;
        
        dbms_output.put_line('Updating user ''' || asUserId || ''', created on ' || TO_CHAR(lnTimestamp, 'YYYY-MM-DD') || ', with name ''' || lsForename || ' ' || lsLastName || '''');

        --Update User Data for future audit trails
        dbms_output.put_line('table ''itus''');
        UPDATE itus
        SET forename = lsForename, last_name = lsLastName, created_on = lnTimestamp
        WHERE user_id = asUserId;
        
        dbms_output.put_line('table ''approval_history''');
        UPDATE approval_history
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND approved_date >= lnTimestamp;

        dbms_output.put_line('table ''itaghs''');
        UPDATE itaghs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itbomjrnl''');
        UPDATE itbomjrnl
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''iteshs''');
        UPDATE iteshs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itfrmdel''');
        UPDATE itfrmdel
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND deletion_date >= lnTimestamp;
        
        dbms_output.put_line('table ''itoihs''');
        UPDATE itoihs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itprcl_h''');
        UPDATE itprcl_h
        SET forename = lsForename, last_name = lsLastName
        WHERE last_modified_by = asUserId
        AND last_modified_on >= lnTimestamp;

        dbms_output.put_line('table ''itprmfc_h''');
        UPDATE itprmfc_h
        SET forename = lsForename, last_name = lsLastName
        WHERE last_modified_by = asUserId
        AND last_modified_on >= lnTimestamp;
        
        dbms_output.put_line('table ''itprnote_h''');
        UPDATE itprnote_h
        SET forename = lsForename, last_name = lsLastName
        WHERE last_modified_by = asUserId
        AND last_modified_on >= lnTimestamp;

        dbms_output.put_line('table ''itprobj_h''');
        UPDATE itprobj_h
        SET forename = lsForename, last_name = lsLastName
        WHERE last_modified_by = asUserId
        AND last_modified_on >= lnTimestamp;

        dbms_output.put_line('table ''itprpl_h''');
        UPDATE itprpl_h
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;
        
        dbms_output.put_line('table ''itrepghs''');
        UPDATE itrepghs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itrephs''');
        UPDATE itrephs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itrths''');
        UPDATE itrths
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itschs''');
        UPDATE itschs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itshdel''');
        UPDATE itshdel
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND deletion_date >= lnTimestamp;
        
        dbms_output.put_line('table ''itshhs''');
        UPDATE itshhs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itsshs''');
        UPDATE itsshs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itughs''');
        UPDATE itughs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itushs''');
        UPDATE itushs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itwghs''');
        UPDATE itwghs
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''itwths''');
        UPDATE itwths
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;

        dbms_output.put_line('table ''jrnl_specification_header''');
        UPDATE jrnl_specification_header
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND timestamp >= lnTimestamp;
        
        dbms_output.put_line('table ''specification_kw_h''');
        UPDATE specification_kw_h
        SET forename = lsForename, last_name = lsLastName
        WHERE last_modified_by = asUserId
        AND last_modified_on >= lnTimestamp;

        dbms_output.put_line('table ''status_history''');
        UPDATE status_history
        SET forename = lsForename, last_name = lsLastName
        WHERE user_id = asUserId
        AND status_date_time >= lnTimestamp;
        
        COMMIT;
    END;
    
    PROCEDURE FixPED(
        asPartNo IN iapiType.PartNo_Type
    ) AS
        lnRetVal   iapiType.ErrorNum_Type;
        lnRevision iapiType.Revision_Type;
        ldPed      iapiType.Date_Type;
    BEGIN
        lnRetVal := iapiGeneral.SetConnection(USER);
        
        IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS THEN
            dbms_output.put_line('Error occured during SetConnection: ' || TO_CHAR(lnRetVal));
            RETURN;
        END IF;

        UPDATE specification_header
        SET planned_effective_date = TRUNC(SYSDATE + 1),
            ped_in_sync = 'Y'
        WHERE part_no = asPartNo
        AND status = 1
        RETURNING revision, planned_effective_date
        INTO lnRevision, ldPed;
        
        IF SQL%ROWCOUNT = 0 THEN
            dbms_output.put_line('No revision in status Dev found.');
            RETURN;
        END IF;

        UPDATE bom_header
        SET plant_effective_date = ldPed
        WHERE part_no = asPartNo
        AND revision = lnRevision;
        
        IF SQL%ROWCOUNT = 0 THEN
          dbms_output.put_line('No BoM Headers found.');
            RETURN;
        END IF;
        
        COMMIT;
        dbms_output.put_line('PED successfully changed.');
    END;

    PROCEDURE SetMopToSubmitLastQR(
        asUserID IN iapiType.UserId_Type,
        asReason IN iapiType.StringVal_Type
    ) AS
    BEGIN
        UPDATE itshq
        SET (workflow_group_id, access_group) = (
            SELECT workflow_group_id, access_group
            FROM specification_header
            WHERE part_no = itshq.part_no
            AND revision = itshq.revision
        ),
        text = asReason,
        status_to = (
            SELECT status
            FROM (
                SELECT
                    part_no,
                    DECODE(
                        REGEXP_REPLACE(
                            MAX(sort_desc) KEEP (DENSE_RANK LAST ORDER BY revision, sort_seq),
                            '^.+ QR(\d+)$',
                            '\1'
                        ),
                        0, 'CRRNT QR0',
                        1, 'CRRNT QR1',
                        2, 'CRRNT QR2',
                        3, 'SUBMIT QR3',
                        4, 'SUBMIT QR4',
                        5, 'SUBMIT QR5'
                    ) AS sort_desc
                FROM status_history
                LEFT JOIN status USING (status)
                WHERE status_type IN (
                    iapiConstant.STATUSTYPE_SUBMIT,
                    iapiConstant.STATUSTYPE_APPROVED,
                    iapiConstant.STATUSTYPE_CURRENT
                )
                AND sort_desc NOT IN ('APPROVED', 'CURRENT', 'TEMP CRRNT')
                GROUP BY part_no
            )
            LEFT JOIN status USING (sort_desc)
            WHERE part_no = itshq.part_no
        )
        WHERE user_id = asUserID;
        
        COMMIT;
    END;

    PROCEDURE StartMop(
        asUserID  IN iapiType.UserId_Type,
        asJobDesc IN iapiType.Description_Type
    ) AS
    BEGIN
        DELETE FROM itq
        WHERE user_id = asUserID;
        
        COMMIT;
        
        INSERT INTO itq(user_id, status, job_descr)
        VALUES (
            asUserID,
            iapiConstant.STARTED_TEXT,
            DECODE(UPPER(asJobDesc),
                'DELETE SPECIFICATION', 'del',
                'STATUS CHANGE', 'ssc',
                'FRAME REFRESH/CHANGE', 'frr',
                'CREATE NEW REVISION', '',
                'REPLACE BOM ITEM', 'rbi',
                'REMOVE BOM ITEM', 'dbi',
                'ADD BOM ITEM', 'abi',
                'CREATE NEW REVISION', 'cpr',
                'CHANGE ACCESS/WORKFLOW-GROUP', 'caw',
                'REPLACE PROPERTY VALUE', 'rpv',
                'UPDATE CONVERSION FACTOR IN BOM', 'ubu',
                LOWER(asJobDesc)
            )
        );
    
        dbms_alert.signal(iapiQueue.gsMopJobName, asUserID);
        
        COMMIT;
    END;
    
    PROCEDURE ClearMOP(
        asUserID IN iapiType.UserId_Type
    ) AS
    BEGIN
        DELETE FROM itshq
        WHERE user_id = asUserID;
        
        COMMIT;
    END;
    
    PROCEDURE AddTableToMOP(
        asUserID     IN iapiType.UserId_Type,
        asTableName  IN iapiType.StringVal_Type,
        asConditions IN iapiType.StringVal_Type DEFAULT NULL
    ) AS
        lsMatchCols iapiType.SqlString_Type;
        lsExtraCols iapiType.SqlString_Type;
        lsSqlString iapiType.SqlString_Type;
    BEGIN
        SELECT ',' || LISTAGG(LOWER(column_name), ',') WITHIN GROUP (ORDER BY column_id) || ','
        INTO lsMatchCols
        FROM all_tab_cols
        WHERE UPPER(table_name) = UPPER(asTableName)
        AND UPPER(column_name) IN (
            SELECT UPPER(column_name)
            FROM all_tab_cols
            WHERE table_name = 'ITSHQ'
        );
        
        SELECT LISTAGG(LOWER(column_name), ',')
            WITHIN GROUP (ORDER BY column_id)
        INTO lsExtraCols
        FROM all_tab_cols
        WHERE UPPER(table_name) = UPPER(asTableName)
        AND UPPER(column_name) IN (
            SELECT UPPER(column_name)
            FROM all_tab_cols
            WHERE table_name = 'ITSHQ'
            AND nullable = 'Y'
        );
        IF (lsExtraCols IS NOT NULL) THEN
            lsExtraCols := ',' || lsExtraCols;
        END IF;
    
        lsSqlString := 'INSERT INTO itshq (user_id,part_no,revision' || lsExtraCols || ') ' ||
            'SELECT ' ||
                CASE WHEN lsMatchCols LIKE '%,user_id,%' THEN 'user_id,' ELSE '''' || asUserID || ''' AS user_id,' END ||
                'part_no,' ||
                CASE WHEN lsMatchCols LIKE '%,revision,%' THEN 'revision' ELSE '1 AS revision' END ||
                lsExtraCols ||
            ' FROM ' || asTableName ||
            CASE WHEN asConditions IS NOT NULL THEN ' WHERE ' || asConditions END;
        
        dbms_output.put_line(lsSqlString);

        EXECUTE IMMEDIATE lsSqlString;
        COMMIT;
    END;

    PROCEDURE CopyUserState(
        asUserIdSrc  IN iapiType.UserId_Type,
        asUserIdDest IN iapiType.UserId_Type
    ) AS
    BEGIN
        UPDATE application_user
        SET (
            current_only, initial_profile, user_profile, user_dropped, prod_access, plan_access, phase_access, printing_allowed, intl, frames_only, reference_text, approved_only, loc_id, cat_id, override_part_val, web_allowed, limited_configurator, plant_access, view_bom, view_price, optional_data
        ) = (
            SELECT current_only, initial_profile, user_profile, user_dropped, prod_access, plan_access, phase_access, printing_allowed, intl, frames_only, reference_text, approved_only, loc_id, cat_id, override_part_val, web_allowed, limited_configurator, plant_access, view_bom, view_price, optional_data
            FROM application_user
            WHERE user_id = asUserIdSrc
        )
        WHERE user_id = asUserIdDest;
        
        
        FOR rec IN (SELECT granted_role FROM dba_role_privs WHERE grantee = asUserIdDest)
        LOOP
            EXECUTE IMMEDIATE 'REVOKE ' || rec.granted_role || ' FROM ' || asUserIdDest;
        END LOOP;
        
        FOR rec IN (SELECT granted_role, default_role FROM dba_role_privs WHERE grantee = asUserIdSrc)
        LOOP
            EXECUTE IMMEDIATE 'GRANT ' || rec.granted_role || ' TO ' || asUserIdDest;
            
            If rec.default_role = 'YES' THEN
                EXECUTE IMMEDIATE 'ALTER USER ' || asUserIdDest || ' DEFAULT ROLE ' || rec.granted_role;
            END IF;
        END LOOP;
        
    
        DELETE FROM user_group_list
        WHERE user_id = asUserIdDest;
        
        INSERT INTO user_group_list(user_id, user_group_id)
        SELECT asUserIdDest AS user_id, user_group_id
        FROM user_group_list
        WHERE user_id = asUserIdSrc;
        
        COMMIT;
    END;

    PROCEDURE CopyCatiaMapping(
        asFromFrameNo  IN iapiType.FrameNo_Type,
        anFromFrameRev IN iapiType.Revision_Type,
        asToFrameNo    IN iapiType.FrameNo_Type,
        anToFrameRev   IN iapiType.Revision_Type
    ) AS
    BEGIN
        DELETE FROM atCatiaMapping
        WHERE frame_no = asToFrameNo
        AND frame_rev = anToFrameRev
        AND (
            NVL(section_desc, '(none)'),
            NVL(sub_section_desc, '(none)'),
            NVL(property_group_desc, 'default property group'),
            NVL(property_desc, ' '),
            NVL(attribute_desc, ' '),
            field_type
        ) IN (
            SELECT
                NVL(section_desc, '(none)'),
                NVL(sub_section_desc, '(none)'),
                NVL(property_group_desc, 'default property group'),
                NVL(property_desc, ' '),
                NVL(attribute_desc, ' '),
                field_type
            FROM atCatiaMapping
            WHERE frame_no = asFromFrameNo
            AND frame_rev = anFromFrameRev
        );

        INSERT INTO atCatiaMapping(
            frame_no,
            frame_rev,
            section_desc,
            sub_section_desc,
            property_group_desc,
            property_desc,
            attribute_desc,
            field_type,
            catia_var
        )
        SELECT
            asToFrameNo,
            anToFrameRev,
            section_desc,
            sub_section_desc,
            property_group_desc,
            property_desc,
            attribute_desc,
            field_type,
            catia_var
        FROM atCatiaMapping
        WHERE frame_no = asFromFrameNo
        AND frame_rev = anFromFrameRev;
    END;

    PROCEDURE UpdateIntMapping(
        asTableName  IN iapiType.StringVal_Type
    ) AS
        lsSqlString iapiType.SqlString_Type;
    BEGIN
        lsSqlString := 'UPDATE (' ||
          'SELECT ' ||
            'sh.int_part_no, ' ||
            'map.int_part_no AS new_int_part_no, ' ||
            'sh.int_part_rev, ' ||
            'map.int_part_rev AS new_int_part_rev ' ||
          'FROM specification_header sh ' ||
          'INNER JOIN ' || asTableName || ' map USING (part_no, revision)' ||
        ') SET ' ||
          'int_part_no = new_int_part_no, ' ||
          'int_part_rev = new_int_part_rev';
        
        --dbms_output.put_line(lsSqlString);

        EXECUTE IMMEDIATE lsSqlString;
        COMMIT;
    END;
    
    PROCEDURE ExportHeaders
    AS
        lsMethod   iapiType.Method_Type := 'ExportHeaders';
        lsFilename VARCHAR2(40 CHAR);
        lnCursor   PLS_INTEGER;
        lsFolder   VARCHAR2(20 CHAR) := 'CATIA_EXPORT'; --\\oracleprod\catiaexport$
        --lnResult   iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lnDatafile utl_file.File_Type;
        lsBuffer   VARCHAR2(4000 CHAR);
        --lnIntl     iapiType.Boolean_Type;
        --lnRetVal   iapiType.ErrorNum_Type;
    BEGIN
        lsFilename := 'spec_headers.csv';

        lnDatafile := utl_file.fopen(lsFolder, lsFilename, 'w');

        lnCursor := dbms_sql.open_cursor();
        
        dbms_sql.parse(lnCursor, '
            SELECT
              sh.part_no,
              sh.revision,
              ss.sort_desc AS status,
              ss.status_type AS status_type,
              sh.description,
              TO_CHAR(sh.planned_effective_date, ''YYYY-MM-DD"T"HH24:MI:SS"Z'') AS planned_effective_date,
              TO_CHAR(sh.issued_date, ''YYYY-MM-DD"T"HH24:MI:SS"Z'') AS issued_date,
              TO_CHAR(sh.obsolescence_date, ''YYYY-MM-DD"T"HH24:MI:SS"Z'') AS obsolescence_date,
              TO_CHAR(sh.status_change_date, ''YYYY-MM-DD"T"HH24:MI:SS"Z'') AS status_change_date,
              sh.phase_in_tolerance,
              sh.created_by,
              TO_CHAR(sh.created_on, ''YYYY-MM-DD"T"HH24:MI:SS"Z'') AS created_on,
              sh.last_modified_by,
              TO_CHAR(sh.last_modified_on, ''YYYY-MM-DD"T"HH24:MI:SS"Z'') AS last_modified_on,
              sh.frame_id AS frame_no,
              sh.frame_rev,
              ag.sort_desc AS access_group,
              wg.sort_desc AS workflow_group,
              st.sort_desc AS spec_type,
              st.type AS spec_type_group,
              sh.int_frame_no,
              sh.int_frame_rev,
              sh.int_part_no,
              sh.frame_owner,
              sh.intl,
              sh.multilang,
              DECODE(sh.uom_type, 0, 1, 0) AS metric,
              vw.description AS mask,
              DECODE(sh.ped_in_sync, ''Y'', 1, 0) AS ped_in_sync,
              sh.locked AS locked_by
            FROM
              specification_header sh,
              status ss,
              access_group ag,
              workflow_group wg,
              class3 st,
              --itdbprofile db,
              itfrmv vw
            WHERE
              ss.status = sh.status
              AND ag.access_group = sh.access_group
              AND wg.workflow_group_id = sh.workflow_group_id
              AND st.class = sh.class3_id
              --AND db.owner = sh.frame_owner
              AND (
                vw.frame_no(+) = sh.frame_id
                AND vw.revision(+) = sh.revision
                AND vw.view_id(+) = sh.mask_id
              )
              AND ss.status_type <> ''HISTORIC''
        ', dbms_sql.native);
        
        aapiGeneral.GenerateCsv(lnDatafile, lnCursor, 1);
        
        utl_file.fclose(lnDatafile);
        dbms_sql.close_cursor(lnCursor);
    END;
    
    PROCEDURE ExportDmt(
        asUserID  IN iapiType.UserId_Type
    ) AS
        lsMethod   iapiType.Method_Type := 'ExportDmt';
        lsFilename VARCHAR2(40 CHAR);
        lnCursor   PLS_INTEGER;
        lsFolder   VARCHAR2(20 CHAR) := 'DMT';
        --lnResult   iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lnDatafile utl_file.File_Type;
        lsBuffer   VARCHAR2(4000 CHAR);
        --lnIntl     iapiType.Boolean_Type;
        --lnRetVal   iapiType.ErrorNum_Type;
    BEGIN
        lsFilename := 'export.csv';

        lnDatafile := utl_file.fopen(lsFolder, lsFilename, 'w');

        lnCursor := dbms_sql.open_cursor();
        
        dbms_sql.parse(lnCursor, '
            SELECT
              part_no,
              revision,
              section_id AS section,
              sub_section_id AS sub_section,
              property_group,
              property,
              attribute,
              header_id AS header,
              NVL(value_s, value) AS value,
              lang_id AS language
            FROM (
              SELECT
                sd.*,
                (
                  SELECT MIN(section_sequence_no)
                  FROM specification_section sec
                  WHERE sec.part_no = sd.part_no
                  AND sec.revision = sd.revision
                  AND sec.section_id = sd.section_id
                  AND sec.sub_section_id = sd.sub_section_id
                ) AS section_sequence_no
              FROM specdata sd
              WHERE (part_no, revision) IN (
                SELECT part_no, revision
                FROM itshq
                WHERE user_id = ''' || asUserID || '''
              )
            )
            ORDER BY
              part_no,
              revision,
              section_sequence_no,
              sequence_no
        ', dbms_sql.native);
        
        aapiGeneral.GenerateCsv(lnDatafile, lnCursor, 1);
        
        utl_file.fclose(lnDatafile);
        dbms_sql.close_cursor(lnCursor);
    END;

END;