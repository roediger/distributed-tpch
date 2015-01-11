DROP TABLE IF EXISTS q20_tmp1;
DROP TABLE IF EXISTS q20_tmp2;
DROP TABLE IF EXISTS q20_tmp3;
DROP TABLE IF EXISTS q20_tmp4;
DROP TABLE IF EXISTS q20_potential_part_promotion;

-- create the target table
create table q20_tmp1(p_partkey int);
create table q20_tmp2(l_partkey int, l_suppkey int, sum_quantity double);
create table q20_tmp3(ps_suppkey int, ps_availqty int, sum_quantity double);
create table q20_tmp4(ps_suppkey int);
create table q20_potential_part_promotion(s_name string, s_address string);
