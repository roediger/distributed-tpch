DROP TABLE IF EXISTS q16_parts_supplier_relationship;
DROP TABLE IF EXISTS q16_tmp;
DROP TABLE IF EXISTS supplier_tmp;

-- create the result table
create table q16_parts_supplier_relationship(p_brand string, p_type string, p_size int, supplier_cnt int);
create table q16_tmp(p_brand string, p_type string, p_size int, ps_suppkey int);
create table supplier_tmp(s_suppkey int);
