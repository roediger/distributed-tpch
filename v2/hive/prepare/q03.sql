DROP TABLE IF EXISTS q3_shipping_priority;

-- create the target table
create table q3_shipping_priority (l_orderkey int, revenue double, o_orderdate string, o_shippriority int);
