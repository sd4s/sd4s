--Match grondstoffen-part-no met sap-article-codes
--Based on SQLSERVER17-vertaaltabel: saparticlecodes

--current INTERSPEC-ARTICLE-CODE has syntax: 'GR_5711_BMZ_BMZ'
--migration-steps: 
--1)replace "GR_" with E1 so:  GR_5711_BMZ_BMZ  becomes E15711_BMZ_BMZ
--2)trunc result-tmp-part-no after and including first "underscore" (substr(E15711_BMZ_BMZ , 1, instr(E15711_BMZ_BMZ,'_')-1)  so:   E15711_BMZ_BMZ  becomes E15711
--3)search with this values an interspec_articlecode in coa_saparticlecodes without at last position added letter (A/B/C etc)
--  Use a like-operator in this case, so:   coa_saparticlecodes.interspec_articlecode like replace(COA_VW_VENDOR_QUALITY.part_no,'GR_','E1')||'%'

DROP VIEW sc_lims_dal.coa_vw_saparticlecodes;

CREATE OR REPLACE VIEW sc_lims_dal.coa_vw_saparticlecodes
(interspec_e1_articlecode
,sap_articlecode
)
AS
select s.oldarticlecode
,      s.newarticlecode
from sc_unilab_ens.saparticlecodes s
;

grant all on  sc_lims_dal.coa_vw_saparticlecodes   to usr_rna_readonly1;


--
--example-query which replaces the INTERSPEC-PART-NO with SAP-ARTICLECODE:
--CREATE OR REPLACE VIEW sc_lims_dal.coa_vw_saparticlecodes
CREATE OR REPLACE VIEW sc_lims_dal.COA_VW_VENDOR_QUALITY_NW
(request_code
,sample_code
,interspec_part_no
,INTERSPEC_tmp_e1_part_no
,interspec_tmp_e1_oldarticlecode
,sap_articlecode
,part_no
,part_no_description
,productiondate
,un_supplier_code   
,is_supplier
,order_number
,parameter
,parameter_descr
,ResultParameterstatus
,ResultParameterStatusName
,unit
,results
,low_spec
,target
,high_spec
,test_date
)
AS
select sc.rq     as request_code
, sc.sc          as sample_code
, gk.value                                                                                        as interspec_part_no
, replace(gk.value,'GR_','E1')                                                                    AS INTERSPEC_tmp_e1_part_no
, SUBSTRING(replace(gk.value,'GR_','E1'), 1, position( '_' in replace(gk.value,'GR_','E1') )-1 )  as interspec_tmp_e1_oldarticlecode
, sa.sap_articlecode                                                                              as sap_articlecode
,case when sa.sap_articlecode is not null
      then sa.sap_articlecode
      else gk.value 
 end                                                                                              as part_no
, p.description   as part_no_description
, iip.iivalue     as productiondate
, iis.iivalue     as un_supplier_code   
, mfc.description as is_Supplier     --MANUFACTURER
, iio.iivalue     as order_number
, pa.pa           as parameter
, pa.description  as parameter_descr
, pa.ss           as ResultParameterstatus
, s.description   as ResultParameterStatusName
, pa.unit         as unit
, pa.value_f      as results
, spa.low_spec
, spa.target
, spa.high_spec
, pa.exec_end_date as test_date
from sc_unilab_ens.utsc      sc
JOIN sc_unilab_ens.utscpa    pa  on (pa.sc = sc.sc)
JOIN sc_unilab_ens.utss      s   ON (s.ss  = pa.ss)
JOIN sc_unilab_ens.utscpaspa spa on (spa.sc = pa.sc  and spa.pg = pa.pg and spa.pa = pa.pa and spa.panode = pa.panode)
JOIN sc_unilab_ens.utscgk    gk  on (gk.sc = pa.sc and gk.gk = 'PART_NO' )
LEFT OUTER JOIN sc_interspec_ens.part        p   on (p.part_no = gk.value)
left outer join sc_interspec_ens.itprmfc   pmf   on (pmf.part_no  = p.part_no)
left outer join sc_interspec_ens.ITMFC     mfc   on (mfc.mfc_id = pmf.mfc_id)
LEFT OUTER JOIN sc_unilab_ens.utscii  iis  on (iis.sc = pa.sc and iis.ii = 'avSupplierCode' )
LEFT OUTER JOIN sc_unilab_ens.utscii  iip  on (iip.sc = pa.sc and iip.ii = 'avProductionDate' )
LEFT OUTER JOIN sc_unilab_ens.utscii  iio  on (iio.sc = pa.sc and iio.ii = 'avOrderno' )
left outer join sc_lims_dal.coa_vw_saparticlecodes sa on (sa.interspec_e1_articlecode||'' like SUBSTRING(replace(gk.value,'GR_','E1'), 1, position( '_' in replace(gk.value,'GR_','E1') )-1 ) || '%')
where pa.pg  = 'CoA'
;

grant all on  sc_lims_dal.COA_VW_VENDOR_QUALITY_NW   to usr_rna_readonly1;


select * from sc_lims_dal.COA_VW_VENDOR_QUALITY_NW
where sample_code = '2001000016'


/*
--query tbv testing...
SELECT v.request_code
,v.sample_code
,v.part_no                       as interspec_part_no
,replace(v.part_no,'GR_','E1')   AS INTERSPEC_tmp_e1_part_no
,SUBSTRING(replace(v.part_no,'GR_','E1'), 1, position( '_' in replace(v.part_no,'GR_','E1') )-1 )  as interspec_tmp_e1_oldarticlecode
,sa.sap_articlecode              as sap_articlecode
,case when sa.sap_articlecode is not null
      then sa.sap_articlecode
      else v.part_no 
 end                               as part_no
,v.part_no_description
,v.productiondate
,v.un_supplier_code   
,v.is_supplier
,v.order_number
,v.parameter
,v.parameter_descr
,v.ResultParameterstatus
,v.ResultParameterStatusName
,v.unit
,v.results
,v.low_spec
,v.target
,v.high_spec
,v.test_date
from sc_lims_dal.COA_VW_VENDOR_QUALITY  v
left outer join sc_lims_dal.coa_vw_saparticlecodes sa on (sa.interspec_oldarticlecode||'' like SUBSTRING(replace(v.part_no,'GR_','E1'), 1, position( '_' in replace(v.part_no,'GR_','E1') )-1 ) || '%')
where v.sample_code = '2001000016'
;
*/

--


