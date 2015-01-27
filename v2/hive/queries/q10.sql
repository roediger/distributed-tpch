
set hive.optimize.ppd=true;
set hive.optimize.index.filter=true;

set hive.auto.convert.join = true;
set hive.auto.convert.join.noconditionaltask = true;
set hive.map.aggr=true;
--set hive.exec.reducers.max=22;
set mapred.reduce.tasks=120;
set hive.auto.convert.join.noconditionaltask.size = 200000000;
set hive.mapjoin.smalltable.filesize = 200000000;
set hive.optimize.correlation=true;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;


-- TPCH HIVE Q10

select 
  c_custkey, c_name, sum(l_extendedprice * (1 - l_discount)) as revenue, 
  c_acctbal, n_name, c_address, c_phone, c_comment
from
  customer c join ordersorc o 
  on 
    c.c_custkey = o.o_custkey and o.o_orderdate >= '1993-10-01' and o.o_orderdate < '1994-01-01'
  join nation n 
  on 
    c.c_nationkey = n.n_nationkey
  join lineitem l 
  on 
    l.l_orderkey = o.o_orderkey and l.l_returnflag = 'R'
group by c_custkey, c_name, c_acctbal, c_phone, n_name, c_address, c_comment 
order by revenue desc 
limit 20;

