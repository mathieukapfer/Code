#!/bin/sh
datasizes="10 20 50 100 200 500 1000 2000 5000 10000 20000"
#datasizes="10 20 50 100 110 120 130 140 150 160 170 180 190 200"

#make clean
for datasize in $datasizes; do
    echo "*** datasize:$datasize;  "
    CFLAGS="-DVECTOR_SIZE=$datasize " make hello_mppa2 run-iss
done
