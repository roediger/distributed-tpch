
set hive.optimize.ppd=true;
set hive.optimize.index.filter=true;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
set hive.auto.convert.join = true;
set hive.auto.convert.join.noconditionaltask = true;
set hive.map.aggr=true;
--set hive.exec.reducers.max=22;
set mapred.reduce.tasks=120;
set hive.auto.convert.join.noconditionaltask.size = 200000000;
set hive.mapjoin.smalltable.filesize = 200000000;
set hive.optimize.correlation=true;

-- TPCH HIVE Q9
select 
  nation, o_year, sum(amount) as sum_profit
from 
  (
select 
  n_name as nation, year(o_orderdate) as o_year, 
  l_extendedprice * (1 - l_discount) -  ps_supplycost * l_quantity as amount
    from
      ordersorc o join
      (select l_extendedprice, l_discount, l_quantity, l_orderkey, n_name, ps_supplycost 
       from part p join
         (select l_extendedprice, l_discount, l_quantity, l_partkey, l_orderkey, 
                 n_name, ps_supplycost 
          from partsupp ps join
            (select l_suppkey, l_extendedprice, l_discount, l_quantity, l_partkey, 
                    l_orderkey, n_name 
             from
               (select s_suppkey, n_name 
                from nation n join supplier s on n.n_nationkey = s.s_nationkey
               ) s1 join lineitem l on s1.s_suppkey = l.l_suppkey
            ) l1 on ps.ps_suppkey = l1.l_suppkey and ps.ps_partkey = l1.l_partkey
         ) l2 on p.p_name like '%green%' and p.p_partkey = l2.l_partkey
     ) l3 on o.o_orderkey = l3.l_orderkey
  )profit
group by nation, o_year
order by nation, o_year desc;

