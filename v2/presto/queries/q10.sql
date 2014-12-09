select top 20
		c.custkey,
		c.name,
		sum(l.extendedprice * (1 - l.discount)) as revenue,
		c.acctbal,
		n.name,
		c.address,
		c.phone,
		c.comment
from
		tpch.sf1.customer,
		tpch.sf1.orders,
		tpch.sf1.lineitem,
		tpch.sf1.nation
where
		c.custkey = o.custkey
		and l.orderkey = o.orderkey
		and o.orderdate >= date '1993-10-01'
		and o.orderdate < date '1994-01-01'
		and l.returnflag = 'R'
		and c.nationkey = n.nationkey
group by
		c.custkey,
		c.name,
		c.acctbal,
		c.phone,
		n.name,
		c.address,
		c.comment
order by
		revenue desc;
