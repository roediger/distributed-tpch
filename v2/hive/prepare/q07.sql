DROP TABLE IF EXISTS q7_volume_shipping;
DROP TABLE IF EXISTS q7_volume_shipping_tmp;

-- create the target table
create table q7_volume_shipping (supp_nation string, cust_nation string, l_year int, revenue double);
create table q7_volume_shipping_tmp(supp_nation string, cust_nation string, s_nationkey int, c_nationkey int);
