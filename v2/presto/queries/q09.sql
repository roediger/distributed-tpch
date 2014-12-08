select
		nation,
		o.year,
		sum(amount) as sum_profit
from
		(
				select
						n.name as nation,
						extract(year from o.orderdate) as o.year,
						l.extendedprice * (1 - l.discount) - ps_supplycost * l.quantity as amount
				from
						part,
						supplier,
						lineitem,
						partsupp,
						orders,
						nation
				where
						s.suppkey = l.suppkey
						and ps_suppkey = l.suppkey
						and ps_partkey = l.partkey
						and p.partkey = l.partkey
						and o.orderkey = l.orderkey
						and s.nationkey = n.nationkey
						and p.name like '%green%'
		) as profit
group by
		nation,
		o.year
order by
		nation,
		o.year desc;
