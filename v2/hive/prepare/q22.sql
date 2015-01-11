DROP TABLE IF EXISTS q22_customer_tmp;
DROP TABLE IF EXISTS q22_customer_tmp1;
DROP TABLE IF EXISTS q22_orders_tmp;
DROP TABLE IF EXISTS q22_global_sales_opportunity;

-- create target tables
create table q22_customer_tmp(c_acctbal double, c_custkey int, cntrycode string);
create table q22_customer_tmp1(avg_acctbal double);
create table q22_orders_tmp(o_custkey int);
create table q22_global_sales_opportunity(cntrycode string, numcust int, totacctbal double);

