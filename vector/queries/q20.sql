select
		s_name,
		s_address
from
		supplier,
		nation
where
		s_suppkey in (
				select
						ps_suppkey
				from
						partsupp
				where
						ps_partkey in (
								select
										p_partkey
								from
										part
								where
										p_name like 'forest%'
						)
						and ps_availqty > (
								select
										0.5 * sum(l_quantity)
								from
										lineitem
								where
										l_partkey = ps_partkey
										and l_suppkey = ps_suppkey
										and l_shipdate >= date '1994-01-01'
										and l_shipdate < date '1995-01-01'
						)
		)
		and s_nationkey = n_nationkey
		and n_name = 'CANADA'
order by
		s_name;\g
select execution_time from iivwprof_query;\g
select concat('async_io ', SUM(async_io)) from iivwprof;\g
