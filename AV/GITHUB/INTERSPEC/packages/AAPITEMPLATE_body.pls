create or replace PACKAGE BODY AAPITEMPLATE AS

    psSource CONSTANT iapiType.Source_Type := 'aapiTemplate';

    FUNCTION peek(
        abStream IN CLOB,
        anIndex  IN PLS_INTEGER,
        anAmount IN PLS_INTEGER DEFAULT 1
    ) RETURN VARCHAR2 AS
    BEGIN
        RETURN dbms_lob.SubStr(abStream, anAmount, anIndex);
    END;

    PROCEDURE advance(
        anIndex  IN OUT PLS_INTEGER,
        anAmount IN PLS_INTEGER DEFAULT 1
    ) AS
    BEGIN
        anIndex := anIndex + anAmount;
    END;

    FUNCTION next(
        abStream IN CLOB,
        anIndex  IN OUT PLS_INTEGER,
        anAmount IN PLS_INTEGER DEFAULT 1
    ) RETURN VARCHAR2 AS
        lsResult VARCHAR2(32 CHAR);
    BEGIN
        lsResult := peek(abStream, anIndex, anAmount);
        advance(anIndex, anAmount);
        RETURN lsResult;
    END;
    
    PROCEDURE append(
        abStream IN OUT NOCOPY CLOB,
        asString IN VARCHAR2
    ) AS
    BEGIN
        IF asString IS NOT NULL THEN
            dbms_lob.WriteAppend(abStream, LENGTH(asString), asString);
        END IF;
    END;
    
    PROCEDURE clear(
        abStream IN OUT NOCOPY CLOB
    ) AS
    BEGIN
        dbms_lob.trim(abStream, 0);
    END;

    PROCEDURE flush(
        abStream IN OUT NOCOPY CLOB,
        abBuffer IN OUT NOCOPY CLOB
    ) AS
    BEGIN
        IF NULLIF(LENGTH(abBuffer), 0) IS NOT NULL THEN
            dbms_lob.Append(abStream, abBuffer);
            clear(abBuffer);
        END IF;
    END;

    PROCEDURE FindProperty(
        asPartNo   IN  iapiType.PartNo_Type,
        anRevision IN  iapiType.Revision_Type,
        asPath     IN  VARCHAR2,
        asValues   OUT iapiType.TokensTab_type
    ) AS
    BEGIN
        WITH data AS (
            SELECT
                part_no,
                revision,
                XmlElement(
                    "spec",
                    XmlElement(
                        "header",
                        XmlForest(
                            part_no AS "part_no",
                            revision AS "rev"
                        )
                    ),
                    XmlAgg(node)
                ) AS node
            FROM (
                SELECT
                    part_no,
                    revision,
                    XmlElement(
                        "section",
                        XmlAttributes(
                            CASE WHEN section_id = 0 THEN NULL
                            ELSE section.description END AS "name"
                        ),
                        XmlAgg(node)
                    ) AS node
                FROM (
                    SELECT
                        part_no,
                        revision,
                        section_id,
                        XmlElement(
                            "subsection",
                            XmlAttributes(
                                CASE WHEN sub_section_id = 0 THEN NULL
                                ELSE sub_section.description END AS "name"
                            ),
                            XmlAgg(node)
                        ) AS node
                    FROM (
                        SELECT
                            part_no,
                            revision,
                            section_id,
                            sub_section_id,
                            XmlElement(
                                "prop_group",
                                XmlAttributes(
                                    CASE WHEN property_group = 0 THEN NULL
                                    ELSE property_group.description END AS "name"
                                ),
                                XmlAgg(node)
                            ) AS node
                        FROM (
                            SELECT
                                part_no,
                                revision,
                                section_id,
                                sub_section_id,
                                property_group,
                                XmlElement(
                                    "property",
                                    XmlAttributes(
                                        property.description AS "name",
                                        CASE WHEN attribute = 0 THEN NULL
                                        ELSE attribute.description END AS "attribute"
                                    ),
                                    XmlAgg(node)
                                ) AS node
                            FROM (
                                SELECT
                                    part_no,
                                    revision,
                                    section_id,
                                    sub_section_id,
                                    property_group,
                                    property,
                                    attribute,
                                    XmlElement(
                                        "value",
                                        XmlAttributes(header.description AS "header"),
                                        value_s
                                    ) AS node
                                FROM specdata
                                LEFT JOIN header USING (header_id)
                            )
                            LEFT JOIN
                                attribute USING (attribute)
                            LEFT JOIN
                                property USING (property)
                            GROUP BY
                                part_no,
                                revision,
                                section_id,
                                sub_section_id,
                                property_group,
                                property.description,
                                attribute,
                                attribute.description
                        )
                        LEFT JOIN
                            property_group USING (property_group)
                        GROUP BY
                            part_no,
                            revision,
                            section_id,
                            sub_section_id,
                            property_group,
                            property_group.description
                    )
                    LEFT JOIN
                        sub_section USING (sub_section_id)
                    GROUP BY
                        part_no,
                        revision,
                        section_id,
                        sub_section_id,
                        sub_section.description
                )
                LEFT JOIN
                    section USING (section_id)
                GROUP BY
                    part_no,
                    revision,
                    section_id,
                    section.description
            )
            WHERE
                part_no = asPartNo
                AND revision = anRevision
            GROUP BY
                part_no,
                revision
        )
        SELECT
            EXTRACT(VALUE(prop_list), '//text()').GetStringVal()
        BULK COLLECT INTO
            asValues
        FROM data, TABLE(
            XmlSequence(
                EXTRACT(
                    data.node,
                    asPath
                )
            )
        ) prop_list;
        
        --DEBUG
        /*
        WITH data AS (
            SELECT XmlElement("DUMMY") AS node
            FROM dual
        )
        SELECT
            EXTRACT(VALUE(prop_list), '//text()').GetStringVal()
        BULK COLLECT INTO
            asValues
        FROM data, TABLE(
            XmlSequence(
                EXTRACT(
                    data.node,
                    asPath
                )
            )
        ) prop_list;
        */
    END;

    /* WARNING: Leaks cursors! TODO: Fix */
    PROCEDURE FindBomItem(
        asPartNo      IN  iapiType.PartNo_Type,
        anRevision    IN  iapiType.Revision_Type,
        asPlant       IN  VARCHAR2,
        anAlternative IN  NUMBER,
        asPath        IN  VARCHAR2,
        asChildParts  OUT iapiType.PartNoTab_Type,
        anChildRevs   OUT iapiType.RevisionTab_Type
    ) AS
    BEGIN
        WITH data AS (
            SELECT
                XmlElement(
                    "spec",
                    XmlAttributes(
                        sh.part_no AS "part_no",
                        sh.revision AS "rev",
                        sh.frame_id AS "frame_no",
                        sh.frame_rev AS "frame_rev",
                        kw.kw_value AS "func"
                    ),
                    dbms_xmlgen.GetXmlType(
                        dbms_xmlgen.NewContextFromHierarchy('
                            SELECT
                                LEVEL,
                                XmlElement(
                                    "spec",
                                    XmlAttributes(
                                        sh.part_no AS "part_no",
                                        sh.revision AS "rev",
                                        sh.frame_id AS "frame_no",
                                        sh.frame_rev AS "frame_rev",
                                        kw.kw_value AS "func"
                                    )
                                ) AS node
                            FROM
                                bom_header bh
                            INNER JOIN
                                bom_item bi
                                ON  bi.part_no     = bh.part_no
                                AND bi.revision    = bh.revision
                                AND bi.plant       = bh.plant
                                AND bi.alternative = bh.alternative
                            INNER JOIN
                                specification_header sh
                                ON  sh.part_no = bi.component_part
                                AND SYSDATE BETWEEN sh.issued_date AND NVL(sh.obsolescence_date, SYSDATE)
                            LEFT JOIN
                                (
                                    SELECT part_no, kw_value
                                    FROM specification_kw
                                    WHERE kw_id = (SELECT kw_id FROM itkw WHERE description = ''Function'')
                                ) kw
                                ON kw.part_no = sh.part_no
                            WHERE
                                bh.plant = '''||asPlant||'''
                            START WITH
                                bh.alternative  = '||anAlternative||'
                                AND bh.part_no  = '''||asPartNo||'''
                                AND bh.revision = '||anRevision||'
                            CONNECT BY
                                bh.part_no  = PRIOR sh.part_no
                                AND bh.revision = PRIOR sh.revision
                                AND bh.preferred = 1
                            ORDER SIBLINGS BY
                                bi.item_number
                            '
                        )
                    )
                ) AS node
            FROM
                specification_header sh
            LEFT JOIN
                (
                    SELECT part_no, kw_value
                    FROM specification_kw
                    WHERE kw_id = (SELECT kw_id FROM itkw WHERE description = 'Function')
                ) kw
                ON kw.part_no = sh.part_no
            WHERE
                sh.part_no = asPartNo
                AND sh.revision = anRevision
        )
        SELECT
            EXTRACTVALUE(VALUE(spec_list), 'spec/@part_no'),
            EXTRACTVALUE(VALUE(spec_list), 'spec/@rev')
        BULK COLLECT INTO
            asChildParts,
            anChildRevs
        FROM data, TABLE(
            XmlSequence(
                EXTRACT(
                    data.node,
                    asPath
                )
            )
        ) spec_list;
    END;

    FUNCTION Parse(
        abTemplate IN  CLOB,
        abOutput   OUT CLOB,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod     iapiType.Method_Type := 'Parse';
        lsErrMsg     iapiType.ErrorText_Type;
        lbBuffer     CLOB;
        --lbResult     CLOB;
        lnState      PLS_INTEGER;
        lnIndex      PLS_INTEGER;
        lsFormat     VARCHAR2(4000 CHAR);
        lsBomPath    VARCHAR2(4000 CHAR);
        lsParamPath  VARCHAR2(4000 CHAR);
        lsEvalText   VARCHAR2(4000 CHAR);
        lsToken      VARCHAR2(32 CHAR);
        lsChildParts iapiType.PartNoTab_Type;
        lnChildRevs  iapiType.RevisionTab_Type;
        lsValues     iapiType.TokensTab_Type;
        
        STATE_TEXT   CONSTANT PLS_INTEGER := 1;
        STATE_FORMAT CONSTANT PLS_INTEGER := 2;
        STATE_BOM    CONSTANT PLS_INTEGER := 3;
        STATE_PARAM  CONSTANT PLS_INTEGER := 4;
                
        PROCEDURE parseEscape(
            abStream IN CLOB,
            anIndex  IN OUT PLS_INTEGER,
            abOutput IN OUT NOCOPY CLOB
        ) AS
            lsToken VARCHAR2(32 CHAR);
        BEGIN
            lsToken := next(abStream, anIndex);
            IF LOWER(lsToken) = 'x' THEN
                lsToken := peek(abStream, anIndex, 2);
                BEGIN
                    lsToken := CHR(TO_NUMBER(lsToken, 'xx'));
                    advance(anIndex, 2);
                EXCEPTION WHEN OTHERS THEN
                    lsToken := '';
                END;
            ELSIF lsToken IN (CHR(10), CHR(13)) THEN
                IF lsToken = CHR(13) THEN
                    lsToken := peek(abStream, anIndex);
                    IF lsToken = CHR(10) THEN
                        advance(anIndex);
                    END IF;
                END IF;
                lsToken := NULL;
            ELSE
                IF REGEXP_LIKE(lsToken, '[0bnrt\\]', 'i') THEN
                    lsToken := TRANSLATE(
                        lsToken,
                        '0BbNnRrTt',
                        CHR(0) || CHR(8) || CHR(8) || CHR(10) || CHR(10) || CHR(13) || CHR(13) || CHR(9) || CHR(9)
                    );
                ELSE
                    lsToken := NULL;
                END IF;
            END IF;
            --IF lsToken IS NULL THEN --Invalid
            append(abOutput, lsToken);
        END;
        
        FUNCTION parseArgs(
            asArguments VARCHAR2
        ) RETURN VARCHAR2
        AS
        BEGIN
            RETURN REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REPLACE(asArguments, '''', '''''') || ';',
                    '(([^\;]|\\\\|\\;)*);',
                    '''\1'', '
                ),
                ', $',
                ''
            );
        END;
        
        FUNCTION evalQuery(
            asQuery   VARCHAR2
        ) RETURN VARCHAR2
        AS
            lsResult VARCHAR2(4000 CHAR);
        BEGIN
            EXECUTE IMMEDIATE asQuery
            INTO lsResult;
            
            RETURN lsResult;
        EXCEPTION WHEN OTHERS THEN
            RETURN '<%!' || SQLERRM || '%>';
        END;
        
        FUNCTION evalFunction(
            asFunction VARCHAR2
        ) RETURN VARCHAR2
        AS
        BEGIN
            IF asFunction IS NOT NULL THEN
                RETURN evalQuery('SELECT ' || asFunction || ' FROM dual');
            ELSE
                RETURN '<%=%>';
            END IF;
        END;
        
        FUNCTION evalBind(
            asArguments VARCHAR2
        ) RETURN VARCHAR2
        AS
        BEGIN
            RETURN evalFunction(
                'aapiTemplate.Bind(' ||
                    '''' || asPartNo || ''',' ||
                    anRevision || ',' ||
                    parseArgs(asArguments) ||
                ')'
            );
        END;
        
        FUNCTION evalReplace(
            asArguments VARCHAR2
        ) RETURN VARCHAR2
        AS
        BEGIN
            RETURN evalFunction(
                'REPLACE(' || parseArgs(asArguments) || ')'
            );
        END;
        
        PROCEDURE parseInline(
            abStream IN CLOB,
            anIndex  IN OUT PLS_INTEGER,
            abOutput IN OUT NOCOPY CLOB
        ) AS
            lnSuccess NUMBER;
            lsType    VARCHAR2(  32 CHAR);
            lsToken   VARCHAR2(  32 CHAR);
            lbBuffer  CLOB;
        BEGIN
            lsType := next(abStream, anIndex);
            IF lsType = '>' THEN
                append(abOutput, '<%>');
                RETURN;
            END IF;

            IF lsType = '-' AND peek(abStream, anIndex) = '-' THEN
                lsType := '--';
                advance(anIndex);
            END IF;
            
            dbms_lob.CreateTemporary(lbBuffer, TRUE);
            WHILE anIndex <= LENGTH(abStream)
            LOOP
                lsToken := next(abStream, anIndex);
                IF lsToken = '\' THEN
                    parseEscape(
                        abStream,
                        anIndex,
                        lbBuffer
                    );
                ELSIF lsToken = '<' AND peek(abStream, anIndex) = '%' THEN
                    advance(anIndex);
                    parseInline(
                        abStream,
                        anIndex,
                        lbBuffer
                    );
                ELSIF lsToken = '%' THEN
                    lsToken := next(abStream, anIndex);
                    IF lsToken = '>' THEN
                        lnSuccess := 1;
                        IF lsType = '=' THEN
                            append(abOutput, evalFunction(lbBuffer));
                        ELSIF lsType = '@' THEN
                            append(abOutput, evalQuery(lbBuffer));
                        ELSIF lsType = '#' THEN
                            append(abOutput, evalBind(lbBuffer));
                        ELSIF lsType = '$' THEN
                            NULL; --EXECUTE PLSQL
                        ELSIF lsType = '--' THEN
                            NULL; --Ignore: comment
                        ELSIF lsType = ':' THEN
                            append(abOutput, evalReplace(lbBuffer));
                        ELSE
                            lnSuccess := 0;
                            NULL;
                            --NO FUNCTON?
                        END IF;
                        IF lnSuccess = 1 THEN
                            clear(lbBuffer);
                        END IF;
                        EXIT;
                    ELSE
                        append(lbBuffer, lsToken);
                    END IF;
                ELSE
                    append(lbBuffer, lsToken);
                END IF;
            END LOOP;

            IF LENGTH(lbBuffer) > 0 THEN
                append(abOutput, '<%' || lsType);
                append(abOutput, lbBuffer);
                append(abOutput, '%>');
            END IF;
            dbms_lob.FreeTemporary(lbBuffer);
        END;
    BEGIN
        dbms_lob.CreateTemporary(lbBuffer, TRUE);
        dbms_lob.CreateTemporary(abOutput, TRUE);

        lnIndex := 1;
        lnState := STATE_TEXT;
        WHILE lnIndex <= LENGTH(abTemplate)
        LOOP
            lsToken := next(abTemplate, lnIndex);
            
            IF lsToken = '\' THEN
                parseEscape(
                    abTemplate,
                    lnIndex,
                    lbBuffer
                );
            ELSIF lsToken = '<' AND peek(abTemplate, lnIndex) = '%' THEN
                advance(lnIndex);
                parseInline(
                    abTemplate,
                    lnIndex,
                    lbBuffer
                );
            ELSE
                append(lbBuffer, lsToken);
            END IF;
        END LOOP;
        flush(abOutput, lbBuffer);
    
        dbms_lob.FreeTemporary(lbBuffer);
        
        RETURN iapiConstantDbError.DBERR_SUCCESS;
    EXCEPTION WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;

    FUNCTION Bind(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asProperty IN VARCHAR2,
        asFormat   IN VARCHAR2 DEFAULT NULL,
        asBomItem  IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2
    AS
        lnRevision   iapiType.Revision_Type;
        lbResult     VARCHAR2(4000 CHAR); --CLOB;
        lsChildParts iapiType.PartNoTab_Type;
        lnChildRevs  iapiType.RevisionTab_Type;
        lsValues     iapiType.TokensTab_Type;
    BEGIN
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
        IF asBomItem IS NULL THEN
            SELECT
                asPartNo,
                lnRevision
            BULK COLLECT INTO
                lsChildParts,
                lnChildRevs
            FROM dual;
        ELSE
            FindBomItem(
                asPartNo,
                lnRevision,
                'ENS',
                1,
                asBomItem,
                lsChildParts,
                lnChildRevs
            );
        END IF;

        FOR i IN 1 .. lsChildParts.COUNT
        LOOP
            FindProperty(
                lsChildParts(i),
                lnChildRevs(i),
                asProperty,
                lsValues
            );

            FOR j IN 1 .. lsValues.COUNT
            LOOP
                IF lsValues(j) IS NOT NULL THEN
                    IF asFormat IS NULL THEN
                        lbResult := lbResult || lsValues(j);
                    ELSE
                        lbResult := lbResult || REGEXP_REPLACE(asFormat, '<%>', lsValues(j), 1, 0, 'i');
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
        
        RETURN lbResult;
    END;

END AAPITEMPLATE;