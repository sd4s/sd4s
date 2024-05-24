--***********************************************
--***********************************************
--select the tyres...
--***********************************************
--***********************************************
select dwc.mainpart, dwc.mainframeid, dwc.part_no, dwc.revision, dwc.header_issueddate, dwc.comp_part_eenheid_kg, count(distinct dwc.mainpart)
from dba_weight_component_part dwc
where dwc.HEADER_issueddate > to_date('01-02-2023 01:00:00','dd-mm-yyyy hh24:mi:ss')
and   dwc.HEADER_issueddate < to_date('08-02-2023 01:00:00','dd-mm-yyyy hh24:mi:ss')
and   dwc.DATUM_VERWERKING     > to_date('01-02-2023 01:00:00','dd-mm-yyyy hh24:mi:ss')
and   dwc.component_part_no is null
and   (   dwc.comp_part_eenheid_kg <> (select distinct dwc2.comp_part_eenheid_kg 
                                       from   dba_weight_component_part dwc2
								   where dwc2.mainpart = dwc.mainpart
								   and   dwc2.component_part_no is null
								   and   dwc2.datum_verwerking = (select max(dwc3.datum_verwerking)
								                                  from dba_weight_component_part dwc3
																  where dwc3.mainpart = dwc.mainpart
																  and   dwc3.datum_verwerking < dwc.datum_verwerking
																 )
                                  )
      or  not exists (select ''
	                  from dba_weight_component_part dwc4
					  where dwc4.mainpart = dwc.mainpart
					  and   dwc4.datum_verwerking < dwc.datum_verwerking
					 )
      )	  
group by dwc.mainpart, dwc.mainframeid, dwc.part_no, dwc.revision, dwc.header_issueddate, dwc.comp_part_eenheid_kg
order by dwc.mainpart, dwc.mainframeid, dwc.part_no, dwc.revision, dwc.header_issueddate, dwc.comp_part_eenheid_kg
;

--***********************************************
--***********************************************
--select COMPONENTS
--***********************************************
--***********************************************
select dwc.component_part_no, dwc.component_revision, dwc.component_issueddate, dwc.comp_part_eenheid_kg, count(distinct dwc.mainpart)
from dba_weight_component_part  dwc
where dwc.component_issueddate > to_date('01-02-2023 01:00:00','dd-mm-yyyy hh24:mi:ss')
and   dwc.component_issueddate < to_date('08-02-2023 01:00:00','dd-mm-yyyy hh24:mi:ss')
and   dwc.DATUM_VERWERKING     > to_date('01-02-2023 01:00:00','dd-mm-yyyy hh24:mi:ss')
and   (   dwc.comp_part_eenheid_kg <> (select distinct dwc2.comp_part_eenheid_kg 
                                       from   dba_weight_component_part dwc2
			     					   where dwc2.component_part_no = dwc.component_part_no
				        			   and   dwc2.datum_verwerking = (select max(dwc3.datum_verwerking)
							    	                                  from dba_weight_component_part dwc3
								    								  where dwc3.component_part_no = dwc.component_part_no
									     							  and   dwc3.datum_verwerking < dwc.datum_verwerking
										    						 )
                                  )
      or  not exists (select ''
	                  from dba_weight_component_part dwc4
					  where dwc4.component_part_no = dwc.component_part_no
					  and   dwc4.datum_verwerking < dwc.datum_verwerking
					 )
      )	  
group by component_part_no, component_revision, component_issueddate, comp_part_eenheid_kg
order by component_part_no, component_revision, component_issueddate, comp_part_eenheid_kg
;
