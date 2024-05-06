--hoe ziet sequence er uit?
select * from all_sequences where sequence_name like 'UTERROR_SEQ';

--alter sequence UTERROR_SEQ
alter sequence UTERROR_SEQ  MAXVALUE 999999999999999;
alter sequence UTERROR_SEQ NOCYCLE ORDER ;



create or replace TRIGGER UNILAB.UT_ERROR_BRI
BEFORE INSERT  ON UNILAB.UTERROR 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  if :new.err_seq is null
  then select uterror_seq.nextval into :new.err_seq from dual;
  end if;
  --
  --Stond  in PROD-omgeving niet aan (dd. 11-11-2021)... Vanaf nu weer wel.
  if :new.error_msg LIKE '%ORA-0%' then
      add_debug
        (p_table => 'UTERROR'
        ,p_message => :new.error_msg
        ,p_sc => null
        ,p_pg => null
        ,p_pgnode => null
        ,p_pa => null
        ,p_panode => null
        ,p_me => null
        ,p_menode => null
        ,p_ss_from => null
        ,p_ss_to => null);
   end if;
END;
/

/*
--ONDERZOEK PERFORMANCE TIJDENS SUB-SAMPLEN... RONDOM DEZE QUERIES CUSTOMSQL LOPEN WE ERGENS EEN VERTRAGING VAN ONGEVEER 30SEC. OP....

--ET Execute 
SELECT UVRQII.IIVALUE 
FROM UVSC, UVRQIC, UVRQII, UVRQ 
WHERE (UVRQ.RQ=UVRQIC.RQ) 
AND (UVRQIC.RQ=UVRQII.RQ 
and UVRQIC.IC=UVRQII.IC 
and UVRQIC.ICNODE=UVRQII.ICNODE) 
AND (UVRQ.RQ=UVSC.RQ) 
AND (UVSC.SC='21.148.PSC02.Y2.FR') 
AND ((UVSC.SC like '%.FL' and UVRQII.II='RimETfront') 
    OR (UVSC.SC like '%.FR' and UVRQII.II='RimETfront') 
	OR (UVSC.SC like '%.RL' and UVRQII.II='RimETrear') 
	OR (UVSC.SC like '%.RR' and UVRQII.II ='RimETrear'))

--null, wel snel
SELECT PART_NO FROM UVSCGKPART_NO   
WHERE SC = '21.148.PSC02.Y2.FL' 


SELECT me 
FROM utscmeau 
WHERE sc = '21.148.PSC05.Y2.FL' 
AND pg = ANSI ('Mounting') 
AND pgnode = 1000000 
AND pa = ANSI ('Mounting') 
AND panode = 1000000 
AND au = 'avCustWaitFor' 
AND value = ANSI ('TP800A1')

SELECT a.description 
FROM utmt a, utscmecell b  
WHERE sc = '21.148.PSC05.Y2.FL' 
AND pg = ANSI ('Mounting') 
AND pgnode = 1000000 
AND pa = ANSI ('Mounting') 
AND panode = 1000000 
AND me = ANSI ('TP800A1') 
AND menode = 1000000 AND b.cell = 'nextMt' 
AND a.mt = b.value_s AND a.version_is_current = 1
*/

