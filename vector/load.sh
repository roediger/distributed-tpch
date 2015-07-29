sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table region tpch /tpch/100/region.tbl"
sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table nation tpch /tpch/100/nation.tbl"
sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table part tpch /tpch/100/part.tbl"
sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table supplier tpch /tpch/100/supplier.tbl"
sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table partsupp tpch /tpch/100/partsupp.tbl"
sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table customer tpch /tpch/100/customer.tbl"
sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table orders tpch /tpch/100/orders.tbl"
sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/vwload -I -m --table lineitem tpch /tpch/100/lineitem.tbl"

