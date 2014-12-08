select
		o.orderpriority,
		count(*) as order_count
from
		orders o,
		(
						select
								o.orderkey, COUNT(*) as count
						from
								lineitem l,
								orders o
						where
								l.orderkey = o.orderkey
								and date_parse(l.commitdate, '%Y-%m-%d') < date_parse(l.receiptdate, '%Y-%m-%d')
						group by o.orderkey
				) _ll
where
		date_parse(o.orderdate, '%Y-%m-%d') >= date '1993-07-01'
		and date_parse(o.orderdate, '%Y-%m-%d') < date '1993-10-01'
		and _ll.orderkey = o.orderkey
		and _ll.count > 0 
group by
		o.orderpriority
order by
		o.orderpriority;
