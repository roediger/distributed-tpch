DROP TABLE IF EXISTS q4_order_priority_tmp;
DROP TABLE IF EXISTS q4_order_priority;

-- create the target table
CREATE TABLE q4_order_priority_tmp (O_ORDERKEY INT);
CREATE TABLE q4_order_priority (O_ORDERPRIORITY STRING, ORDER_COUNT INT);
