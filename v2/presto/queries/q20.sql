select
		s.name,
		s.address
from
		tpch.sf1.supplier,
		tpch.sf1.nation
where
		s.suppkey in (
				select
						ps_suppkey
				from
						tpch.sf1.partsupp
				where
						ps_partkey in (
								select
										p.partkey
								from
										part
								where
										p.name like 'forest%'
						)
						and ps_availqty > (
								select
										0.5 * sum(l.quantity)
								from
										lineitem
								where
										l.partkey = ps_partkey
										and l.suppkey = ps_suppkey
										and l.shipdate >= date '1994-01-01'
										and l.shipdate < date '1995-01-01'
						)
		)
		and s.nationkey = n.nationkey
		and n.name = 'CANADA'
order by
		s.name
