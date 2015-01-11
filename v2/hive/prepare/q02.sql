DROP TABLE IF EXISTS q2_minimum_cost_supplier;
DROP TABLE IF EXISTS q2_minimum_cost_supplier_tmp1;
DROP TABLE IF EXISTS q2_minimum_cost_supplier_tmp2;

-- create result tables
create table q2_minimum_cost_supplier_tmp1 (s_acctbal double, s_name string, n_name string, p_partkey int, ps_supplycost double, p_mfgr string, s_address string, s_phone string, s_comment string);
create table q2_minimum_cost_supplier_tmp2 (p_partkey int, ps_min_supplycost double);
create table q2_minimum_cost_supplier (s_acctbal double, s_name string, n_name string, p_partkey int, p_mfgr string, s_address string, s_phone string, s_comment string);
