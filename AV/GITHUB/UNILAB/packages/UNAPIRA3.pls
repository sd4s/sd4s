create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapira3 AS

-- Package variable 'l_puttext' is introduced as optimalization, this avoids having to create a
-- large varchar in all packages. Should only be used for U4DataGetLine.
l_puttext         VARCHAR2(4000);

-- Constants with list of columns for group key tables.
-- PAY attention to the replace taking place in the code when modifying these constants.
CONSTANT_ALLSTGKCOLUMNS    CONSTANT VARCHAR2(100) := 'st, version, gk, gk_version, gkseq, value';
CONSTANT_ALLRTGKCOLUMNS    CONSTANT VARCHAR2(100) := 'rt, version, gk, gk_version, gkseq, value';
CONSTANT_ALLSCGKCOLUMNS    CONSTANT VARCHAR2(100) := 'sc, gk, gk_version, gkseq, value';
CONSTANT_ALLSCMEGKCOLUMNS  CONSTANT VARCHAR2(100) := 'sc, pg, pgnode, pa, panode, me, menode, gk, gk_version, gkseq, value';
CONSTANT_ALLWSGKCOLUMNS    CONSTANT VARCHAR2(100) := 'ws, gk, gk_version, gkseq, value';
CONSTANT_ALLRQGKCOLUMNS    CONSTANT VARCHAR2(100) := 'rq, gk, gk_version, gkseq, value';
CONSTANT_ALLSDGKCOLUMNS    CONSTANT VARCHAR2(100) := 'sd, gk, gk_version, gkseq, value';
CONSTANT_ALLPTGKCOLUMNS    CONSTANT VARCHAR2(100) := 'pt, version, gk, gk_version, gkseq, value';

FUNCTION GetVersion
RETURN VARCHAR2;

----------------------------------------------------------------------------------------------
-- Pseudo Private Functions
-- should not be used by client - public since the package had to be splitted into 3 packages.
----------------------------------------------------------------------------------------------
PROCEDURE U4DataPutLine               /* INTERNAL */
(a_text      IN   VARCHAR2,           /* VC2000_TYPE */
 a_data_row  IN   CHAR DEFAULT '1');  /* CHAR1_TYPE */

FUNCTION ArchiveScGkToFile        /* INTERNAL */
(a_sc IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveStGkToFile                 /* INTERNAL */
(a_st IN VARCHAR2, a_version IN VARCHAR2)  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveRtGkToFile                /* INTERNAL */
(a_rt IN VARCHAR2, a_version IN VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveScCustomToFile    /* INTERNAL */
(a_sc IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveAtCustomToFile    /* INTERNAL */
RETURN NUMBER;

FUNCTION ArchiveRqGkToFile        /* INTERNAL */
(a_rq IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveRqCustomToFile    /* INTERNAL */
(a_rq IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveWsGkToFile        /* INTERNAL */
(a_ws IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveWsCustomToFile    /* INTERNAL */
(a_ws IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveSdGkToFile        /* INTERNAL */
(a_sd IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveSdCustomToFile    /* INTERNAL */
(a_sd IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchivePtGkToFile                /* INTERNAL */
(a_pt IN VARCHAR2, a_version IN VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveChCustomToFile    /* INTERNAL */
(a_ch IN VARCHAR2)                /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ArchiveToFILE           /* INTERNAL */
(a_archive_id    IN VARCHAR2)    /* VC20_TYPE */
RETURN NUMBER;

END unapira3;