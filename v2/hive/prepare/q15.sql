DROP TABLE IF EXISTS max_revenue;
DROP TABLE IF EXISTS q15_top_supplier;

-- create result tables
create table revenue(supplier_no int, total_revenue double); 
create table max_revenue(max_revenue double); 
create table q15_top_supplier(s_suppkey int, s_name string, s_address string, s_phone string, total_revenue double);
