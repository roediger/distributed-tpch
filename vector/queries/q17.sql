select
		sum(l_extendedprice) / 7.0 as avg_yearly
from
		lineitem,
		part
where
		p_partkey = l_partkey
		and p_brand = 'Brand#23'
		and p_container = 'MED BOX'
		and l_quantity < (
				select
						0.2 * avg(l_quantity)
				from
						lineitem
				where
						l_partkey = p_partkey
		);\g
select execution_time from iivwprof_query;\g
select concat('async_io ', SUM(async_io)) from iivwprof;\g
