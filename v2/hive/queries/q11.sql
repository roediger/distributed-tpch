set hive.optimize.correlation=true;
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
-- TPCH HIVE Q11
DROP TABLE q11_part_tmp;

create table q11_part_tmp(ps_partkey int, part_value double) stored as orc tblproperties ("orc.compress"="NONE");

insert overwrite table q11_part_tmp
select 
  ps_partkey, sum(ps_supplycost * ps_availqty) as part_value 
from
  nation n join supplier s 
  on 
    s.s_nationkey = n.n_nationkey and n.n_name = 'GERMANY'
  join partsupp ps 
  on 
    ps.ps_suppkey = s.s_suppkey
group by ps_partkey;


select 
  ps_partkey, part_value as value
from
  (
    select ps_partkey, part_value, total_value
    from q11_part_tmp join ( select
  sum(part_value) as total_value
from
  q11_part_tmp )t
  ) a
where part_value > total_value * 0.0001
order by value desc;

