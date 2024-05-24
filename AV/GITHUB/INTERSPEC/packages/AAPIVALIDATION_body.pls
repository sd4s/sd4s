create or replace PACKAGE BODY AAPIVALIDATION AS

    CURSOR gqRules(
        asRuleType IN iapiType.StringVal_Type DEFAULT NULL
    ) IS
        SELECT
            sv.seq_no,
            sv.mandatory,
            sv.clear,
            flt.*,
            ref.ref_id,
            ref.section_id,
            ref.sub_section_id,
            ref.property_group,
            ref.property,
            ref.attribute,
            ref.header_id,
            ref.description AS ref_desc,
            rule.rule_id,
            rule.rule_type,
            rule.rule,
            rule.arg1,
            rule.arg2,
            rule.description AS rule_desc
        FROM atSpecVal sv
        INNER JOIN atSpecVal_Filter flt ON (flt.filter_id = sv.filter_id)
        INNER JOIN atSpecVal_Ref ref ON (ref.ref_id = sv.ref_id)
        INNER JOIN atSpecVal_Rule rule ON(rule.rule_id = sv.rule_id)
        WHERE (asRuleType IS NULL OR rule_type = asRuleType)
        AND sv.status = 2
        ORDER BY DECODE(rule.rule_type,
            gsWarning,     0,
            gsValidation,  1,
            gsCalculation, 2
        ),
        seq_no
        ;
        
    CURSOR gqRef(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_type,
        anSubSection    IN iapiType.ID_type,
        anPropertyGroup IN iapiType.ID_type,
        anProperty      IN iapiType.ID_type,
        anAttribute     IN iapiType.ID_type,
        anHeader        IN iapiType.ID_type
    ) IS
        SELECT
            section_id,
            sub_section_id,
            property_group,
            property,
            attribute,
            anHeader AS header_id
        FROM specification_prop sp
        WHERE part_no = asPartNo
        AND revision = anRevision
        AND (anSection IS NULL OR section_id = anSection)
        AND (anSubSection IS NULL OR sub_section_id = anSubSection)
        AND (anPropertyGroup IS NULL OR property_group = anPropertyGroup)
        AND (anProperty IS NULL OR property = anProperty)
        AND (anAttribute IS NULL OR attribute = anAttribute)
        ;

    FUNCTION MatchSpec(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        anFilterID IN iapiType.ID_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lnCount PLS_INTEGER;
    BEGIN
        SELECT COUNT(*)
        INTO lnCount
        FROM
            specification_header sh,
            atSpecVal_Filter flt
        WHERE sh.part_no = asPartNo
        AND sh.revision = anRevision
        AND flt.filter_id = anFilterID
        AND (flt.part_no IS NULL OR sh.part_no LIKE flt.part_no)
        AND (flt.rev_min IS NULL OR sh.revision >= flt.rev_min)
        AND (flt.rev_max IS NULL OR sh.revision <= flt.rev_max)
        AND (flt.owner IS NULL OR sh.owner = flt.owner)
        AND (flt.status IS NULL OR sh.status = flt.status)
        AND (flt.status_type IS NULL
            OR flt.status_type = (
                SELECT status_type FROM status
                WHERE status = sh.status
            )
        )
        AND (flt.description IS NULL OR sh.description LIKE flt.description)
        AND (flt.frame_id IS NULL OR sh.frame_id LIKE flt.frame_id)
        AND (flt.frame_rev_min IS NULL OR sh.frame_rev >= flt.frame_rev_min)
        AND (flt.frame_rev_max IS NULL OR sh.frame_rev <= flt.frame_rev_max)
        AND (flt.frame_owner IS NULL OR sh.frame_owner = flt.frame_owner)
        AND (flt.access_group IS NULL OR sh.access_group = flt.access_group)
        AND (flt.workflow_group_id IS NULL OR sh.workflow_group_id = flt.workflow_group_id)
        AND (flt.class3_id IS NULL OR sh.class3_id = flt.class3_id)
        AND (flt.spec_type_group IS NULL
            OR flt.spec_type_group = (
                SELECT type FROM class3
                WHERE class = sh.class3_id
            )
        )
        AND (flt.int_frame_no IS NULL OR sh.int_frame_no LIKE flt.int_frame_no)
        AND (flt.int_frame_rev_min IS NULL OR sh.int_frame_rev >= flt.int_frame_rev_min)
        AND (flt.int_frame_rev_max IS NULL OR sh.int_frame_rev <= flt.int_frame_rev_max)
        AND (flt.int_part_no IS NULL OR sh.int_part_no LIKE flt.int_part_no)
        AND (flt.int_part_rev_min IS NULL OR sh.int_part_rev >= flt.int_part_rev_min)
        AND (flt.int_part_rev_max IS NULL OR sh.int_part_rev <= flt.int_part_rev_max)
        AND (flt.intl IS NULL OR sh.intl = flt.intl)
        AND (flt.multilang IS NULL OR sh.multilang = flt.multilang)
        AND (flt.plant IS NULL
            OR flt.plant IN (
                SELECT plant FROM part_plant
                WHERE part_no = sh.part_no
            )
        )
        AND (flt.alt_part_no IS NULL
            OR (
                SELECT alt_part_no FROM part
                WHERE part_no = sh.part_no
            ) LIKE flt.alt_part_no
        )
        AND (flt.lang_id IS NULL OR flt.lang_descr IS NULL
            OR (
                SELECT description FROM itshdescr_l
                WHERE part_no = sh.part_no
                AND revision = sh.revision
                AND lang_id = flt.lang_id
            ) LIKE flt.lang_descr
        );
        
        IF lnCount = 1 THEN
            RETURN iapiConstantDBError.DBERR_SUCCESS;
        ELSE
            RETURN iapiConstantDBError.DBERR_GENFAIL;
        END IF;
    END;

    FUNCTION FormatQuery(
        asRule    IN iapiType.StringVal_Type
    ) RETURN iapiType.StringVal_Type
    AS
        lsRule    iapiType.SqlString_Type;
        lsPattern iapiType.String_Type := '(^|\W)\$((\w|\$)+)(\s*\S|$)';
        lsBindPat iapiType.String_Type := '^([^'']*(''[^'']*''[^'']*?)*?''[^'']*?)\${([^}'']*?)(:([^:]*[<^>]\d+))?}([^'']*?'')';

        lsMatch  iapiType.SqlString_Type;
        lsName   iapiType.String_Type;
        lsArgs   iapiType.String_Type;
        lsPrefix iapiType.String_Type;
        lsSuffix iapiType.String_Type;
    BEGIN
        lsRule := asRule;
        
        LOOP
            lsMatch := REGEXP_SUBSTR(lsRule, lsBindPat, 1, 1);
            EXIT WHEN lsMatch IS NULL;
            
            lsRule := REGEXP_REPLACE(lsRule, lsBindPat, '\1''||$Bind(''\3'', ''\5'')||''\6', 1, 1);
        END LOOP;
        
        lsRule := REGEXP_REPLACE(lsRule, '\\([{}])', '\1');
        
        LOOP
            lsMatch := REGEXP_SUBSTR(lsRule, lsPattern, 1, 1);
            EXIT WHEN lsMatch IS NULL;
            
            lsArgs := '';
            lsName := UPPER(REGEXP_REPLACE(lsMatch, lsPattern, '\2'));
            lsPrefix := '';
            lsSuffix := REGEXP_REPLACE(lsMatch, lsPattern, '\4');
            IF lsSuffix IS NULL OR SUBSTR(lsSuffix, -1) <> '(' THEN
                IF lsName IN ('MATCHREGEX', 'RANGE', 'LENGTHRANGE') THEN
                    lsArgs := '(param.value, param.arg1, param.arg2)';
                ELSIF lsName IN ('ISEQUAL', 'ISDATE', 'ISDECIMAL', 'ISMULTIPLE', 'ISOBJECT') THEN
                    lsArgs := '(param.value, param.arg1)';
                ELSE
                    lsArgs := '(param.value)';
                END IF;
                lsSuffix := '=1' || lsSuffix;
            ELSE
                IF lsName IN ('COLUMNVALUE') THEN
                    lsArgs := '(param.part_no, param.revision, param.section, param.sub_section, param.property_group, param.property, param.attribute, ';
                ELSIF REGEXP_LIKE(lsName, 'LIMIT\$[A-Z0-9_]+$') THEN
                    lsPrefix := '1=';
                    lsArgs := SUBSTR(lsName, 7);
                    lsArgs := '(' || lsArgs || '_OP, ' || lsArgs || '_VAL, ';
                    lsName := 'Limit';
                ELSIF lsName IN ('BIND') THEN
                    lsArgs := '(param.part_no, param.revision, ';
                ELSIF lsName IN ('LOOKUP') THEN
                    lsArgs := '(';
                ELSE
                    lsArgs := '(param.value, ';
                END IF;
                lsSuffix := '';
            END IF;
            
            lsRule := REGEXP_REPLACE(lsRule, lsPattern, '\1' || lsPrefix || gsSource || '.' || lsName || lsArgs || lsSuffix, 1, 1);
        END LOOP;
        
        RETURN lsRule;
    END;
        
    FUNCTION CustomValidation(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        anHeader        IN iapiType.ID_Type,
        asMandatory     IN iapiType.Mandatory_Type,
        asRule          IN iapiType.StringVal_Type,
        asArg1          IN iapiType.StringVal_Type DEFAULT NULL,
        asArg2          IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod iapiType.Method_Type := 'CustomValidation';
        lsValue  iapiType.String_Type;
        lsRawVal iapiType.String_Type;
        lnCount  PLS_INTEGER;
        lnRetVal iapiType.ErrorNum_Type;
        lnResult iapiType.ErrorNum_Type;
    BEGIN
        lnRetVal := iapiConstantDBError.DBERR_SUCCESS;
        IF gnCalculating = 1 THEN
            RETURN lnRetVal;
        END IF;
        gnCalculating := 1;
        
        BEGIN
            lsValue := aapiDataBinding.GetPropertyValue(
                asPartNo,
                anRevision,
                anSection,
                anSubSection,
                anPropertyGroup,
                anProperty,
                anAttribute,
                anHeader
            );
            
            lsRawVal := aapiDataBinding.GetPropertyValue(
                asPartNo,
                anRevision,
                anSection,
                anSubSection,
                anPropertyGroup,
                anProperty,
                anAttribute,
                anHeader,
                anRawValue => 1
            );
        EXCEPTION
        WHEN OTHERS THEN
            IF asMandatory = iapiConstant.Flag_Yes THEN
                RAISE;
            ELSE
                lsValue  := NULL;
                lsRawVal := NULL;
            END IF;
        END;
        
        lnCount := 1;
        IF asMandatory = iapiConstant.Flag_Yes OR lsValue IS NOT NULL THEN
            iapiGeneral.LogInfo(
                gsSource,
                lsMethod,
                'SELECT COUNT(*) FROM param WHERE (' || FormatQuery(asRule) || ')',
                iapiConstant.INFOLEVEL_2
            );
            iapiGeneral.LogInfo(
                gsSource,
                lsMethod,
                'part_no=' || asPartNo || ',' ||
                'revision=' || anRevision || ',' ||
                'section=' || anSection || ',' ||
                'sub_section=' || anSubSection || ',' ||
                'property_group=' || anPropertyGroup || ',' ||
                'property=' || anProperty || ',' ||
                'attribute=' || anAttribute || ',' ||
                'header=' || anHeader || ',' ||
                'value=' || lsValue || ',' ||
                'raw_value=' || lsRawVal || ',' ||
                'arg1=' || asArg1 || ',' ||
                'arg2=' || asArg2,
                iapiConstant.INFOLEVEL_2
            );
                
            EXECUTE IMMEDIATE '
WITH param AS (
    SELECT
        :part_no AS part_no,
        :revision AS revision,
        :section AS section,
        :sub_section AS sub_section,
        :property_group AS property_group,
        :property AS property,
        :attribute AS attribute,
        :header AS header,
        :value AS value,
        :raw_value AS raw_value,
        :arg1 AS arg1,
        :arg2 AS arg2
    FROM dual
)
SELECT COUNT(*)
FROM param WHERE (' || FormatQuery(asRule) || ')'
            INTO lnCount
            USING
                asPartNo,
                anRevision,
                anSection,
                anSubSection,
                anPropertyGroup,
                anProperty,
                anAttribute,
                anHeader,
                lsValue,
                lsRawVal,
                asArg1,
                asArg2
            ;
            dbms_output.put_line('SELECT COUNT(*) FROM param WHERE (' || FormatQuery(asRule) || ')');
            dbms_output.put_line('>>' || lnCount);
        END IF;
        
        gnCalculating := 0;
        IF lnCount = 0 THEN
            RETURN iapiConstantDBError.DBERR_INVALIDVALIDATION;
        ELSE
            RETURN iapiconstantDBError.DBERR_SUCCESS;
        END IF;
    EXCEPTION
    WHEN OTHERS THEN
        gnCalculating := 0;
        RAISE;
    END CustomValidation;

    FUNCTION CustomCalculation(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        anHeader        IN iapiType.ID_Type,
        asMandatory     IN iapiType.Mandatory_Type,
        asRule          IN iapiType.StringVal_Type,
        asArg1          IN iapiType.StringVal_Type DEFAULT NULL,
        asArg2          IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod iapiType.Method_Type := 'CustomCalculation';
        lsValue  iapiType.String_Type;
        lsRawVal iapiType.String_Type;
        lsResult iapiType.String_Type;
        lnRetVal iapiType.ErrorNum_Type;
        lqInfo   iapiType.Ref_Type;
        lqErrors iapiType.Ref_Type;
    BEGIN
        lnRetVal := iapiConstantDBError.DBERR_SUCCESS;
        IF gnCalculating = 1 THEN
            RETURN lnRetVal;
        END IF;
        gnCalculating := 1;
        
        lsValue := aapiDataBinding.GetPropertyValue(
            asPartNo,
            anRevision,
            anSection,
            anSubSection,
            anPropertyGroup,
            anProperty,
            anAttribute,
            anHeader
        );
        
        lsRawVal := aapiDataBinding.GetPropertyValue(
            asPartNo,
            anRevision,
            anSection,
            anSubSection,
            anPropertyGroup,
            anProperty,
            anAttribute,
            anHeader,
            anRawValue => 1
        );
        
        BEGIN
            iapiGeneral.LogInfo(
                gsSource,
                lsMethod,
                'SELECT (' || FormatQuery(asRule) || ') FROM param',
                iapiConstant.INFOLEVEL_2
            );
            iapiGeneral.LogInfo(
                gsSource,
                lsMethod,
                'part_no=' || asPartNo || ',' ||
                'revision=' || anRevision || ',' ||
                'section=' || anSection || ',' ||
                'sub_section=' || anSubSection || ',' ||
                'property_group=' || anPropertyGroup || ',' ||
                'property=' || anProperty || ',' ||
                'attribute=' || anAttribute || ',' ||
                'header=' || anHeader || ',' ||
                'value=' || lsValue || ',' ||
                'raw_value=' || lsRawVal || ',' ||
                'arg1=' || asArg1 || ',' ||
                'arg2=' || asArg2,
                iapiConstant.INFOLEVEL_2
            );

            EXECUTE IMMEDIATE '
    WITH param AS (
        SELECT
            :part_no AS part_no,
            :revision AS revision,
            :section AS section,
            :sub_section AS sub_section,
            :property_group AS property_group,
            :property AS property,
            :attribute AS attribute,
            :header AS header,
            :value AS value,
            :raw_value AS raw_value,
            :arg1 AS arg1,
            :arg2 AS arg2
        FROM dual
    )
    SELECT (' || FormatQuery(asRule) || ') FROM param'
            INTO lsResult
            USING
                asPartNo,
                anRevision,
                anSection,
                anSubSection,
                anPropertyGroup,
                anProperty,
                anAttribute,
                anHeader,
                lsValue,
                lsRawVal,
                asArg1,
                asArg2
            ;
        EXCEPTION
        WHEN OTHERS THEN
            IF asMandatory = iapiConstant.Flag_Yes THEN
                RAISE;
            ELSE
                lsResult := NULL;
            END IF;
        END;
        dbms_output.put_line('SELECT (' || FormatQuery(asRule) || ') FROM param');
        dbms_output.put_line('>>' || lsResult);

        IF NVL(lsResult, ' ') <> NVL(lsValue, ' ') THEN
            lnRetVal := iapiSpecificationPropertyGroup.SaveAddProperty(
                asPartNo,
                anRevision,
                anSection,
                anSubSection,
                anPropertyGroup,
                anProperty,
                anAttribute,
                anHeader,
                lsResult,
                1,
                lqInfo,
                lqErrors
            );
            
            IF lnRetVal = iapiConstantDBError.DBERR_ERRORLIST THEN
                iapiGeneral.LogErrorList(
                    gsSource,
                    lsMethod,
                    lqErrors
                );
            END IF;
        END IF;
        
        gnCalculating := 0;
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        gnCalculating := 0;
        RAISE;
    END;

    PROCEDURE ClearRulesOnCopySpec
    AS
        lnRetVal iapiType.ErrorNum_Type;
    BEGIN
        lnRetVal := ClearRules(
            iapiSpecification.gtCopySpec(0).PartNo,
            iapiSpecification.gtCopySpec(0).NewRevision
        );
    END;

    PROCEDURE ClearRulesOnStatusChange
    AS
        lnRetVal iapiType.ErrorNum_Type;
    BEGIN
        lnRetVal := ClearRules(
            iapiSpecificationStatus.gtStatusChange(0).PartNo,
            iapiSpecificationStatus.gtStatusChange(0).Revision
        );
    END;
    
    FUNCTION ClearRules(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'ClearRules';
        lsErrorMsg iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type;
        lnResult   iapiType.ErrorMessageType_Type;
        lqInfo     iapiType.Ref_Type;
        lqErrors   iapiType.Ref_Type;
    BEGIN
      dbms_output.put_line('ClearRules - Start');
        lnResult := iapiConstantDBError.DBERR_SUCCESS;

        --DEBUG
        IF NOT REGEXP_LIKE(asPartNo, gsTestPattern) THEN
            RETURN lnResult;
        END IF;
    
        IF gnCalculating = 1 THEN
            RETURN lnResult;
        END IF;

        FOR lrRule IN gqRules LOOP
            IF lrRule.clear = iapiConstant.Flag_Yes
            AND MatchSpec(asPartNo, anRevision, lrRule.filter_id) = iapiConstantDBError.DBERR_SUCCESS THEN
                lnRetVal := iapiGeneral.SetErrorText(
                    iapiConstantDBError.DBERR_SUCCESS
                );

                gnCalculating := 1;
                BEGIN
                    lnRetVal := iapiSpecificationPropertyGroup.SaveAddProperty(
                        asPartNo,
                        anRevision,
                        lrRule.section_id,
                        lrRule.sub_section_id,
                        lrRule.property_group,
                        lrRule.property,
                        lrRule.attribute,
                        lrRule.header_id,
                        NULL,
                        1,
                        lqInfo,
                        lqErrors
                    );
                    IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                        IF lnRetVal = iapiConstantDBError.DBERR_ERRORLIST THEN
                            iapiGeneral.LogErrorList(
                                gsSource,
                                lsMethod,
                                lqErrors
                            );
                        ELSE
                            lnRetVal := iapiGeneral.SetErrorText(
                                iapiConstantDBError.DBERR_INVALIDACTION,
                                '[' || lrRule.rule_id || '] ' || lrRule.rule_desc
                            );
                        END IF;
                    END IF;
                EXCEPTION
                WHEN OTHERS THEN
                    lnRetVal := iapiGeneral.SetErrorText(
                        iapiConstantDBError.DBERR_APPLICATIONERROR,
                        SQLCODE,
                        SQLERRM
                    );
                END;
                gnCalculating := 0;

                IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                    lnResult := lnRetVal;
                    
                    lsErrorMsg := iapiGeneral.GetLastErrorText();
                    iapiGeneral.LogError(gsSource, lsMethod, lsErrorMsg);
                    
                    lnRetVal := iapiGeneral.SetErrorText(
                        iapiConstantDBError.DBERR_INVALIDPROP,
                        F_SCH_DESCR(1, lrRule.section_id, 0) || '/' ||
                        CASE WHEN lrRule.sub_section_id <> 0 THEN F_SBH_DESCR(1, lrRule.sub_section_id, 0) || '/' END ||
                        F_PGH_DESCR(1, lrRule.property_group, 0) || '/' ||
                        F_SPH_DESCR(1, lrRule.property, 0) ||
                        CASE WHEN lrRule.attribute <> 0 THEN '[' || F_ATH_DESCR(1, lrRule.attribute, 0) || ']' END
                    );
                
                    lnRetVal := iapiGeneral.AddErrorToList(
                        gsSource || '.' || lsMethod,
                        iapiGeneral.GetLastErrorText() || CHR(13) || CHR(10) || '- ' || lsErrorMsg,
                        iapiSpecificationPropertyGroup.gtErrors,
                        iapiConstant.ERRORMESSAGE_ERROR
                    );
                END IF;
            END IF;
        END LOOP;
      dbms_output.put_line('ClearRules - End');

        RETURN lnResult;
    END;

    PROCEDURE ValidateAccessOnSaveProp
    AS
        lnRetVal iapiType.ErrorNum_Type;
    BEGIN
        lnRetVal := ValidateRules(
            iapiSpecificationPropertyGroup.gtProperties(0).PartNo,
            iapiSpecificationPropertyGroup.gtProperties(0).Revision,
            gsCalculation
        );
    END;

    PROCEDURE ValidateRulesOnSaveProp
    AS
        lnRetVal iapiType.ErrorNum_Type;
    BEGIN
        lnRetVal := ValidateRules(
            iapiSpecificationPropertyGroup.gtProperties(0).PartNo,
            iapiSpecificationPropertyGroup.gtProperties(0).Revision,
            gsValidation
        );
    END;

    FUNCTION ValidateRules(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asRuleType IN iapiType.StringVal_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'ValidateRules';
        lsErrorMsg iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type;
        lnResult   iapiType.ErrorNum_Type;
        lsOldVal   iapiType.PropertyLongString_Type;
        lsNewVal   iapiType.PropertyLongString_Type;
    BEGIN
        lnResult := iapiConstantDBError.DBERR_SUCCESS;

        --DEBUG
        IF NOT REGEXP_LIKE(asPartNo, gsTestPattern) THEN
            RETURN lnResult;
        END IF;
    
        IF gnCalculating = 1 THEN
            RETURN lnResult;
        END IF;
        
        FOR lrRule IN gqRules LOOP
            IF MatchSpec(asPartNo, anRevision, lrRule.filter_id) = iapiConstantDBError.DBERR_SUCCESS THEN
                FOR lrRef IN gqRef(asPartNo, anRevision, lrRule.section_id, lrRule.sub_section_id, lrRule.property_group, lrRule.property, lrRule.attribute, lrRule.header_id) LOOP
                    lnRetVal := iapiGeneral.SetErrorText(
                        iapiConstantDBError.DBERR_SUCCESS
                    );
    
                    BEGIN
                        IF NVL(asRuleType, gsCalculation) = gsCalculation AND lrRule.rule_type = gsCalculation THEN
                            lsOldVal := aapiDataBinding.GetPropertyValue(
                                asPartNo,
                                anRevision,
                                lrRef.section_id,
                                lrRef.sub_section_id,
                                lrRef.property_group,
                                lrRef.property,
                                lrRef.attribute,
                                lrRef.header_id
                            );
                            
                            lsNewVal := aapiSpecificationPropertyGroup.GetPropertyValueByHeader(
                                iapiSpecificationPropertyGroup.gtProperties(0),
                                lrRef.header_id
                            );
                            iapiGeneral.LogInfo('aapiValidation', 'ValidateRules', 'Old: ' || lsOldVal || ', New: ' || lsNewVal, 1);
                            
                            IF  iapiSpecificationPropertyGroup.gtProperties(0).PartNo = asPartNo
                            AND iapiSpecificationPropertyGroup.gtProperties(0).Revision = anRevision
                            AND iapiSpecificationPropertyGroup.gtProperties(0).SectionId = lrRef.section_id
                            AND iapiSpecificationPropertyGroup.gtProperties(0).SubSectionId = lrRef.sub_section_id
                            AND iapiSpecificationPropertyGroup.gtProperties(0).PropertyGroupId = lrRef.property_group
                            AND iapiSpecificationPropertyGroup.gtProperties(0).PropertyId = lrRef.property
                            AND NVL(lsNewVal, ' ') != NVL(lsOldVal, ' ')
                            THEN
                                lnRetVal := iapiGeneral.SetErrorText(
                                    CASE WHEN gnCalculating = 0 THEN
                                        iapiConstantDBError.DBERR_NOTCORRECTACCESSRIGHT
                                    ELSE
                                        iapiConstantDBError.DBERR_SUCCESS
                                    END
                                );
                            END IF;
                        ELSIF NVL(asRuleType, gsValidation) <> gsCalculation AND lrRule.rule_type <> gsCalculation THEN
                            lnRetVal := CustomValidation(
                                asPartNo,
                                anRevision,
                                lrRef.section_id,
                                lrRef.sub_section_id,
                                lrRef.property_group,
                                lrRef.property,
                                lrRef.attribute,
                                lrRef.header_id,
                                lrRule.mandatory,
                                lrRule.rule,
                                lrRule.arg1,
                                lrRule.arg2
                            );
                            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                                lnRetVal := iapiGeneral.SetErrorText(
                                    iapiConstantDBError.DBERR_INVALIDVALIDATION,
                                    '[' || lrRule.rule_id || '] ' || lrRule.rule_desc
                                );
                            END IF;
                       END IF;
                    EXCEPTION
                    WHEN OTHERS THEN
                        lnRetVal := iapiGeneral.SetErrorText(
                            iapiConstantDBError.DBERR_APPLICATIONERROR,
                            SQLCODE,
                            SQLERRM
                        );
                    END;
                    
                    IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                        IF lrRule.rule_type IN (gsWarning, gsValidation) THEN
                            IF lnResult = iapiConstantDBError.DBERR_SUCCESS THEN
                                lnResult := lnRetVal;
                            END IF;
                        ELSE
                            lnResult := lnRetVal;
                        END IF;
    
                        lsErrorMsg := iapiGeneral.GetLastErrorText();
                        
                        lnRetVal := iapiGeneral.SetErrorText(
                            iapiConstantDBError.DBERR_INVALIDPROP,
                            F_SCH_DESCR(1, lrRef.section_id, 0) || '/' ||
                            CASE WHEN lrRef.sub_section_id <> 0 THEN F_SBH_DESCR(1, lrRef.sub_section_id, 0) || '/' END ||
                            F_PGH_DESCR(1, lrRef.property_group, 0) || '/' ||
                            F_SPH_DESCR(1, lrRef.property, 0) ||
                            CASE WHEN lrRef.attribute <> 0 THEN '[' || F_ATH_DESCR(1, lrRef.attribute, 0) || ']' END
                        );
                    
                        lnRetVal := iapiGeneral.AddErrorToList(
                            gsSource || '.' || lsMethod,
                            iapiGeneral.GetLastErrorText() || CHR(13) || CHR(10) || '- ' || lsErrorMsg,
                            iapiSpecificationPropertyGroup.gtErrors,
                            CASE WHEN lrRule.rule_type IN (gsWarning, gsValidation) THEN
                                iapiConstant.ERRORMESSAGE_WARNING
                            ELSE
                                iapiConstant.ERRORMESSAGE_ERROR
                            END
                        );
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        
        RETURN lnResult;
    END;
    
    FUNCTION ExecuteRules(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asRuleType IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'ExecuteRules';
        lsErrorMsg iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type;
        lnResult   iapiType.ErrorMessageType_Type;
    BEGIN
        lnResult := iapiConstantDBError.DBERR_SUCCESS;

        --DEBUG
        IF NOT REGEXP_LIKE(asPartNo, gsTestPattern) THEN
            RETURN lnResult;
        END IF;
    
        IF gnCalculating = 1 THEN
            RETURN lnResult;
        END IF;
        
        FOR lrRule IN gqRules(asRuleType) LOOP
            IF MatchSpec(asPartNo, anRevision, lrRule.filter_id) = iapiConstantDBError.DBERR_SUCCESS THEN
                FOR lrRef IN gqRef(asPartNo, anRevision, lrRule.section_id, lrRule.sub_section_id, lrRule.property_group, lrRule.property, lrRule.attribute, lrRule.header_id) LOOP
                    dbms_output.put_line(
                        'Executing ' || CASE WHEN lrRule.rule_type = gsCalculation THEN 'calculation' ELSE 'validation' END ||  ' for ' ||
                        f_sch_descr(NULL, lrRef.section_id, 0) || '/' ||
                        f_sbh_descr(NULL, lrRef.sub_section_id, 0) || '/' ||
                        f_pgh_descr(NULL, lrRef.property_group, 0) || '/' ||
                        f_sph_descr(NULL, lrRef.property, 0) || '/' ||
                        f_ath_descr(NULL, lrRef.attribute, 0) || '/' ||
                        f_hdh_descr(NULL, lrRef.header_id, 0)
                    );
                
                    lnRetVal := iapiGeneral.SetErrorText(
                        iapiConstantDBError.DBERR_SUCCESS
                    );
    
                    BEGIN
                        IF lrRule.rule_type = gsCalculation THEN
                            lnRetVal := CustomCalculation(
                                asPartNo,
                                anRevision,
                                lrRef.section_id,
                                lrRef.sub_section_id,
                                lrRef.property_group,
                                lrRef.property,
                                lrRef.attribute,
                                lrRef.header_id,
                                lrRule.mandatory,
                                lrRule.rule,
                                lrRule.arg1,
                                lrRule.arg2
                            );
                            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                                lnRetVal := iapiGeneral.SetErrorText(
                                    iapiConstantDBError.DBERR_INVALIDACTION,
                                    '[' || lrRule.rule_id || '] ' || lrRule.rule_desc
                                );
                            END IF;
                        ELSE
                            lnRetVal := CustomValidation(
                                asPartNo,
                                anRevision,
                                lrRef.section_id,
                                lrRef.sub_section_id,
                                lrRef.property_group,
                                lrRef.property,
                                lrRef.attribute,
                                lrRef.header_id,
                                lrRule.mandatory,
                                lrRule.rule,
                                lrRule.arg1,
                                lrRule.arg2
                            );
                            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                                lnRetVal := iapiGeneral.SetErrorText(
                                    iapiConstantDBError.DBERR_INVALIDVALIDATION,
                                    '[' || lrRule.rule_id || '] ' || lrRule.rule_desc
                                );
                            END IF;
                        END IF;
                    EXCEPTION
                    WHEN OTHERS THEN
                        lnRetVal := iapiGeneral.SetErrorText(
                            iapiConstantDBError.DBERR_APPLICATIONERROR,
                            SQLCODE,
                            SQLERRM
                        );
                    END;
                    
                    IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                        IF lrRule.rule_type = gsWarning THEN
                            IF lnResult = iapiConstantDBError.DBERR_SUCCESS THEN
                                lnResult := lnRetVal;
                            END IF;
                        ELSE
                            lnResult := lnRetVal;
                        END IF;
                        
                        lsErrorMsg := iapiGeneral.GetLastErrorText();
                        iapiGeneral.LogError(gsSource, lsMethod, lsErrorMsg);
                        
                        lnRetVal := iapiGeneral.SetErrorText(
                            iapiConstantDBError.DBERR_INVALIDPROP,
                            F_SCH_DESCR(1, lrRef.section_id, 0) || '/' ||
                            CASE WHEN lrRef.sub_section_id <> 0 THEN F_SBH_DESCR(1, lrRef.sub_section_id, 0) || '/' END ||
                            F_PGH_DESCR(1, lrRef.property_group, 0) || '/' ||
                            F_SPH_DESCR(1, lrRef.property, 0) ||
                            CASE WHEN lrRef.attribute <> 0 THEN '[' || F_ATH_DESCR(1, lrRef.attribute, 0) || ']' END
                        );
                    
                        lnRetVal := iapiGeneral.AddErrorToList(
                            gsSource || '.' || lsMethod,
                            iapiGeneral.GetLastErrorText() || CHR(13) || CHR(10) || '- ' || lsErrorMsg,
                            iapiSpecificationPropertyGroup.gtErrors,
                            CASE WHEN lrRule.rule_type = gsWarning THEN
                                iapiConstant.ERRORMESSAGE_WARNING
                            ELSE
                                iapiConstant.ERRORMESSAGE_ERROR
                            END
                        );
                    END IF;
                END LOOP;
            END IF;
        END LOOP;

        RETURN lnResult;
    END;
 
    FUNCTION Bind(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asPath     IN iapiType.StringVal_Type,
        asAlign    IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.StringVal_Type
    AS
        lsResult  iapiType.PropertyLongString_Type;
        lsFill    iapiType.String_Type;
        lsAlign   iapiType.String_Type;
        lsLength  iapiType.String_Type;
        lsPattern iapiType.String_Type := '^(.*?)([<^>])(\d+)$';
        lnLength  NUMBER;
    BEGIN
        lsResult := aapiDataBinding.PropertyBinding(
            asPartNo,
            anRevision,
            asPath
        );
        
        IF asAlign IS NOT NULL THEN
            lsFill   := REGEXP_REPLACE(asAlign, lsPattern, '\1');
            lsAlign  := REGEXP_REPLACE(asAlign, lsPattern, '\2');
            lsLength := REGEXP_REPLACE(asAlign, lsPattern, '\3');
            lnLength := TO_NUMBER(lsLength);

            IF lsFill IS NULL THEN
                lsFill := ' ';
            END IF;

            IF lsAlign = '<' THEN
                lsResult := RPAD(lsResult, lnLength, lsFill);
            ELSIF lsAlign = '>' THEN
                lsResult := LPAD(lsResult, lnLength, lsFill);
            ELSIF lsAlign = '^' THEN
                lnLength := lnLength - LENGTH(lsResult);
                lsResult := LPAD(lsFill, FLOOR(lnLength / 2), lsFill) || lsResult || RPAD(lsFill, CEIL(lnLength / 2), lsFill);
            END IF;
        END IF;
        
        RETURN lsResult;
    END;
    
    FUNCTION ColumnValue(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        asHeader        IN iapiType.Description_Type
    ) RETURN iapiType.StringVal_Type
    AS
        lnHeader iapiType.ID_Type;
    BEGIN
        SELECT header_id
        INTO lnHeader
        FROM header
        WHERE description LIKE NVL(asHeader, 'Value');
    
        RETURN aapiDataBinding.GetPropertyValue(
            asPartNo,
            anRevision,
            anSection,
            anSubSection,
            anPropertyGroup,
            anProperty,
            anAttribute,
            lnHeader
        );
    END;

    /*
    FUNCTION KeyFromValues(
        asVal1 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal2 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal3 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal4 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal5 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal6 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal7 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal8 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal9 IN iapiType.StringVal_Type DEFAULT gsUndefined
    ) RETURN iapiType.TokensTab_Type
    AS
        ltResult iapiType.TokensTab_Type;
    BEGIN
        IF NVL(asVal1, 'X') <> gsUndefined THEN ltResult(0) := asVal1; END IF;
        IF NVL(asVal2, 'X') <> gsUndefined THEN ltResult(1) := asVal2; END IF;
        IF NVL(asVal3, 'X') <> gsUndefined THEN ltResult(2) := asVal3; END IF;
        IF NVL(asVal4, 'X') <> gsUndefined THEN ltResult(3) := asVal4; END IF;
        IF NVL(asVal5, 'X') <> gsUndefined THEN ltResult(4) := asVal5; END IF;
        IF NVL(asVal6, 'X') <> gsUndefined THEN ltResult(5) := asVal6; END IF;
        IF NVL(asVal7, 'X') <> gsUndefined THEN ltResult(6) := asVal7; END IF;
        IF NVL(asVal8, 'X') <> gsUndefined THEN ltResult(7) := asVal8; END IF;
        IF NVL(asVal9, 'X') <> gsUndefined THEN ltResult(8) := asVal9; END IF;

        RETURN ltResult;
    END;

    FUNCTION KeyFromPaths(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asPath1 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath2 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath3 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath4 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath5 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath6 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath7 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath8 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath9 IN iapiType.StringVal_Type DEFAULT gsUndefined
    ) RETURN iapiType.TokensTab_type
    AS
        ltResult iapiType.TokensTab_Type;
    BEGIN
        IF NVL(asPath1, 'X') <> gsUndefined THEN ltResult(0) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath1); END IF;
        IF NVL(asPath2, 'X') <> gsUndefined THEN ltResult(1) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath2); END IF;
        IF NVL(asPath3, 'X') <> gsUndefined THEN ltResult(2) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath3); END IF;
        IF NVL(asPath4, 'X') <> gsUndefined THEN ltResult(3) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath4); END IF;
        IF NVL(asPath5, 'X') <> gsUndefined THEN ltResult(4) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath5); END IF;
        IF NVL(asPath6, 'X') <> gsUndefined THEN ltResult(5) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath6); END IF;
        IF NVL(asPath7, 'X') <> gsUndefined THEN ltResult(6) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath7); END IF;
        IF NVL(asPath8, 'X') <> gsUndefined THEN ltResult(7) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath8); END IF;
        IF NVL(asPath9, 'X') <> gsUndefined THEN ltResult(8) := aapiDataBinding.PropertyBinding(asPartNo, anRevision, asPath9); END IF;

        RETURN ltResult;
    END;

    FUNCTION Lookup(
        atKeyTab   IN iapiType.TokensTab_Type,
        asTable    IN iapiType.StringVal_Type,
        asValueCol IN iapiType.StringVal_Type
    ) RETURN iapiType.StringVal_Type
    AS
        ltKeyTab iapiType.TokensTab_Type;
        lsWhere  iapiType.SqlString_Type;
        lsColumn iapiType.String_Type;
        lnNumber NUMBER;
        lnIndex  PLS_INTEGER;
        lsResult iapiType.PropertyLongString_Type;
    BEGIN
        lsWhere := '';
        ltKeyTab := atKeyTab;
        FOR lnIndex IN 0 .. 8 LOOP
            IF ltKeyTab.EXISTS(lnIndex) THEN
                IF LENGTH(lsWhere) > 0 THEN
                    lsWhere := lsWhere || ' AND ';
                END IF;
                
                SELECT column_name
                INTO lsColumn
                FROM all_tab_cols
                WHERE UPPER(table_name) = UPPER(asTable)
                AND column_id = lnIndex + 1;
    
                lsWhere := lsWhere || lsColumn || ' = asKeyVal' || TO_CHAR(lnIndex + 1);
            ELSE
                ltKeyTab(lnIndex) := NULL;
            END IF;
        END LOOP;
        
        BEGIN
            lnNumber := TO_NUMBER(asValueCol);
            
            SELECT column_name
            INTO lsColumn
            FROM all_tab_cols
            WHERE upper(table_name) = UPPER(asTable)
            AND column_id = lnNumber;
        EXCEPTION
        WHEN VALUE_ERROR THEN
            lsColumn := asValueCol;
        END is_number;
        
        EXECUTE IMMEDIATE '
WITH params AS (
    SELECT
        :asKeyVal1 AS asKeyVal1,
        :asKeyVal2 AS asKeyVal2,
        :asKeyVal3 AS asKeyVal3,
        :asKeyVal4 AS asKeyVal4,
        :asKeyVal5 AS asKeyVal5,
        :asKeyVal6 AS asKeyVal6,
        :asKeyVal7 AS asKeyVal7,
        :asKeyVal8 AS asKeyVal8,
        :asKeyVal9 AS asKeyVal9
    FROM dual
)
SELECT ' || lsColumn || ' FROM ' || asTable || ', params
WHERE ' || lsWhere
        INTO lsResult
        USING
            ltKeyTab(0),
            ltKeyTab(1),
            ltKeyTab(2),
            ltKeyTab(3),
            ltKeyTab(4),
            ltKeyTab(5),
            ltKeyTab(6),
            ltKeyTab(7),
            ltKeyTab(8)
        ;
        
        RETURN lsResult;
    END;

    FUNCTION Lookup(
        atKeyVal IN iapiType.StringVal_Type,
        asTable  IN iapiType.StringVal_Type,
        asColumn IN iapiType.StringVal_Type
    ) RETURN iapiType.StringVal_Type
    AS
        ltKeyTab iapiType.TokensTab_Type;
    BEGIN
        ltKeyTab(0) := atKeyVal;
        RETURN Lookup(ltKeyTab, asTable, asColumn);
    END;
    */

    FUNCTION Lookup(
        asTable   IN iapiType.StringVal_Type,
        asColumn  IN iapiType.StringVal_Type,
        asKeyVal1 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal2 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal3 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal4 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal5 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal6 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal7 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal8 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal9 IN iapiType.StringVal_Type DEFAULT gsUndefined
    ) RETURN iapiType.StringVal_Type
    AS
        lsWhere  iapiType.SqlString_Type;
        lsColumn iapiType.String_Type;
        lnNumber iapiType.NumVal_Type;
        --lnIndex  PLS_INTEGER;
        lsResult iapiType.PropertyLongString_Type;
        
        PROCEDURE AppendKeyClause(
            anColumn IN iapiType.NumVal_Type
        ) AS
        BEGIN
            IF LENGTH(lsWhere) > 0 THEN
                lsWhere := lsWhere || ' AND ';
            END IF;
            
            SELECT column_name
            INTO lsColumn
            FROM all_tab_cols
            WHERE UPPER(table_name) = UPPER(asTable)
            AND column_id = anColumn;
            
            lsWhere := lsWhere || 'lt.' || lsColumn || '=key.val' || TO_CHAR(anColumn);
        END;
    BEGIN
        lsWhere := '';
        IF NVL(asKeyVal1, 'X') <> gsUndefined THEN AppendKeyClause(1); END IF;
        IF NVL(asKeyVal2, 'X') <> gsUndefined THEN AppendKeyClause(2); END IF;
        IF NVL(asKeyVal3, 'X') <> gsUndefined THEN AppendKeyClause(3); END IF;
        IF NVL(asKeyVal4, 'X') <> gsUndefined THEN AppendKeyClause(4); END IF;
        IF NVL(asKeyVal5, 'X') <> gsUndefined THEN AppendKeyClause(5); END IF;
        IF NVL(asKeyVal6, 'X') <> gsUndefined THEN AppendKeyClause(6); END IF;
        IF NVL(asKeyVal7, 'X') <> gsUndefined THEN AppendKeyClause(7); END IF;
        IF NVL(asKeyVal8, 'X') <> gsUndefined THEN AppendKeyClause(8); END IF;
        IF NVL(asKeyVal9, 'X') <> gsUndefined THEN AppendKeyClause(9); END IF;
        
        BEGIN
            lnNumber := TO_NUMBER(asColumn);
            
            SELECT column_name
            INTO lsColumn
            FROM all_tab_cols
            WHERE upper(table_name) = UPPER(asTable)
            AND column_id = lnNumber;
        EXCEPTION
        WHEN VALUE_ERROR THEN
            lsColumn := asColumn;
        END is_number;
        
        EXECUTE IMMEDIATE '
WITH key AS (
    SELECT
        :asKeyVal1 AS val1,
        :asKeyVal2 AS val2,
        :asKeyVal3 AS val3,
        :asKeyVal4 AS val4,
        :asKeyVal5 AS val5,
        :asKeyVal6 AS val6,
        :asKeyVal7 AS val7,
        :asKeyVal8 AS val8,
        :asKeyVal9 AS val9
    FROM dual
)
SELECT lt.' || lsColumn || ' FROM ' || asTable || ' lt, key
WHERE ' || lsWhere
        INTO lsResult
        USING
            asKeyVal1,
            asKeyVal2,
            asKeyVal3,
            asKeyVal4,
            asKeyVal5,
            asKeyVal6,
            asKeyVal7,
            asKeyVal8,
            asKeyVal9
        ;
        
        RETURN lsResult;
    END;
   
    FUNCTION MatchRegex(
        asValue   IN iapiType.StringVal_Type,
        asPattern IN iapiType.StringVal_Type,
        asFlags   IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        IF REGEXP_LIKE(asValue, asPattern, asFlags) THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;

    FUNCTION Required(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        IF asValue IS NOT NULL THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;
    
    FUNCTION Range(
        anValue IN iapiType.NumVal_Type,
        anMin   IN iapiType.NumVal_Type,
        anMax   IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        IF (anValue >= anMin OR anMin IS NULL) AND (anValue <= anMax OR anMax IS NULL) THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;
    
    FUNCTION LengthRange(
        asValue IN iapiType.StringVal_Type,
        anMin   IN iapiType.NumVal_Type,
        anMax   IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN Range(LENGTH(asValue), anMin, anMax);
    END;
    
    FUNCTION Limit(
        asOperator IN iapiType.StringVal_Type,
        anLimit    IN iapiType.NumVal_Type,
        anValue    IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        IF asOperator = '<' THEN
            RETURN CASE WHEN anValue < anLimit THEN 1 ELSE 0 END;
        ELSIF asOperator = '<=' THEN
            RETURN CASE WHEN anValue <= anLimit THEN 1 ELSE 0 END;
        ELSIF asOperator = '>' THEN
            RETURN CASE WHEN anValue > anLimit THEN 1 ELSE 0 END;
        ELSIF asOperator = '>=' THEN
            RETURN CASE WHEN anValue >= anLimit THEN 1 ELSE 0 END;
        ELSIF asOperator IS NULL THEN
            RETURN 1;
        END IF;
    END;

    FUNCTION IsEqual(
        asValue1 IN iapiType.StringVal_Type,
        asValue2 IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        IF asValue1 = asValue2 OR (asValue1 IS NULL AND asValue2 IS NULL) THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;

    FUNCTION IsAlpha(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[[:alpha:]]+$');
    END;
    
    FUNCTION IsAlphaNumeric(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[[:alnum:]]+$');
    END;

    FUNCTION IsBase64(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^([[:alnum:]+/]{4})*([[:alnum:]+/]{2}==|[[:alnum:]+/]{3}=)?$');
    END;
    
    FUNCTION IsDate(
        asValue  IN iapiType.StringVal_Type,
        asFormat IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.Boolean_Type
    AS
        ldDate DATE;
    BEGIN
        IF asFormat IS NULL THEN
            ldDate := TO_DATE(asValue);
        ELSE
            ldDate := TO_DATE(asValue, asFormat);
        END IF;
        RETURN 1;
    EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
    END;
    
    FUNCTION IsNumeric(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[[:digit:]]+$');
    END;
    
    FUNCTION IsDecimal(
        asValue  IN iapiType.StringVal_Type,
        asFormat IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.Boolean_Type
    AS
        lnNumber NUMBER;
    BEGIN
        IF asFormat IS NULL THEN
            lnNumber := TO_NUMBER(asValue);
        ELSE
            lnNumber := TO_NUMBER(asValue, asFormat);
        END IF;
        RETURN 1;
    EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
    END;
    
    FUNCTION IsMultiple(
        anValue    IN iapiType.NumVal_Type,
        anMultiple IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        IF MOD(anValue, anMultiple) = 0 THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;
    
    FUNCTION IsHexadecimal(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[[:xdigit:]]+$');
    END;
    
    FUNCTION IsEmail(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[^][@()<>{}:;\,.[:blank:][:cntrl:][:space:]]+(\.[^][@()<>{}:;\,.[:blank:][:cntrl:][:space:]]+)*@[^][@()<>{}:;\,.[:blank:][:cntrl:][:space:]]+(\.[^][@()<>{}:;\,.[:blank:][:cntrl:][:space:]]+)+$');
    END;
    
    FUNCTION IsUrl(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^([[:alnum:]+.-]+://)?[^[:blank:][:cntrl:][:space:]/$.?#]+\.[^[:blank:][:cntrl:][:space:]/$.?#][^[:blank:][:cntrl:][:space:]]*$');
    END;
    
    FUNCTION IsIpAddress(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    END;
    
    FUNCTION IsUppercase(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[[:upper:]]+$');
    END;
    
    FUNCTION IsLowercase(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[[:lower:]]+$');
    END;
    
    FUNCTION IsUuid(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN MatchRegex(asValue, '^[[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}|{[[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}}|\([[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}\)$');
    END;
    
    FUNCTION IsObject(
        asValue IN iapiType.StringVal_Type,
        asType  IN iapiType.StringVal_Type,
        anFuzzy IN iapiType.Boolean_Type DEFAULT 0,
        anExt   IN iapiType.Boolean_Type DEFAULT 0
    ) RETURN iapiType.Boolean_Type
    AS
        lsType   iapiType.String_Type;
        lsCompOp iapiType.String_Type;
        lsClause iapiType.SqlString_Type;
        lnCount  PLS_INTEGER;
    BEGIN
        lsType := LOWER(asType);
        
        IF anFuzzy = 1 THEN
            lsCompOp := ' LIKE ';
        ELSE
            lsCompOp := ' = ';
        END IF;
    
        IF lsType = 'frame_header' THEN
            lsClause := 'frame_no';
        ELSIF lsType = 'specification_header' THEN
            lsClause := 'part_no';
        ELSIF lsType = 'itprsource' THEN
            lsClause := 'source';
        ELSIF lsType = 'application_user' THEN
            lsClause := 'user_id';
        ELSIF lsType = 'user_group' THEN
            lsClause := 'short_desc';
        ELSIF lsType IN ('access_group', 'class3', 'status', 'workflow_group', 'ref_text_type') THEN
            lsClause := 'sort_desc';
        ELSE
            lsClause := 'description';
        END IF;
        lsClause := 'param.value' || lsCompOp || lsClause;
        
        IF anExt = 1 AND lsType IN ('access_group', 'class3', 'status', 'workflow_group', 'ref_text_type', 'user_group') THEN
            lsClause := lsClause || ' OR param.value' || lsCompOp || 'description';
        END IF;

        EXECUTE IMMEDIATE '
WITH param AS (
    SELECT :asValue AS value
    FROM dual
)
SELECT COUNT(*)
FROM param, ' || lsType || '
WHERE ' || lsClause
        INTO lnCount
        USING asValue;
        
        IF lnCount = 0 THEN
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;
    END;
    
    FUNCTION IsAccessGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Access_Group');
    END;
    
    FUNCTION IsAssociation(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Association');
    END;
    
    FUNCTION IsAttribute(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Attribute');
    END;

    FUNCTION IsCharacteristic(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Characteristic');
    END;
    
    FUNCTION IsSpecType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Class3');
    END;
    
    FUNCTION IsSpecTypeGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItStGrp');
    END;
    
    FUNCTION IsFormat(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Format');
    END;
    
    FUNCTION IsFunction(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Functions');
    END;
    
    FUNCTION IsFrame(
        asValue IN iapiType.StringVal_Type,
        anRev   IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Frame_Header');
    END;
    
    FUNCTION IsHeader(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Header');
    END;
    
    FUNCTION IsKeyword(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItKw');
    END;
    
    FUNCTION IsKeywordCharacteristic(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItKwCh');
    END;
    
    FUNCTION IsBomLayout(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItBomLy');
    END;
    
    FUNCTION IsCustomFunction(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItCf');
    END;
    
    FUNCTION IsOwner(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItDbProfile');
    END;
    
    FUNCTION IsTestMethodType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItTmType');
    END;
    
    FUNCTION IsUserCategory(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItUsCat');
    END;
    
    FUNCTION IsUserLocation(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItUsLoc');
    END;
    
    FUNCTION IsLayout(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Layout');
    END;
    
    FUNCTION IsLocation(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Location');
    END;
    
    FUNCTION IsManufacturer(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItMfc');
    END;
    
    FUNCTION IsManufacturerPlant(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItMpl');
    END;
    
    FUNCTION IsManufacturerType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItMtp');
    END;
    
    FUNCTION IsMessage(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItMessage');
    END;
    
    FUNCTION IsPart(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Part');
    END;
    
    FUNCTION IsPlant(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Plant');
    END;
    
    FUNCTION IsPlantGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItPlGrp');
    END;
    
    FUNCTION IsSource(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'ItPrSource');
    END;
    
    FUNCTION IsProperty(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Property');
    END;
    
    FUNCTION IsPropertyGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Property_Group');
    END;
    
    FUNCTION IsSection(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Section');
    END;
    
    FUNCTION IsSpecification(
        asValue IN iapiType.StringVal_Type,
        anRev   IN iapiType.NumVal_Type DEFAULT 0
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Specification_Header');
    END;
    
    FUNCTION IsStatus(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Status');
    END;
    
    FUNCTION IsStatusType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Status_Type');
    END;
    
    FUNCTION IsSubSection(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Sub_Section');
    END;
    
    FUNCTION IsTestMethod(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Test_Method');
    END;
    
    FUNCTION IsTextType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Text_Type');
    END;
    
    FUNCTION IsUom(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Uom');
    END;
    
    FUNCTION IsUomGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Uom_Group');
    END;
    
    FUNCTION IsUser(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Application_User');
    END;
    
    FUNCTION IsUserGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'User_Group');
    END;

    FUNCTION IsReferenceText(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Ref_Text_Type');
    END;
    
    FUNCTION IsWorkflow(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Work_Flow_Group');
    END;
    
    FUNCTION IsWorkflowGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type
    AS
    BEGIN
        RETURN IsObject(asValue, 'Workflow_Group');
    END;

END AAPIVALIDATION; 