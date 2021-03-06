CREATE SCHEMA IF NOT EXISTS tpch_csv;

DROP TABLE IF EXISTS tpch_csv.lineitem;
DROP TABLE IF EXISTS tpch_csv.part;
DROP TABLE IF EXISTS tpch_csv.supplier;
DROP TABLE IF EXISTS tpch_csv.partsupp;
DROP TABLE IF EXISTS tpch_csv.nation;
DROP TABLE IF EXISTS tpch_csv.region;
DROP TABLE IF EXISTS tpch_csv.customer;
DROP TABLE IF EXISTS tpch_csv.orders;

-- create tables and load data
CREATE EXTERNAL TABLE tpch_csv.lineitem (
  L_ORDERKEY INT,
  L_PARTKEY INT,
  L_SUPPKEY INT,
  L_LINENUMBER INT,
  L_QUANTITY DOUBLE,
  L_EXTENDEDPRICE DOUBLE,
  L_DISCOUNT DOUBLE,
  L_TAX DOUBLE,
  L_RETURNFLAG STRING,
  L_LINESTATUS STRING,
  L_SHIPDATE STRING,
  L_COMMITDATE STRING,
  L_RECEIPTDATE STRING,
  L_SHIPINSTRUCT STRING,
  L_SHIPMODE STRING,
  L_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/tpch/100/lineitem';

CREATE EXTERNAL TABLE tpch_csv.part (
  P_PARTKEY INT,
  P_NAME STRING,
  P_MFGR STRING,
  P_BRAND STRING,
  P_TYPE STRING,
  P_SIZE INT,
  P_CONTAINER STRING,
  P_RETAILPRICE DOUBLE,
  P_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/tpch/100/part';

CREATE EXTERNAL TABLE tpch_csv.supplier (
  S_SUPPKEY INT,
  S_NAME STRING,
  S_ADDRESS STRING,
  S_NATIONKEY INT,
  S_PHONE STRING,
  S_ACCTBAL DOUBLE,
  S_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/tpch/100/supplier';

CREATE EXTERNAL TABLE tpch_csv.partsupp (
  PS_PARTKEY INT,
  PS_SUPPKEY INT,
  PS_AVAILQTY INT,
  PS_SUPPLYCOST DOUBLE,
  PS_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION'/tpch/100/partsupp';

CREATE EXTERNAL TABLE tpch_csv.nation (
  N_NATIONKEY INT,
  N_NAME STRING,
  N_REGIONKEY INT,
  N_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/tpch/100/nation';

CREATE EXTERNAL TABLE tpch_csv.region (
  R_REGIONKEY INT,
  R_NAME STRING,
  R_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/tpch/100/region';

CREATE EXTERNAL TABLE tpch_csv.customer (
  C_CUSTKEY INT,
  C_NAME STRING,
  C_ADDRESS STRING,
  C_NATIONKEY INT,
  C_PHONE STRING,
  C_ACCTBAL DOUBLE,
  C_MKTSEGMENT STRING,
  C_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/tpch/100/customer';

CREATE EXTERNAL TABLE tpch_csv.orders (
  O_ORDERKEY INT,
  O_CUSTKEY INT,
  O_ORDERSTATUS STRING,
  O_TOTALPRICE DOUBLE,
  O_ORDERDATE STRING,
  O_ORDERPRIORITY STRING,
  O_CLERK STRING,
  O_SHIPPRIORITY INT,
  O_COMMENT STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/tpch/100/orders';

-- create stats
USE tpch_csv;
ANALYZE TABLE lineitem COMPUTE STATISTICS;
ANALYZE TABLE lineitem COMPUTE STATISTICS FOR COLUMNS L_ORDERKEY, L_PARTKEY, L_SUPPKEY, L_LINENUMBER, L_QUANTITY, L_EXTENDEDPRICE, L_DISCOUNT, L_TAX, L_RETURNFLAG, L_LINESTATUS, L_SHIPDATE, L_COMMITDATE, L_RECEIPTDATE, L_SHIPINSTRUCT, L_SHIPMODE, L_COMMENT;
ANALYZE TABLE orders COMPUTE STATISTICS;
ANALYZE TABLE orders COMPUTE STATISTICS FOR COLUMNS O_ORDERKEY, O_CUSTKEY, O_ORDERSTATUS, O_TOTALPRICE, O_ORDERDATE, O_ORDERPRIORITY, O_CLERK, O_SHIPPRIORITY, O_COMMENT;
ANALYZE TABLE customer COMPUTE STATISTICS;
ANALYZE TABLE customer COMPUTE STATISTICS FOR COLUMNS C_CUSTKEY, C_NAME, C_ADDRESS, C_NATIONKEY, C_PHONE, C_ACCTBAL, C_MKTSEGMENT, C_COMMENT;
ANALYZE TABLE part COMPUTE STATISTICS;
ANALYZE TABLE part COMPUTE STATISTICS FOR COLUMNS P_PARTKEY, P_NAME, P_MFGR, P_BRAND, P_TYPE, P_SIZE, P_CONTAINER, P_RETAILPRICE, P_COMMENT;
ANALYZE TABLE partsupp COMPUTE STATISTICS;
ANALYZE TABLE partsupp COMPUTE STATISTICS FOR COLUMNS PS_PARTKEY, PS_SUPPKEY, PS_AVAILQTY, PS_SUPPLYCOST, PS_COMMENT;
ANALYZE TABLE supplier COMPUTE STATISTICS;
ANALYZE TABLE supplier COMPUTE STATISTICS FOR COLUMNS S_SUPPKEY, S_NAME, S_ADDRESS, S_NATIONKEY, S_PHONE, S_ACCTBAL, S_COMMENT;
ANALYZE TABLE nation COMPUTE STATISTICS;
ANALYZE TABLE nation COMPUTE STATISTICS FOR COLUMNS N_NATIONKEY, N_NAME, N_REGIONKEY, N_COMMENT;
ANALYZE TABLE region COMPUTE STATISTICS;
ANALYZE TABLE region COMPUTE STATISTICS FOR COLUMNS R_REGIONKEY, R_NAME, R_COMMENT;

