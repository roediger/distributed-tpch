DROP TABLE IF EXISTS q21_tmp1;
DROP TABLE IF EXISTS q21_tmp2;
DROP TABLE IF EXISTS q21_suppliers_who_kept_orders_waiting;

-- create target tables
create table q21_tmp1(l_orderkey int, count_suppkey int, max_suppkey int);
create table q21_tmp2(l_orderkey int, count_suppkey int, max_suppkey int);
create table q21_suppliers_who_kept_orders_waiting(s_name string, numwait int);
