create or replace PACKAGE BODY AAPIFEA AS

    psSource CONSTANT iapiType.Source_Type := 'aapiFea';
    pnSectionMaterial CONSTANT iapiType.ID_Type := 701015;
    pnSectionDSpec    CONSTANT iapiType.ID_Type := 700835;
    pnSubsectionHyper CONSTANT iapiType.ID_Type := 702262;
    pnSubsectionTanD  CONSTANT iapiType.ID_Type := 702263;
    pnSubsectionNone  CONSTANT iapiType.ID_Type := 0;

    FUNCTION CleanObjects(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod         iapiType.Method_Type := 'CleanObjects';
        lsErrMsg         iapiType.ErrorText_Type;
        lnRetVal         iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
        lnResult         iapiType.ErrorNum_Type := iapiConstantDbError.DBERR_SUCCESS;
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
                   ss.ref_owner AS owner,
                   ss.section_id,
                   ss.sub_section_id
            FROM specification_section ss
            INNER JOIN itoid od
                ON  od.object_id = ss.ref_id
                AND od.revision = ss.ref_ver
                AND od.owner = ss.ref_owner
            INNER JOIN application_user au
                ON au.user_id = od.last_modified_by
            WHERE ss.part_no = asPartNo
              AND ss.revision = anRevision
              AND ss.section_id = pnSectionMaterial
              AND ss.sub_section_id IN (pnSubsectionHyper, pnSubsectionTanD)
              AND ss.type = 6 --Object
              AND ss.ref_id <> 0
              AND au.last_name IN ('SYSTEM', 'SYSTEMADMIN');
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        FOR obj IN lqLinkedObjects(asPartNo, anRevision) LOOP
            lnRetVal := iapiSpecificationObject.RemoveObject(
                asPartNo       => asPartNo,
                anRevision     => anRevision,
                anSectionID    => obj.section_id,
                anSubSectionID => obj.sub_section_id,
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

    FUNCTION CreateMaterialFiles(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod    iapiType.Method_Type := 'CreateMaterialFiles';
        lsErrMsg    iapiType.ErrorText_Type;
        lnResult    iapiType.ErrorNum_Type;
        lnRetVal    iapiType.ErrorNum_Type;
        lsPartNo    iapiType.PartNo_Type;
        lnRevision  iapiType.Revision_Type;
        lsFrameNo   iapiType.FrameNo_Type;
        lnLatestRev iapiType.Revision_Type;
        lnSectionMaterial iapiType.ID_Type := 701015;
        lnSubsectionHyper iapiType.ID_Type := 702262;
        lsFilename  VARCHAR2(40 CHAR) := 'materialfile.header.txt';
        lbTemplate  CLOB;
        lbResult    CLOB;
        lnDestIndex PLS_INTEGER := 1;
        lnSrcIndex  PLS_INTEGER := 1;
        lnLangCtx   PLS_INTEGER := dbms_lob.Default_Lang_Ctx;
        lbData      BLOB;
        lnObjectID  iapiType.ID_Type;
        lnJobID     iapiType.ID_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        --lnRetVal := iapiGeneral.SetConnection(USER);
        
        lsPartNo := asPartNo;
        lnRevision := anRevision;

        SELECT frame_id
        INTO lsFrameNo
        FROM specification_header
        WHERE part_no  = lsPartNo
          AND revision = lnRevision;
        
        IF lsFrameNo = 'A_FEA_Materials' THEN
            SELECT kw_value
            INTO lsPartNo
            FROM specification_kw
            WHERE part_no = lsPartNo
              AND kw_id = 700911; --Linked production compound
            
            SELECT revision
            INTO lnRevision
            FROM specification_header
            LEFT JOIN status USING (status)
            WHERE part_no = lsPartNo
              AND status_type = 'CURRENT';
            --TODO: Error when not found.

            SELECT frame_id
            INTO lsFrameNo
            FROM specification_header
            WHERE part_no  = lsPartNo
              AND revision = lnRevision;
        END IF;
    
        BEGIN
            SELECT MAX(revision)
            INTO lnLatestRev
            FROM atFeaTemplate
            WHERE frame_no = lsFrameNo;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            lnLatestRev := NULL;
        END;
        
        IF lnLatestRev IS NOT NULL THEN
            SELECT template
            INTO lbTemplate
            FROM atFeaTemplate
            WHERE frame_no = lsFrameNo
              AND revision = lnLatestRev;
            
            lnRetVal := aapiTemplate.Parse(
                lbTemplate,
                lbResult,
                lsPartNo,
                lnRevision
            );
            IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
                dbms_lob.CreateTemporary(lbData, TRUE, dbms_lob.CALL);
                dbms_lob.ConvertToBlob(
                    lbData,
                    lbResult,
                    dbms_lob.LobMaxSize,
                    lnDestIndex,
                    lnSrcIndex,
                    dbms_lob.Default_Csid,
                    lnLangCtx,
                    lnRetVal
                );

                BEGIN
                    SELECT object_id
                    INTO lnObjectID
                    FROM itoih
                    WHERE description = asPartNo || '[' || TO_CHAR(anRevision) || '] ' || lsFilename;
                    
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

                IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
                    lnRetVal := F_CREATE_OBJECT(
                        anOwner        => 1,
                        asShortDesc    => NULL,
                        asDescription  => asPartNo || '[' || TO_CHAR(anRevision) || '] ' || lsFilename,
                        asFilename     => lsFilename,
                        anObjectWidth  => 0,
                        anObjectHeight => 0,
                        anIntl         => 0,
                        abData         => lbData,
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
                        asPartNo       => asPartNo,
                        anRevision     => anRevision,
                        anSectionID    => lnSectionMaterial,
                        anSubSectionID => lnSubsectionHyper,
                        anObjectID     => lnObjectID,
                        anObjectRev    => 1,
                        anObjectOwner  => 1
                    );
                END IF;
            END IF;
        ELSE
            lnRetVal := iapiConstantDBError.DBERR_MAPPINGNOTFOUND;
        END IF;
        
        lnResult := lnRetVal;
        lnJobID := aapiJob.GetJobID(asPartNo, anRevision, aapiJobDelegates.JOBTYPE_FEA);
        lnRetVal := aapiJob.SetJobResult(lnJobID, lnResult);

        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);

        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;
    
    FUNCTION GetAttachedFile(
        asPartNo     IN iapiType.PartNo_Type,
        anRevision   IN iapiType.Revision_Type,
        anSection    IN iapiType.ID_Type,
        anSubsection IN iapiType.ID_Type,
        aqImported   IN OUT NOCOPY SpecRefTable_Type,
        abResult     IN OUT NOCOPY BLOB
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'GetAttachedFile';
        lsErrMsg   iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type;
        lnRevision iapiType.Revision_Type;
        lnCount    PLS_INTEGER;
        lbBuffer   BLOB;
        lnImported BOOLEAN;
        lrSpecRef  SpecRefRecord_Type;
        lsHeader   VARCHAR2(40 CHAR) := '%.header.%';
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('anSection', anSection);
        aapiTrace.Param('anSubSection', anSubSection);

        dbms_lob.Trim(abResult, 0);

        lnRevision := anRevision;
        IF lnRevision IS NULL THEN
            BEGIN
                SELECT revision
                INTO lnRevision
                FROM specification_header
                WHERE part_no = asPartNo
                  AND SYSDATE BETWEEN issued_date AND NVL(obsolescence_date, SYSDATE)
                ;
            EXCEPTION WHEN OTHERS THEN
                lnRevision := 1;
            END;
        END IF;
        
        SELECT COUNT(*)
        INTO lnCount
        FROM specification_section ss
        WHERE ss.part_no = asPartNo
          AND ss.revision = lnRevision
          AND ss.section_id = anSection
          AND ss.sub_section_id = anSubsection
          AND ss.type = 6 --Object
          AND ss.ref_id <> 0
        ;
        
        IF lnCount = 0 THEN
            RETURN iapiConstantDBError.DBERR_OBJECTNOTFOUND;
        END IF;

        BEGIN
            SELECT desktop_object
            INTO lbBuffer
            FROM specification_section ss
            INNER JOIN itoiraw rw
                ON  rw.object_id = ss.ref_id
                AND rw.revision  = ss.ref_ver
                AND rw.owner     = ss.ref_owner
            INNER JOIN itoid od
                ON  od.object_id = ss.ref_id
                AND od.revision  = ss.ref_ver
                AND od.owner     = ss.ref_owner
            WHERE ss.part_no = asPartNo
              AND ss.revision = lnRevision
              AND ss.section_id = anSection
              AND ss.sub_section_id = anSubsection
              AND ss.type = 6 --Object
              AND ss.ref_id <> 0
              AND LOWER(od.file_name) LIKE LOWER(lsHeader)
            ;
            dbms_lob.append(abResult, lbBuffer);
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        END;
    
        lnImported := FALSE;
        IF aqImported.COUNT > 0 THEN
            FOR lnIndex IN aqImported.FIRST .. aqImported.LAST
            LOOP
                IF aqImported(lnIndex).part_no = asPartNo
                AND aqImported(lnIndex).revision = lnRevision THEN
                    lnImported := TRUE;
                    EXIT;
                END IF;
            END LOOP;
        END IF;

        IF lnImported THEN
            aapiTrace.Exit(iapiConstantDBError.DBERR_SPECALREADYEXIST);
            RETURN iapiConstantDBError.DBERR_SPECALREADYEXIST;
        ELSE
            aqImported.EXTEND();
            aqImported(aqImported.LAST) := SpecRefRecord_Type(asPartNo, lnRevision, NULL);
    
            FOR obj IN (
                SELECT desktop_object
                FROM specification_section ss
                INNER JOIN itoiraw rw
                    ON  rw.object_id = ss.ref_id
                    AND rw.revision  = ss.ref_ver
                    AND rw.owner     = ss.ref_owner
                INNER JOIN itoid od
                    ON  od.object_id = ss.ref_id
                    AND od.revision  = ss.ref_ver
                    AND od.owner     = ss.ref_owner
                WHERE ss.part_no = asPartNo
                  AND ss.revision = lnRevision
                  AND ss.section_id = anSection
                  AND ss.sub_section_id = anSubsection
                  AND ss.type = 6 --Object
                  AND ss.ref_id <> 0
                  AND od.file_name NOT LIKE lsHeader
            ) LOOP
                IF dbms_lob.GetLength(abResult) > 0 THEN
                    dbms_lob.Append(abResult, HEXTORAW('0D0A'));
                END IF;
                dbms_lob.append(abResult, obj.desktop_object);
            END LOOP;
            
            aapiTrace.Exit(iapiConstantDBError.DBERR_SUCCESS);
            RETURN iapiConstantDBError.DBERR_SUCCESS;
        END IF;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;
    
    FUNCTION GetHyperMaterialfile(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        abResult   OUT aapiBlob.t_raw --IN OUT NOCOPY BLOB
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'GetHyperMaterialfile';
        lsErrMsg   iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
        lnErrNum   iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
        lnRevision iapiType.Revision_Type;
        lqImported SpecRefTable_Type;
        lbBuffer BLOB;
        lbResult BLOB;
        
        FUNCTION AppendComponentFiles(
            asComponent IN VARCHAR2,
            asReinfType IN VARCHAR2 DEFAULT NULL
        ) RETURN iapiType.ErrorNum_Type
        AS
            lnRetVal          iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
            lnErrNum          iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
            lsComponentPartNo iapiType.PartNo_Type;
            lsCompoundPartNo  iapiType.PartNo_Type;
            lsPartNoRef       iapiType.String_Type;
            lsReinfPartNo     iapiType.PartNo_Type;
            lnCurrentRev      iapiType.Revision_Type;
            lnComponentRev    iapiType.Revision_Type;
        BEGIN
            aapiTrace.Enter();
            aapiTrace.Param('asComponent', asComponent);
            aapiTrace.Param('asReinfType', asReinfType);

            IF dbms_lob.GetLength(lbResult) > 0 THEN
                dbms_lob.Append(lbResult, HEXTORAW('0D0A'));
            END IF;
            dbms_lob.Append(lbResult, utl_raw.cast_to_raw('**' || asComponent || ' > Compound'));
        
            lsComponentPartNo := aapiTemplate.Bind(
                asPartNo,
                lnRevision,
                'spec/section[@name="D-spec"]//' ||
                'prop_group[@name="Materials and compounds"]/' ||
                'property[@name="' || asComponent || '"]/' ||
                'value[@header="Code"]'
            );
            IF lsComponentPartNo IS NULL THEN
                dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No component specified for ' || asComponent));
            ELSE
                SELECT NVL(MAX(revision), 0)
                INTO lnCurrentRev
                FROM specification_header
                INNER JOIN status USING (status)
                WHERE part_no = lsComponentPartNo
                AND status_type = 'CURRENT';
                
                IF lnCurrentRev = 0 THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No current spec found for ' || lsComponentPartNo || ' (' || asComponent || ')'));
                    lsComponentPartNo := NULL;
                ELSE
                    lnComponentRev := lnCurrentRev;
                END IF;
            END IF;
            
            lsCompoundPartNo := aapiTemplate.Bind(
                asPartNo,
                lnRevision,
                'spec/section[@name="D-spec"]//' ||
                'prop_group[@name="Materials and compounds"]/' ||
                'property[@name="' || asComponent || '"]/' ||
                'value[@header="Custom compound"]'
            );
            IF lsCompoundPartNo IS NULL THEN
                IF lsComponentPartNo IS NULL THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No compound specified for ' || asComponent));
                ELSIF asReinfType IS NULL THEN
                    lsCompoundPartNo := lsComponentPartNo;
                ELSE
                    lsCompoundPartNo := aapiTemplate.Bind(
                        lsComponentPartNo, NULL,
                        'spec/header/part_no', NULL,
                        'spec/spec[@func="Compound"]'
                    );
                    IF lsCompoundPartNo IS NULL THEN
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No compound found for ' || lsComponentPartNo || '[' || TO_CHAR(lnComponentRev) || '] (' || asComponent || ')'));
                    END IF;
                END IF;
            END IF;
            
            IF lsCompoundPartNo IS NOT NULL THEN
                lsPartNoRef := lsCompoundPartNo;
                
                BEGIN
                    SELECT kw.part_no
                    INTO lsCompoundPartNo
                    FROM specification_kw kw, specification_header sh, status ss
                    WHERE kw.kw_value = lsPartNoRef
                    AND kw.part_no = sh.part_no
                    AND ss.status = sh.status
                    AND ss.status_type = 'CURRENT'
                    AND kw.kw_id = 700911; --Linked production compound

                    lsPartNoRef := lsPartNoRef || '->' || lsCompoundPartNo;
                EXCEPTION
                WHEN TOO_MANY_ROWS  THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!Too many attached specs found for ' || lsPartNoRef || ' (' || asComponent || ')'));
                    lsCompoundPartNo := NULL;
                WHEN NO_DATA_FOUND THEN
                    NULL; --IGNORE
                END;

                SELECT NVL(MAX(revision), 0)
                INTO lnCurrentRev
                FROM specification_header
                INNER JOIN status USING (status)
                WHERE part_no = lsCompoundPartNo
                AND status_type = 'CURRENT';
                
                IF lnCurrentRev = 0 THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No current spec found for ' || lsPartNoRef || ' (' || asComponent || ')'));
                ELSE
                    lnRetVal := GetAttachedFile(
                        lsCompoundPartNo, NULL,
                        pnSectionMaterial, pnSubsectionHyper,
                        lqImported,
                        lbBuffer
                    );
                    IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
                        dbms_lob.Append(lbResult, HEXTORAW('0D0A'));
                        dbms_lob.Append(lbResult, lbBuffer);
                    ELSIF lnRetVal = iapiConstantDBError.DBERR_SPECALREADYEXIST THEN
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!Materialfile already imported: ' || lsPartNoRef || '[' || TO_CHAR(lnCurrentRev) || '] (' || asComponent || ')'));
                    ELSE
                        lnErrNum := lnRetVal;
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No materialfile found for ' || lsPartNoRef || '[' || TO_CHAR(lnCurrentRev) || '] (' || asComponent || ')'));
                    END IF;
                END IF;
            END IF;

            IF asReinfType IS NOT NULL THEN
                dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**' || asComponent || ' > Reinforcement'));
                lsReinfPartNo := aapiTemplate.Bind(
                    asPartNo,
                    lnRevision,
                    'spec/section[@name="D-spec"]//' ||
                    'prop_group[@name="Materials and compounds"]/' ||
                    'property[@name="' || asComponent || '"]/' ||
                    'value[@header="Custom reinforcement"]'
                );
                
                IF lsReinfPartNo IS NULL THEN
                    IF lsComponentPartNo IS NULL THEN
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No reinforcement specified for ' || asComponent));
                    ELSE
                        lsReinfPartNo := aapiTemplate.Bind(
                            lsComponentPartNo, NULL,
                            'spec/header/part_no', NULL,
                            'spec/spec[@func="' || asReinfType || '"]'
                        );
                        IF lsReinfPartNo IS NULL THEN
                            dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No reinforcement found for ' || lsComponentPartNo || '[' || TO_CHAR(lnComponentRev) || '] (' || asComponent || ')'));
                        END IF;
                    END IF;
                END IF;

                IF lsReinfPartNo IS NOT NULL THEN
                    SELECT NVL(MAX(revision), 0)
                    INTO lnCurrentRev
                    FROM specification_header
                    INNER JOIN status USING (status)
                    WHERE part_no = lsReinfPartNo
                    AND status_type = 'CURRENT';
                    
                    IF lnCurrentRev = 0 THEN
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No current spec found for ' || lsReinfPartNo || ' (' || asComponent || ')'));
                    ELSE
                        lnRetVal := GetAttachedFile(
                            lsReinfPartNo, NULL,
                            pnSectionMaterial, pnSubsectionHyper,
                            lqImported,
                            lbBuffer
                        );
                        IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
                            dbms_lob.Append(lbResult, HEXTORAW('0D0A'));
                            dbms_lob.Append(lbResult, lbBuffer);
                        ELSIF lnRetVal = iapiConstantDBError.DBERR_SPECALREADYEXIST THEN
                            dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!Materialfile already imported: ' || lsReinfPartNo || '[' || TO_CHAR(lnCurrentRev) || '] (' || asComponent || ')'));
                        ELSE
                            lnErrNum := lnRetVal;
                            dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No materialfile found for ' || lsReinfPartNo || '[' || TO_CHAR(lnCurrentRev) || '] (' || asComponent || ')'));
                        END IF;
                    END IF;
                END IF;
            END IF;
            
            aapiTrace.Exit(lnErrNum);
            RETURN lnErrNum;
        EXCEPTION WHEN OTHERS THEN
            lsErrMsg := SQLERRM;
            dbms_output.put_line(lsErrMsg);
            iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
            
            aapiTrace.Error(lsErrMsg);
            aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
            RETURN iapiConstantDBError.DBERR_GENFAIL;
        END;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        dbms_lob.CreateTemporary(lbResult, TRUE, dbms_lob.CALL);
        dbms_lob.CreateTemporary(lbBuffer, TRUE, dbms_lob.CALL);
        lqImported := SpecRefTable_Type();

        lnRevision := anRevision;
        IF lnRevision IS NULL THEN
            BEGIN
                SELECT revision
                INTO lnRevision
                FROM specification_header
                WHERE part_no = asPartNo
                  AND SYSDATE BETWEEN issued_date AND NVL(obsolescence_date, SYSDATE)
                ;
            EXCEPTION WHEN OTHERS THEN
                lnRevision := 1;
            END;
        END IF;

        lnRetVal := AppendComponentFiles('Innerliner');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Ply', 'Fabric');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Belt', 'Steelcord');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Capply', 'Fabric');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Beltstrip');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Sidewall');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Rimcushion');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Sidewall');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Bead wire');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread cap');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Filler');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread base 1');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread base 2');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread wingtip');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Runflat insert');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Chafer');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Chipper');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Squeegee');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := GetAttachedFile(
            asPartNo, lnRevision,
            pnSectionMaterial, pnSubsectionHyper,
            lqImported,
            lbBuffer
        );

        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            lnErrNum := lnRetVal;
        ELSE
            IF dbms_lob.GetLength(lbResult) > 0 THEN
                dbms_lob.Append(lbResult, HEXTORAW('0D0A'));
            END IF;
            dbms_lob.Append(lbResult, lbBuffer);
        END IF;
        
        abResult := aapiBlob.Convert(lbResult);

        aapiTrace.Exit(lnErrNum);
        RETURN lnErrNum;
    EXCEPTION WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;

    FUNCTION GetRRMaterialfile(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        abResult   OUT aapiBlob.t_raw --IN OUT NOCOPY BLOB
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'GetRRMaterialfile';
        lsErrMsg   iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
        lnErrNum   iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
        lnRevision iapiType.Revision_Type;
        lqImported SpecRefTable_Type;
        lbBuffer BLOB;
        lbResult BLOB;
        
        FUNCTION AppendComponentFiles(
            asComponent IN VARCHAR2,
            asReinfType IN VARCHAR2 DEFAULT NULL
        ) RETURN iapiType.ErrorNum_Type
        AS
            lnRetVal          iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
            lnErrNum          iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
            lsComponentPartNo iapiType.PartNo_Type;
            lsCompoundPartNo  iapiType.PartNo_Type;
            lsPartNoRef       iapiType.String_Type;
            lsReinfPartNo     iapiType.PartNo_Type;
            lnCurrentRev      iapiType.Revision_Type;
            lnComponentRev    iapiType.Revision_Type;
        BEGIN
            aapiTrace.Enter();
            aapiTrace.Param('asComponent', asComponent);
            aapiTrace.Param('asReinfType', asReinfType);

            IF dbms_lob.GetLength(lbResult) > 0 THEN
                dbms_lob.Append(lbResult, HEXTORAW('0D0A'));
            END IF;
            dbms_lob.Append(lbResult, utl_raw.cast_to_raw('**' || asComponent || ' > Compound'));

            lsComponentPartNo := aapiTemplate.Bind(
                asPartNo,
                lnRevision,
                'spec/section[@name="D-spec"]//' ||
                'prop_group[@name="Materials and compounds"]/' ||
                'property[@name="' || asComponent || '"]/' ||
                'value[@header="Code"]'
            );
            IF lsComponentPartNo IS NULL THEN
                dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No component specified for ' || asComponent));
            ELSE
                SELECT NVL(MAX(revision), 0)
                INTO lnCurrentRev
                FROM specification_header
                INNER JOIN status USING (status)
                WHERE part_no = lsComponentPartNo
                AND status_type = 'CURRENT';
                
                IF lnCurrentRev = 0 THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No current spec found for ' || lsComponentPartNo || ' (' || asComponent || ')'));
                    lsComponentPartNo := NULL;
                ELSE
                    lnComponentRev := lnCurrentRev;
                END IF;
            END IF;

            lsCompoundPartNo := aapiTemplate.Bind(
                asPartNo,
                lnRevision,
                'spec/section[@name="D-spec"]//' ||
                'prop_group[@name="Materials and compounds"]/' ||
                'property[@name="' || asComponent || '"]/' ||
                'value[@header="Custom compound"]'
            );
            IF lsCompoundPartNo IS NULL THEN
                IF lsComponentPartNo IS NULL THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No compound specified for ' || asComponent));
                ELSIF asReinfType IS NULL THEN
                    lsCompoundPartNo := lsComponentPartNo;
                ELSE
                    lsCompoundPartNo := aapiTemplate.Bind(
                        lsComponentPartNo, NULL,
                        'spec/header/part_no', NULL,
                        'spec/spec[@func="Compound"]'
                    );
                    IF lsCompoundPartNo IS NULL THEN
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No compound found for ' || lsComponentPartNo || '[' || TO_CHAR(lnComponentRev) || '] (' || asComponent || ')'));
                    END IF;
                END IF;
            END IF;

            IF lsCompoundPartNo IS NOT NULL THEN
                lsPartNoRef := lsCompoundPartNo;
                
                BEGIN
                    SELECT kw.part_no
                    INTO lsCompoundPartNo
                    FROM specification_kw kw, specification_header sh, status ss
                    WHERE kw.kw_value = lsPartNoRef
                    AND kw.part_no = sh.part_no
                    AND ss.status = sh.status
                    AND ss.status_type = 'CURRENT'
                    AND kw.kw_id = 700911; --Linked production compound

                    lsPartNoRef := lsPartNoRef || '->' || lsCompoundPartNo;
                EXCEPTION
                WHEN TOO_MANY_ROWS  THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!Too many attached specs found for ' || lsPartNoRef || ' (' || asComponent || ')'));
                    lsCompoundPartNo := NULL;
                WHEN NO_DATA_FOUND THEN
                    NULL; --IGNORE
                END;
                
                SELECT NVL(MAX(revision), 0)
                INTO lnCurrentRev
                FROM specification_header
                INNER JOIN status USING (status)
                WHERE part_no = lsCompoundPartNo
                AND status_type = 'CURRENT';
                
                IF lnCurrentRev = 0 THEN
                    dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No current spec found for ' || lsPartNoRef || ' (' || asComponent || ')'));
                ELSE
                    lnRetVal := GetAttachedFile(
                        lsCompoundPartNo, NULL,
                        pnSectionMaterial, pnSubsectionTanD,
                        lqImported,
                        lbBuffer
                    );
                    IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
                        dbms_lob.Append(lbResult, HEXTORAW('0D0A'));
                        dbms_lob.Append(lbResult, lbBuffer);
                    ELSIF lnRetVal = iapiConstantDBError.DBERR_SPECALREADYEXIST THEN
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!Materialfile already imported: ' || lsPartNoRef || '[' || TO_CHAR(lnCurrentRev) || '] (' || asComponent || ')'));
                    ELSE
                        lnErrNum := lnRetVal;
                        dbms_lob.Append(lbResult, utl_raw.cast_to_raw(CHR(13) || CHR(10) || '**!!No materialfile found for ' || lsPartNoRef || '[' || TO_CHAR(lnCurrentRev) || '] (' || asComponent || ')'));
                    END IF;
                END IF;
            END IF;
            
            aapiTrace.Exit(lnErrNum);
            RETURN lnErrNum;
        EXCEPTION WHEN OTHERS THEN
            lsErrMsg := SQLERRM;
            dbms_output.put_line(lsErrMsg);
            iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
            
            aapiTrace.Error(lsErrMsg);
            aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
            RETURN iapiConstantDBError.DBERR_GENFAIL;
        END;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        dbms_lob.CreateTemporary(lbResult, TRUE, dbms_lob.CALL);
        dbms_lob.CreateTemporary(lbBuffer, TRUE, dbms_lob.CALL);
        lqImported := SpecRefTable_Type();

        lnRevision := anRevision;
        IF lnRevision IS NULL THEN
            BEGIN
                SELECT revision
                INTO lnRevision
                FROM specification_header
                WHERE part_no = asPartNo
                  AND SYSDATE BETWEEN issued_date AND NVL(obsolescence_date, SYSDATE)
                ;
            EXCEPTION WHEN OTHERS THEN
                lnRevision := 1;
            END;
        END IF;

        lnRetVal := AppendComponentFiles('Innerliner');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Ply', 'Fabric');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Belt', 'Steelcord');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Capply', 'Fabric');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Beltstrip');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Sidewall');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Rimcushion');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Sidewall');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Bead wire compound');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread cap');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Filler');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread base 1');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread base 2');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Tread wingtip');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;
        
        lnRetVal := AppendComponentFiles('Runflat insert');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Chafer');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Chipper');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        lnRetVal := AppendComponentFiles('Squeegee');
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN lnErrNum := lnRetVal; END IF;

        abResult := aapiBlob.Convert(lbResult);
        
        aapiTrace.Exit(lnErrNum);
        RETURN lnErrNum;
    EXCEPTION WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;

    FUNCTION GetCatPart(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        abResult   OUT aapiBlob.t_raw --IN OUT NOCOPY BLOB
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'GetCatPart';
        lsErrMsg   iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
        lnRevision iapiType.Revision_Type;
        lbBuffer   BLOB;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        dbms_lob.CreateTemporary(lbBuffer, TRUE, dbms_lob.CALL);

        lnRevision := anRevision;
        IF lnRevision IS NULL THEN
            BEGIN
                SELECT revision
                INTO lnRevision
                FROM specification_header
                WHERE part_no = asPartNo
                  AND SYSDATE BETWEEN issued_date AND NVL(obsolescence_date, SYSDATE)
                ;
            EXCEPTION WHEN OTHERS THEN
                lnRevision := 1;
            END;
        END IF;
        
        SELECT desktop_object
        INTO lbBuffer
        FROM specification_section ss
        INNER JOIN itoiraw rw
            ON  rw.object_id = ss.ref_id
            AND rw.revision  = ss.ref_ver
            AND rw.owner     = ss.ref_owner
        INNER JOIN itoid od
            ON  od.object_id = ss.ref_id
            AND od.revision  = ss.ref_ver
            AND od.owner     = ss.ref_owner
        WHERE ss.part_no = asPartNo
          AND ss.revision = lnRevision
          AND ss.section_id = pnSectionDSpec
          AND ss.sub_section_id = pnSubsectionNone
          AND ss.type = 6 --Object
          AND ss.ref_id <> 0
          AND LOWER(od.file_name) = 'cross-section.catpart'
        ;

        abResult := aapiBlob.Convert(lbBuffer);

        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;

    FUNCTION ValidateValues(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
    BEGIN
        RETURN 0;
    END;

END AAPIFEA;