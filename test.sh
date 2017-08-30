#!/bin/bash

tmp=`mktemp`

seq 1 10 > $tmp

set -x

./get_line -r 1 -i $tmp
./get_line -r 2 -i $tmp
./get_line -r 3 -i $tmp
./get_line -r 2..5 -i $tmp
./get_line -r 0 -i $tmp
./get_line -r 11 -i $tmp
./get_line -r 10..12 -i $tmp
./get_line -r 12..15 -i $tmp

./get_line -r 1 -i $tmp -v
./get_line -r 2 -i $tmp -v
./get_line -r 3 -i $tmp -v
./get_line -r 2..5 -i $tmp -v

./get_line -r +3 -i $tmp
./get_line -r -3 -i $tmp

./get_line -r +10 -i $tmp --rand

./get_line -r 1,5,10 -i $tmp

set +x

rm -f $tmp
