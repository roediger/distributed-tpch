DROP TABLE IF EXISTS q17_small_quantity_order_revenue;
DROP TABLE IF EXISTS lineitem_tmp;

-- create the result table
create table q17_small_quantity_order_revenue (avg_yearly double);
create table lineitem_tmp (t_partkey int, t_avg_quantity double);
