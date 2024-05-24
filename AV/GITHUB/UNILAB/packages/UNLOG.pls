create or replace PACKAGE        unlog AS
--
procedure test_plan
  (p_rec in utassignfulltestplan_tmp%rowtype);

END unlog;