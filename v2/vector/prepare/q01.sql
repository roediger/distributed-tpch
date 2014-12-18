CREATE TABLE lineitem 
(
	l_orderkey INTEGER NOT NULL,
	l_partkey INTEGER NOT NULL,
	l_suppkey INTEGER NOT NULL,
	l_linenumber INTEGER NOT NULL,
	l_quantity DECIMAL(2,0) NOT NULL,
	l_extendedprice DECIMAL(8,2) NOT NULL,
	l_discount DECIMAL(2,2) NOT NULL,
	l_tax DECIMAL(2,2) NOT NULL,
	l_returnflag CHAR(1) NOT NULL,
	l_linestatus CHAR(1) NOT NULL,
	l_shipdate ANSIDATE NOT NULL,
	l_commitdate ANSIDATE NOT NULL,
	l_receiptdate ANSIDATE NOT NULL,
	l_shipinstruct CHAR(25) NOT NULL,
	l_shipmode CHAR(10) NOT NULL,
	l_comment VARCHAR(44) NOT NULL
)\g
