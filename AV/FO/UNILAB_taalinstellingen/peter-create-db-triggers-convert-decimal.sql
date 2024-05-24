--
--CREATE TRIGGER TBV OMZETTEN VAN DECIMAL-KOMMA'S NAAR DECIMAL-POINTS
--UTSCMECELL.VALUE_F
--UTSCMECELL.VALUE_S

--****************************************************************
--****************************************************************
-- UTSCPA
--****************************************************************
--****************************************************************
create or replace TRIGGER UNILAB.UT_PA_POINT_BRIU_TR
BEFORE INSERT or UPDATE ON UNILAB.UTSCPA
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  --
  IF  REGEXP_LIKE(:new.value_s, '^-?\d+,\d+$') 
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+,\d+,') 
  THEN
    --We gaan eerst proberen om string direct in number om te zetten
	--Indien taalinstelling = NL, en string een komma bevat
	IF :NEW.VALUE_F IS NULL
	THEN
	  begin
        :NEW.VALUE_F := to_number(:NEW.value_s);
	  exception
	    when others 
		then null;
	  end;
	END IF;
    --convert decimal-komma by point
	:NEW.VALUE_S := REGEXP_REPLACE (:NEW.value_s, ',', '.' );
	--
    IF :NEW.VALUE_F IS NULL
	THEN
	  begin
        :NEW.VALUE_F := to_number(REGEXP_REPLACE (:NEW.value_s, ',', '.' ) );
	  exception
	    when others 
		then null;
	  end;
	END IF;
    add_autonomous_debug (p_table => 'UTSCPA'
	                     ,p_message => 'Trigger-Update REGEXP-REPLACE POINT EXECUTOR: '||:new.executor||' NUMBER-value: '||:new.value_F||' string-value: '||:new.value_s
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_ss_to => :new.ss
                         );
  END IF;
  --Indien value_s IS GEVULD met number, maar value_F is leeg dan kunnen we VALUE_F ook met zelfde waarde vullen
  if      (  REGEXP_LIKE(:new.value_s, '^-?\d+.\d+$')  
          or REGEXP_LIKE(:new.value_s, '^-?\d+$') 
		  )
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+.\d+.') 
  then 
    IF :NEW.VALUE_F is null
	then 
	  begin
 	    :new.value_f := to_number(REGEXP_REPLACE (:NEW.value_s, ',', '.' ) );
         add_autonomous_debug (p_table => 'UTSCPA'
	                     ,p_message => 'Trigger-Update REGEXP-REPLACE POINT EXECUTOR: '||:new.executor||' FILL-MISSING-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_ss_to => :new.ss
                         );
	  exception
	    when others
		then 
          add_autonomous_debug (p_table => 'UTSCPA'
	                     ,p_message => 'Trigger-ERROR EXECUTOR: '||:new.executor||' FILL-MISSING-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s||' (err='||sqlerrm||')'
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_ss_to => :new.ss
                         );
      end;
      --					 
	end if;   --value_f is null
  end if;   --VALUE_S = number
  --
EXCEPTION
  WHEN OTHERS
  THEN NULL;
    add_autonomous_debug (p_table => 'UTSCPA'
	                     ,p_message => 'Trigger-ERROR REGEXP-REPLACE POINT NUM-value: '||:new.value_f||' string-value: '||:new.value_s||' (err='||sqlerrm||')'
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_ss_to => :new.ss
                         );
END ut_pa_point_briu_tr;
/

/*
--test/controle:
insert into utscpa (sc, pg, pgnode, pa, panode,   td_info, delay, min_nr_results, value_s, value_f)
values ('-1','-1','-1','-1','-1',                 '-1','-1','-1','123,45', null);
select * from utscpa where sc = '-1';

insert into utscpa (sc, pg, pgnode, pa, panode,   td_info, delay, min_nr_results, value_s, value_f)
values ('-2','-2','-2','-2','-2',                 '-2','-2','-2','123,45', '456.78');
select * from utscpa where sc = '-2';

select * from atdebug where sc = '-1';
*/

