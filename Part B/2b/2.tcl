set ns [new Simulator]

$ns color 2 red
$ns color 3 blue


set tf [open 2.tr w]
$ns trace-all $tf
set nf [open 2.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    exec awk -f 2.awk 2.tr &
    #exec nam 2.nam &
    exit 0
}

for {set i 0} {$i < 4} {incr i} {
    set n($i) [$ns node]
}

# lindex $argv 0 is used for system arguments - makes it easier for plotting
$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) [lindex $argv 0]kb 10ms DropTail
$ns queue-limit $n(0) $n(2) 10



set tcp0 [new Agent/TCP]
$tcp0 set fid_ 2
$ns attach-agent $n(0) $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink0
$ns connect $tcp0 $sink0

set telnet [new Application/Telnet]
$telnet set interval_ 0
$telnet set fid_ 2
$telnet attach-agent $tcp0

set tcp1 [new Agent/TCP]
$tcp1 set fid_ 3
$ns attach-agent $n(1) $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink1
$ns connect $tcp1 $sink1

set ftp [new Application/FTP]
$ftp set type_ FTP
$ftp attach-agent $tcp1

$ns at 0.5 "$telnet start"
$ns at 0.6 "$ftp start"
$ns at 24.5 "$ftp stop"
$ns at 24.5 "$telnet stop"
$ns at 25.0 "finish"

$ns run 