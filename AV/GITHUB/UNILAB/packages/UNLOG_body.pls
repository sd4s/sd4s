create or replace PACKAGE BODY        unlog AS
--
procedure test_plan
  (p_rec in utassignfulltestplan_tmp%rowtype)
is
  pragma autonomous_transaction;
  --
  r_rec utassignfulltestplan_tmp%rowtype := p_rec;
begin
  select count(0)
  into   r_rec.no_of_records
  from   utassignfulltestplan;
  --
  insert into unilab.utassignfulltestplan_tmp
  values r_rec;
  --
  commit;
end;
--
END unlog;