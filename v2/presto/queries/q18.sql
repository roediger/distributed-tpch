select  top 100
		c.name,
		c.custkey,
		o.orderkey,
		o.orderdate,
		o.totalprice,
		sum(l.quantity)
from
		tpch.sf1.customer,
		tpch.sf1.orders,
		tpch.sf1.lineitem
where
		o.orderkey in (
				select
						l.orderkey
				from
						tpch.sf1.lineitem
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
