create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapixslt AS

FUNCTION GetVersion
RETURN VARCHAR2;

--Deprecated: will be suppressed in the one of the following version of this package
FUNCTION GetPdaXslt
(a_obj_id                     OUT UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_seq                        OUT UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_line                       OUT UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER,                       /* NUM_TYPE */
 a_where_clause            IN     VARCHAR2)                     /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetXslt
(a_obj_id          OUT    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_usage_type      OUT    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_line            OUT    UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER,                       /* NUM_TYPE */
 a_where_clause    IN     VARCHAR2)                     /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetXsltList
(a_obj_id          OUT    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_usage_type      OUT    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER,                       /* NUM_TYPE */
 a_where_clause    IN     VARCHAR2)                     /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveXslt
(a_obj_id           IN    VARCHAR2,                     /* VC20_TYPE */
 a_usage_type       IN    VARCHAR2,                     /* VC20_TYPE */
 a_line             IN    UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN    NUMBER,                       /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteXslt
(a_obj_id           IN    VARCHAR2,                     /* VC20_TYPE */
 a_modify_reason    IN    VARCHAR2)                     /* VC255_TYPE */
RETURN NUMBER;

END unapixslt;