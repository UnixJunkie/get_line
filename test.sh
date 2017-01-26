#!/bin/bash

tmp=`mktemp`

seq 1 10 > $tmp

set -x

./get_line 1 $tmp
./get_line 2 $tmp
./get_line 3 $tmp
./get_line 2-5 $tmp
./get_line 0 $tmp
./get_line 11 $tmp
./get_line 10-12 $tmp
./get_line 12-15 $tmp

set +x

rm -f $tmp
