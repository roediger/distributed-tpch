DROP TABLE IF EXISTS nation;
DROP TABLE IF EXISTS region;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS partsupp;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS orders; 
DROP TABLE IF EXISTS lineitem;

CREATE TABLE nation  ( N_NATIONKEY  INTEGER NOT NULL,
                            N_NAME       CHAR(25) NOT NULL,
                            N_REGIONKEY  INTEGER NOT NULL,
                            N_COMMENT    VARCHAR(152),
							primary key(N_NATIONKEY)
						)
						WITH PARTITION=(HASH ON N_NATIONKEY 20 PARTITIONS);

CREATE TABLE region  ( R_REGIONKEY  INTEGER NOT NULL,
                            R_NAME       CHAR(25) NOT NULL,
                            R_COMMENT    VARCHAR(152),
						 primary key (r_regionkey))
						 WITH PARTITION=(HASH ON R_REGIONKEY 20 PARTITIONS);

CREATE TABLE part  ( P_PARTKEY     INTEGER NOT NULL,
                          P_NAME        VARCHAR(55) NOT NULL,
                          P_MFGR        CHAR(25) NOT NULL,
                          P_BRAND       CHAR(10) NOT NULL,
                          P_TYPE        VARCHAR(25) NOT NULL,
                          P_SIZE        INTEGER NOT NULL,
                          P_CONTAINER   CHAR(10) NOT NULL,
                          P_RETAILPRICE DECIMAL(15,2) NOT NULL,
                          P_COMMENT     VARCHAR(23) NOT NULL,
					       primary key (p_partkey) )
						   WITH PARTITION=(HASH ON p_partkey 20 PARTITIONS);

CREATE TABLE supplier  ( S_SUPPKEY     INTEGER NOT NULL,
                             S_NAME        CHAR(25) NOT NULL,
                             S_ADDRESS     VARCHAR(40) NOT NULL,
                             S_NATIONKEY   INTEGER NOT NULL,
                             S_PHONE       CHAR(15) NOT NULL,
                             S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                             S_COMMENT     VARCHAR(101) NOT NULL,
							 primary key (s_suppkey)
						 )
						 WITH PARTITION=(HASH ON s_suppkey 20 PARTITIONS);

CREATE TABLE partsupp  ( PS_PARTKEY     INTEGER NOT NULL,
                             PS_SUPPKEY     INTEGER NOT NULL,
                             PS_AVAILQTY    INTEGER NOT NULL,
                             PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
                             PS_COMMENT     VARCHAR(199) NOT NULL,
						  primary key (ps_partkey, ps_suppkey)
					   )
					   WITH PARTITION=(HASH ON ps_partkey, ps_suppkey 20 PARTITIONS);

CREATE TABLE customer  ( C_CUSTKEY     INTEGER NOT NULL,
                             C_NAME        VARCHAR(25) NOT NULL,
                             C_ADDRESS     VARCHAR(40) NOT NULL,
                             C_NATIONKEY   INTEGER NOT NULL,
                             C_PHONE       CHAR(15) NOT NULL,
                             C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                             C_MKTSEGMENT  CHAR(10) NOT NULL,
                             C_COMMENT     VARCHAR(117) NOT NULL,
						 primary key (c_custkey))
						 WITH PARTITION=(HASH ON c_custkey 20 PARTITIONS);

CREATE TABLE orders  ( O_ORDERKEY       INTEGER NOT NULL,
                           O_CUSTKEY        INTEGER NOT NULL,
                           O_ORDERSTATUS    CHAR(1) NOT NULL,
                           O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                           O_ORDERDATE      DATE NOT NULL,
                           O_ORDERPRIORITY  CHAR(15) NOT NULL,  
                           O_CLERK          CHAR(15) NOT NULL, 
                           O_SHIPPRIORITY   INTEGER NOT NULL,
                           O_COMMENT        VARCHAR(79) NOT NULL,
					   primary key (o_orderkey))
					   WITH PARTITION=(HASH ON O_ORDERKEY 20 PARTITIONS);

CREATE TABLE lineitem ( L_ORDERKEY    INTEGER NOT NULL,
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
						  primary key (l_orderkey,l_linenumber))
						  WITH PARTITION=(HASH ON l_orderkey,l_linenumber 20 PARTITIONS);
							 
-- Copy Data

COPY TABLE lineitem (
        l_orderkey = 'c0|',
        l_partkey = 'c0|',
        l_suppkey = 'c0|',
        l_linenumber = 'c0|',
        l_quantity = 'c0|',
        l_extendedprice = 'c0|',
        l_discount = 'c0|',
        l_tax = 'c0|',
        l_returnflag = 'c0|',
        l_linestatus = 'c0|',
        l_shipdate = 'c0|',
        l_commitdate = 'c0|',
        l_receiptdate = 'c0|',
        l_shipinstruct = 'c0|',
        l_shipmode = 'c0|',
        l_comment = 'c0nl'
) FROM '/space/tpch/100/lineitem.tbl';

COPY TABLE nation (
        N_NATIONKEY = 'c0|',
        N_NAME = 'c0|',
        N_REGIONKEY = 'c0|',
        N_COMMENT = 'c0nl'
) FROM '/space/tpch/100/nation.tbl';

COPY TABLE region (
        R_REGIONKEY = 'c0|',
        R_NAME = 'c0|',
        R_COMMENT = 'c0nl'
) FROM '/space/tpch/100/region.tbl';

COPY TABLE part (
        P_PARTKEY = 'c0|',
        P_NAME = 'c0|',
        P_MFGR = 'c0|',
        P_BRAND = 'c0|',
        P_TYPE = 'c0|',
        P_SIZE = 'c0|',
        P_CONTAINER = 'c0|',
        P_RETAILPRICE = 'c0|',
        P_COMMENT = 'c0nl'
) FROM '/space/tpch/100/part.tbl';

COPY TABLE supplier (
        S_SUPPKEY = 'c0|',
        S_NAME = 'c0|',
        S_ADDRESS = 'c0|',
        S_NATIONKEY = 'c0|',
        S_PHONE = 'c0|',
        S_ACCTBAL = 'c0|',
        S_COMMENT = 'c0nl'
) FROM '/space/tpch/100/supplier.tbl';

COPY TABLE partsupp (
        PS_PARTKEY = 'c0|',
        PS_SUPPKEY = 'c0|',
        PS_AVAILQTY = 'c0|',
        PS_SUPPLYCOST = 'c0|',
        PS_COMMENT = 'c0nl'
) FROM '/space/tpch/100/partsupp.tbl';

COPY TABLE customer (
        C_CUSTKEY = 'c0|',
        C_NAME = 'c0|',
        C_ADDRESS = 'c0|',
        C_NATIONKEY = 'c0|',
        C_PHONE = 'c0|',
        C_ACCTBAL = 'c0|',
        C_MKTSEGMENT = 'c0|',
        C_COMMENT = 'c0nl'
) FROM '/space/tpch/100/customer.tbl';

COPY TABLE orders (
        O_ORDERKEY = 'c0|',
        O_CUSTKEY = 'c0|',
        O_ORDERSTATUS = 'c0|',
        O_TOTALPRICE = 'c0|',
        O_ORDERDATE = 'c0|',
        O_ORDERPRIORITY = 'c0|',
        O_CLERK = 'c0|',
        O_SHIPPRIORITY = 'c0|',
        O_COMMENT = 'c0nl'
) FROM '/space/tpch/100/orders.tbl';\g


