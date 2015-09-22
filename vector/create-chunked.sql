DROP TABLE IF EXISTS lineitem;
DROP TABLE IF EXISTS orders; 
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS partsupp;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS nation;
DROP TABLE IF EXISTS region;

CREATE TABLE region (
 R_REGIONKEY  INTEGER NOT NULL,
 R_NAME       CHAR(25) NOT NULL,
 R_COMMENT    VARCHAR(152),
 PRIMARY KEY (R_REGIONKEY)
);

CREATE TABLE nation (
 N_NATIONKEY  INTEGER NOT NULL,
 N_NAME       CHAR(25) NOT NULL,
 N_REGIONKEY  INTEGER NOT NULL,
 N_COMMENT    VARCHAR(152),
 FOREIGN KEY (N_REGIONKEY) REFERENCES region(R_REGIONKEY),
 PRIMARY KEY (N_NATIONKEY)
);

CREATE TABLE part (
 P_ID          INTEGER NOT NULL GENERATED BY DEFAULT AS partid IDENTITY,
 P_PARTKEY     INTEGER NOT NULL,
 P_NAME        VARCHAR(55) NOT NULL,
 P_MFGR        CHAR(25) NOT NULL,
 P_BRAND       CHAR(10) NOT NULL,
 P_TYPE        VARCHAR(25) NOT NULL,
 P_SIZE        INTEGER NOT NULL,
 P_CONTAINER   CHAR(10) NOT NULL,
 P_RETAILPRICE DECIMAL(15,2) NOT NULL,
 P_COMMENT     VARCHAR(23) NOT NULL,
 PRIMARY KEY (P_PARTKEY)
) WITH PARTITION=(HASH ON P_ID 24 PARTITIONS);

CREATE TABLE supplier (
 S_ID          INTEGER NOT NULL GENERATED BY DEFAULT AS supplierid IDENTITY,
 S_SUPPKEY     INTEGER NOT NULL,
 S_NAME        CHAR(25) NOT NULL,
 S_ADDRESS     VARCHAR(40) NOT NULL,
 S_NATIONKEY   INTEGER NOT NULL,
 S_PHONE       CHAR(15) NOT NULL,
 S_ACCTBAL     DECIMAL(15,2) NOT NULL,
 S_COMMENT     VARCHAR(101) NOT NULL,
 FOREIGN KEY (S_NATIONKEY) REFERENCES nation(N_NATIONKEY),
 PRIMARY KEY (S_SUPPKEY)
) WITH PARTITION=(HASH ON S_ID 24 PARTITIONS);

CREATE TABLE partsupp (
 PS_ID          INTEGER NOT NULL GENERATED BY DEFAULT AS partsuppid IDENTITY,
 PS_PARTKEY     INTEGER NOT NULL,
 PS_SUPPKEY     INTEGER NOT NULL,
 PS_AVAILQTY    INTEGER NOT NULL,
 PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
 PS_COMMENT     VARCHAR(199) NOT NULL,
 FOREIGN KEY (PS_PARTKEY) REFERENCES part(P_PARTKEY),
 FOREIGN KEY (PS_SUPPKEY) REFERENCES supplier(S_SUPPKEY),
 PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY)
) WITH PARTITION=(HASH ON PS_ID 24 PARTITIONS);

CREATE TABLE customer (
 C_ID          INTEGER NOT NULL GENERATED BY DEFAULT AS customerid IDENTITY,
 C_CUSTKEY     INTEGER NOT NULL,
 C_NAME        VARCHAR(25) NOT NULL,
 C_ADDRESS     VARCHAR(40) NOT NULL,
 C_NATIONKEY   INTEGER NOT NULL,
 C_PHONE       CHAR(15) NOT NULL,
 C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
 C_MKTSEGMENT  CHAR(10) NOT NULL,
 C_COMMENT     VARCHAR(117) NOT NULL,
 FOREIGN KEY (C_NATIONKEY) REFERENCES nation(N_NATIONKEY),
 PRIMARY KEY (C_CUSTKEY)
) WITH PARTITION=(HASH ON C_ID 24 PARTITIONS);

CREATE TABLE orders (
 O_ID             INTEGER NOT NULL GENERATED BY DEFAULT AS ordersid IDENTITY,
 O_ORDERKEY       INTEGER NOT NULL,
 O_CUSTKEY        INTEGER NOT NULL,
 O_ORDERSTATUS    CHAR(1) NOT NULL,
 O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
 O_ORDERDATE      DATE NOT NULL,
 O_ORDERPRIORITY  CHAR(15) NOT NULL,  
 O_CLERK          CHAR(15) NOT NULL, 
 O_SHIPPRIORITY   INTEGER NOT NULL,
 O_COMMENT        VARCHAR(79) NOT NULL,
 FOREIGN KEY (O_CUSTKEY) REFERENCES customer(C_CUSTKEY),
 PRIMARY KEY (O_ORDERKEY)
) WITH PARTITION=(HASH ON O_ID 24 PARTITIONS);

CREATE TABLE lineitem (
 L_ID          INTEGER NOT NULL GENERATED BY DEFAULT AS lineitemid IDENTITY,
 L_ORDERKEY    INTEGER NOT NULL,
 L_PARTKEY     INTEGER NOT NULL,
 L_SUPPKEY     INTEGER NOT NULL,
 L_LINENUMBER  INTEGER NOT NULL,
 L_QUANTITY    DECIMAL(15,2) NOT NULL,
 L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
 L_DISCOUNT    DECIMAL(15,2) NOT NULL,
 L_TAX         DECIMAL(15,2) NOT NULL,
 L_RETURNFLAG  CHAR(1) NOT NULL,
 L_LINESTATUS  CHAR(1) NOT NULL,
 L_SHIPDATE    DATE NOT NULL,
 L_COMMITDATE  DATE NOT NULL,
 L_RECEIPTDATE DATE NOT NULL,
 L_SHIPINSTRUCT CHAR(25) NOT NULL,
 L_SHIPMODE     CHAR(10) NOT NULL,
 L_COMMENT      VARCHAR(44) NOT NULL,
 FOREIGN KEY (L_ORDERKEY) REFERENCES orders(O_ORDERKEY),
 FOREIGN KEY (L_PARTKEY) REFERENCES part(P_PARTKEY),
 FOREIGN KEY (L_SUPPKEY) REFERENCES supplier(S_SUPPKEY),
 FOREIGN KEY (L_PARTKEY,L_SUPPKEY) REFERENCES partsupp(PS_PARTKEY,PS_SUPPKEY),
 PRIMARY KEY (L_ORDERKEY,L_LINENUMBER)
) WITH PARTITION=(HASH ON L_ID 24 PARTITIONS);

CREATE INDEX lineitem_index ON lineitem(L_ORDERKEY);
CREATE INDEX orders_index ON orders(O_ORDERDATE);
CREATE INDEX part_index ON part(P_PARTKEY);
CREATE INDEX partsupp_index ON partsupp(PS_PARTKEY);
CREATE INDEX region_index ON region(R_REGIONKEY);
CREATE INDEX nation_index ON nation(N_REGIONKEY);
CREATE INDEX customer_index ON customer(C_NATIONKEY);
CREATE INDEX supplier_index ON supplier(S_NATIONKEY);

\g
