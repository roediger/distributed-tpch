
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
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;


-- TPCH HIVE Q22
DROP TABLE q22_customer_tmp;
DROP TABLE q22_customer_tmp1;

create table q22_customer_tmp(c_acctbal double, c_custkey int, cntrycode string) stored as orc tblproperties ("orc.compress"="NONE");
create table q22_customer_tmp1(avg_acctbal double) stored as orc tblproperties ("orc.compress"="NONE");

insert overwrite table q22_customer_tmp
select 
  c_acctbal, c_custkey, substr(c_phone, 1, 2) as cntrycode
from 
  customer
where 
  substr(c_phone, 1, 2) = '13' or
  substr(c_phone, 1, 2) = '31' or
  substr(c_phone, 1, 2) = '23' or
  substr(c_phone, 1, 2) = '29' or
  substr(c_phone, 1, 2) = '30' or
  substr(c_phone, 1, 2) = '18' or
  substr(c_phone, 1, 2) = '17';
 
insert overwrite table q22_customer_tmp1
select
  avg(c_acctbal)
from
  q22_customer_tmp
where
  c_acctbal > 0.00;


select
  cntrycode, count(1) as numcust, sum(c_acctbal) as totacctbal
from
(
  select cntrycode, c_acctbal, avg_acctbal from
  q22_customer_tmp1 ct1 join
  (
    select cntrycode, c_acctbal from
      (select
  o_custkey
from
  ordersorc
group by
  o_custkey) ot 
      right outer join q22_customer_tmp ct 
      on
        ct.c_custkey = ot.o_custkey
    where
      o_custkey is null
  ) ct2
) a
where
  c_acctbal > avg_acctbal
group by cntrycode
order by cntrycode;

