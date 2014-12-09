select top 100
		s.name,
		count(*) as numwait
from
		tpch.sf1.supplier,
		tpch.sf1.lineitem l1,
		tpch.sf1.orders,
		tpch.sf1.nation
where
		s.suppkey = l1.l.suppkey
		and o.orderkey = l1.l.orderkey
		and o.orderstatus = 'F'
		and l1.l.receiptdate > l1.l.commitdate
		and exists (
				select
						*
				from
						tpch.sf1.lineitem l2
				where
						l2.l.orderkey = l1.l.orderkey
						and l2.l.suppkey <> l1.l.suppkey
		)
		and not exists (
				select
						*
				from
						tpch.sf1.lineitem l3
				where
						l3.l.orderkey = l1.l.orderkey
						and l3.l.suppkey <> l1.l.suppkey
						and l3.l.receiptdate > l3.l.commitdate
		)
		and s.nationkey = n.nationkey
		and n.name = 'SAUDI ARABIA'
group by
		s.name
order by
		numwait desc,
		s.name
