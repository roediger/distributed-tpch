set hive.optimize.ppd=true;
set hive.optimize.index.filter=true;

set hive.auto.convert.join = true;
set hive.auto.convert.join.noconditionaltask = true;
set hive.map.aggr=true;
--set hive.exec.reducers.max=22;
set mapred.reduce.tasks=120;
set hive.auto.convert.join.noconditionaltask.size = 200000000; 
set hive.mapjoin.smalltable.filesize = 200000000;
--set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
-- TPCH HIVE Q1

SELECT 
  L_RETURNFLAG, L_LINESTATUS, SUM(L_QUANTITY), SUM(L_EXTENDEDPRICE), SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)), SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX)), AVG(L_QUANTITY), AVG(L_EXTENDEDPRICE), AVG(L_DISCOUNT), COUNT(1) 
FROM 
  lineitem
WHERE 
  L_SHIPDATE<='1998-09-02' 
GROUP BY L_RETURNFLAG, L_LINESTATUS 
ORDER BY L_RETURNFLAG, L_LINESTATUS;