--****************************************************************
--****************************************************************
-- UTSCME
--****************************************************************
--****************************************************************
create or replace TRIGGER UNILAB.UT_ME_POINT_BRIU_TR
BEFORE INSERT or UPDATE ON UNILAB.UTSCME
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  --
  IF  REGEXP_LIKE(:new.value_s, '^-?\d+,\d+$') 
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+,\d+,') 
  THEN
    --We gaan eerst proberen om string direct in number om te zetten
	--Indien taalinstelling = NL, en string een komma bevat
	IF :NEW.VALUE_F IS NULL
	THEN
	  begin
        :NEW.VALUE_F := to_number(:NEW.value_s);
	  exception
	    when others 
		then null;
	  end;
	END IF;
    --convert decimal-komma by point
	:NEW.VALUE_S := REGEXP_REPLACE (:NEW.value_s, ',', '.' );
	--
    IF :NEW.VALUE_F IS NULL
	THEN
	  begin
        :NEW.VALUE_F := to_number(REGEXP_REPLACE (:NEW.value_s, ',', '.' ) );
	  exception
	    when others 
		then null;
	  end;
	END IF;
    add_autonomous_debug (p_table => 'UTSCME'
	                     ,p_message => 'Trigger-Update REGEXP-REPLACE POINT EXECUTOR: '||:new.executor||' NUMBER-value: '||:new.value_F||' string-value: '||:new.value_s
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         ,p_ss_to => :new.ss
                         );
    --
  END IF;
  --Indien value_s IS GEVULD met number, maar value_F is leeg dan kunnen we VALUE_F ook met zelfde waarde vullen
  if      (  REGEXP_LIKE(:new.value_s, '^-?\d+.\d+$')  
          or REGEXP_LIKE(:new.value_s, '^-?\d+$') 
		  )
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+.\d+.') 
  then 
    IF :NEW.VALUE_F is null
	then 
	  begin
	    :new.value_f := to_number(REGEXP_REPLACE (:NEW.value_s, ',', '.' ) );
        add_autonomous_debug (p_table => 'UTSCME'
	                     ,p_message => 'Trigger-Update REGEXP-REPLACE POINT EXECUTOR: '||:new.executor||' FILL-MISSING-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         ,p_ss_to => :new.ss
                         );
	  exception
	    when others
		then 
          add_autonomous_debug (p_table => 'UTSCME'
	                     ,p_message => 'Trigger-ERROR EXECUTOR: '||:new.executor||' FILL-MISSING-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s||' (err='||sqlerrm||')'
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         ,p_ss_to => :new.ss
                         );
      end;
	  --				 
	end if;   --value_f is null
  end if;   --VALUE_S = number
  --
EXCEPTION
  WHEN OTHERS
  THEN NULL;
    add_autonomous_debug (p_table => 'UTSCME'
	                     ,p_message => 'Trigger-ERROR REGEXP-REPLACE POINT num_value: '||:new.value_f||' string-value: '||:new.value_s||' (err='||sqlerrm||')'
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         ,p_ss_to => :new.ss
                         );
END;
/

