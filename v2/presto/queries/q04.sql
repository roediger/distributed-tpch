-- Presto doesn't support the EXISTS predicate, use q04-alternative.sql
select
		o.orderpriority,
		count(*) as order_count
from
		tpch.sf1.orders o
where
		date_parse(o.orderdate, '%Y-%m-%d') >= date '1993-07-01'
		and date_parse(o.orderdate, '%Y-%m-%d') < date '1993-10-01'
		and exists (
				select
						*
				from
						tpch.sf1.lineitem l
				where
						l.orderkey = o.orderkey
						and date_parse(l.commitdate, '%Y-%m-%d') < date_parse(l.receiptdate, '%Y-%m-%d')
		)
group by
		o.orderpriority
order by
		o.orderpriority