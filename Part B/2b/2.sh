#!/bin/bash
for i in 100 200 300 400 500 600 700 800 900
do
    echo -n $i
    ns 2.tcl $i
    sleep 0.1
done