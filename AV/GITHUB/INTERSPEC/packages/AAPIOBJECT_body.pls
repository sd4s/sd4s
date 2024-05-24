create or replace PACKAGE BODY aapiObject AS

    FUNCTION CreateObject(
        arObject       OUT ObjectRec_Type,
        abData         IN  BLOB,
        asFilename     IN  VARCHAR2,
        asDescription  IN  VARCHAR2 DEFAULT NULL,
        asSortDesc     IN  VARCHAR2 DEFAULT NULL,
        anObjectWidth  IN  NUMBER   DEFAULT 0,
        anObjectHeight IN  NUMBER   DEFAULT 0
    ) RETURN iapiType.ErrorNum_Type AS
        /*
        anOwner         IN  NUMBER,
        asShortDesc     IN  VARCHAR2,
        asDescription   IN  VARCHAR2,
        asFilename      IN  VARCHAR2,
        anObjectWidth   IN  NUMBER,
        anObjectHeight  IN  NUMBER,
        anIntl          IN  NUMBER,
        abData          IN  BLOB,
        anObjectID      OUT NUMBER
        ) RETURN iapiType.ErrorNum_Type
        AS
        lsShortDesc   VARCHAR2(20 CHAR);
        lsDescription VARCHAR2(70 CHAR);
        lsErrMsg      VARCHAR2(1024);
        lnRetval      NUMBER;
        lnIsImage     NUMBER;
        */
        lnCount PLS_INTEGER;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('abData', '[...]');
        aapiTrace.Param('asFilename', asFilename);
        aapiTrace.Param('asDescription', asDescription);
        aapiTrace.Param('asSortDesc', asSortDesc);
        aapiTrace.Param('anObjectWidth', anObjectWidth);
        aapiTrace.Param('anObjectHeight', anObjectHeight);

        SELECT COUNT(*)
        INTO lnCount
        FROM itoih
        WHERE sort_desc = asSortDesc
          AND description = asDescription;
        
        IF lnCount = 1 THEN
            NULL;
        END IF;
        /*
        SELECT object_id_seq.nextVal
        INTO anObjectID
        FROM dual;
    
        lsShortDesc := asShortDesc;
        IF lsShortDesc IS NULL THEN
            lsShortDesc := TO_CHAR(anObjectID);
        END IF;
        
        lsDescription := asDescription;
        IF lsDescription IS NULL THEN
            lsDescription := TO_CHAR(anObjectID);
        END IF;
        lnRetval := iapiObject.ifValidate(lsShortDesc, lsDescription, asFilename);
        IF lnRetVal <> iapiConstantDbError.DBERR_SUCCESS THEN
            RETURN lnRetVal;
        END IF;
        */
    
        INSERT INTO itoih(
            object_id,
            owner,
            lang_id,
            sort_desc,
            description,
            object_imported,
            allow_phantom,
            intl
        ) VALUES(
            object_id_seq.nextVal,
            1, --owner
            1, --lang_id
            asSortDesc,
            asDescription,
            'Y',
            'Y',
            1
        ) RETURNING object_id, 1, owner, lang_id
        INTO arObject;
    
        /*
        UPDATE itoiraw
        SET desktop_object = abData
        WHERE object_id = anObjectID
        AND revision = 1
        AND owner = anOwner;
    
        IF (anObjectWidth > 0) AND (anObjectHeight > 0) THEN
            lnIsImage := 1;
        ELSE
            lnIsImage := 0;
        END IF;
        
        UPDATE itoid
        SET object_width = anObjectWidth,
            object_height = anObjectHeight,
            file_name = asFileName,
            visual = CASE WHEN lnIsImage = 1 THEN 1 ELSE 0 END,
            ole_object = CASE WHEN lnIsImage = 1 THEN 'N' ELSE 'P' END
        WHERE object_id = anObjectID
        AND revision = 1
        AND owner = anOwner;
        
        RETURN iapiConstantDbError.DBERR_SUCCESS;
        EXCEPTION
        WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(lsErrMsg);
        iapiGeneral.LogError('FUNCTIONS', 'f_create_object', lsErrMsg);
        
        RETURN iapiConstantDbError.DBERR_GENFAIL;
        END f_create_object;    RETURN NULL;
        */
        
        aapiTrace.Exit();
    END CreateObject;

END;