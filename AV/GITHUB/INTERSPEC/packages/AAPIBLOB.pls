create or replace package aapiblob as
--
type t_raw is table of raw(32767) index by pls_integer;
--
function convert
  (abBlob in blob)
   return t_raw;
--
function get
  (asFileName out varchar2
  ,abRaw out t_raw)
   return iapiType.ErrorNum_Type;
--
function getBLOBbyObjectId
  (anObjectId in number,
  asFileName out varchar2
  ,abRaw out t_raw)
   return iapiType.ErrorNum_Type;
--
end aapiblob; 