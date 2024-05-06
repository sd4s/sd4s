--create aurora-view AV_UTBLOB

--CONN AURORA-DB 

CREATE or REPLACE VIEW SC_LIMS_DAL."AV_UTBLOB" 
("ID" 
,	"DESCRIPTION" 
,	"OBJECT_LINK" 
,	"KEY1" 
,	"KEY2" 
,	"KEY3" 
,	"KEY4" 
,	"KEY5" 
,	"URL" 
,	"DATA"
)
AS
select "ID" 
,	"DESCRIPTION"
,	"OBJECT_LINK" 
,	"KEY1" 
,	"KEY2" 
,	"KEY3" 
,	"KEY4" 
,	"KEY5" 
,	"URL" 
,	"DATA"
from sc_unilab_ens."UTBLOB"
;


grant all on  SC_LIMS_DAL."AV_UTBLOB"   to usr_rna_readonly1;

  
  
  
  
--einde script
  