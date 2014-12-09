select
		n.name,
		sum(l.extendedprice * (1 - l.discount)) as revenue
from
		tpch.sf1.customer c,
		tpch.sf1.orders o,
		tpch.sf1.lineitem l,
		tpch.sf1.supplier s,
		tpch.sf1.nation n,
		tpch.sf1.region r
where
		c.custkey = o.custkey
		and l.orderkey = o.orderkey
		and l.suppkey = s.suppkey
		and c.nationkey = s.nationkey
		and s.nationkey = n.nationkey
		and n.regionkey = r.regionkey
		and r.name = 'ASIA'
		and date_parse(o.orderdate, '%Y-%m-%d') >= date '1994-01-01'
		and date_parse(o.orderdate, '%Y-%m-%d') < date '1995-01-01'
group by
		n.name
order by
		revenue desc;
