#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "$0 create|drop SCHEMA"
	exit 1
fi

if [ "$1" = "create" ]; then
	echo "Creating Cache for schema $2"
	
	sudo -u impala hdfs cacheadmin -addPool $2_pool -mode 0777 -limit 350000000000
	sleep 10
	
	impala-shell -q "ALTER TABLE $2.lineitem set cached in '$2_pool';"
	impala-shell -q "ALTER TABLE $2.orders set cached in '$2_pool';"
	impala-shell -q "ALTER TABLE $2.customer set cached in '$2_pool';"
	impala-shell -q "ALTER TABLE $2.part set cached in '$2_pool';"
	impala-shell -q "ALTER TABLE $2.partsupp set cached in '$2_pool';"
	impala-shell -q "ALTER TABLE $2.supplier set cached in '$2_pool';"
	impala-shell -q "ALTER TABLE $2.nation set cached in '$2_pool';"
	impala-shell -q "ALTER TABLE $2.region set cached in '$2_pool';"
	
else
	echo "Dropping Cache for schema $2"
	
	impala-shell -q "ALTER TABLE $2.lineitem set uncached;"
	impala-shell -q "ALTER TABLE $2.orders set uncached;"
	impala-shell -q "ALTER TABLE $2.customer set uncached;"
	impala-shell -q "ALTER TABLE $2.part set uncached;"
	impala-shell -q "ALTER TABLE $2.partsupp set uncached;"
	impala-shell -q "ALTER TABLE $2.supplier set uncached;"
	impala-shell -q "ALTER TABLE $2.nation set uncached;"
	impala-shell -q "ALTER TABLE $2.region set uncached;"
	
	hdfs cacheadmin -removePool $2_pool
fi

impala-shell -q "COMPUTE STATS $2.lineitem;"
impala-shell -q "COMPUTE STATS $2.customer;"
impala-shell -q "COMPUTE STATS $2.part;"
impala-shell -q "COMPUTE STATS $2.partsupp;"
impala-shell -q "COMPUTE STATS $2.supplier;"
impala-shell -q "COMPUTE STATS $2.nation;"
impala-shell -q "COMPUTE STATS $2.region;"
impala-shell -q "COMPUTE STATS $2.orders;"