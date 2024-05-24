create or replace PACKAGE          AAPIUTILS AS 
    PROCEDURE StopAllDBJobs;
    
    PROCEDURE StartAllDBJobs;
    
    PROCEDURE RestartAllDBJobs;

    PROCEDURE FixUserHistory(
        asUserID IN iapiType.UserId_Type
    );
    
    PROCEDURE FixPED(
        asPartNo IN iapiType.PartNo_Type
    );
    
    PROCEDURE ClearMOP(
        asUserID IN iapiType.UserId_Type
    );
    
    PROCEDURE AddTableToMOP(
        asUserID     IN iapiType.UserId_Type,
        asTableName  IN iapiType.StringVal_Type,
        asConditions IN iapiType.StringVal_Type DEFAULT NULL
    );
    
    PROCEDURE SetMopToSubmitLastQR(
        asUserID IN iapiType.UserId_Type,
        asReason IN iapiType.StringVal_Type
    );
    
    PROCEDURE StartMop(
        asUserID  IN iapiType.UserId_Type,
        asJobDesc IN iapiType.Description_Type
    );
    
    PROCEDURE CopyUserState(
        asUserIdSrc  IN iapiType.UserId_Type,
        asUserIdDest IN iapiType.UserId_Type
    );
    
    PROCEDURE CopyCatiaMapping(
        asFromFrameNo  IN iapiType.FrameNo_Type,
        anFromFrameRev IN iapiType.Revision_Type,
        asToFrameNo    IN iapiType.FrameNo_Type,
        anToFrameRev   IN iapiType.Revision_Type
    );
    
    PROCEDURE UpdateIntMapping(
        asTableName IN iapiType.StringVal_Type
    );
    
    PROCEDURE ExportHeaders;

    PROCEDURE ExportDmt(
        asUserID  IN iapiType.UserId_Type
    );

END;