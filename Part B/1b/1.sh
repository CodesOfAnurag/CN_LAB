#!/bin/bash
for i in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8
do 
	echo -n $i" "
	ns 1.tcl $i
	sleep 0.2
done

