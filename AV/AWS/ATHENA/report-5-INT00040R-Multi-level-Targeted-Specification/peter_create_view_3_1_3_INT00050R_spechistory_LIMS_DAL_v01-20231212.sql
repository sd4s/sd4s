--UNI00040R MULTI LEVEL TARGETED SPECIFICATION
--(athena: [product&proces development] + [specifications] + [multi-level targeted specifications]
--(SPEC-HISTORY: INT00050R_spechistory)
--
--Create VIEWS MULTI-LEVEL-TARGET
--test-object: XGF_BF66A17J1   --only part-no + properties (no BOM-info + ASSEMBLY-properties)
--             XGV_BF66A17J1   --only part-no + properties (no BOM-info + assembly-properties)
--             XGG_BF66A17J1   --ALL: part-no + BOM-info + ASSEMBLY-properties + properties !!!!!
--
--             GF_1856015ULAXH --only part-no + properties (no BOM-info + assembly-properties)
--             GG_186015ULAXH  --ALL: part-no + BOM-info + ASSEMBLY-properties + properties !!!!!
--
--             EF_145/60-20-SM  --NO template aanwezig, REPORT crashed...
--             EV_145/60-20-SM  --NO template aanwezig, REPORT crashed...
--             EG_145/60-20-SM  --NO template aanwezig, REPORT crashed...

--SPECIFICATION-HISTORY
--
DROP VIEW sc_lims_dal.av_mlts_spec_history;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_mlts_spec_history
(part_no
,revision
,part_description
,issued_date
,last_modified_on
,last_modified_by
,planned_effective_date
,obsolescence_date
,status
,status_code
,status_type
,reason_id
,reason_text
) as
SELECT  H.part_no
 ,      H.revision
 ,      H.description as part_description
 ,	    H.issued_date
 ,      H.last_modified_on
 ,      u.forename||''||u.last_name   as last_modified_by
 ,      H.planned_effective_date
 ,      H.obsolescence_date
 ,	    S.status
 ,      S.sort_desc AS status_code
 ,      S.status_type
 ,     sh.reason_id
 ,      r.text
 FROM sc_interspec_ens.specification_header H  
 JOIN sc_interspec_ens.status               S ON (S.status   = H.status)
 join sc_interspec_ens.itus                 u on (u.user_id  = H.last_modified_by)
 join sc_interspec_ens.status_history      sh on (sh.part_no = h.part_no and sh.revision = h.revision)
 join sc_interspec_ens.reason               r on (r.id       = sh.reason_id)
 WHERE S.status_type IN ('HISTORIC', 'CURRENT')
 AND   SH.REASON_ID is not null
;

--example WHERE-CLAUSE
--and   h.part_no = 'GF_1856015ULAXH'   --'XGG_BF66A17J1'
--where part_no = 'XGG_BF66A17J1'
--and   preferred = 1
-- ORDER BY h.part_no, h.revision DESC


/*
GF_1856015ULAXH	21	03-11-2022 00:00:08	02-11-2022 16:22:24	SYSTEMADMINSYSTEMADMIN	03-11-2022 00:00:00		128	CRRNT QR5	CURRENT	1389120
GF_1856015ULAXH	20	27-10-2022 13:18:47	27-10-2022 13:04:04	EvelinKovacs	27-10-2022 00:00:00	03-11-2022 00:00:08	5	HISTORIC	HISTORIC	1385962
GF_1856015ULAXH	20	27-10-2022 13:18:47	27-10-2022 13:04:04	EvelinKovacs	27-10-2022 00:00:00	03-11-2022 00:00:08	5	HISTORIC	HISTORIC	1385962
GF_1856015ULAXH	19	13-07-2022 16:52:32	13-07-2022 16:08:07	BarbaraEckert	13-07-2022 00:00:00	27-10-2022 13:18:47	5	HISTORIC	HISTORIC	1364545
*/

/*
JOIN
	STATUS IN SPECIFICATION_HEADER TAG header TO
	STATUS IN STATUS TAG status AS J0
END
JOIN
	header.LAST_MODIFIED_BY IN SPECIFICATION_HEADER TO
	USER_ID IN ITUS TAG user AS J1
END
JOIN LEFT_OUTER
	FILE SPECIFICATION_HEADER AT header.PART_NO TO MULTIPLE
	FILE STATUS_HISTORY AT PART_NO TAG statHist AS J2
 
	WHERE statHist.PART_NO EQ header.PART_NO;
	WHERE statHist.REVISION EQ header.REVISION;
	WHERE statHist.REASON_ID IS NOT MISSING;
END
JOIN LEFT_OUTER
	statHist.REASON_ID IN SPECIFICATION_HEADER TO
	ID IN REASON TAG reason AS J3
END
-*JOIN LEFT_OUTER
-*	statHist.STATUS IN SPECIFICATION_HEADER TO UNIQUE
-*	STATUS IN STATUS TAG histStatus AS J4
-*END
 
DEFINE FILE SPECIFICATION_HEADER
	ISSUED_DATE/A20 = HCNVRT(header.ISSUED_DATE, '(HYYMDS)', 20, 'A20');
END
TABLE FILE SPECIFICATION_HEADER
PRINT
-*	header.LAST_MODIFIED_ON			AS 'Last Modified,On'
	header.ISSUED_DATE				AS 'Issued,On'
	COMPUTE FULLNAME/A21 = user.FORENAME || ' ' | user.LAST_NAME;
									AS 'Last Modified,By'
-*	header.STATUS_CHANGE_DATE		AS 'Status,Change Date'
	header.OBSOLESCENCE_DATE		AS 'Obsoleted,On'
	reason.TEXT						AS 'Reason for Issue'
-*	histStatus.SORT_DESC			AS 'Status at Reason'
	ISSUED_DATE						NOPRINT
	COMPUTE FMXNP/I3 = &FMXNP; NOPRINT
*/	