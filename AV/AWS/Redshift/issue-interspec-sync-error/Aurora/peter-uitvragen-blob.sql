--opvragen van BLOB uit AURORA-DB: sc_unilab_ens.UTBLOB

--LET OP: COLUMN_NAME TUSSEN "" OPNEMEN IN SELECT + WHERE-CLAUSE !!

--UNILAB-ORACLE:
SELECT RQ, II, IIVALUE FROM UTRQII WHERE RQ='22.786.MAR' and II='avResultDocument';
--22.786.MAR	avResultDocument	2023-0123-0027#BLB	


--AURORA.UTBLOB:
--LET OP: COLUMN_NAME TUSSEN "" OPNEMEN IN SELECT + WHERE-CLAUSE !!

select * from information_schema.columns where table_name='UTBLOB'

select * from sc_unilab_ens."UTBLOB" limit 1;;
select "ID", "URL", "DATA"  from "UTBLOB" where "ID" = '2023-0123-0027#BLB' ;


select "OBJECT_ID" from sc_interspec_ens."ITOIRAW" i where "OBJECT_ID" = 213 limit 1;


