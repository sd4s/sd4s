-- Get all keywords from all frames
--select xmltype(cursor(
select fh.frame_no, fk.kw_id, kw.kw_type,
       case when kw.kw_type = 0 then 'Free Data'
            when kw.kw_type = 1 then 'List'
            when kw.kw_type = 2 then 'External Data'
            else 'NULL'
       end KW_Type_Descr
       , kw.description, fk.kw_value
  from frame_header fh, frame_kw fk, itkw kw
where fh.frame_no      like 'A_RM_%'
   and fh.status           = 2  -- Current   
   and fk.frame_no         = fh.frame_no
   and kw.kw_id            = fk.kw_id
   order by 1, 5, 6
--)).getClobVal() xdoc from dual
   ;
   
-- list all values per keywords (if keyword is of type list)
-- so all charcteristics of keywords of type = list
--select xmltype(cursor(
select kw.kw_id, kw.description KW_List, 
case when kw.kw_usage = 1 then 'Linked with specification'
     when kw.kw_usage = 2 then 'Linked with reference text'
     when kw.kw_usage = 3 then 'Linked with Object'
     when kw.kw_usage = 4 then 'Linked with Manufacturer'
     when kw.kw_usage = 5 then 'Linked with Plant'
     else 'NULL'
     end KW_Usage, 
kas.ch_id, ch.description KW_Value
  from itkwas kas, itkw kw, itkwch ch
-- where kas.kw_id = 700706
where kw.kw_id = kas.kw_id
   and ch.ch_id = kas.ch_id
   order by 1
--)).getClobVal() xdoc from dual
   ;
