DROP TABLE IF EXISTS q18_tmp;
DROP TABLE IF EXISTS q18_large_volume_customer;

-- create the result tables
create table q18_tmp(l_orderkey int, t_sum_quantity double);
create table q18_large_volume_customer(c_name string, c_custkey int, o_orderkey int, o_orderdate string, o_totalprice double, sum_quantity double);
