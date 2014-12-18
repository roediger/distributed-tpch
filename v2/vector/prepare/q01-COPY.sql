COPY TABLE lineitem (
        l_orderkey = 'c0|',
        l_partkey = 'c0|',
        l_suppkey = 'c0|',
        l_linenumber = 'c0|',
        l_quantity = 'c0|',
        l_extendedprice = 'c0|',
        l_discount = 'c0|',
        l_tax = 'c0|',
        l_returnflag = 'c0|',
        l_linestatus = 'c0|',
        l_shipdate = 'c0|',
        l_commitdate = 'c0|',
        l_receiptdate = 'c0|',
        l_shipinstruct = 'c0|',
        l_shipmode = 'c0|',
        l_comment = 'c0nl'
) FROM 'lineitem.tbl';\g