--****************************************************************
--****************************************************************
-- UTSCMECELL
--****************************************************************
--****************************************************************
create or replace TRIGGER UNILAB.UT_MECELL_POINT_BRIU_TR
BEFORE INSERT or UPDATE ON UNILAB.UTSCMECELL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  --
  IF  REGEXP_LIKE(:new.value_s, '^-?\d+,\d+$') 
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+,\d+,') 
  THEN
    --We gaan eerst proberen om string direct in number om te zetten
	--Indien taalinstelling = NL, en string een komma bevat
	IF :NEW.VALUE_F IS NULL
	THEN
	  begin
        :NEW.VALUE_F := to_number(:NEW.value_s);
	  exception
	    when others 
		then null;
	  end;
	END IF;
    --convert value_S decimal-komma by point
	:NEW.VALUE_S := REGEXP_REPLACE (:NEW.value_s, ',', '.' );
	--
    --Indien VALUE_S nog leeg is dan proberen om string alsnog in number om te zetten
	--String bevat nu een POINT 
	IF :NEW.VALUE_F IS NULL
	THEN
	  begin
        :NEW.VALUE_F := to_number(REGEXP_REPLACE (:NEW.value_s, ',', '.' ) );
	  exception
	    when others 
		then null;
	  end;
	END IF;
    add_autonomous_debug (p_table => 'UTSCMECELL'
	                     ,p_message => 'Trigger-Update REGEXP-REPLACE POINT  mecell: '||:new.cell||' NUMBER-value: '||:new.value_F||' string-value: '||:new.value_s
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         );
    --
  END IF;
  --Indien value_s IS GEVULD met number, maar value_F is leeg dan kunnen we VALUE_F ook met zelfde waarde vullen
  if      (  REGEXP_LIKE(:new.value_s, '^-?\d+\.\d+$')  
          or REGEXP_LIKE(:new.value_s, '^-?\d+$') 
		  )
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+\.\d+\.') 
  then 
    IF :NEW.VALUE_F is null
	then 
	  begin
	    :new.value_f := to_number(REGEXP_REPLACE (:NEW.value_s, ',', '.' ) );
        add_autonomous_debug (p_table => 'UTSCMECELL'
	                     ,p_message => 'Trigger-Update CELL: '||:new.cell||' FILL-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         );
	  exception
	    when others
		then 
          add_autonomous_debug (p_table => 'UTSCMECELL'
	                     ,p_message => 'Trigger-ERROR cell: '||:new.cell||' FILL-MISSING-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s||' (err='||sqlerrm||')'
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         );
      end;
	end if;   --value_f is null
  end if;   --VALUE_S = number
  --
EXCEPTION
  WHEN OTHERS
  THEN NULL;
    add_autonomous_debug (p_table => 'UTSCMECELL'
	                    ,p_message => 'Trigger-ALG-EXCP-ERROR REGEXP-REPLACE POINT mecell: '||:new.cell||' num-value: '||:new.value_F||' string-value: '||:new.value_s||' (err='||sqlerrm||')'
                        ,p_sc => :new.sc
                        ,p_pg => :new.pg
                        ,p_pgnode => :new.pgnode
                        ,p_pa => :new.pa
                        ,p_panode => :new.panode
                        ,p_me => :new.me
                        ,p_menode => :new.menode
                        );
END;
/

/*
--11004201	14-12-2023 16:26:08	INF	Trigger-ERROR REGEXP-REPLACE POINT mecell: E_min value: 484.00				UTSCMECELL	RAG	RAG2350001T02	Indoor testing	2000000	TT761AX	1000000	TT761A	3000000		
--11004202	14-12-2023 16:26:08	INF	Trigger-Update REGEXP-REPLACE POINT  mecell: E_mean string-value: 514.80	UTSCMECELL	RAG	RAG2350001T02	Indoor testing	2000000	TT761AX	1000000				
--11004203	14-12-2023 16:26:08	INF	Trigger-ERROR REGEXP-REPLACE POINT mecell: E_max value: 540.00				UTSCMECELL	RAG	RAG2350001T02	Indoor testing	2000000	TT761AX	1000000	TT761A	3000000		

select SC, VALUE_F, VALUE_S, REGEXP_REPLACE (value_s, ',', '.' ) VALUE_S_CORR from utscmecell where sc = 'RAG2350001T02' and pg='Indoor testing' and pgnode='2000000' and pa = 'TT761AX' and panode = '1000000' and me = 'TT761A' and menode = '3000000' and cell='E_min';
--update utscmecell set value_f = null  where sc = 'RAG2350001T02' and pg='Indoor testing' and pgnode='2000000' and pa = 'TT761AX' and panode = '1000000' and me = 'TT761A' and menode = '3000000' and cell='E_min';
update utscmecell set value_s = '484.00' where sc = 'RAG2350001T02' and pg='Indoor testing' and pgnode='2000000' and pa = 'TT761AX' and panode = '1000000' and me = 'TT761A' and menode = '3000000' and cell='E_min';

select * from utscmecell where sc = 'RAG2350001T02' and pg='Indoor testing' and pgnode='2000000' ;
RAG2350001T02	Indoor testing	2000000	TT761AX	1000000	TT761A	3000000	0	E_max	26000000	E(max)				540.00	K	162	525	L	10	1	0	0	0	Ncm		-			C	Maximum(E_1,E_2,E_3,E_4,E_5)		1	1	0
RAG2350001T02	Indoor testing	2000000	TT761AX	1000000	TT761A	3000000	0	E_mean	25000000	E(mean)		514.8	514.80	K	162	500	L	10	1	0	0	0	Ncm		-			C	Average(E_1,E_2,E_3,E_4,E_5)		1	1	0
RAG2350001T02	Indoor testing	2000000	TT761AX	1000000	TT761A	3000000	0	E_min	24000000	E(min)				484.00	K	162	475	L	10	1	0	0	0	Ncm		-			C	Minimum(E_1,E_2,E_3,E_4,E_5)		1	1	0
*/

/*
RAG2350001T05	Indoor testing	2000000	TT761AX	1000000	TT761A	3000000	0	E_max	26000000	E(max)		515.00	K	162	525	L	10	1	0	0	0	Ncm		-			C	Maximum(E_1,E_2,E_3,E_4,E_5)		1	1	0
RAG2350001T05	Indoor testing	2000000	TT761AX	1000000	TT761A	3000000	0	E_min	24000000	E(min)		480.00	K	162	475	L	10	1	0	0	0	Ncm		-			C	Minimum(E_1,E_2,E_3,E_4,E_5)		1	1	0

--error on string-values with .00 as decimals


*/

--****************************************************************
--****************************************************************
-- UTSCMECELLLIST
--****************************************************************
--****************************************************************
create or replace TRIGGER UNILAB.UT_MECELLLIST_POINT_BRIU_TR
BEFORE INSERT or UPDATE ON UNILAB.UTSCMECELLLIST
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  --
  IF  REGEXP_LIKE(:new.value_s, '^-?\d+,\d+$') 
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+,\d+,') 
  THEN
    --We gaan eerst proberen om string direct in number om te zetten
	--Indien taalinstelling = NL, en string een komma bevat
	IF :NEW.VALUE_F IS NULL
	THEN
	  begin
        :NEW.VALUE_F := to_number(:NEW.value_s);
	  exception
	    when others 
		then null;
	  end;
	END IF;
    --convert value_S decimal-komma by point
	:NEW.VALUE_S := REGEXP_REPLACE (:NEW.value_s, ',', '.' );
	--
    --Indien VALUE_S nog leeg is dan proberen om string alsnog in number om te zetten
	--String bevat nu een POINT 
	IF :NEW.VALUE_F IS NULL
	THEN
	  begin
	    :new.value_f := to_number(:new.value_s);
	  exception
	    when others
		then null;
      end;
    END IF;	
    add_autonomous_debug (p_table => 'UTSCMECELLLIST'
	                     ,p_message => 'Trigger-Update REGEXP-REPLACE POINT cell: '||:new.cell||'(xy: '||:new.index_x||'-'||:new.index_y||') num-value: '||:new.value_f||' string-value: '||:new.value_S
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         );
    --
  END IF;
  --Indien value_s IS GEVULD met number, maar value_F is leeg dan kunnen we VALUE_F ook met zelfde waarde vullen
  if      (  REGEXP_LIKE(:new.value_s, '^-?\d+\.\d+$')  
          or REGEXP_LIKE(:new.value_s, '^-?\d+$') 
		  )
  AND NOT REGEXP_LIKE(:new.value_s, '^-?\d+\.\d+\.') 
  then 
    IF :NEW.VALUE_F is null
	then 
	  begin
         :new.value_f := to_number(:new.value_s);
         add_autonomous_debug (p_table => 'UTSCMECELLLIST'
	                     ,p_message => 'Trigger-Update REGEXP-REPLACE POINT EXECUTOR: '||:new.cell||'(xy: '||:new.index_x||'-'||:new.index_y||') FILL-MISSING-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         );
	  exception
	    when others
		then 
          add_autonomous_debug (p_table => 'UTSCMECELLLIST'
	                     ,p_message => 'Trigger-ERROR cell: '||:new.cell||'(xy: '||:new.index_x||'-'||:new.index_y||') FILL-MISSING-NUMBER-value: '||:new.value_F||' with string-value: '||:new.value_s||' (err='||sqlerrm||')'
                         ,p_sc => :new.sc
                         ,p_pg => :new.pg
                         ,p_pgnode => :new.pgnode
                         ,p_pa => :new.pa
                         ,p_panode => :new.panode
                         ,p_me => :new.me
                         ,p_menode => :new.menode
                         );
       end;
	   --
	end if;   --value_f is null
  end if;   --VALUE_S = number
  --
EXCEPTION
  WHEN OTHERS
  THEN NULL;
      add_autonomous_debug (p_table => 'UTSCMECELLLIST'
	          ,p_message => 'Trigger-ERROR REGEXP-REPLACE POINT mecellLIST: '||:new.cell||'(xy: '||:new.index_x||'-'||:new.index_y||') num-value: '||:new.value_f||' string-value: '||:new.value_s||' (err='||sqlerrm||')'
              ,p_sc => :new.sc
              ,p_pg => :new.pg
              ,p_pgnode => :new.pgnode
              ,p_pa => :new.pa
              ,p_panode => :new.panode
			  ,p_me => :new.me
			  ,p_menode => :new.menode
			  );
END;
/


--einde script

