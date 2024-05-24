create or replace PACKAGE
unapiul AS


UL_TRACE_NONE            CONSTANT INTEGER := 0;
UL_TRACE_LOW             CONSTANT INTEGER := 1;
UL_TRACE_NORMAL          CONSTANT INTEGER := 2;
UL_TRACE_HIGH            CONSTANT INTEGER := 3;
UL_TRACE_ALERT           CONSTANT INTEGER := 4;

P_TRACE_LEVEL            INTEGER; /* 0 show all - 4 alerts only */
--Message level under which trace messages will be filtered out when tracing is turned on
--When P_TRACE_LEVEL = 0, all messages will be present in the trace file.
--When P_TRACE_LEVEL = 4, only alert messages will be present in the trace file.
--When P_TRACE_LEVEL = 5, no messages will be present in the trace file.

P_UNILINK_ID             VARCHAR2(255);
P_DELIMITER              CHAR(1) DEFAULT '/';
P_LOC_IN_DIR             VARCHAR2(255);
P_LOC_LOG_DIR            VARCHAR2(255);
P_LOC_OUT_DIR            VARCHAR2(255);
P_LOC_ERROR_DIR          VARCHAR2(255);
P_FILE_NAME              VARCHAR2(255);
P_UL_TRACE_ON            CHAR(1) DEFAULT '0';
P_UL_TRACE_LOC_DIR       VARCHAR2(255);

CURSOR l_ul_cursor(a_unilink_id VARCHAR2) IS
SELECT eq,
       lab,
       MAX(DECODE(a.setting_name,'LOC_DIR'      ,a.setting_value)) loc_dir,
       MAX(DECODE(a.setting_name,'FILE_NAME'    ,a.setting_value)) file_name,
       MAX(DECODE(a.setting_name,'CF'           ,a.setting_value)) cf,
       MAX(DECODE(a.setting_name,'AFTER_PROCESS',a.setting_value)) after_process,
       MAX(DECODE(a.setting_name,'UNILINK_ID'   ,NVL(a.setting_value,'UNILINK'))) unilink_id,
       MAX(DECODE(a.setting_name,'EOF_STRING'   ,NVL(a.setting_value,'<EOF>'))) eof_string
FROM uteqcd a
WHERE a.eq IN
   (SELECT eq
    FROM uteqcd
    WHERE setting_name = 'LOC_DIR'
    AND setting_value IS NOT NULL
    INTERSECT
    SELECT eq
    FROM uteqcd
    WHERE setting_name = 'UNILINK_ID'
    AND NVL(setting_value,'UNILINK') = NVL(a_unilink_id, 'UNILINK'))
GROUP BY a.eq, a.lab;
P_EQUL_REC                l_ul_cursor%ROWTYPE;

CURSOR l_eq_cursor(a_eq VARCHAR2) IS
SELECT eq,
       MAX(DECODE(a.setting_name,'LOC_DIR'      ,a.setting_value)) loc_dir,
       MAX(DECODE(a.setting_name,'FILE_NAME'    ,a.setting_value)) file_name,
       MAX(DECODE(a.setting_name,'CF'           ,a.setting_value)) cf,
       MAX(DECODE(a.setting_name,'AFTER_PROCESS',a.setting_value)) after_process,
       MAX(DECODE(a.setting_name,'UNILINK_ID'   ,NVL(a.setting_value,'UNILINK'))) unilink_id,
       MAX(DECODE(a.setting_name,'EOF_STRING'   ,NVL(a.setting_value,'<EOF>'))) eof_string
FROM uteqcd a
WHERE a.eq = a_eq
AND lab = '-'
GROUP BY a.eq;

CURSOR l_directory(a_directory_name VARCHAR2) IS
SELECT directory_path
FROM all_directories
WHERE directory_name = a_directory_name;

CURSOR l_searchdirectory4path(a_directory_path VARCHAR2) IS
SELECT directory_name
FROM all_directories
WHERE directory_path = a_directory_path;

CURSOR l_utulin_cursor(a_file_name VARCHAR2) IS
   SELECT read_on, line_nbr, text_line
   FROM utulin
   WHERE file_name = NVL(a_file_name, UNAPIUL.P_FILE_NAME)
   ORDER BY line_nbr;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION Unilink                               /* INTERNAL */
