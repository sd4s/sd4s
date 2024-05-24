--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function MEDIAN2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."MEDIAN2" (p_string in varchar2) 
return float is
  l_string varchar2(32767);
  l_index pls_integer := 1;
  l_value varchar2(100);
  l_median number;
  l_query varchar2(32767);
begin
  l_string := replace(p_string, ',', '.');
  
  loop
    l_value := regexp_substr(l_string, '([0-9.]*)#', 1, l_index, '', 1);
    exit when l_value is null;

    if l_query is not null
    then
      l_query := l_query||' union all ';
    end if;

    l_query := l_query||'select '||l_value||' v from dual';

    l_index := l_index + 1;
  end loop;

  if l_query is not null
  then
    execute immediate 'select median(v) from ('||l_query||')'
    into l_median;
  end if;

  return l_median;
end;

/
