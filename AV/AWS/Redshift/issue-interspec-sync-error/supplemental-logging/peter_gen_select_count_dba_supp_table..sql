--genereer select-count-statements voor AWS-redshift

--UNILAB

select 'select '||''''||a.asl_table_name||''''||', '||''''||'sc_unilab_ens: '||''''||'||'||'count(*) from sc_unilab_ens.'||a.asl_table_name||';'
from dba_aws_supplemental_log a
where a.asl_ind_active_jn='J'
order by a.asl_table_name
;

/*
--DEZE CONSTRUCTIE WERKT OOK...

select 'ATAOACTIONS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATAOACTIONS
UNION
select 'ATAOCONDITIONS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATAOCONDITIONS
;
*/


/*
select 'ATAOACTIONS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATAOACTIONS;
select 'ATAOCONDITIONS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATAOCONDITIONS;
select 'ATAVMETHODCLASS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATAVMETHODCLASS;
select 'ATAVPROJECTS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATAVPROJECTS;
select 'ATICTRHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATICTRHS;
select 'ATMETRHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATMETRHS;
select 'ATPATRHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATPATRHS;
select 'ATRQTRHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATRQTRHS;
select 'ATSCTRHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.ATSCTRHS;
select 'UTAD', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTAD;
select 'UTADAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTADAU;
select 'UTAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTAU;
select 'UTDD', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTDD;
select 'UTDECODE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTDECODE;
select 'UTEQ', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTEQ;
select 'UTEQAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTEQAU;
select 'UTEQCD', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTEQCD;
select 'UTEQTYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTEQTYPE;
select 'UTERROR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTERROR;
select 'UTGKMELIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTGKMELIST;
select 'UTGKRQLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTGKRQLIST;
select 'UTGKRTLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTGKRTLIST;
select 'UTGKSCLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTGKSCLIST;
select 'UTGKSTLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTGKSTLIST;
select 'UTGKWSLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTGKWSLIST;
select 'UTIE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTIE;
select 'UTIEAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTIEAU;
select 'UTIELIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTIELIST;
select 'UTIP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTIP;
select 'UTIPIE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTIPIE;
select 'UTLAB', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTLAB;
select 'UTLC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTLC;
select 'UTLCAF', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTLCAF;
select 'UTLCHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTLCHS;
select 'UTLCTR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTLCTR;
select 'UTLONGTEXT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTLONGTEXT;
select 'UTLY', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTLY;
select 'UTMT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTMT;
select 'UTMTAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTMTAU;
select 'UTMTCELL', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTMTCELL;
select 'UTMTCELLLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTMTCELLLIST;
select 'UTMTHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTMTHS;
select 'UTPP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPP;
select 'UTPPAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPPAU;
select 'UTPPPR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPPPR;
select 'UTPPPRAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPPPRAU;
select 'UTPR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPR;
select 'UTPRAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPRAU;
select 'UTPRHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPRHS;
select 'UTPRMT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPRMT;
select 'UTPRMTAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTPRMTAU;
select 'UTRQ', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQ;
select 'UTRQAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQAU;
select 'UTRQGK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGK;
select 'UTRQGKISRELEVANT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKISRELEVANT;
select 'UTRQGKISTEST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKISTEST;
select 'UTRQGKREQUESTCODE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKREQUESTCODE;
select 'UTRQGKRQDAY', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKRQDAY;
select 'UTRQGKRQEXECUTIONWEEK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKRQEXECUTIONWEEK;
select 'UTRQGKRQMONTH', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKRQMONTH;
select 'UTRQGKRQSTATUS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKRQSTATUS;
select 'UTRQGKRQWEEK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKRQWEEK;
select 'UTRQGKRQYEAR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKRQYEAR;
select 'UTRQGKSITE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKSITE;
select 'UTRQGKTESTLOCATION', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKTESTLOCATION;
select 'UTRQGKTESTTYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKTESTTYPE;
select 'UTRQGKWORKORDER', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQGKWORKORDER;
select 'UTRQHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQHS;
select 'UTRQIC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQIC;
select 'UTRQII', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRQII;
select 'UTRSCME', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRSCME;
select 'UTRSCMECELL', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRSCMECELL;
select 'UTRSCMECELLLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRSCMECELLLIST;
select 'UTRSCPA', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRSCPA;
select 'UTRSCPASPA', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRSCPASPA;
select 'UTRSCPG', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRSCPG;
select 'UTRT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRT;
select 'UTRTAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRTAU;
select 'UTRTGKREQUESTERUP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRTGKREQUESTERUP;
select 'UTRTGKSPEC_TYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRTGKSPEC_TYPE;
select 'UTRTIP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTRTIP;
select 'UTSC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSC;
select 'UTSCAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCAU;
select 'UTSCGK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGK;
select 'UTSCGKCONTEXT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKCONTEXT;
select 'UTSCGKISTEST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKISTEST;
select 'UTSCGKPARTGROUP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKPARTGROUP;
select 'UTSCGKPART_NO', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKPART_NO;
select 'UTSCGKPROJECT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKPROJECT;
select 'UTSCGKREQUESTCODE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKREQUESTCODE;
select 'UTSCGKRIMCODE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKRIMCODE;
select 'UTSCGKSCCREATEUP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKSCCREATEUP;
select 'UTSCGKSCLISTUP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKSCLISTUP;
select 'UTSCGKSCRECEIVERUP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKSCRECEIVERUP;
select 'UTSCGKSITE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKSITE;
select 'UTSCGKSPEC_TYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKSPEC_TYPE;
select 'UTSCGKWEEK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKWEEK;
select 'UTSCGKWORKORDER', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKWORKORDER;
select 'UTSCGKYEAR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCGKYEAR;
select 'UTSCHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCHS;
select 'UTSCIC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCIC;
select 'UTSCII', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCII;
select 'UTSCME', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCME;
select 'UTSCMEAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEAU;
select 'UTSCMECELL', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMECELL;
select 'UTSCMECELLLIST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMECELLLIST;
select 'UTSCMEGK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGK;
select 'UTSCMEGKAVTESTMETHOD', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKAVTESTMETHOD;
select 'UTSCMEGKAVTESTMETHODDESC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKAVTESTMETHODDESC;
select 'UTSCMEGKEQUIPEMENT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKEQUIPEMENT;
select 'UTSCMEGKEQUIPMENT_TYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKEQUIPMENT_TYPE;
select 'UTSCMEGKIMPORTID', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKIMPORTID;
select 'UTSCMEGKKINDOFSAMPLE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKKINDOFSAMPLE;
select 'UTSCMEGKLAB', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKLAB;
select 'UTSCMEGKME_IS_RELEVANT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKME_IS_RELEVANT;
select 'UTSCMEGKPART_NO', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKPART_NO;
select 'UTSCMEGKREQUESTCODE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKREQUESTCODE;
select 'UTSCMEGKSCPRIORITY', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKSCPRIORITY;
select 'UTSCMEGKTM_POSITION', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKTM_POSITION;
select 'UTSCMEGKUSER_GROUP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKUSER_GROUP;
select 'UTSCMEGKWEEK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKWEEK;
select 'UTSCMEGKYEAR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEGKYEAR;
select 'UTSCMEHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEHS;
select 'UTSCMEHSDETAILS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCMEHSDETAILS;
select 'UTSCPA', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCPA;
select 'UTSCPAAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCPAAU;
select 'UTSCPAHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCPAHS;
select 'UTSCPASPA', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCPASPA;
select 'UTSCPG', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCPG;
select 'UTSCPGAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSCPGAU;
select 'UTSS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSS;
select 'UTST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTST;
select 'UTSTAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTAU;
select 'UTSTGK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTGK;
select 'UTSTGKCONTEXT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTGKCONTEXT;
select 'UTSTGKISTEST', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTGKISTEST;
select 'UTSTGKPRODUCT_RANGE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTGKPRODUCT_RANGE;
select 'UTSTGKSPEC_TYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTGKSPEC_TYPE;
select 'UTSTHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTHS;
select 'UTSTPP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTSTPP;
select 'UTUP', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTUP;
select 'UTUPAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTUPAU;
select 'UTUPPREF', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTUPPREF;
select 'UTUPUS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTUPUS;
select 'UTUPUSPREF', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTUPUSPREF;
select 'UTWS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWS;
select 'UTWSAU', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSAU;
select 'UTWSGK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGK;
select 'UTWSGKAVTESTMETHOD', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKAVTESTMETHOD;
select 'UTWSGKAVTESTMETHODDESC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKAVTESTMETHODDESC;
select 'UTWSGKNUMBEROFREFS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKNUMBEROFREFS;
select 'UTWSGKNUMBEROFSETS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKNUMBEROFSETS;
select 'UTWSGKNUMBEROFVARIANTS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKNUMBEROFVARIANTS;
select 'UTWSGKOUTSOURCE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKOUTSOURCE;
select 'UTWSGKP_INFL_FRONT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKP_INFL_FRONT;
select 'UTWSGKP_INFL_REAR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKP_INFL_REAR;
select 'UTWSGKREFSETDESC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKREFSETDESC;
select 'UTWSGKREQUESTCODE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKREQUESTCODE;
select 'UTWSGKRIM', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKRIM;
select 'UTWSGKRIMETFRONT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKRIMETFRONT;
select 'UTWSGKRIMETREAR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKRIMETREAR;
select 'UTWSGKRIMWIDTHFRONT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKRIMWIDTHFRONT;
select 'UTWSGKRIMWIDTHREAR', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKRIMWIDTHREAR;
select 'UTWSGKSPEC_TYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKSPEC_TYPE;
select 'UTWSGKSUBPROGRAMID', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKSUBPROGRAMID;
select 'UTWSGKTESTLOCATION', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKTESTLOCATION;
select 'UTWSGKTESTPRIO', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKTESTPRIO;
select 'UTWSGKTESTSETSIZE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKTESTSETSIZE;
select 'UTWSGKTESTVEHICLETYPE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKTESTVEHICLETYPE;
select 'UTWSGKTESTWEEK', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKTESTWEEK;
select 'UTWSGKWSPRIO', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKWSPRIO;
select 'UTWSGKWSTESTLOCATION', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKWSTESTLOCATION;
select 'UTWSGKWSVEHICLE', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSGKWSVEHICLE;
select 'UTWSHS', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSHS;
select 'UTWSII', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSII;
select 'UTWSME', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSME;
select 'UTWSSC', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWSSC;
select 'UTWT', 'sc_unilab_ens: '||count(*) from sc_unilab_ens.UTWT;
*/

	
--INTERSPEC

