with revenue as (
	select
		l.suppkey as supplier_no,
		sum(l.extendedprice * (1 - l.discount)) as total_revenue
	from
		lineitem
	where
		l.shipdate >= date '1996-01-01'
		and l.shipdate < date '1996-04-01'
	group by
		l.suppkey)
select
	s.suppkey,
	s.name,
	s.address,
	s.phone,
	total_revenue
from
	supplier,
	revenue
where
	s.suppkey = supplier_no
	and total_revenue = (
		select
			max(total_revenue)
		from
			revenue
	)
order by
	s.suppkey
