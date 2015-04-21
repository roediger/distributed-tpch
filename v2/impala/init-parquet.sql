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
LIKE default.lineitem 
STORED AS PARQUET;

CREATE TABLE tpch_parquet.part
LIKE default.part
STORED AS PARQUET;

CREATE TABLE tpch_parquet.supplier
LIKE default.supplier
STORED AS PARQUET;

CREATE TABLE tpch_parquet.partsupp
LIKE default.partsupp
STORED AS PARQUET;

CREATE TABLE tpch_parquet.nation
LIKE default.nation
STORED AS PARQUET;

CREATE TABLE tpch_parquet.region
LIKE default.region
STORED AS PARQUET;

CREATE TABLE tpch_parquet.customer
LIKE default.customer
STORED AS PARQUET;

CREATE TABLE tpch_parquet.orders 
LIKE default.orders
STORED AS PARQUET;

INSERT INTO tpch_parquet.lineitem 	SELECT * FROM default.lineitem;
INSERT INTO tpch_parquet.part 		SELECT * FROM default.part;
INSERT INTO tpch_parquet.supplier 	SELECT * FROM default.supplier;
INSERT INTO tpch_parquet.partsupp 	SELECT * FROM default.partsupp;
INSERT INTO tpch_parquet.nation 	SELECT * FROM default.nation;
INSERT INTO tpch_parquet.region 	SELECT * FROM default.region;
INSERT INTO tpch_parquet.customer 	SELECT * FROM default.customer;
INSERT INTO tpch_parquet.orders 	SELECT * FROM default.orders;

COMPUTE STATS tpch_parquet.lineitem;
COMPUTE STATS tpch_parquet.orders;
COMPUTE STATS tpch_parquet.customer;
COMPUTE STATS tpch_parquet.part;
COMPUTE STATS tpch_parquet.partsupp;
COMPUTE STATS tpch_parquet.supplier;
COMPUTE STATS tpch_parquet.nation;
COMPUTE STATS tpch_parquet.region;
