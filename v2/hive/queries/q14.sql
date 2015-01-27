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
--set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
-- TPCH HIVE Q14
select 
  100.00 * sum(case
               when p_type like 'PROMO%'
               then l_extendedprice*(1-l_discount)
               else 0.0
               end
  ) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from 
  lineitem l join part p 
  on 
    l.l_partkey = p.p_partkey and l.l_shipdate >= '1995-09-01' and l.l_shipdate < '1995-10-01';

