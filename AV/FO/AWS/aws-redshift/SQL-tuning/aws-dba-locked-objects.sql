--REDSHIFT locked-objects
--Detect and Release Locks in Amazon Redshift
--Locks are a protection mechanism that controls how many sessions can access a table at the same time.
--In addition, it determines the operations to perform in those sessions.
--While most relational databases use row-level locks, Amazon Redshift uses table-level locks.
--Generally, Amazon Redshift has three lock modes. They are:
-- * AccessExclusiveLock
-- * AccessShareLock
-- * ShareRowExclusiveLock
--When a query or transaction acquires a lock on a table, it remains for the duration of the query or transaction.

--Initially, we run a query to identify sessions that are holding locks:

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
where a.relation is not null;


--To release a lock, we wait for the transaction that holds the lock to finish.
--On the other hand, to manually terminate the session we run the below command:

select pg_terminate_backend(PID);
--1073766832
select pg_terminate_backend(1073766832);





