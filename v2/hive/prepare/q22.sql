DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS q22_customer_tmp;
DROP TABLE IF EXISTS q22_customer_tmp1;
DROP TABLE IF EXISTS q22_orders_tmp;
DROP TABLE IF EXISTS q22_global_sales_opportunity;

-- create tables and load data
create external table customer (C_CUSTKEY INT, C_NAME STRING, C_ADDRESS STRING, C_NATIONKEY INT, C_PHONE STRING, C_ACCTBAL DOUBLE, C_MKTSEGMENT STRING, C_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION '/tpch/100/customer';
create external table orders (O_ORDERKEY INT, O_CUSTKEY INT, O_ORDERSTATUS STRING, O_TOTALPRICE DOUBLE, O_ORDERDATE STRING, O_ORDERPRIORITY STRING, O_CLERK STRING, O_SHIPPRIORITY INT, O_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION '/tpch/100/orders';

-- create target tables
create table q22_customer_tmp(c_acctbal double, c_custkey int, cntrycode string);
create table q22_customer_tmp1(avg_acctbal double);
create table q22_orders_tmp(o_custkey int);
create table q22_global_sales_opportunity(cntrycode string, numcust int, totacctbal double);

