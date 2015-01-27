
set hive.optimize.ppd=true;
set hive.optimize.index.filter=true;

set hive.optimize.correlation=true;
set hive.auto.convert.join = true;
set hive.auto.convert.join.noconditionaltask = true;
set hive.map.aggr=true;
-- set hive.exec.reducers.max=22;
set mapred.reduce.tasks=120;
set hive.auto.convert.join.noconditionaltask.size = 200000000;
set hive.mapjoin.smalltable.filesize = 200000000;
--set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;


-- TPCH HIVE Q13
select 
  c_count, count(1) as custdist
from 
  (select 
     c_custkey, count(o_orderkey) as c_count
   from 
     customer c left outer join ordersorc o 
     on 
       c.c_custkey = o.o_custkey and not o.o_comment like '%special%requests%'
   group by c_custkey
   ) c_orders
group by c_count
order by custdist desc, c_count desc;

