select
		ps_partkey,
		sum(ps_supplycost * ps_availqty) as "value"
from
		partsupp,
		supplier,
		nation
where
		ps_suppkey = s_suppkey
		and s_nationkey = n_nationkey
		and n_name = 'GERMANY'
group by
		ps_partkey having
				sum(ps_supplycost * ps_availqty) > (
						select
								sum(ps_supplycost * ps_availqty) * 0.0001
						from
								partsupp,
								supplier,
								nation
						where
								ps_suppkey = s_suppkey
								and s_nationkey = n_nationkey
								and n_name = 'GERMANY'
				)
order by
		"value" desc;\g
select execution_time from iivwprof_query;\g
select concat('async_io ', SUM(async_io)) from iivwprof;\g
