set hive.optimize.correlation=true;
set hive.optimize.ppd=true;
set hive.optimize.index.filter=true;

set hive.auto.convert.join = true;
set hive.auto.convert.join.noconditionaltask = true;
set hive.map.aggr=true;
--set hive.exec.reducers.max=22;
set mapred.reduce.tasks=120;
--set hive.auto.convert.join.noconditionaltask.size = 100000000;
--set hive.mapjoin.smalltable.filesize = 100000000;
--set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
DROP TABLE revenue;

create table revenue(supplier_no int, total_revenue double) stored as orc tblproperties ("orc.compress"="NONE");; 

insert overwrite table revenue
select 
  l_suppkey as supplier_no, sum(l_extendedprice * (1 - l_discount)) as total_revenue
from 
  lineitem
where 
  l_shipdate >= '1996-01-01' and l_shipdate < '1996-04-01'
group by l_suppkey;


select 
  s_suppkey, s_name, s_address, s_phone, total_revenue
from supplier s join revenue r 
  on 
    s.s_suppkey = r.supplier_no
  join (select
  max(total_revenue) as max_revenue
from
  revenue)  m 
  on 
    r.total_revenue = m.max_revenue
order by s_suppkey;

