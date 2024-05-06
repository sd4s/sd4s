-- Get list of CoA test performed with their limits
 select r.sc
 , m.value material
 , v.iivalue vendor_code, r.pa parameter, r.description, s.description Status, r.unit, r.value_f measured, l.low_spec, l.target, l.high_spec, r.exec_start_date
   from utscpa r
   , utscpaspa l
   , utscgk m
   , utscii v
   , utss s
  where r.sc like '2%'
    and r.pg = 'CoA'
    and l.sc = r.sc
    and l.pg = r.pg
    and l.pa = r.pa
    and l.panode = r.panode
    and m.sc = r.sc
    and m.gk = 'PART_NO'
    and v.sc = r.sc
    and v.ii = 'avSupplierCode'
    and s.ss = r.ss
    ;