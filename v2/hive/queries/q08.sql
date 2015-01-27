
set hive.optimize.ppd=true;
set hive.optimize.index.filter=true;
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


-- TPCH HIVE Q8
select 
  o_year, sum(case when nation = 'BRAZIL' then volume else 0.0 end) / sum(volume) as mkt_share
from 
  (
select 
  year(o_orderdate) as o_year, l_extendedprice * (1-l_discount) as volume, 
  n2.n_name as nation
    from
      nation n2 join
        (select o_orderdate, l_discount, l_extendedprice, s_nationkey 
         from supplier s join
          (select o_orderdate, l_discount, l_extendedprice, l_suppkey 
           from part p join
             (select o_orderdate, l_partkey, l_discount, l_extendedprice, l_suppkey 
              from lineitem l join
                (select o_orderdate, o_orderkey 
                 from ordersorc o join
                   (select c.c_custkey 
                    from customer c join
                      (select n1.n_nationkey 
                       from nation n1 join region r
                       on n1.n_regionkey = r.r_regionkey and r.r_name = 'AMERICA'
                       ) n11 on c.c_nationkey = n11.n_nationkey
                    ) c1 on c1.c_custkey = o.o_custkey
                 ) o1 on l.l_orderkey = o1.o_orderkey and o1.o_orderdate >= '1995-01-01' 
                         and o1.o_orderdate < '1996-12-31'
              ) l1 on p.p_partkey = l1.l_partkey and p.p_type = 'ECONOMY ANODIZED STEEL'
           ) p1 on s.s_suppkey = p1.l_suppkey
        ) s1 on s1.s_nationkey = n2.n_nationkey
  ) all_nation
group by o_year
order by o_year;

