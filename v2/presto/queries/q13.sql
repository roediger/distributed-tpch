select
		c.count,
		count(*) as custdist
from
		(
				select
						c.custkey,
						count(o.orderkey) c.count
				from
						customer left outer join orders on
								c.custkey = o.custkey
								and o.comment not like '%special%requests%'
				group by
						c.custkey
		) as c.orders
group by
		c.count
order by
		custdist desc,
		c.count desc
