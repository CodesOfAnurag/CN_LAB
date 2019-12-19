set ns [new Simulator]

# Decoration --- optional
$ns color 1 red
$ns color 2 blue
$ns color 3 green
$ns color 4 cyan
$ns color 5 magenta
$ns color 6 yellow

# Setting up tracefiles
set tf [open 4.tr w]
$ns trace-all $tf
set nf [open 4.nam w]
$ns namtrace-all $nf

# finish Procedure
proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $nf
    close $tf
    exec awk -f 4.awk 4.tr &
    exec nam 4.nam &
    exit 0
}

# Node creation 
for {set i 0} {$i < 7} {incr i} {
    set n($i) [$ns node]
}

for {set i 1} {$i < 4} {incr i} {
    $ns duplex-link $n(0) $n($i) 1Mb 10ms DropTail
}
$ns duplex-link $n(0) $n(4) 1Mb 100ms DropTail
$ns duplex-link $n(0) $n(5) 1Mb 100ms DropTail
$ns duplex-link $n(0) $n(6) 1Mb 90ms DropTail

for {set i 1} {$i < 6} {incr i} {
    $ns queue-limit $n(0) $n($i) 2
}
$ns queue-limit $n(0) $n(6) 1

Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "node [$node_ id] received ping-answer from $from in rtt of $rtt ms"
}

for {set i 1} {$i < 7} {incr i} {
    set pingAgent($i) [new Agent/Ping]
    $ns attach-agent $n($i) $pingAgent($i)
    # Decoration --- optional
    $pingAgent($i) set fid_ $i
}

$ns connect $pingAgent(1) $pingAgent(4)
$ns connect $pingAgent(2) $pingAgent(5)
$ns connect $pingAgent(3) $pingAgent(6)

# Simulation
$ns at 0.1 "$pingAgent(1) send"
$ns at 0.5 "$pingAgent(2) send"
$ns at 0.5 "$pingAgent(3) send"
$ns at 0.5 "$pingAgent(4) send"
$ns at 1.0 "$pingAgent(5) send"
$ns at 1.0 "$pingAgent(6) send"
$ns at 1.1 "$pingAgent(1) send"
$ns at 1.5 "$pingAgent(2) send"
$ns at 1.5 "$pingAgent(3) send"
$ns at 1.5 "$pingAgent(4) send"
$ns at 2.0 "$pingAgent(5) send"
$ns at 2.0 "$pingAgent(6) send"
$ns at 3.0 "finish"
$ns run