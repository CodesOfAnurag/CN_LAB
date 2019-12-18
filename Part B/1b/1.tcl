set ns [new Simulator]
$ns rtproto Static
$ns color 2 green

set tf [open 1.tr w]
$ns trace-all $tf
set nf [open 1.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    exec awk -f 1.awk 1.tr &
    #exec nam 1.nam &
    exit 0
}

for {set i 1} {$i < 4} {incr i} {
    set n($i) [$ns node]
}

# lindex $argv 0 is used for system arguments - makes it easier for plotting
$ns duplex-link $n(1) $n(2) [lindex $argv 0]Mb 20ms DropTail
$ns duplex-link $n(2) $n(3) [lindex $argv 0]Mb 20ms DropTail
$ns queue-limit $n(1) $n(2) 10
$ns queue-limit $n(2) $n(3) 10

# decoration command -> not required 
# ---- decoration ----
$n(1) shape square
$n(1) color orange

$n(2) shape circle
$n(2) color lightblue

$n(3) shape hexagon
$n(3) color blue
# ---- decoration ----

set udp [new Agent/UDP]
$udp set fid_ 2
$ns attach-agent $n(1) $udp

set null [new Agent/Null]
$ns attach-agent $n(3) $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512
$cbr set interval_ 0.005
$cbr attach-agent $udp

$ns at 0.5 "$cbr start"
$ns at 2.0 "$cbr stop"
$ns at 2.0 "finish"

$ns run 
