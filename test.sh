#!/bin/bash

tmp=`mktemp`

seq 1 10 > $tmp

./get_line 1 $tmp
./get_line 2 $tmp
./get_line 3 $tmp
./get_line 0 $tmp
./get_line 11 $tmp

rm -f $tmp
