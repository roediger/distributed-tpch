select
		s.acctbal,
		s.name,
		n.name,
		p.partkey,
		p.mfgr,
		s.address,
		s.phone,
		s.comment
from
		part p,
		supplier s,
		partsupp ps,
		nation n,
		region r,
		(
						select
								p.partkey, min(ps.supplycost) as supplycost
						from
								part p,
								partsupp ps,
								supplier s,
								nation n,
								region r
						where
								p.partkey = ps.partkey
								and s.suppkey = ps.suppkey
								and s.nationkey = n.nationkey
								and n.regionkey = r.regionkey
								and r.name = 'EUROPE'
						group by 
								p.partkey
				) min_supplycost
where
		p.partkey = ps.partkey
		and s.suppkey = ps.suppkey
		and p.size = 15
		and p.type like '%BRASS'
		and s.nationkey = n.nationkey
		and n.regionkey = r.regionkey
		and r.name = 'EUROPE'
		and min_supplycost.partkey = p.partkey
		and ps.supplycost = min_supplycost.supplycost
order by
		s.acctbal desc,
		n.name,
		s.name,
		p.partkey
limit 100;
