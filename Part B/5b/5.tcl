# ---- creating simulator ----
set ns [new Simulator]

# ---- setting up tracefiles ----
set tf [open 5.tr w]
$ns trace-all $tf
set nf [open 5.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    #exec awk -f 5.awk 5.tr &
    exec nam 5.nam &
    exit 0
}
    
# ---- Node Set-up ----
for {set i 0} {$i < 7} {incr i} {
    set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 1Mb 10ms DropTail
$ns simplex-link $n(2) $n(3) 0.3Mb 100ms DropTail
$ns simplex-link $n(3) $n(2) 0.3Mb 100ms DropTail
set lan [$ns newLan "$n(3) $n(4) $n(5) $n(6)" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

$ns duplex-link-op $n(0) $n(2) orient right-down
$ns duplex-link-op $n(1) $n(2) orient right-up
$ns simplex-link-op $n(2) $n(3) orient right
$ns simplex-link-op $n(3) $n(2) orient left
# ---- Node Set-up Done ----

# ---- Agent and Application set-up ----
$ns color 1 lightblue 
$ns color 2 lightgreen

# TCP with FTP
set TCPAgent [new Agent/TCP/Newreno]
$ns attach-agent $n(0) $TCPAgent
$TCPAgent set fid_ 1
$TCPAgent set packetSize_ 552

set ftp [new Application/FTP]
$ftp set type_ FTP
$ftp attach-agent $TCPAgent

set TCPSink [new Agent/TCPSink/DelAck]
$ns attach-agent $n(6) $TCPSink

$ns connect $TCPAgent $TCPSink

# UDP with CBR
set UDPAgent [new Agent/UDP]
$ns attach-agent $n(1) $UDPAgent
$UDPAgent set fid_ 2

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $UDPAgent
$cbr set type_ CBR
$cbr set packetSize 1000
$cbr set rate_ 0.05Mb
$cbr set random_ false

set UDPNull [new Agent/Null]
$ns attach-agent $n(6) $UDPNull

$ns connect $UDPAgent $UDPNull
# ---- Agent and Application set-up Done ----

# ---- Simulation ----
$ns at 0.0 "$n(0) label TCP"
$ns at 0.0 "$n(1) label UDP"
$ns at 0.3 "$cbr start"
$ns at 0.8 "$ftp start"
$ns at 7.5 "$ftp stop"
$ns at 7.5 "$cbr stop"
$ns at 8.0 "finish"
$ns run