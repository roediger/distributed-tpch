-- Note: Facebook Presto doesn't support "between 0.06 - 0.01 and 0.06 + 0.01"
select
		sum(l.extendedprice * l.discount) as revenue
from
		tpch.sf1.lineitem l
where
		date_parse(l.shipdate, '%Y-%m-%d') >= date '1994-01-01'
		and date_parse(l.shipdate, '%Y-%m-%d') < date '1995-01-01'
		and l.discount between 0.05 and 0.07
		and l.quantity < 24;
