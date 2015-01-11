DROP TABLE IF EXISTS q11_important_stock;
DROP TABLE IF EXISTS q11_part_tmp;
DROP TABLE IF EXISTS q11_sum_tmp;

-- create the target table
create table q11_important_stock(ps_partkey INT, value DOUBLE);
create table q11_part_tmp(ps_partkey int, part_value double);
create table q11_sum_tmp(total_value double);

