CREATE SCHEMA IF NOT EXISTS tpch_parquet;

DROP TABLE IF EXISTS tpch_parquet.lineitem;
DROP TABLE IF EXISTS tpch_parquet.part;
DROP TABLE IF EXISTS tpch_parquet.supplier;
DROP TABLE IF EXISTS tpch_parquet.partsupp;
DROP TABLE IF EXISTS tpch_parquet.nation;
DROP TABLE IF EXISTS tpch_parquet.region;
DROP TABLE IF EXISTS tpch_parquet.customer;
DROP TABLE IF EXISTS tpch_parquet.orders;

CREATE TABLE tpch_parquet.lineitem
LIKE tpch_csv.lineitem 
STORED AS PARQUET;

CREATE TABLE tpch_parquet.part
LIKE tpch_csv.part
STORED AS PARQUET;

CREATE TABLE tpch_parquet.supplier
LIKE tpch_csv.supplier
STORED AS PARQUET;

CREATE TABLE tpch_parquet.partsupp
LIKE tpch_csv.partsupp
STORED AS PARQUET;

CREATE TABLE tpch_parquet.nation
LIKE tpch_csv.nation
STORED AS PARQUET;

CREATE TABLE tpch_parquet.region
LIKE tpch_csv.region
STORED AS PARQUET;

CREATE TABLE tpch_parquet.customer
LIKE tpch_csv.customer
STORED AS PARQUET;

CREATE TABLE tpch_parquet.orders 
LIKE tpch_csv.orders
STORED AS PARQUET;

INSERT INTO tpch_parquet.lineitem SELECT * FROM tpch_csv.lineitem;
INSERT INTO tpch_parquet.part     SELECT * FROM tpch_csv.part;
INSERT INTO tpch_parquet.supplier SELECT * FROM tpch_csv.supplier;
INSERT INTO tpch_parquet.partsupp SELECT * FROM tpch_csv.partsupp;
INSERT INTO tpch_parquet.nation   SELECT * FROM tpch_csv.nation;
INSERT INTO tpch_parquet.region   SELECT * FROM tpch_csv.region;
INSERT INTO tpch_parquet.customer SELECT * FROM tpch_csv.customer;
INSERT INTO tpch_parquet.orders   SELECT * FROM tpch_csv.orders;

COMPUTE STATS tpch_parquet.lineitem;
COMPUTE STATS tpch_parquet.orders;
COMPUTE STATS tpch_parquet.customer;
COMPUTE STATS tpch_parquet.part;
COMPUTE STATS tpch_parquet.partsupp;
COMPUTE STATS tpch_parquet.supplier;
COMPUTE STATS tpch_parquet.nation;
COMPUTE STATS tpch_parquet.region;