(a_unilink_id       IN    VARCHAR2,            /* VC20_TYPE */
 a_read_file        IN    CHAR,                /* CHAR1_TYPE */
 a_eof_detection    IN    VARCHAR2,            /* VC20_TYPE */
 a_delimiter        IN    CHAR,                /* CHAR1_TYPE */
 a_trace_level      IN    NUMBER,              /* NUM_TYPE */
 a_ul_trace_on      IN    CHAR,                /* CHAR1_TYPE */
 a_ul_trace_loc_dir IN    VARCHAR2,            /* VC20_TYPE */
 a_file             IN    VARCHAR2 DEFAULT '', /* VC255_TYPE */
 a_tz               IN    VARCHAR2 DEFAULT 'SERVER' ) /* VC255_TYPE */
RETURN NUMBER;

/* following function is implemented in C because of OS interaction */
/* library 'unilink' must exist on the system */

FUNCTION Unilink                    /* INTERNAL */
(a_eq               IN    VARCHAR2, /* VC20_TYPE */
 a_delimiter        IN    CHAR,     /* CHAR1_TYPE */
 a_trace_level      IN    NUMBER,   /* NUM_TYPE */
 a_file             IN    VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

/*---------------------*/
/* AUXILIARY FUNCTIONS */
/*---------------------*/
FUNCTION GetULTextList                             /* INTERNAL */
(a_file_name    IN     VARCHAR2,                   /* VC255_TYPE */
 a_read_on      OUT    UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_line_nbr     OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_text_line    OUT    UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_nr_of_rows   IN OUT NUMBER,                     /* NUM_TYPE */
 a_next_rows    IN     NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteULText                              /* INTERNAL */
(a_file_name    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION WriteToLog                   /* INTERNAL */
(a_api_name    IN     VARCHAR2,       /* VC40_TYPE */
 a_log_msg     IN     VARCHAR2)       /* VC255_TYPE */
RETURN NUMBER;

FUNCTION OpenOutputFile                       /* INTERNAL */
(a_file_name    IN     VARCHAR2)              /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CloseOutputFile         /* INTERNAL */
RETURN NUMBER;

FUNCTION WriteToOutputFile         /* INTERNAL */
(a_text_line  IN VARCHAR2)         /* VC2000_TYPE */
RETURN NUMBER;

PROCEDURE Trace                      /* INTERNAL */
(a_text_line   IN VARCHAR2,         /* VC2000_TYPE */
 a_trace_level IN NUMBER)           /* NUM_TYPE */
;

FUNCTION StartUnilink               /* INTERNAL */
(a_unilink_id       IN    VARCHAR2, /* VC20_TYPE */
 a_read_file        IN    CHAR,     /* CHAR1_TYPE */
 a_eof_detection    IN    VARCHAR2, /* VC20_TYPE */
 a_delimiter        IN    CHAR,     /* CHAR1_TYPE */
 a_trace_level      IN    NUMBER,   /* NUM_TYPE */
 a_ul_trace_on      IN    CHAR,     /* CHAR1_TYPE */
 a_ul_trace_loc_dir IN    VARCHAR2, /* VC255_TYPE */
 a_tz               IN    VARCHAR2 DEFAULT 'SERVER' ) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION StopUnilink                /* INTERNAL */
(a_unilink_id       IN    VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ChangeULInterval          /* INTERNAL */
(a_unilink_id      IN    VARCHAR2, /* VC20_TYPE */
 a_interval        IN    VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetDirectory                                /* INTERNAL */
(a_dirpath      IN     VARCHAR2,                     /* VC255_TYPE */
 a_files        OUT    UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TAB_TYPE */
 a_nr_of_rows   OUT    NUMBER,                       /* NUM_TYPE */
 a_not_locked   IN     NUMBER DEFAULT 1)                        /* NUM_TYPE */
RETURN NUMBER;

FUNCTION RemoveFile                              /* INTERNAL */
(a_filepath     IN          VARCHAR2)            /* VC255_TYPE */
RETURN NUMBER;

FUNCTION RemoveFile                              /* INTERNAL */
(a_directory    IN          VARCHAR2,            /* VC255_TYPE */
 a_delimiter    IN          CHAR,                /* CHAR1_TYPE */
 a_file         IN          VARCHAR2)            /* VC255_TYPE */
RETURN NUMBER;

FUNCTION MoveFile
(a_filepath_to_move       IN VARCHAR2,  /* VC255_TYPE */
 a_filepath_destination   IN VARCHAR2)  /* VC255_TYPE */
RETURN NUMBER;

END unapiul;