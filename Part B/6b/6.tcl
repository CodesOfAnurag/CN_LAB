set ns [new Simulator]
set error [lindex $argv 0]

set tf [open 6.tr w]
$ns trace-all $tf
set nf [open 6.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    exec awk -f 6.awk 6.tr &
    #exec nam 6.nam &
    exit 0
}

for {set i 0} {$i < 6} {incr i} {
    set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 1Mb 10ms DropTail
$ns simplex-link $n(2) $n(3) 0.3Mb 100ms DropTail
$ns simplex-link $n(3) $n(2) 0.3Mb 100ms DropTail

set lan [$ns newLan "$n(3) $n(4) $n(5)" 0.5Mb 40ms LL Queue/DropTail MAC/802_3 Channel]

$ns duplex-link-op $n(0) $n(2) orient right-down
$ns duplex-link-op $n(1) $n(2) orient right-up
$ns simplex-link-op $n(2) $n(3) orient right
$ns simplex-link-op $n(3) $n(2) orient left
$ns simplex-link-op $n(2) $n(3) queuePos 0.5

$ns queue-limit $n(2) $n(3) 20

set loss [new ErrorModel]
$loss ranvar [new RandomVariable/Uniform]
$loss drop-target [new Agent/Null]
$loss set rate_ $error
$ns lossmodel $loss $n(2) $n(3)

$ns color 1 lightblue
$ns color 2 lightgreen

set tcp [new Agent/TCP/Newreno]
$tcp set window_ 8000
$tcp set packetSize_ 552
$tcp set fid_ 1
$ns attach-agent $n(0) $tcp

set ftp [new Application/FTP]
$ftp set type_ FTP
$ftp attach-agent $tcp

set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n(5) $sink

$ns connect $tcp $sink

set udp [new Agent/UDP]
$udp set fid_ 2
$ns attach-agent $n(1) $udp

set cbr [new Application/Traffic/CBR]
$cbr set type_ CBR
$cbr set packetSize_ 1000
$cbr set rate_ 0.2Mb
$cbr set random_ false
$cbr attach-agent $udp

set null [new Agent/Null]
$ns attach-agent $n(5) $null

$ns connect $udp $null

$ns at 0.0 "$n(0) label TCP"
$ns at 0.0 "$n(1) label UDP"
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 124.0 "$ftp stop"
$ns at 124.5 "$cbr stop"
$ns at 125.0 "finish"
$ns run