select 'select '||''''||a.asl_table_name||''''||', '||''''||'sc_interspec_ens: '||''''||'||'||'count(*) from sc_interspec_ens.'||a.asl_table_name||';'
from dba_aws_supplemental_log a
where a.asl_ind_active_jn='J'
order by a.asl_table_name
;

/*
select 'ACCESS_GROUP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ACCESS_GROUP;
select 'APPROVAL_HISTORY', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.APPROVAL_HISTORY;
select 'ASSOCIATION', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ASSOCIATION;
select 'ATFUNCBOM', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ATFUNCBOM;
select 'ATFUNCBOMDATA', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ATFUNCBOMDATA;
select 'ATFUNCBOMWORKAREA', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ATFUNCBOMWORKAREA;
select 'ATTACHED_SPECIFICATION', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ATTACHED_SPECIFICATION;
select 'ATTRIBUTE', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ATTRIBUTE;
select 'AVARTICLEPRICES', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.AVARTICLEPRICES;
select 'BOM_HEADER', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.BOM_HEADER;
select 'BOM_ITEM', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.BOM_ITEM;
select 'CHARACTERISTIC', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.CHARACTERISTIC;
select 'CHARACTERISTIC_ASSOCIATION', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.CHARACTERISTIC_ASSOCIATION;
select 'CLASS3', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.CLASS3;
select 'FRAME_HEADER', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.FRAME_HEADER;
select 'FRAME_KW', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.FRAME_KW;
select 'FRAME_PROP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.FRAME_PROP;
select 'FRAME_SECTION', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.FRAME_SECTION;
select 'HEADER', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.HEADER;
select 'HEADER_H', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.HEADER_H;
select 'ITBOMLY', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITBOMLY;
select 'ITBOMLYITEM', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITBOMLYITEM;
select 'ITBOMLYSOURCE', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITBOMLYSOURCE;
select 'ITCLAT', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITCLAT;
select 'ITCLD', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITCLD;
select 'ITCLTV', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITCLTV;
select 'ITFRMDEL', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITFRMDEL;
select 'ITKW', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITKW;
select 'ITKWAS', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITKWAS;
select 'ITKWCH', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITKWCH;
select 'ITLANG', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITLANG;
select 'ITLIMSCONFLY', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITLIMSCONFLY;
select 'ITLIMSJOB', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITLIMSJOB;
select 'ITLIMSTMP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITLIMSTMP;
select 'ITMFC', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITMFC;
select 'ITMFCMPL', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITMFCMPL;
select 'ITMPL', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITMPL;
select 'ITOID', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITOID;
select 'ITOIH', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITOIH;
select 'ITPLGRP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITPLGRP;
select 'ITPLGRPLIST', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITPLGRPLIST;
select 'ITPP_DEL', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITPP_DEL;
select 'ITPRCL', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITPRCL;
select 'ITPRMFC', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITPRMFC;
select 'ITSHDEL', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITSHDEL;
select 'ITSHQ', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITSHQ;
select 'ITUP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITUP;
select 'ITUS', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.ITUS;
select 'LAYOUT', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.LAYOUT;
select 'MATERIAL_CLASS', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.MATERIAL_CLASS;
select 'PART', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PART;
select 'PART_PLANT', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PART_PLANT;
select 'PLANT', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PLANT;
select 'PROPERTY', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY;
select 'PROPERTY_DISPLAY', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_DISPLAY;
select 'PROPERTY_GROUP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_GROUP;
select 'PROPERTY_GROUP_DISPLAY', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_GROUP_DISPLAY;
select 'PROPERTY_GROUP_H', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_GROUP_H;
select 'PROPERTY_GROUP_LIST', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_GROUP_LIST;
select 'PROPERTY_H', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_H;
select 'PROPERTY_LAYOUT', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_LAYOUT;
select 'PROPERTY_TEST_METHOD', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.PROPERTY_TEST_METHOD;
select 'REASON', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.REASON;
select 'REF_TEXT_TYPE', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.REF_TEXT_TYPE;
select 'SECTION', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SECTION;
select 'SECTION_H', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SECTION_H;
select 'SPECDATA', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SPECDATA;
select 'SPECIFICATION_HEADER', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SPECIFICATION_HEADER;
select 'SPECIFICATION_KW', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SPECIFICATION_KW;
select 'SPECIFICATION_PROP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SPECIFICATION_PROP;
select 'SPECIFICATION_SECTION', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SPECIFICATION_SECTION;
select 'STATUS', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.STATUS;
select 'STATUS_HISTORY', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.STATUS_HISTORY;
select 'SUB_SECTION', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SUB_SECTION;
select 'SUB_SECTION_H', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.SUB_SECTION_H;
select 'TEST_METHOD', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.TEST_METHOD;
select 'TEXT_TYPE', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.TEXT_TYPE;
select 'UOM', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.UOM;
select 'USER_GROUP', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.USER_GROUP;
select 'USER_GROUP_LIST', 'sc_interspec_ens: '||count(*) from sc_interspec_ens.USER_GROUP_LIST;
*/


	