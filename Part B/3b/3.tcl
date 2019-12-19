set ns [new Simulator]
$ns color 2 blue
$ns color 3 green

set tf [open 3.tr w]
$ns trace-all $tf
set nf [open 3.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $nf
    close $tf
    #exec awk -f 3.awk 3.tr &
    #exec nam 3.nam &
    exit 0
}

for {set i 0} {$i < 4} {incr i} {
    set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 900kb 10ms DropTail
$ns queue-limit $n(0) $n(2) 10

# ---- setting up UDP connection ----
set udp [new Agent/UDP]
$udp set fid_ 2
$ns attach-agent $n(0) $udp

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp

set null [new Agent/Null]
$ns attach-agent $n(3) $null

$ns connect $udp $null
# ---- UDP connection with CBR Traffic formed ----

# ---- setting up TCP connection ----
set tcp [new Agent/TCP]
$tcp set fid_ 3
$ns attach-agent $n(1) $tcp

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

set sink [new Agent/TCPSink]
$ns attach-agent $n(3) $sink

$ns connect $tcp $sink
# ---- TCP connection with FTP formed ----

$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr start"
$ns at 9.0 "$cbr stop"
$ns at 9.5 "$ftp stop"
$ns at 10.0 "finish"

$ns run