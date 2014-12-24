DROP TABLE IF EXISTS partsupp;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS nation;
DROP TABLE IF EXISTS q11_important_stock;
DROP TABLE IF EXISTS q11_part_tmp;
DROP TABLE IF EXISTS q11_sum_tmp;

-- create tables and load data
create external table supplier (S_SUPPKEY INT, S_NAME STRING, S_ADDRESS STRING, S_NATIONKEY INT, S_PHONE STRING, S_ACCTBAL DOUBLE, S_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION '/tpch/100/supplier';
create external table nation (N_NATIONKEY INT, N_NAME STRING, N_REGIONKEY INT, N_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION '/tpch/100/nation';
create external table partsupp (PS_PARTKEY INT, PS_SUPPKEY INT, PS_AVAILQTY INT, PS_SUPPLYCOST DOUBLE, PS_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION'/tpch/100/partsupp';

-- create the target table
create table q11_important_stock(ps_partkey INT, value DOUBLE);
create table q11_part_tmp(ps_partkey int, part_value double);
create table q11_sum_tmp(total_value double);

