select sum(bytes)/1024/1024 as "Index Size (MB)" from dba_segments where segment_name='&INDEX_NAME';
select sum(bytes)/1024/1024 as "Index Size (MB)" from user_segments where segment_name='&INDEX_NAME';


select  *
from (select owner
     ,       segment_type
     ,       segment_name
	 ,       bytes/1024/1024 mb
     from dba_segments
     --where segment_type = 'INDEX'
     order by bytes/1024/1024 desc)
where rownum <= 20
;

/*
UNILAB	UISCPAHSDETAILS				40355
UNILAB	UISCMEHSDETAILS				38617
UNILAB	UISCPAHS					20064
UNILAB	UISCHSDETAILS				17592
UNILAB	UISCMEHS					16433
UNILAB	UKSCMECELLLIST				10981
UNILAB	AIPATRHS_OBJECT				9703		--???
UNILAB	UISCHS						9088
UNILAB	UKSCPAAU					9033
UNILAB	UKSCMEGK					6544
UNILAB	UKSCGK						5310
UNILAB	UISCMEHS_LOGDATE			4416
UNILAB	UISCPAHS_LOGDATE			4021
UNILAB	UISCICHSDETAILS				3857
UNILAB	UISCPGHS					3777
UNILAB	AIPATRHS_TR_ON				3585		--???
UNILAB	AISCPAEXEC_END_DATESSPAPGSC	3537		--???
UNILAB	UISCICHS					3412
UNILAB	UKSCMECELL					3409
UNILAB	UISCPASCPGPASSEXEC_END_DATE	3271
*/	

select index_name, table_name from all_indexes where index_name ='AIPATRHS_OBJECT';
/*
index_name			table_name
AIPATRHS_OBJECT		ATPATRHS
*/

--UNACTION.LogTransition
/*
atwstrhs		0
atrqtrhs		6.329.863
atsctrhs		7.648.386
atpgtrhs		0
atpatrhs		67.556.026
atmetrhs		11.971.913
atrqictrhs		0
atictrhs		0	
atobjecttrhs	0
*/
