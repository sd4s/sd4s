--OVERZICHT van tabellen zonder een PK

--*************************************************************************************************
--*************************************************************************************************
--UNILAB:
--*************************************************************************************************
--*************************************************************************************************
select * from dba_aws_supplemental_log where asl_pk_exists_jn = 'N' ORDER by asl_table_name;
3	UNILAB	ATICTRHS		N	ALL	J	23-10-2021 09:25:27	
4	UNILAB	ATMETRHS		N	ALL	J	23-10-2021 09:25:27	
5	UNILAB	ATPATRHS		N	ALL	J	23-10-2021 09:25:27	
6	UNILAB	ATRQTRHS		N	ALL	J	23-10-2021 09:25:27	
7	UNILAB	ATSCTRHS		N	ALL	J	23-10-2021 09:25:27	
17	UNILAB	UTSCMEHS		N	ALL	J	23-10-2021 09:25:27	
55	UNILAB	UTLCHS			N	ALL	J	23-10-2021 09:25:27	
63	UNILAB	UTMTHS			N	ALL	J	23-10-2021 09:25:27	
70	UNILAB	UTPRHS			N	ALL	J	23-10-2021 09:25:27	
88	UNILAB	UTRQHS			N	ALL	J	23-10-2021 09:25:27	
120	UNILAB	UTSCHS			N	ALL	J	23-10-2021 09:25:27	
146	UNILAB	UTSCPAHS		N	ALL	J	23-10-2021 09:25:27	
158	UNILAB	UTSTHS			N	ALL	J	23-10-2021 09:25:27	
193	UNILAB	UTWSHS			N	ALL	J	23-10-2021 09:25:27	
194	UNILAB	UTWSII			N	ALL	J	23-10-2021 09:25:27	
195	UNILAB	UTWSME			N	ALL	J	23-10-2021 09:25:27	
206	UNILAB	UTSCMEHSDETAILS	N	ALL	J	23-10-2021 09:25:27	
225	UNILAB	ATAOACTIONS		N	ALL	J	23-10-2021 09:25:27	
226	UNILAB	ATAOCONDITIONS	N	ALL	J	23-10-2021 09:25:27	

select * 
from dba_aws_supplemental_count A
where exists (select asl_table_name from dba_aws_supplemental_log l where l.asl_table_name = a.asc_table_name and l.asl_pk_exists_jn = 'N')
ORDER BY a.asc_table_name
;
410	UNILAB	ATAOACTIONS		23-10-2021 10:43:25	71	
411	UNILAB	ATAOCONDITIONS	23-10-2021 10:43:25	100	
237	UNILAB	ATICTRHS		23-10-2021 09:34:35	0	
238	UNILAB	ATMETRHS		23-10-2021 09:35:04	11727424	
239	UNILAB	ATPATRHS		23-10-2021 09:37:30	66565994	
240	UNILAB	ATRQTRHS		23-10-2021 09:37:46	6222915	
241	UNILAB	ATSCTRHS		23-10-2021 09:38:02	7553086	
281	UNILAB	UTLCHS			23-10-2021 09:55:04	3011	
285	UNILAB	UTMTHS			23-10-2021 09:55:06	120861	
291	UNILAB	UTPRHS			23-10-2021 09:56:14	217244	
309	UNILAB	UTRQHS			23-10-2021 09:56:29	10383407	
338	UNILAB	UTSCHS			23-10-2021 10:05:22	137199564	
250	UNILAB	UTSCMEHS		23-10-2021 09:48:44	160134513	
409	UNILAB	UTSCMEHSDETAILS	23-10-2021 10:43:25	338980250	
359	UNILAB	UTSCPAHS		23-10-2021 10:18:33	169218999	
369	UNILAB	UTSTHS			23-10-2021 10:19:44	1672140	
404	UNILAB	UTWSHS			23-10-2021 10:19:48	1127761	
405	UNILAB	UTWSII			23-10-2021 10:19:48	48568	
406	UNILAB	UTWSME			23-10-2021 10:19:48	9773	


--*************************************************************************************************
--*************************************************************************************************
--INTERSPEC:
--*************************************************************************************************
--*************************************************************************************************
select * from dba_aws_supplemental_log where asl_pk_exists_jn = 'N' ORDER by asl_table_name;


35	INTERSPC	ITBOMLYSOURCE	N	ALL	J	23/10/2021 10:02:01
60	INTERSPC	ITUP			N	ALL	J	23/10/2021 10:02:01
12	INTERSPC	SPECDATA		N	ALL	J	23/10/2021 10:02:01

select * 
from dba_aws_supplemental_count A
where A.asc_table_name in ('ITBOMLYSOURCE','ITUP','SPECDATA');

149	INTERSPC	SPECDATA		23/10/2021 10:51:45	148825863
168	INTERSPC	ITBOMLYSOURCE	23/10/2021 10:51:59	28
191	INTERSPC	ITUP			23/10/2021 10:52:00	0

--

--einde script

