create or replace PACKAGE BODY aapiCatia AS

    psSource CONSTANT iapiType.Source_Type := 'aapiCatia';

    FUNCTION CreateCatiaDatafiles(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    IS
        lsMethod     iapiType.Method_Type := 'CreateCatiaDatafiles';
        lsErrMsg     iapiType.ErrorText_Type;
        lsFilename   VARCHAR2(40 CHAR);
        lnCursor     PLS_INTEGER;
        lsFolder     VARCHAR2(20 CHAR) := 'CATIA_EXPORT';
        lnResult     iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lnDatafile   utl_file.File_Type;
        lsStatusDesc iapiType.ShortDescription_Type;
        lsStatusType iapiType.StatusType_Type;
        lsBuffer     VARCHAR2(4000 CHAR);
        lnIntl       iapiType.Boolean_Type;
        lnRetVal     iapiType.ErrorNum_Type;
        
        lsLockExt  VARCHAR2(20 CHAR) := '.lock.log';
        lsSpecExt  VARCHAR2(20 CHAR) := '.spec';
        lsFrameExt VARCHAR2(20 CHAR) := '.frame';
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
    
        lsFilename := REPLACE(utl_url.escape(asPartNo, TRUE), '%', '$');
        lsFileName := REPLACE(lsFileName, '.', '$2E') || '#' || TO_CHAR(anRevision);
        
        --lnRetVal := iapiGeneral.SetConnection(USER);
        lnRetVal := aapiJobDelegates.SetIntlMode(asPartNo, anRevision);

        lnDatafile := utl_file.fopen(lsFolder, lsFilename || lsLockExt, 'w');
        utl_file.fclose(lnDatafile);

        lnDatafile := utl_file.fopen(lsFolder, lsFilename || lsSpecExt, 'w');

        lnCursor := dbms_sql.open_cursor();
        
        dbms_sql.parse(lnCursor, '
            SELECT
                section_id AS section,
                sub_section_id AS sub_section,
                property_group,
                property,
                attribute,
                uom_id AS uom,
                uom_alt_id AS uom_alt,
                num_1, num_2, num_3, num_4, num_5,
                num_6, num_7, num_8, num_9, num_10,
                char_1, char_2, char_3, char_4, char_5, char_6,
                boolean_1, boolean_2, boolean_3, boolean_4,
                date_1, date_2,
                ch_1.description AS assoc_1,
                ch_2.description AS assoc_2,
                ch_3.description AS assoc_3
            FROM
                specification_prop prop
            LEFT JOIN
                characteristic ch_1 ON (ch_1.characteristic_id = prop.characteristic)
            LEFT JOIN
                characteristic ch_2 ON (ch_1.characteristic_id = prop.ch_2)
            LEFT JOIN
                characteristic ch_3 ON (ch_1.characteristic_id = prop.ch_3)
            WHERE
                part_no = :asPartNo
                AND revision = :anRevision
                AND section_id = :anSection
        ', dbms_sql.native);
        aapiGeneral.GenerateCsvHeader(lnDatafile, lnCursor);
        
        dbms_sql.bind_variable(lnCursor, ':asPartNo', asPartNo);
        dbms_sql.bind_variable(lnCursor, ':anRevision', anRevision);
        
        dbms_sql.bind_variable(lnCursor, ':anSection', 700579); --Section: General information
        aapiGeneral.GenerateCsv(lnDatafile, lnCursor, 0);

        dbms_sql.bind_variable(lnCursor, ':anSection', 700835); --Section: D-spec
        aapiGeneral.GenerateCsv(lnDatafile, lnCursor, 0);
        
        dbms_sql.bind_variable(lnCursor, ':anSection', 700755); --Section: SAP information
        aapiGeneral.GenerateCsv(lnDatafile, lnCursor, 0);

        utl_file.put_line(lnDatafile, '0,0,0,713619,,,,,,,,,,,,,,' || aapiGeneral.EscapeCsv(asPartNo) || ',,,,,,,,,,,,,,');
        utl_file.put_line(lnDatafile, '0,0,0,711109,,,,' || TO_CHAR(anRevision) || ',,,,,,,,,,,,,,,,,,,,,,,,');

        SELECT sort_desc, status_type
        INTO lsStatusDesc, lsStatusType
        FROM status
        WHERE status = (
            SELECT status
            FROM specification_header
            WHERE part_no = asPartNo
            AND revision = anRevision
        );
        utl_file.put_line(lnDatafile, '0,0,0,715627,,,,,,,,,,,,,,' || aapiGeneral.EscapeCsv(lsStatusDesc) || ',,,,,,,,,,,,,,');
        utl_file.put_line(lnDatafile, '0,0,0,715628,,,,,,,,,,,,,,' || aapiGeneral.EscapeCsv(lsStatusType) || ',,,,,,,,,,,,,,');

        
        SELECT LISTAGG(plant, '/') WITHIN GROUP (ORDER BY plant)
        INTO lsBuffer
        FROM part_plant
        WHERE part_no = asPartNo
        GROUP BY part_no;

        utl_file.put_line(lnDatafile, '0,0,0,713620,,,,,,,,,,,,,,' || aapiGeneral.EscapeCsv(lsBuffer) || ',,,,,,,,,,,,,,');

        WITH prop AS (
            SELECT
                char_1 AS value,
                property.description AS name
            FROM specification_prop
            INNER JOIN section USING (section_id)
            INNER JOIN sub_section USING (sub_section_id)
            INNER JOIN property_group USING (property_group)
            INNER JOIN property USING (property)
            WHERE section.description = 'General information'
            AND sub_section.description = '(none)'
            AND property_group.description = 'Size'
            AND part_no = asPartNo
            AND revision = anRevision
        )
        SELECT
            (SELECT value FROM prop WHERE name = 'Section width') || '/' ||
            (SELECT value FROM prop WHERE name = 'Aspect ratio') || 'R' ||
            (SELECT value FROM prop WHERE name = 'Rimcode')
        INTO lsBuffer
        FROM dual;

        utl_file.put_line(lnDatafile, '700579,0,701569,705633,,,,,,,,,,,,,,' || aapiGeneral.EscapeCsv(lsBuffer) || ',,,,,,,,,,,,,,');

        utl_file.fclose(lnDatafile);
        dbms_sql.close_cursor(lnCursor);


        lnDatafile := utl_file.fopen(lsFolder, lsFilename || lsFrameExt, 'w');

        lnCursor := dbms_sql.open_cursor();

        dbms_sql.parse(lnCursor, '
            SELECT
                frame_id,
                frame_rev
            FROM
                specification_header
            WHERE
                part_no = :asPartNo
                AND revision = :anRevision
        ', dbms_sql.native);
        
        dbms_sql.bind_variable(lnCursor, ':asPartNo', asPartNo);
        dbms_sql.bind_variable(lnCursor, ':anRevision', anRevision);
        aapiGeneral.GenerateCsv(lnDatafile, lnCursor, 0);

        utl_file.fclose(lnDatafile);
        dbms_sql.close_cursor(lnCursor);
        
        utl_file.fremove(lsFolder, lsFilename || lsLockExt);
<<cleanup>>
        IF utl_file.is_open(lnDatafile) THEN
            utl_file.fclose(lnDatafile);
        END IF;
        IF dbms_sql.is_open(lnCursor) THEN
            dbms_sql.close_cursor(lnCursor);
        END IF;
        
        aapiTrace.Exit(lnResult);        
        RETURN lnResult;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        aapiTrace.Error(lsErrMsg);

        IF utl_file.is_open(lnDatafile) THEN
            utl_file.fclose(lnDatafile);
        END IF;
        IF dbms_sql.is_open(lnCursor) THEN
            dbms_sql.close_cursor(lnCursor);
        END IF;
        
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END CreateCatiaDatafiles;

    FUNCTION CreateCatiaJobFile(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    IS
        lsMethod     iapiType.Method_Type := 'CreateCatiaJobFile';
        lsFrameNo    iapiType.FrameNo_Type;
        lnFrameRev   iapiType.Revision_Type;
      
        lsErrMsg     iapiType.ErrorText_Type;
        lsFileName   iapiType.SqlString_Type;
        lsFilePath   iapiType.SqlString_Type;
        lsFolder     VARCHAR2(20 CHAR) := 'CATIA_EXPORT';
        lnResult     iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lnDatafile   utl_file.File_Type;
        lnRetVal     iapiType.ErrorNum_Type;
        lsMachine    iapiType.MachineName_Type;
        lsDesc       iapiType.Description_Type;
      
        lsBaseDir    iapiType.String_Type;
        lsTplType    iapiType.String_Type;
        lsCatiaTpl   iapiType.String_Type;
        lsTplVer     iapiType.String_Type;
        lsTimestamp  iapiType.String_Type;
        
              
        CURSOR lqCatiaData(
          lsFrameNo  iapiType.FrameNo_Type,
          lnFrameRev iapiType.Revision_Type,
          lsPartNo   iapiType.PartNo_Type,
          lnRevision iapiType.Revision_Type
        ) IS
          SELECT
            catia_var AS parameter,
            DECODE(UPPER(field_type),
              'NUM_1', TO_CHAR(sp.num_1), 'NUM_2', TO_CHAR(sp.num_2),
              'NUM_3', TO_CHAR(sp.num_3), 'NUM_4', TO_CHAR(sp.num_4),
              'NUM_5', TO_CHAR(sp.num_5), 'NUM_6', TO_CHAR(sp.num_6),
              'NUM_7', TO_CHAR(sp.num_7), 'NUM_8', TO_CHAR(sp.num_8),
              'NUM_9', TO_CHAR(sp.num_9), 'NUM_10', TO_CHAR(sp.num_10),
              'CHAR_1', sp.char_1, 'CHAR_2', sp.char_2,
              'CHAR_3', sp.char_3, 'CHAR_4', sp.char_4,
              'CHAR_5', sp.char_5, 'CHAR_6', sp.char_6,
              'BOOLEAN_1', sp.boolean_1, 'BOOLEAN_2', sp.boolean_2,
              'BOOLEAN_3', sp.boolean_3, 'BOOLEAN_4', sp.boolean_4,
              'ASSOCIATION', ch_1.description,
              'ASSOC_1', ch_1.description,
              'ASSOC_2', ch_2.description,
              'ASSOC_3', ch_3.description,
              'DATE_1', TO_CHAR(date_1, 'DD/MM/YYYY'),
              'DATE_2', TO_CHAR(date_2, 'DD/MM/YYYY'),
              'INFO', INFO
            ) AS value,
            DECODE(cm.uom,
              '°', 'DEG',
              cm.uom
            ) AS uom
          FROM atCatiaMapping cm
          LEFT JOIN specification_prop sp ON (
            sp.section_id = NVL(cm.section_id, 0)
            AND sp.sub_section_id = NVL(cm.sub_section_id, 0)
            AND sp.property_group = NVL(cm.property_group, 0)
            AND sp.property = NVL(cm.property, 0)
            AND sp.attribute = NVL(cm.attribute, 0)
          )
          LEFT JOIN characteristic ch_1 ON (ch_1.characteristic_id = sp.characteristic)
          LEFT JOIN characteristic ch_2 ON (ch_1.characteristic_id = sp.ch_2)
          LEFT JOIN characteristic ch_3 ON (ch_1.characteristic_id = sp.ch_3)
          WHERE frame_no = lsFrameNo
          AND frame_rev = lnFrameRev
          AND part_no = lsPartNo
          AND revision = lnRevision
          ;
      BEGIN
        lnRetVal := aapiJobDelegates.SetIntlMode(asPartNo, anRevision);
        
        SELECT frame_id, frame_rev, description
        INTO lsFrameNo, lnFrameRev, lsDesc
        FROM specification_header
        WHERE part_no = asPartNo
        AND revision = anRevision;
        
        SELECT frame_no, MAX(frame_rev)
        INTO lsFrameNo, lnFrameRev
        FROM atCatiaMapping
        WHERE frame_no = lsFrameNo
        AND frame_rev <= lnFrameRev
        GROUP BY frame_no;
      
        SELECT machine
        INTO lsMachine
        FROM v$session
        WHERE audsid = USERENV('sessionid')
        AND ROWNUM = 1;
      
        lsBaseDir   := '\\ensdnas01\xpert_shared$';
        lsTplType   := 'OHT';
        lsCatiaTpl  := 'Development';
        lsTplVer    := 'Current';
        lsTimestamp := ROUND(SYSDATE - DATE '1899-12-30') || ROUND((SYSDATE - TRUNC(SYSDATE)) * 100000);
      
      
        lsFileName := REPLACE(utl_url.escape(asPartNo, TRUE), '%', '$');
        lsFileName := REPLACE(lsFileName, '.', '$2E') || '#' || TO_CHAR(anRevision);
        lsFilePath := 'freeze_' || lsFileName || '.txt';
        lnDatafile := utl_file.fopen(lsFolder, lsFilePath, 'w');
      
        utl_file.put_line(lnDatafile, 'templateDir="' || lsBaseDir || '\' || lsTplType || '\' || lsCatiaTpl || '\Template\' || lsTplVer || '"');
        utl_file.put_line(lnDatafile, 'templateType=' || lsTplType);
        utl_file.put_line(lnDatafile, 'resultDir="' || lsBaseDir || '\Output\Freeze\' || lsFileName || '"');
        utl_file.put_line(lnDatafile, 'clientName=' || lsMachine);
        utl_file.put_line(lnDatafile, 'logonServer=\\ENSDADCS03');
        utl_file.put_line(lnDatafile, 'userDomain=APOLLOTYRES');
        utl_file.put_line(lnDatafile, 'lastModification=' || TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'));
        utl_file.put_line(lnDatafile, 'expertSystemVersion=1.2.7');
        utl_file.put_line(lnDatafile, 'catiaTemplate=' || lsCatiaTpl);
        utl_file.put_line(lnDatafile, 'catiaTemplateVersion=' || lsTplVer);
        utl_file.put_line(lnDatafile, 'timeStamp=' || lsTimestamp);
        utl_file.put_line(lnDatafile, 'dateCreated=' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'));
        utl_file.put_line(lnDatafile, 'drawingType=cavity+layout');
        utl_file.put_line(lnDatafile, 'partNumber=' || asPartNo);
        utl_file.put_line(lnDatafile, 'partNumberDescription=' || lsDesc);
        
        FOR rec IN lqCatiaData(lsFrameNo, lnFrameRev, asPartNo, anRevision)
        LOOP
          dbms_output.put_line(rec.parameter);
          IF rec.uom IS NOT NULL THEN
            utl_file.put_line(lnDatafile, rec.parameter || ' (' || rec.uom || ')=' || rec.value);
          ELSE
            utl_file.put_line(lnDatafile, rec.parameter || '=' || rec.value);
          END IF;
        END LOOP;
      
        IF utl_file.is_open(lnDatafile) THEN
            utl_file.fclose(lnDatafile);
        END IF;
        
        RETURN lnResult;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);

        IF utl_file.is_open(lnDatafile) THEN
            utl_file.fclose(lnDatafile);
        END IF;
        
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END CreateCatiaJobFile;



    FUNCTION CleanDSpecObjects(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod         iapiType.Method_Type := 'CleanDSpecObjects';
        lsErrMsg         iapiType.ErrorText_Type;
        lnRetVal         iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lnResult         iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lsSectionDSpec   iapiType.ID_Type := 700835;
        lsSubSectionNone iapiType.ID_Type := 0;
        lnIntl           iapiType.Boolean_Type;
        lfHandle         iapiType.Float_Type := NULL;
        lqInfo           iapiType.Ref_Type;
        lqErrors         iapiType.Ref_Type;
        lrError          iapitype.ErrorRec_Type;
        ltErrors         iapitype.ErrorTab_type;

        CURSOR lqLinkedObjects (
            asPartNo   IN iapiType.PartNo_Type,
            anRevision IN iapiType.Revision_Type
        ) IS
            SELECT ss.ref_id AS object_id,
                   ss.ref_ver AS revision,
                   ss.ref_owner AS owner
            FROM specification_section ss
            INNER JOIN itoid od
                ON  od.object_id = ss.ref_id
                AND od.revision = ss.ref_ver
                AND od.owner = ss.ref_owner
            INNER JOIN application_user au
                ON au.user_id = od.last_modified_by
            WHERE ss.part_no = asPartNo
              AND ss.revision = anRevision
              AND ss.section_id = lsSectionDSpec
              AND ss.sub_section_id = lsSubSectionNone
              AND ss.type = 6 --Object
              AND ss.ref_id <> 0
              AND au.last_name IN ('SYSTEM', 'SYSTEMADMIN');
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        
        --lnRetVal := iapiGeneral.SetConnection(USER);
        lnRetVal := aapiJobDelegates.SetIntlMode(asPartNo, anRevision);

        IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
            FOR obj IN lqLinkedObjects(asPartNo, anRevision) LOOP
                lnRetVal := iapiSpecificationObject.RemoveObject(
                    asPartNo       => asPartNo,
                    anRevision     => anRevision,
                    anSectionID    => lsSectionDSpec,
                    anSubSectionID => lsSubSectionNone,
                    anItemID       => obj.object_id,
                    anItemRevision => obj.revision,
                    anItemOwner    => obj.owner,
                    afHandle       => lfHandle,
                    aqInfo         => lqInfo,
                    aqErrors       => lqErrors
                );
                
                IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
                    lnRetVal := iapiObject.CheckUsed(
                        anRefId  => obj.object_id,
                        anRefVer => obj.revision,
                        anOwner  => obj.owner
                    );
                    IF lnRetVal = iapiConstantDbError.DBERR_OBJECTALREADYUSED THEN
                        CONTINUE;
                    END IF;
                END IF;
    
                IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
                    lnRetVal := F_SET_OBJECT_STATUS(
                        anObjectID => obj.object_id,
                        anRevision => obj.revision,
                        anStatus   => 4 --Obsolete
                    );
                END IF;
                IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
                    lnRetVal := iapiObject.DeleteObject(
                        anRefID  => obj.object_id,
                        anRefVer => obj.revision,
                        anOwner  => obj.owner
                    );
                END IF;
                IF lnRetVal <> iapiConstantDbError.DBERR_SUCCESS THEN
                    lnResult := lnRetVal;
                END IF;
            END LOOP;
            lnRetVal := lnResult;
        END IF;
        
        IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
        ELSIF lnRetVal = iapiConstantDbError.DBERR_ERRORLIST THEN
            FETCH lqErrors
            BULK COLLECT INTO ltErrors;
    
            IF ltErrors.COUNT > 0 THEN
                FOR lnIndex IN ltErrors.FIRST .. ltErrors.LAST LOOP
                    lrError := ltErrors(lnIndex);
                    lsErrMsg := lrError.ErrorText || ' (' || lrError.ErrorParameterId || ')';
                    dbms_output.put_line(lsErrMsg);
                    iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
                    aapiTrace.Error(lsErrMsg);
                END LOOP;
            END IF;
    
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
        ELSE
            lsErrMsg := iapiGeneral.GetLastErrorText();
            dbms_output.put_line(lsErrMsg);
            iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
            aapiTrace.Error(lsErrMsg);
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
        END IF;
    END;

    FUNCTION AssignObjectToDSpec(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asFilename IN iapiType.ShortDescription_Type,
        abData     IN iapiType.Blob_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod         iapiType.Method_Type := 'AssignObjectToDSpec';
        lsDescription    iapiType.ReferenceTextTypeDescr_Type;
        lsSectionDSpec   iapiType.ID_Type := 700835;
        lsSubSectionNone iapiType.ID_Type := 0;
        lsErrMsg         iapiType.ErrorText_Type;
        lnIntl           iapiType.Boolean_Type;
        lsPartNo         iapiType.PartNo_Type;
        lnRetVal         iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lnObjectID       iapiType.ID_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('asFilename', asFilename);
        aapiTrace.Param('abData', '[...]');

        lsPartNo := utl_url.unescape(REPLACE(asPartNo, '$', '%'));
        lsDescription := lsPartNo || '[' || TO_CHAR(anRevision) || '] ' || asFilename;
    
        iapiGeneral.LogError(psSource, lsMethod, 'Catia file received for ' || lsPartNo || '[' || TO_CHAR(anRevision) || ']: "' || asFilename || '"');
        
        lnRetVal := iapiGeneral.SetConnection(USER);
        lnRetVal := aapiJobDelegates.SetIntlMode(lsPartNo, anRevision);
        
        IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
            BEGIN
                SELECT object_id
                INTO lnObjectID
                FROM itoih
                WHERE description = lsDescription;
                
                lnRetVal := F_SET_OBJECT_STATUS(
                    anObjectID => lnObjectID,
                    anRevision => 1,
                    anStatus   => 4 --Obsolete
                );
                IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
                    lnRetVal := iapiObject.DeleteObject(
                        anRefID  => lnObjectID,
                        anRefVer => 1,
                        anOwner  => 1
                    );
                END IF;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                NULL;
            END;
        END IF;
        
        IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
            lnRetVal := F_CREATE_OBJECT(
                anOwner        => 1,
                asShortDesc    => NULL,
                asDescription  => lsDescription,
                asFilename     => asFilename,
                anObjectWidth  => 0,
                anObjectHeight => 0,
                anIntl         => lnIntl,
                abData         => abData,
                anObjectID     => lnObjectID
            );
        END IF;

        IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
            lnRetVal := F_SET_OBJECT_STATUS(
                anObjectID => lnObjectID,
                anRevision => 1,
                anStatus   => 2 --Current
            );
        END IF;
        
        IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
            lnRetVal := F_ADD_OBJECT(
                asPartNo       => lsPartNo,
                anRevision     => anRevision,
                anSectionID    => lsSectionDSpec,
                anSubSectionID => lsSubSectionNone,
                anObjectID     => lnObjectID,
                anObjectRev    => 1,
                anObjectOwner  => 1
            );
        END IF;
        
        IF lnRetVal <> iapiConstantDbError.DBERR_SUCCESS THEN
            lsErrMsg := iapiGeneral.GetLastErrorText();
            dbms_output.put_line(lsErrMsg);
            iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        END IF;
        
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        aapiTrace.Error(lsErrMsg);
        
        lnRetVal := SetJobResult(
            lsPartNo,
            anRevision,
            iapiConstantDbError.DBERR_GENFAIL
        );
        
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;


    FUNCTION SetJobResult(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        anResult   IN iapiType.ErrorNum_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod      iapiType.Method_Type := 'SetJobResult';
        lnRetVal      iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lsPartNo      iapiType.PartNo_Type;
        lnJobType     NUMBER;
        lnJobID       iapiType.ID_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('anResult', anResult);

        lsPartNo := utl_url.unescape(REPLACE(asPartNo, '$', '%'));
        
        iapiGeneral.LogError(psSource, lsMethod, 'Job result received for ' || lsPartNo || '[' || TO_CHAR(anRevision) || ']: ' || TO_CHAR(anResult));
        lnRetVal := iapiGeneral.SetConnection(USER);
        lnRetVal := aapiJobDelegates.SetIntlMode(lsPartNo, anRevision);

        lnJobID := aapiJob.GetJobID(lsPartNo, anRevision, aapiJobDelegates.JOBTYPE_CATIAJOB);
        IF lnJobID IS NULL THEN
          lnJobID := aapiJob.GetJobID(lsPartNo, anRevision, aapiJobDelegates.JOBTYPE_CATIA);
        END IF;
        lnRetVal := aapiJob.SetJobResult(lnJobID, anResult);

        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    END;

END AAPICATIA;