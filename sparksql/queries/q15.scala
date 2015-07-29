// major change: use rewritten query because original query not supported
val start = System.currentTimeMillis
sqlContext.sql("drop table revenue")
sqlContext.sql("create table revenue(supplier_no int, total_revenue double)")
sqlContext.sql("insert overwrite table revenue select l_suppkey as supplier_no, sum(l_extendedprice * (1 - l_discount)) as total_revenue from lineitem where l_shipdate >= '1996-01-01' and l_shipdate < '1996-04-01' group by l_suppkey")
sqlContext.sql("select s_suppkey, s_name, s_address, s_phone, total_revenue from supplier s join revenue r on s.s_suppkey = r.supplier_no join (select max(total_revenue) as max_revenue from revenue) m on r.total_revenue = m.max_revenue order by s_suppkey").show()
(System.currentTimeMillis-start)/1000.0
