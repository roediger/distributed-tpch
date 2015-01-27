
--set hive.optimize.ppd=true;
--set hive.optimize.index.filter=true;

set hive.optimize.correlation=true;
set hive.auto.convert.join = true;
set hive.auto.convert.join.noconditionaltask = true;
set hive.map.aggr=true;
--set hive.exec.reducers.max=22;
set mapred.reduce.tasks=120;
set hive.auto.convert.join.noconditionaltask.size = 200000000;
set hive.mapjoin.smalltable.filesize = 200000000;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
-- TPCH HIVE Q12
select 
  l_shipmode,
  sum(case
    when o_orderpriority ='1-URGENT'
         or o_orderpriority ='2-HIGH'
    then 1
    else 0
end
  ) as high_line_count,
  sum(case
    when o_orderpriority <> '1-URGENT'
         and o_orderpriority <> '2-HIGH'
    then 1
    else 0
end
  ) as low_line_count
from
  ordersorc o join lineitem l 
  on 
    o.o_orderkey = l.l_orderkey and l.l_commitdate < l.l_receiptdate
and l.l_shipdate < l.l_commitdate and l.l_receiptdate >= '1994-01-01' 
and l.l_receiptdate < '1995-01-01'
where 
  l.l_shipmode = 'MAIL' or l.l_shipmode = 'SHIP'
group by l_shipmode
order by l_shipmode;
