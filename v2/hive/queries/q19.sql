
set hive.optimize.ppd=true;
set hive.optimize.index.filter=true;

set hive.optimize.correlation=true;
set hive.auto.convert.join = true;
set hive.auto.convert.join.noconditionaltask = true;
set hive.map.aggr=true;
--set hive.exec.reducers.max=22;
set mapred.reduce.tasks=120;
set hive.auto.convert.join.noconditionaltask.size = 200000000;
set hive.mapjoin.smalltable.filesize = 200000000;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;


-- TPCH HIVE Q19

select
  sum(l_extendedprice * (1 - l_discount) ) as revenue
from
  lineitem l join part p
  on 
    p.p_partkey = l.l_partkey    
where
  (
    p_brand = 'Brand#12'
	and p_container REGEXP 'SM CASE||SM BOX||SM PACK||SM PKG'
	and l_quantity >= 1 and l_quantity <= 11
	and p_size >= 1 and p_size <= 5
	and l_shipmode REGEXP 'AIR||AIR REG'
	and l_shipinstruct = 'DELIVER IN PERSON'
  ) 
  or 
  (
    p_brand = 'Brand#23'
	and p_container REGEXP 'MED BAG||MED BOX||MED PKG||MED PACK'
	and l_quantity >= 10 and l_quantity <= 20
	and p_size >= 1 and p_size <= 10
	and l_shipmode REGEXP 'AIR||AIR REG'
	and l_shipinstruct = 'DELIVER IN PERSON'
  )
  or
  (
	p_brand = 'Brand#34'
	and p_container REGEXP 'LG CASE||LG BOX||LG PACK||LG PKG'
	and l_quantity >= 20 and l_quantity <= 30
	and p_size >= 1 and p_size <= 15
	and l_shipmode REGEXP 'AIR||AIR REG'
	and l_shipinstruct = 'DELIVER IN PERSON'
  )
;
