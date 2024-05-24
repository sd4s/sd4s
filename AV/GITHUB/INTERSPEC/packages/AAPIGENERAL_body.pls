create or replace PACKAGE BODY            "AAPIGENERAL" AS

    FUNCTION EscapeFilename(
        asValue IN VARCHAR2
    ) RETURN VARCHAR2
    IS
        lsValue VARCHAR2(4000 CHAR);
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asValue', asValue);

        aapiTrace.Exit(TRANSLATE(asValue, '\/:*?"<>|', '_________'));
        RETURN TRANSLATE(asValue, '\/:*?"<>|', '_________');
    END;


    FUNCTION EscapeCsv(
        asValue IN VARCHAR2
    ) RETURN VARCHAR2
    IS
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asValue', asValue);

        IF asValue IS NULL THEN
            aapiTrace.Exit();
            RETURN '';
        ELSIF INSTR(asValue, ',') > 0 OR INSTR(asValue, '"') > 0
        OR INSTR(asValue, CHR(10)) > 0 OR INSTR(asValue, CHR(13)) > 0
        OR SUBSTR(asValue, 1, 1) = ' ' OR SUBSTR(asValue, -1, 1) = ' ' THEN
            aapiTrace.Exit('"' || REPLACE(asValue, '"', '""') || '"');
            RETURN '"' || REPLACE(asValue, '"', '""') || '"';
        ELSE
            aapiTrace.Exit(asValue);
            RETURN asValue;
        END IF;
    END;
    
    
    PROCEDURE GenerateCsvHeader(
        anFile    IN utl_file.File_Type,
        anCursor  IN PLS_INTEGER,
        atDescTab IN dbms_sql.desc_tab
    )
    AS
        lnIndex    PLS_INTEGER;
    BEGIN
        aapiTrace.Enter();
        
        lnIndex := atDescTab.FIRST;
        WHILE lnIndex IS NOT NULL LOOP
            utl_file.put(anFile, EscapeCsv(atDescTab(lnIndex).col_name));
            lnIndex := atDescTab.NEXT(lnIndex);
            IF lnIndex IS NOT NULL THEN
                utl_file.put(anFile, ',');
            END IF;
        END LOOP;
        utl_file.new_line(anFile);
        
        aapiTrace.Exit();
    END;


    PROCEDURE GenerateCsvHeader(
        anFile    IN utl_file.File_Type,
        anCursor  IN PLS_INTEGER
    )
    AS
        lnCount   PLS_INTEGER;
        ltDescTab dbms_sql.desc_tab;
    BEGIN
        dbms_sql.describe_columns(anCursor, lnCount, ltDescTab);
        GenerateCsvHeader(anFile, anCursor, ltDescTab);
    END;
    
    
    PROCEDURE GenerateCsv(
        anFile        IN utl_file.File_Type,
        anCursor      IN PLS_INTEGER,
        anWriteHeader IN iapiType.Boolean_Type DEFAULT 1
    )
    IS
        lnIndex    PLS_INTEGER;
        lnCount    PLS_INTEGER;
        lnColCount PLS_INTEGER;
        lsBuffer   VARCHAR2(32767);
        ltDescTab  dbms_sql.desc_tab;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anWriteHeader', anWriteHeader);

        dbms_sql.describe_columns(anCursor, lnColCount, ltDescTab);
        FOR lnIndex IN 1 .. lnColCount LOOP
            dbms_sql.define_column(anCursor, lnIndex, lsBuffer, 32767);
        END LOOP;
    
        IF anWriteHeader <> 0 THEN
            GenerateCsvHeader(anFile, anCursor, ltDescTab);
        END IF;
        
        lnCount := dbms_sql.execute(anCursor);
        WHILE dbms_sql.fetch_rows(anCursor) <> 0 LOOP
            FOR lnIndex IN 1 .. lnColCount LOOP
                IF lnIndex > 1 THEN
                    utl_file.put(anFile, ',');
                END IF;
                dbms_sql.column_value(anCursor, lnIndex, lsBuffer);
                utl_file.put(anFile, EscapeCsv(lsBuffer));
            END LOOP;
            utl_file.new_line(anFile);
        END LOOP;
        
        aapiTrace.Exit();
    END;

END AAPIGENERAL;