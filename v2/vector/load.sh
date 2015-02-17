source ~actian/.ingAHsh

/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table region dbtest /space/tpch/100/region.tbl
/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table nation dbtest /space/tpch/100/nation.tbl
/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table part dbtest /space/tpch/100/part.tbl
/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table supplier dbtest /space/tpch/100/supplier.tbl
/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table partsupp dbtest /space/tpch/100/partsupp.tbl
/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table customer dbtest /space/tpch/100/customer.tbl
/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table orders dbtest /space/tpch/100/orders.tbl
/opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table lineitem dbtest /space/tpch/100/lineitem.tbl
