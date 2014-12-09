select
		p.brand,
		p.type,
		p.size,
		count(distinct ps_suppkey) as supplier_cnt
from
		tpch.sf1.partsupp,
		tpch.sf1.part
where
		p.partkey = ps_partkey
		and p.brand <> 'Brand#45'
		and p.type not like 'MEDIUM POLISHED%'
		and p.size in (49, 14, 23, 45, 19, 3, 36, 9)
		and ps_suppkey not in (
				select
						s.suppkey
				from
						tpch.sf1.supplier
				where
						s.comment like '%Customer%Complaints%'
		)
group by
		p.brand,
		p.type,
		p.size
order by
		supplier_cnt desc,
		p.brand,
		p.type,
		p.size
