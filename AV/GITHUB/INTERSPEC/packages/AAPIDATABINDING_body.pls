create or replace PACKAGE BODY AAPIDATABINDING AS

    FUNCTION GetPropertyValue(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        anHeader        IN iapiType.ID_Type,
        anRawValue      IN iapiType.Boolean_Type DEFAULT 0
    ) RETURN iapiType.StringVal_Type
    AS
        lnField   iapiType.ID_Type;
        lnRetVal  iapiType.ErrorNum_Type;
        lsResult  iapiType.String_Type;
        lsDateFmt iapiType.String_Type := 'dd-mm-yyyy hh24:mi:ss';
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('anSection', anSection);
        aapiTrace.Param('anSubSection', anSubSection);
        aapiTrace.Param('anPropertyGroup', anPropertyGroup);
        aapiTrace.Param('anProperty', anProperty);
        aapiTrace.Param('anAttribute', anAttribute);
        aapiTrace.Param('anHeader', anHeader);
        aapiTrace.Param('anRawValue', anRawValue);

        SELECT field_id
        INTO lnField
        FROM property_layout
        WHERE header_id = anHeader
        AND (layout_id, revision) = (
            SELECT display_format, display_format_rev
            FROM specification_section
            WHERE part_no = asPartNo
            AND revision = anRevision
            AND section_id = anSection
            AND sub_section_id = anSubSection
            AND (
                (type = iapiConstant.SECTIONTYPE_PROPERTYGROUP AND ref_id = anPropertyGroup)
                OR (type = iapiConstant.SECTIONTYPE_SINGLEPROPERTY AND ref_id = anProperty)
            )
        );
        
        SELECT DECODE(
            lnField,
            1, TO_CHAR(num_1),
            2, TO_CHAR(num_2),
            3, TO_CHAR(num_3),
            4, TO_CHAR(num_4),
            5, TO_CHAR(num_5),
            6, TO_CHAR(num_6),
            7, TO_CHAR(num_7),
            8, TO_CHAR(num_8),
            9, TO_CHAR(num_9),
            10, TO_CHAR(num_10),
            11, char_1,
            12, char_2,
            13, char_3,
            14, char_4,
            15, char_5,
            16, char_6,
            17, boolean_1,
            18, boolean_2,
            19, boolean_3,
            20, boolean_4,
            21, TO_CHAR(date_1, lsDateFmt),
            22, TO_CHAR(date_2, lsDateFmt),
            23, CASE WHEN anRawValue = 1 THEN TO_CHAR(uom_id) ELSE F_UMH_DESCR(1, uom_id, uom_rev) END,
            24, CASE WHEN anRawValue = 1 THEN TO_CHAR(anAttribute) ELSE F_ATH_DESCR(1, anAttribute, attribute_rev) END,
            25, CASE WHEN anRawValue = 1 THEN TO_CHAR(test_method) ELSE F_TMH_DESCR(1, test_method, test_method_rev) END,
            26, CASE WHEN anRawValue = 1 THEN TO_CHAR(characteristic) ELSE F_CHH_DESCR(1, characteristic, characteristic_rev) END,
            27, CASE WHEN anRawValue = 1 THEN TO_CHAR(anProperty) ELSE F_SPH_DESCR(1, anProperty, property_rev) END
        )
        INTO lsResult
        FROM specification_prop
        WHERE part_no = asPartNo
        AND revision = anRevision
        AND section_id = anSection
        AND sub_section_id = anSubSection
        and property_group = anPropertyGroup
        and property = anProperty
        and attribute = anAttribute;
        
        aapiTrace.Exit(lsResult);
        RETURN lsResult;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        lnRetVal := iapiGeneral.SetErrorText(
            iapiConstantDBError.DBERR_SPPROPERTYNOTFOUND,
            asPartNo,
            anRevision,
            anSection,
            anSubSection,
            anPropertyGroup,
            anProperty,
            anAttribute
        );
        aapiTrace.Error(iapiGeneral.GetLastErrorText());
        aapiTrace.Exit();
        RAISE_APPLICATION_ERROR(-20000, iapiGeneral.GetLastErrorText());
    END;

    FUNCTION PropertyBinding(
        asPartNo   IN  iapiType.PartNo_Type,
        anRevision IN  iapiType.Revision_Type,
        asPath     IN  iapiType.StringVal_Type,
        anRawValue IN iapiType.Boolean_Type DEFAULT 0
    ) RETURN iapiType.StringVal_Type AS
        ltSepPos        iapiType.NumberTab_Type;
        lnIndex         iapiType.NumVal_Type;
        
        lsSection       iapiType.Description_Type := NULL;
        lsSubSection    iapiType.Description_Type := NULL;
        lsPropertyGroup iapiType.Description_Type := NULL;
        lsProperty      iapiType.Description_Type := NULL;
        lsAttribute     iapiType.Description_Type := NULL;
        lsHeader        iapiType.Description_Type := NULL;
        
        lnSection       iapiType.ID_Type;
        lnSubSection    iapiType.ID_Type;
        lnPropertyGroup iapiType.ID_Type;
        lnProperty      iapiType.ID_Type;
        lnAttribute     iapiType.ID_Type;
        lnHeader        iapiType.ID_Type;
        lnField         iapiType.ID_Type;
        
        lsIdFormat      iapiType.String_Type := '999999';
        lnRetVal        iapiType.ErrorNum_Type;
        lsResult        iapiType.PropertyLongString_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('asPath', asPath);
        aapiTrace.Param('anRawValue', anRawValue);

        FOR lnIndex IN 1 .. 6 LOOP
            ltSepPos(lnIndex) := INSTR(asPath, '/', 1, lnIndex);
            IF ltSepPos(lnIndex) = 0 THEN
                ltSepPos(lnIndex) := LENGTH(asPath) + 1;
            END IF;
        END LOOP;
        
        lsSection       := SUBSTR(asPath, 1, ltSepPos(1) - 1);
        lsSubSection    := SUBSTR(asPath, ltSepPos(1) + 1, ltSepPos(2) - ltSepPos(1) - 1);
        lsPropertyGroup := SUBSTR(asPath, ltSepPos(2) + 1, ltSepPos(3) - ltSepPos(2) - 1);
        lsProperty      := SUBSTR(asPath, ltSepPos(3) + 1, ltSepPos(4) - ltSepPos(3) - 1);
        lsAttribute     := SUBSTR(asPath, ltSepPos(4) + 1, ltSepPos(5) - ltSepPos(4) - 1);
        lsHeader        := SUBSTR(asPath, ltSepPos(5) + 1);
        
        BEGIN
            lnSection := TO_NUMBER(NVL(lsSection, 'X'), lsIdFormat);
        EXCEPTION
        WHEN VALUE_ERROR THEN
            SELECT section_id
            INTO lnSection
            FROM section
            WHERE description LIKE NVL(lsSection, '(none)');
        END;

        BEGIN
            lnSubSection := TO_NUMBER(NVL(lsSubSection, 'X'), lsIdFormat);
        EXCEPTION
        WHEN VALUE_ERROR THEN
            SELECT sub_section_id
            INTO lnSubSection
            FROM sub_section
            WHERE description LIKE NVL(lsSubSection, '(none)');
        END;

        BEGIN
            lnPropertyGroup := TO_NUMBER(NVL(lsPropertyGroup, 'X'), lsIdFormat);
        EXCEPTION
        WHEN VALUE_ERROR THEN
            SELECT property_group
            INTO lnPropertyGroup
            FROM property_group
            WHERE description LIKE NVL(lsPropertyGroup, 'default property group');
        END;
        
        BEGIN
            lnProperty := TO_NUMBER(NVL(lsProperty, 'X'), lsIdFormat);
        EXCEPTION
        WHEN VALUE_ERROR THEN
            SELECT property
            INTO lnProperty
            FROM property
            WHERE description LIKE lsProperty;
        END;

        BEGIN
            lnAttribute := TO_NUMBER(NVL(lsAttribute, 'X'), lsIdFormat);
        EXCEPTION
        WHEN VALUE_ERROR THEN
            SELECT attribute
            INTO lnAttribute
            FROM attribute
            WHERE description LIKE NVL(lsAttribute, ' ');
        END;
        
        BEGIN
            lnHeader := TO_NUMBER(NVL(lsHeader, 'X'), lsIdFormat);
        EXCEPTION
        WHEN VALUE_ERROR THEN
            SELECT header_id
            INTO lnHeader
            FROM header
            WHERE description LIKE NVL(lsHeader, 'Value');
        END;
        
        aapiTrace.Exit('[...]');
        RETURN GetPropertyValue(
            asPartNo,
            anRevision,
            lnSection,
            lnSubSection,
            lnPropertyGroup,
            lnProperty,
            lnAttribute,
            lnHeader
        );
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        lnRetVal := iapiGeneral.SetErrorText(
            iapiConstantDBError.DBERR_SPPROPERTYNOTFOUND,
            asPartNo,
            anRevision,
            lsSection,
            lsSubSection,
            lsPropertyGroup,            
            lsProperty,
            lsAttribute
        );
        aapiTrace.Error(iapiGeneral.GetLastErrorText());
        aapiTrace.Exit();
        RAISE_APPLICATION_ERROR(-20000, iapiGeneral.GetLastErrorText());
    END PropertyBinding;

END AAPIDATABINDING;