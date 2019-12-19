#!/bin/bash
ns 3.tcl
nam 3.nam
awk -f 3.awk 3.tr
rm TCP.xg
rm UDP.xg
awk -f 3graph.awk 3.tr