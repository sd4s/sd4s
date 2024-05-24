create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiip AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetIpInfoField
(a_ip            OUT      UNAPIGEN.VC20_TABLE_TYPE,
 a_ie            OUT      UNAPIGEN.VC20_TABLE_TYPE,
 a_description   OUT      UNAPIGEN.VC40_TABLE_TYPE,
 a_dsp_len       OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_dsp_tp        OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_dsp_rows      OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_seq           OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_pos_x         OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_pos_y         OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_is_protected  OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_mandatory     OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_hidden        OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_def_val_tp    OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_def_au_level  OUT      UNAPIGEN.VC4_TABLE_TYPE,
 a_ievalue       OUT      UNAPIGEN.VC2000_TABLE_TYPE,
 a_nr_of_rows    IN OUT   NUMBER,
 a_where_clause  IN       VARCHAR2,
 a_next_rows     IN       NUMBER)
RETURN NUMBER;

END pbapiip;