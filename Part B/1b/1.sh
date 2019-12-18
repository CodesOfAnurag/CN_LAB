#!/bin/bash

for i in 1 2 3 4 5 6 7 8 9
do
    echo -n "0."$i
    ns 1.tcl 0.$i
    sleep 0.1
done