// major change: use rewritten query because original query not supported
val start = System.currentTimeMillis
sqlContext.sql("drop table q11_part_tmp")
sqlContext.sql("create table q11_part_tmp(ps_partkey int, part_value double)")
sqlContext.sql("insert overwrite table q11_part_tmp select ps_partkey, sum(ps_supplycost * ps_availqty) as part_value from nation n join supplier s on s.s_nationkey = n.n_nationkey and n.n_name = 'GERMANY' join partsupp ps on ps.ps_suppkey = s.s_suppkey group by ps_partkey")
sqlContext.sql("select ps_partkey, part_value as value from ( select ps_partkey, part_value, total_value from q11_part_tmp join ( select sum(part_value) as total_value from q11_part_tmp )t ) a where part_value > total_value * 0.0001 order by value desc").show()
(System.currentTimeMillis-start)/1000.0
