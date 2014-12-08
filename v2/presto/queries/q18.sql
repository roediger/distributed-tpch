select  top 100
		c.name,
		c.custkey,
		o.orderkey,
		o.orderdate,
		o.totalprice,
		sum(l.quantity)
from
		customer,
		orders,
		lineitem
where
		o.orderkey in (
				select
						l.orderkey
				from
						lineitem
				group by
						l.orderkey having
								sum(l.quantity) > 300
		)
		and c.custkey = o.custkey
		and o.orderkey = l.orderkey
group by
		c.name,
		c.custkey,
		o.orderkey,
		o.orderdate,
		o.totalprice
order by
		o.totalprice desc,
		o.orderdate
