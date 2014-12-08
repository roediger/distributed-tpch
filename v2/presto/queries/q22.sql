select
		cntrycode,
		count(*) as numcust,
		sum(c.acctbal) as totacctbal
from
		(
				select
						substring(c.phone from 1 for 2) as cntrycode,
						c.acctbal
				from
						customer
				where
						substring(c.phone from 1 for 2) in
								('13', '31', '23', '29', '30', '18', '17')
						and c.acctbal > (
								select
										avg(c.acctbal)
								from
										customer
								where
										c.acctbal > 0.00
										and substring(c.phone from 1 for 2) in
												('13', '31', '23', '29', '30', '18', '17')
						)
						and not exists (
								select
										*
								from
										orders
								where
										o.custkey = c.custkey
						)
		) as custsale
group by
		cntrycode
order by
		cntrycode
