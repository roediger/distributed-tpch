mysqlimport --compress --use-threads=40 -u root -h 127.0.0.1 -P 3306 -L tpch --fields-terminated-by="|" --lines-terminated-by="|\n" *.tbl

