select
		supp_nation,
		cust_nation,
		l.year,
		sum(volume) as revenue
from
		(
				select
						n1.n.name as supp_nation,
						n2.n.name as cust_nation,
						extract(year from l.shipdate) as l.year,
						l.extendedprice * (1 - l.discount) as volume
				from
						tpch.sf1.supplier,
						tpch.sf1.lineitem,
						tpch.sf1.orders,
						tpch.sf1.customer,
						tpch.sf1.nation n1,
						tpch.sf1.nation n2
				where
						s.suppkey = l.suppkey
						and o.orderkey = l.orderkey
						and c.custkey = o.custkey
						and s.nationkey = n1.n.nationkey
						and c.nationkey = n2.n.nationkey
						and (
								(n1.n.name = 'FRANCE' and n2.n.name = 'GERMANY')
								or (n1.n.name = 'GERMANY' and n2.n.name = 'FRANCE')
						)
						and l.shipdate between date '1995-01-01' and date '1996-12-31'
		) as shipping
group by
		supp_nation,
		cust_nation,
		l.year
order by
		supp_nation,
		cust_nation,
		l.year

