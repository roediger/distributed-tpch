-- the query
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

insert overwrite table q11_sum_tmp
select 
  sum(part_value) as total_value
from 
  q11_part_tmp;

insert overwrite table q11_important_stock
select 
  ps_partkey, part_value as value
from
  (
    select ps_partkey, part_value, total_value
    from q11_part_tmp join q11_sum_tmp
  ) a
where part_value > total_value * 0.0001
order by value desc;

