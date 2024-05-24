create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 1 $
-- $Date: 4/11/04 14:23 $
unlocation AS

--auxiliary function
PROCEDURE TraceError
(a_api_name     IN        VARCHAR2,    /* VC40_TYPE */
 a_error_msg    IN        VARCHAR2);   /* VC255_TYPE */

--see package body for more information
FUNCTION UpdateLocationCounter
(a_sd                              IN     VARCHAR2, /* VC20_TYPE */
 a_cs                              IN     VARCHAR2, /* VC20_TYPE */
 a_csnode                          IN     NUMBER,   /* LONG_TYPE */
 a_tp                              IN     NUMBER,   /* NUM_TYPE */
 a_tp_unit                         IN     VARCHAR2, /* VC20_TYPE */
 a_tpnode                          IN     NUMBER,   /* LONG_TYPE */
 a_sc                              IN     VARCHAR2, /* VC20_TYPE */
 a_old_sdce_rec_lo                 IN     VARCHAR2, /* VC20_TYPE */
 a_old_sdce_rec_lo_description     IN     VARCHAR2, /* VC40_TYPE */
 a_old_sdce_rec_lo_start_date      IN     DATE,     /* DATE_TYPE */
 a_old_sdce_rec_lo_end_date        IN     DATE,     /* DATE_TYPE */
 a_new_sdce_rec_lo                 IN     VARCHAR2, /* VC20_TYPE */
 a_new_sdce_rec_lo_description     IN     VARCHAR2, /* VC40_TYPE */
 a_new_sdce_rec_lo_start_date      IN     DATE,     /* DATE_TYPE */
 a_new_sdce_rec_lo_end_date        IN     DATE,     /* DATE_TYPE */
 a_modify_action                   IN     VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

END unlocation;
 