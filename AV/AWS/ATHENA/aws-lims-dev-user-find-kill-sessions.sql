--I try to re-create a db-view in redshift, but the views seems to be locked by another session. 
--I try to find out who/which/what, but i don't have enough perimission to retrieve this information from redshift:

select a.txn_owner
, a.txn_db
, a.xid
, a.pid
, a.txn_start
, a.lock_mode
, a.relation as table_id
,nvl(trim(c."name"),d.relname) as tablename
, a.granted
,b.pid as blocking_pid 
,datediff(s,a.txn_start,getdate())/86400||' days '||datediff(s,a.txn_start,getdate())%86400/3600||' hrs '||datediff(s,a.txn_start,getdate())%3600/60||' mins '||datediff(s,a.txn_start,getdate())%60||' secs' as txn_duration
from svv_transactions a
left join (select pid,relation,granted from pg_locks group by 1,2,3) b  on a.relation=b.relation and a.granted='f' and b.granted='t'
left join (select * from stv_tbl_perm where slice=0) c                  on a.relation=c.id
left join pg_class d                                                    on a.relation=d.oid
where a.relation is not null
;

--Can you run this query, or find out who is locking view SC_LIMS_DAL.av_reqovtest_resultsmethod ??
txn_owner			txn_db				xid			pid			txn_start			lock_mode		table_id	tablename			granted	blocking_pid	txn_duration
atl_dl_prd_admin	db_prd_ens_lims		459204167	1073899589	2023-12-18 11:06:42	AccessShareLock	61080		stv_transactions	true	 				0 days 5 hrs 30 mins 0 secs
atl_dl_prd_admin	db_prd_ens_lims		459204167	1073899589	2023-12-18 11:06:42	AccessShareLock	60810		stv_sessions		true	 				0 days 5 hrs 30 mins 0 secs
atl_dl_prd_admin	db_prd_ens_lims		459204167	1073899589	2023-12-18 11:06:42	AccessShareLock	17918706	svv_transactions	true	 				0 days 5 hrs 30 mins 0 secs
atl_dl_prd_admin	db_prd_ens_lims		459204167	1073899589	2023-12-18 11:06:42	AccessShareLock	17012		pg_locks			
...
etc

--thnx. Do you know who user = usr_rna_readonly1 ?  Or can you kill his process for me? 
--kill session based on PID !!!
select pg_terminate_backend(1073766832);


--einde script

