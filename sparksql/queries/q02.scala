// major change: use rewritten query because original query not supported
val start = System.currentTimeMillis
sqlContext.sql("DROP TABLE q2_minimum_cost_supplier_tmp1")
sqlContext.sql("create table q2_minimum_cost_supplier_tmp1 (s_acctbal double, s_name string, n_name string, p_partkey int, ps_supplycost double, p_mfgr string, s_address string, s_phone string, s_comment string)")
sqlContext.sql("insert overwrite table q2_minimum_cost_supplier_tmp1 select s.s_acctbal, s.s_name, n.n_name, p.p_partkey, ps.ps_supplycost, p.p_mfgr, s.s_address, s.s_phone, s.s_comment from nation  n join region  r on n.n_regionkey = r.r_regionkey and r.r_name = 'EUROPE' join supplier s on s.s_nationkey = n.n_nationkey join partsupp  ps on  s.s_suppkey = ps.ps_suppkey join part p on p.p_partkey = ps.ps_partkey and p.p_size = 15 and p.p_type like '%BRASS'").show()
sqlContext.sql("select t1.s_acctbal, t1.s_name, t1.n_name, t1.p_partkey, t1.p_mfgr, t1.s_address, t1.s_phone, t1.s_comment from q2_minimum_cost_supplier_tmp1 t1 join (select p_partkey, min(ps_supplycost) as ps_min_supplycost from q2_minimum_cost_supplier_tmp1 group by p_partkey) t2 on t1.p_partkey = t2.p_partkey and t1.ps_supplycost=t2.ps_min_supplycost order by s_acctbal desc, n_name, s_name, p_partkey limit 100").show()
(System.currentTimeMillis-start)/1000.0
