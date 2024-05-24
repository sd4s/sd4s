create or replace PACKAGE            "AAPIGENERAL" AS 

    FUNCTION EscapeFilename(
        asValue IN VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION EscapeCsv(
        asValue IN VARCHAR2
    ) RETURN VARCHAR2;
    
    PROCEDURE GenerateCsvHeader(
        anFile    IN utl_file.File_Type,
        anCursor  IN PLS_INTEGER
    );

    PROCEDURE GenerateCsv(
        anFile        IN utl_file.File_Type,
        anCursor      IN PLS_INTEGER,
        anWriteHeader IN iapiType.Boolean_Type DEFAULT 1
    );

END AAPIGENERAL;