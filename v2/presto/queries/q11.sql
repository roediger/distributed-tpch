select
		ps_partkey,
		sum(ps_supplycost * ps_availqty) as "value"
from
		tpch.sf1.partsupp,
		tpch.sf1.supplier,
		tpch.sf1.nation
where
		ps_suppkey = s.suppkey
		and s.nationkey = n.nationkey
		and n.name = 'GERMANY'
group by
		ps_partkey having
				sum(ps_supplycost * ps_availqty) > (
						select
								sum(ps_supplycost * ps_availqty) * 0.0001
						from
								tpch.sf1.partsupp,
								tpch.sf1.supplier,
								tpch.sf1.nation
						where
								ps_suppkey = s.suppkey
								and s.nationkey = n.nationkey
								and n.name = 'GERMANY'
				)
order by
		"value" desc
